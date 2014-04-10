Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934871AbaDJELt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:11:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934745AbaDJDWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 060/134] USB: cypress_m8: fix use-after-free in TIOCMIWAIT
Date: Wed,  9 Apr 2014 20:22:56 -0700
Message-Id: <20140410032307.771544390@linuxfoundation.org>
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

commit 356050d8b1e526db093e9d2c78daf49d6bf418e3 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Also remove bogus test for private data pointer being NULL as it is
never assigned in the loop.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cypress_m8.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -125,7 +125,6 @@ struct cypress_private {
 	int baud_rate;			   /* stores current baud rate in
 					      integer form */
 	int isthrottled;		   /* if throttled, discard reads */
-	wait_queue_head_t delta_msr_wait;  /* used for TIOCMIWAIT */
 	char prev_status, diff_status;	   /* used for TIOCMIWAIT */
 	/* we pass a pointer to this as the argument sent to
 	   cypress_set_termios old_termios */
@@ -475,7 +474,6 @@ static int generic_startup(struct usb_se
 		kfree(priv);
 		return -ENOMEM;
 	}
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	/* Skip reset for FRWD device. It is a workaound:
 	   device hangs if it receives SET_CONFIGURE in Configured
@@ -919,12 +917,16 @@ static int cypress_ioctl(struct tty_stru
 	switch (cmd) {
 	/* This code comes from drivers/char/serial.c and ftdi_sio.c */
 	case TIOCMIWAIT:
-		while (priv != NULL) {
-			interruptible_sleep_on(&priv->delta_msr_wait);
+		for (;;) {
+			interruptible_sleep_on(&port->delta_msr_wait);
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
-			else {
+
+			if (port->serial->disconnected)
+				return -EIO;
+
+			{
 				char diff = priv->diff_status;
 				if (diff == 0)
 					return -EIO; /* no change => error */
@@ -1250,7 +1252,7 @@ static void cypress_read_int_callback(st
 	if (priv->current_status != priv->prev_status) {
 		priv->diff_status |= priv->current_status ^
 			priv->prev_status;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 		priv->prev_status = priv->current_status;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);


