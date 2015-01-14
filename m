Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbbANCHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:07:30 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61333 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbbANCH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:07:29 -0500
MIME-Version: 1.0
In-Reply-To: <20150114013350.GA11620@kroah.com>
References: <1421198202-4042-1-git-send-email-eu@felipetonello.com>
	<20150114013350.GA11620@kroah.com>
Date: Tue, 13 Jan 2015 18:07:27 -0800
Message-ID: <CAGrhNMyEJgc5PB2y292PLyi52KO+zSxLPCjj3bANmkcsNDURwg@mail.gmail.com>
Subject: Re: [PATCH] char: Added support for u-blox 6 i2c gps driver
From: Felipe Tonello <eu@felipetonello.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Jan 13, 2015 at 5:33 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jan 13, 2015 at 05:16:42PM -0800, Felipe F. Tonello wrote:
>> This driver will basically translate serial communication to i2c communication
>> between the user-space and the GPS module.
>>
>> It creates a /dev/ttyS device node.
>>
>> There are specific tty termios flags in order to the tty line discipliner not
>> to change the date it is pushed to user space.
>
> I don't understand this sentance, what date?  What is pushed where?
> What termios files?  What is a "discipliner"?

Some typos here, I will fix it and try to explain it better.

>
>> That is necessary so the NMEA
>> data is not corrupted.
>> * iflags: added IGNCR: Ignore carriage return on input.
>> * oflags: removed ONLCR: (XSI) Map NL to CR-NL on output.
>>
>> Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
>> ---
>>  drivers/tty/serial/Kconfig          |   9 ++
>>  drivers/tty/serial/Makefile         |   1 +
>>  drivers/tty/serial/ublox6-gps-i2c.c | 245 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 255 insertions(+)
>>  create mode 100644 drivers/tty/serial/ublox6-gps-i2c.c
>>
>> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
>> index 26cec64..49913eb 100644
>> --- a/drivers/tty/serial/Kconfig
>> +++ b/drivers/tty/serial/Kconfig
>> @@ -1552,6 +1552,15 @@ config SERIAL_MEN_Z135
>>         This driver can also be build as a module. If so, the module will be called
>>         men_z135_uart.ko
>>
>> +config SERIAL_UBLOX_GPS
>> +     tristate "u-blox 6 I2C GPS support"
>> +     depends on I2C
>> +     default n
>> +     help
>> +       This driver uses i2c to communicate with the u-blox 6 GPS module
>> +       and has a serial tty device interface to the user-space, making
>> +       it easy to read/write data from/to the GPS.
>> +
>>  endmenu
>>
>>  config SERIAL_MCTRL_GPIO
>> diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
>> index 0080cc3..cba2b5c 100644
>> --- a/drivers/tty/serial/Makefile
>> +++ b/drivers/tty/serial/Makefile
>> @@ -92,6 +92,7 @@ obj-$(CONFIG_SERIAL_ARC)    += arc_uart.o
>>  obj-$(CONFIG_SERIAL_RP2)     += rp2.o
>>  obj-$(CONFIG_SERIAL_FSL_LPUART)      += fsl_lpuart.o
>>  obj-$(CONFIG_SERIAL_MEN_Z135)        += men_z135_uart.o
>> +obj-$(CONFIG_SERIAL_UBLOX_GPS) += ublox6-gps-i2c.o
>>
>>  # GPIOLIB helpers for modem control lines
>>  obj-$(CONFIG_SERIAL_MCTRL_GPIO)      += serial_mctrl_gpio.o
>> diff --git a/drivers/tty/serial/ublox6-gps-i2c.c b/drivers/tty/serial/ublox6-gps-i2c.c
>> new file mode 100644
>> index 0000000..16dd1cf
>> --- /dev/null
>> +++ b/drivers/tty/serial/ublox6-gps-i2c.c
>> @@ -0,0 +1,245 @@
>> +/* u-blox 6 I2C GPS driver
>> + *
>> + * Copyright (C) 2015 Felipe F. Tonello <eu@felipetonello.com>
>> + *
>> + * Driver that translates a serial tty GPS device to a i2c GPS device
>
> I don't think there is a "serial tty GPS device" here, right?

No, it is a i2c device driver that translates to tty serial.

>
>
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/tty.h>
>> +#include <linux/tty_flip.h>
>> +#include <linux/i2c.h>
>> +#include <linux/workqueue.h>
>> +
>> +/*
>> + * Version Information
>> + */
>> +#define DRIVER_VERSION "v0.1"
>> +#define DRIVER_DESC "u-blox 6 I2C GPS driver"
>> +
>> +#define UBLOX_GPS_MAJOR 0
>> +#define UBLOX_GPS_NUM 1 /* Only support 1 GPS at a time */
>> +
>> +/* By default u-blox GPS fill its buffer every 1 second (1000 msecs) */
>> +#define READ_TIME 1000
>> +
>> +static struct tty_port *ublox_gps_tty_port;
>> +static struct i2c_client *ublox_gps_i2c_client;
>
> Why only one device/client?  Why can't you have more than one in the
> system?  Please don't make this work for only one device, these can all
> be device-private.

