Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab3H2Qnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:43:33 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:40092 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab3H2Qnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:43:31 -0400
MIME-Version: 1.0
In-Reply-To: <1377615715-25699-1-git-send-email-dbarksdale@uplogix.com>
References: <1377615715-25699-1-git-send-email-dbarksdale@uplogix.com>
Date: Thu, 29 Aug 2013 18:43:31 +0200
Message-ID: <CANq1E4TGr54owuauUNyHqQ7GOiXf4wByWpaPTX28+SnqDsac+A@mail.gmail.com>
Subject: Re: [PATCH RESEND] HID: New hid-cp2112 driver.
From: David Herrmann <dh.herrmann@gmail.com>
To: David Barksdale <dbarksdale@uplogix.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Aug 27, 2013 at 5:01 PM, David Barksdale <dbarksdale@uplogix.com> wrote:
> This patch adds support for the Silicon Labs CP2112
> "Single-Chip HID USB to SMBus Master Bridge."
>
> I wrote this to support a USB temperature and humidity
> sensor I've been working on. It's been tested by using
> SMBus byte-read, byte-data-read/write, and word-data-read
> transfer modes to talk to an I2C sensor. The other
> transfer modes have not been tested.
>
> Signed-off-by: David Barksdale <dbarksdale@uplogix.com>
>
> ---
>  drivers/hid/Kconfig      |   6 +
>  drivers/hid/Makefile     |   1 +
>  drivers/hid/hid-core.c   |   3 +
>  drivers/hid/hid-cp2112.c | 504 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 514 insertions(+)
>
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 14ef6ab..1833948 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -175,6 +175,12 @@ config HID_PRODIKEYS
>           multimedia keyboard, but will lack support for the musical keyboard
>           and some additional multimedia keys.
>
> +config HID_CP2112
> +       tristate "Silicon Labs CP2112 HID USB-to-SMBus Bridge support"
> +       depends on USB_HID
> +       ---help---
> +       Support for Silicon Labs CP2112 HID USB to SMBus Master Bridge.
> +
>  config HID_CYPRESS
>         tristate "Cypress mouse and barcode readers" if EXPERT
>         depends on HID
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index 6f68728..a88a5c4 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -41,6 +41,7 @@ obj-$(CONFIG_HID_AUREAL)        += hid-aureal.o
>  obj-$(CONFIG_HID_BELKIN)       += hid-belkin.o
>  obj-$(CONFIG_HID_CHERRY)       += hid-cherry.o
>  obj-$(CONFIG_HID_CHICONY)      += hid-chicony.o
> +obj-$(CONFIG_HID_CP2112)       += hid-cp2112.o
>  obj-$(CONFIG_HID_CYPRESS)      += hid-cypress.o
>  obj-$(CONFIG_HID_DRAGONRISE)   += hid-dr.o
>  obj-$(CONFIG_HID_EMS_FF)       += hid-emsff.o
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 36668d1..b472a0d 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1568,6 +1568,9 @@ static const struct hid_device_id hid_have_special_driver[] = {
>         { HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS2) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_AK1D) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_CREATIVELABS, USB_DEVICE_ID_PRODIKEYS_PCMIDI) },
> +#if IS_ENABLED(CONFIG_HID_CP2112)
> +       { HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, 0xEA90) },
> +#endif

Why is that #if needed?

