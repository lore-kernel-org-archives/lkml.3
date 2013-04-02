Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab3DBXHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:07:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253Ab3DBWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 064/124] USB: oti6858: fix use-after-free in TIOCMIWAIT
Date: Tue,  2 Apr 2013 15:10:46 -0700
Message-Id: <20130402221111.603489576@linuxfoundation.org>
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

commit 8edfdab37157d2683e51b8be5d3d5697f66a9f7b upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/oti6858.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -188,7 +188,6 @@ struct oti6858_private {
 	u8 setup_done;
 	struct delayed_work delayed_setup_work;
 
-	wait_queue_head_t intr_wait;
 	struct usb_serial_port *port;   /* USB port with which associated */
 };
 
@@ -339,7 +338,6 @@ static int oti6858_port_probe(struct usb
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->intr_wait);
 	priv->port = port;
 	INIT_DELAYED_WORK(&priv->delayed_setup_work, setup_line);
 	INIT_DELAYED_WORK(&priv->delayed_write_work, send_data);
@@ -664,11 +662,15 @@ static int wait_modem_info(struct usb_se
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (1) {
-		wait_event_interruptible(priv->intr_wait,
+		wait_event_interruptible(port->delta_msr_wait,
+					port->serial->disconnected ||
 					priv->status.pin_state != prev);
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		status = priv->status.pin_state & PIN_MASK;
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -763,7 +765,7 @@ static void oti6858_read_int_callback(st
 
 		if (!priv->transient) {
 			if (xs->pin_state != priv->status.pin_state)
-				wake_up_interruptible(&priv->intr_wait);
+				wake_up_interruptible(&port->delta_msr_wait);
 			memcpy(&priv->status, xs, OTI6858_CTRL_PKT_SIZE);
 		}
 


