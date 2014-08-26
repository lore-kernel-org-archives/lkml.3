Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934585AbaHZO6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:58:14 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38892 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934498AbaHZO6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:58:01 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] PCI: tegra: Add Tegra124 support
Date: Tue, 26 Aug 2014 16:57:44 +0200
Message-Id: <1409065064-17617-7-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409065064-17617-1-git-send-email-thierry.reding@gmail.com>
References: <1409065064-17617-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The PCIe controller on Tegra124 has two root ports that can be used in a
x4/x1 or x2/x1 configuration and can run at PCIe 2.0 link speeds (up to
5 GT/s). The PHY programming has been moved into a separate controller,
so the driver now needs to request an external PHY referenced using the
device tree.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 .../bindings/pci/nvidia,tegra20-pcie.txt           |  25 ++-
 drivers/pci/host/pci-tegra.c                       | 211 ++++++++++++++++++---
 2 files changed, 204 insertions(+), 32 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
index 0823362548dc..bc0b09b0dfb5 100644
--- a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
+++ b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
@@ -1,7 +1,10 @@
 NVIDIA Tegra PCIe controller
 
 Required properties:
-- compatible: "nvidia,tegra20-pcie" or "nvidia,tegra30-pcie"
+- compatible: Must be one of:
+  - "nvidia,tegra20-pcie"
+  - "nvidia,tegra30-pcie"
+  - "nvidia,tegra124-pcie"
 - device_type: Must be "pci"
 - reg: A list of physical base address and length for each set of controller
   registers. Must contain an entry for each entry in the reg-names property.
@@ -57,6 +60,11 @@ Required properties:
   - afi
   - pcie_x
 
+Required properties on Tegra124 and later:
+- phys: Must contain an entry for each entry in phy-names.
+- phy-names: Must include the following entries:
+  - pcie
+
 Power supplies for Tegra20:
 - avdd-pex-supply: Power supply for analog PCIe logic. Must supply 1.05 V.
 - vdd-pex-supply: Power supply for digital PCIe I/O. Must supply 1.05 V.
@@ -84,6 +92,21 @@ Power supplies for Tegra30:
     - avdd-pexb-supply: Power supply for analog PCIe logic. Must supply 1.05 V.
     - vdd-pexb-supply: Power supply for digital PCIe I/O. Must supply 1.05 V.
 
+Power supplies for Tegra124:
+- Required:
+  - avddio-pex-supply: Power supply for analog PCIe logic. Must supply 1.05 V.
+  - vddio-pex-supply: Power supply for digital PCIe I/O. Must supply 1.05 V.
+  - avdd-pex-pll-supply: Power supply for dedicated (internal) PCIe PLL. Must
+    supply 1.05 V.
+  - hvdd-pex-supply: High-voltage supply for PCIe I/O and PCIe output clocks.
+    Must supply 3.3 V.
+  - hvdd-pex-plle-supply: High-voltage supply for PLLE (shared with USB3).
+    Must supply 3.3 V.
+  - vddio-pex-ctl-supply: Power supply for PCIe control I/O partition. Must
+    supply 2.8-3.3 V.
+  - avdd-plle-supply: Power supply for PLLE (shared with USB3). Must
+    supply 1.05 V.
+
 Root ports are defined as subnodes of the PCIe controller node.
 
 Required properties:
diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 0ce43764dd36..a04525a93487 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -38,6 +38,7 @@
 #include <linux/of_pci.h>
 #include <linux/of_platform.h>
 #include <linux/pci.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/reset.h>
 #include <linux/sizes.h>
@@ -115,13 +116,20 @@
 
 #define AFI_INTR_CODE			0xb8
 #define  AFI_INTR_CODE_MASK		0xf
-#define  AFI_INTR_AXI_SLAVE_ERROR	1
-#define  AFI_INTR_AXI_DECODE_ERROR	2
+#define  AFI_INTR_INI_SLAVE_ERROR	1
+#define  AFI_INTR_INI_DECODE_ERROR	2
 #define  AFI_INTR_TARGET_ABORT		3
 #define  AFI_INTR_MASTER_ABORT		4
 #define  AFI_INTR_INVALID_WRITE		5
 #define  AFI_INTR_LEGACY		6
 #define  AFI_INTR_FPCI_DECODE_ERROR	7
