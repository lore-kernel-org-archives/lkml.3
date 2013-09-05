Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763549Ab3IEJL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:11:56 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:46243 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763437Ab3IEJLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:11:53 -0400
MIME-Version: 1.0
In-Reply-To: <522659FC.5050701@uplogix.com>
References: <1377615715-25699-1-git-send-email-dbarksdale@uplogix.com>
	<CANq1E4TGr54owuauUNyHqQ7GOiXf4wByWpaPTX28+SnqDsac+A@mail.gmail.com>
	<522659FC.5050701@uplogix.com>
Date: Thu, 5 Sep 2013 11:11:52 +0200
Message-ID: <CANq1E4RAYRk=MtjsqDQrr3-bdCR9REMmoW18fwxc4uVx-NXMwQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] HID: New hid-cp2112 driver.
From: David Herrmann <dh.herrmann@gmail.com>
To: David Barksdale <dbarksdale@uplogix.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Sep 3, 2013 at 11:51 PM, David Barksdale <dbarksdale@uplogix.com> wrote:
> On 08/29/2013 11:43 AM, David Herrmann wrote:
>>
>> Hi
>>
>> On Tue, Aug 27, 2013 at 5:01 PM, David Barksdale <dbarksdale@uplogix.com>
>> wrote:
>>>
>>> This patch adds support for the Silicon Labs CP2112
>>> "Single-Chip HID USB to SMBus Master Bridge."
>>>
>>> I wrote this to support a USB temperature and humidity
>>> sensor I've been working on. It's been tested by using
>>> SMBus byte-read, byte-data-read/write, and word-data-read
>>> transfer modes to talk to an I2C sensor. The other
>>> transfer modes have not been tested.
>>>
>>> Signed-off-by: David Barksdale <dbarksdale@uplogix.com>
>>>
>>> ---
>>>   drivers/hid/Kconfig      |   6 +
>>>   drivers/hid/Makefile     |   1 +
>>>   drivers/hid/hid-core.c   |   3 +
>>>   drivers/hid/hid-cp2112.c | 504
>>> +++++++++++++++++++++++++++++++++++++++++++++++
>>>   4 files changed, 514 insertions(+)
>>>
>>> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
>>> index 14ef6ab..1833948 100644
>>> --- a/drivers/hid/Kconfig
>>> +++ b/drivers/hid/Kconfig
>>> @@ -175,6 +175,12 @@ config HID_PRODIKEYS
>>>            multimedia keyboard, but will lack support for the musical
>>> keyboard
>>>            and some additional multimedia keys.
>>>
>>> +config HID_CP2112
>>> +       tristate "Silicon Labs CP2112 HID USB-to-SMBus Bridge support"
>>> +       depends on USB_HID
>>> +       ---help---
>>> +       Support for Silicon Labs CP2112 HID USB to SMBus Master Bridge.
>>> +
>>>   config HID_CYPRESS
>>>          tristate "Cypress mouse and barcode readers" if EXPERT
>>>          depends on HID
>>> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
>>> index 6f68728..a88a5c4 100644
>>> --- a/drivers/hid/Makefile
>>> +++ b/drivers/hid/Makefile
>>> @@ -41,6 +41,7 @@ obj-$(CONFIG_HID_AUREAL)        += hid-aureal.o
>>>   obj-$(CONFIG_HID_BELKIN)       += hid-belkin.o
>>>   obj-$(CONFIG_HID_CHERRY)       += hid-cherry.o
>>>   obj-$(CONFIG_HID_CHICONY)      += hid-chicony.o
>>> +obj-$(CONFIG_HID_CP2112)       += hid-cp2112.o
>>>   obj-$(CONFIG_HID_CYPRESS)      += hid-cypress.o
>>>   obj-$(CONFIG_HID_DRAGONRISE)   += hid-dr.o
>>>   obj-$(CONFIG_HID_EMS_FF)       += hid-emsff.o
>>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>>> index 36668d1..b472a0d 100644
>>> --- a/drivers/hid/hid-core.c
>>> +++ b/drivers/hid/hid-core.c
>>> @@ -1568,6 +1568,9 @@ static const struct hid_device_id
>>> hid_have_special_driver[] = {
>>>          { HID_USB_DEVICE(USB_VENDOR_ID_CHICONY,
>>> USB_DEVICE_ID_CHICONY_WIRELESS2) },
>>>          { HID_USB_DEVICE(USB_VENDOR_ID_CHICONY,
>>> USB_DEVICE_ID_CHICONY_AK1D) },
>>>          { HID_USB_DEVICE(USB_VENDOR_ID_CREATIVELABS,
>>> USB_DEVICE_ID_PRODIKEYS_PCMIDI) },
>>> +#if IS_ENABLED(CONFIG_HID_CP2112)
>>> +       { HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, 0xEA90) },
>>> +#endif
>>
>>
>> Why is that #if needed?
>
>
> There are similar #ifs for CONFIG_HID_LENOVO_TPKBD, CONFIG_HID_LOGITECH_DJ,
> and CONFIG_HID_ROCCAT. I thought it was a good idea.