>         { HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_1) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_2) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_3) },
> diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
> new file mode 100644
> index 0000000..8737d18
> --- /dev/null
> +++ b/drivers/hid/hid-cp2112.c
> @@ -0,0 +1,504 @@
> +/*
> +  hid-cp2112.c - Silicon Labs HID USB to SMBus master bridge
> +  Copyright (c) 2013 Uplogix, Inc.
> +  David Barksdale <dbarksdale@uplogix.com>
> +
> +  This program is free software; you can redistribute it and/or modify
> +  it under the terms of the GNU General Public License as published by
> +  the Free Software Foundation; either version 2 of the License, or
> +  (at your option) any later version.
> +
> +  This program is distributed in the hope that it will be useful,
> +  but WITHOUT ANY WARRANTY; without even the implied warranty of
> +  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +  GNU General Public License for more details.
> +
> +  You should have received a copy of the GNU General Public License
> +  along with this program; if not, write to the Free Software
> +  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/hid.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include "hid-ids.h"
> +
> +enum {
> +       GET_VERSION_INFO = 0x05,
> +       SMBUS_CONFIG = 0x06,
> +       DATA_READ_REQUEST = 0x10,
> +       DATA_WRITE_READ_REQUEST = 0x11,
> +       DATA_READ_FORCE_SEND = 0x12,
> +       DATA_READ_RESPONSE = 0x13,
> +       DATA_WRITE_REQUEST = 0x14,
> +       TRANSFER_STATUS_REQUEST = 0x15,
> +       TRANSFER_STATUS_RESPONSE = 0x16,
> +       CANCEL_TRANSFER = 0x17,
> +};
> +
> +enum {
> +       STATUS0_IDLE = 0x00,
> +       STATUS0_BUSY = 0x01,
> +       STATUS0_COMPLETE = 0x02,
> +       STATUS0_ERROR = 0x03,
> +};
> +
> +enum {
> +       STATUS1_TIMEOUT_NACK = 0x00,
> +       STATUS1_TIMEOUT_BUS = 0x01,
> +       STATUS1_ARBITRATION_LOST = 0x02,
> +       STATUS1_READ_INCOMPLETE = 0x03,
> +       STATUS1_WRITE_INCOMPLETE = 0x04,
> +       STATUS1_SUCCESS = 0x05,
> +};

If you don't add any prefix to these functions (especially
SMBUS_CONFIG) it is quite likely that at some point your driver will
get compile-errors. Any particular reason not to do that? (same
applies to all the function/global-vars below)

> +
> +/* All values are in big-endian */
> +struct __attribute__ ((__packed__)) smbus_config {
> +       uint32_t clock_speed; /* Hz */
> +       uint8_t device_address; /* Stored in the upper 7 bits */
> +       uint8_t auto_send_read; /* 1 = enabled, 0 = disabled */
> +       uint16_t write_timeout; /* ms, 0 = no timeout */
> +       uint16_t read_timeout; /* ms, 0 = no timeout */
> +       uint8_t scl_low_timeout; /* 1 = enabled, 0 = disabled */
> +       uint16_t retry_time; /* # of retries, 0 = no limit */
> +};
> +
> +static const int MAX_TIMEOUT = 100;
> +
> +static const struct hid_device_id cp2112_devices[] = {
> +       { HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, 0xEA90) },

You might want to add a
#define USB_PRODUCT_ID_CYGNAL_CP2112 0xEA90
to drivers/hid/hid-ids.h to avoid this magic-number here and in hid-core.c.

