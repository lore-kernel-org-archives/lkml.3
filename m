Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaCIH2F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 03:28:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47513 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaCIH1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 03:27:44 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/28 v2] phy: omap-usb2: Provide workaround for USB2PHY false disconnect
Date: Sun, 9 Mar 2014 12:57:38 +0530
Message-ID: <1394350059-20524-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394350059-20524-1-git-send-email-kishon@ti.com>
References: <1394270969-11851-1-git-send-email-kishon@ti.com>
 <1394350059-20524-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Austin Beam <austinbeam@ti.com>

Enable the dra7x errata workaround for false disconnect problem
with USB2PHY. False disconnects were detected with some of the devices.
Reduce the sensitivity of the disconnect logic within the USB2PHY subsystem
to enusre these false disconnects are not registered.

[george.cherian@ti.com]
While at that, pass proper flags for each SoC's. This is a common driver
used across OMAP4,OMAP5,DRA7xx and AM437x USB2PHY.

False disconnect workaround is currently applicable for only DRA7x.

Signed-off-by: Austin Beam <austinbeam@ti.com>
Signed-off-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v1:
removed the Documentation since the name of the file got modified in usb tree.
 drivers/phy/phy-omap-usb2.c  |   44 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/phy/omap_usb.h |    4 ++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 0c78f54..b220202 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -31,6 +31,9 @@
 #include <linux/phy/phy.h>
 #include <linux/of_platform.h>
 
+#define USB2PHY_DISCON_BYP_LATCH (1 << 31)
+#define USB2PHY_ANA_CONFIG1 0x4c
+
 /**
  * omap_usb2_set_comparator - links the comparator present in the sytem with
  *	this phy
@@ -116,7 +119,30 @@ static int omap_usb_power_on(struct phy *x)
 	return 0;
 }
 
+static int omap_usb_init(struct phy *x)
+{
+	struct omap_usb *phy = phy_get_drvdata(x);
+	u32 val;
+
+	if (phy->flags & OMAP_USB2_CALIBRATE_FALSE_DISCONNECT) {
+		/*
+		 *
+		 * Reduce the sensitivity of internal PHY by enabling the
+		 * DISCON_BYP_LATCH of the USB2PHY_ANA_CONFIG1 register. This
+		 * resolves issues with certain devices which can otherwise
+		 * be prone to false disconnects.
+		 *
+		 */
+		val = omap_usb_readl(phy->phy_base, USB2PHY_ANA_CONFIG1);
+		val |= USB2PHY_DISCON_BYP_LATCH;
+		omap_usb_writel(phy->phy_base, USB2PHY_ANA_CONFIG1, val);
+	}
+
+	return 0;
+}
+
 static struct phy_ops ops = {
+	.init		= omap_usb_init,
 	.power_on	= omap_usb_power_on,
 	.power_off	= omap_usb_power_off,
 	.owner		= THIS_MODULE,
@@ -128,6 +154,11 @@ static const struct usb_phy_data omap_usb2_data = {
 	.flags = OMAP_USB2_HAS_START_SRP | OMAP_USB2_HAS_SET_VBUS,
 };
 
+static const struct usb_phy_data dra7x_usb2_data = {
+	.label = "dra7x_usb2",
+	.flags = OMAP_USB2_CALIBRATE_FALSE_DISCONNECT,
+};
+
 static const struct usb_phy_data am437x_usb2_data = {
 	.label = "am437x_usb2",
 	.flags =  0,
@@ -139,6 +170,10 @@ static const struct of_device_id omap_usb2_id_table[] = {
 		.data = &omap_usb2_data,
 	},
 	{
+		.compatible = "ti,dra7x-usb2",
+		.data = &dra7x_usb2_data,
+	},
+	{
 		.compatible = "ti,am437x-usb2",
 		.data = &am437x_usb2_data,
 	},
@@ -151,6 +186,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
 {
 	struct omap_usb	*phy;
 	struct phy *generic_phy;
+	struct resource *res;
 	struct phy_provider *phy_provider;
 	struct usb_otg *otg;
 	struct device_node *node = pdev->dev.of_node;
@@ -185,6 +221,14 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	phy->phy.otg		= otg;
 	phy->phy.type		= USB_PHY_TYPE_USB2;
 
+	if (phy_data->flags & OMAP_USB2_CALIBRATE_FALSE_DISCONNECT) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		phy->phy_base = devm_ioremap_resource(&pdev->dev, res);
+		if (!phy->phy_base)
+			return -ENOMEM;
+		phy->flags |= OMAP_USB2_CALIBRATE_FALSE_DISCONNECT;
+	}
+
 	control_node = of_parse_phandle(node, "ctrl-module", 0);
 	if (!control_node) {
 		dev_err(&pdev->dev, "Failed to get control device phandle\n");
diff --git a/include/linux/phy/omap_usb.h b/include/linux/phy/omap_usb.h
index 35989a8..dc2c541 100644
--- a/include/linux/phy/omap_usb.h
+++ b/include/linux/phy/omap_usb.h
@@ -33,10 +33,13 @@ struct usb_dpll_params {
 struct omap_usb {
 	struct usb_phy		phy;
 	struct phy_companion	*comparator;
+	void __iomem		*pll_ctrl_base;
+	void __iomem		*phy_base;
 	struct device		*dev;
 	struct device		*control_dev;
 	struct clk		*wkupclk;
 	struct clk		*optclk;
+	u8			flags;
 };
 
 struct usb_phy_data {
@@ -47,6 +50,7 @@ struct usb_phy_data {
 /* Driver Flags */
 #define OMAP_USB2_HAS_START_SRP (1 << 0)
 #define OMAP_USB2_HAS_SET_VBUS (1 << 1)
+#define OMAP_USB2_CALIBRATE_FALSE_DISCONNECT (1 << 2)
 
 #define	phy_to_omapusb(x)	container_of((x), struct omap_usb, phy)
 
-- 
1.7.9.5

