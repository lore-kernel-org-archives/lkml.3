Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab3BZOd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 09:33:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36925 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758511Ab3BZOdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 09:33:53 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH 2/3] usb: dwc3-omap: remove platform data associated with dwc3-omap
Date: Tue, 26 Feb 2013 20:03:28 +0530
Message-ID: <1361889210-12875-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361889210-12875-1-git-send-email-kishon@ti.com>
References: <1361889210-12875-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap5 is not going to have support for non-dt boot making the platform
data associated with dwc3 useless. Removed it here.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c            |   24 ++++++++++--------------
 include/linux/platform_data/dwc3-omap.h |    4 ----
 2 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index bafff68..38d0516 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -311,7 +311,6 @@ static int dwc3_omap_remove_core(struct device *dev, void *c)
 
 static int dwc3_omap_probe(struct platform_device *pdev)
 {
-	struct dwc3_omap_data	*pdata = pdev->dev.platform_data;
 	struct device_node	*node = pdev->dev.of_node;
 
 	struct dwc3_omap	*omap;
@@ -328,6 +327,11 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	void __iomem		*base;
 	void			*context;
 
+	if (!node) {
+		dev_err(dev, "device node not found\n");
+		return -EINVAL;
+	}
+
 	omap = devm_kzalloc(dev, sizeof(*omap), GFP_KERNEL);
 	if (!omap) {
 		dev_err(dev, "not enough memory\n");
@@ -389,12 +393,7 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 
 	reg = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
 
-	if (node)
-		of_property_read_u32(node, "utmi-mode", &utmi_mode);
-	else if (pdata)
-		utmi_mode = pdata->utmi_mode;
-	else
-		dev_dbg(dev, "missing platform data\n");
+	of_property_read_u32(node, "utmi-mode", &utmi_mode);
 
 	switch (utmi_mode) {
 	case DWC3_OMAP_UTMI_MODE_SW:
@@ -437,13 +436,10 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 
 	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_1, reg);
 
-	if (node) {
-		ret = of_platform_populate(node, NULL, NULL, dev);
-		if (ret) {
-			dev_err(&pdev->dev,
-				"failed to add create dwc3 core\n");
-			return ret;
-		}
+	ret = of_platform_populate(node, NULL, NULL, dev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to create dwc3 core\n");
+		return ret;
 	}
 
 	return 0;
diff --git a/include/linux/platform_data/dwc3-omap.h b/include/linux/platform_data/dwc3-omap.h
index ada4012..1d36ca8 100644
--- a/include/linux/platform_data/dwc3-omap.h
+++ b/include/linux/platform_data/dwc3-omap.h
@@ -41,7 +41,3 @@ enum dwc3_omap_utmi_mode {
 	DWC3_OMAP_UTMI_MODE_HW,
 	DWC3_OMAP_UTMI_MODE_SW,
 };
-
-struct dwc3_omap_data {
-	enum dwc3_omap_utmi_mode	utmi_mode;
-};
-- 
1.7.10.4

