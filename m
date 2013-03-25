Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab3CYBgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:36:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33854 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755635Ab3CYBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:22 -0400
Message-Id: <20130325010533.648791175@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:58 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 094/104] USB: oti6858: fix use-after-free in TIOCMIWAIT
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

commit 8edfdab37157d2683e51b8be5d3d5697f66a9f7b upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/oti6858.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -196,7 +196,6 @@ struct oti6858_private {
 	u8 setup_done;
 	struct delayed_work delayed_setup_work;
 
-	wait_queue_head_t intr_wait;
 	struct usb_serial_port *port;   /* USB port with which associated */
 };
 
@@ -357,7 +356,6 @@ static int oti6858_startup(struct usb_se
 			break;
 
 		spin_lock_init(&priv->lock);
-		init_waitqueue_head(&priv->intr_wait);
 /*		INIT_WORK(&priv->setup_work, setup_line, serial->port[i]); */
 /*		INIT_WORK(&priv->write_work, send_data, serial->port[i]); */
 		priv->port = port;
@@ -705,11 +703,15 @@ static int wait_modem_info(struct usb_se
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
@@ -821,7 +823,7 @@ static void oti6858_read_int_callback(st
 
 		if (!priv->transient) {
 			if (xs->pin_state != priv->status.pin_state)
-				wake_up_interruptible(&priv->intr_wait);
+				wake_up_interruptible(&port->delta_msr_wait);
 			memcpy(&priv->status, xs, OTI6858_CTRL_PKT_SIZE);
 		}
 


