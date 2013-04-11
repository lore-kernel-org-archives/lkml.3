Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422736Ab3DKVKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:10:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935659Ab3DKUtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:09 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jtrK8jxVwYUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Kmy8LY4XhQ8A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202605.638207149@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 118/171 ] USB: quatech2: fix use-after-free in TIOCMIWAIT
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0118-USB-quatech2-fix-use-after-free-in-TIOCMIWAIT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 69f87f40d2b98e8b4ab82a121fd2bd584690b887 ]

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/quatech2.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index ea69301..e801c54 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -132,7 +132,6 @@ struct qt2_port_private {
 	u8          shadowLSR;
 	u8          shadowMSR;
 
-	wait_queue_head_t   delta_msr_wait; /* Used for TIOCMIWAIT */
 	struct async_icount icount;
 
 	struct usb_serial_port *port;
@@ -510,8 +509,9 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (1) {
-		wait_event_interruptible(priv->delta_msr_wait,
-					 ((priv->icount.rng != prev.rng) ||
+		wait_event_interruptible(port->delta_msr_wait,
+					 (port->serial->disconnected ||
+					  (priv->icount.rng != prev.rng) ||
 					  (priv->icount.dsr != prev.dsr) ||
 					  (priv->icount.dcd != prev.dcd) ||
 					  (priv->icount.cts != prev.cts)));
@@ -519,6 +519,9 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		cur = priv->icount;
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -845,7 +848,6 @@ static int qt2_port_probe(struct usb_serial_port *port)
 
 	spin_lock_init(&port_priv->lock);
 	spin_lock_init(&port_priv->urb_lock);
-	init_waitqueue_head(&port_priv->delta_msr_wait);
 	port_priv->port = port;
 
 	port_priv->write_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -990,7 +992,7 @@ static void qt2_update_msr(struct usb_serial_port *port, unsigned char *ch)
 		if (newMSR & UART_MSR_TERI)
 			port_priv->icount.rng++;
 
-		wake_up_interruptible(&port_priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 }
 
-- 
1.7.10.4


