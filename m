Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab3AYDCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:02:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39957 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab3AYDBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:01:10 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v3 07/11] usb: dwc3-omap: remove platform data associated with dwc3-omap
Date: Fri, 25 Jan 2013 08:30:51 +0530
Message-ID: <1359082855-7404-8-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359082855-7404-1-git-send-email-kishon@ti.com>
References: <1359082855-7404-1-git-send-email-kishon@ti.com>
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
index cc2ccba..4e96fbe 100644
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
1.7.9.5

