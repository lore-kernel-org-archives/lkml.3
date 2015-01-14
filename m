Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbbANBQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 20:16:52 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62088 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbANBQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 20:16:51 -0500
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        "Felipe F. Tonello" <eu@felipetonello.com>
Subject: [PATCH] char: Added support for u-blox 6 i2c gps driver
Date: Tue, 13 Jan 2015 17:16:42 -0800
Message-Id: <1421198202-4042-1-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver will basically translate serial communication to i2c communication
between the user-space and the GPS module.

It creates a /dev/ttyS device node.

There are specific tty termios flags in order to the tty line discipliner not
to change the date it is pushed to user space. That is necessary so the NMEA
data is not corrupted.
* iflags: added IGNCR: Ignore carriage return on input.
* oflags: removed ONLCR: (XSI) Map NL to CR-NL on output.

Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
---
 drivers/tty/serial/Kconfig          |   9 ++
 drivers/tty/serial/Makefile         |   1 +
 drivers/tty/serial/ublox6-gps-i2c.c | 245 ++++++++++++++++++++++++++++++++++++
 3 files changed, 255 insertions(+)
 create mode 100644 drivers/tty/serial/ublox6-gps-i2c.c

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 26cec64..49913eb 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1552,6 +1552,15 @@ config SERIAL_MEN_Z135
 	  This driver can also be build as a module. If so, the module will be called
 	  men_z135_uart.ko
 
+config SERIAL_UBLOX_GPS
+	tristate "u-blox 6 I2C GPS support"
+	depends on I2C
+	default n
+	help
+	  This driver uses i2c to communicate with the u-blox 6 GPS module
+	  and has a serial tty device interface to the user-space, making
+	  it easy to read/write data from/to the GPS.
+
 endmenu
 
 config SERIAL_MCTRL_GPIO
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index 0080cc3..cba2b5c 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_SERIAL_ARC)	+= arc_uart.o
 obj-$(CONFIG_SERIAL_RP2)	+= rp2.o
 obj-$(CONFIG_SERIAL_FSL_LPUART)	+= fsl_lpuart.o
 obj-$(CONFIG_SERIAL_MEN_Z135)	+= men_z135_uart.o
+obj-$(CONFIG_SERIAL_UBLOX_GPS) += ublox6-gps-i2c.o
 
 # GPIOLIB helpers for modem control lines
 obj-$(CONFIG_SERIAL_MCTRL_GPIO)	+= serial_mctrl_gpio.o
