Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbaEFNez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:34:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43029 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426AbaEFNew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:34:52 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 02/17] phy: omap-control: add external clock support for PCIe PHY
Date: Tue, 6 May 2014 19:03:48 +0530
Message-ID: <1399383244-14556-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399383244-14556-1-git-send-email-kishon@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export an API to be called by PIPE3 PHY to enable external clock for
PCIE PHY. Added a new compatible for PCIE in omap-control in order to
enable it.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/phy/ti-phy.txt |    9 ++--
 drivers/phy/phy-omap-control.c                   |   51 +++++++++++++++++++++-
 include/linux/phy/omap_control_phy.h             |   14 ++++++
 3 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
index cf3de7e..bc9afb5 100644
--- a/Documentation/devicetree/bindings/phy/ti-phy.txt
+++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
@@ -9,15 +9,18 @@ Required properties:
                         e.g. USB2_PHY on OMAP5.
  "ti,control-phy-pipe3" - if it has DPLL and individual Rx & Tx power control
                         e.g. USB3 PHY and SATA PHY on OMAP5.
+ "ti,control-phy-pcie" - for pcie to support external clock for pcie and to
+			set PCS delay value.
+			e.g. PCIE PHY in DRA7x
  "ti,control-phy-usb2-dra7" - if it has power down register like USB2 PHY on
                         DRA7 platform.
  "ti,control-phy-usb2-am437" - if it has power down register like USB2 PHY on
                         AM437 platform.
  - reg : Address and length of the register set for the device. It contains
    the address of "otghs_control" for control-phy-otghs or "power" register
-   for other types.
- - reg-names: should be "otghs_control" control-phy-otghs and "power" for
-   other types.
+   for other types and "control_sma" for control-phy-pcie
+ - reg-names: should be "otghs_control" for control-phy-otghs,
+  "control_sma" for control-phy-pcie and "power" for other types.
 
 omap_control_usb: omap-control-usb@4a002300 {
         compatible = "ti,control-phy-otghs";
diff --git a/drivers/phy/phy-omap-control.c b/drivers/phy/phy-omap-control.c
index 311b4f9..47a1b6c 100644
--- a/drivers/phy/phy-omap-control.c
+++ b/drivers/phy/phy-omap-control.c
@@ -27,6 +27,40 @@
 #include <linux/phy/omap_control_phy.h>
 
 /**
+ * omap_control_pcie_tx_rx_control - PCIe RX and TX control of ACSPCIe
+ * @dev: the control module device
+ * @ctrl: 1, 2 or 3 based on controlling either RX or TX or both of ACSPCIe
+ */
+void omap_control_pcie_tx_rx_control(struct device *dev, u8 ctrl)
+{
+	u32 val;
+	struct omap_control_phy	*control_phy;
+
+	if (IS_ERR(dev) || !dev) {
+		pr_err("%s: invalid device\n", __func__);
+		return;
+	}
+
+	control_phy = dev_get_drvdata(dev);
+	if (!control_phy) {
+		dev_err(dev, "%s: invalid control phy device\n", __func__);
+		return;
+	}
+
+	if (control_phy->type != OMAP_CTRL_TYPE_PCIE) {
+		dev_err(dev, "%s: unsupported operation\n", __func__);
+		return;
+	}
+
+	val = readl(control_phy->ctrl_sma);
+	val &= ~(OMAP_CTRL_PCIE_TX_RX_CONTROL_MASK <<
+		OMAP_CTRL_PCIE_TX_RX_CONTROL_SHIFT);
+	val |= ctrl << OMAP_CTRL_PCIE_TX_RX_CONTROL_SHIFT;
+	writel(val, control_phy->ctrl_sma);
+}
+EXPORT_SYMBOL_GPL(omap_control_pcie_tx_rx_control);
+
+/**
  * omap_control_phy_power - power on/off the phy using control module reg
  * @dev: the control module device
  * @on: 0 or 1, based on powering on or off the PHY
@@ -61,6 +95,7 @@ void omap_control_phy_power(struct device *dev, int on)
 			val |= OMAP_CTRL_DEV_PHY_PD;
 		break;
 
+	case OMAP_CTRL_TYPE_PCIE:
 	case OMAP_CTRL_TYPE_PIPE3:
 		rate = clk_get_rate(control_phy->sys_clk);
 		rate = rate/1000000;
@@ -211,6 +246,7 @@ EXPORT_SYMBOL_GPL(omap_control_usb_set_mode);
 static const enum omap_control_phy_type otghs_data = OMAP_CTRL_TYPE_OTGHS;
 static const enum omap_control_phy_type usb2_data = OMAP_CTRL_TYPE_USB2;
 static const enum omap_control_phy_type pipe3_data = OMAP_CTRL_TYPE_PIPE3;
+static const enum omap_control_phy_type pcie_data = OMAP_CTRL_TYPE_PCIE;
 static const enum omap_control_phy_type dra7usb2_data = OMAP_CTRL_TYPE_DRA7USB2;
 static const enum omap_control_phy_type am437usb2_data = OMAP_CTRL_TYPE_AM437USB2;
 
@@ -228,6 +264,10 @@ static const struct of_device_id omap_control_phy_id_table[] = {
 		.data = &pipe3_data,
 	},
 	{
+		.compatible = "ti,control-phy-pcie",
+		.data = &pcie_data,
+	},
+	{
 		.compatible = "ti,control-phy-usb2-dra7",
 		.data = &dra7usb2_data,
 	},
@@ -279,7 +319,8 @@ static int omap_control_phy_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (control_phy->type == OMAP_CTRL_TYPE_PIPE3) {
+	if (control_phy->type == OMAP_CTRL_TYPE_PIPE3 ||
+	    control_phy->type == OMAP_CTRL_TYPE_PCIE) {
 		control_phy->sys_clk = devm_clk_get(control_phy->dev,
 			"sys_clkin");
 		if (IS_ERR(control_phy->sys_clk)) {
@@ -288,6 +329,14 @@ static int omap_control_phy_probe(struct platform_device *pdev)
 		}
 	}
 
+	if (control_phy->type == OMAP_CTRL_TYPE_PCIE) {
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						   "control_sma");
+		control_phy->ctrl_sma = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(control_phy->ctrl_sma))
+			return PTR_ERR(control_phy->ctrl_sma);
+	}
+
 	dev_set_drvdata(control_phy->dev, control_phy);
 
 	return 0;
diff --git a/include/linux/phy/omap_control_phy.h b/include/linux/phy/omap_control_phy.h
index 5450403..15cfbfe 100644
--- a/include/linux/phy/omap_control_phy.h
+++ b/include/linux/phy/omap_control_phy.h
@@ -23,6 +23,7 @@ enum omap_control_phy_type {
 	OMAP_CTRL_TYPE_OTGHS = 1,	/* Mailbox OTGHS_CONTROL */
 	OMAP_CTRL_TYPE_USB2,	/* USB2_PHY, power down in CONTROL_DEV_CONF */
 	OMAP_CTRL_TYPE_PIPE3,	/* PIPE3 PHY, DPLL & seperate Rx/Tx power */
+	OMAP_CTRL_TYPE_PCIE,	/* RX TX control of ACSPCIE */
 	OMAP_CTRL_TYPE_DRA7USB2, /* USB2 PHY, power and power_aux e.g. DRA7 */
 	OMAP_CTRL_TYPE_AM437USB2, /* USB2 PHY, power e.g. AM437x */
 };
