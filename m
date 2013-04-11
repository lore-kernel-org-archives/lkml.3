Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935160Ab3DKVMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:12:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935642Ab3DKUtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:07 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BAG_JaWrMZAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=odZjL5BKJQEA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202606.469326415@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 123/171 ] USB: pl2303: fix use-after-free in TIOCMIWAIT
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0123-USB-pl2303-fix-use-after-free-in-TIOCMIWAIT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 40509ca982c00c4b70fc00be887509feca0bff15 ]

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/pl2303.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 4d8d210..bf39f1b 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -141,7 +141,6 @@ struct pl2303_serial_private {
 
 struct pl2303_private {
 	spinlock_t lock;
-	wait_queue_head_t delta_msr_wait;
 	u8 line_control;
 	u8 line_status;
 };
@@ -235,7 +234,6 @@ static int pl2303_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	usb_set_serial_port_data(port, priv);
 
@@ -609,11 +607,14 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (1) {
-		interruptible_sleep_on(&priv->delta_msr_wait);
+		interruptible_sleep_on(&port->delta_msr_wait);
 		/* see if a signal did it */
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		status = priv->line_status;
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -721,7 +722,7 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
 	spin_unlock_irqrestore(&priv->lock, flags);
 	if (priv->line_status & UART_BREAK_ERROR)
 		usb_serial_handle_break(port);
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	tty = tty_port_tty_get(&port->port);
 	if (!tty)
@@ -786,7 +787,7 @@ static void pl2303_process_read_urb(struct urb *urb)
 	line_status = priv->line_status;
 	priv->line_status &= ~UART_STATE_TRANSIENT_MASK;
 	spin_unlock_irqrestore(&priv->lock, flags);
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	if (!urb->actual_length)
 		return;
-- 
1.7.10.4


