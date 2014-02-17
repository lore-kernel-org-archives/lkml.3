Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaBQNTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:19:16 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:42872 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbaBQNTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:19:13 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1402171414490.1192@pobox.suse.cz>
References: <1391636004-29354-1-git-send-email-benjamin.tissoires@redhat.com>
	<1391636004-29354-8-git-send-email-benjamin.tissoires@redhat.com>
	<alpine.LNX.2.00.1402171414490.1192@pobox.suse.cz>
Date: Mon, 17 Feb 2014 08:19:11 -0500
Message-ID: <CAN+gG=E__6ejV_BqdtM8iwyM-UCdB1G49nvEZn3WTeELixqs4Q@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] HID: remove hid_get_raw_report in struct hid_device
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Frank Praznik <frank.praznik@oh.rr.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 8:15 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 5 Feb 2014, Benjamin Tissoires wrote:
>
>> dev->hid_get_raw_report(X) and hid_hw_raw_request(X, HID_REQ_GET_REPORT)
>> are strictly equivalent. Switch the hid subsystem to the hid_hw notation
>> and remove the field .hid_get_raw_report in struct hid_device.
>>
>> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  drivers/hid/hid-input.c       | 6 +++---
>>  drivers/hid/hid-sony.c        | 3 ++-
>>  drivers/hid/hidraw.c          | 7 ++++---
>>  drivers/hid/i2c-hid/i2c-hid.c | 1 -
>>  drivers/hid/uhid.c            | 1 -
>>  drivers/hid/usbhid/hid-core.c | 1 -
>>  include/linux/hid.h           | 3 ---
>>  net/bluetooth/hidp/core.c     | 1 -
>>  8 files changed, 9 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
>> index 68db2db..6253e95 100644
>> --- a/drivers/hid/hid-input.c
>> +++ b/drivers/hid/hid-input.c
>> @@ -350,9 +350,9 @@ static int hidinput_get_battery_property(struct power_supply *psy,
>>                       ret = -ENOMEM;
>>                       break;
>>               }
>> -             ret = dev->hid_get_raw_report(dev, dev->battery_report_id,
>> -                                           buf, 2,
>> -                                           dev->battery_report_type);
>> +             ret = hid_hw_raw_request(dev, dev->battery_report_id, buf, 2,
>> +                                      dev->battery_report_type,
>> +                                      HID_REQ_GET_REPORT);
>>
>>               if (ret != 2) {
>>                       ret = -ENODATA;
>> diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
>> index 2bd3f13..b51db79 100644
>> --- a/drivers/hid/hid-sony.c
>> +++ b/drivers/hid/hid-sony.c
>> @@ -810,7 +810,8 @@ static int sixaxis_set_operational_usb(struct hid_device *hdev)
>>       if (!buf)
>>               return -ENOMEM;
>>
>> -     ret = hdev->hid_get_raw_report(hdev, 0xf2, buf, 17, HID_FEATURE_REPORT);
>> +     ret = hid_hw_raw_request(hdev, 0xf2, buf, 17, HID_FEATURE_REPORT,
>> +                              HID_REQ_GET_REPORT);
>>
>>       if (ret < 0)
>>               hid_err(hdev, "can't set operational mode\n");
>> diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
>> index cb0137b..4b2dc95 100644
>> --- a/drivers/hid/hidraw.c
>> +++ b/drivers/hid/hidraw.c
>> @@ -189,7 +189,7 @@ static ssize_t hidraw_get_report(struct file *file, char __user *buffer, size_t
>>
>>       dev = hidraw_table[minor]->hid;
>>
>> -     if (!dev->hid_get_raw_report) {
>> +     if (!dev->ll_driver->raw_request) {
>>               ret = -ENODEV;
>>               goto out;
>>       }
>> @@ -216,14 +216,15 @@ static ssize_t hidraw_get_report(struct file *file, char __user *buffer, size_t
>>
>>       /*
>>        * Read the first byte from the user. This is the report number,
>> -      * which is passed to dev->hid_get_raw_report().
>> +      * which is passed to hid_hw_raw_request().
>>        */
>>       if (copy_from_user(&report_number, buffer, 1)) {
>>               ret = -EFAULT;
>>               goto out_free;
>>       }
>>
>> -     ret = dev->hid_get_raw_report(dev, report_number, buf, count, report_type);
>> +     ret = hid_hw_raw_request(dev, report_number, buf, count, report_type,
>> +                              HID_REQ_GET_REPORT);
>>
>>       if (ret < 0)
>>               goto out_free;
>> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
>> index 923ff81..f57de7f 100644
>> --- a/drivers/hid/i2c-hid/i2c-hid.c
>> +++ b/drivers/hid/i2c-hid/i2c-hid.c
>> @@ -1003,7 +1003,6 @@ static int i2c_hid_probe(struct i2c_client *client,
>>
>>       hid->driver_data = client;
>>       hid->ll_driver = &i2c_hid_ll_driver;
>> -     hid->hid_get_raw_report = i2c_hid_get_raw_report;
>>       hid->hid_output_raw_report = i2c_hid_output_raw_report;
>>       hid->dev.parent = &client->dev;
>>       ACPI_COMPANION_SET(&hid->dev, ACPI_COMPANION(&client->dev));
>> diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
>> index f5a2b19..12439e1 100644
>> --- a/drivers/hid/uhid.c
>> +++ b/drivers/hid/uhid.c
>> @@ -404,7 +404,6 @@ static int uhid_dev_create(struct uhid_device *uhid,
>>       hid->uniq[63] = 0;
>>
>>       hid->ll_driver = &uhid_hid_driver;
>> -     hid->hid_get_raw_report = uhid_hid_get_raw;
>
> I'll queue a followup patch on top of this that completely removes
> uhid_hid_get_raw(), as it's unused now.

Jiri, please don't. It was a mistake which was fixed in the next patch
series (2/14: HID: uHID: implement .raw_request). It was already
reviewed by David, so you can apply it right now.

Cheers,
Benjamin


>
> --
> Jiri Kosina
> SUSE Labs
