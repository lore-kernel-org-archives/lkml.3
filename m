Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983Ab3DBXIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:08:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab3DBWMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 061/124] USB: quatech2: fix use-after-free in TIOCMIWAIT
Date: Tue,  2 Apr 2013 15:10:43 -0700
Message-Id: <20130402221111.266512673@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 69f87f40d2b98e8b4ab82a121fd2bd584690b887 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/quatech2.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -128,7 +128,6 @@ struct qt2_port_private {
 	u8          shadowLSR;
 	u8          shadowMSR;
 
-	wait_queue_head_t   delta_msr_wait; /* Used for TIOCMIWAIT */
 	struct async_icount icount;
 
 	struct usb_serial_port *port;
@@ -506,8 +505,9 @@ static int wait_modem_info(struct usb_se
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
@@ -515,6 +515,9 @@ static int wait_modem_info(struct usb_se
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		cur = priv->icount;
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -841,7 +844,6 @@ static int qt2_port_probe(struct usb_ser
 
 	spin_lock_init(&port_priv->lock);
 	spin_lock_init(&port_priv->urb_lock);
-	init_waitqueue_head(&port_priv->delta_msr_wait);
 	port_priv->port = port;
 
 	port_priv->write_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -984,7 +986,7 @@ static void qt2_update_msr(struct usb_se
 		if (newMSR & UART_MSR_TERI)
 			port_priv->icount.rng++;
 
-		wake_up_interruptible(&port_priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 }
 


