Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaFDJEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:04:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50901 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaFDJEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:04:52 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org, balbi@ti.com
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        gregkh@linuxfoundation.org, Paul.Zimmerman@synopsys.com, kishon@ti.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v2] usb: dwc3: Keeping 'resource' related code together
Date: Wed,  4 Jun 2014 14:34:52 +0530
Message-Id: <1401872692-7846-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAFp+6iGgyh9eBfHU-XY=v+81oXpNk+OHRd0oUAdVG2tDzgH=gQ@mail.gmail.com>
References: <CAFp+6iGgyh9eBfHU-XY=v+81oXpNk+OHRd0oUAdVG2tDzgH=gQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Putting together the code related to getting the 'IORESOURCE_MEM'
and assigning the same to dwc->xhci_resources, for increasing
the readability.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

Changes from v1:
 - Fixed issue with 'res->start' as pointed out by Paul Zimmerman
   by decrementing it back to its original value.

 drivers/usb/dwc3/core.c |   44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 3f59c12..8b1acad 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -656,6 +656,31 @@ static int dwc3_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	dwc->xhci_resources[0].start = res->start;
+	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
+					DWC3_XHCI_REGS_END;
+	dwc->xhci_resources[0].flags = res->flags;
+	dwc->xhci_resources[0].name = res->name;
+
+	res->start += DWC3_GLOBALS_REGS_START;
+
+	/*
+	 * Request memory region but exclude xHCI regs,
+	 * since it will be requested by the xhci-plat driver.
+	 */
+	regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
+	dwc->regs	= regs;
+	dwc->regs_size	= resource_size(res);
+	/*
+	 * restore res->start back to its original value so that,
+	 * in case the probe is deferred, we don't end up getting error in
+	 * request the memory region the next time probe is called.
+	 */
+	res->start -= DWC3_GLOBALS_REGS_START;
+
 	if (node) {
 		dwc->maximum_speed = of_usb_get_maximum_speed(node);
 
@@ -676,28 +701,9 @@ static int dwc3_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	dwc->xhci_resources[0].start = res->start;
-	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
-					DWC3_XHCI_REGS_END;
-	dwc->xhci_resources[0].flags = res->flags;
-	dwc->xhci_resources[0].name = res->name;
-
-	res->start += DWC3_GLOBALS_REGS_START;
-
-	/*
-	 * Request memory region but exclude xHCI regs,
-	 * since it will be requested by the xhci-plat driver.
-	 */
-	regs = devm_ioremap_resource(dev, res);
-	if (IS_ERR(regs))
-		return PTR_ERR(regs);
-
 	spin_lock_init(&dwc->lock);
 	platform_set_drvdata(pdev, dwc);
 
-	dwc->regs	= regs;
-	dwc->regs_size	= resource_size(res);
-
 	dev->dma_mask	= dev->parent->dma_mask;
 	dev->dma_parms	= dev->parent->dma_parms;
 	dma_set_coherent_mask(dev, dev->parent->coherent_dma_mask);
-- 
1.7.10.4

