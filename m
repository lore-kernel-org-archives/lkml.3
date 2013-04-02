Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478Ab3DBXGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:06:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278Ab3DBWMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 069/124] USB: ssu100: fix use-after-free in TIOCMIWAIT
Date: Tue,  2 Apr 2013 15:10:51 -0700
Message-Id: <20130402221112.200437974@linuxfoundation.org>
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

commit 43a66b4c417ad15f6d2f632ce67ad195bdf999e8 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ssu100.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -61,7 +61,6 @@ struct ssu100_port_private {
 	spinlock_t status_lock;
 	u8 shadowLSR;
 	u8 shadowMSR;
-	wait_queue_head_t delta_msr_wait; /* Used for TIOCMIWAIT */
 	struct async_icount icount;
 };
 
@@ -355,8 +354,9 @@ static int wait_modem_info(struct usb_se
 	spin_unlock_irqrestore(&priv->status_lock, flags);
 
 	while (1) {
-		wait_event_interruptible(priv->delta_msr_wait,
-					 ((priv->icount.rng != prev.rng) ||
+		wait_event_interruptible(port->delta_msr_wait,
+					 (port->serial->disconnected ||
+					  (priv->icount.rng != prev.rng) ||
 					  (priv->icount.dsr != prev.dsr) ||
 					  (priv->icount.dcd != prev.dcd) ||
 					  (priv->icount.cts != prev.cts)));
@@ -364,6 +364,9 @@ static int wait_modem_info(struct usb_se
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->status_lock, flags);
 		cur = priv->icount;
 		spin_unlock_irqrestore(&priv->status_lock, flags);
@@ -445,7 +448,6 @@ static int ssu100_port_probe(struct usb_
 		return -ENOMEM;
 
 	spin_lock_init(&priv->status_lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	usb_set_serial_port_data(port, priv);
 
@@ -537,7 +539,7 @@ static void ssu100_update_msr(struct usb
 			priv->icount.dcd++;
 		if (msr & UART_MSR_TERI)
 			priv->icount.rng++;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 }
 


