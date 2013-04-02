Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab3DBWsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:48:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319Ab3DBWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 075/124] USB: cypress_m8: fix use-after-free in TIOCMIWAIT
Date: Tue,  2 Apr 2013 15:10:57 -0700
Message-Id: <20130402221112.888774291@linuxfoundation.org>
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

commit 356050d8b1e526db093e9d2c78daf49d6bf418e3 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Also remove bogus test for private data pointer being NULL as it is
never assigned in the loop.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cypress_m8.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -111,7 +111,6 @@ struct cypress_private {
 	int baud_rate;			   /* stores current baud rate in
 					      integer form */
 	int isthrottled;		   /* if throttled, discard reads */
-	wait_queue_head_t delta_msr_wait;  /* used for TIOCMIWAIT */
 	char prev_status, diff_status;	   /* used for TIOCMIWAIT */
 	/* we pass a pointer to this as the argument sent to
 	   cypress_set_termios old_termios */
@@ -449,7 +448,6 @@ static int cypress_generic_port_probe(st
 		kfree(priv);
 		return -ENOMEM;
 	}
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	usb_reset_configuration(serial->dev);
 
@@ -868,12 +866,16 @@ static int cypress_ioctl(struct tty_stru
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
@@ -1187,7 +1189,7 @@ static void cypress_read_int_callback(st
 	if (priv->current_status != priv->prev_status) {
 		priv->diff_status |= priv->current_status ^
 			priv->prev_status;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 		priv->prev_status = priv->current_status;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);


