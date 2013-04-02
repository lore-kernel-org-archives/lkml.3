Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab3DBWtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:49:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933314Ab3DBWMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 073/124] USB: ark3116: fix use-after-free in TIOCMIWAIT
Date: Tue,  2 Apr 2013 15:10:55 -0700
Message-Id: <20130402221112.654719936@linuxfoundation.org>
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

commit 5018860321dc7a9e50a75d5f319bc981298fb5b7 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ark3116.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -62,7 +62,6 @@ static int is_irda(struct usb_serial *se
 }
 
 struct ark3116_private {
-	wait_queue_head_t       delta_msr_wait;
 	struct async_icount	icount;
 	int			irda;	/* 1 for irda device */
 
@@ -146,7 +145,6 @@ static int ark3116_port_probe(struct usb
 	if (!priv)
 		return -ENOMEM;
 
-	init_waitqueue_head(&priv->delta_msr_wait);
 	mutex_init(&priv->hw_lock);
 	spin_lock_init(&priv->status_lock);
 
@@ -456,10 +454,14 @@ static int ark3116_ioctl(struct tty_stru
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
@@ -580,7 +582,7 @@ static void ark3116_update_msr(struct us
 			priv->icount.dcd++;
 		if (msr & UART_MSR_TERI)
 			priv->icount.rng++;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 }
 


