Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaJWTlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:41:46 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59148 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaJWTlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:41:44 -0400
From: Russ Dill <russ.dill@gmail.com>
X-Google-Original-From: Russ Dill <Russ.Dill@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hector Martin <hector@marcansoft.com>
Subject: [PATCH v2] usb: serial: Perform verification for FTDI FT232R devices
Date: Thu, 23 Oct 2014 12:41:41 -0700
Message-Id: <1414093301-21992-1-git-send-email-Russ.Dill@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <5449355C.2060301@marcansoft.com>
References: <5449355C.2060301@marcansoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: Perform check using product ID instead of vendor ID and
update half word before checksum rather than checksum
itself.

This patch provides the FTDI genuine product verification steps
as contained within the new 2.12.00 official release. It ensures
that counterfeiters don't exploit engineering investment made
by FTDI. Counterfeit ICs are destroying innovation in the
industry.

FTDI recommends that to guarantee genuine FTDI products
please purchase either from FTDI directly or an authorised
distributor.

This is definitely not targeting end users - if you're unsure if
ICs are genuine then please don't use the drivers.

Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c | 113 +++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/serial/ftdi_sio.h |  41 +++++++++++++++
 2 files changed, 153 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index dc72b924c399..c7041fd9e213 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1377,6 +1377,48 @@ static int read_latency_timer(struct usb_serial_port *port)
 	return rv;
 }
 
