Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965322Ab3CZPXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:23:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54041 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965283Ab3CZPXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 111/150] USB: quatech2: fix use-after-free in TIOCMIWAIT
Date: Tue, 26 Mar 2013 15:20:10 +0000
Message-Id: <1364311249-14454-112-git-send-email-luis.henriques@canonical.com>
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

commit 69f87f40d2b98e8b4ab82a121fd2bd584690b887 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5; adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/quatech2.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index e1065f8..1c2c0ba 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -132,7 +132,6 @@ struct qt2_port_private {
 	u8          shadowLSR;
 	u8          shadowMSR;
 
-	wait_queue_head_t   delta_msr_wait; /* Used for TIOCMIWAIT */
 	struct async_icount icount;
 
 	struct usb_serial_port *port;
@@ -528,8 +527,9 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (1) {
-		wait_event_interruptible(priv->delta_msr_wait,
-					 ((priv->icount.rng != prev.rng) ||
+		wait_event_interruptible(port->delta_msr_wait,
+					 (port->serial->disconnected ||
+					  (priv->icount.rng != prev.rng) ||
 					  (priv->icount.dsr != prev.dsr) ||
 					  (priv->icount.dcd != prev.dcd) ||
 					  (priv->icount.cts != prev.cts)));
@@ -537,6 +537,9 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		cur = priv->icount;
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -881,7 +884,6 @@ static int qt2_attach(struct usb_serial *serial)
 
 		spin_lock_init(&port_priv->lock);
 		spin_lock_init(&port_priv->urb_lock);
-		init_waitqueue_head(&port_priv->delta_msr_wait);
 
 		port_priv->port = serial->port[pcount];
 
@@ -1015,7 +1017,7 @@ static void qt2_update_msr(struct usb_serial_port *port, unsigned char *ch)
 		if (newMSR & UART_MSR_TERI)
 			port_priv->icount.rng++;
 
-		wake_up_interruptible(&port_priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 }
 
-- 
1.8.1.2

