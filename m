Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934931AbaDJEMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:12:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934735AbaDJDWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 058/134] USB: ark3116: fix use-after-free in TIOCMIWAIT
Date: Wed,  9 Apr 2014 20:22:54 -0700
Message-Id: <20140410032307.522780891@linuxfoundation.org>
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

commit 5018860321dc7a9e50a75d5f319bc981298fb5b7 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ark3116.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -68,7 +68,6 @@ static int is_irda(struct usb_serial *se
 }
 
 struct ark3116_private {
-	wait_queue_head_t       delta_msr_wait;
 	struct async_icount	icount;
 	int			irda;	/* 1 for irda device */
 
@@ -148,7 +147,6 @@ static int ark3116_attach(struct usb_ser
 	if (!priv)
 		return -ENOMEM;
 
-	init_waitqueue_head(&priv->delta_msr_wait);
 	mutex_init(&priv->hw_lock);
 	spin_lock_init(&priv->status_lock);
 
@@ -460,10 +458,14 @@ static int ark3116_ioctl(struct tty_stru
 	case TIOCMIWAIT:
 		for (;;) {
 			struct async_icount prev = priv->icount;
-			interruptible_sleep_on(&priv->delta_msr_wait);
+			interruptible_sleep_on(&port->delta_msr_wait);
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			if ((prev.rng == priv->icount.rng) &&
 			    (prev.dsr == priv->icount.dsr) &&
 			    (prev.dcd == priv->icount.dcd) &&
@@ -584,7 +586,7 @@ static void ark3116_update_msr(struct us
 			priv->icount.dcd++;
 		if (msr & UART_MSR_TERI)
 			priv->icount.rng++;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 }
 


