Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3DVO3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:29:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51365 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134Ab3DVO3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.969181393@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [05/75] USB: cypress_m8: fix use-after-free in TIOCMIWAIT
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/cypress_m8.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -150,7 +150,6 @@ struct cypress_private {
 	int baud_rate;			   /* stores current baud rate in
 					      integer form */
 	int isthrottled;		   /* if throttled, discard reads */
-	wait_queue_head_t delta_msr_wait;  /* used for TIOCMIWAIT */
 	char prev_status, diff_status;	   /* used for TIOCMIWAIT */
 	/* we pass a pointer to this as the argument sent to
 	   cypress_set_termios old_termios */
@@ -488,7 +487,6 @@ static int generic_startup(struct usb_se
 		kfree(priv);
 		return -ENOMEM;
 	}
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	usb_reset_configuration(serial->dev);
 
@@ -928,12 +926,16 @@ static int cypress_ioctl(struct tty_stru
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
@@ -1261,7 +1263,7 @@ static void cypress_read_int_callback(st
 	if (priv->current_status != priv->prev_status) {
 		priv->diff_status |= priv->current_status ^
 			priv->prev_status;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 		priv->prev_status = priv->current_status;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);

