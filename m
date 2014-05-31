Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbaEaXiY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 19:38:24 -0400
Received: from donald.hachti.de ([188.40.85.216]:36975 "EHLO donald.hachti.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbaEaXiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 19:38:20 -0400
From: Philipp Hachtmann <hachti@hachti.de>
To: jhovold@gmail.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Philipp Hachtmann <hachti@hachti.de>
Subject: [PATCH 2/2] usb/ftdi_sio: Add support for setting CBUS pins on FT232H
Date: Sun,  1 Jun 2014 01:31:06 +0200
Message-Id: <1401579066-8298-3-git-send-email-hachti@hachti.de>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1401579066-8298-1-git-send-email-hachti@hachti.de>
References: <1401579066-8298-1-git-send-email-hachti@hachti.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a sysfs attribute "cbus" which allows to set the four CBUS
pins on the FT232H.

CBUS support could probably extended to all supporting FTDI chips.

Signed-off-by: Philipp Hachtmann <hachti@hachti.de>
---
 drivers/usb/serial/ftdi_sio.c | 66 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/serial/ftdi_sio.h |  1 +
 2 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index cacba4a..c84e27c 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1354,9 +1354,39 @@ static int set_syncmode(struct usb_serial_port *port, int enable)
 			     urb_value, priv->interface,
 			     NULL, 0, WDR_SHORT_TIMEOUT);
 
+}
+
+static int set_cbus(struct usb_serial_port *port, u8 data)
+{
+	struct ftdi_private *priv = usb_get_serial_port_data(port);
+
+	__u16 urb_value = 0;
+	int rv = 0;
+
+	urb_value = FTDI_BITMODE_CBUS << 8 | data;
+
+	rv = usb_control_msg(port->serial->dev,
+			     usb_sndctrlpipe(port->serial->dev, 0),
+			     FTDI_SIO_SET_BITBANG_REQUEST,
+			     FTDI_SIO_SET_BITBANG_REQUEST_TYPE,
+			     urb_value, priv->interface,
+			     NULL, 0, WDR_SHORT_TIMEOUT);
+
+	if (rv)
+		return rv;
+	if (priv->syncmode) {
+		priv->syncmode = 0;
+		rv = set_syncmode(port, 1);
+	}
+
 	return rv;
 }
 
+static int get_cbus(struct usb_serial_port *port)
+{
+	return -EIO;
+}
+
 static int write_latency_timer(struct usb_serial_port *port)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
@@ -1684,6 +1714,34 @@ static ssize_t syncmode_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(syncmode);
 
+static ssize_t cbus_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	int retval;
+	struct usb_serial_port *port = to_usb_serial_port(dev);
+	retval = get_cbus(port);
+	if (retval < 0)
+		return retval;
+	return sprintf(buf, "%#-x\n", get_cbus(port));
+}
+
+static ssize_t cbus_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *valbuf, size_t count)
+{
+	unsigned long value;
+	struct usb_serial_port *port = to_usb_serial_port(dev);
+	int retval = kstrtoul(valbuf, 0, &value);
+
+	if (retval)
+		return -EINVAL;
+	retval = set_cbus(port, value);
+	if (retval < 0)
+		return -EIO;
+	return count;
+}
+static DEVICE_ATTR_RW(cbus);
+
 /* Write an event character directly to the FTDI register.  The ASCII
    value is in the low 8 bits, with the enable bit in the 9th bit. */
 static ssize_t store_event_char(struct device *dev,
@@ -1736,6 +1794,10 @@ static int create_sysfs_attrs(struct usb_serial_port *port)
 	}
 	if ((!retval) && priv->chip_type == FT232H) {
 		retval = device_create_file(&port->dev,
+					    &dev_attr_cbus);
+		if (retval)
+			return retval;
+		retval = device_create_file(&port->dev,
 					    &dev_attr_syncmode);
 	}
 	return retval;
@@ -1758,8 +1820,10 @@ static void remove_sysfs_attrs(struct usb_serial_port *port)
 			device_remove_file(&port->dev, &dev_attr_latency_timer);
 		}
 	}
-	if (priv->chip_type == FT232H)
+	if (priv->chip_type == FT232H) {
 		device_remove_file(&port->dev, &dev_attr_syncmode);
+		device_remove_file(&port->dev, &dev_attr_cbus);
+	}
 }
 
 /*
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index 04a29f8..f9de34c 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -357,6 +357,7 @@ enum ftdi_sio_baudrate {
 #define FTDI_SIO_SET_BITBANG_REQUEST_TYPE 0x40
 
 #define FTDI_BITMODE_RESET     0x00  /* Switch back to normal operation */
+#define FTDI_BITMODE_CBUS      0x20  /* Configure CBUS pins */
 #define FTDI_BITMODE_SYNCFIFO  0x40  /* Switch to syncronous FIFO mode  */
 
 /*
-- 
2.0.0.rc2

