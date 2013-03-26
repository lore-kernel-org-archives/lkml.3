Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965263Ab3CZPX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:23:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53980 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965220Ab3CZPXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 099/150] USB: ark3116: fix use-after-free in TIOCMIWAIT
Date: Tue, 26 Mar 2013 15:19:58 +0000
Message-Id: <1364311249-14454-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5018860321dc7a9e50a75d5f319bc981298fb5b7 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ark3116.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index f8ce97d..15bd068 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -68,7 +68,6 @@ static int is_irda(struct usb_serial *serial)
 }
 
 struct ark3116_private {
-	wait_queue_head_t       delta_msr_wait;
 	struct async_icount	icount;
 	int			irda;	/* 1 for irda device */
 
@@ -148,7 +147,6 @@ static int ark3116_attach(struct usb_serial *serial)
 	if (!priv)
 		return -ENOMEM;
 
-	init_waitqueue_head(&priv->delta_msr_wait);
 	mutex_init(&priv->hw_lock);
 	spin_lock_init(&priv->status_lock);
 
@@ -461,10 +459,14 @@ static int ark3116_ioctl(struct tty_struct *tty,
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
@@ -585,7 +587,7 @@ static void ark3116_update_msr(struct usb_serial_port *port, __u8 msr)
 			priv->icount.dcd++;
 		if (msr & UART_MSR_TERI)
 			priv->icount.rng++;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 }
 
-- 
1.8.1.2