> +       { }
> +};
> +MODULE_DEVICE_TABLE(hid, cp2112_devices);
> +
> +struct cp2112_device {
> +       struct i2c_adapter adap;
> +       struct hid_device *hdev;
> +       wait_queue_head_t wait;
> +       uint8_t read_data[61];
> +       uint8_t read_length;
> +       int xfer_status;
> +       atomic_t read_avail;
> +       atomic_t xfer_avail;
> +};
> +
> +static int cp2112_wait(struct cp2112_device *dev, atomic_t *avail)
> +{
> +       int ret = 0;
> +
> +       ret = wait_event_interruptible_timeout(dev->wait,
> +               atomic_read(avail), msecs_to_jiffies(50));
> +       if (-ERESTARTSYS == ret)
> +               return ret;
> +       if (!ret)
> +               return -ETIMEDOUT;
> +       atomic_set(avail, 0);
> +       return 0;
> +}
> +
> +static int cp2112_xfer_status(struct cp2112_device *dev)
> +{
> +       struct hid_device *hdev = dev->hdev;
> +       uint8_t buf[2];
> +       int ret;
> +
> +       buf[0] = TRANSFER_STATUS_REQUEST;
> +       buf[1] = 0x01;
> +       atomic_set(&dev->xfer_avail, 0);
> +       ret = hdev->hid_output_raw_report(hdev, buf, 2, HID_OUTPUT_REPORT);
> +       if (ret < 0) {
> +               hid_warn(hdev, "Error requesting status: %d\n", ret);
> +               return ret;
> +       }
> +       ret = cp2112_wait(dev, &dev->xfer_avail);
> +       if (ret)
> +               return ret;
> +       return dev->xfer_status;
> +}
> +
> +static int cp2112_read(struct cp2112_device *dev, uint8_t *data, size_t size)
> +{
> +       struct hid_device *hdev = dev->hdev;
> +       uint8_t buf[3];
> +       int ret;
> +
> +       buf[0] = DATA_READ_FORCE_SEND;
> +       *(uint16_t *)&buf[1] = htons(size);
> +       atomic_set(&dev->read_avail, 0);
> +       ret = hdev->hid_output_raw_report(hdev, buf, 3, HID_OUTPUT_REPORT);
> +       if (ret < 0) {
> +               hid_warn(hdev, "Error requesting data: %d\n", ret);
> +               return ret;
> +       }
> +       ret = cp2112_wait(dev, &dev->read_avail);
> +       if (ret)
> +               return ret;
> +       hid_dbg(hdev, "read %d of %d bytes requested\n",
> +               dev->read_length, size);
> +       if (size > dev->read_length)
> +               size = dev->read_length;
> +       memcpy(data, dev->read_data, size);
> +       return dev->read_length;
> +}
> +
> +static int cp2112_xfer(struct i2c_adapter *adap, uint16_t addr,
> +       unsigned short flags, char read_write, uint8_t command,
> +       int size, union i2c_smbus_data *data)
> +{
> +       struct cp2112_device *dev = (struct cp2112_device *)adap->algo_data;
> +       struct hid_device *hdev = dev->hdev;
> +       uint8_t buf[64];
> +       size_t count;
> +       size_t read_length = 0;
> +       size_t write_length;
> +       size_t timeout;
> +       int ret;
> +
> +       hid_dbg(hdev, "%s addr 0x%x flags 0x%x cmd 0x%x size %d\n",
> +               read_write == I2C_SMBUS_WRITE ? "write" : "read",
> +               addr, flags, command, size);
> +       buf[1] = addr << 1;
> +       switch (size) {
> +       case I2C_SMBUS_BYTE:
> +               if (I2C_SMBUS_READ == read_write) {
> +                       read_length = 1;
> +                       buf[0] = DATA_READ_REQUEST;
> +                       *(uint16_t *)&buf[2] = htons(read_length);
> +                       count = 4;
> +               } else {
> +                       write_length = 1;
> +                       buf[0] = DATA_WRITE_REQUEST;
> +                       buf[2] = write_length;
> +                       buf[3] = data->byte;
> +                       count = 4;
> +               }
> +               break;
> +       case I2C_SMBUS_BYTE_DATA:
> +               if (I2C_SMBUS_READ == read_write) {
> +                       read_length = 1;
> +                       buf[0] = DATA_WRITE_READ_REQUEST;
> +                       *(uint16_t *)&buf[2] = htons(read_length);
> +                       buf[4] = 1;
> +                       buf[5] = command;
> +                       count = 6;
> +               } else {
> +                       write_length = 2;
> +                       buf[0] = DATA_WRITE_REQUEST;
> +                       buf[2] = write_length;
> +                       buf[3] = command;
> +                       buf[4] = data->byte;
> +                       count = 5;
> +               }
> +               break;
> +       case I2C_SMBUS_WORD_DATA:
> +               if (I2C_SMBUS_READ == read_write) {
> +                       read_length = 2;
> +                       buf[0] = DATA_WRITE_READ_REQUEST;
> +                       *(uint16_t *)&buf[2] = htons(read_length);
> +                       buf[4] = 1;
> +                       buf[5] = command;
> +                       count = 6;
> +               } else {
> +                       write_length = 3;
> +                       buf[0] = DATA_WRITE_REQUEST;
> +                       buf[2] = write_length;
> +                       buf[3] = command;
> +                       *(uint16_t *)&buf[4] = htons(data->word);
> +                       count = 6;
> +               }
> +               break;
> +       case I2C_SMBUS_PROC_CALL:
> +               size = I2C_SMBUS_WORD_DATA;
> +               read_write = I2C_SMBUS_READ;
> +               read_length = 2;
> +               write_length = 3;
> +               buf[0] = DATA_WRITE_READ_REQUEST;
> +               *(uint16_t *)&buf[2] = htons(read_length);
> +               buf[4] = write_length;
> +               buf[5] = command;
> +               *(uint16_t *)&buf[6] = data->word;
> +               count = 8;
> +               break;
> +       case I2C_SMBUS_I2C_BLOCK_DATA:
> +               size = I2C_SMBUS_BLOCK_DATA;
> +               /* fallthrough */
> +       case I2C_SMBUS_BLOCK_DATA:
> +               if (I2C_SMBUS_READ == read_write) {
> +                       buf[0] = DATA_WRITE_READ_REQUEST;
> +                       *(uint16_t *)&buf[2] = htons(I2C_SMBUS_BLOCK_MAX);
> +                       buf[4] = 1;
> +                       buf[5] = command;
> +                       count = 6;
> +               } else {
> +                       write_length = data->block[0];
> +                       if (write_length > 61 - 2)
> +                               return -EINVAL;
> +                       buf[0] = DATA_WRITE_REQUEST;
> +                       buf[2] = write_length + 2;
> +                       buf[3] = command;
> +                       memcpy(&buf[4], data->block, write_length + 1);
> +                       count = 5 + write_length;
> +               }
> +               break;
> +       case I2C_SMBUS_BLOCK_PROC_CALL:
> +               size = I2C_SMBUS_BLOCK_DATA;
> +               read_write = I2C_SMBUS_READ;
> +               write_length = data->block[0];
> +               if (write_length > 16 - 2)
> +                       return -EINVAL;
> +               buf[0] = DATA_WRITE_READ_REQUEST;
> +               *(uint16_t *)&buf[2] = htons(I2C_SMBUS_BLOCK_MAX);
> +               buf[4] = write_length + 2;
> +               buf[5] = command;
> +               memcpy(&buf[6], data->block, write_length + 1);
> +               count = 7 + write_length;

Isn't there a break; missing?

> +       default:
> +               hid_warn(hdev, "Unsupported transaction %d\n", size);
> +               return -EOPNOTSUPP;
> +       }
> +       ret = hid_hw_open(hdev);
> +       if (ret) {
> +               hid_err(hdev, "hw open failed\n");
> +               return ret;
> +       }
> +       ret = hid_hw_power(hdev, PM_HINT_FULLON);
> +       if (ret < 0) {
> +               hid_err(hdev, "power management error: %d\n", ret);
> +               goto hid_close;
> +       }
> +       ret = hdev->hid_output_raw_report(hdev, buf, count, HID_OUTPUT_REPORT);
> +       if (ret < 0) {
> +               hid_warn(hdev, "Error starting transaction: %d\n", ret);
> +               goto power_normal;
> +       }
> +       for (timeout = 0; timeout < MAX_TIMEOUT; ++timeout) {
> +               ret = cp2112_xfer_status(dev);
> +               if (-EBUSY == ret)
> +                       continue;
> +               if (ret < 0)
> +                       goto power_normal;
> +               break;
> +       }
> +       if (MAX_TIMEOUT <= timeout) {
> +               hid_warn(hdev, "Transfer timed out, cancelling.\n");
> +               buf[0] = CANCEL_TRANSFER;
> +               buf[1] = 0x01;
> +               ret = hdev->hid_output_raw_report(hdev, buf, 2,
> +                       HID_OUTPUT_REPORT);
> +               if (ret < 0) {
> +                       hid_warn(hdev, "Error cancelling transaction: %d\n",
> +                               ret);
> +               }
> +               ret = -ETIMEDOUT;
> +               goto power_normal;
> +       }
> +       if (I2C_SMBUS_WRITE == read_write) {
> +               ret = 0;
> +               goto power_normal;
> +       }
> +       if (I2C_SMBUS_BLOCK_DATA == size)
> +               read_length = ret;
> +       ret = cp2112_read(dev, buf, read_length);
> +       if (ret < 0)
> +               goto power_normal;
> +       if (ret != read_length) {
> +               hid_warn(hdev, "short read: %d < %d\n", ret, read_length);
> +               ret = -EIO;
> +               goto power_normal;
> +       }
> +       switch (size) {
> +       case I2C_SMBUS_BYTE:
> +       case I2C_SMBUS_BYTE_DATA:
> +               data->byte = buf[0];
> +               break;
> +       case I2C_SMBUS_WORD_DATA:
> +               data->word = ntohs(*(uint16_t *)buf);
> +               break;
> +       case I2C_SMBUS_BLOCK_DATA:
> +               if (read_length > I2C_SMBUS_BLOCK_MAX) {
> +                       ret = -EPROTO;
> +                       goto power_normal;
> +               }
> +               memcpy(data->block, buf, read_length);
> +               break;
> +       }
> +       ret = 0;
> +power_normal:
> +       hid_hw_power(hdev, PM_HINT_NORMAL);
> +hid_close:
> +       hid_hw_close(hdev);
> +       hid_dbg(hdev, "transfer finished: %d\n", ret);
> +       return ret;
> +}
> +
> +static uint32_t cp2122_functionality(struct i2c_adapter *adap)
> +{
> +       return I2C_FUNC_SMBUS_BYTE |
> +               I2C_FUNC_SMBUS_BYTE_DATA |
> +               I2C_FUNC_SMBUS_WORD_DATA |
> +               I2C_FUNC_SMBUS_BLOCK_DATA |
> +               I2C_FUNC_SMBUS_I2C_BLOCK |
> +               I2C_FUNC_SMBUS_PROC_CALL |
> +               I2C_FUNC_SMBUS_BLOCK_PROC_CALL;
> +}
> +
> +static const struct i2c_algorithm smbus_algorithm = {
> +       .smbus_xfer     = cp2112_xfer,
> +       .functionality  = cp2122_functionality,
> +};
> +
> +static int
> +cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
> +{
> +       struct cp2112_device *dev;
> +       uint8_t buf[64];
> +       struct smbus_config *config;
> +       int ret;
> +
> +       ret = hid_parse(hdev);
> +       if (ret) {
> +               hid_err(hdev, "parse failed\n");
> +               return ret;
> +       }
> +       ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);