+static int write_eeprom(struct usb_serial_port *port, u8 addr, u16 data)
+{
+	struct usb_device *udev = port->serial->dev;
+	int rv;
+
+	rv = usb_control_msg(udev,
+			     usb_sndctrlpipe(udev, 0),
+			     FTDI_SIO_WRITE_EEPROM_REQUEST,
+			     FTDI_SIO_WRITE_EEPROM_REQUEST_TYPE,
+			     data, addr,
+			     NULL, 0, WDR_TIMEOUT);
+	if (rv < 0)
+		dev_err(&port->dev, "Unable to write EEPROM: %i\n", rv);
+	return rv;
+}
+
+static int read_eeprom(struct usb_serial_port *port, u8 addr, u16 *data)
+{
+	struct usb_device *udev = port->serial->dev;
+	u16 *buf;
+	int rv;
+
+	buf = kmalloc(2, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	rv = usb_control_msg(udev,
+			     usb_rcvctrlpipe(udev, 0),
+			     FTDI_SIO_READ_EEPROM_REQUEST,
+			     FTDI_SIO_READ_EEPROM_REQUEST_TYPE,
+			     0, addr,
+			     buf, 2, WDR_TIMEOUT);
+	if (rv < 0)
+		dev_err(&port->dev, "Unable to read from EEPROM: %i\n", rv);
+	else
+		*data = *buf;
+
+	kfree(buf);
+
+	return rv;
+}
+
 static int get_serial_info(struct usb_serial_port *port,
 				struct serial_struct __user *retinfo)
 {
@@ -1723,12 +1765,80 @@ static int ftdi_sio_probe(struct usb_serial *serial,
 	return 0;
 }
 
+static u16 ftdi_checksum(u16 *data, int n)
+{
+	u16 checksum;
+	int i;
+
+	checksum = 0xaaaa;
+	for (i = 0; i < n; i++) {
+		checksum ^= be16_to_cpu(data[i]);
+		checksum = (checksum << 1) | (checksum >> 15);
+	}
+
+	return checksum;
+}
+
+static void ftdi_verify(struct usb_serial_port *port)
+{
+	struct ftdi_private *priv = usb_get_serial_port_data(port);
+	u16 *eeprom_data;
+	u16 checksum;
+	u16 fill;
+	int eeprom_size;
+	int i;
+
+	switch (priv->chip_type) {
+	case FT232RL:
+		eeprom_size = 0x40;
+		break;
+	default:
+		/* Unsupported for verification */
+		return;
+	}
+
+	/* Latency timer needs to be 0x77 to unlock EEPROM programming */
+	if (priv->latency != 0x77) {
+		int orig_latency = priv->latency;
+		priv->latency = 0x77;
+		write_latency_timer(port);
+		priv->latency = orig_latency;
+	}
+
+	eeprom_data = kzalloc(eeprom_size * 2, GFP_KERNEL);
+	if (!eeprom_data)
+		return;
+
+	/* Read in EEPROM */
+	for (i = 0; i < eeprom_size; i++)
+		if (read_eeprom(port, i, eeprom_data + i) < 0)
+			goto end_verify;
+
+	/* Verify EEPROM is valid */
+	checksum = ftdi_checksum(eeprom_data, eeprom_size - 1);
+	if (checksum != be16_to_cpu(eeprom_data[eeprom_size - 1]))
+		goto end_verify;
+
+	/* Attempt to set Product ID to 0 */
+	eeprom_data[2] = 0;
+
+	/* Calculate value to write to memory to make checksum still valid */
+	fill = ftdi_checksum(eeprom_data, eeprom_size - 2);
+	fill ^= (checksum >> 1) | (checksum << 15);
+
+	/* Verify EEPROM programming behavior/nonbehavior */
+	write_eeprom(port, 2, 0);
+	write_eeprom(port, eeprom_size - 2, cpu_to_be16(fill));
+
+end_verify:
+	kfree(eeprom_data);
+}
+
 static int ftdi_sio_port_probe(struct usb_serial_port *port)
 {
 	struct ftdi_private *priv;
 	struct ftdi_sio_quirk *quirk = usb_get_serial_data(port->serial);
 
-
 	priv = kzalloc(sizeof(struct ftdi_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
@@ -1746,6 +1856,7 @@ static int ftdi_sio_port_probe(struct usb_serial_port *port)
 	ftdi_set_max_packet_size(port);
 	if (read_latency_timer(port) < 0)
 		priv->latency = 16;
+	ftdi_verify(port);
 	write_latency_timer(port);
 	create_sysfs_attrs(port);
 	return 0;
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index ed58c6fa8dbe..9ed6b7645cae 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -35,6 +35,9 @@
 #define FTDI_SIO_SET_ERROR_CHAR		7 /* Set the error character */
 #define FTDI_SIO_SET_LATENCY_TIMER	9 /* Set the latency timer */
 #define FTDI_SIO_GET_LATENCY_TIMER	10 /* Get the latency timer */
+#define FTDI_SIO_READ_EEPROM		0x90 /* Read 2 bytes from EEPROM */
+#define FTDI_SIO_WRITE_EEPROM		0x91 /* Write 2 bytes to EEPROM */
+
 
 /* Interface indices for FT2232, FT2232H and FT4232H devices */
 #define INTERFACE_A		1
@@ -345,6 +348,44 @@ enum ftdi_sio_baudrate {
  */
 
 /*
+ * FTDI_SIO_READ_EEPROM
+ *
+ * Read 2 bytes of EEPROM data.
+ */
+#define  FTDI_SIO_READ_EEPROM_REQUEST FTDI_SIO_READ_EEPROM
+#define  FTDI_SIO_READ_EEPROM_REQUEST_TYPE 0xC0
+
+/*
+ *  BmRequestType:   1100 0000b
+ *  bRequest:        FTDI_SIO_READ_EEPROM
+ *  wValue:          0
+ *  wIndex:          EEPROM address / 2
+ *  wLength:         0
+ *  Data:            2 bytes of data from EEPROM
+ */
+
+/*
+ * FTDI_SIO_WRITE_EEPROM
+ *
+ * Write 2 bytes of data to EEPROM.
+ */
+#define  FTDI_SIO_WRITE_EEPROM_REQUEST FTDI_SIO_WRITE_EEPROM
+#define  FTDI_SIO_WRITE_EEPROM_REQUEST_TYPE 0x40
+
+/*
+ *  BmRequestType:   0100 0000b
+ *  bRequest:        FTDI_SIO_WRITE_EEPROM
+ *  wValue:          2 bytes for EEPROM
+ *  wIndex:          EEPROM address / 2
+ *  wLength:         0
+ *  Data:            None
+ *
+ * wValue:
+ *   B0..15  EEPROM data
+ *
+ */
+
+/*
  * FTDI_SIO_SET_EVENT_CHAR
  *
  * Set the special event character for the specified communications port.
-- 
2.1.0

