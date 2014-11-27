Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaK0G0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:26:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59577 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbaK0G0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:47 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/25] usb: dwc3: host: convey the PHYs to xhci
Date: Thu, 27 Nov 2014 11:56:10 +0530
Message-ID: <1417069577-1169-19-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

On some platforms a PHY may need to be handled also in the
host controller driver. Exynos5420 SoC requires some "PHY
tuning" based on the USB speed. This patch delivers dwc3's
PHYs to the xhci platform device when it's created.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/host.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index dcb8ca0..12bfd3c 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -29,8 +29,7 @@ int dwc3_host_init(struct dwc3 *dwc)
 	xhci = platform_device_alloc("xhci-hcd", PLATFORM_DEVID_AUTO);
 	if (!xhci) {
 		dev_err(dwc->dev, "couldn't allocate xHCI device\n");
-		ret = -ENOMEM;
-		goto err0;
+		return -ENOMEM;
 	}
 
 	dma_set_coherent_mask(&xhci->dev, dwc->dev->coherent_dma_mask);
@@ -60,22 +59,33 @@ int dwc3_host_init(struct dwc3 *dwc)
 		goto err1;
 	}
 
+	phy_create_lookup(dwc->usb2_generic_phy, "usb2-phy",
+			  dev_name(&xhci->dev));
+	phy_create_lookup(dwc->usb3_generic_phy, "usb3-phy",
+			  dev_name(&xhci->dev));
+
 	ret = platform_device_add(xhci);
 	if (ret) {
 		dev_err(dwc->dev, "failed to register xHCI device\n");
-		goto err1;
+		goto err2;
 	}
 
 	return 0;
-
+err2:
+	phy_remove_lookup(dwc->usb2_generic_phy, "usb2-phy",
+			  dev_name(&xhci->dev));
+	phy_remove_lookup(dwc->usb3_generic_phy, "usb3-phy",
+			  dev_name(&xhci->dev));
 err1:
 	platform_device_put(xhci);
-
-err0:
 	return ret;
 }
 
 void dwc3_host_exit(struct dwc3 *dwc)
 {
+	phy_remove_lookup(dwc->usb2_generic_phy, "usb2-phy",
+			  dev_name(&dwc->xhci->dev));
+	phy_remove_lookup(dwc->usb3_generic_phy, "usb3-phy",
+			  dev_name(&dwc->xhci->dev));
 	platform_device_unregister(dwc->xhci);
 }
-- 
1.7.9.5

