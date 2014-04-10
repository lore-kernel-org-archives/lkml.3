Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934933AbaDJEHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:07:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934803AbaDJDWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 070/134] USB: ssu100: fix use-after-free in TIOCMIWAIT
Date: Wed,  9 Apr 2014 20:23:06 -0700
Message-Id: <20140410032309.113957278@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 43a66b4c417ad15f6d2f632ce67ad195bdf999e8 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ssu100.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -77,7 +77,6 @@ struct ssu100_port_private {
 	spinlock_t status_lock;
 	u8 shadowLSR;
 	u8 shadowMSR;
-	wait_queue_head_t delta_msr_wait; /* Used for TIOCMIWAIT */
 	struct async_icount icount;
 };
 
@@ -386,8 +385,9 @@ static int wait_modem_info(struct usb_se
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
@@ -395,6 +395,9 @@ static int wait_modem_info(struct usb_se
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->status_lock, flags);
 		cur = priv->icount;
 		spin_unlock_irqrestore(&priv->status_lock, flags);
@@ -477,7 +480,6 @@ static int ssu100_attach(struct usb_seri
 	}
 
 	spin_lock_init(&priv->status_lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 	usb_set_serial_port_data(port, priv);
 
 	return ssu100_initdevice(serial->dev);
@@ -563,7 +565,7 @@ static void ssu100_update_msr(struct usb
 			priv->icount.dcd++;
 		if (msr & UART_MSR_TERI)
 			priv->icount.rng++;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 }
 


