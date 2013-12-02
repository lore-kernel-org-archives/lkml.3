Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab3LBHFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 02:05:50 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:53268 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab3LBHFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 02:05:33 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 3/3] usb: phy-generic: Add ULPI VBUS support
Date: Mon,  2 Dec 2013 15:05:19 +0800
Message-Id: <1385967919-13258-4-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk>
References: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb: phy-generic: Add ULPI VBUS support

Some platforms need to set the VBUS parameters of the ULPI
like ISP1504 which interact with overcurrent protection and
power switch MIC2575. Therefore it requires to set
* DRVVBUS
* DRVVBUS_EXT
* EXTVBUSIND
* CHRGVBUS
of the ULPI.
This patch add support for it.

Devicetree configuration example:

usbphy0: usbphy@0x10024170 {
 compatible = "usb-nop-xceiv";
 reg = <0x10024170 0x4>; /* ULPI Viewport OTG */
 clocks = <&clks 75>;
 clock-names = "main_clk";
};

&usbphy0 {
        reset-gpios = <&gpio1 31 1>;
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_usbphy0 &pinctrl_usbotg1>;
        ulpi_set_vbus = <0x0f>;
};

Please refer to the phy-bindings.txt for the value of ulpi_set_vbus commit
with this patch.

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
---
 .../devicetree/bindings/phy/phy-bindings.txt       |   15 ++++++
 drivers/usb/phy/phy-generic.c                      |   50 +++++++++++++++++++-
 drivers/usb/phy/phy-generic.h                      |    3 ++
 3 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/phy/phy-bindings.txt b/Documentation/devicetree/bindings/phy/phy-bindings.txt
index 8ae844f..b109b2f 100644
--- a/Documentation/devicetree/bindings/phy/phy-bindings.txt
+++ b/Documentation/devicetree/bindings/phy/phy-bindings.txt
@@ -34,6 +34,18 @@ phys : the phandle for the PHY device (used by the PHY subsystem)
 phy-names : the names of the PHY corresponding to the PHYs present in the
 	    *phys* phandle
 
