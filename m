Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab3CHC1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:27:24 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33502 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322Ab3CHC1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:27:22 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Virupax Sadashivpetimath 
	<virupax.sadashivpetimath@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v2 1/5] usb: musb: ux500_dma: add missing MEM resource check
Date: Fri,  8 Mar 2013 10:27:05 +0800
Message-Id: <1362709629-27238-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362709629-27238-1-git-send-email-fabio.baltieri@linaro.org>
References: <1362709629-27238-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>

Fix dma_controller_create() fail path in case memory resource is
missing.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/musb/ux500_dma.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index 360c99c..6e3db71 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -372,12 +372,17 @@ struct dma_controller *dma_controller_create(struct musb *musb,
 
 	controller = kzalloc(sizeof(*controller), GFP_KERNEL);
 	if (!controller)
-		return NULL;
+		goto kzalloc_fail;
 
 	controller->private_data = musb;
 
 	/* Save physical address for DMA controller. */
 	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iomem) {
+		dev_err(musb->controller, "no memory resource defined\n");
+		goto plat_get_fail;
+	}
+
 	controller->phy_base = (dma_addr_t) iomem->start;
 
 	controller->controller.start = ux500_dma_controller_start;
@@ -389,4 +394,9 @@ struct dma_controller *dma_controller_create(struct musb *musb,
 	controller->controller.is_compatible = ux500_dma_is_compatible;
 
 	return &controller->controller;
+
+plat_get_fail:
+	kfree(controller);
+kzalloc_fail:
+	return NULL;
 }
-- 
1.8.1.3

