Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaLHXZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 18:25:51 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:40034 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbaLHXZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 18:25:49 -0500
From: George McCollister <george.mccollister@gmail.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, johan@kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH] USB: serial: add nt124 usb to serial driver
Date: Mon,  8 Dec 2014 17:24:17 -0600
Message-Id: <1418081057-25283-1-git-send-email-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is for the NovaTech 124 4x serial expansion board for the
NovaTech OrionLXm.

Firmware source code can be found here:
https://github.com/novatechweb/nt124

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/usb/serial/Kconfig  |   9 +
 drivers/usb/serial/Makefile |   1 +
 drivers/usb/serial/nt124.c  | 429 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 439 insertions(+)
 create mode 100644 drivers/usb/serial/nt124.c

diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index a69f7cd..6dfc340 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -509,6 +509,15 @@ config USB_SERIAL_NAVMAN
 	  To compile this driver as a module, choose M here: the
 	  module will be called navman.
 
+config USB_SERIAL_NT124
+	tristate "USB nt124 serial device"
+	help
+	  Say Y here if you want to use the NovaTech 124 4x USB to serial
+	  board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called nt124.
+
 config USB_SERIAL_PL2303
 	tristate "USB Prolific 2303 Single Port Serial Driver"
 	help
diff --git a/drivers/usb/serial/Makefile b/drivers/usb/serial/Makefile
index 349d9df..f88eaab 100644
--- a/drivers/usb/serial/Makefile
+++ b/drivers/usb/serial/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_USB_SERIAL_MOS7720)		+= mos7720.o
 obj-$(CONFIG_USB_SERIAL_MOS7840)		+= mos7840.o
 obj-$(CONFIG_USB_SERIAL_MXUPORT)		+= mxuport.o
 obj-$(CONFIG_USB_SERIAL_NAVMAN)			+= navman.o
+obj-$(CONFIG_USB_SERIAL_NT124)			+= nt124.o
 obj-$(CONFIG_USB_SERIAL_OMNINET)		+= omninet.o
 obj-$(CONFIG_USB_SERIAL_OPTICON)		+= opticon.o
 obj-$(CONFIG_USB_SERIAL_OPTION)			+= option.o
