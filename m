Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab3DBWuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:50:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290Ab3DBWMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 070/124] USB: ch341: fix use-after-free in TIOCMIWAIT
Date: Tue,  2 Apr 2013 15:10:52 -0700
Message-Id: <20130402221112.308953445@linuxfoundation.org>
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

commit fa1e11d5231c001c80a479160b5832933c5d35fb upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ch341.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -80,7 +80,6 @@ MODULE_DEVICE_TABLE(usb, id_table);
 
 struct ch341_private {
 	spinlock_t lock; /* access lock */
-	wait_queue_head_t delta_msr_wait; /* wait queue for modem status */
 	unsigned baud_rate; /* set baud rate */
 	u8 line_control; /* set line control value RTS/DTR */
 	u8 line_status; /* active status of modem control inputs */
@@ -252,7 +251,6 @@ static int ch341_port_probe(struct usb_s
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 	priv->baud_rate = DEFAULT_BAUD_RATE;
 	priv->line_control = CH341_BIT_RTS | CH341_BIT_DTR;
 
@@ -298,7 +296,7 @@ static void ch341_dtr_rts(struct usb_ser
 		priv->line_control &= ~(CH341_BIT_RTS | CH341_BIT_DTR);
 	spin_unlock_irqrestore(&priv->lock, flags);
 	ch341_set_handshake(port->serial->dev, priv->line_control);
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 }
 
 static void ch341_close(struct usb_serial_port *port)
@@ -491,7 +489,7 @@ static void ch341_read_int_callback(stru
 			tty_kref_put(tty);
 		}
 
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 
 exit:
@@ -517,11 +515,14 @@ static int wait_modem_info(struct usb_se
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