Use HID_CONNECT_HIDRAW or does your device provide more than just the
smbus bridge?

> +       if (ret) {
> +               hid_err(hdev, "hw start failed\n");
> +               return ret;
> +       }

You must call hid_hw_open() here, otherwise I/O is not guaranteed to
be possible. It might work for USB now, but you shouldn't do that.
Either call hid_hw_close() after setup is done, or call it in
remove().

> +       ret = hdev->hid_get_raw_report(hdev, GET_VERSION_INFO, buf, 3,
> +               HID_FEATURE_REPORT);
> +       if (ret != 3) {
> +               hid_err(hdev, "error requesting version\n");
> +               return ret;

return (ret < 0) ? ret : -EIO;

And call hid_hw_stop() before returning, please (and hid_hw_close()).

> +       }
> +       hid_info(hdev, "Part Number: 0x%02X Device Version: 0x%02X\n",
> +               buf[1], buf[2]);
> +       ret = hdev->hid_get_raw_report(hdev, SMBUS_CONFIG, buf,
> +               sizeof(*config) + 1, HID_FEATURE_REPORT);
> +       if (ret != sizeof(*config) + 1) {
> +               hid_err(hdev, "error requesting SMBus config\n");
> +               return ret;

same as above

> +       }
> +       config = (struct smbus_config *)&buf[1];
> +       config->retry_time = htons(1);
> +       ret = hdev->hid_output_raw_report(hdev, buf,
> +               sizeof(*config) + 1, HID_FEATURE_REPORT);
> +       if (ret != sizeof(*config) + 1) {
> +               hid_err(hdev, "error setting SMBus config\n");
> +               return ret;

same as above

> +       }
> +       dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +       if (!dev) {
> +               hid_err(hdev, "out of memory\n");
> +               return -ENOMEM;

hid_hw_stop() missing (and hid_hw_close())

> +       }
> +       dev->hdev = hdev;
> +       hid_set_drvdata(hdev, (void *)dev);
> +       dev->adap.owner         = THIS_MODULE;
> +       dev->adap.class         = I2C_CLASS_HWMON;
> +       dev->adap.algo          = &smbus_algorithm;
> +       dev->adap.algo_data     = dev;
> +       snprintf(dev->adap.name, sizeof(dev->adap.name),
> +               "CP2112 SMBus Bridge on hiddev%d", hdev->minor);
> +       init_waitqueue_head(&dev->wait);
> +       hid_device_io_start(hdev);
> +       ret = i2c_add_adapter(&dev->adap);
> +       hid_device_io_stop(hdev);

