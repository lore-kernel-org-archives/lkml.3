Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3HAOF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:05:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41697 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab3HAOFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:05:23 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <tony@atomide.com>, <kishon@ti.com>, <george.cherian@ti.com>,
        <dmurphy@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 1/7] usb: phy: omap: Add new PHY types and remove omap_control_usb3_phy_power()
Date: Thu, 1 Aug 2013 17:05:09 +0300
Message-ID: <1375365915-21380-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1375365915-21380-1-git-send-email-rogerq@ti.com>
References: <1375365915-21380-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TYPE2 meaning has changed. It is now a USB2 phy with Power down bit in
control_dev_conf register.

Introduce TYPE3 and TYPE4 PHY. TYPE3 is USB3 phy with DPLL and individual
TX/RX power control. TYPE4 is USB2 phy with power aux register.

Update DT binding information to reflect these changes.

Also get rid of omap_control_usb3_phy_power(). Just one function
i.e. omap_control_usb_phy_power() will now take care of all PHY types.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/usb/omap-usb.txt |   23 ++--
 drivers/usb/phy/phy-omap-control.c                 |  129 +++++++++++---------
 drivers/usb/phy/phy-omap-usb2.c                    |    4 +
 drivers/usb/phy/phy-omap-usb3.c                    |    6 +-
 include/linux/usb/omap_control_usb.h               |   18 ++--
 5 files changed, 100 insertions(+), 80 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index 57e71f6..e2606ab 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -75,20 +75,19 @@ OMAP CONTROL USB
 Required properties:
  - compatible: Should be "ti,omap-control-usb"
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
+   the address of "otghs_control" for type 1 or "power" register for other types.
+   For type 4, it must also contain "power_aux" register.
+ - reg-names: should be otghs_control for type 1 and "power" for other types.
+ - ti,type: This is used to specify the type of control register.
+   Should be one of the following:
+   1 - if it has otghs_control mailbox register (e.g. on OMAP4)
+   2 - if it has Power down bit in control_dev_conf register. e.g. USB2 PHY
+   3 - if it has DPLL and individual Rx & Tx power control. e.g. USB3 PHY or SATA PHY
+   4 - if it has both power down and power aux registers. e.g. USB2 PHY on DRA7
 
 omap_control_usb: omap-control-usb@4a002300 {
 	compatible = "ti,omap-control-usb";
-	reg = <0x4a002300 0x4>,
-	      <0x4a00233c 0x4>;
-	reg-names = "control_dev_conf", "otghs_control";
+	reg = <0x4a00233c 0x4>;
+	reg-names = "otghs_control";
 	ti,type = <1>;
 };
diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/usb/phy/phy-omap-control.c
index a4dda8e..cf93c5a 100644
--- a/drivers/usb/phy/phy-omap-control.c
+++ b/drivers/usb/phy/phy-omap-control.c
@@ -46,61 +46,76 @@ struct device *omap_get_control_dev(void)
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
-	u32 val;
+	u32 val, val_aux;
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
+	control_usb = dev_get_drvdata(dev);
+	if (!control_usb) {
+		dev_err(dev, "%s: invalid control usb device\n", __func__);
+		return;
+	}
 
-	val = readl(control_usb->phy_power);
+	if (control_usb->type == OMAP_CTRL_DEV_TYPE1)
+		return;
 
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
-	}
+	val = readl(control_usb->power);
 
