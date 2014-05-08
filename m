Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbaEHJf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:35:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44053 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbaEHJfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:35:51 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <rogerq@ti.com>,
        <kishon@ti.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH 3/5] usb: dwc3: dwc3-omap: Add dwc3_omap_extcon_register function
Date: Thu, 8 May 2014 15:03:05 +0530
Message-ID: <1399541587-14067-4-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399541587-14067-1-git-send-email-george.cherian@ti.com>
References: <1399541587-14067-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the extcon related code to its own function.
Improve code readability, decrease the dwc3_probe() size.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c | 65 ++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index b739a24..0b9b1d8 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -450,6 +450,42 @@ static void dwc3_omap_set_utmi_mode(struct dwc3_omap *omap)
 	dwc3_omap_write_utmi_status(omap, reg);
 }
 
+static int dwc3_omap_extcon_register(struct dwc3_omap *omap)
+{
+	u32			ret;
+	struct device_node	*node = omap->dev->of_node;
+	struct extcon_dev	*edev;
+
+	if (of_property_read_bool(node, "extcon")) {
+		edev = extcon_get_edev_by_phandle(omap->dev, 0);
+		if (IS_ERR(edev)) {
+			dev_vdbg(omap->dev, "couldn't get extcon device\n");
+			return -EPROBE_DEFER;
+		}
+
+		omap->vbus_nb.notifier_call = dwc3_omap_vbus_notifier;
+		ret = extcon_register_interest(&omap->extcon_vbus_dev,
+					       edev->name, "USB",
+					       &omap->vbus_nb);
+		if (ret < 0)
+			dev_vdbg(omap->dev, "failed to register notifier for USB\n");
+
+		omap->id_nb.notifier_call = dwc3_omap_id_notifier;
+		ret = extcon_register_interest(&omap->extcon_id_dev,
+					       edev->name, "USB-HOST",
+					       &omap->id_nb);
+		if (ret < 0)
+			dev_vdbg(omap->dev, "failed to register notifier for USB-HOST\n");
+
+		if (extcon_get_cable_state(edev, "USB") == true)
+			dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);
+		if (extcon_get_cable_state(edev, "USB-HOST") == true)
+			dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_GROUND);
+	}
+
+	return 0;
+}
+
 static int dwc3_omap_probe(struct platform_device *pdev)
 {
 	struct device_node	*node = pdev->dev.of_node;
@@ -457,7 +493,6 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	struct dwc3_omap	*omap;
 	struct resource		*res;
 	struct device		*dev = &pdev->dev;
-	struct extcon_dev	*edev;
 	struct regulator	*vbus_reg = NULL;
 
 	int			ret = -ENOMEM;
@@ -529,31 +564,9 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 
 	dwc3_omap_enable_irqs(omap);
 
-	if (of_property_read_bool(node, "extcon")) {
-		edev = extcon_get_edev_by_phandle(dev, 0);
-		if (IS_ERR(edev)) {
-			dev_vdbg(dev, "couldn't get extcon device\n");
-			ret = -EPROBE_DEFER;
-			goto err2;
-		}
-
-		omap->vbus_nb.notifier_call = dwc3_omap_vbus_notifier;
-		ret = extcon_register_interest(&omap->extcon_vbus_dev,
-			edev->name, "USB", &omap->vbus_nb);
-		if (ret < 0)
-			dev_vdbg(dev, "failed to register notifier for USB\n");
-		omap->id_nb.notifier_call = dwc3_omap_id_notifier;
-		ret = extcon_register_interest(&omap->extcon_id_dev, edev->name,
-					 "USB-HOST", &omap->id_nb);
-		if (ret < 0)
-			dev_vdbg(dev,
-				"failed to register notifier for USB-HOST\n");
-
-		if (extcon_get_cable_state(edev, "USB") == true)
-			dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);
-		if (extcon_get_cable_state(edev, "USB-HOST") == true)
-			dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_GROUND);
-	}
+	ret = dwc3_omap_extcon_register(omap);
+	if (ret < 0)
+		goto err2;
 
 	ret = of_platform_populate(node, NULL, NULL, dev);
 	if (ret) {
-- 
1.8.3.1

