Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaEVMPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:15:45 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62214 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaEVMPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:15:44 -0400
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, paulz@synopsys.com,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH] DWC2: intializes the spin_lock earlier in the probe
Date: Thu, 22 May 2014 14:10:10 +0200
Message-Id: <1400760610-13815-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spinlock hsotg->lock is intialized at the end of the probe. However it
may be used from within dwc2_hcd_init(). This patch moves the
initialization before the call to dwc2_hcd_init(). This make the locking
correctness validator happy.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/usb/dwc2/platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 37a8ab0..55fb30d 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -156,6 +156,8 @@ static int dwc2_driver_probe(struct platform_device *dev)
 		params.dma_desc_enable = prop;
 	}
 
+	spin_lock_init(&hsotg->lock);
+
 	if (IS_ENABLED(CONFIG_USB_DWC2_HOST)) {
 		retval = dwc2_hcd_init(hsotg, irq, &params);
 		if (retval)
@@ -175,7 +177,6 @@ static int dwc2_driver_probe(struct platform_device *dev)
 		if (retval)
 			return retval;
 	}
-	spin_lock_init(&hsotg->lock);
 
 	platform_set_drvdata(dev, hsotg);
 	return retval;
-- 
1.9.2

