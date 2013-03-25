Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3CYBPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:15:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33875 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755682Ab3CYBPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:24 -0400
Message-Id: <20130325010533.317542350@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:55 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 091/104] USB: mct_u232: fix use-after-free in TIOCMIWAIT
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

commit cf1d24443677a0758cfa88ca40f24858b89261c0 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/mct_u232.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -168,8 +168,6 @@ struct mct_u232_private {
 	unsigned char	     last_msr;      /* Modem Status Register */
 	unsigned int	     rx_flags;      /* Throttling flags */
 	struct async_icount  icount;
-	wait_queue_head_t    msr_wait;	/* for handling sleeping while waiting
-						for msr change to happen */
 };
 
 #define THROTTLED		0x01
@@ -449,7 +447,6 @@ static int mct_u232_startup(struct usb_s
 	if (!priv)
 		return -ENOMEM;
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->msr_wait);
 	usb_set_serial_port_data(serial->port[0], priv);
 
 	init_waitqueue_head(&serial->port[0]->write_wait);
@@ -675,7 +672,7 @@ static void mct_u232_read_int_callback(s
 		tty_kref_put(tty);
 	}
 #endif
-	wake_up_interruptible(&priv->msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 	spin_unlock_irqrestore(&priv->lock, flags);
 exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
@@ -896,13 +893,17 @@ static int  mct_u232_ioctl(struct tty_st
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


