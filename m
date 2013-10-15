Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3JOGzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:55:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46429 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab3JOGzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:55:00 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: <tony@atomide.com>, <balbi@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <ijc+devicetree@hellion.org.uk>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <gregkh@linuxfoundation.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 2/2] phy: omap-usb2: Adapt phy-omap-usb2 for AM437x
Date: Tue, 15 Oct 2013 12:23:45 +0530
Message-ID: <1381820025-31376-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1381820025-31376-1-git-send-email-george.cherian@ti.com>
References: <1381820025-31376-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a compatible for AM437x "ti,am43xx-usb2" to
reuse the same phy-omap-usb2 driver.

Also updated the documentation to add the new compatible.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 Documentation/devicetree/bindings/usb/usb-phy.txt |  4 +-
 drivers/phy/phy-omap-usb2.c                       | 54 +++++++++++++++++------
 include/linux/usb/omap_usb.h                      | 10 +++++
 3 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
index c0245c8..309ab27 100644
--- a/Documentation/devicetree/bindings/usb/usb-phy.txt
+++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
@@ -3,7 +3,9 @@ USB PHY
 OMAP USB2 PHY
 
 Required properties:
- - compatible: Should be "ti,omap-usb2"
+ - compatible: Should be either of
+	* "ti,omap-usb2" for OMAP4,OMAP5,DRA7
+	* "ti,am437x-usb2" for AM437x
  - reg : Address and length of the register set for the device.
  - #phy-cells: determine the number of cells that should be given in the
    phandle while referencing this phy.
diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 3e5f08c..7c0bc6c 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -144,6 +144,35 @@ static struct phy_ops ops = {
 	.owner		= THIS_MODULE,
 };
 
+#ifdef CONFIG_OF
+static const struct usb_phy_data omap_usb2_data = {
+	.label = "omap_usb2",
+	.set_host = omap_usb_set_host,
+	.set_peripheral = omap_usb_set_peripheral,
+	.set_vbus = omap_usb_set_vbus,
+	.start_srp = omap_usb_start_srp,
+};
+
+static const struct usb_phy_data am437x_usb2_data = {
+	.label = "am437x_usb2",
+	.set_host = omap_usb_set_host,
+	.set_peripheral = omap_usb_set_peripheral,
+};
+
+static const struct of_device_id omap_usb2_id_table[] = {
+	{
+		.compatible = "ti,omap-usb2",
+		.data = &omap_usb2_data,
+	},
+	{
+		.compatible = "ti,am437x-usb2",
+		.data = &am437x_usb2_data,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap_usb2_id_table);
+#endif
+
 static int omap_usb2_probe(struct platform_device *pdev)
 {
 	struct omap_usb	*phy;
@@ -153,9 +182,14 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	struct device_node *node = pdev->dev.of_node;
 	struct device_node *control_node;
 	struct platform_device *control_pdev;
+	const struct of_device_id *of_id;
+	struct usb_phy_data *phy_data;
+
+	of_id = of_match_device(of_match_ptr(omap_usb2_id_table), &pdev->dev);
 
-	if (!node)
+	if (!of_id)
 		return -EINVAL;
+	phy_data = (struct usb_phy_data *)of_id->data;
 
 	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
 	if (!phy) {
@@ -172,7 +206,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	phy->dev		= &pdev->dev;
 
 	phy->phy.dev		= phy->dev;
-	phy->phy.label		= "omap-usb2";
+	phy->phy.label		= phy_data->label;
 	phy->phy.set_suspend	= omap_usb2_suspend;
 	phy->phy.otg		= otg;
 	phy->phy.type		= USB_PHY_TYPE_USB2;
@@ -199,10 +233,10 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	phy->is_suspended	= 1;
 	omap_control_usb_phy_power(phy->control_dev, 0);
 
-	otg->set_host		= omap_usb_set_host;
-	otg->set_peripheral	= omap_usb_set_peripheral;
-	otg->set_vbus		= omap_usb_set_vbus;
-	otg->start_srp		= omap_usb_start_srp;
+	otg->set_host		= phy_data->set_host;
+	otg->set_peripheral	= phy_data->set_peripheral;
+	otg->set_vbus		= phy_data->set_vbus;
+	otg->start_srp		= phy_data->start_srp;
 	otg->phy		= &phy->phy;
 
 	platform_set_drvdata(pdev, phy);
@@ -297,14 +331,6 @@ static const struct dev_pm_ops omap_usb2_pm_ops = {
 #define DEV_PM_OPS     NULL
 #endif
 
-#ifdef CONFIG_OF
-static const struct of_device_id omap_usb2_id_table[] = {
-	{ .compatible = "ti,omap-usb2" },
-	{}
-};
-MODULE_DEVICE_TABLE(of, omap_usb2_id_table);
-#endif
-
 static struct platform_driver omap_usb2_driver = {
 	.probe		= omap_usb2_probe,
 	.remove		= omap_usb2_remove,
diff --git a/include/linux/usb/omap_usb.h b/include/linux/usb/omap_usb.h
index 6ae2936..0c6b71c 100644
--- a/include/linux/usb/omap_usb.h
+++ b/include/linux/usb/omap_usb.h
@@ -42,6 +42,16 @@ struct omap_usb {
 	u8			is_suspended:1;
 };
 
+struct usb_phy_data {
+	const char *label;
+	int (*set_host)(struct usb_otg *otg, struct usb_bus *host);
+	int (*set_peripheral)(struct usb_otg *otg,
+					struct usb_gadget *gadget);
+	int (*set_vbus)(struct usb_otg *otg, bool enabled);
+	int (*start_srp)(struct usb_otg *otg);
+	int (*start_hnp)(struct usb_otg *otg);
+};
+
 #define	phy_to_omapusb(x)	container_of((x), struct omap_usb, phy)
 
 #if defined(CONFIG_OMAP_USB2) || defined(CONFIG_OMAP_USB2_MODULE)
-- 
1.8.1