diff --git a/drivers/tty/serial/ublox6-gps-i2c.c b/drivers/tty/serial/ublox6-gps-i2c.c
new file mode 100644
index 0000000..16dd1cf
--- /dev/null
+++ b/drivers/tty/serial/ublox6-gps-i2c.c
@@ -0,0 +1,245 @@
+/* u-blox 6 I2C GPS driver
+ *
+ * Copyright (C) 2015 Felipe F. Tonello <eu@felipetonello.com>
+ *
+ * Driver that translates a serial tty GPS device to a i2c GPS device
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+
+/*
+ * Version Information
+ */
+#define DRIVER_VERSION "v0.1"
+#define DRIVER_DESC "u-blox 6 I2C GPS driver"
+
+#define UBLOX_GPS_MAJOR 0
+#define UBLOX_GPS_NUM 1 /* Only support 1 GPS at a time */
+
+/* By default u-blox GPS fill its buffer every 1 second (1000 msecs) */
+#define READ_TIME 1000
+
+static struct tty_port *ublox_gps_tty_port;
+static struct i2c_client *ublox_gps_i2c_client;
+static int ublox_gps_is_open;
+static struct file *ublox_gps_filp;
+
+static void ublox_gps_read_worker(struct work_struct *private);
+
+static DECLARE_DELAYED_WORK(ublox_gps_wq, ublox_gps_read_worker);
+
+static void ublox_gps_read_worker(struct work_struct *private)
+{
+	s32 gps_buf_size, buf_size = 0;
+	u8 *buf;
+
+	if (!ublox_gps_is_open)
+		return;
+
+	/* check if driver was removed */
+	if (!ublox_gps_i2c_client)
+		return;
+
+	gps_buf_size = i2c_smbus_read_word_data(ublox_gps_i2c_client, 0xfd);
+	if (gps_buf_size < 0) {
+		dev_warn(&ublox_gps_i2c_client->dev, KBUILD_MODNAME ": couldn't read register(0xfd) from GPS.\n");
+		/* try one more time */
+		goto end;
+	}
+
+	/* 0xfd is the MSB and 0xfe is the LSB */
+	gps_buf_size = ((gps_buf_size & 0xf) << 8) | ((gps_buf_size & 0xf0) >> 8);
+
+	if (gps_buf_size > 0) {
+
+		buf = kcalloc(gps_buf_size, sizeof(*buf), GFP_KERNEL);
+		if (!buf) {
+			dev_warn(&ublox_gps_i2c_client->dev, KBUILD_MODNAME ": couldn't allocate memory.\n");
+			/* try one more time */
+			goto end;
+		}
+
+		do {
+			buf_size = i2c_master_recv(ublox_gps_i2c_client, (char *)buf, gps_buf_size);
+			if (buf_size < 0) {
+				dev_warn(&ublox_gps_i2c_client->dev, KBUILD_MODNAME ": couldn't read data from GPS.\n");
+				kfree(buf);
+				/* try one more time */
+				goto end;
+			}
+
+			tty_insert_flip_string(ublox_gps_tty_port, buf, buf_size);
+
+			gps_buf_size -= buf_size;
+
+			/* There is a small chance that we need to split the data over
+			   several buffers. If this is the case we must loop */
+		} while (unlikely(gps_buf_size > 0));
+
+		tty_flip_buffer_push(ublox_gps_tty_port);
+
+		kfree(buf);
+	}
+
+end:
+	/* resubmit the workqueue again */
+	schedule_delayed_work(&ublox_gps_wq, msecs_to_jiffies(READ_TIME)); /* 1 sec delay */
+}
+
+static int ublox_gps_serial_open(struct tty_struct *tty, struct file *filp)
+{
+	if (ublox_gps_is_open)
+		return -EBUSY;
+
+	ublox_gps_filp = filp;
+	ublox_gps_tty_port = tty->port;
+	ublox_gps_tty_port->low_latency = true; /* make sure we push data immediately */
+	ublox_gps_is_open = true;
+
+	schedule_delayed_work(&ublox_gps_wq, 0);
+
+	return 0;
+}
+
+static void ublox_gps_serial_close(struct tty_struct *tty, struct file *filp)
+{
+	if (!ublox_gps_is_open)
+		return;
+
+	/* avoid stop when the denied (in open) file structure closes itself */
+	if (ublox_gps_filp != filp)
+		return;
+
+	ublox_gps_is_open = false;
+	ublox_gps_filp = NULL;
+	ublox_gps_tty_port = NULL;
+}
+
+static int ublox_gps_serial_write(struct tty_struct *tty, const unsigned char *buf,
+	int count)
+{
+	if (!ublox_gps_is_open)
+		return 0;
+
+	/* check if driver was removed */
+	if (!ublox_gps_i2c_client)
+		return 0;
+
+	/* we don't write back to the GPS so just return same value here */
+	return count;
+}
+
+static int ublox_gps_write_room(struct tty_struct *tty)
+{
+	if (!ublox_gps_is_open)
+		return 0;
+
+	/* check if driver was removed */
+	if (!ublox_gps_i2c_client)
+		return 0;
+
+	/* we don't write back to the GPS so just return some value here */
+	return 1024;
+}
+
+static const struct tty_operations ublox_gps_serial_ops = {
+	.open = ublox_gps_serial_open,
+	.close = ublox_gps_serial_close,
+	.write = ublox_gps_serial_write,
+	.write_room = ublox_gps_write_room,
+};
+
+static struct tty_driver *ublox_gps_tty_driver;
+
+static int ublox_gps_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	int result = 0;
+
+	ublox_gps_tty_driver = alloc_tty_driver(UBLOX_GPS_NUM);
+	if (!ublox_gps_tty_driver)
+		return -ENOMEM;
+
+	ublox_gps_tty_driver->owner = THIS_MODULE;
+	ublox_gps_tty_driver->driver_name = "ublox_gps";
+	ublox_gps_tty_driver->name = "ttyS";
+	ublox_gps_tty_driver->major = UBLOX_GPS_MAJOR;
+	ublox_gps_tty_driver->minor_start = 0;
+	ublox_gps_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
+	ublox_gps_tty_driver->subtype = SERIAL_TYPE_NORMAL;
+	ublox_gps_tty_driver->flags = TTY_DRIVER_REAL_RAW;
+	ublox_gps_tty_driver->init_termios = tty_std_termios;
+	ublox_gps_tty_driver->init_termios.c_iflag = IGNCR | IXON;
+	ublox_gps_tty_driver->init_termios.c_oflag = OPOST;
+	ublox_gps_tty_driver->init_termios.c_cflag = B9600 | CS8 | CREAD |
+		HUPCL | CLOCAL;
+	ublox_gps_tty_driver->init_termios.c_ispeed = 9600;
+	ublox_gps_tty_driver->init_termios.c_ospeed = 9600;
+	tty_set_operations(ublox_gps_tty_driver, &ublox_gps_serial_ops);
+	result = tty_register_driver(ublox_gps_tty_driver);
+	if (result) {
+		dev_err(&ublox_gps_i2c_client->dev, KBUILD_MODNAME ": %s - tty_register_driver failed\n",
+			__func__);
+		goto err;
+	}
+
+	ublox_gps_i2c_client = client;
+	ublox_gps_filp = NULL;
+	ublox_gps_tty_port = NULL;
+	ublox_gps_is_open = false;
+
+	/* i2c_set_clientdata(client, NULL); */
+
+	dev_info(&ublox_gps_i2c_client->dev, KBUILD_MODNAME ": " DRIVER_VERSION ": "
+		DRIVER_DESC "\n");
+
+	return result;
+
+err:
+	dev_err(&ublox_gps_i2c_client->dev, KBUILD_MODNAME ": %s - returning with error %d\n",
+		__func__, result);
+
+	put_tty_driver(ublox_gps_tty_driver);
+
+	return result;
+}
+
+static int ublox_gps_remove(struct i2c_client *client)
+{
+	tty_unregister_driver(ublox_gps_tty_driver);
+	put_tty_driver(ublox_gps_tty_driver);
+
+	ublox_gps_i2c_client = NULL;
+
+	return 0;
+}
+
+static const struct i2c_device_id ublox_gps_id[] = {
+	{ "ublox_gps", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, ublox_gps_id);
+
+static struct i2c_driver ublox_gps_i2c_driver = {
+	.driver = {
+		.name  = "ublox_gps",
+		.owner = THIS_MODULE,
+	},
+	.id_table  = ublox_gps_id,
+	.probe     = ublox_gps_probe,
+	.remove    = ublox_gps_remove,
+};
+
+module_i2c_driver(ublox_gps_i2c_driver);
+
+MODULE_AUTHOR("Felipe F. Tonello <eu@felipetonello.com>");
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL");
-- 
1.9.3