@@ -33,6 +34,7 @@ struct omap_control_phy {
 	u32 __iomem *otghs_control;
 	u32 __iomem *power;
 	u32 __iomem *power_aux;
+	u32 __iomem *ctrl_sma;
 
 	struct clk *sys_clk;
 
@@ -63,6 +65,13 @@ enum omap_control_usb_mode {
 #define	OMAP_CTRL_PIPE3_PHY_TX_RX_POWERON	0x3
 #define	OMAP_CTRL_PIPE3_PHY_TX_RX_POWEROFF	0x0
 
+#define	OMAP_CTRL_PCIE_TX_RX_CONTROL_SHIFT	0x10
+#define	OMAP_CTRL_PCIE_TX_RX_CONTROL_MASK	0x3
+
+#define	OMAP_CTRL_PCIE_PHY_TX_ACSPCIE		0x1
+#define	OMAP_CTRL_PCIE_PHY_RX_ACSPCIE		0x2
+#define	OMAP_CTRL_PCIE_PHY_TX_RX_ACSPCIE	0x3
+
 #define OMAP_CTRL_USB2_PHY_PD		BIT(28)
 
 #define AM437X_CTRL_USB2_PHY_PD		BIT(0)
@@ -74,6 +83,7 @@ enum omap_control_usb_mode {
 void omap_control_phy_power(struct device *dev, int on);
 void omap_control_usb_set_mode(struct device *dev,
 			       enum omap_control_usb_mode mode);
+void omap_control_pcie_tx_rx_control(struct device *dev, u8 ctrl);
 #else
 
 static inline void omap_control_phy_power(struct device *dev, int on)
@@ -84,6 +94,10 @@ static inline void omap_control_usb_set_mode(struct device *dev,
 	enum omap_control_usb_mode mode)
 {
 }
+
+static inline void omap_control_pcie_tx_rx_control(struct device *dev, u8 ctrl)
+{
+}
 #endif
 
 #endif	/* __OMAP_CONTROL_PHY_H__ */
-- 
1.7.9.5

