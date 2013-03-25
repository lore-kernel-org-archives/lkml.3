Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3CYBPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:15:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33882 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693Ab3CYBPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:25 -0400
Message-Id: <20130325010532.711405969@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:49 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 085/104] USB: ark3116: fix use-after-free in TIOCMIWAIT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5018860321dc7a9e50a75d5f319bc981298fb5b7 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ark3116.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -68,7 +68,6 @@ static int is_irda(struct usb_serial *se
 }
 
 struct ark3116_private {
-	wait_queue_head_t       delta_msr_wait;
 	struct async_icount	icount;
 	int			irda;	/* 1 for irda device */
 
@@ -148,7 +147,6 @@ static int ark3116_attach(struct usb_ser
 	if (!priv)
 		return -ENOMEM;
 
-	init_waitqueue_head(&priv->delta_msr_wait);
 	mutex_init(&priv->hw_lock);
 	spin_lock_init(&priv->status_lock);
 
@@ -460,10 +458,14 @@ static int ark3116_ioctl(struct tty_stru
 	case TIOCMIWAIT:
 		for (;;) {
 			struct async_icount prev = priv->icount;
-			interruptible_sleep_on(&priv->delta_msr_wait);
+			interruptible_sleep_on(&port->delta_msr_wait);
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			if ((prev.rng == priv->icount.rng) &&
 			    (prev.dsr == priv->icount.dsr) &&
 			    (prev.dcd == priv->icount.dcd) &&
@@ -584,7 +586,7 @@ static void ark3116_update_msr(struct us
 			priv->icount.dcd++;
 		if (msr & UART_MSR_TERI)
 			priv->icount.rng++;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 }
 


