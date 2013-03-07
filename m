Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab3CGNWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:22:16 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53822 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab3CGNWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:22:12 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <s-guiriec@ti.com>, <gg@slimlogic.co.uk>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <ruchika@ti.com>
Subject: [PATCH v2 1/4] usb: dwc3: set dma_mask for dwc3_omap device
Date: Thu, 7 Mar 2013 18:51:43 +0530
Message-ID: <1362662506-14823-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362662506-14823-1-git-send-email-kishon@ti.com>
References: <1362662506-14823-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*dma_mask* is not set for devices created from dt data. So filled dma_mask
for dwc3_omap device here. And dwc3 core will copy the dma_mask from its
parent.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/core.c      |    4 ++++
 drivers/usb/dwc3/dwc3-omap.c |    3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 66c0572..c845e70 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -454,6 +454,10 @@ static int dwc3_probe(struct platform_device *pdev)
 	dwc->regs_size	= resource_size(res);
 	dwc->dev	= dev;
 
+	dev->dma_mask	= dev->parent->dma_mask;
+	dev->dma_parms	= dev->parent->dma_parms;
+	dma_set_coherent_mask(dev, dev->parent->coherent_dma_mask);
+
 	if (!strncmp("super", maximum_speed, 5))
 		dwc->maximum_speed = DWC3_DCFG_SUPERSPEED;
 	else if (!strncmp("high", maximum_speed, 4))
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 35b9673..546f1fd 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -277,6 +277,8 @@ static void dwc3_omap_disable_irqs(struct dwc3_omap *omap)
 	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_0, 0x00);
 }
 
+static u64 dwc3_omap_dma_mask = DMA_BIT_MASK(32);
+
 static int dwc3_omap_probe(struct platform_device *pdev)
 {
 	struct device_node	*node = pdev->dev.of_node;
@@ -330,6 +332,7 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	omap->dev	= dev;
 	omap->irq	= irq;
 	omap->base	= base;
+	dev->dma_mask	= &dwc3_omap_dma_mask;
 
 	/*
 	 * REVISIT if we ever have two instances of the wrapper, we will be
-- 
1.7.10.4

