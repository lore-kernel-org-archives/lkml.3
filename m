Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934473AbaDIX7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 19:59:05 -0400
Received: from smtp04.udag.de ([62.146.106.30]:45125 "EHLO smtp04.udag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933480AbaDIX7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 19:59:00 -0400
Message-ID: <5345DEBF.6070509@cevel.net>
Date: Thu, 10 Apr 2014 01:58:55 +0200
From: Tolga Cakir <tolga@cevel.net>
Reply-To: tolga@cevel.net
Organization: Cevel Network
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
CC: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Derya <derya.kiran@yahoo.de>, Jiri Kosina <jkosina@suse.cz>,
        Reyad Attiyat <reyad.attiyat@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] HID: microsoft: added Sidewinder X4 / X6 sysfs support
References: <1396631227-11770-1-git-send-email-tolga@cevel.net> <CAN+gG=HDuDW8H6_fESdHwtJSKQ4CYgXr0UM9qpYv6EPGE7W_KA@mail.gmail.com>
In-Reply-To: <CAN+gG=HDuDW8H6_fESdHwtJSKQ4CYgXr0UM9qpYv6EPGE7W_KA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.04.2014 22:42, schrieb Benjamin Tissoires:
> On Fri, Apr 4, 2014 at 1:07 PM, Tolga Cakir <tolga@cevel.net> wrote:
>> This patch enables us to set the profile, LEDs and read the key mask via sysfs. Documentation is included in this patch.
>>
>> Signed-off-by: Tolga Cakir <tolga@cevel.net>
>> ---
>>   .../ABI/testing/sysfs-driver-hid-microsoft         |  30 +++
>>   drivers/hid/hid-microsoft.c                        | 231 +++++++++++++++++++++
>>   2 files changed, 261 insertions(+)
>>   create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-microsoft
>>
>> diff --git a/Documentation/ABI/testing/sysfs-driver-hid-microsoft b/Documentation/ABI/testing/sysfs-driver-hid-microsoft
>> new file mode 100644
>> index 0000000..9fdfad7
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-driver-hid-microsoft
>> @@ -0,0 +1,30 @@
>> +What:          /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/auto_led
>> +Date:          April 2014
>> +Contact:       Tolga Cakir <tolga@cevel.net>
>> +Description:   This file allows you to set and view the Auto LED status.
>> +               Valid values are 0 and 1.
>> +
>> +What:          /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/profile
>> +Date:          April 2014
>> +Contact:       Tolga Cakir <tolga@cevel.net>
>> +Description:   Both, the Sidewinder X4 and the X6 can handle profiles.
>> +               They can be switched by writing to this file. Profile LEDs will be
>> +               set accordingly.
>> +               Valid values are 1 - 3.
>> +
>> +What:          /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/key_mask
>> +Date:          April 2014
>> +Contact:       Tolga Cakir <tolga@cevel.net>
>> +Description:   This file is read-only and outputs an unsigned long integer.
>> +               Every bit represents one of the S1 - S6 extra keys on the Sidewinder
>> +               X4 and S1 - S30 on the Sidewinder X6. The least significant bit
>> +               represents S1 on both gaming keyboards, the most significant bit
>> +               represents the Bank switch button on both keyboards. Multiple
>> +               special keys can be pressed at the same time.
> So that means that the user space polls the sysfs to trigger the actual macros?
> Or maybe I am missing something.
Nope, you got it right. Originally, I was only working on the Sidewinder 
X4 support, featuring 6 macro keys and 3 profiles, resulting in 18 
possible outcomes.

So, I hardcoded KEY_F13 - KEY_F24 and some other keys in the hid driver. 
That solution was working fine for the Sidewinder X4. However, when I got my
hands on a Sidewinder X6, supporting 30 macro keys and 3 profiles, 
resulting in 90 possible outcomes, I had to overthink my original design.

