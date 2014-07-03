Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbaGCSSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:18:22 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:39785 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbaGCSSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:18:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140703174017.GP16590@localhost>
References: <20140703082830.GB16590@localhost> <1404407829-1815-1-git-send-email-janne.kanniainen@gmail.com>
 <1404407829-1815-2-git-send-email-janne.kanniainen@gmail.com> <20140703174017.GP16590@localhost>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 3 Jul 2014 11:17:57 -0700
Message-ID: <CAK5ve-LBU72Z_dnV9XUyMTVgFF2C1xRhKNhC_cziO5GMx__zhA@mail.gmail.com>
Subject: Re: [PATCH 2/2 v6] HID: gt683r: move mode attribute to led-class devices
To: Johan Hovold <johan@kernel.org>
Cc: Janne Kanniainen <janne.kanniainen@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 10:40 AM, Johan Hovold <johan@kernel.org> wrote:
> On Thu, Jul 03, 2014 at 08:17:09PM +0300, Janne Kanniainen wrote:
>> Move led_mode attribute from HID device to led-class devices and rename
>> it msi_mode. This will also fix race condition by using
>
> There's a typo here (s/msi_mode/mode) but perhaps Bryan can just fix
> that up before applying?
>
>> attribute-groups.
>>
>> Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
>
> Reviewed-by: Johan Hovold <johan@kernel.org>
>
> Otherwise both patches (v6) are ready to be merged, Bryan.
>
> Thanks, Janne!
>

No problem. I fixed the typo and merged it.

Thanks,
-Bryan



