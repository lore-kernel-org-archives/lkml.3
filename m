Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaFEMxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:53:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:20243 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbaFEMxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:53:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,981,1392192000"; 
   d="scan'208";a="441253864"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCHv2 6/6] usb: dwc3: host: convey the PHYs to xhci
Date: Thu,  5 Jun 2014 15:52:58 +0300
Message-Id: <1401972778-5880-7-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms a PHY may need to be handled also in the
host controller driver. Exynos5420 SoC requires some "PHY
tuning" based on the USB speed. This patch delivers dwc3's
PHYs to the xhci platform device when it's created.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/dwc3/host.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index 32db328..8387564 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -27,8 +27,7 @@ int dwc3_host_init(struct dwc3 *dwc)
 	xhci = platform_device_alloc("xhci-hcd", PLATFORM_DEVID_AUTO);
 	if (!xhci) {
 		dev_err(dwc->dev, "couldn't allocate xHCI device\n");
-		ret = -ENOMEM;
-		goto err0;
+		return -ENOMEM;
 	}
 
 	dma_set_coherent_mask(&xhci->dev, dwc->dev->coherent_dma_mask);
@@ -46,22 +45,33 @@ int dwc3_host_init(struct dwc3 *dwc)
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
2.0.0.rc4