These are used for devices that work with and without special drivers.
If you don't have the special-driver compiled in, you want the generic
HID driver to bind to these devices (Jiri may correct me if I am
wrong).

However, for your device this doesn't make any sense. hid-generic has
no idea of smbus bridges. So yeah, just drop the #if.

>
>>>          { HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
>>> USB_DEVICE_ID_CYPRESS_BARCODE_1) },
>>>          { HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
>>> USB_DEVICE_ID_CYPRESS_BARCODE_2) },
>>>          { HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
>>> USB_DEVICE_ID_CYPRESS_BARCODE_3) },
>>> diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
>>> new file mode 100644
>>> index 0000000..8737d18
>>> --- /dev/null
>>> +++ b/drivers/hid/hid-cp2112.c
>>> @@ -0,0 +1,504 @@
>>> +/*
>>> +  hid-cp2112.c - Silicon Labs HID USB to SMBus master bridge
>>> +  Copyright (c) 2013 Uplogix, Inc.
>>> +  David Barksdale <dbarksdale@uplogix.com>
>>> +
>>> +  This program is free software; you can redistribute it and/or modify
>>> +  it under the terms of the GNU General Public License as published by
>>> +  the Free Software Foundation; either version 2 of the License, or
>>> +  (at your option) any later version.
>>> +
>>> +  This program is distributed in the hope that it will be useful,
>>> +  but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> +  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> +  GNU General Public License for more details.
>>> +
>>> +  You should have received a copy of the GNU General Public License
>>> +  along with this program; if not, write to the Free Software
>>> +  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>>> + */
>>> +
>>> +#include <linux/hid.h>
>>> +#include <linux/i2c.h>
>>> +#include <linux/module.h>
>>> +#include "hid-ids.h"
>>> +
>>> +enum {
>>> +       GET_VERSION_INFO = 0x05,
>>> +       SMBUS_CONFIG = 0x06,
>>> +       DATA_READ_REQUEST = 0x10,
>>> +       DATA_WRITE_READ_REQUEST = 0x11,
>>> +       DATA_READ_FORCE_SEND = 0x12,
>>> +       DATA_READ_RESPONSE = 0x13,
>>> +       DATA_WRITE_REQUEST = 0x14,
>>> +       TRANSFER_STATUS_REQUEST = 0x15,
>>> +       TRANSFER_STATUS_RESPONSE = 0x16,
>>> +       CANCEL_TRANSFER = 0x17,
>>> +};
>>> +
>>> +enum {
>>> +       STATUS0_IDLE = 0x00,
>>> +       STATUS0_BUSY = 0x01,
>>> +       STATUS0_COMPLETE = 0x02,
>>> +       STATUS0_ERROR = 0x03,
>>> +};
>>> +
>>> +enum {
>>> +       STATUS1_TIMEOUT_NACK = 0x00,
>>> +       STATUS1_TIMEOUT_BUS = 0x01,
>>> +       STATUS1_ARBITRATION_LOST = 0x02,
>>> +       STATUS1_READ_INCOMPLETE = 0x03,
>>> +       STATUS1_WRITE_INCOMPLETE = 0x04,
>>> +       STATUS1_SUCCESS = 0x05,
>>> +};
>>
>>
>> If you don't add any prefix to these functions (especially
>> SMBUS_CONFIG) it is quite likely that at some point your driver will
>> get compile-errors. Any particular reason not to do that? (same
>> applies to all the function/global-vars below)
>
>
> Prefixes added. I think the STATUS* ones will be unique enough without
> another prefix.