True.

>
>> +static int ublox_gps_is_open;
>
> Why do you need this?  And again, don't make it global for the whole
> driver, but unique per-device
>
>> +static struct file *ublox_gps_filp;
>
> I don't understand why you even need this, what problem is this solving?

See tty close operation.

>
>> +static void ublox_gps_read_worker(struct work_struct *private);
>> +
>> +static DECLARE_DELAYED_WORK(ublox_gps_wq, ublox_gps_read_worker);
>
> Again, make device-specific.
>
>> +static void ublox_gps_read_worker(struct work_struct *private)
>> +{
>> +     s32 gps_buf_size, buf_size = 0;
>> +     u8 *buf;
>> +
>> +     if (!ublox_gps_is_open)
>> +             return;
>
> How can this happen?

If the tty device is closed and there is a scheduled workqueue, then
this might happen.

>
>> +
>> +     /* check if driver was removed */
>> +     if (!ublox_gps_i2c_client)
>> +             return;
>
> How can this happen?

If tty device is open and user removes the module (if it is a module)
and there is a scheduled workqueue, then this might happen.

>
>> +
>> +     gps_buf_size = i2c_smbus_read_word_data(ublox_gps_i2c_client, 0xfd);
>> +     if (gps_buf_size < 0) {
>> +             dev_warn(&ublox_gps_i2c_client->dev, KBUILD_MODNAME ": couldn't read register(0xfd) from GPS.\n");
>
> Something to be fixed for all of your dev_*() calls, don't put
> KBUILD_MODNAME, it's not needed as dev_* handles everything properly to
> point to the specific driver and device that created the message.

Got it.

>
>
>> +             /* try one more time */
>> +             goto end;
>> +     }
>> +
>> +     /* 0xfd is the MSB and 0xfe is the LSB */
>> +     gps_buf_size = ((gps_buf_size & 0xf) << 8) | ((gps_buf_size & 0xf0) >> 8);
>
> I don't understand the comment here.

I'll improve.

>
>> +
>> +     if (gps_buf_size > 0) {
>> +
>> +             buf = kcalloc(gps_buf_size, sizeof(*buf), GFP_KERNEL);
>> +             if (!buf) {
>> +                     dev_warn(&ublox_gps_i2c_client->dev, KBUILD_MODNAME ": couldn't allocate memory.\n");
>
> No need to send any error if memory is gone, that already happened in
> the syslog.

Ok.

>
>> +                     /* try one more time */
>> +                     goto end;
>> +             }
>> +
>> +             do {
>> +                     buf_size = i2c_master_recv(ublox_gps_i2c_client, (char *)buf, gps_buf_size);
>> +                     if (buf_size < 0) {
>> +                             dev_warn(&ublox_gps_i2c_client->dev, KBUILD_MODNAME ": couldn't read data from GPS.\n");
>> +                             kfree(buf);
>> +                             /* try one more time */
>> +                             goto end;
>> +                     }
>> +
>> +                     tty_insert_flip_string(ublox_gps_tty_port, buf, buf_size);
>> +
>> +                     gps_buf_size -= buf_size;
>> +
>> +                     /* There is a small chance that we need to split the data over
>> +                        several buffers. If this is the case we must loop */
>> +             } while (unlikely(gps_buf_size > 0));
>> +
>> +             tty_flip_buffer_push(ublox_gps_tty_port);
>> +
>> +             kfree(buf);
>> +     }
>> +
>> +end:
>> +     /* resubmit the workqueue again */
>> +     schedule_delayed_work(&ublox_gps_wq, msecs_to_jiffies(READ_TIME)); /* 1 sec delay */
>> +}
>> +
>> +static int ublox_gps_serial_open(struct tty_struct *tty, struct file *filp)
>> +{
>> +     if (ublox_gps_is_open)
>> +             return -EBUSY;
>> +
>> +     ublox_gps_filp = filp;
>> +     ublox_gps_tty_port = tty->port;
>> +     ublox_gps_tty_port->low_latency = true; /* make sure we push data immediately */
>> +     ublox_gps_is_open = true;
>> +
>> +     schedule_delayed_work(&ublox_gps_wq, 0);
>> +
>> +     return 0;
>> +}
>> +
>> +static void ublox_gps_serial_close(struct tty_struct *tty, struct file *filp)
>> +{
>> +     if (!ublox_gps_is_open)
>
> How can this happen?

I am not sure. But it is better to check then having a unknown bug anyway.

>
>> +             return;
>> +
>> +     /* avoid stop when the denied (in open) file structure closes itself */
>> +     if (ublox_gps_filp != filp)
>> +             return;
>
> I don't understand, how can something "close itself"?

What happens is that this callback is called if a user tries to open
two ttyS for the GPS. The second will fail, calling the close, thus
calling this callback with different filp.
So I need to check if the close was really called by the first ttyS user.

>
>> +
>> +     ublox_gps_is_open = false;
>> +     ublox_gps_filp = NULL;
>> +     ublox_gps_tty_port = NULL;
>> +}
>> +
>> +static int ublox_gps_serial_write(struct tty_struct *tty, const unsigned char *buf,
>> +     int count)
>> +{
>> +     if (!ublox_gps_is_open)
>> +             return 0;
>> +
>> +     /* check if driver was removed */
>> +     if (!ublox_gps_i2c_client)
>> +             return 0;
>> +
>> +     /* we don't write back to the GPS so just return same value here */
>> +     return count;
>> +}
>
> So write does nothing, why even have it at all?

