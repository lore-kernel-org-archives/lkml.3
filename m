Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbaEFNfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:35:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44208 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaEFNfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:35:03 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 04/17] phy: pipe3: insert delay to enumerate in GEN2 mode
Date: Tue, 6 May 2014 19:03:50 +0530
Message-ID: <1399383244-14556-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399383244-14556-1-git-send-email-kishon@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8-bit delay value (0xF1) is required for GEN2 devices to be enumerated
consistently. Added an API to be called from PHY drivers to set this delay
value and called it from PIPE3 driver to set the delay value.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/phy/ti-phy.txt |    4 +--
 drivers/phy/phy-omap-control.c                   |   41 ++++++++++++++++++++++
 drivers/phy/phy-ti-pipe3.c                       |    4 ++-
 include/linux/phy/omap_control_phy.h             |    9 +++++
 4 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
index d50f8ee..5653dc4 100644
--- a/Documentation/devicetree/bindings/phy/ti-phy.txt
+++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
@@ -18,9 +18,9 @@ Required properties:
                         AM437 platform.
  - reg : Address and length of the register set for the device. It contains
    the address of "otghs_control" for control-phy-otghs or "power" register
-   for other types and "control_sma" for control-phy-pcie
+   for other types and "control_sma", "pcie_pcs" for control-phy-pcie
  - reg-names: should be "otghs_control" for control-phy-otghs,
-  "control_sma" for control-phy-pcie and "power" for other types.
+  "control_sma", "pcie_pcs" for control-phy-pcie and "power" for other types.
 
 omap_control_usb: omap-control-usb@4a002300 {
         compatible = "ti,control-phy-otghs";
diff --git a/drivers/phy/phy-omap-control.c b/drivers/phy/phy-omap-control.c
index 47a1b6c..6ba551b 100644
--- a/drivers/phy/phy-omap-control.c
+++ b/drivers/phy/phy-omap-control.c
@@ -61,6 +61,41 @@ void omap_control_pcie_tx_rx_control(struct device *dev, u8 ctrl)
 EXPORT_SYMBOL_GPL(omap_control_pcie_tx_rx_control);
 
 /**
+ * omap_control_pcie_pcs - set the PCS delay count
+ * @dev: the control module device
+ * @id: index of the pcie PHY (should be 1 or 2)
+ * @delay: 8 bit delay value
+ */
+void omap_control_pcie_pcs(struct device *dev, u8 id, u8 delay)
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
+	val = readl(control_phy->pcie_pcs);
+	val &= ~(OMAP_CTRL_PCIE_PCS_MASK <<
+		(id * OMAP_CTRL_PCIE_PCS_DELAY_COUNT_SHIFT));
+	val |= delay << (id * OMAP_CTRL_PCIE_PCS_DELAY_COUNT_SHIFT);
+	writel(val, control_phy->pcie_pcs);
+}
+EXPORT_SYMBOL_GPL(omap_control_pcie_pcs);
+
+/**
  * omap_control_phy_power - power on/off the phy using control module reg
  * @dev: the control module device
  * @on: 0 or 1, based on powering on or off the PHY
@@ -335,6 +370,12 @@ static int omap_control_phy_probe(struct platform_device *pdev)
 		control_phy->ctrl_sma = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(control_phy->ctrl_sma))
 			return PTR_ERR(control_phy->ctrl_sma);
+
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						   "pcie_pcs");
+		control_phy->pcie_pcs = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(control_phy->pcie_pcs))
+			return PTR_ERR(control_phy->pcie_pcs);
 	}
 
 	dev_set_drvdata(control_phy->dev, control_phy);
diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index 5513aa0..a1a0e35 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -216,8 +216,10 @@ static int ti_pipe3_init(struct phy *x)
 	u32 val;
 	int ret = 0;
 
-	if (of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-pcie"))
+	if (of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-pcie")) {
+		omap_control_pcie_pcs(phy->control_dev, 0x1, 0xF1);
 		return 0;
+	}
 
 	/* Bring it out of IDLE if it is IDLE */
 	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
diff --git a/include/linux/phy/omap_control_phy.h b/include/linux/phy/omap_control_phy.h
index 15cfbfe..6127c04 100644
--- a/include/linux/phy/omap_control_phy.h
+++ b/include/linux/phy/omap_control_phy.h
@@ -35,6 +35,7 @@ struct omap_control_phy {
 	u32 __iomem *power;
 	u32 __iomem *power_aux;
 	u32 __iomem *ctrl_sma;
+	u32 __iomem *pcie_pcs;
 
 	struct clk *sys_clk;
 
@@ -68,6 +69,9 @@ enum omap_control_usb_mode {
 #define	OMAP_CTRL_PCIE_TX_RX_CONTROL_SHIFT	0x10
 #define	OMAP_CTRL_PCIE_TX_RX_CONTROL_MASK	0x3
 
+#define	OMAP_CTRL_PCIE_PCS_MASK			0xff
+#define	OMAP_CTRL_PCIE_PCS_DELAY_COUNT_SHIFT	0x8
+
 #define	OMAP_CTRL_PCIE_PHY_TX_ACSPCIE		0x1
 #define	OMAP_CTRL_PCIE_PHY_RX_ACSPCIE		0x2
 #define	OMAP_CTRL_PCIE_PHY_TX_RX_ACSPCIE	0x3
@@ -84,6 +88,7 @@ void omap_control_phy_power(struct device *dev, int on);
 void omap_control_usb_set_mode(struct device *dev,
 			       enum omap_control_usb_mode mode);
 void omap_control_pcie_tx_rx_control(struct device *dev, u8 ctrl);
+void omap_control_pcie_pcs(struct device *dev, u8 id, u8 delay);
 #else
 
 static inline void omap_control_phy_power(struct device *dev, int on)
@@ -98,6 +103,10 @@ static inline void omap_control_usb_set_mode(struct device *dev,
 static inline void omap_control_pcie_tx_rx_control(struct device *dev, u8 ctrl)
 {
 }
+
+static inline void omap_control_pcie_pcs(struct device *dev, u8 id, u8 delay)
+{
+}
 #endif
 
 #endif	/* __OMAP_CONTROL_PHY_H__ */
-- 
1.7.9.5

