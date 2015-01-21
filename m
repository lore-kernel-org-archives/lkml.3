Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbbAUKaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:30:19 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:46748 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbbAUKaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:30:10 -0500
From: Peter Hung <hpeter@gmail.com>
X-Google-Original-From: Peter Hung <hpeter+linux_kernel@gmail.com>
To: johan@kernel.org
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom_tsai@fintek.com.tw,
        peter_hong@fintek.com.tw, Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: [PATCH v2 2/4] usb: serial: fix callback wrong process for F81232
Date: Wed, 21 Jan 2015 18:30:05 +0800
Message-Id: <1421836205-25545-1-git-send-email-hpeter+linux_kernel@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our int callback will return IIR, not LSR, and bulk-in callback will return
[LSR+Data][LSR+Data], so need to rewrite it

Signed-off-by: Peter Hung <hpeter+linux_kernel@gmail.com>
---
 drivers/usb/serial/f81232.c | 82 +++++++++++++++++++++------------------------
 1 file changed, 39 insertions(+), 43 deletions(-)

diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index efd45a7..b372975 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -230,17 +230,33 @@ static inline int update_mctrl(struct f81232_private *port_priv,
 
 	return status;
 }
-static void f81232_update_line_status(struct usb_serial_port *port,
+
+static void f81232_iir_status(struct usb_serial_port *port,
 				      unsigned char *data,
 				      unsigned int actual_length)
 {
-	/*
-	 * FIXME: Update port->icount, and call
-	 *
-	 *		wake_up_interruptible(&port->port.delta_msr_wait);
-	 *
-	 *	  on MSR changes.
-	 */
+	struct f81232_private *priv = usb_get_serial_port_data(port);
+	struct usb_device *dev = port->serial->dev;
+
+	if (!actual_length)
+		return;
+
+	switch (data[0] & 0x07) {
+	case 0x00: /* msr change */
+		dev_dbg(&dev->dev, "IIR: MSR Change: %x\n", data[0]);
+		schedule_work(&priv->int_worker);
+		break;
+
+	case 0x02: /* tx-empty */
+		break;
+
+	case 0x04: /* rx data available */
+		break;
+
+	case 0x06: /* lsr change */
+		dev_dbg(&dev->dev, "IIR: IIR: LSR Change: %x\n", data[0]);
+		break;
+	}
 }
 
 static void f81232_read_int_callback(struct urb *urb)
@@ -271,7 +287,7 @@ static void f81232_read_int_callback(struct urb *urb)
 	usb_serial_debug_data(&port->dev, __func__,
 			      urb->actual_length, urb->transfer_buffer);
 
-	f81232_update_line_status(port, data, actual_length);
+	f81232_iir_status(port, data, actual_length);
 
 exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
@@ -284,47 +300,30 @@ exit:
 static void f81232_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
-	struct f81232_private *priv = usb_get_serial_port_data(port);
 	unsigned char *data = urb->transfer_buffer;
 	char tty_flag = TTY_NORMAL;
-	unsigned long flags;
-	u8 line_status;
+	u8 line_status = 0;
 	int i;
 
-	/* update line status */
-	spin_lock_irqsave(&priv->lock, flags);
-	line_status = priv->line_status;
-	priv->line_status &= ~UART_STATE_TRANSIENT_MASK;
-	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (!urb->actual_length)
 		return;
 
-	/* break takes precedence over parity, */
-	/* which takes precedence over framing errors */
-	if (line_status & UART_BREAK_ERROR)
-		tty_flag = TTY_BREAK;
-	else if (line_status & UART_PARITY_ERROR)
-		tty_flag = TTY_PARITY;
-	else if (line_status & UART_FRAME_ERROR)
-		tty_flag = TTY_FRAME;
-	dev_dbg(&port->dev, "%s - tty_flag = %d\n", __func__, tty_flag);
-
-	/* overrun is special, not associated with a char */
-	if (line_status & UART_OVERRUN_ERROR)
-		tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
-
-	if (port->port.console && port->sysrq) {
-		for (i = 0; i < urb->actual_length; ++i)
-			if (!usb_serial_handle_sysrq_char(port, data[i]))
-				tty_insert_flip_char(&port->port, data[i],
-						tty_flag);
-	} else {
-		tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
-							urb->actual_length);
+	if (urb->actual_length >= 2) {
+
+		for (i = 0 ; i < urb->actual_length ; i += 2) {
+			line_status |= data[i+0];
+			tty_insert_flip_string_fixed_flag(&port->port,
+				&data[i+1], tty_flag, 1);
+		}
+
+		if (unlikely(line_status & UART_OVERRUN_ERROR))
+			tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
+
+		tty_flip_buffer_push(&port->port);
 	}
 
-	tty_flip_buffer_push(&port->port);
+
 }
 
 static int set_control_lines(struct usb_device *dev, u8 value)
@@ -456,9 +455,6 @@ static int f81232_ioctl(struct tty_struct *tty,
 	return -ENOIOCTLCMD;
 }
 
-
-
-
 static void f81232_int_work_wq(struct work_struct *work)
 {
 	struct f81232_private *priv =
-- 
1.9.1

