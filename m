Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965332Ab3CZPXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:23:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54051 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965297Ab3CZPXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 113/150] USB: ssu100: fix use-after-free in TIOCMIWAIT
Date: Tue, 26 Mar 2013 15:20:12 +0000
Message-Id: <1364311249-14454-114-git-send-email-luis.henriques@canonical.com>
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

commit 43a66b4c417ad15f6d2f632ce67ad195bdf999e8 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5; adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ssu100.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index c4409b1..3ad10b5 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -65,7 +65,6 @@ struct ssu100_port_private {
 	spinlock_t status_lock;
 	u8 shadowLSR;
 	u8 shadowMSR;
-	wait_queue_head_t delta_msr_wait; /* Used for TIOCMIWAIT */
 	struct async_icount icount;
 };
 
@@ -366,8 +365,9 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	spin_unlock_irqrestore(&priv->status_lock, flags);
 
 	while (1) {
-		wait_event_interruptible(priv->delta_msr_wait,
-					 ((priv->icount.rng != prev.rng) ||
+		wait_event_interruptible(port->delta_msr_wait,
+					 (port->serial->disconnected ||
+					  (priv->icount.rng != prev.rng) ||
 					  (priv->icount.dsr != prev.dsr) ||
 					  (priv->icount.dcd != prev.dcd) ||
 					  (priv->icount.cts != prev.cts)));
@@ -375,6 +375,9 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->status_lock, flags);
 		cur = priv->icount;
 		spin_unlock_irqrestore(&priv->status_lock, flags);
@@ -455,7 +458,6 @@ static int ssu100_attach(struct usb_serial *serial)
 	}
 
 	spin_lock_init(&priv->status_lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 	usb_set_serial_port_data(port, priv);
 
 	return ssu100_initdevice(serial->dev);
@@ -536,7 +538,7 @@ static void ssu100_update_msr(struct usb_serial_port *port, u8 msr)
 			priv->icount.dcd++;
 		if (msr & UART_MSR_TERI)
 			priv->icount.rng++;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 }
 
-- 
1.8.1.2

