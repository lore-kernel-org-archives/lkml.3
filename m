Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934821Ab3CZPlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:41:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53995 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965238Ab3CZPXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 102/150] USB: f81232: fix use-after-free in TIOCMIWAIT
Date: Tue, 26 Mar 2013 15:20:01 +0000
Message-Id: <1364311249-14454-103-git-send-email-luis.henriques@canonical.com>
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

commit 508f940f1407656076a2e7d8f7fa059b567ecac2 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backport to 3.5; adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/f81232.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index 499b15f..ea88b47 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -49,7 +49,6 @@ MODULE_DEVICE_TABLE(usb, id_table);
 
 struct f81232_private {
 	spinlock_t lock;
-	wait_queue_head_t delta_msr_wait;
 	u8 line_control;
 	u8 line_status;
 };
@@ -114,7 +113,7 @@ static void f81232_process_read_urb(struct urb *urb)
 	line_status = priv->line_status;
 	priv->line_status &= ~UART_STATE_TRANSIENT_MASK;
 	spin_unlock_irqrestore(&priv->lock, flags);
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	if (!urb->actual_length)
 		return;
@@ -262,11 +261,14 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (1) {
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
@@ -329,7 +331,6 @@ static int f81232_startup(struct usb_serial *serial)
 		if (!priv)
 			goto cleanup;
 		spin_lock_init(&priv->lock);
-		init_waitqueue_head(&priv->delta_msr_wait);
 		usb_set_serial_port_data(serial->port[i], priv);
 	}
 	return 0;
-- 
1.8.1.2

