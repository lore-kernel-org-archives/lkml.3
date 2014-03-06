Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaCFKAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:00:35 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45184 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbaCFKA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:00:29 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <s.nawrocki@samsung.com>, <tony@atomide.com>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: [PATCH v2 2/3] phy: omap-usb2: Provide workaround for USB2PHY false disconnect
Date: Thu, 6 Mar 2014 15:29:59 +0530
Message-ID: <1394099999-20027-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1393841424-27656-1-git-send-email-george.cherian@ti.com>
References: <1393841424-27656-1-git-send-email-george.cherian@ti.com>
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

Update the Documentation also to add new comaptible.

Signed-off-by: Austin Beam <austinbeam@ti.com>
Signed-off-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
v1 -> v2 
 changed devm_request_and ioremap to devm_ioremap_resource

 drivers/phy/phy-omap-usb2.c  | 44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/omap_usb.h |  3 +++
 2 files changed, 47 insertions(+)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index d54f24b..0ae4129 100644
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
@@ -138,7 +141,30 @@ static int omap_usb_power_on(struct phy *x)
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
@@ -150,6 +176,11 @@ static const struct usb_phy_data omap_usb2_data = {
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
@@ -161,6 +192,10 @@ static const struct of_device_id omap_usb2_id_table[] = {
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
@@ -173,6 +208,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
 {
 	struct omap_usb	*phy;
 	struct phy *generic_phy;
+	struct resource *res;
 	struct phy_provider *phy_provider;
 	struct usb_otg *otg;
 	struct device_node *node = pdev->dev.of_node;
@@ -208,6 +244,14 @@ static int omap_usb2_probe(struct platform_device *pdev)
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
diff --git a/include/linux/usb/omap_usb.h b/include/linux/usb/omap_usb.h
index 034161d..248a603 100644
--- a/include/linux/usb/omap_usb.h
+++ b/include/linux/usb/omap_usb.h
@@ -34,11 +34,13 @@ struct omap_usb {
 	struct usb_phy		phy;
 	struct phy_companion	*comparator;
 	void __iomem		*pll_ctrl_base;
+	void __iomem		*phy_base;
 	struct device		*dev;
 	struct device		*control_dev;
 	struct clk		*wkupclk;
 	struct clk		*sys_clk;
 	struct clk		*optclk;
+	u8			flags;
 	u8			is_suspended:1;
 };
 
@@ -50,6 +52,7 @@ struct usb_phy_data {
 /* Driver Flags */
 #define OMAP_USB2_HAS_START_SRP (1 << 0)
 #define OMAP_USB2_HAS_SET_VBUS (1 << 1)
+#define OMAP_USB2_CALIBRATE_FALSE_DISCONNECT (1 << 2)
 
 #define	phy_to_omapusb(x)	container_of((x), struct omap_usb, phy)
 
-- 
1.8.3.1

