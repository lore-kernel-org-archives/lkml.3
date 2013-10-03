Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3JCPNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:13:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39675 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554Ab3JCPNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:13:35 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>, <balbi@ti.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <george.cherian@ti.com>,
        <kishon@ti.com>, <bigeasy@linutronix.de>,
        <sergei.shtylyov@cogentembedded.com>, <thomas.langer@lantiq.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v8 2/8] usb: phy: omap: Add new device types and remove omap_control_usb3_phy_power()
Date: Thu, 3 Oct 2013 18:12:31 +0300
Message-ID: <1380813157-22311-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1380813157-22311-1-git-send-email-rogerq@ti.com>
References: <1380813157-22311-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for new device types and in the process rid of "ti,type"
device tree property. The correct type of device will be determined
from the compatible string instead.

Introduce a compatible string for each device type. At the moment
we support 4 types OTGHS, USB2, PIPE3 (e.g. USB3) and DRA7USB2.

Update DT binding information to reflect these changes.

Also get rid of omap_control_usb3_phy_power(). Just one function
i.e. omap_control_usb_phy_power() will now take care of all PHY types.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/usb/omap-usb.txt |   30 ++--
 drivers/usb/phy/phy-omap-control.c                 |  173 +++++++++++--------
 drivers/usb/phy/phy-omap-usb3.c                    |    6 +-
 include/linux/usb/omap_control_usb.h               |   24 ++--
 4 files changed, 130 insertions(+), 103 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index 661cb06..9add35c 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -83,22 +83,22 @@ omap_dwc3 {
 OMAP CONTROL USB
 
 Required properties:
- - compatible: Should be "ti,omap-control-usb"
+ - compatible: Should be one of
+ "ti,control-phy-otghs" - if it has otghs_control mailbox register as on OMAP4.
+ "ti,control-phy-usb2" - if it has Power down bit in control_dev_conf register
+			e.g. USB2_PHY on OMAP5.
+ "ti,control-phy-pipe3" - if it has DPLL and individual Rx & Tx power control
+			e.g. USB3 PHY and SATA PHY on OMAP5.
+ "ti,control-phy-dra7usb2" - if it has power down register like USB2 PHY on
+			DRA7 platform.
  - reg : Address and length of the register set for the device. It contains
-   the address of "control_dev_conf" and "otghs_control" or "phy_power_usb"
-   depending upon omap4 or omap5.
- - reg-names: The names of the register addresses corresponding to the registers
-   filled in "reg".
- - ti,type: This is used to differentiate whether the control module has
-   usb mailbox or usb3 phy power. omap4 has usb mailbox in control module to
-   notify events to the musb core and omap5 has usb3 phy power register to
-   power on usb3 phy. Should be "1" if it has mailbox and "2" if it has usb3
-   phy power.
+   the address of "otghs_control" for control-phy-otghs or "power" register
+   for other types.
+ - reg-names: should be "otghs_control" control-phy-otghs and "power" for
+   other types.
 
 omap_control_usb: omap-control-usb@4a002300 {
-	compatible = "ti,omap-control-usb";
-	reg = <0x4a002300 0x4>,
-	      <0x4a00233c 0x4>;
-	reg-names = "control_dev_conf", "otghs_control";
-	ti,type = <1>;
+	compatible = "ti,control-phy-otghs";
+	reg = <0x4a00233c 0x4>;
+	reg-names = "otghs_control";
 };
diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/usb/phy/phy-omap-control.c
index 9772592..1c8a7c5 100644
--- a/drivers/usb/phy/phy-omap-control.c
+++ b/drivers/usb/phy/phy-omap-control.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/clk.h>
@@ -46,61 +47,70 @@ struct device *omap_get_control_dev(void)
 EXPORT_SYMBOL_GPL(omap_get_control_dev);
 
 /**
- * omap_control_usb3_phy_power - power on/off the serializer using control
- *	module
+ * omap_control_usb_phy_power - power on/off the phy using control module reg
  * @dev: the control module device
- * @on: 0 to off and 1 to on based on powering on or off the PHY
- *
- * usb3 PHY driver should call this API to power on or off the PHY.
+ * @on: 0 or 1, based on powering on or off the PHY
  */
-void omap_control_usb3_phy_power(struct device *dev, bool on)
+void omap_control_usb_phy_power(struct device *dev, int on)
 {
 	u32 val;
 	unsigned long rate;
-	struct omap_control_usb	*control_usb = dev_get_drvdata(dev);
+	struct omap_control_usb	*control_usb;
 
-	if (control_usb->type != OMAP_CTRL_DEV_TYPE2)
+	if (IS_ERR(dev) || !dev) {
+		pr_err("%s: invalid device\n", __func__);
 		return;
+	}
 
-	rate = clk_get_rate(control_usb->sys_clk);
-	rate = rate/1000000;
-
-	val = readl(control_usb->phy_power);
-
-	if (on) {
-		val &= ~(OMAP_CTRL_USB_PWRCTL_CLK_CMD_MASK |
-			OMAP_CTRL_USB_PWRCTL_CLK_FREQ_MASK);
-		val |= OMAP_CTRL_USB3_PHY_TX_RX_POWERON <<
-			OMAP_CTRL_USB_PWRCTL_CLK_CMD_SHIFT;
-		val |= rate << OMAP_CTRL_USB_PWRCTL_CLK_FREQ_SHIFT;
-	} else {
-		val &= ~OMAP_CTRL_USB_PWRCTL_CLK_CMD_MASK;
-		val |= OMAP_CTRL_USB3_PHY_TX_RX_POWEROFF <<
-			OMAP_CTRL_USB_PWRCTL_CLK_CMD_SHIFT;
+	control_usb = dev_get_drvdata(dev);
+	if (!control_usb) {
+		dev_err(dev, "%s: invalid control usb device\n", __func__);
+		return;
 	}
 
-	writel(val, control_usb->phy_power);
-}
-EXPORT_SYMBOL_GPL(omap_control_usb3_phy_power);
+	if (control_usb->type == OMAP_CTRL_TYPE_OTGHS)
+		return;
 
-/**
- * omap_control_usb_phy_power - power on/off the phy using control module reg
- * @dev: the control module device
- * @on: 0 or 1, based on powering on or off the PHY
- */
-void omap_control_usb_phy_power(struct device *dev, int on)
-{
-	u32 val;
-	struct omap_control_usb	*control_usb = dev_get_drvdata(dev);
+	val = readl(control_usb->power);
+
+	switch (control_usb->type) {
+	case OMAP_CTRL_TYPE_USB2:
+		if (on)
+			val &= ~OMAP_CTRL_DEV_PHY_PD;
+		else
+			val |= OMAP_CTRL_DEV_PHY_PD;
+		break;
 
-	val = readl(control_usb->dev_conf);
+	case OMAP_CTRL_TYPE_PIPE3:
+		rate = clk_get_rate(control_usb->sys_clk);
+		rate = rate/1000000;
+
+		if (on) {
+			val &= ~(OMAP_CTRL_USB_PWRCTL_CLK_CMD_MASK |
+					OMAP_CTRL_USB_PWRCTL_CLK_FREQ_MASK);
+			val |= OMAP_CTRL_USB3_PHY_TX_RX_POWERON <<
+				OMAP_CTRL_USB_PWRCTL_CLK_CMD_SHIFT;
+			val |= rate << OMAP_CTRL_USB_PWRCTL_CLK_FREQ_SHIFT;
+		} else {
+			val &= ~OMAP_CTRL_USB_PWRCTL_CLK_CMD_MASK;
+			val |= OMAP_CTRL_USB3_PHY_TX_RX_POWEROFF <<
+				OMAP_CTRL_USB_PWRCTL_CLK_CMD_SHIFT;
+		}
+		break;
 
-	if (on)
-		val &= ~OMAP_CTRL_DEV_PHY_PD;
-	else
-		val |= OMAP_CTRL_DEV_PHY_PD;
+	case OMAP_CTRL_TYPE_DRA7USB2:
+		if (on)
+			val &= ~OMAP_CTRL_USB2_PHY_PD;
+		else
+			val |= OMAP_CTRL_USB2_PHY_PD;
+		break;
+	default:
+		dev_err(dev, "%s: type %d not recognized\n",
+					__func__, control_usb->type);
+		break;
+	}
 
-	writel(val, control_usb->dev_conf);
+	writel(val, control_usb->power);
 }
 EXPORT_SYMBOL_GPL(omap_control_usb_phy_power);
 
@@ -172,7 +182,7 @@ void omap_control_usb_set_mode(struct device *dev,
 {
 	struct omap_control_usb	*ctrl_usb;
 
-	if (IS_ERR(dev) || control_usb->type != OMAP_CTRL_DEV_TYPE1)
+	if (IS_ERR(dev) || control_usb->type != OMAP_CTRL_TYPE_OTGHS)
 		return;
 
 	ctrl_usb = dev_get_drvdata(dev);
@@ -193,10 +203,45 @@ void omap_control_usb_set_mode(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(omap_control_usb_set_mode);
 
+#ifdef CONFIG_OF
+
+static const enum omap_control_usb_type otghs_data = OMAP_CTRL_TYPE_OTGHS;
+static const enum omap_control_usb_type usb2_data = OMAP_CTRL_TYPE_USB2;
+static const enum omap_control_usb_type pipe3_data = OMAP_CTRL_TYPE_PIPE3;
+static const enum omap_control_usb_type dra7usb2_data = OMAP_CTRL_TYPE_DRA7USB2;
+
+static const struct of_device_id omap_control_usb_id_table[] = {
+	{
+		.compatible = "ti,control-phy-otghs",
+		.data = &otghs_data,
+	},
+	{
+		.compatible = "ti,control-phy-usb2",
+		.data = &usb2_data,
+	},
+	{
+		.compatible = "ti,control-phy-pipe3",
+		.data = &pipe3_data,
+	},
+	{
+		.compatible = "ti,control-phy-dra7usb2",
+		.data = &dra7usb2_data,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap_control_usb_id_table);
+#endif
+
+
 static int omap_control_usb_probe(struct platform_device *pdev)
 {
 	struct resource	*res;
-	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *of_id;
+
+	of_id = of_match_device(of_match_ptr(omap_control_usb_id_table),
+								&pdev->dev);
+	if (!of_id)
+		return -EINVAL;
 
 	control_usb = devm_kzalloc(&pdev->dev, sizeof(*control_usb),
 		GFP_KERNEL);
@@ -205,36 +250,27 @@ static int omap_control_usb_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	if (np)
-		of_property_read_u32(np, "ti,type", &control_usb->type);
-	else
-		return -EINVAL;	/* We only support DT boot */
-
-	control_usb->dev	= &pdev->dev;
+	control_usb->dev = &pdev->dev;
+	control_usb->type = *(enum omap_control_usb_type *)of_id->data;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-		"control_dev_conf");
-	control_usb->dev_conf = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(control_usb->dev_conf))
-		return PTR_ERR(control_usb->dev_conf);
-
-	if (control_usb->type == OMAP_CTRL_DEV_TYPE1) {
+	if (control_usb->type == OMAP_CTRL_TYPE_OTGHS) {
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 			"otghs_control");
 		control_usb->otghs_control = devm_ioremap_resource(
 			&pdev->dev, res);
 		if (IS_ERR(control_usb->otghs_control))
 			return PTR_ERR(control_usb->otghs_control);
-	}
-
-	if (control_usb->type == OMAP_CTRL_DEV_TYPE2) {
+	} else {
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-			"phy_power_usb");
-		control_usb->phy_power = devm_ioremap_resource(
-			&pdev->dev, res);
-		if (IS_ERR(control_usb->phy_power))
-			return PTR_ERR(control_usb->phy_power);
+				"power");
+		control_usb->power = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(control_usb->power)) {
+			dev_err(&pdev->dev, "Couldn't get power register\n");
+			return PTR_ERR(control_usb->power);
+		}
+	}
 
+	if (control_usb->type == OMAP_CTRL_TYPE_PIPE3) {
 		control_usb->sys_clk = devm_clk_get(control_usb->dev,
 			"sys_clkin");
 		if (IS_ERR(control_usb->sys_clk)) {
@@ -243,20 +279,11 @@ static int omap_control_usb_probe(struct platform_device *pdev)
 		}
 	}
 
-
 	dev_set_drvdata(control_usb->dev, control_usb);
 
 	return 0;
 }
 
-#ifdef CONFIG_OF
-static const struct of_device_id omap_control_usb_id_table[] = {
-	{ .compatible = "ti,omap-control-usb" },
-	{}
-};
-MODULE_DEVICE_TABLE(of, omap_control_usb_id_table);
-#endif
-
 static struct platform_driver omap_control_usb_driver = {
 	.probe		= omap_control_usb_probe,
 	.driver		= {
diff --git a/drivers/usb/phy/phy-omap-usb3.c b/drivers/usb/phy/phy-omap-usb3.c
index 4e8a040..0824be4 100644
--- a/drivers/usb/phy/phy-omap-usb3.c
+++ b/drivers/usb/phy/phy-omap-usb3.c
@@ -100,7 +100,7 @@ static int omap_usb3_suspend(struct usb_phy *x, int suspend)
 			udelay(1);
 		} while (--timeout);
 
-		omap_control_usb3_phy_power(phy->control_dev, 0);
+		omap_control_usb_phy_power(phy->control_dev, 0);
 
 		phy->is_suspended	= 1;
 	} else if (!suspend && phy->is_suspended) {
@@ -189,7 +189,7 @@ static int omap_usb3_init(struct usb_phy *x)
 	if (ret)
 		return ret;
 
-	omap_control_usb3_phy_power(phy->control_dev, 1);
+	omap_control_usb_phy_power(phy->control_dev, 1);
 
 	return 0;
 }
@@ -245,7 +245,7 @@ static int omap_usb3_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	omap_control_usb3_phy_power(phy->control_dev, 0);
+	omap_control_usb_phy_power(phy->control_dev, 0);
 	usb_add_phy_dev(&phy->phy);
 
 	platform_set_drvdata(pdev, phy);
diff --git a/include/linux/usb/omap_control_usb.h b/include/linux/usb/omap_control_usb.h
index e2416b4..61b889a 100644
--- a/include/linux/usb/omap_control_usb.h
+++ b/include/linux/usb/omap_control_usb.h
@@ -19,16 +19,23 @@
 #ifndef __OMAP_CONTROL_USB_H__
 #define __OMAP_CONTROL_USB_H__
 
+enum omap_control_usb_type {
+	OMAP_CTRL_TYPE_OTGHS = 1,	/* Mailbox OTGHS_CONTROL */
+	OMAP_CTRL_TYPE_USB2,	/* USB2_PHY, power down in CONTROL_DEV_CONF */
+	OMAP_CTRL_TYPE_PIPE3,	/* PIPE3 PHY, DPLL & seperate Rx/Tx power */
+	OMAP_CTRL_TYPE_DRA7USB2, /* USB2 PHY, power and power_aux e.g. DRA7 */
+};
+
 struct omap_control_usb {
 	struct device *dev;
 
-	u32 __iomem *dev_conf;
 	u32 __iomem *otghs_control;
-	u32 __iomem *phy_power;
+	u32 __iomem *power;
+	u32 __iomem *power_aux;
 
 	struct clk *sys_clk;
 
-	u32 type;
+	enum omap_control_usb_type type;
 };
 
 enum omap_control_usb_mode {
@@ -38,10 +45,6 @@ enum omap_control_usb_mode {
 	USB_MODE_DISCONNECT,
 };
 
-/* To differentiate ctrl module IP having either mailbox or USB3 PHY power */
-#define	OMAP_CTRL_DEV_TYPE1		0x1
-#define	OMAP_CTRL_DEV_TYPE2		0x2
-
 #define	OMAP_CTRL_DEV_PHY_PD		BIT(0)
 
 #define	OMAP_CTRL_DEV_AVALID		BIT(0)
@@ -59,10 +62,11 @@ enum omap_control_usb_mode {
 #define	OMAP_CTRL_USB3_PHY_TX_RX_POWERON	0x3
 #define	OMAP_CTRL_USB3_PHY_TX_RX_POWEROFF	0x0
 
+#define OMAP_CTRL_USB2_PHY_PD		BIT(28)
+
 #if IS_ENABLED(CONFIG_OMAP_CONTROL_USB)
 extern struct device *omap_get_control_dev(void);
 extern void omap_control_usb_phy_power(struct device *dev, int on);
-extern void omap_control_usb3_phy_power(struct device *dev, bool on);
 extern void omap_control_usb_set_mode(struct device *dev,
 	enum omap_control_usb_mode mode);
 #else
@@ -75,10 +79,6 @@ static inline void omap_control_usb_phy_power(struct device *dev, int on)
 {
 }
 
-static inline void omap_control_usb3_phy_power(struct device *dev, int on)
-{
-}
-
 static inline void omap_control_usb_set_mode(struct device *dev,
 	enum omap_control_usb_mode mode)
 {
-- 
1.7.4.1

