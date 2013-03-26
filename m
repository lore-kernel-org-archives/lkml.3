Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965401Ab3CZPlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:41:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965233Ab3CZPXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 101/150] USB: cypress_m8: fix use-after-free in TIOCMIWAIT
Date: Tue, 26 Mar 2013 15:20:00 +0000
Message-Id: <1364311249-14454-102-git-send-email-luis.henriques@canonical.com>
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

commit 356050d8b1e526db093e9d2c78daf49d6bf418e3 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Also remove bogus test for private data pointer being NULL as it is
never assigned in the loop.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/cypress_m8.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index b78c34e..dec5b2f 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -116,7 +116,6 @@ struct cypress_private {
 	int baud_rate;			   /* stores current baud rate in
 					      integer form */
 	int isthrottled;		   /* if throttled, discard reads */
-	wait_queue_head_t delta_msr_wait;  /* used for TIOCMIWAIT */
 	char prev_status, diff_status;	   /* used for TIOCMIWAIT */
 	/* we pass a pointer to this as the argument sent to
 	   cypress_set_termios old_termios */
@@ -452,7 +451,6 @@ static int generic_startup(struct usb_serial *serial)
 		kfree(priv);
 		return -ENOMEM;
 	}
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	usb_reset_configuration(serial->dev);
 
@@ -872,12 +870,16 @@ static int cypress_ioctl(struct tty_struct *tty,
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
@@ -1193,7 +1195,7 @@ static void cypress_read_int_callback(struct urb *urb)
 	if (priv->current_status != priv->prev_status) {
 		priv->diff_status |= priv->current_status ^
 			priv->prev_status;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 		priv->prev_status = priv->current_status;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.8.1.2

