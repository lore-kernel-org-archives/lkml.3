Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab3DBWMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:12:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760573Ab3DBWMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 072/124] USB: f81232: fix use-after-free in TIOCMIWAIT
Date: Tue,  2 Apr 2013 15:10:54 -0700
Message-Id: <20130402221112.533613748@linuxfoundation.org>
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

commit 508f940f1407656076a2e7d8f7fa059b567ecac2 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/f81232.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -47,7 +47,6 @@ MODULE_DEVICE_TABLE(usb, id_table);
 
 struct f81232_private {
 	spinlock_t lock;
-	wait_queue_head_t delta_msr_wait;
 	u8 line_control;
 	u8 line_status;
 };
@@ -112,7 +111,7 @@ static void f81232_process_read_urb(stru
 	line_status = priv->line_status;
 	priv->line_status &= ~UART_STATE_TRANSIENT_MASK;
 	spin_unlock_irqrestore(&priv->lock, flags);
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	if (!urb->actual_length)
 		return;
@@ -261,11 +260,14 @@ static int wait_modem_info(struct usb_se
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
@@ -327,7 +329,6 @@ static int f81232_port_probe(struct usb_
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	usb_set_serial_port_data(port, priv);
 