Because for some reason the tty layer was calling it anyway.

>
>> +static int ublox_gps_write_room(struct tty_struct *tty)
>> +{
>> +     if (!ublox_gps_is_open)
>> +             return 0;
>> +
>> +     /* check if driver was removed */
>> +     if (!ublox_gps_i2c_client)
>> +             return 0;
>> +
>> +     /* we don't write back to the GPS so just return some value here */
>> +     return 1024;
>
> Why have this function at all if it does nothing?

Same as the write.

>
>
>> +}
>> +
>> +static const struct tty_operations ublox_gps_serial_ops = {
>> +     .open = ublox_gps_serial_open,
>> +     .close = ublox_gps_serial_close,
>> +     .write = ublox_gps_serial_write,
>> +     .write_room = ublox_gps_write_room,
>> +};
>> +
>> +static struct tty_driver *ublox_gps_tty_driver;
>> +
>> +static int ublox_gps_probe(struct i2c_client *client,
>> +     const struct i2c_device_id *id)
>> +{
>> +     int result = 0;
>> +
>> +     ublox_gps_tty_driver = alloc_tty_driver(UBLOX_GPS_NUM);
>> +     if (!ublox_gps_tty_driver)
>> +             return -ENOMEM;
>> +
>> +     ublox_gps_tty_driver->owner = THIS_MODULE;
>> +     ublox_gps_tty_driver->driver_name = "ublox_gps";
>> +     ublox_gps_tty_driver->name = "ttyS";
>> +     ublox_gps_tty_driver->major = UBLOX_GPS_MAJOR;
>> +     ublox_gps_tty_driver->minor_start = 0;
>> +     ublox_gps_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
>> +     ublox_gps_tty_driver->subtype = SERIAL_TYPE_NORMAL;
>> +     ublox_gps_tty_driver->flags = TTY_DRIVER_REAL_RAW;
>> +     ublox_gps_tty_driver->init_termios = tty_std_termios;
>> +     ublox_gps_tty_driver->init_termios.c_iflag = IGNCR | IXON;
>> +     ublox_gps_tty_driver->init_termios.c_oflag = OPOST;
>> +     ublox_gps_tty_driver->init_termios.c_cflag = B9600 | CS8 | CREAD |
>> +             HUPCL | CLOCAL;
>> +     ublox_gps_tty_driver->init_termios.c_ispeed = 9600;
>> +     ublox_gps_tty_driver->init_termios.c_ospeed = 9600;
>> +     tty_set_operations(ublox_gps_tty_driver, &ublox_gps_serial_ops);
>> +     result = tty_register_driver(ublox_gps_tty_driver);
>> +     if (result) {
>> +             dev_err(&ublox_gps_i2c_client->dev, KBUILD_MODNAME ": %s - tty_register_driver failed\n",
>> +                     __func__);
>> +             goto err;
>> +     }
>> +
>> +     ublox_gps_i2c_client = client;
>> +     ublox_gps_filp = NULL;
>> +     ublox_gps_tty_port = NULL;
>> +     ublox_gps_is_open = false;
>> +
>> +     /* i2c_set_clientdata(client, NULL); */
>> +
>> +     dev_info(&ublox_gps_i2c_client->dev, KBUILD_MODNAME ": " DRIVER_VERSION ": "
>> +             DRIVER_DESC "\n");
>
> Be quiet for "normal" operations please, your driver should never send
> anything to the kernel log unless some error happens.

Got it.

>
> thanks,
>
> greg k-h
