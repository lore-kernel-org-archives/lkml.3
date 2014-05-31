Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbaEaXiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 19:38:23 -0400
Received: from donald.hachti.de ([188.40.85.216]:36973 "EHLO donald.hachti.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754AbaEaXiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 19:38:20 -0400
From: Philipp Hachtmann <hachti@hachti.de>
To: jhovold@gmail.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Philipp Hachtmann <hachti@hachti.de>
Subject: [PATCH 1/2] usb/ftdi_sio: Add synchronous FIFO mode support for FT232H
Date: Sun,  1 Jun 2014 01:31:05 +0200
Message-Id: <1401579066-8298-2-git-send-email-hachti@hachti.de>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1401579066-8298-1-git-send-email-hachti@hachti.de>
References: <1401579066-8298-1-git-send-email-hachti@hachti.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the synchronous FIFO mode of the FT232H
serial converter chip.
This might also be extended to be usable with other FTDI chips.

Signed-off-by: Philipp Hachtmann <hachti@hachti.de>
---
 drivers/usb/serial/ftdi_sio.c | 65 +++++++++++++++++++++++++++++++++++++++++--
 drivers/usb/serial/ftdi_sio.h | 15 ++++++++++
 2 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 7c6e1de..cacba4a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -73,7 +73,7 @@ struct ftdi_private {
 				   this value */
 	int force_rtscts;	/* if non-zero, force RTS-CTS to always
 				   be enabled */
-
+	int syncmode;           /* FIFO device in synchronous 245 mode */
 	unsigned int latency;		/* latency setting in use */
 	unsigned short max_packet_size;
 	struct mutex cfg_lock; /* Avoid mess by parallel calls of config ioctl() and change_speed() */
@@ -1327,6 +1327,36 @@ static int change_speed(struct tty_struct *tty, struct usb_serial_port *port)
 	return rv;
 }
 
+static int set_syncmode(struct usb_serial_port *port, int enable)
+{
+	struct ftdi_private *priv = usb_get_serial_port_data(port);
+
+	__u16 urb_value = 0;
+	int rv = 0;
+
+	enable = enable ? 1 : 0;
+	if (enable == priv->syncmode)
+		return 0;
+
+	priv->syncmode = enable;
+
+	/* FTDI seems to say that the urb_value should be or'ed with 0xff. But
+	 * when done this way the port gets quite slow. 0x00 seems to work much
+	 * better.
+	 */
+	if (enable)
+		urb_value = FTDI_BITMODE_SYNCFIFO << 8 | 0x00;
+
+	rv = usb_control_msg(port->serial->dev,
+			     usb_sndctrlpipe(port->serial->dev, 0),
+			     FTDI_SIO_SET_BITBANG_REQUEST,
+			     FTDI_SIO_SET_BITBANG_REQUEST_TYPE,
+			     urb_value, priv->interface,
+			     NULL, 0, WDR_SHORT_TIMEOUT);
+
+	return rv;
+}
+
 static int write_latency_timer(struct usb_serial_port *port)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
@@ -1628,6 +1658,32 @@ static ssize_t latency_timer_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(latency_timer);
 
+static ssize_t syncmode_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct usb_serial_port *port = to_usb_serial_port(dev);
+	struct ftdi_private *priv = usb_get_serial_port_data(port);
+	return sprintf(buf, "%i\n", priv->syncmode);
+}
+
+static ssize_t syncmode_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *valbuf, size_t count)
+{
+	unsigned long value;
+	int rv;
+	struct usb_serial_port *port = to_usb_serial_port(dev);
+	int ret = kstrtoul(valbuf, 0, &value);
+	if (ret)
+		return -EINVAL;
+
+	rv = set_syncmode(port, value);
+	if (rv < 0)
+		return -EIO;
+	return count;
+}
+static DEVICE_ATTR_RW(syncmode);
+
 /* Write an event character directly to the FTDI register.  The ASCII
    value is in the low 8 bits, with the enable bit in the 9th bit. */
 static ssize_t store_event_char(struct device *dev,
@@ -1678,6 +1734,10 @@ static int create_sysfs_attrs(struct usb_serial_port *port)
 						    &dev_attr_latency_timer);
 		}
 	}
+	if ((!retval) && priv->chip_type == FT232H) {
+		retval = device_create_file(&port->dev,
+					    &dev_attr_syncmode);
+	}
 	return retval;
 }
 
@@ -1698,7 +1758,8 @@ static void remove_sysfs_attrs(struct usb_serial_port *port)
 			device_remove_file(&port->dev, &dev_attr_latency_timer);
 		}
 	}
-
+	if (priv->chip_type == FT232H)
+		device_remove_file(&port->dev, &dev_attr_syncmode);
 }
 
 /*
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index ed58c6f..04a29f8 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -35,6 +35,7 @@
 #define FTDI_SIO_SET_ERROR_CHAR		7 /* Set the error character */
 #define FTDI_SIO_SET_LATENCY_TIMER	9 /* Set the latency timer */
 #define FTDI_SIO_GET_LATENCY_TIMER	10 /* Get the latency timer */
+#define FTDI_SIO_SET_BITBANG            11 /* Set the bitbang mode */
 
 /* Interface indices for FT2232, FT2232H and FT4232H devices */
 #define INTERFACE_A		1
@@ -345,6 +346,20 @@ enum ftdi_sio_baudrate {
  */
 
 /*
+ * FTDI_SIO_SET_BITBANG
+ *
+ * Set the chip's bitbang mode. Used to switch FT232H (which else?) into
+ * synchronous FIFO mode which cannot be configured in the eeprom.
+ *
+ */
+
+#define FTDI_SIO_SET_BITBANG_REQUEST FTDI_SIO_SET_BITBANG
+#define FTDI_SIO_SET_BITBANG_REQUEST_TYPE 0x40
+
+#define FTDI_BITMODE_RESET     0x00  /* Switch back to normal operation */
+#define FTDI_BITMODE_SYNCFIFO  0x40  /* Switch to syncronous FIFO mode  */
+
+/*
  * FTDI_SIO_SET_EVENT_CHAR
  *
  * Set the special event character for the specified communications port.
-- 
2.0.0.rc2

