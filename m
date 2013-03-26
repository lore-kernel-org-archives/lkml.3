Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965393Ab3CZPid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:38:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54031 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965269Ab3CZPX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 109/150] USB: oti6858: fix use-after-free in TIOCMIWAIT
Date: Tue, 26 Mar 2013 15:20:08 +0000
Message-Id: <1364311249-14454-110-git-send-email-luis.henriques@canonical.com>
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

commit 8edfdab37157d2683e51b8be5d3d5697f66a9f7b upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5; adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/oti6858.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index 5976b65..d9c40b1 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -191,7 +191,6 @@ struct oti6858_private {
 	u8 setup_done;
 	struct delayed_work delayed_setup_work;
 
-	wait_queue_head_t intr_wait;
 	struct usb_serial_port *port;   /* USB port with which associated */
 };
 
@@ -345,7 +344,6 @@ static int oti6858_startup(struct usb_serial *serial)
 			break;
 
 		spin_lock_init(&priv->lock);
-		init_waitqueue_head(&priv->intr_wait);
 /*		INIT_WORK(&priv->setup_work, setup_line, serial->port[i]); */
 /*		INIT_WORK(&priv->write_work, send_data, serial->port[i]); */
 		priv->port = port;
@@ -672,11 +670,15 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
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
@@ -783,7 +785,7 @@ static void oti6858_read_int_callback(struct urb *urb)
 
 		if (!priv->transient) {
 			if (xs->pin_state != priv->status.pin_state)
-				wake_up_interruptible(&priv->intr_wait);
+				wake_up_interruptible(&port->delta_msr_wait);
 			memcpy(&priv->status, xs, OTI6858_CTRL_PKT_SIZE);
 		}
 
-- 
1.8.1.2

