Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3KJTgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 14:36:09 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:63728 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab3KJTgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 14:36:00 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] drivers: usb: goku: remove unused argument
Date: Sun, 10 Nov 2013 20:35:55 +0100
Message-Id: <1384112155-25012-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

The stop_activity function never uses driver argument (even
though it modifies it) and thus it is safe to remove it.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/goku_udc.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index f827680..7eda9fd 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1350,16 +1350,12 @@ static int goku_udc_start(struct usb_gadget *g,
 	return 0;
 }
 
-static void
-stop_activity(struct goku_udc *dev, struct usb_gadget_driver *driver)
+static void stop_activity(struct goku_udc *dev)
 {
 	unsigned	i;
 
 	DBG (dev, "%s\n", __func__);
 
-	if (dev->gadget.speed == USB_SPEED_UNKNOWN)
-		driver = NULL;
-
 	/* disconnect gadget driver after quiesceing hw and the driver */
 	udc_reset (dev);
 	for (i = 0; i < 4; i++)
@@ -1377,7 +1373,7 @@ static int goku_udc_stop(struct usb_gadget *g,
 
 	spin_lock_irqsave(&dev->lock, flags);
 	dev->driver = NULL;
-	stop_activity(dev, driver);
+	stop_activity(dev);
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	return 0;
@@ -1521,7 +1517,7 @@ rescan:
 	if (unlikely(stat & INT_DEVWIDE)) {
 		if (stat & INT_SYSERROR) {
 			ERROR(dev, "system error\n");
-			stop_activity(dev, dev->driver);
+			stop_activity(dev);
 			stat = 0;
 			handled = 1;
 			// FIXME have a neater way to prevent re-enumeration
@@ -1536,7 +1532,7 @@ rescan:
 			} else {
 				DBG(dev, "disconnect\n");
 				if (dev->gadget.speed == USB_SPEED_FULL)
-					stop_activity(dev, dev->driver);
+					stop_activity(dev);
 				dev->ep0state = EP0_DISCONNECT;
 				dev->int_enable = INT_DEVWIDE;
 				writel(dev->int_enable, &dev->regs->int_enable);
-- 
1.8.3.2

