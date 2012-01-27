require 'base64'

module Parse

  # Pointer
  # ------------------------------------------------------------

  class Pointer
    attr_accessor :parse_object_id
    attr_accessor :class_name

    def initialize(data)
      @class_name       = data[Protocol::KEY_CLASS_NAME]
      @parse_object_id  = data[Protocol::KEY_OBJECT_ID]
    end

    def to_json(*a)
      {
          Protocol::KEY_TYPE        => Protocol::TYPE_POINTER,
          Protocol::KEY_CLASS_NAME  => @class_name,
          Protocol::KEY_OBJECT_ID   => @parse_object_id
      }.to_json(*a)
    end

    # Retrieve the Parse object referenced by this pointer.
    def get
      Parse.get @class_name, @parse_object_id
    end
  end

  # Date
  # ------------------------------------------------------------

  class Date
    attr_accessor :value

    def initialize(data)
      if data.is_a? DateTime
        @value = data
      elsif data.is_a? Hash
        @value = DateTime.parse data["iso"]
      elsif data.is_a? String
        @value = DateTime.parse data
      end
    end

    def to_json(*a)
      {
          Protocol::KEY_TYPE => Protocol::TYPE_DATE,
          "iso"              => value.iso8601
      }.to_json(*a)
    end
  end

  # Bytes
  # ------------------------------------------------------------

  class Bytes
    attr_accessor :value

    def initialize(data)
      bytes = data["base64"]
      value = Base64.decode(bytes)
    end

    def to_json(*a)
      {
          Protocol::KEY_TYPE => Protocol::TYPE_BYTES,
          "base64" => Base64.encode(@value)
      }.to_json(*a)
    end
  end

end