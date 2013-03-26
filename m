Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369Ab3CZPi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:38:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54016 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965259Ab3CZPX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 106/150] USB: mct_u232: fix use-after-free in TIOCMIWAIT
Date: Tue, 26 Mar 2013 15:20:05 +0000
Message-Id: <1364311249-14454-107-git-send-email-luis.henriques@canonical.com>
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

commit cf1d24443677a0758cfa88ca40f24858b89261c0 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/mct_u232.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index 66b91d5..5f005cc 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -118,8 +118,6 @@ struct mct_u232_private {
 	unsigned char	     last_msr;      /* Modem Status Register */
 	unsigned int	     rx_flags;      /* Throttling flags */
 	struct async_icount  icount;
-	wait_queue_head_t    msr_wait;	/* for handling sleeping while waiting
-						for msr change to happen */
 };
 
 #define THROTTLED		0x01
@@ -399,7 +397,6 @@ static int mct_u232_startup(struct usb_serial *serial)
 	if (!priv)
 		return -ENOMEM;
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->msr_wait);
 	usb_set_serial_port_data(serial->port[0], priv);
 
 	init_waitqueue_head(&serial->port[0]->write_wait);
@@ -416,7 +413,6 @@ static int mct_u232_startup(struct usb_serial *serial)
 	return 0;
 } /* mct_u232_startup */
 
-
 static void mct_u232_release(struct usb_serial *serial)
 {
 	struct mct_u232_private *priv;
@@ -616,7 +612,7 @@ static void mct_u232_read_int_callback(struct urb *urb)
 		tty_kref_put(tty);
 	}
 #endif
-	wake_up_interruptible(&priv->msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 	spin_unlock_irqrestore(&priv->lock, flags);
 exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
@@ -827,13 +823,17 @@ static int  mct_u232_ioctl(struct tty_struct *tty,
 		cprev = mct_u232_port->icount;
 		spin_unlock_irqrestore(&mct_u232_port->lock, flags);
 		for ( ; ; ) {
-			prepare_to_wait(&mct_u232_port->msr_wait,
+			prepare_to_wait(&port->delta_msr_wait,
 					&wait, TASK_INTERRUPTIBLE);
 			schedule();
-			finish_wait(&mct_u232_port->msr_wait, &wait);
+			finish_wait(&port->delta_msr_wait, &wait);
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			spin_lock_irqsave(&mct_u232_port->lock, flags);
 			cnow = mct_u232_port->icount;
 			spin_unlock_irqrestore(&mct_u232_port->lock, flags);
-- 
1.8.1.2

