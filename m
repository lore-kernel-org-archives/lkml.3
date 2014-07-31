Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaGaP4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:56:53 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57558 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaGaP4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:56:51 -0400
MIME-Version: 1.0
In-Reply-To: <1406674412.24026.1.camel@fedora-lan>
References: <1406659385-3256-1-git-send-email-benjamin.tissoires@redhat.com>
	<1406659385-3256-5-git-send-email-benjamin.tissoires@redhat.com>
	<1406674412.24026.1.camel@fedora-lan>
Date: Thu, 31 Jul 2014 08:56:49 -0700
Message-ID: <CAF8JNhK1R3mzfJA2OZwZv3-KwqpFBkOjDmzM1JkZW_Wix+Ww8g@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] Input - wacom: Check for bluetooth protocol while
 setting OLEDs
From: Ping Cheng <pinglinux@gmail.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jason Gerecke <killertofu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 3:53 PM, Przemo Firszt <przemo@firszt.eu> wrote:
> Dnia 2014-07-29, wto o godzinie 14:43 -0400, Benjamin Tissoires pisze:
>> Bluetooth Intuos 4 use 1-bit definition while the USB ones use a 4-bits
>> definition. This changes the size of the raw image we receive, and thus
>> the kernel will only accept 1-bit images for Bluetooth and 4-bits for
>> USB.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  drivers/hid/wacom_sys.c | 29 +++++++++++++++++++++--------
>>  1 file changed, 21 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
>> index f5c9c56..a12cd9c 100644
>> --- a/drivers/hid/wacom_sys.c
>> +++ b/drivers/hid/wacom_sys.c
>> @@ -20,6 +20,7 @@
>>  #define WAC_CMD_LED_CONTROL  0x20
>>  #define WAC_CMD_ICON_START   0x21
>>  #define WAC_CMD_ICON_XFER    0x23
>> +#define WAC_CMD_ICON_BT_XFER 0x26
>>  #define WAC_CMD_RETRIES              10
>>
>>  static int wacom_get_report(struct hid_device *hdev, u8 type, u8 id,
>> @@ -526,12 +527,14 @@ static int wacom_led_control(struct wacom *wacom)
>>       return retval;
>>  }
>>
>> -static int wacom_led_putimage(struct wacom *wacom, int button_id, const void *img)
>> +static int wacom_led_putimage(struct wacom *wacom, int button_id, u8 xfer_id,
>> +             const unsigned len, const void *img)
>>  {
>>       unsigned char *buf;
>>       int i, retval;
>> +     const unsigned chunk_len = len / 4; /* 4 chunks are needed to be sent */
>>
>> -     buf = kzalloc(259, GFP_KERNEL);
>> +     buf = kzalloc(chunk_len + 3 , GFP_KERNEL);
>>       if (!buf)
>>               return -ENOMEM;
>>
>> @@ -543,15 +546,15 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id, const void *im
>>       if (retval < 0)
>>               goto out;
>>
>> -     buf[0] = WAC_CMD_ICON_XFER;
>> +     buf[0] = xfer_id;
>>       buf[1] = button_id & 0x07;
>>       for (i = 0; i < 4; i++) {
>>               buf[2] = i;
>> -             memcpy(buf + 3, img + i * 256, 256);
>> +             memcpy(buf + 3, img + i * chunk_len, chunk_len);
>>
>>               retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
>> -                                       WAC_CMD_ICON_XFER,
>> -                                       buf, 259, WAC_CMD_RETRIES);
>> +                                       xfer_id, buf, chunk_len + 3,
>> +                                       WAC_CMD_RETRIES);
>>               if (retval < 0)
>>                       break;
>>       }
>> @@ -652,13 +655,23 @@ static ssize_t wacom_button_image_store(struct device *dev, int button_id,
>>       struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>>       struct wacom *wacom = hid_get_drvdata(hdev);
>>       int err;
>> +     unsigned len;
>> +     u8 xfer_id;
>>
>> -     if (count != 1024)
>> +     if (hdev->bus == BUS_BLUETOOTH) {
>> +             len = 256;
>> +             xfer_id = WAC_CMD_ICON_BT_XFER;
>> +     } else {
>> +             len = 1024;
>> +             xfer_id = WAC_CMD_ICON_XFER;
>> +     }
>> +
>> +     if (count != len)
>>               return -EINVAL;
>>
>>       mutex_lock(&wacom->lock);
>>
>> -     err = wacom_led_putimage(wacom, button_id, buf);
>> +     err = wacom_led_putimage(wacom, button_id, xfer_id, len, buf);
>>
>>       mutex_unlock(&wacom->lock);
>
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>

Reviewed-by: Ping Cheng <pingc@wacom.com>

> I'll test the whole series tomorrow.

I'd like to see Przemo's Tested-by tag here as well. Przemo, are you
done with your testing?

Thank you Przemo and Benjamin for your effort in making this
transition smooth and successful. We, at Wacom, are very grateful to
be part of this great community.

Cheers,

Ping
