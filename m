Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935907Ab3DKVKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:10:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16652 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935655Ab3DKUtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:08 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=7GU11ANpa6QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=x5FYpSr56C8A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202606.153522653@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 121/171 ] USB: oti6858: fix use-after-free in TIOCMIWAIT
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0121-USB-oti6858-fix-use-after-free-in-TIOCMIWAIT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 8edfdab37157d2683e51b8be5d3d5697f66a9f7b ]

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/oti6858.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index 3aa582e..88e31f8 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -191,7 +191,6 @@ struct oti6858_private {
 	u8 setup_done;
 	struct delayed_work delayed_setup_work;
 
-	wait_queue_head_t intr_wait;
 	struct usb_serial_port *port;   /* USB port with which associated */
 };
 
@@ -342,7 +341,6 @@ static int oti6858_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->intr_wait);
 	priv->port = port;
 	INIT_DELAYED_WORK(&priv->delayed_setup_work, setup_line);
 	INIT_DELAYED_WORK(&priv->delayed_write_work, send_data);
@@ -669,11 +667,15 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (1) {
-		wait_event_interruptible(priv->intr_wait,
+		wait_event_interruptible(port->delta_msr_wait,
+					port->serial->disconnected ||
 					priv->status.pin_state != prev);
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		status = priv->status.pin_state & PIN_MASK;
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -771,7 +773,7 @@ static void oti6858_read_int_callback(struct urb *urb)
 
 		if (!priv->transient) {
 			if (xs->pin_state != priv->status.pin_state)
-				wake_up_interruptible(&priv->intr_wait);
+				wake_up_interruptible(&port->delta_msr_wait);
 			memcpy(&priv->status, xs, OTI6858_CTRL_PKT_SIZE);
 		}
 
-- 
1.7.10.4