You should call hid_device_io_stop() only on failure. Otherwise,
hid-core drops any incoming events until you return. If smbus can
handle missing events, this is fine.

In case you don't care for I/O between this and your handler above,
you can call hid_hw_close() here. Note that ->raw_event() is only
called while the device is open.

> +       if (ret) {
> +               hid_err(hdev, "error registering i2c adapter\n");
> +               kfree(dev);
> +               hid_set_drvdata(hdev, NULL);

Drop this hid_set_drvdata()
hid_hw_stop() missing (and hid_hw_close())

> +       }
> +       hid_dbg(hdev, "adapter registered\n");
> +       return ret;
> +}
> +
> +static void cp2112_remove(struct hid_device *hdev)
> +{
> +       struct cp2112_device *dev = hid_get_drvdata(hdev);
> +
> +       if (dev) {

Why if (dev)? Any reason dev might be NULL?

> +               i2c_del_adapter(&dev->adap);
> +               wake_up_interruptible(&dev->wait);

How can you have waiters on dev->wait if you free() it in the line
below? There ought to be some *_sync() call here which waits for all
possible pending calls to finish.

> +               kfree(dev);
> +               hid_set_drvdata(hdev, NULL);

Not needed.

> +       }
> +       hid_hw_stop(hdev);

I recommend calling hid_hw_stop() before destroying your context. Not
strictly needed, but it makes it clear that no I/O is possible during
_remove().

So you can reduce this function to:

hid_hw_stop(hdev);
i2c_del_adapter(&dev->adap);
wake_up_interruptible(&dev->wait);
your_whatever_wait_sync_call()
kfree(dev);

> +}
> +
> +static int cp2112_raw_event(struct hid_device *hdev, struct hid_report *report,
> +       uint8_t *data, int size)
> +{
> +       struct cp2112_device *dev = hid_get_drvdata(hdev);
> +
> +       switch (data[0]) {
> +       case TRANSFER_STATUS_RESPONSE:
> +               hid_dbg(hdev, "xfer status: %02x %02x %04x %04x\n",
> +                       data[1], data[2], htons(*(uint16_t *)&data[3]),
> +                       htons(*(uint16_t *)&data[5]));
> +               switch (data[1]) {
> +               case STATUS0_IDLE:
> +                       dev->xfer_status = -EAGAIN;
> +                       break;
> +               case STATUS0_BUSY:
> +                       dev->xfer_status = -EBUSY;
> +                       break;
> +               case STATUS0_COMPLETE:
> +                       dev->xfer_status = ntohs(*(uint16_t *)&data[5]);
> +                       break;
> +               case STATUS0_ERROR:
> +                       switch (data[2]) {
> +                       case STATUS1_TIMEOUT_NACK:
> +                       case STATUS1_TIMEOUT_BUS:
> +                               dev->xfer_status = -ETIMEDOUT;
> +                               break;
> +                       default:
> +                               dev->xfer_status = -EIO;
> +                       }
> +                       break;
> +               default:
> +                       dev->xfer_status = -EINVAL;
> +                       break;
> +               }
> +               atomic_set(&dev->xfer_avail, 1);
> +               break;
> +       case DATA_READ_RESPONSE:
> +               hid_dbg(hdev, "read response: %02x %02x\n", data[1], data[2]);
> +               dev->read_length = data[2];
> +               if (dev->read_length > sizeof(dev->read_data))
> +                       dev->read_length = sizeof(dev->read_data);
> +               memcpy(dev->read_data, &data[3], dev->read_length);
> +               atomic_set(&dev->read_avail, 1);
> +               break;
> +       default:
> +               hid_err(hdev, "unknown report\n");
> +               return 0;
> +       }
> +       wake_up_interruptible(&dev->wait);
> +       return 1;
> +}
> +
> +static struct hid_driver cp2112_driver = {
> +       .name = "cp2112",
> +       .id_table = cp2112_devices,
> +       .probe = cp2112_probe,
> +       .remove = cp2112_remove,
> +       .raw_event = cp2112_raw_event,
> +};
> +
> +static int __init cp2112_init(void)
> +{
> +       return hid_register_driver(&cp2112_driver);
> +}
> +
> +static void __exit cp2112_exit(void)
> +{
> +       hid_unregister_driver(&cp2112_driver);
> +}
> +
> +module_init(cp2112_init);
> +module_exit(cp2112_exit);

Use:
module_hid_driver(&cp2112_driver);
to save some lines here.

Cheers
David

> +MODULE_DESCRIPTION("Silicon Labs HID USB to SMBus master bridge");
> +MODULE_AUTHOR("David Barksdale <dbarksdale@uplogix.com>");
> +MODULE_LICENSE("GPL");
> +
> --
> tg: (584d88b..) upstream/hid-cp2112 (depends on: upstream/master)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
