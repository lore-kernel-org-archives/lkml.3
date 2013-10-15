Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686Ab3JOTzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:55:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52791 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759121Ab3JOTz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:55:28 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <grant.likely@linaro.org>,
        <s.nawrocki@samsung.com>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v2 1/7] usb: dwc3: get "usb_phy" only if the platform indicates the presence of PHY's
Date: Wed, 16 Oct 2013 01:24:11 +0530
Message-ID: <1381866857-3861-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1381866857-3861-1-git-send-email-kishon@ti.com>
References: <1381866857-3861-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There can be systems which does not have a external usb_phy, so get
usb_phy only if dt data indicates the presence of PHY in the case of dt boot or
if platform_data indicates the presence of PHY. Also remove checking if
return value is -ENXIO since it's now changed to always enable usb_phy layer.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
In usb_get_phy_by_phandle, index 0 always refers to usb2 phy and index 1 always
refers to usb3 phy. Since we've lived so long with this, this patch will make
an assumption that if only one entry is populated in *usb-phy* property, it will
be usb2 phy and the next entry will be usb3 phy.

 drivers/usb/dwc3/Kconfig         |    1 +
 drivers/usb/dwc3/core.c          |   72 ++++++++++++++++++++------------------
 drivers/usb/dwc3/platform_data.h |    2 ++
 3 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 70fc430..8e385b4 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -1,6 +1,7 @@
 config USB_DWC3
 	tristate "DesignWare USB3 DRD Core Support"
 	depends on (USB || USB_GADGET) && HAS_DMA
+	select USB_PHY
 	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
 	help
 	  Say Y or M here if your system has a Dual Role SuperSpeed
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 474162e..cb91d70 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -354,6 +354,7 @@ static int dwc3_probe(struct platform_device *pdev)
 	struct device_node	*node = dev->of_node;
 	struct resource		*res;
 	struct dwc3		*dwc;
+	int			count;
 
 	int			ret = -ENOMEM;
 
@@ -387,16 +388,49 @@ static int dwc3_probe(struct platform_device *pdev)
 	if (node) {
 		dwc->maximum_speed = of_usb_get_maximum_speed(node);
 
-		dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
-		dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
+		count = of_count_phandle_with_args(node, "usb-phy", NULL);
+		switch (count) {
+		case 2:
+			dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev,
+				"usb-phy", 1);
+			if (IS_ERR(dwc->usb3_phy)) {
+				dev_err(dev, "usb3 phy not found\n");
+				return PTR_ERR(dwc->usb3_phy);
+			}
+		case 1:
+			dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev,
+				"usb-phy", 0);
+			if (IS_ERR(dwc->usb2_phy)) {
+				dev_err(dev, "usb2 phy not found\n");
+				return PTR_ERR(dwc->usb2_phy);
+			}
+			break;
+		default:
+			dev_err(dev, "usb phy nodes not configured\n");
+		}
 
 		dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
 		dwc->dr_mode = of_usb_get_dr_mode(node);
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
 
-		dwc->usb2_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
-		dwc->usb3_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
+		if (pdata->usb2_phy) {
+			dwc->usb2_phy = devm_usb_get_phy(dev,
+				USB_PHY_TYPE_USB2);
+			if (IS_ERR(dwc->usb2_phy)) {
+				dev_err(dev, "usb2 phy not found\n");
+				return PTR_ERR(dwc->usb2_phy);
+			}
+		}
+
+		if (pdata->usb3_phy) {
+			dwc->usb3_phy = devm_usb_get_phy(dev,
+				USB_PHY_TYPE_USB3);
+			if (IS_ERR(dwc->usb3_phy)) {
+				dev_err(dev, "usb3 phy not found\n");
+				return PTR_ERR(dwc->usb3_phy);
+			}
+		}
 
 		dwc->needs_fifo_resize = pdata->tx_fifo_resize;
 		dwc->dr_mode = pdata->dr_mode;
@@ -409,36 +443,6 @@ static int dwc3_probe(struct platform_device *pdev)
 	if (dwc->maximum_speed == USB_SPEED_UNKNOWN)
 		dwc->maximum_speed = USB_SPEED_SUPER;
 
-	if (IS_ERR(dwc->usb2_phy)) {
-		ret = PTR_ERR(dwc->usb2_phy);
-
-		/*
-		 * if -ENXIO is returned, it means PHY layer wasn't
-		 * enabled, so it makes no sense to return -EPROBE_DEFER
-		 * in that case, since no PHY driver will ever probe.
-		 */
-		if (ret == -ENXIO)
-			return ret;
-
-		dev_err(dev, "no usb2 phy configured\n");
-		return -EPROBE_DEFER;
-	}
-
-	if (IS_ERR(dwc->usb3_phy)) {
-		ret = PTR_ERR(dwc->usb3_phy);
-
-		/*
-		 * if -ENXIO is returned, it means PHY layer wasn't
-		 * enabled, so it makes no sense to return -EPROBE_DEFER
-		 * in that case, since no PHY driver will ever probe.
-		 */
-		if (ret == -ENXIO)
-			return ret;
-
-		dev_err(dev, "no usb3 phy configured\n");
-		return -EPROBE_DEFER;
-	}
-
 	dwc->xhci_resources[0].start = res->start;
 	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
 					DWC3_XHCI_REGS_END;
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 7db34f0..49ffa6d 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -24,4 +24,6 @@ struct dwc3_platform_data {
 	enum usb_device_speed maximum_speed;
 	enum usb_dr_mode dr_mode;
 	bool tx_fifo_resize;
+	bool usb2_phy;
+	bool usb3_phy;
 };
-- 
1.7.10.4

