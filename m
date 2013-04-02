Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab3DBWsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:48:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933318Ab3DBWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 074/124] USB: mct_u232: fix use-after-free in TIOCMIWAIT
Date: Tue,  2 Apr 2013 15:10:56 -0700
Message-Id: <20130402221112.777998447@linuxfoundation.org>
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

commit cf1d24443677a0758cfa88ca40f24858b89261c0 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mct_u232.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -114,8 +114,6 @@ struct mct_u232_private {
 	unsigned char	     last_msr;      /* Modem Status Register */
 	unsigned int	     rx_flags;      /* Throttling flags */
 	struct async_icount  icount;
-	wait_queue_head_t    msr_wait;	/* for handling sleeping while waiting
-						for msr change to happen */
 };
 
 #define THROTTLED		0x01
@@ -409,7 +407,6 @@ static int mct_u232_port_probe(struct us
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->msr_wait);
 
 	usb_set_serial_port_data(port, priv);
 
@@ -606,7 +603,7 @@ static void mct_u232_read_int_callback(s
 		tty_kref_put(tty);
 	}
 #endif
-	wake_up_interruptible(&priv->msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 	spin_unlock_irqrestore(&priv->lock, flags);
 exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
@@ -815,13 +812,17 @@ static int  mct_u232_ioctl(struct tty_st
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