>> ---
>>
>> Changes in v3:
>>       - Style fixes
>>       - Rename sysfs-class-hid-driver-gt683r to sysfs-class-leds-driver-gt683r
>>
>> Changes in v4:
>>       - Rename sysfs-class-leds-driver-gt683r to sysfs-class-leds-gt683r
>>       - Change "What: " to /sys/class/leds/<led>/gt683r/mode
>>       - Change .name from gt683r_led to gt683r
>>
>> Changes in v5:
>>       - Move mode attribute to gt683r/mode
>>
>> Changes in v6:
>>       - Fix subject and commit message
>>
>>  .../ABI/testing/sysfs-class-hid-driver-gt683r      | 14 ---------
>>  Documentation/ABI/testing/sysfs-class-leds-gt683r  | 16 ++++++++++
>>  drivers/hid/hid-gt683r.c                           | 36 ++++++++++++++--------
>>  3 files changed, 40 insertions(+), 26 deletions(-)
>>  delete mode 100644 Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
>>  create mode 100644 Documentation/ABI/testing/sysfs-class-leds-gt683r
>>
>> diff --git a/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
>> deleted file mode 100644
>> index 317e9d5..0000000
>> --- a/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
>> +++ /dev/null
>> @@ -1,14 +0,0 @@
>> -What:                /sys/class/hidraw/<hidraw>/device/leds_mode
>> -Date:                Jun 2014
>> -KernelVersion:       3.17
>> -Contact:     Janne Kanniainen <janne.kanniainen@gmail.com>
>> -Description:
>> -             Set the mode of LEDs
>> -
>> -             0 - normal
>> -             1 - audio
>> -             2 - breathing
>> -
>> -             Normal: LEDs are fully on when enabled
>> -             Audio:  LEDs brightness depends on sound level
>> -             Breathing: LEDs brightness varies at human breathing rate
>> \ No newline at end of file
>> diff --git a/Documentation/ABI/testing/sysfs-class-leds-gt683r b/Documentation/ABI/testing/sysfs-class-leds-gt683r
>> new file mode 100644
>> index 0000000..e4fae60
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-class-leds-gt683r
>> @@ -0,0 +1,16 @@
>> +What:                /sys/class/leds/<led>/gt683r/mode
>> +Date:                Jun 2014
>> +KernelVersion:       3.17
>> +Contact:     Janne Kanniainen <janne.kanniainen@gmail.com>
>> +Description:
>> +             Set the mode of LEDs. You should notice that changing the mode
>> +             of one LED will update the mode of its two sibling devices as
>> +             well.
>> +
>> +             0 - normal
>> +             1 - audio
>> +             2 - breathing
>> +
>> +             Normal: LEDs are fully on when enabled
>> +             Audio:  LEDs brightness depends on sound level
>> +             Breathing: LEDs brightness varies at human breathing rate
>> \ No newline at end of file
>> diff --git a/drivers/hid/hid-gt683r.c b/drivers/hid/hid-gt683r.c
>> index 073bd80..0d6f135 100644
>> --- a/drivers/hid/hid-gt683r.c
>> +++ b/drivers/hid/hid-gt683r.c
>> @@ -84,12 +84,13 @@ static void gt683r_brightness_set(struct led_classdev *led_cdev,
>>       }
>>  }
>>
>> -static ssize_t leds_mode_show(struct device *dev,
>> +static ssize_t mode_show(struct device *dev,
>>                               struct device_attribute *attr,
>>                               char *buf)
>>  {
>>       u8 sysfs_mode;
>> -     struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>> +     struct hid_device *hdev = container_of(dev->parent,
>> +                                     struct hid_device, dev);
>>       struct gt683r_led *led = hid_get_drvdata(hdev);
>>
>>       if (led->mode == GT683R_LED_NORMAL)
>> @@ -102,12 +103,13 @@ static ssize_t leds_mode_show(struct device *dev,
>>       return scnprintf(buf, PAGE_SIZE, "%u\n", sysfs_mode);
>>  }
>>
>> -static ssize_t leds_mode_store(struct device *dev,
>> +static ssize_t mode_store(struct device *dev,
>>                               struct device_attribute *attr,
>>                               const char *buf, size_t count)
>>  {
>>       u8 sysfs_mode;
>> -     struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>> +     struct hid_device *hdev = container_of(dev->parent,
>> +                                     struct hid_device, dev);
>>       struct gt683r_led *led = hid_get_drvdata(hdev);
>>
>>
>> @@ -212,7 +214,22 @@ fail:
>>       mutex_unlock(&led->lock);
>>  }
>>
>> -static DEVICE_ATTR_RW(leds_mode);
>> +static DEVICE_ATTR_RW(mode);
>> +
>> +static struct attribute *gt683r_led_attrs[] = {
>> +     &dev_attr_mode.attr,
>> +     NULL
>> +};
>> +
>> +static const struct attribute_group gt683r_led_group = {
>> +     .name = "gt683r",
>> +     .attrs = gt683r_led_attrs,
>> +};
>> +
>> +static const struct attribute_group *gt683r_led_groups[] = {
>> +     &gt683r_led_group,
>> +     NULL
>> +};
>>
>>  static int gt683r_led_probe(struct hid_device *hdev,
>>                       const struct hid_device_id *id)
>> @@ -261,6 +278,8 @@ static int gt683r_led_probe(struct hid_device *hdev,
>>               led->led_devs[i].name = name;
>>               led->led_devs[i].max_brightness = 1;
>>               led->led_devs[i].brightness_set = gt683r_brightness_set;
>> +             led->led_devs[i].groups = gt683r_led_groups;
>> +
>>               ret = led_classdev_register(&hdev->dev, &led->led_devs[i]);
>>               if (ret) {
>>                       hid_err(hdev, "could not register led device\n");
>> @@ -268,12 +287,6 @@ static int gt683r_led_probe(struct hid_device *hdev,
>>               }
>>       }
>>
>> -     ret = device_create_file(&led->hdev->dev, &dev_attr_leds_mode);
>> -     if (ret) {
>> -             hid_err(hdev, "could not make mode attribute file\n");
>> -             goto fail;
>> -     }
>> -
>>       return 0;
>>
>>  fail:
>> @@ -288,7 +301,6 @@ static void gt683r_led_remove(struct hid_device *hdev)
>>       int i;
>>       struct gt683r_led *led = hid_get_drvdata(hdev);
>>
>> -     device_remove_file(&hdev->dev, &dev_attr_leds_mode);
>>       for (i = 0; i < GT683R_LED_COUNT; i++)
>>               led_classdev_unregister(&led->led_devs[i]);
>>       flush_work(&led->work);