+#define  AFI_INTR_AXI_DECODE_ERROR	8
+#define  AFI_INTR_FPCI_TIMEOUT		9
+#define  AFI_INTR_PE_PRSNT_SENSE	10
+#define  AFI_INTR_PE_CLKREQ_SENSE	11
+#define  AFI_INTR_CLKCLAMP_SENSE	12
+#define  AFI_INTR_RDY4PD_SENSE		13
+#define  AFI_INTR_P2P_ERROR		14
 
 #define AFI_INTR_SIGNATURE	0xbc
 #define AFI_UPPER_FPCI_ADDRESS	0xc0
@@ -152,8 +160,10 @@
 #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_MASK	(0xf << 20)
 #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_SINGLE	(0x0 << 20)
 #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_420	(0x0 << 20)
+#define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_X2_X1	(0x0 << 20)
 #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_DUAL	(0x1 << 20)
 #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_222	(0x1 << 20)
+#define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_X4_X1	(0x1 << 20)
 #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_411	(0x2 << 20)
 
 #define AFI_FUSE			0x104
@@ -165,12 +175,21 @@
 #define  AFI_PEX_CTRL_RST		(1 << 0)
 #define  AFI_PEX_CTRL_CLKREQ_EN		(1 << 1)
 #define  AFI_PEX_CTRL_REFCLK_EN		(1 << 3)
+#define  AFI_PEX_CTRL_OVERRIDE_EN	(1 << 4)
+
+#define AFI_PLLE_CONTROL		0x160
+#define  AFI_PLLE_CONTROL_BYPASS_PADS2PLLE_CONTROL (1 << 9)
+#define  AFI_PLLE_CONTROL_PADS2PLLE_CONTROL_EN (1 << 1)
 
 #define AFI_PEXBIAS_CTRL_0		0x168
 
 #define RP_VEND_XP	0x00000F00
 #define  RP_VEND_XP_DL_UP	(1 << 30)
 
+#define RP_PRIV_MISC	0x00000FE0
+#define  RP_PRIV_MISC_PRSNT_MAP_EP_PRSNT (0xE << 0)
+#define  RP_PRIV_MISC_PRSNT_MAP_EP_ABSNT (0xF << 0)
+
 #define RP_LINK_CONTROL_STATUS			0x00000090
 #define  RP_LINK_CONTROL_STATUS_DL_LINK_ACTIVE	0x20000000
 #define  RP_LINK_CONTROL_STATUS_LINKSTAT_MASK	0x3fff0000
@@ -197,6 +216,7 @@
 
 #define PADS_REFCLK_CFG0			0x000000C8
 #define PADS_REFCLK_CFG1			0x000000CC
+#define PADS_REFCLK_BIAS			0x000000D0
 
 /*
  * Fields in PADS_REFCLK_CFG*. Those registers form an array of 16-bit
@@ -236,6 +256,7 @@ struct tegra_pcie_soc_data {
 	bool has_pex_bias_ctrl;
 	bool has_intr_prsnt_sense;
 	bool has_cml_clk;
+	bool has_gen2;
 };
 
 static inline struct tegra_msi *to_tegra_msi(struct msi_chip *chip)
@@ -268,6 +289,8 @@ struct tegra_pcie {
 	struct reset_control *afi_rst;
 	struct reset_control *pcie_xrst;
 
+	struct phy *phy;
+
 	struct tegra_msi msi;
 
 	struct list_head ports;
@@ -562,6 +585,8 @@ static void tegra_pcie_port_enable(struct tegra_pcie_port *port)
 	if (soc->has_pex_clkreq_en)
 		value |= AFI_PEX_CTRL_CLKREQ_EN;
 
+	value |= AFI_PEX_CTRL_OVERRIDE_EN;
+
 	afi_writel(port->pcie, value, ctrl);
 
 	tegra_pcie_port_reset(port);
@@ -699,9 +724,15 @@ static irqreturn_t tegra_pcie_isr(int irq, void *arg)
 		"Target abort",
 		"Master abort",
 		"Invalid write",
+		"Legacy interrupt",
 		"Response decoding error",
 		"AXI response decoding error",
 		"Transaction timeout",
+		"Slot present pin change",
+		"Slot clock request change",
+		"TMS clock ramp change",
+		"TMS ready for power down",
+		"Peer2Peer error",
 	};
 	struct tegra_pcie *pcie = arg;
 	u32 code, signature;
@@ -807,30 +838,27 @@ static void tegra_pcie_setup_translations(struct tegra_pcie *pcie)
 	afi_writel(pcie, 0, AFI_MSI_BAR_SZ);
 }
 
-static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
+static int tegra_pcie_pll_wait(struct tegra_pcie *pcie, unsigned long timeout)
 {
 	const struct tegra_pcie_soc_data *soc = pcie->soc_data;
-	struct tegra_pcie_port *port;
-	unsigned int timeout;
-	unsigned long value;
-
-	/* power down PCIe slot clock bias pad */
-	if (soc->has_pex_bias_ctrl)
-		afi_writel(pcie, 0, AFI_PEXBIAS_CTRL_0);
+	u32 value;
 