diff --git a/drivers/usb/serial/nt124.c b/drivers/usb/serial/nt124.c
new file mode 100644
index 0000000..d7557ff
--- /dev/null
+++ b/drivers/usb/serial/nt124.c
@@ -0,0 +1,429 @@
+/*
+ * nt124.c
+ *
+ * Copyright (c) 2014 NovaTech LLC
+ *
+ * Driver for nt124 4x serial board based on STM32F103
+ *
+ * Portions derived from the cdc-acm driver
+ *
+ * The original intention was to implement a cdc-acm compliant
+ * 4x USB to serial converter in the STM32F103 however several problems arose.
+ *   The STM32F103 didn't have enough end points to implement 4 ports.
+ *   CTS control was required by the application.
+ *   Accurate notification of transmission completion was required.
+ *   RTSCTS flow control support was required.
+ *
+ * The interrupt endpoint was eliminated and the control line information
+ * was moved to the first two bytes of the in endpoint message. CTS control
+ * and mechanisms to enable RTSCTS flow control and deliver TXEMPTY
+ * information were added.
+ *
+ * Firmware source code can be found here:
+ * https://github.com/novatechweb/nt124
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_flip.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/serial.h>
+#include <asm/unaligned.h>
+
+#define NT124_VID		0x2aeb
+#define NT124_USB_PID		124
+
+#define DRIVER_AUTHOR "George McCollister <george.mccollister@gmail.com>"
+#define DRIVER_DESC "nt124 USB serial driver"
+
+static const struct usb_device_id id_table[] = {
+	{ USB_DEVICE(NT124_VID, NT124_USB_PID) },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(usb, id_table);
+
+/*
+ * Output control lines.
+ */
+
+#define NT124_CTRL_DTR		0x01
+#define NT124_CTRL_RTS		0x02
+
+/*
+ * Input control lines and line errors.
+ */
+
+#define NT124_CTRL_DCD		0x01
+#define NT124_CTRL_DSR		0x02
+#define NT124_CTRL_BRK		0x04
+#define NT124_CTRL_RI		0x08
+#define NT124_CTRL_FRAMING	0x10
+#define NT124_CTRL_PARITY	0x20
+#define NT124_CTRL_OVERRUN	0x40
+#define NT124_CTRL_TXEMPTY	0x80
+#define NT124_CTRL_CTS		0x100
+
+#define USB_NT124_REQ_SET_LINE_CODING		0x20
+#define USB_NT124_REQ_SET_CONTROL_LINE_STATE	0x22
+#define USB_NT124_REQ_SEND_BREAK		0x23
+#define USB_NT124_SET_FLOW_CONTROL		0x90
+
+struct nt124_line_coding {
+	__le32	dwDTERate;
+	u8	bCharFormat;
+	u8	bParityType;
+	u8	bDataBits;
+} __packed;
+
+struct nt124_private {
+	/* USB interface */
+	u16 bInterfaceNumber;
+	/* input control lines (DCD, DSR, RI, break, overruns) */
+	unsigned int ctrlin;
+	/* output control lines (DTR, RTS) */
+	unsigned int ctrlout;
+	/* termios CLOCAL */
+	unsigned char clocal;
+	/* bits, stop, parity */
+	struct nt124_line_coding line;
+	int serial_transmit;
+	unsigned int flowctrl;
+};
+
+static int nt124_ctrl_msg(struct usb_serial_port *port, int request, int value,
+			  void *buf, int len)
+{
+	struct nt124_private *priv = usb_get_serial_port_data(port);
+	int retval;
+
+	retval = usb_control_msg(port->serial->dev,
+			usb_sndctrlpipe(port->serial->dev, 0),
+			request, USB_TYPE_CLASS | USB_RECIP_INTERFACE, value,
+			priv->bInterfaceNumber,
+			buf, len, 5000);
+
+	dev_dbg(&port->dev,
+			"%s - rq 0x%02x, val %#x, len %#x, result %d\n",
+			__func__, request, value, len, retval);
+
+	return retval < 0 ? retval : 0;
+}
+
+#define nt124_set_control(port, control) \
+	nt124_ctrl_msg(port, USB_NT124_REQ_SET_CONTROL_LINE_STATE, control, \
+	NULL, 0)
+#define nt124_set_line(port, line) \
+	nt124_ctrl_msg(port, USB_NT124_REQ_SET_LINE_CODING, 0, line, \
+	sizeof *(line))
+#define nt124_send_break(port, ms) \
+	nt124_ctrl_msg(port, USB_NT124_REQ_SEND_BREAK, ms, NULL, 0)
+#define nt124_set_flowctrl(port, flowctrl) \
+	nt124_ctrl_msg(port, USB_NT124_SET_FLOW_CONTROL, flowctrl, NULL, 0)
+
+static void nt124_process_notify(struct usb_serial_port *port,
+				 struct nt124_private *priv,
+				 unsigned char *data)
+{
+	int newctrl;
+	unsigned long flags;
+
+	newctrl = get_unaligned_le16(data);
+	if (newctrl & NT124_CTRL_TXEMPTY) {
+		spin_lock_irqsave(&port->lock, flags);
+		priv->serial_transmit = 0;
+		spin_unlock_irqrestore(&port->lock, flags);
+		tty_port_tty_wakeup(&port->port);
+	}
+
+	if (!priv->clocal && (priv->ctrlin & ~newctrl & NT124_CTRL_DCD)) {
+		dev_dbg(&port->dev, "%s - calling hangup\n",
+				__func__);
+		tty_port_tty_hangup(&port->port, false);
+	}
+
+	priv->ctrlin = newctrl;
+}
+
+static void nt124_process_read_urb(struct urb *urb)
+{
+	struct usb_serial_port *port = urb->context;
+	struct nt124_private *priv = usb_get_serial_port_data(port);
+	unsigned char *data = (unsigned char *)urb->transfer_buffer;
+
+	if (urb->actual_length < 2)
+		return;
+
+	nt124_process_notify(port, priv, data);
+
+	if (urb->actual_length == 2)
+		return;
+
+	tty_insert_flip_string(&port->port, &data[2],
+			urb->actual_length - 2);
+	tty_flip_buffer_push(&port->port);
+}
+
+static int nt124_tiocmget(struct tty_struct *tty)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct nt124_private *priv = usb_get_serial_port_data(port);
+
+	return (priv->ctrlout & NT124_CTRL_DTR ? TIOCM_DTR : 0) |
+	       (priv->ctrlout & NT124_CTRL_RTS ? TIOCM_RTS : 0) |
+	       (priv->ctrlin  & NT124_CTRL_DSR ? TIOCM_DSR : 0) |
+	       (priv->ctrlin  & NT124_CTRL_RI  ? TIOCM_RI  : 0) |
+	       (priv->ctrlin  & NT124_CTRL_DCD ? TIOCM_CD  : 0) |
+	       (priv->ctrlin  & NT124_CTRL_CTS ? TIOCM_CTS : 0);
+}
+
+static int nt124_port_tiocmset(struct usb_serial_port *port,
+			       unsigned int set, unsigned int clear)
+{
+	struct nt124_private *priv = usb_get_serial_port_data(port);
+	unsigned int newctrl;
+
+	newctrl = priv->ctrlout;
+	set = (set & TIOCM_DTR ? NT124_CTRL_DTR : 0) |
+		(set & TIOCM_RTS ? NT124_CTRL_RTS : 0);
+	clear = (clear & TIOCM_DTR ? NT124_CTRL_DTR : 0) |
+		(clear & TIOCM_RTS ? NT124_CTRL_RTS : 0);
+
+	newctrl = (newctrl & ~clear) | set;
+
+	if (priv->ctrlout == newctrl)
+		return 0;
+	return nt124_set_control(port, priv->ctrlout = newctrl);
+}
+
+static int nt124_tiocmset(struct tty_struct *tty,
+			  unsigned int set, unsigned int clear)
+{
+	struct usb_serial_port *port = tty->driver_data;
+
+	return nt124_port_tiocmset(port, set, clear);
+}
+
+static void nt124_dtr_rts(struct usb_serial_port *port, int on)
+{
+	if (on)
+		nt124_port_tiocmset(port, TIOCM_DTR|TIOCM_RTS, 0);
+	else
+		nt124_port_tiocmset(port, 0, TIOCM_DTR|TIOCM_RTS);
+}
+
+static void nt124_set_termios(struct tty_struct *tty,
+			      struct usb_serial_port *port,
+			      struct ktermios *termios_old)
+{
+	struct nt124_private *priv = usb_get_serial_port_data(port);
+	struct ktermios *termios = &tty->termios;
+	struct nt124_line_coding newline;
+	int newctrl = priv->ctrlout;
+
+	newline.dwDTERate = cpu_to_le32(tty_get_baud_rate(tty));
+	newline.bCharFormat = termios->c_cflag & CSTOPB ? 2 : 0;
+	newline.bParityType = termios->c_cflag & PARENB ?
+				(termios->c_cflag & PARODD ? 1 : 2) +
+				(termios->c_cflag & CMSPAR ? 2 : 0) : 0;
+	switch (termios->c_cflag & CSIZE) {
+	case CS5:
+		newline.bDataBits = 5;
+		break;
+	case CS6:
+		newline.bDataBits = 6;
+		break;
+	case CS7:
+		newline.bDataBits = 7;
+		break;
+	case CS8:
+	default:
+		newline.bDataBits = 8;
+		break;
+	}
+	priv->clocal = ((termios->c_cflag & CLOCAL) != 0);
+
+	if (C_BAUD(tty) == B0) {
+		newline.dwDTERate = priv->line.dwDTERate;
+		newctrl &= ~NT124_CTRL_DTR;
+	} else if (termios_old && (termios_old->c_cflag & CBAUD) == B0) {
+		newctrl |=  NT124_CTRL_DTR;
+	}
+
+	if (newctrl != priv->ctrlout)
+		nt124_set_control(port, priv->ctrlout = newctrl);
+
+	if (memcmp(&priv->line, &newline, sizeof(newline))) {
+		memcpy(&priv->line, &newline, sizeof(newline));
+		dev_dbg(&port->dev, "%s - set line: %d %d %d %d\n",
+			__func__,
+			le32_to_cpu(newline.dwDTERate),
+			newline.bCharFormat, newline.bParityType,
+			newline.bDataBits);
+		nt124_set_line(port, &priv->line);
+	}
+
+	if (termios->c_cflag & CRTSCTS && !priv->flowctrl) {
+		priv->flowctrl = 1;
+		nt124_set_flowctrl(port, priv->flowctrl);
+	} else if (!(termios->c_cflag & CRTSCTS) && priv->flowctrl) {
+		priv->flowctrl = 0;
+		nt124_set_flowctrl(port, priv->flowctrl);
+	}
+}
+
+static void nt124_write_bulk_callback(struct urb *urb)
+{
+	unsigned long flags;
+	struct usb_serial_port *port = urb->context;
+	struct nt124_private *priv = usb_get_serial_port_data(port);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(port->write_urbs); ++i) {
+		if (port->write_urbs[i] == urb)
+			break;
+	}
+	spin_lock_irqsave(&port->lock, flags);
+	port->tx_bytes -= urb->transfer_buffer_length;
+	if (!urb->status)
+		priv->serial_transmit = 1;
+	set_bit(i, &port->write_urbs_free);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	switch (urb->status) {
+	case 0:
+		break;
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+		dev_dbg(&port->dev, "%s - urb stopped: %d\n",
+							__func__, urb->status);
+		return;
+	case -EPIPE:
+		dev_err_console(port, "%s - urb stopped: %d\n",
+							__func__, urb->status);
+		return;
+	default:
+		dev_err_console(port, "%s - nonzero urb status: %d\n",
+							__func__, urb->status);
+		goto resubmit;
+	}
+
+resubmit:
+	usb_serial_generic_write_start(port, GFP_ATOMIC);
+	usb_serial_port_softint(port);
+}
+
+static int nt124_chars_in_buffer(struct tty_struct *tty)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct nt124_private *priv = usb_get_serial_port_data(port);
+	unsigned long flags;
+	int chars;
+
+	if (!port->bulk_out_size)
+		return 0;
+
+	spin_lock_irqsave(&port->lock, flags);
+	chars = kfifo_len(&port->write_fifo) + port->tx_bytes +
+		priv->serial_transmit;
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	dev_dbg(&port->dev, "%s - returns %d\n", __func__, chars);
+	return chars;
+}
+
+static void nt124_break_ctl(struct tty_struct *tty, int state)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	int retval;
+
+	retval = nt124_send_break(port, state ? 0xffff : 0);
+	if (retval < 0)
+		dev_dbg(&port->dev, "%s - send break failed\n", __func__);
+}
+
+static int nt124_open(struct tty_struct *tty,
+		      struct usb_serial_port *port)
+{
+	struct nt124_private *priv = usb_get_serial_port_data(port);
+	int result = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	port->throttled = 0;
+	port->throttle_req = 0;
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	priv->flowctrl = 0;
+	nt124_set_termios(tty, port, NULL);
+	nt124_set_flowctrl(port, priv->flowctrl);
+
+	if (port->bulk_in_size)
+		result = usb_serial_generic_submit_read_urbs(port, GFP_KERNEL);
+
+	return result;
+}
+
+static int nt124_port_probe(struct usb_serial_port *port)
+{
+	struct usb_interface *interface = port->serial->interface;
+	struct usb_host_interface *cur_altsetting = interface->cur_altsetting;
+	struct nt124_private *priv;
+
+	priv = devm_kzalloc(&port->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->bInterfaceNumber = cur_altsetting->desc.bInterfaceNumber;
+
+	usb_set_serial_port_data(port, priv);
+
+	return 0;
+}
+
+static struct usb_serial_driver nt124_device = {
+	.driver = {
+		.owner =	THIS_MODULE,
+		.name =		"nt124",
+	},
+	.id_table =		id_table,
+	.num_ports =		1,
+	.bulk_in_size =		32,
+	.bulk_out_size =	32,
+	.open =			nt124_open,
+	.process_read_urb =	nt124_process_read_urb,
+	.write_bulk_callback =	nt124_write_bulk_callback,
+	.chars_in_buffer =	nt124_chars_in_buffer,
+	.throttle =		usb_serial_generic_throttle,
+	.unthrottle =		usb_serial_generic_unthrottle,
+	.set_termios =		nt124_set_termios,
+	.tiocmget =		nt124_tiocmget,
+	.tiocmset =		nt124_tiocmset,
+	.dtr_rts =		nt124_dtr_rts,
+	.break_ctl =		nt124_break_ctl,
+	.port_probe =		nt124_port_probe,
+};
+
+static struct usb_serial_driver * const serial_drivers[] = {
+	&nt124_device, NULL
+};
+
+module_usb_serial_driver(serial_drivers, id_table);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
-- 
2.1.0

