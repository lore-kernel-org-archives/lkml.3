Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3FEPMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:12:44 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18818 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab3FEPMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:12:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 05 Jun 2013 08:11:37 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>,
        <thierry.reding@avionic-design.de>, <bhelgaas@google.com>,
        <ldewangan@nvidia.com>, <olof@lixom.net>, <hdoyu@nvidia.com>,
        <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <pdeschrijver@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <jtukkinen@nvidia.com>, <kthota@nvidia.com>, <jagarwal@nvidia.com>
Subject: [PATCH V4 2/4] ARM: tegra: pcie: Add tegra3 support
Date: Wed, 5 Jun 2013 20:43:41 +0530
Message-ID: <1370445221-17696-1-git-send-email-jagarwal@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Make private data structure for each SoC
- Add required Tegra30 clocks and regulators
- Add Tegra30 specific code in enable controller
- Added Tegra30 specific properties in pci binding document

Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
---
Patch is based on remotes/gitorious_thierryreding_linux/tegra/next and should be applied on top of this.

Changes in V4:
As per review comment
- Corrected pci document
- Removed fix in read/write config space
- modified num_max_ports -> num_ports
- Avoided changes in tegra_pcie_remove
---
 .../bindings/pci/nvidia,tegra20-pcie.txt           |    4 +-
 drivers/pci/host/pci-tegra.c                       |  147 +++++++++++++++++---
 2 files changed, 130 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
index 90c112f..db673c0 100644
--- a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
+++ b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
@@ -1,7 +1,7 @@
 NVIDIA Tegra PCIe controller
 
 Required properties:
-- compatible: "nvidia,tegra20-pcie"
+- compatible: "nvidia,tegra20-pcie" "nvidia,tegra30-pcie"
 - device_type: Must be "pci"
 - reg: A list of physical base address and length for each set of controller
   registers. Must contain an entry for each entry in the reg-names property.
@@ -16,6 +16,7 @@ Required properties:
   "msi": The Tegra interrupt that is asserted when an MSI is received
 - pex-clk-supply: Supply voltage for internal reference clock
 - vdd-supply: Power supply for controller (1.05V)
+- avdd-supply: Power supply for controller (1.05V) (not required for tegra20)
 - bus-range: Range of bus numbers associated with this controller
 - #address-cells: Address representation for root ports (must be 3)
   - cell 0 specifies the bus and device numbers of the root port:
@@ -48,6 +49,7 @@ Required properties:
   "afi": The Tegra clock of that name
   "pcie_xclk": The Tegra clock of that name
   "pll_e": The Tegra clock of that name
+  "cml": The Tegra clock of that name (not required for tegra20)
 
 Root ports are defined as subnodes of the PCIe controller node.
 
diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index c2d0b22..6a992ef 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -1,5 +1,5 @@
 /*
- * PCIe host controller driver for TEGRA(2) SOCs
+ * PCIe host controller driver for TEGRA SOCs
  *
  * Copyright (c) 2010, CompuLab, Ltd.
  * Author: Mike Rapoport <mike@compulab.co.il>
@@ -50,7 +50,6 @@
 #include <asm/mach/pci.h>
 
 #define INT_PCI_MSI_NR (8 * 32)
-#define TEGRA_MAX_PORTS 2
 
 /* register definitions */
 
@@ -142,14 +141,15 @@
 #define  AFI_INTR_EN_DFPCI_DECERR	(1 << 5)
 #define  AFI_INTR_EN_AXI_DECERR		(1 << 6)
 #define  AFI_INTR_EN_FPCI_TIMEOUT	(1 << 7)
+#define AFI_INTR_EN_PRSNT_SENSE		(1 << 8)
 
 #define AFI_PCIE_CONFIG					0x0f8
 #define  AFI_PCIE_CONFIG_PCIE_DISABLE(x)		(1 << ((x) + 1))
 #define  AFI_PCIE_CONFIG_PCIE_DISABLE_ALL		0xe
 #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_MASK	(0xf << 20)
 #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_SINGLE	(0x0 << 20)
