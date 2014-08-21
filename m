Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbaHULeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:34:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:29709 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbaHULeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:34:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="591291334"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 6/6] usb: dwc3: host: convey the PHYs to xhci
Date: Thu, 21 Aug 2014 14:33:23 +0300
Message-Id: <1408620803-10464-7-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms a PHY may need to be handled also in the
host controller driver. Exynos5420 SoC requires some "PHY
tuning" based on the USB speed. This patch delivers dwc3's
PHYs to the xhci platform device when it's created.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/dwc3/host.c | 22 ++++++++++++++++------
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
2.1.0