It was SMBUS_CONFIG in particular that bothered me. So yeah, if names
look unique enough, no need to add prefixes.

[..snip..]
>>> +       }
>>> +       dev->hdev = hdev;
>>> +       hid_set_drvdata(hdev, (void *)dev);
>>> +       dev->adap.owner         = THIS_MODULE;
>>> +       dev->adap.class         = I2C_CLASS_HWMON;
>>> +       dev->adap.algo          = &smbus_algorithm;
>>> +       dev->adap.algo_data     = dev;
>>> +       snprintf(dev->adap.name, sizeof(dev->adap.name),
>>> +               "CP2112 SMBus Bridge on hiddev%d", hdev->minor);
>>> +       init_waitqueue_head(&dev->wait);
>>> +       hid_device_io_start(hdev);
>>> +       ret = i2c_add_adapter(&dev->adap);
>>> +       hid_device_io_stop(hdev);
>>
>>
>> You should call hid_device_io_stop() only on failure. Otherwise,
>> hid-core drops any incoming events until you return. If smbus can
>> handle missing events, this is fine.
>>
>> In case you don't care for I/O between this and your handler above,
>> you can call hid_hw_close() here. Note that ->raw_event() is only
>> called while the device is open.
>
>
> I'll call hid_device_io_stop() and hid_hw_close() here since I don't care
> for I/O or events until I have a transaction to perform.

Yepp, sounds good.