-	/* configure mode and disable all ports */
-	value = afi_readl(pcie, AFI_PCIE_CONFIG);
-	value &= ~AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_MASK;
-	value |= AFI_PCIE_CONFIG_PCIE_DISABLE_ALL | pcie->xbar_config;
+	timeout = jiffies + msecs_to_jiffies(timeout);
 
-	list_for_each_entry(port, &pcie->ports, list)
-		value &= ~AFI_PCIE_CONFIG_PCIE_DISABLE(port->index);
+	while (time_before(jiffies, timeout)) {
+		value = pads_readl(pcie, soc->pads_pll_ctl);
+		if (value & PADS_PLL_CTL_LOCKDET)
+			return 0;
+	}
 
-	afi_writel(pcie, value, AFI_PCIE_CONFIG);
+	return -ETIMEDOUT;
+}
 
-	value = afi_readl(pcie, AFI_FUSE);
-	value |= AFI_FUSE_PCIE_T0_GEN2_DIS;
-	afi_writel(pcie, value, AFI_FUSE);
+static int tegra_pcie_phy_enable(struct tegra_pcie *pcie)
+{
+	const struct tegra_pcie_soc_data *soc = pcie->soc_data;
+	u32 value;
+	int err;
 
 	/* initialize internal PHY, enable up to 16 PCIE lanes */
 	pads_writel(pcie, 0x0, PADS_CTL_SEL);
@@ -868,15 +896,11 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
 		pads_writel(pcie, PADS_REFCLK_CFG_VALUE, PADS_REFCLK_CFG1);
 
 	/* wait for the PLL to lock */
-	timeout = 300;
-	do {
-		value = pads_readl(pcie, soc->pads_pll_ctl);
-		usleep_range(1000, 2000);
-		if (--timeout == 0) {
-			pr_err("Tegra PCIe error: timeout waiting for PLL\n");
-			return -EBUSY;
-		}
-	} while (!(value & PADS_PLL_CTL_LOCKDET));
+	err = tegra_pcie_pll_wait(pcie, 500);
+	if (err < 0) {
+		dev_err(pcie->dev, "PLL failed to lock: %d\n", err);
+		return err;
+	}
 
 	/* turn off IDDQ override */
 	value = pads_readl(pcie, PADS_CTL);
@@ -888,6 +912,58 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
 	value |= PADS_CTL_TX_DATA_EN_1L | PADS_CTL_RX_DATA_EN_1L;
 	pads_writel(pcie, value, PADS_CTL);
 
+	return 0;
+}
+
+static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
+{
+	const struct tegra_pcie_soc_data *soc = pcie->soc_data;
+	struct tegra_pcie_port *port;
+	unsigned long value;
+	int err;
+
+	/* enable PLL power down */
+	if (pcie->phy) {
+		value = afi_readl(pcie, AFI_PLLE_CONTROL);
+		value &= ~AFI_PLLE_CONTROL_BYPASS_PADS2PLLE_CONTROL;
+		value |= AFI_PLLE_CONTROL_PADS2PLLE_CONTROL_EN;
+		afi_writel(pcie, value, AFI_PLLE_CONTROL);
+	}
+
+	/* power down PCIe slot clock bias pad */
+	if (soc->has_pex_bias_ctrl)
+		afi_writel(pcie, 0, AFI_PEXBIAS_CTRL_0);
+
+	/* configure mode and disable all ports */
+	value = afi_readl(pcie, AFI_PCIE_CONFIG);
+	value &= ~AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_MASK;
+	value |= AFI_PCIE_CONFIG_PCIE_DISABLE_ALL | pcie->xbar_config;
+
+	list_for_each_entry(port, &pcie->ports, list)
+		value &= ~AFI_PCIE_CONFIG_PCIE_DISABLE(port->index);
+
+	afi_writel(pcie, value, AFI_PCIE_CONFIG);
+
+	if (soc->has_gen2) {
+		value = afi_readl(pcie, AFI_FUSE);
+		value &= ~AFI_FUSE_PCIE_T0_GEN2_DIS;
+		afi_writel(pcie, value, AFI_FUSE);
+	} else {
+		value = afi_readl(pcie, AFI_FUSE);
+		value |= AFI_FUSE_PCIE_T0_GEN2_DIS;
+		afi_writel(pcie, value, AFI_FUSE);
+	}
+
+	if (!pcie->phy)
+		err = tegra_pcie_phy_enable(pcie);
+	else
+		err = phy_power_on(pcie->phy);
+
+	if (err < 0) {
+		dev_err(pcie->dev, "failed to power on PHY: %d\n", err);
+		return err;
+	}
+
 	/* take the PCIe interface module out of reset */
 	reset_control_deassert(pcie->pcie_xrst);
 
@@ -921,6 +997,10 @@ static void tegra_pcie_power_off(struct tegra_pcie *pcie)
 
 	/* TODO: disable and unprepare clocks? */
 
+	err = phy_power_off(pcie->phy);
+	if (err < 0)
+		dev_warn(pcie->dev, "failed to power off PHY: %d\n", err);
+
 	reset_control_assert(pcie->pcie_xrst);
 	reset_control_assert(pcie->afi_rst);
 	reset_control_assert(pcie->pex_rst);
@@ -1042,6 +1122,19 @@ static int tegra_pcie_get_resources(struct tegra_pcie *pcie)
 		return err;
 	}
 
