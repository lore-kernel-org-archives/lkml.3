Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965151AbaDJEIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:08:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934795AbaDJDWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 068/134] USB: pl2303: fix use-after-free in TIOCMIWAIT
Date: Wed,  9 Apr 2014 20:23:04 -0700
Message-Id: <20140410032308.840713732@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 40509ca982c00c4b70fc00be887509feca0bff15 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/pl2303.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -149,7 +149,6 @@ enum pl2303_type {
 
 struct pl2303_private {
 	spinlock_t lock;
-	wait_queue_head_t delta_msr_wait;
 	u8 line_control;
 	u8 line_status;
 	enum pl2303_type type;
@@ -203,7 +202,6 @@ static int pl2303_startup(struct usb_ser
 		if (!priv)
 			goto cleanup;
 		spin_lock_init(&priv->lock);
-		init_waitqueue_head(&priv->delta_msr_wait);
 		priv->type = type;
 		usb_set_serial_port_data(serial->port[i], priv);
 	}
@@ -595,11 +593,14 @@ static int wait_modem_info(struct usb_se
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
@@ -721,7 +722,7 @@ static void pl2303_update_line_status(st
 	spin_unlock_irqrestore(&priv->lock, flags);
 	if (priv->line_status & UART_BREAK_ERROR)
 		usb_serial_handle_break(port);
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	tty = tty_port_tty_get(&port->port);
 	if (!tty)
@@ -788,7 +789,7 @@ static void pl2303_process_read_urb(stru
 	line_status = priv->line_status;
 	priv->line_status &= ~UART_STATE_TRANSIENT_MASK;
 	spin_unlock_irqrestore(&priv->lock, flags);
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	if (!urb->actual_length)
 		return;


