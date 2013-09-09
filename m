Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3IIQIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:08:43 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:50645 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3IIQIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:08:42 -0400
From: Paul Chavent <Paul.Chavent@onera.fr>
To: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org, Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH 1/5] USB : serial : remove tty arg of handle_dcd_change.
Date: Mon,  9 Sep 2013 18:01:16 +0200
Message-Id: <1378742480-2146-2-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
References: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Mon, 09 Sep 2013 18:08:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do the same way as in serialcore.c for uart_handle_dcd_change.  It
removes duplicated code around the usb_serial_handle_dcd_change calls.

Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
---
 drivers/usb/serial/ch341.c   | 7 ++-----
 drivers/usb/serial/generic.c | 4 ++--
 drivers/usb/serial/pl2303.c  | 7 +------
 include/linux/usb/serial.h   | 1 -
 4 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index c2a4171..51c3d3a 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -481,11 +481,8 @@ static void ch341_read_int_callback(struct urb *urb)
 		spin_unlock_irqrestore(&priv->lock, flags);
 
 		if ((priv->line_status ^ prev_line_status) & CH341_BIT_DCD) {
-			struct tty_struct *tty = tty_port_tty_get(&port->port);
-			if (tty)
-				usb_serial_handle_dcd_change(port, tty,
-					    priv->line_status & CH341_BIT_DCD);
-			tty_kref_put(tty);
+			usb_serial_handle_dcd_change(port,
+				    priv->line_status & CH341_BIT_DCD);
 		}
 
 		wake_up_interruptible(&port->port.delta_msr_wait);
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 1f31e6b..33f1df1 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -560,13 +560,13 @@ EXPORT_SYMBOL_GPL(usb_serial_handle_break);
 /**
  *	usb_serial_handle_dcd_change - handle a change of carrier detect state
  *	@port: usb_serial_port structure for the open port
- *	@tty: tty_struct structure for the port
  *	@status: new carrier detect status, nonzero if active
  */
 void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
-				struct tty_struct *tty, unsigned int status)
+				unsigned int status)
 {
 	struct tty_port *port = &usb_port->port;
+	struct tty_struct *tty = port->tty;
 
 	dev_dbg(&usb_port->dev, "%s - status %d\n", __func__, status);
 
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index e7a84f0..3299f3a 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -823,7 +823,6 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
 {
 
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	unsigned long flags;
 	u8 status_idx = UART_STATE;
 	u8 length = UART_STATE + 1;
@@ -856,13 +855,9 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
 		usb_serial_handle_break(port);
 	wake_up_interruptible(&port->port.delta_msr_wait);
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
 	if ((priv->line_status ^ prev_line_status) & UART_DCD)
-		usb_serial_handle_dcd_change(port, tty,
+		usb_serial_handle_dcd_change(port,
 				priv->line_status & UART_DCD);
-	tty_kref_put(tty);
 }
 
 static void pl2303_read_int_callback(struct urb *urb)
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index d528b80..facec97 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -347,7 +347,6 @@ extern int usb_serial_handle_sysrq_char(struct usb_serial_port *port,
 					unsigned int ch);
 extern int usb_serial_handle_break(struct usb_serial_port *port);
 extern void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
-					 struct tty_struct *tty,
 					 unsigned int status);
 
 
-- 
1.7.12.1