I've searched for similar keyboards and found the Roccat Arvo. As far as 
I've understood the code of hid-roccat-arvo, it shows pressed keys as 
key_mask via
sysfs and a user land tool (http://sourceforge.net/projects/roccat) 
polls sysfs to handle the keypresses. I'm doing essentially the same 
here, too.
>> +
>> +What:          /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/record_led
>> +Date:          April 2014
>> +Contact:       Tolga Cakir <tolga@cevel.net>
>> +Description:   This file allows you to set and view the Record LED status.
>> +               Valid values are 0 - 2. 0 stands for off, 1 for solid mode and 2
>> +               for blinking mode.
>> diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
>> index 5b5d40f..5674c0c 100644
>> --- a/drivers/hid/hid-microsoft.c
>> +++ b/drivers/hid/hid-microsoft.c
>> @@ -19,6 +19,8 @@
>>   #include <linux/input.h>
>>   #include <linux/hid.h>
>>   #include <linux/module.h>
>> +#include <linux/sysfs.h>
>> +#include <linux/usb.h>
> iiiik, I really don't like seeing this in a HID driver. I spent too
> much try fighting to make HID usb agnostic to accept that blindy.
> Fortunately, it doesn't seems to be used in the final patch.
Aww, sorry to make you see such cruel things :(. I will fix it in v2, 
thank you for pointing that out; I wasn't aware of it.
>>   #include "hid-ids.h"
>>
>> @@ -209,6 +211,219 @@ static int ms_sidewinder_kb_quirk(struct hid_input *hi, struct hid_usage *usage,
>>          return 1;
>>   }
>>
>> +static int ms_sidewinder_control(struct hid_device *hdev, __u8 setup)
>> +{
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>> +       struct ms_sidewinder_extra *sidewinder = sc->extra;
>> +       struct hid_report *report =
>> +                       hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[7];
>> +
>> +       /*
>> +        * LEDs 1 - 3 should not be set simultaneously, however
>> +        * they can be set in any combination with Auto or Record LEDs.
>> +        */
>> +       report->field[0]->value[0] = (setup & 0x01) ? 0x01 : 0x00;      /* X6 only: Macro Pad toggle */
>> +       report->field[0]->value[1] = (setup & 0x02) ? 0x01 : 0x00;      /* LED Auto */
>> +       report->field[0]->value[2] = (setup & 0x04) ? 0x01 : 0x00;      /* LED 1 */
>> +       report->field[0]->value[3] = (setup & 0x08) ? 0x01 : 0x00;      /* LED 2 */
>> +       report->field[0]->value[4] = (setup & 0x10) ? 0x01 : 0x00;      /* LED 3 */
>> +       report->field[1]->value[0] = 0x00;      /* Clear Record LED */
>> +
>> +       switch (setup & 0x60) {
>> +       case 0x40: report->field[1]->value[0] = 0x02;   break;  /* Record LED Blink */
>> +       case 0x20: report->field[1]->value[0] = 0x03;   break;  /* Record LED Solid */
> do we have any guarantees that setup & 0x60 != 0x60?
I think there is no possibility for that outcome. The only code, which 
touches these bits, can be found in
static ms_sidewinder_record_store. Everytime, prior writing to these 
bits, they're cleared and the only
possible values are either 0x40, 0x20, 0x00 or 0x10 (if LED 3 is on). 
But I think, I get your point. I will create
another case for 0x60 in terms of error handling in v2.
>> +       }
>> +
>> +       hid_hw_request(hdev, report, HID_REQ_SET_REPORT);
>> +       sidewinder->status = setup;
>> +
>> +       return 0;
>> +}
>> +
>> +/*
>> + * Sidewinder sysfs
>> + * @key_mask: show pressed special keys
>> + * @profile: show and set profile count and LED status
>> + * @auto_led: show and set LED Auto
>> + * @record_led: show and set Record LED
>> + */
>> +static ssize_t ms_sidewinder_key_mask_show(struct device *dev,
>> +               struct device_attribute *attr, char *buf)
>> +{
>> +       struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>> +       struct ms_sidewinder_extra *sidewinder = sc->extra;
>> +
>> +       return snprintf(buf, PAGE_SIZE, "%lu\n", sidewinder->key_mask);
>> +}
>> +
>> +static struct device_attribute dev_attr_ms_sidewinder_key_mask = {
>> +       .attr = { .name = __stringify(key_mask), .mode = S_IRUGO },
>> +       .show = ms_sidewinder_key_mask_show
>> +};
>> +
>> +static ssize_t ms_sidewinder_profile_show(struct device *dev,
>> +               struct device_attribute *attr, char *buf)
>> +{
>> +       struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>> +       struct ms_sidewinder_extra *sidewinder = sc->extra;
>> +
>> +       return snprintf(buf, PAGE_SIZE, "%1u\n", sidewinder->profile);
>> +}
>> +
>> +static ssize_t ms_sidewinder_profile_store(struct device *dev,
>> +               struct device_attribute *attr, char const *buf, size_t count)
>> +{
>> +       struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>> +       struct ms_sidewinder_extra *sidewinder = sc->extra;
>> +       __u8 setup = sidewinder->status & ~(0x1c);      /* Clear Profile LEDs */
>> +
>> +       if (sscanf(buf, "%1u", &sidewinder->profile) != 1)
>> +               return -EINVAL;
>> +
>> +       if (sidewinder->profile < 1 || sidewinder->profile > 3) {
>> +               return -EINVAL;
>> +       } else {
>> +               setup |= 0x02 << sidewinder->profile;
>> +               ms_sidewinder_control(hdev, setup);
>> +               return strnlen(buf, PAGE_SIZE);
>> +       }
>> +}
>> +
>> +static struct device_attribute dev_attr_ms_sidewinder_profile =
>> +       __ATTR(profile, S_IWUSR | S_IRUGO,
>> +               ms_sidewinder_profile_show,
>> +               ms_sidewinder_profile_store);
>> +
>> +static ssize_t ms_sidewinder_macro_pad_show(struct device *dev,
>> +               struct device_attribute *attr, char *buf)
>> +{
>> +       struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>> +       struct ms_sidewinder_extra *sidewinder = sc->extra;
>> +
>> +       return snprintf(buf, PAGE_SIZE, "%1u\n", (sidewinder->status & 0x01));
>> +}
>> +
>> +static ssize_t ms_sidewinder_macro_pad_store(struct device *dev,
>> +               struct device_attribute *attr, char const *buf, size_t count)
>> +{
>> +       struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>> +       struct ms_sidewinder_extra *sidewinder = sc->extra;
>> +       unsigned int value;
>> +       __u8 setup;
>> +
>> +       if (sscanf(buf, "%1u", &value) != 1)
>> +               return -EINVAL;
>> +
>> +       if (value < 0 || value > 1) {
>> +               return -EINVAL;
>> +       } else {
>> +               setup = sidewinder->status & ~(0x01);   /* Clear Macro Pad */
>> +               if (value)
>> +                       setup |= 0x01;
>> +               ms_sidewinder_control(hdev, setup);
>> +               return strnlen(buf, PAGE_SIZE);
>> +       }
>> +}
>> +
>> +static struct device_attribute dev_attr_ms_sidewinder_macro_pad =
>> +       __ATTR(macro_pad, S_IWUSR | S_IRUGO,
>> +               ms_sidewinder_macro_pad_show,
>> +               ms_sidewinder_macro_pad_store);
>> +
>> +static ssize_t ms_sidewinder_record_show(struct device *dev,
>> +               struct device_attribute *attr, char *buf)
>> +{
>> +       struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>> +       struct ms_sidewinder_extra *sidewinder = sc->extra;
>> +
>> +       return snprintf(buf, PAGE_SIZE, "%1d\n", (sidewinder->status & 0x60) >> 5);
>> +}
>> +
>> +static ssize_t ms_sidewinder_record_store(struct device *dev,
>> +               struct device_attribute *attr, char const *buf, size_t count)
>> +{
>> +       struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>> +       struct ms_sidewinder_extra *sidewinder = sc->extra;
>> +       unsigned int value;
>> +       __u8 setup;
>> +
>> +       if (sscanf(buf, "%1u", &value) != 1)
>> +               return -EINVAL;
>> +
>> +       if (value < 0 || value > 2) {
>> +               return -EINVAL;
>> +       } else {
>> +               setup = sidewinder->status & ~(0xe0);   /* Clear Record LED */
>> +               if (value)
>> +                       setup |= 0x10 << value;
>> +               ms_sidewinder_control(hdev, setup);
>> +               return strnlen(buf, PAGE_SIZE);
>> +       }
>> +}
>> +
>> +static struct device_attribute dev_attr_ms_sidewinder_record =
>> +       __ATTR(record_led, S_IWUSR | S_IRUGO,
>> +               ms_sidewinder_record_show,
>> +               ms_sidewinder_record_store);
>> +
>> +static ssize_t ms_sidewinder_auto_show(struct device *dev,
>> +               struct device_attribute *attr, char *buf)
>> +{
>> +       struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>> +       struct ms_sidewinder_extra *sidewinder = sc->extra;
>> +
>> +       return snprintf(buf, PAGE_SIZE, "%1d\n", (sidewinder->status & 0x02) >> 1);
>> +}
>> +
>> +static ssize_t ms_sidewinder_auto_store(struct device *dev,
>> +               struct device_attribute *attr, char const *buf, size_t count)
>> +{
>> +       struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>> +       struct ms_sidewinder_extra *sidewinder = sc->extra;
>> +       unsigned int value;
>> +       __u8 setup;
>> +
>> +       if (sscanf(buf, "%1d", &value) != 1)
>> +               return -EINVAL;
>> +
>> +       if (value < 0 || value > 1) {
>> +               return -EINVAL;
>> +       } else {
>> +               setup = sidewinder->status & ~(0x02);   /* Clear Auto LED */
>> +               if (value)
>> +                       setup |= 0x02;
>> +               ms_sidewinder_control(hdev, setup);
>> +               return strnlen(buf, PAGE_SIZE);
>> +       }
>> +}
>> +
>> +static struct device_attribute dev_attr_ms_sidewinder_auto =
>> +       __ATTR(auto_led, S_IWUSR | S_IRUGO,
>> +               ms_sidewinder_auto_show,
>> +               ms_sidewinder_auto_store);
>> +
>> +static struct attribute *ms_attributes[] = {
>> +       &dev_attr_ms_sidewinder_key_mask.attr,
>> +       &dev_attr_ms_sidewinder_profile.attr,
>> +       &dev_attr_ms_sidewinder_macro_pad.attr,
>> +       &dev_attr_ms_sidewinder_record.attr,
>> +       &dev_attr_ms_sidewinder_auto.attr,
>> +       NULL
>> +};
>> +
>> +static const struct attribute_group ms_attr_group = {
>> +       .attrs = ms_attributes,
>> +};
>> +
>>   static int ms_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>>                  struct hid_field *field, struct hid_usage *usage,
>>                  unsigned long **bit, int *max)
>> @@ -357,6 +572,13 @@ static int ms_probe(struct hid_device *hdev, const struct hid_device_id *id)
>>                          return -ENOMEM;
>>                  }
>>                  sc->extra = sidewinder;
>> +
>> +               /* Create sysfs files for the Consumer Control Device only */
>> +               if (hdev->type == 2) {
> type is an enum, so using HID_TYPE_USBNONE makes more sense.
Nice! Thank you for that hint!
>> +                       if (sysfs_create_group(&hdev->dev.kobj, &ms_attr_group)) {
>> +                               hid_warn(hdev, "Could not create sysfs group\n");
>> +                       }
>> +               }
>>          }
>>
>>          ret = hid_parse(hdev);
>> @@ -377,6 +599,14 @@ err_free:
>>          return ret;
>>   }
>>
>> +static void ms_remove(struct hid_device *hdev)
>> +{
>> +       sysfs_remove_group(&hdev->dev.kobj,
>> +               &ms_attr_group);
> I guess this should be protected by some "if".
Yepp, you're right!
> Regarding the rest of the sysfs code. I did not went too deeper, but
> it on overall looks good to me.
>
> However, I am a little bit concerned by the API you are providing. We
> have already a LED API (have a look at hid-sony.c for instance) which
> seems to be more commonly used.
> It may not gives all of the features you need, but having a specific
> API for only two keyboards seems too much for me.
I originally tried to use the common LED API, but couldn't get it to 
work. It's just too
difficult for me, I'm very new to C and kernel development. I've studied 
hid-sony.c
countless times, but I guess I need more examples to fully understand 
the LED API.

I'll keep you updated about my progress.
> Also, If I read correctly, this patch set does not provide a way to
> use the macro keys: they are just stored and can be polled through
> sysfs (which I don't like).
>
> I have no idea how the other keyboards deal with macro keys, but this
> implementation seems not enough for me.
>
> Cheers,
> Benjamin
As I already mentioned, the Roccat Arvo (and several other Roccat gaming 
keyboards) handle
the macro keys like this.

Basically, there are two types of gaming keyboards out there; the ones, 
which don't depend
on software / drivers and do everything in hardware. For such keyboards, 
one usually needs
a user-land tool, which programs the keyboard's internal memory and 
that's it. It sends out
the standard USB packets, without the need of any software / driver 
afterwards.

The other type of keyboards depend on software. Each macro key sends out 
a specific USB
packet, the software catches these packets and handles it.

So, what I did there, is basically splitting up the driver in a kernel 
and a user-land component.
The kernel recognizes the key-presses and shows them via sysfs and the 
user-land tool
executes events (simple key-presses, scripts etc.), depending on which 
bit is set in key_mask.

Atleast, that's what I thought would be the best solution. Hardcoding 
keycodes might
work for some keyboards (Logitech G710+, Razer BlackWidow Ultimate 2013, 
Cooler Master
Storm Trigger), but will definitely fail on keyboards like the 
Sidewinder X6, Corsair K90 / K95
or the Logitech G110 featuring 50+ macro keys.

I'd love to approach another solution, but the problem is, that the 
Linux kernel is currently
not prepared for handling so many extra keys. We'd need more keycodes 
for such a solution,
like defining KEY_M1 - KEY_M99 for example. This way, we could make the 
kernel driver
send out keycodes and eliminate the use of sysfs for that. But I don't 
think that would be a
good solution. What are your thoughts Benjamin?

Again, thank you for your patience and for your time Benjamin!

Greetings,
Tolga Cakir
>> +
>> +       hid_hw_stop(hdev);
>> +}
>> +
>>   static const struct hid_device_id ms_devices[] = {
>>          { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV),
>>                  .driver_data = MS_HIDINPUT },
>> @@ -419,6 +649,7 @@ static struct hid_driver ms_driver = {
>>          .input_mapped = ms_input_mapped,
>>          .event = ms_event,
>>          .probe = ms_probe,
>> +       .remove = ms_remove,
>>   };
>>   module_hid_driver(ms_driver);
>>
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

