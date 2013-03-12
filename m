Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab3CLLZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:25:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53374 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab3CLLZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:25:44 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <tony@atomide.com>, <mark.rutland@arm.com>, <mkl@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH 7/8] usb: phy: nop: Add device tree support and binding information
Date: Tue, 12 Mar 2013 13:24:25 +0200
Message-ID: <1363087466-32444-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363087466-32444-1-git-send-email-rogerq@ti.com>
References: <1363087466-32444-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PHY clock, clock rate, VCC regulator and RESET regulator
can now be provided via device tree.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 .../devicetree/bindings/usb/usb-nop-xceiv.txt      |   34 +++++++++++++++++++
 drivers/usb/otg/nop-usb-xceiv.c                    |   35 +++++++++++++++----
 2 files changed, 61 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt

diff --git a/Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt b/Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt
new file mode 100644
index 0000000..d7e2726
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt
@@ -0,0 +1,34 @@
+USB NOP PHY
+
+Required properties:
+- compatible: should be usb-nop-xceiv
+
+Optional properties:
+- clocks: phandle to the PHY clock. Use as per Documentation/devicetree
+  /bindings/clock/clock-bindings.txt
+  This property is required if clock-frequency is specified.
+
+- clock-names: Should be "main_clk"
+
+- clock-frequency: the clock frequency (in Hz) that the PHY clock must
+  be configured to.
+
+- vcc-supply: phandle to the regulator that provides RESET to the PHY.
+
+- reset-supply: phandle to the regulator that provides power to the PHY.
+
+Example:
+
+	hsusb1_phy {
+		compatible = "usb-nop-xceiv";
+		clock-frequency = <19200000>;
+		clocks = <&osc 0>;
+		clock-names = "main_clk";
+		vcc-supply = <&hsusb1_vcc_regulator>;
+		reset-supply = <&hsusb1_reset_regulator>;
+	};
+
+hsusb1_phy is a NOP USB PHY device that gets its clock from an oscillator
+and expects that clock to be configured to 19.2MHz by the NOP PHY driver.
+hsusb1_vcc_regulator provides power to the PHY and hsusb1_reset_regulator
+controls RESET.
diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
index fe7a460..b26b1c2 100644
--- a/drivers/usb/otg/nop-usb-xceiv.c
+++ b/drivers/usb/otg/nop-usb-xceiv.c
@@ -34,13 +34,14 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/regulator/consumer.h>
+#include <linux/of.h>
 
 struct nop_usb_xceiv {
-	struct usb_phy		phy;
-	struct device		*dev;
-	struct clk		*clk;
-	struct regulator	*vcc;
-	struct regulator	*reset;
+	struct usb_phy phy;
+	struct device *dev;
+	struct clk *clk;
+	struct regulator *vcc;
+	struct regulator *reset;
 };
 
 static struct platform_device *pd;
@@ -140,10 +141,12 @@ static int nop_set_host(struct usb_otg *otg, struct usb_bus *host)
 
 static int nop_usb_xceiv_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct nop_usb_xceiv_platform_data *pdata = pdev->dev.platform_data;
 	struct nop_usb_xceiv	*nop;
 	enum usb_phy_type	type = USB_PHY_TYPE_USB2;
 	int err;
+	u32 clk_rate = 0;
 
 	nop = devm_kzalloc(&pdev->dev, sizeof(*nop), GFP_KERNEL);
 	if (!nop)
@@ -154,8 +157,16 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 	if (!nop->phy.otg)
 		return -ENOMEM;
 
-	if (pdata)
+	if (dev->of_node) {
+		struct device_node *node = dev->of_node;
+
+		if (of_property_read_u32(node, "clock-frequency", &clk_rate))
+			clk_rate = 0;
+
+	} else if (pdata) {
 		type = pdata->type;
+		clk_rate = pdata->clk_rate;
+	}
 
 	nop->clk = devm_clk_get(&pdev->dev, "main_clk");
 	if (IS_ERR(nop->clk)) {
@@ -163,8 +174,8 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 					PTR_ERR(nop->clk));
 	}
 
-	if (!IS_ERR(nop->clk) && pdata && pdata->clk_rate) {
-		err = clk_set_rate(nop->clk, pdata->clk_rate);
+	if (!IS_ERR(nop->clk) && clk_rate) {
+		err = clk_set_rate(nop->clk, clk_rate);
 		if (err) {
 			dev_err(&pdev->dev, "Error setting clock rate\n");
 			return err;
@@ -237,12 +248,20 @@ static int nop_usb_xceiv_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id nop_xceiv_dt_ids[] = {
+	{ .compatible = "usb-nop-xceiv" },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, nop_xceiv_dt_ids);
+
 static struct platform_driver nop_usb_xceiv_driver = {
 	.probe		= nop_usb_xceiv_probe,
 	.remove		= nop_usb_xceiv_remove,
 	.driver		= {
 		.name	= "nop_usb_xceiv",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(nop_xceiv_dt_ids),
 	},
 };
 
-- 
1.7.4.1