-#define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_420	(0x0 << 20)
 #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_DUAL	(0x1 << 20)
+#define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_420	(0x0 << 20)
 #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_222	(0x1 << 20)
 #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_411	(0x2 << 20)
 
@@ -160,8 +160,11 @@
 #define AFI_PEX1_CTRL			0x118
 #define AFI_PEX2_CTRL			0x128
 #define  AFI_PEX_CTRL_RST		(1 << 0)
+#define  AFI_PEX_CTRL_CLKREQ_EN		(1 << 1)
 #define  AFI_PEX_CTRL_REFCLK_EN		(1 << 3)
 
+#define  AFI_PEXBIAS_CTRL_0		0x168
+
 #define RP_VEND_XP	0x00000F00
 #define  RP_VEND_XP_DL_UP	(1 << 30)
 
@@ -175,7 +178,8 @@
 #define  PADS_CTL_TX_DATA_EN_1L	(1 << 6)
 #define  PADS_CTL_RX_DATA_EN_1L	(1 << 10)
 
-#define PADS_PLL_CTL				0x000000B8
+#define  PADS_PLL_CTL_T20			0x000000B8
+#define  PADS_PLL_CTL_T30			0x000000B4
 #define  PADS_PLL_CTL_RST_B4SM			(1 << 1)
 #define  PADS_PLL_CTL_LOCKDET			(1 << 8)
 #define  PADS_PLL_CTL_REFCLK_MASK		(0x3 << 16)
@@ -183,8 +187,11 @@
 #define  PADS_PLL_CTL_REFCLK_INTERNAL_CMOS	(1 << 16)
 #define  PADS_PLL_CTL_REFCLK_EXTERNAL		(2 << 16)
 #define  PADS_PLL_CTL_TXCLKREF_MASK		(0x1 << 20)
+#define  PADS_PLL_CTL_TXCLKREF_BUF_EN		(1 << 22)
 #define  PADS_PLL_CTL_TXCLKREF_DIV10		(0 << 20)
 #define  PADS_PLL_CTL_TXCLKREF_DIV5		(1 << 20)