-	writel(val, control_usb->phy_power);
-}
-EXPORT_SYMBOL_GPL(omap_control_usb3_phy_power);
+	switch (control_usb->type) {
+	case OMAP_CTRL_DEV_TYPE2:
+		if (on)
+			val &= ~OMAP_CTRL_DEV_PHY_PD;
+		else
+			val |= OMAP_CTRL_DEV_PHY_PD;
+		break;
 
-/**
- * omap_control_usb_phy_power - power on/off the phy using control module reg
- * @dev: the control module device
- * @on: 0 or 1, based on powering on or off the PHY
- */
-void omap_control_usb_phy_power(struct device *dev, int on)
-{
-	u32 val;
-	struct omap_control_usb	*control_usb = dev_get_drvdata(dev);
+	case OMAP_CTRL_DEV_TYPE3:
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
 
-	val = readl(control_usb->dev_conf);
+	case OMAP_CTRL_DEV_TYPE4:
+		val_aux = readl(control_usb->power_aux);
+		if (on) {
+			val &= ~OMAP_CTRL_USB2_PHY_PD;
+			val_aux |= 0x100;
+		} else {
+			val |= OMAP_CTRL_USB2_PHY_PD;
+			val_aux &= ~0x100;
+		}
 
-	if (on)
-		val &= ~OMAP_CTRL_DEV_PHY_PD;
-	else
-		val |= OMAP_CTRL_DEV_PHY_PD;
+		writel(val_aux, control_usb->power_aux);
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
 
@@ -218,12 +233,6 @@ static int omap_control_usb_probe(struct platform_device *pdev)
 
 	control_usb->dev	= &pdev->dev;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-		"control_dev_conf");
-	control_usb->dev_conf = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(control_usb->dev_conf))
-		return PTR_ERR(control_usb->dev_conf);
-
 	if (control_usb->type == OMAP_CTRL_DEV_TYPE1) {
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 			"otghs_control");
@@ -231,16 +240,17 @@ static int omap_control_usb_probe(struct platform_device *pdev)
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
 
+	if (control_usb->type == OMAP_CTRL_DEV_TYPE3) {
 		control_usb->sys_clk = devm_clk_get(control_usb->dev,
 			"sys_clkin");
 		if (IS_ERR(control_usb->sys_clk)) {
@@ -249,6 +259,15 @@ static int omap_control_usb_probe(struct platform_device *pdev)
 		}
 	}
 
+	if (control_usb->type == OMAP_CTRL_DEV_TYPE4) {
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+				"power_aux");
+		control_usb->power_aux = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(control_usb->power_aux)) {
+			dev_err(&pdev->dev, "Couldn't get power_aux register\n");
+			return PTR_ERR(control_usb->power_aux);
+		}
+	}
 
 	dev_set_drvdata(control_usb->dev, control_usb);
 
diff --git a/drivers/usb/phy/phy-omap-usb2.c b/drivers/usb/phy/phy-omap-usb2.c
index 844ab68..376b367 100644
--- a/drivers/usb/phy/phy-omap-usb2.c
+++ b/drivers/usb/phy/phy-omap-usb2.c
@@ -123,6 +123,10 @@ static int omap_usb2_probe(struct platform_device *pdev)
 {
 	struct omap_usb			*phy;
 	struct usb_otg			*otg;
+	struct device_node *node = pdev->dev.of_node;
+
+	if (!node)
+		return -ENODEV;
 
 	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
 	if (!phy) {
diff --git a/drivers/usb/phy/phy-omap-usb3.c b/drivers/usb/phy/phy-omap-usb3.c
index fc15694..4a7f27c 100644
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
index 27b5b8c..7f027d3 100644
--- a/include/linux/usb/omap_control_usb.h
+++ b/include/linux/usb/omap_control_usb.h
@@ -22,9 +22,9 @@
 struct omap_control_usb {
 	struct device *dev;
 
-	u32 __iomem *dev_conf;
 	u32 __iomem *otghs_control;
-	u32 __iomem *phy_power;
+	u32 __iomem *power;
+	u32 __iomem *power_aux;
 
 	struct clk *sys_clk;
 
@@ -42,9 +42,10 @@ enum omap_control_usb_mode {
 	USB_MODE_DISCONNECT,
 };
 
-/* To differentiate ctrl module IP having either mailbox or USB3 PHY power */
-#define	OMAP_CTRL_DEV_TYPE1		0x1
-#define	OMAP_CTRL_DEV_TYPE2		0x2
+#define	OMAP_CTRL_DEV_TYPE1 0x1	/* Mailbox OTGHS_CONTROL */
+#define	OMAP_CTRL_DEV_TYPE2 0x2	/* USB2_PHY, power down in CONTROL_DEV_CONF */
+#define	OMAP_CTRL_DEV_TYPE3 0x3	/* USB3_PHY, DPLL & seperate Rx/Tx power */
+#define	OMAP_CTRL_DEV_TYPE4 0x4	/* USB2 PHY, power and power_aux e.g. DRA7 */
 
 #define	OMAP_CTRL_DEV_PHY_PD		BIT(0)
 
@@ -63,10 +64,11 @@ enum omap_control_usb_mode {
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
@@ -79,10 +81,6 @@ static inline void omap_control_usb_phy_power(struct device *dev, int on)
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