+Optional Properties:
+reset-gpios :	GPIO used to reset ULPI like ISP1504 with
+		0 = reset active high ; 1 = reset active low.
+cs-gpios :	GPIO used to activate a ULPI like ISP1504 with
+		0 = reset acitive high; 1 = reset active low.
+ulpi_set_vbus :	ULPI configuation parameter to program the VBUS signaling of 
+		ISP1504 or similar chipsets.
+		Set the parameter:
+		DRVVBUS = (1) DRVVBUS_EXT = (1<<1) EXTVBUSIND = (1<<2) CHRGVBUS = (1<<3)
+		eg: DRVVBUS | DRVVBUS_EXT = 0x03
+		    ulpi_set_vbus = <0x03>
+
 Example 1:
 usb1: usb_otg_ss@xxx {
     compatible = "xxx";
@@ -44,6 +56,9 @@ usb1: usb_otg_ss@xxx {
     phy-names = "usb2phy", "usb3phy";
     .
     .
+    reset-gpios = <&gpio6 19 0> /*high active pin */
+    cs-gpios = <&gpio6 20 1> /* low active pin */
+    ulpi_set_vbus = <0x0f>;
 };
 
 This node represents a controller that uses two PHYs, one for usb2 and one for
diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index ff4d68c..9c26b58 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -30,6 +30,7 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/usb/otg.h>
+#include <linux/usb/ulpi.h>
 #include <linux/usb/usb_phy_gen_xceiv.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
@@ -99,6 +100,11 @@ int usb_gen_phy_init(struct usb_phy *phy)
 	/* De-assert RESET */
 	nop_reset_set(nop, 0);
 
+	if (nop->ulpi_vbus > 0) {
+		nop->ulpi->init(nop->ulpi);
+		nop->ulpi->otg->set_vbus(nop->ulpi->otg,true);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(usb_gen_phy_init);
@@ -107,6 +113,10 @@ void usb_gen_phy_shutdown(struct usb_phy *phy)
 {
 	struct usb_phy_gen_xceiv *nop = dev_get_drvdata(phy->dev);
 
+	if (nop->ulpi_vbus > 0) {
+		nop->ulpi->otg->set_vbus(nop->ulpi->otg,false);
+	}
+
 	/* Assert RESET */
 	nop_reset_set(nop, 1);
 
@@ -154,6 +164,27 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xceiv *nop,
 {
 	int err;
 
+	if (nop->ulpi_vbus > 0) {
+		unsigned int flags = 0;
+
+		if (nop->ulpi_vbus & 0x1)
+			flags |= ULPI_OTG_DRVVBUS;
+		if (nop->ulpi_vbus & 0x2)
+			flags |= ULPI_OTG_DRVVBUS_EXT;
+		if (nop->ulpi_vbus & 0x4)
+			flags |= ULPI_OTG_EXTVBUSIND;
+		if (nop->ulpi_vbus & 0x8)
+			flags |= ULPI_OTG_CHRGVBUS;
+
+		nop->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, flags);
+		if (!nop->ulpi) {
+			dev_err(dev, "Failed create ULPI Phy\n");
+			return -ENOMEM;
+		}
+		dev_dbg(dev, "Create ULPI Phy\n");
+		nop->ulpi->io_priv =  nop->viewport;
+	}
+
 	nop->phy.otg = devm_kzalloc(dev, sizeof(*nop->phy.otg),
 			GFP_KERNEL);
 	if (!nop->phy.otg)
@@ -253,14 +284,15 @@ static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
 
 	if (dev->of_node) {
 		struct device_node *node = dev->of_node;
+		struct resource	*res;
 		enum of_gpio_flags flags;
 		enum of_gpio_flags csflags;
+		u32 ulpi_vbus;
 
 		if (of_property_read_u32(node, "clock-frequency", &clk_rate))
 			clk_rate = 0;
 
 		needs_vcc = of_property_read_bool(node, "vcc-supply");
-
 		nop->gpio_reset = of_get_named_gpio_flags(node, "reset-gpios",
 								0, &flags);
 
@@ -274,6 +306,22 @@ static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
 		if (gpio_is_valid(nop->gpio_chipselect))
 			nop->cs_active_low = csflags & OF_GPIO_ACTIVE_LOW;
 
+		err = of_property_read_u32(node, "ulpi_set_vbus",&ulpi_vbus);
+		if (err) {
+			nop->ulpi_vbus = -1;
+			nop->viewport = NULL;
+			ulpi_vbus = 0;
+		} else {
+			dev_dbg(dev,"ULPI ulpi_set_vbus 0x%02x",ulpi_vbus);
+			nop->ulpi_vbus = ulpi_vbus;
+			res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+			nop->viewport = devm_ioremap_resource(dev, res);
+			if (IS_ERR(nop->viewport)) {
+				dev_err(dev,"No IORESOURCE_MEM for ULPI Viewport");
+				return PTR_ERR(nop->viewport);
+			}
+		}
+
 	} else if (pdata) {
 		type = pdata->type;
 		clk_rate = pdata->clk_rate;
diff --git a/drivers/usb/phy/phy-generic.h b/drivers/usb/phy/phy-generic.h
index 97eafc2..0f6f1fc 100644
--- a/drivers/usb/phy/phy-generic.h
+++ b/drivers/usb/phy/phy-generic.h
@@ -3,13 +3,16 @@
 
 struct usb_phy_gen_xceiv {
 	struct usb_phy phy;
+	struct usb_phy *ulpi;
 	struct device *dev;
 	struct clk *clk;
 	struct regulator *vcc;
 	int gpio_reset;
 	int gpio_chipselect;
+	int ulpi_vbus;
 	bool reset_active_low;
 	bool cs_active_low;
+	void __iomem *viewport;
 };
 
 int usb_gen_phy_init(struct usb_phy *phy);
-- 
1.7.10.4

