Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965503Ab3CZPhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:37:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54048 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965290Ab3CZPXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 112/150] USB: spcp8x5: fix use-after-free in TIOCMIWAIT
Date: Tue, 26 Mar 2013 15:20:11 +0000
Message-Id: <1364311249-14454-113-git-send-email-luis.henriques@canonical.com>
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

commit dbcea7615d8d7d58f6ff49d2c5568113f70effe9 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5; adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/spcp8x5.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index cad6089..66a4871 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -154,7 +154,6 @@ enum spcp8x5_type {
 struct spcp8x5_private {
 	spinlock_t 	lock;
 	enum spcp8x5_type	type;
-	wait_queue_head_t	delta_msr_wait;
 	u8 			line_control;
 	u8 			line_status;
 };
@@ -188,7 +187,6 @@ static int spcp8x5_startup(struct usb_serial *serial)
 			goto cleanup;
 
 		spin_lock_init(&priv->lock);
-		init_waitqueue_head(&priv->delta_msr_wait);
 		priv->type = type;
 		usb_set_serial_port_data(serial->port[i] , priv);
 	}
@@ -491,7 +489,7 @@ static void spcp8x5_process_read_urb(struct urb *urb)
 	priv->line_status &= ~UART_STATE_TRANSIENT_MASK;
 	spin_unlock_irqrestore(&priv->lock, flags);
 	/* wake up the wait for termios */
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	if (!urb->actual_length)
 		return;
@@ -541,12 +539,15 @@ static int spcp8x5_wait_modem_info(struct usb_serial_port *port,
 
 	while (1) {
 		/* wake up in bulk read */
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
 		spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.8.1.2

