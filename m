Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965283Ab3CZPmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:42:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965229Ab3CZPXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 100/150] USB: ch341: fix use-after-free in TIOCMIWAIT
Date: Tue, 26 Mar 2013 15:19:59 +0000
Message-Id: <1364311249-14454-101-git-send-email-luis.henriques@canonical.com>
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

commit fa1e11d5231c001c80a479160b5832933c5d35fb upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ch341.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index cabd1b1..93c835e 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -82,7 +82,6 @@ MODULE_DEVICE_TABLE(usb, id_table);
 
 struct ch341_private {
 	spinlock_t lock; /* access lock */
-	wait_queue_head_t delta_msr_wait; /* wait queue for modem status */
 	unsigned baud_rate; /* set baud rate */
 	u8 line_control; /* set line control value RTS/DTR */
 	u8 line_status; /* active status of modem control inputs */
@@ -253,7 +252,6 @@ static int ch341_attach(struct usb_serial *serial)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 	priv->baud_rate = DEFAULT_BAUD_RATE;
 	priv->line_control = CH341_BIT_RTS | CH341_BIT_DTR;
 
@@ -289,7 +287,7 @@ static void ch341_dtr_rts(struct usb_serial_port *port, int on)
 		priv->line_control &= ~(CH341_BIT_RTS | CH341_BIT_DTR);
 	spin_unlock_irqrestore(&priv->lock, flags);
 	ch341_set_handshake(port->serial->dev, priv->line_control);
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 }
 
 static void ch341_close(struct usb_serial_port *port)
@@ -482,7 +480,7 @@ static void ch341_read_int_callback(struct urb *urb)
 			tty_kref_put(tty);
 		}
 
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 
 exit:
@@ -508,11 +506,14 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
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
-- 
1.8.1.2

