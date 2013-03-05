Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab3CEOWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:22:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53204 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3CEOWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:22:31 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <s-guiriec@ti.com>, <gg@slimlogic.co.uk>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 1/4] usb: dwc3: dwc3-omap: set dma_mask for dwc3 inorder for host mode to work
Date: Tue, 5 Mar 2013 19:51:57 +0530
Message-ID: <1362493320-13913-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362493320-13913-1-git-send-email-kishon@ti.com>
References: <1362493320-13913-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While creating the child devices, *of_platform_populate* sets only
coherent_dma_mask but USBHCD sets *uses_dma* (determines whether the
controller is DMA'able) based on dma_mask. So If we haven't explicitly set
dma_mask, the HCD thinks the controller is not DMA'able and the
controller will fail. So explicity set dma_mask for dwc3 after
*of_platform_populate*.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 35b9673..19c6e72 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -277,6 +277,14 @@ static void dwc3_omap_disable_irqs(struct dwc3_omap *omap)
 	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_0, 0x00);
 }
 
+static u64 dwc3_omap_dma_mask = DMA_BIT_MASK(32);
+
+static int dwc3_omap_set_dmamask(struct device *dev, void *c)
+{
+	dev->dma_mask = &dwc3_omap_dma_mask;
+	return 0;
+}
+
 static int dwc3_omap_probe(struct platform_device *pdev)
 {
 	struct device_node	*node = pdev->dev.of_node;
@@ -381,6 +389,8 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	device_for_each_child(&pdev->dev, NULL, dwc3_omap_set_dmamask);
+
 	return 0;
 }
 
-- 
1.7.10.4

