Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3DVO3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:29:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51358 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291Ab3DVO3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:14 -0400
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
Message-ID: <lsq.1366640759.345237974@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [04/75] USB: ch341: fix use-after-free in TIOCMIWAIT
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

commit fa1e11d5231c001c80a479160b5832933c5d35fb upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ch341.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -82,7 +82,6 @@ MODULE_DEVICE_TABLE(usb, id_table);
 
 struct ch341_private {
 	spinlock_t lock; /* access lock */
-	wait_queue_head_t delta_msr_wait; /* wait queue for modem status */
 	unsigned baud_rate; /* set baud rate */
 	u8 line_control; /* set line control value RTS/DTR */
 	u8 line_status; /* active status of modem control inputs */
@@ -262,7 +261,6 @@ static int ch341_attach(struct usb_seria
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 	priv->baud_rate = DEFAULT_BAUD_RATE;
 	priv->line_control = CH341_BIT_RTS | CH341_BIT_DTR;
 
@@ -299,7 +297,7 @@ static void ch341_dtr_rts(struct usb_ser
 		priv->line_control &= ~(CH341_BIT_RTS | CH341_BIT_DTR);
 	spin_unlock_irqrestore(&priv->lock, flags);
 	ch341_set_handshake(port->serial->dev, priv->line_control);
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 }
 
 static void ch341_close(struct usb_serial_port *port)
@@ -503,7 +501,7 @@ static void ch341_read_int_callback(stru
 			tty_kref_put(tty);
 		}
 
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 
 exit:
@@ -529,11 +527,14 @@ static int wait_modem_info(struct usb_se
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (!multi_change) {
-		interruptible_sleep_on(&priv->delta_msr_wait);
+		interruptible_sleep_on(&port->delta_msr_wait);
 		/* see if a signal did it */
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		status = priv->line_status;
 		multi_change = priv->multi_status_change;

