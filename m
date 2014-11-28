Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaK1N41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:56:27 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:49922 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaK1NvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:09 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/17] net2280: remove full_speed module parameter
Date: Fri, 28 Nov 2014 14:50:47 +0100
Message-Id: <1417182662-7405-3-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the full_speed parameter used force full-speed
operation.

It was designed exclusively for testing purposes, and there is no
reason to maintain this in a production kernel.

Reverts: 2f0760774711c957c395b31131b848043af98edf
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index 08c16ee..27b94c6 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -113,11 +113,6 @@ static bool enable_suspend;
 /* "modprobe net2280 enable_suspend=1" etc */
 module_param(enable_suspend, bool, 0444);
 
-/* force full-speed operation */
-static bool full_speed;
-module_param(full_speed, bool, 0444);
-MODULE_PARM_DESC(full_speed, "force full-speed mode -- for testing only!");
-
 #define	DIR_STRING(bAddress) (((bAddress) & USB_DIR_IN) ? "in" : "out")
 
 static char *type_string(u8 bmAttributes)
@@ -2291,11 +2286,7 @@ static int net2280_start(struct usb_gadget *_gadget,
 	if (retval)
 		goto err_func;
 
-	/* Enable force-full-speed testing mode, if desired */
-	if (full_speed && (dev->quirks & PLX_LEGACY))
-		writel(BIT(FORCE_FULL_SPEED_MODE), &dev->usb->xcvrdiag);
-
-	/* ... then enable host detection and ep0; and we're ready
+	/* enable host detection and ep0; and we're ready
 	 * for set_configuration as well as eventual disconnect.
 	 */
 	net2280_led_active(dev, 1);
@@ -2353,10 +2344,6 @@ static int net2280_stop(struct usb_gadget *_gadget)
 
 	net2280_led_active(dev, 0);
 
-	/* Disable full-speed test mode */
-	if (dev->quirks & PLX_LEGACY)
-		writel(0, &dev->usb->xcvrdiag);
-
 	device_remove_file(&dev->pdev->dev, &dev_attr_function);
 	device_remove_file(&dev->pdev->dev, &dev_attr_queues);
 
@@ -3655,9 +3642,6 @@ static void net2280_shutdown(struct pci_dev *pdev)
 	/* disable the pullup so the host will think we're gone */
 	writel(0, &dev->usb->usbctl);
 
-	/* Disable full-speed test mode */
-	if (dev->quirks & PLX_LEGACY)
-		writel(0, &dev->usb->xcvrdiag);
 }
 
 
-- 
2.1.3