+	pcie->phy = devm_phy_optional_get(pcie->dev, "pcie");
+	if (IS_ERR(pcie->phy)) {
+		err = PTR_ERR(pcie->phy);
+		dev_err(&pdev->dev, "failed to get PHY: %d\n", err);
+		return err;
+	}
+
+	err = phy_init(pcie->phy);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to initialize PHY: %d\n", err);
+		return err;
+	}
+
 	err = tegra_pcie_power_on(pcie);
 	if (err) {
 		dev_err(&pdev->dev, "failed to power up: %d\n", err);
@@ -1100,10 +1193,17 @@ poweroff:
 
 static int tegra_pcie_put_resources(struct tegra_pcie *pcie)
 {
+	int err;
+
 	if (pcie->irq > 0)
 		free_irq(pcie->irq, pcie);
 
 	tegra_pcie_power_off(pcie);
+
+	err = phy_exit(pcie->phy);
+	if (err < 0)
+		dev_err(pcie->dev, "failed to teardown PHY: %d\n", err);
+
 	return 0;
 }
 
@@ -1349,7 +1449,19 @@ static int tegra_pcie_get_xbar_config(struct tegra_pcie *pcie, u32 lanes,
 {
 	struct device_node *np = pcie->dev->of_node;
 
-	if (of_device_is_compatible(np, "nvidia,tegra30-pcie")) {
+	if (of_device_is_compatible(np, "nvidia,tegra124-pcie")) {
+		switch (lanes) {
+		case 0x0000104:
+			dev_info(pcie->dev, "4x1, 1x1 configuration\n");
+			*xbar = AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_X4_X1;
+			return 0;
+
+		case 0x0000102:
+			dev_info(pcie->dev, "2x1, 1x1 configuration\n");
+			*xbar = AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_X2_X1;
+			return 0;
+		}
+	} else if (of_device_is_compatible(np, "nvidia,tegra30-pcie")) {
 		switch (lanes) {
 		case 0x00000204:
 			dev_info(pcie->dev, "4x1, 2x1 configuration\n");
@@ -1457,7 +1569,23 @@ static int tegra_pcie_get_regulators(struct tegra_pcie *pcie, u32 lane_mask)
 	struct device_node *np = pcie->dev->of_node;
 	unsigned int i = 0;
 
-	if (of_device_is_compatible(np, "nvidia,tegra30-pcie")) {
+	if (of_device_is_compatible(np, "nvidia,tegra124-pcie")) {
+		pcie->num_supplies = 7;
+
+		pcie->supplies = devm_kcalloc(pcie->dev, pcie->num_supplies,
+					      sizeof(*pcie->supplies),
+					      GFP_KERNEL);
+		if (!pcie->supplies)
+			return -ENOMEM;
+
+		pcie->supplies[i++].supply = "avddio-pex";
+		pcie->supplies[i++].supply = "vddio-pex";
+		pcie->supplies[i++].supply = "avdd-pex-pll";
+		pcie->supplies[i++].supply = "hvdd-pex";
+		pcie->supplies[i++].supply = "hvdd-pex-plle";
+		pcie->supplies[i++].supply = "vddio-pex-ctl";
+		pcie->supplies[i++].supply = "avdd-plle";
+	} else if (of_device_is_compatible(np, "nvidia,tegra30-pcie")) {
 		bool need_pexa = false, need_pexb = false;
 
 		/* VDD_PEXA and AVDD_PEXA supply lanes 0 to 3 */
@@ -1679,6 +1807,12 @@ static bool tegra_pcie_port_check_link(struct tegra_pcie_port *port)
 	unsigned int retries = 3;
 	unsigned long value;
 
+	/* override presence detection */
+	value = readl(port->base + RP_PRIV_MISC);
+	value &= ~RP_PRIV_MISC_PRSNT_MAP_EP_ABSNT;
+	value |= RP_PRIV_MISC_PRSNT_MAP_EP_PRSNT;
+	writel(value, port->base + RP_PRIV_MISC);
+
 	do {
 		unsigned int timeout = TEGRA_PCIE_LINKUP_TIMEOUT;
 
@@ -1759,6 +1893,7 @@ static const struct tegra_pcie_soc_data tegra20_pcie_data = {
 	.has_pex_bias_ctrl = false,
 	.has_intr_prsnt_sense = false,
 	.has_cml_clk = false,
+	.has_gen2 = false,
 };
 
 static const struct tegra_pcie_soc_data tegra30_pcie_data = {
@@ -1770,9 +1905,23 @@ static const struct tegra_pcie_soc_data tegra30_pcie_data = {
 	.has_pex_bias_ctrl = true,
 	.has_intr_prsnt_sense = true,
 	.has_cml_clk = true,
+	.has_gen2 = false,
+};
+
+static const struct tegra_pcie_soc_data tegra124_pcie_data = {
+	.num_ports = 2,
+	.msi_base_shift = 8,
+	.pads_pll_ctl = PADS_PLL_CTL_TEGRA30,
+	.tx_ref_sel = PADS_PLL_CTL_TXCLKREF_BUF_EN,
+	.has_pex_clkreq_en = true,
+	.has_pex_bias_ctrl = true,
+	.has_intr_prsnt_sense = true,
+	.has_cml_clk = true,
+	.has_gen2 = true,
 };
 
 static const struct of_device_id tegra_pcie_of_match[] = {
+	{ .compatible = "nvidia,tegra124-pcie", .data = &tegra124_pcie_data },
 	{ .compatible = "nvidia,tegra30-pcie", .data = &tegra30_pcie_data },
 	{ .compatible = "nvidia,tegra20-pcie", .data = &tegra20_pcie_data },
 	{ },
-- 
2.0.4