>
>>> +       if (ret) {
>>> +               hid_err(hdev, "error registering i2c adapter\n");
>>> +               kfree(dev);
>>> +               hid_set_drvdata(hdev, NULL);
>>
>>
>> Drop this hid_set_drvdata()
>> hid_hw_stop() missing (and hid_hw_close())
>
>
> Done.
>
>
>>> +       }
>>> +       hid_dbg(hdev, "adapter registered\n");
>>> +       return ret;
>>> +}
>>> +
>>> +static void cp2112_remove(struct hid_device *hdev)
>>> +{
>>> +       struct cp2112_device *dev = hid_get_drvdata(hdev);
>>> +
>>> +       if (dev) {
>>
>>
>> Why if (dev)? Any reason dev might be NULL?
>
>
> This is probably left over from some debugging, just to be safe. Removed.
>
>
>>> +               i2c_del_adapter(&dev->adap);
>>> +               wake_up_interruptible(&dev->wait);
>>
>>
>> How can you have waiters on dev->wait if you free() it in the line
>> below? There ought to be some *_sync() call here which waits for all
>> possible pending calls to finish.
>
>
> I'm having some trouble with this. I've added some printk's to understand
> what happens when I yank the USB cable. For testing I generate transactions
> using the i2c-dev driver and i2cdetect utility.
> On one occasion it looks like the last cp2112_xfer() completes, then it is
> called several more times after the cable is yanked which fail on
> hid_output_raw_report() returning -EPIPE. Then cp2112_remove() is finally
> called (your version below) and returns. Then cp2112_xfer() is called yet
> again and barfs because everything's been freed.
> What can I wait on to know that my .smbus_xfer function won't be called
> after i2c_del_adapter()?

Maybe Benjamin can help here as I am not very familiar with i2c core-code.

I did look at it (and other i2c bus-drivers) and i2c_del_adapter
should be enough.

The thing is, your i2c-xfer callback is synchronous. Once
hid->remove() is called, no other HID callback will be called,
anymore. Furthermore, if the device is gone, all HID-I/O calls will
return -EIO immediately. So you should just drop the
wake_up_interruptible() (or move it in front of i2c_del_adapter() in
case you don't care for driver-unload while devices are still active).

Furthermore, the xfer callback shouldn't be called by smbus-core after
i2c_del_adapter() returns. If it is, you should definitely report that
to the i2c mailing-list.

Obviously, for debugging, you should set the i2c-drvdata to NULL after
i2c_del_adapter() and test for that in your xfer callback (may add a
WARN_ON()). This is racy, but it should avoid the use-after-free. Once
you figured it out, you can remove them again. Feel free to CC
i2c-mailing-lists if you are not sure.

And also feel free to send v2 even if there are still bugs. It's often
easier to comment on the recent-state than just an old ML thread.

Thanks
David

>
>>> +               kfree(dev);
>>> +               hid_set_drvdata(hdev, NULL);
>>
>>
>> Not needed.
>>
>>> +       }
>>> +       hid_hw_stop(hdev);
>>
>>
>> I recommend calling hid_hw_stop() before destroying your context. Not
>> strictly needed, but it makes it clear that no I/O is possible during
>> _remove().
>>
>> So you can reduce this function to:
>>
>> hid_hw_stop(hdev);
>> i2c_del_adapter(&dev->adap);
>> wake_up_interruptible(&dev->wait);
>> your_whatever_wait_sync_call()
>> kfree(dev);
>
>
> Done.
>
>
>>> +}
>>> +
>>> +static int cp2112_raw_event(struct hid_device *hdev, struct hid_report
>>> *report,
>>> +       uint8_t *data, int size)
>>> +{
>>> +       struct cp2112_device *dev = hid_get_drvdata(hdev);
>>> +
>>> +       switch (data[0]) {
>>> +       case TRANSFER_STATUS_RESPONSE:
>>> +               hid_dbg(hdev, "xfer status: %02x %02x %04x %04x\n",
>>> +                       data[1], data[2], htons(*(uint16_t *)&data[3]),
>>> +                       htons(*(uint16_t *)&data[5]));
>>> +               switch (data[1]) {
>>> +               case STATUS0_IDLE:
>>> +                       dev->xfer_status = -EAGAIN;
>>> +                       break;
>>> +               case STATUS0_BUSY:
>>> +                       dev->xfer_status = -EBUSY;
>>> +                       break;
>>> +               case STATUS0_COMPLETE:
>>> +                       dev->xfer_status = ntohs(*(uint16_t *)&data[5]);
>>> +                       break;
>>> +               case STATUS0_ERROR:
>>> +                       switch (data[2]) {
>>> +                       case STATUS1_TIMEOUT_NACK:
>>> +                       case STATUS1_TIMEOUT_BUS:
>>> +                               dev->xfer_status = -ETIMEDOUT;
>>> +                               break;
>>> +                       default:
>>> +                               dev->xfer_status = -EIO;
>>> +                       }
>>> +                       break;
>>> +               default:
>>> +                       dev->xfer_status = -EINVAL;
>>> +                       break;
>>> +               }
>>> +               atomic_set(&dev->xfer_avail, 1);
>>> +               break;
>>> +       case DATA_READ_RESPONSE:
>>> +               hid_dbg(hdev, "read response: %02x %02x\n", data[1],
>>> data[2]);
>>> +               dev->read_length = data[2];
>>> +               if (dev->read_length > sizeof(dev->read_data))
>>> +                       dev->read_length = sizeof(dev->read_data);
>>> +               memcpy(dev->read_data, &data[3], dev->read_length);
>>> +               atomic_set(&dev->read_avail, 1);
>>> +               break;
>>> +       default:
>>> +               hid_err(hdev, "unknown report\n");
>>> +               return 0;
>>> +       }
>>> +       wake_up_interruptible(&dev->wait);
>>> +       return 1;
>>> +}
>>> +
>>> +static struct hid_driver cp2112_driver = {
>>> +       .name = "cp2112",
>>> +       .id_table = cp2112_devices,
>>> +       .probe = cp2112_probe,
>>> +       .remove = cp2112_remove,
>>> +       .raw_event = cp2112_raw_event,
>>> +};
>>> +
>>> +static int __init cp2112_init(void)
>>> +{
>>> +       return hid_register_driver(&cp2112_driver);
>>> +}
>>> +
>>> +static void __exit cp2112_exit(void)
>>> +{
>>> +       hid_unregister_driver(&cp2112_driver);
>>> +}
>>> +
>>> +module_init(cp2112_init);
>>> +module_exit(cp2112_exit);
>>
>>
>> Use:
>> module_hid_driver(&cp2112_driver);
>> to save some lines here.
>
>
> Done.
>
>
>> Cheers
>> David
>>
>>> +MODULE_DESCRIPTION("Silicon Labs HID USB to SMBus master bridge");
>>> +MODULE_AUTHOR("David Barksdale <dbarksdale@uplogix.com>");
>>> +MODULE_LICENSE("GPL");
>>> +
>>> --
>>> tg: (584d88b..) upstream/hid-cp2112 (depends on: upstream/master)
>>> --
>
>
> Thank you David for all the helpful comments.
>