+#define  PADS_REFCLK_CFG0			0x000000C8
+#define  PADS_REFCLK_CFG1			0x000000CC
 
 struct tegra_msi {
 	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
@@ -195,6 +202,19 @@ struct tegra_msi {
 	int irq;
 };
 
+/* used to differentiate tegra chips code */
+struct tegra_pcie_soc_data {
+	unsigned int num_ports;
+	unsigned int msi_base_shift;
+	u32 pads_pll_ctl;
+	u32 tx_ref_sel;
+	bool has_pex_clkreq_en;
+	bool has_pex_bias_ctrl;
+	bool has_intr_prsnt_sense;
+	bool has_avdd_supply;
+	bool has_cml_clk;
+};
+
 static inline struct tegra_msi *to_tegra_msi(struct msi_chip *chip)
 {
 	return container_of(chip, struct tegra_msi, chip);
@@ -219,6 +239,7 @@ struct tegra_pcie {
 	struct clk *afi_clk;
 	struct clk *pcie_xclk;
 	struct clk *pll_e;
+	struct clk *cml_clk;
 
 	struct tegra_msi msi;
 
@@ -228,6 +249,9 @@ struct tegra_pcie {
 
 	struct regulator *pex_clk_supply;
 	struct regulator *vdd_supply;
+	struct regulator *avdd_supply;
+
+	struct tegra_pcie_soc_data *soc_data;
 };
 
 struct tegra_pcie_port {
@@ -510,12 +534,15 @@ static void tegra_pcie_port_reset(struct tegra_pcie_port *port)
 
 static void tegra_pcie_port_enable(struct tegra_pcie_port *port)
 {
+	struct tegra_pcie_soc_data *soc = port->pcie->soc_data;
 	unsigned long ctrl = tegra_pcie_port_get_pex_ctrl(port);
 	unsigned long value;
 
 	/* enable reference clock */
 	value = afi_readl(port->pcie, ctrl);
 	value |= AFI_PEX_CTRL_REFCLK_EN;
+	if (soc->has_pex_clkreq_en)
+		value |= AFI_PEX_CTRL_CLKREQ_EN;
 	afi_writel(port->pcie, value, ctrl);
 
 	tegra_pcie_port_reset(port);
@@ -568,6 +595,8 @@ static void tegra_pcie_fixup_class(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf0, tegra_pcie_fixup_class);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf1, tegra_pcie_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0e1c, tegra_pcie_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0e1d, tegra_pcie_fixup_class);
 
 /* Tegra PCIE requires relaxed ordering */
 static void tegra_pcie_relax_enable(struct pci_dev *dev)
@@ -748,6 +777,11 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
 	struct tegra_pcie_port *port;
 	unsigned int timeout;
 	unsigned long value;
+	struct tegra_pcie_soc_data *soc = pcie->soc_data;
+
+	/* power down to PCIe slot clock bias pad */
+	if (soc->has_pex_bias_ctrl)
+		afi_writel(pcie, 0, AFI_PEXBIAS_CTRL_0);
 
 	/* configure mode and disable all ports */
 	value = afi_readl(pcie, AFI_PCIE_CONFIG);
@@ -775,26 +809,26 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
 	 * Set up PHY PLL inputs select PLLE output as refclock,
 	 * set TX ref sel to div10 (not div5).
 	 */
-	value = pads_readl(pcie, PADS_PLL_CTL);
+	value = pads_readl(pcie, soc->pads_pll_ctl);
 	value &= ~(PADS_PLL_CTL_REFCLK_MASK | PADS_PLL_CTL_TXCLKREF_MASK);
-	value |= (PADS_PLL_CTL_REFCLK_INTERNAL_CML | PADS_PLL_CTL_TXCLKREF_DIV10);
-	pads_writel(pcie, value, PADS_PLL_CTL);
+	value |= PADS_PLL_CTL_REFCLK_INTERNAL_CML | soc->tx_ref_sel;
+	pads_writel(pcie, value, soc->pads_pll_ctl);
 
 	/* take PLL out of reset  */
-	value = pads_readl(pcie, PADS_PLL_CTL);
+	value = pads_readl(pcie, soc->pads_pll_ctl);
 	value |= PADS_PLL_CTL_RST_B4SM;
-	pads_writel(pcie, value, PADS_PLL_CTL);
+	pads_writel(pcie, value, soc->pads_pll_ctl);
 
 	/*
 	 * Hack, set the clock voltage to the DEFAULT provided by hw folks.
 	 * This doesn't exist in the documentation.
 	 */
-	pads_writel(pcie, 0xfa5cfa5c, 0xc8);
+	pads_writel(pcie, 0xfa5cfa5c, PADS_REFCLK_CFG0);
 
 	/* wait for the PLL to lock */
 	timeout = 300;
 	do {
-		value = pads_readl(pcie, PADS_PLL_CTL);
+		value = pads_readl(pcie, soc->pads_pll_ctl);
 		usleep_range(1000, 1000);
 		if (--timeout == 0) {
 			pr_err("Tegra PCIe error: timeout waiting for PLL\n");
@@ -823,6 +857,8 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
 	value = AFI_INTR_EN_INI_SLVERR | AFI_INTR_EN_INI_DECERR |
 		AFI_INTR_EN_TGT_SLVERR | AFI_INTR_EN_TGT_DECERR |
 		AFI_INTR_EN_TGT_WRERR | AFI_INTR_EN_DFPCI_DECERR;
+	if (soc->has_intr_prsnt_sense)
+		value |= AFI_INTR_EN_PRSNT_SENSE;
 	afi_writel(pcie, value, AFI_AFI_INTR_ENABLE);
 	afi_writel(pcie, 0xffffffff, AFI_SM_INTR_ENABLE);
 
@@ -837,6 +873,7 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
 
 static void tegra_pcie_power_off(struct tegra_pcie *pcie)
 {
+	struct tegra_pcie_soc_data *soc = pcie->soc_data;
 	int err;
 
 	/* TODO: disable and unprepare clocks? */
@@ -848,19 +885,26 @@ static void tegra_pcie_power_off(struct tegra_pcie *pcie)
 	tegra_powergate_power_off(TEGRA_POWERGATE_PCIE);
 	tegra_pmc_pcie_xclk_clamp(true);
 
+	if (soc->has_avdd_supply) {
+		err = regulator_disable(pcie->avdd_supply);
+		if (err < 0)
+			dev_warn(pcie->dev, "failed to disable AVDD regulator: %d\n",
+			err);
+	}
 	err = regulator_disable(pcie->pex_clk_supply);
 	if (err < 0)
-		dev_err(pcie->dev, "failed to disable pex-clk regulator: %d\n",
+		dev_warn(pcie->dev, "failed to disable pex-clk regulator: %d\n",
 			err);
 
 	err = regulator_disable(pcie->vdd_supply);
 	if (err < 0)
-		dev_err(pcie->dev, "failed to disable VDD regulator: %d\n",
+		dev_warn(pcie->dev, "failed to disable VDD regulator: %d\n",
 			err);
 }
 
 static int tegra_pcie_power_on(struct tegra_pcie *pcie)
 {
+	struct tegra_pcie_soc_data *soc = pcie->soc_data;
 	int err;
 
 	tegra_periph_reset_assert(pcie->pcie_xclk);
@@ -884,6 +928,15 @@ static int tegra_pcie_power_on(struct tegra_pcie *pcie)
 		return err;
 	}
 
+	if (soc->has_avdd_supply) {
+		err = regulator_enable(pcie->avdd_supply);
+		if (err < 0) {
+			dev_err(pcie->dev, "failed to enable AVDD regulator: %d\n",
+				err);
+			return err;
+		}
+	}
+
 	err = tegra_powergate_sequence_power_up(TEGRA_POWERGATE_PCIE,
 						pcie->pex_clk);
 	if (err) {
@@ -901,6 +954,15 @@ static int tegra_pcie_power_on(struct tegra_pcie *pcie)
 		return err;
 	}
 
+	if (soc->has_cml_clk) {
+		err = clk_prepare_enable(pcie->cml_clk);
+		if (err < 0) {
+			dev_err(pcie->dev, "failed to enable cml clock: %d\n",
+				err);
+			return err;
+		}
+	}
+
 	err = clk_prepare_enable(pcie->pll_e);
 	if (err < 0) {
 		dev_err(pcie->dev, "failed to enable PLLE clock: %d\n", err);
@@ -912,6 +974,8 @@ static int tegra_pcie_power_on(struct tegra_pcie *pcie)
 
 static int tegra_pcie_clocks_get(struct tegra_pcie *pcie)
 {
+	struct tegra_pcie_soc_data *soc = pcie->soc_data;
+
 	pcie->pex_clk = devm_clk_get(pcie->dev, "pex");
 	if (IS_ERR(pcie->pex_clk))
 		return PTR_ERR(pcie->pex_clk);
@@ -928,6 +992,11 @@ static int tegra_pcie_clocks_get(struct tegra_pcie *pcie)
 	if (IS_ERR(pcie->pll_e))
 		return PTR_ERR(pcie->pll_e);
 
+	if (soc->has_cml_clk) {
+		pcie->cml_clk = devm_clk_get(pcie->dev, "cml");
+		if (IS_ERR(pcie->cml_clk))
+			return PTR_ERR(pcie->cml_clk);
+	}
 	return 0;
 }
 
@@ -1150,6 +1219,7 @@ static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
 {
 	struct platform_device *pdev = to_platform_device(pcie->dev);
 	struct tegra_msi *msi = &pcie->msi;
+	struct tegra_pcie_soc_data *soc = pcie->soc_data;
 	unsigned long base;
 	int err;
 	u32 reg;
@@ -1186,7 +1256,7 @@ static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
 	msi->pages = __get_free_pages(GFP_KERNEL, 3);
 	base = virt_to_phys((void *)msi->pages);
 
-	afi_writel(pcie, base, AFI_MSI_FPCI_BAR_ST);
+	afi_writel(pcie, base >> soc->msi_base_shift, AFI_MSI_FPCI_BAR_ST);
 	afi_writel(pcie, base, AFI_MSI_AXI_BAR_ST);
 	/* this register is in 4K increments */
 	afi_writel(pcie, 1, AFI_MSI_BAR_SZ);
@@ -1283,6 +1353,7 @@ static u32 tegra_pcie_get_xbar_config(struct tegra_pcie *pcie, u32 lanes)
 static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 {
 	struct device_node *np = pcie->dev->of_node, *port;
+	struct tegra_pcie_soc_data *soc = pcie->soc_data;
 	struct of_pci_range_parser parser;
 	struct of_pci_range range;
 	struct resource res;
@@ -1302,6 +1373,12 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 	if (IS_ERR(pcie->pex_clk_supply))
 		return PTR_ERR(pcie->pex_clk_supply);
 
+	if (soc->has_avdd_supply) {
+		pcie->avdd_supply = devm_regulator_get(pcie->dev, "avdd");
+		if (IS_ERR(pcie->avdd_supply))
+			return PTR_ERR(pcie->avdd_supply);
+	}
+
 	for_each_of_pci_range(&parser, &range) {
 		of_pci_range_to_resource(&range, np, &res);
 
@@ -1348,7 +1425,7 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 
 		index = PCI_SLOT(err);
 
-		if (index < 1 || index > TEGRA_MAX_PORTS) {
+		if (index < 1 || index > pcie->soc_data->num_ports) {
 			dev_err(pcie->dev, "invalid port number: %d\n", index);
 			return -EINVAL;
 		}
@@ -1484,8 +1561,39 @@ static int tegra_pcie_enable(struct tegra_pcie *pcie)
 	return 0;
 }
 
+static const struct tegra_pcie_soc_data tegra20_pcie_data = {
+	.num_ports = 2,
+	.msi_base_shift = 0,
+	.pads_pll_ctl = PADS_PLL_CTL_T20,
+	.tx_ref_sel = PADS_PLL_CTL_TXCLKREF_DIV10,
+	.has_pex_clkreq_en = false,
+	.has_pex_bias_ctrl = false,
+	.has_intr_prsnt_sense = false,
+	.has_avdd_supply = false,
+	.has_cml_clk = false,
+};
+
+static const struct tegra_pcie_soc_data tegra30_pcie_data = {
+	.num_ports = 3,
+	.msi_base_shift = 8,
+	.pads_pll_ctl = PADS_PLL_CTL_T30,
+	.tx_ref_sel = PADS_PLL_CTL_TXCLKREF_BUF_EN,
+	.has_pex_clkreq_en = true,
+	.has_pex_bias_ctrl = true,
+	.has_intr_prsnt_sense = true,
+	.has_avdd_supply = true,
+	.has_cml_clk = true,
+};
+
+static const struct of_device_id tegra_pcie_of_match[] = {
+	{ .compatible = "nvidia,tegra30-pcie", .data = &tegra30_pcie_data},
+	{ .compatible = "nvidia,tegra20-pcie", .data = &tegra20_pcie_data},
+	{ },
+};
+
 static int tegra_pcie_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *match;
 	struct tegra_pcie *pcie;
 	int err;
 
@@ -1496,6 +1604,10 @@ static int tegra_pcie_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&pcie->busses);
 	INIT_LIST_HEAD(&pcie->ports);
 	pcie->dev = &pdev->dev;
+	match = of_match_device(tegra_pcie_of_match, &pdev->dev);
+	if (!match)
+		return -ENODEV;
+	pcie->soc_data = (struct tegra_pcie_soc_data *)match->data;
 
 	err = tegra_pcie_parse_dt(pcie);
 	if (err < 0)
@@ -1567,11 +1679,6 @@ static int tegra_pcie_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id tegra_pcie_of_match[] = {
-	{ .compatible = "nvidia,tegra20-pcie", },
-	{ },
-};
-
 static struct platform_driver tegra_pcie_driver = {
 	.driver = {
 		.name = "tegra-pcie",
-- 
1.7.0.4

