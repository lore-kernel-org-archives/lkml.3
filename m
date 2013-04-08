Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965139Ab3DHPjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:39:40 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13511 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942Ab3DHPji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:39:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 08 Apr 2013 08:39:29 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>,
        <thierry.reding@avionic-design.de>, <ldewangan@nvidia.com>,
        <bhelgaas@google.com>, <olof@lixom.net>, <hdoyu@nvidia.com>,
        <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <pdeschrijver@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <jtukkinen@nvidia.com>, <kthota@nvidia.com>, <jagarwal@nvidia.com>
Subject: [PATCH 1/3] ARM: tegra: pcie: Add tegra3 support
Date: Mon, 8 Apr 2013 21:11:26 +0530
Message-ID: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>

- Enable pcie root port 2 for cardhu
- Make private data structure for each SOC
- Add required tegra3 clocks and regulators
- Add tegra3 specific code in enable controller
- Modify clock tree to get clocks based on device
- Based on git://gitorious.org/thierryreding/linux.git

 drivers/clk/tegra/clk-tegra30.c |   12 ++--
 drivers/pci/host/pci-tegra.c    |  146 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 133 insertions(+), 25 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index ba6f51b..6a80b40 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1592,6 +1592,12 @@ static void __init tegra30_periph_clk_init(void)
 	clk_register_clkdev(clk, "afi", "tegra-pcie");
 	clks[afi] = clk;
 
+	/* pciex */
+	clk = tegra_clk_register_periph_gate("pciex", "pll_e", 0, clk_base, 0,
+				    74, &periph_u_regs, periph_clk_enb_refcnt);
+	clk_register_clkdev(clk, "pciex", NULL);
+	clks[pciex] = clk;
+
 	/* kfuse */
 	clk = tegra_clk_register_periph_gate("kfuse", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
@@ -1710,11 +1716,6 @@ static void __init tegra30_fixed_clk_init(void)
 				1, 0, &cml_lock);
 	clk_register_clkdev(clk, "cml1", NULL);
 	clks[cml1] = clk;
-
-	/* pciex */
-	clk = clk_register_fixed_rate(NULL, "pciex", "pll_e", 0, 100000000);
-	clk_register_clkdev(clk, "pciex", NULL);
-	clks[pciex] = clk;
 }
 
 static void __init tegra30_osc_clk_init(void)
@@ -1930,7 +1931,6 @@ static struct tegra_clk_duplicate tegra_clk_duplicates[] = {
 	TEGRA_CLK_DUPLICATE(bsea, "nvavp", "bsea"),
 	TEGRA_CLK_DUPLICATE(cml1, "tegra_sata_cml", NULL),
 	TEGRA_CLK_DUPLICATE(cml0, "tegra_pcie", "cml"),
-	TEGRA_CLK_DUPLICATE(pciex, "tegra_pcie", "pciex"),
 	TEGRA_CLK_DUPLICATE(vcp, "nvavp", "vcp"),
 	TEGRA_CLK_DUPLICATE(clk_max, NULL, NULL), /* MUST be the last entry */
 };
diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 24085ed..79c0996 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -51,7 +51,6 @@
 #include <mach/powergate.h>
 
 #define INT_PCI_MSI_NR (8 * 32)
-#define TEGRA_MAX_PORTS 2
 
 /* register definitions */
 
@@ -143,14 +142,15 @@
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
 
@@ -161,8 +161,11 @@
 #define AFI_PEX1_CTRL			0x118
 #define AFI_PEX2_CTRL			0x128
 #define  AFI_PEX_CTRL_RST		(1 << 0)
+#define  AFI_PEX_CTRL_CLKREQ_EN		(1 << 1)
 #define  AFI_PEX_CTRL_REFCLK_EN		(1 << 3)
 
+#define  AFI_PEXBIAS_CTRL_0		0x168
+
 #define RP_VEND_XP	0x00000F00
 #define  RP_VEND_XP_DL_UP	(1 << 30)
 
@@ -176,7 +179,8 @@
 #define  PADS_CTL_TX_DATA_EN_1L	(1 << 6)
 #define  PADS_CTL_RX_DATA_EN_1L	(1 << 10)
 
-#define PADS_PLL_CTL				0x000000B8
+#define  PADS_PLL_CTL_T20			0x000000B8
+#define  PADS_PLL_CTL_T30			0x000000B4
 #define  PADS_PLL_CTL_RST_B4SM			(1 << 1)
 #define  PADS_PLL_CTL_LOCKDET			(1 << 8)
 #define  PADS_PLL_CTL_REFCLK_MASK		(0x3 << 16)
@@ -184,8 +188,11 @@
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
@@ -196,6 +203,19 @@ struct tegra_msi {
 	int irq;
 };
 
+/* used to differente tegra chips code */
+struct tegra_pcie_soc_data {
+	unsigned int num_max_ports;
+	unsigned int pads_pll_ctl;
+	unsigned int tx_ref_sel;
+	unsigned int msi_base_shift;
+	bool pex_clkreq_en;
+	bool pex_bias_ctrl;
+	bool intr_prsnt_sense;
+	bool need_avdd_supply;
+	bool need_cml0_clk;
+};
+
 static inline struct tegra_msi *to_tegra_msi(struct msi_chip *chip)
 {
 	return container_of(chip, struct tegra_msi, chip);
@@ -220,6 +240,7 @@ struct tegra_pcie {
 	struct clk *afi_clk;
 	struct clk *pcie_xclk;
 	struct clk *pll_e;
+	struct clk *cml0_clk;
 
 	struct tegra_msi msi;
 
@@ -229,6 +250,9 @@ struct tegra_pcie {
 
 	struct regulator *pex_clk_supply;
 	struct regulator *vdd_supply;
+	struct regulator *avdd_supply;
+
+	struct tegra_pcie_soc_data *soc_data;
 };
 
 struct tegra_pcie_port {
@@ -511,12 +535,15 @@ static void tegra_pcie_port_reset(struct tegra_pcie_port *port)
 
 static void tegra_pcie_port_enable(struct tegra_pcie_port *port)
 {
+	struct tegra_pcie_soc_data *soc = port->pcie->soc_data;
 	unsigned long ctrl = tegra_pcie_port_get_pex_ctrl(port);
 	unsigned long value;
 
 	/* enable reference clock */
 	value = afi_readl(port->pcie, ctrl);
 	value |= AFI_PEX_CTRL_REFCLK_EN;
+	if (soc->pex_clkreq_en)
+		value |= AFI_PEX_CTRL_CLKREQ_EN;
 	afi_writel(port->pcie, value, ctrl);
 
 	tegra_pcie_port_reset(port);
@@ -569,6 +596,8 @@ static void tegra_pcie_fixup_class(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf0, tegra_pcie_fixup_class);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf1, tegra_pcie_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0e1c, tegra_pcie_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0e1d, tegra_pcie_fixup_class);
 
 /* Tegra PCIE requires relaxed ordering */
 static void tegra_pcie_relax_enable(struct pci_dev *dev)
@@ -749,6 +778,11 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
 	struct tegra_pcie_port *port;
 	unsigned int timeout;
 	unsigned long value;
+	struct tegra_pcie_soc_data *soc = pcie->soc_data;
+
+	/* power down to PCIe slot clock bias pad */
+	if (soc->pex_bias_ctrl)
+		afi_writel(pcie, 0, AFI_PEXBIAS_CTRL_0);
 
 	/* configure mode and disable all ports */
 	value = afi_readl(pcie, AFI_PCIE_CONFIG);
@@ -776,26 +810,26 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
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
@@ -824,6 +858,8 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
 	value = AFI_INTR_EN_INI_SLVERR | AFI_INTR_EN_INI_DECERR |
 		AFI_INTR_EN_TGT_SLVERR | AFI_INTR_EN_TGT_DECERR |
 		AFI_INTR_EN_TGT_WRERR | AFI_INTR_EN_DFPCI_DECERR;
+	if (soc->intr_prsnt_sense)
+		value |= AFI_INTR_EN_PRSNT_SENSE;
 	afi_writel(pcie, value, AFI_AFI_INTR_ENABLE);
 	afi_writel(pcie, 0xffffffff, AFI_SM_INTR_ENABLE);
 
@@ -838,6 +874,7 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
 
 static void tegra_pcie_power_off(struct tegra_pcie *pcie)
 {
+	struct tegra_pcie_soc_data *soc = pcie->soc_data;
 	int err;
 
 	/* TODO: disable and unprepare clocks? */
@@ -849,19 +886,26 @@ static void tegra_pcie_power_off(struct tegra_pcie *pcie)
 	tegra_powergate_power_off(TEGRA_POWERGATE_PCIE);
 	tegra_pmc_pcie_xclk_clamp(true);
 
+	if (soc->need_avdd_supply) {
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
@@ -885,6 +929,15 @@ static int tegra_pcie_power_on(struct tegra_pcie *pcie)
 		return err;
 	}
 
+	if (soc->need_avdd_supply) {
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
@@ -902,6 +955,15 @@ static int tegra_pcie_power_on(struct tegra_pcie *pcie)
 		return err;
 	}
 
+	if (soc->need_cml0_clk) {
+		err = clk_prepare_enable(pcie->cml0_clk);
+		if (err < 0) {
+			dev_err(pcie->dev, "failed to enable cml0 clock: %d\n",
+				err);
+			return err;
+		}
+	}
+
 	err = clk_prepare_enable(pcie->pll_e);
 	if (err < 0) {
 		dev_err(pcie->dev, "failed to enable PLLE clock: %d\n", err);
@@ -913,6 +975,8 @@ static int tegra_pcie_power_on(struct tegra_pcie *pcie)
 
 static int tegra_pcie_clocks_get(struct tegra_pcie *pcie)
 {
+	struct tegra_pcie_soc_data *soc = pcie->soc_data;
+
 	pcie->pex_clk = devm_clk_get(pcie->dev, "pex");
 	if (IS_ERR(pcie->pex_clk))
 		return PTR_ERR(pcie->pex_clk);
@@ -929,6 +993,11 @@ static int tegra_pcie_clocks_get(struct tegra_pcie *pcie)
 	if (IS_ERR(pcie->pll_e))
 		return PTR_ERR(pcie->pll_e);
 
+	if (soc->need_cml0_clk) {
+		pcie->cml0_clk = devm_clk_get(pcie->dev, "cml0");
+		if (IS_ERR(pcie->cml0_clk))
+			return PTR_ERR(pcie->cml0_clk);
+	}
 	return 0;
 }
 
@@ -1151,6 +1220,7 @@ static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
 {
 	struct platform_device *pdev = to_platform_device(pcie->dev);
 	struct tegra_msi *msi = &pcie->msi;
+	struct tegra_pcie_soc_data *soc = pcie->soc_data;
 	unsigned long base;
 	int err;
 	u32 reg;
@@ -1187,7 +1257,7 @@ static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
 	msi->pages = __get_free_pages(GFP_KERNEL, 3);
 	base = virt_to_phys((void *)msi->pages);
 
-	afi_writel(pcie, base, AFI_MSI_FPCI_BAR_ST);
+	afi_writel(pcie, base >> soc->msi_base_shift, AFI_MSI_FPCI_BAR_ST);
 	afi_writel(pcie, base, AFI_MSI_AXI_BAR_ST);
 	/* this register is in 4K increments */
 	afi_writel(pcie, 1, AFI_MSI_BAR_SZ);
@@ -1284,6 +1354,7 @@ static u32 tegra_pcie_get_xbar_config(struct tegra_pcie *pcie, u32 lanes)
 static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 {
 	struct device_node *np = pcie->dev->of_node, *port;
+	struct tegra_pcie_soc_data *soc = pcie->soc_data;
 	const __be32 *range = NULL;
 	struct resource res;
 	u32 lanes = 0;
@@ -1297,6 +1368,12 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 	if (IS_ERR(pcie->pex_clk_supply))
 		return PTR_ERR(pcie->pex_clk_supply);
 
+	if (soc->need_avdd_supply) {
+		pcie->avdd_supply = devm_regulator_get(pcie->dev, "avdd");
+		if (IS_ERR(pcie->avdd_supply))
+			return PTR_ERR(pcie->avdd_supply);
+	}
+
 	while ((range = of_pci_process_ranges(np, &res, range)) != NULL) {
 		switch (res.flags & IORESOURCE_TYPE_BITS) {
 		case IORESOURCE_IO:
@@ -1341,7 +1418,7 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 
 		index = PCI_SLOT(err);
 
-		if (index < 1 || index > TEGRA_MAX_PORTS) {
+		if (index < 1 || index > pcie->soc_data->num_max_ports) {
 			dev_err(pcie->dev, "invalid port number: %d\n", index);
 			return -EINVAL;
 		}
@@ -1477,8 +1554,39 @@ static int tegra_pcie_enable(struct tegra_pcie *pcie)
 	return 0;
 }
 
+static const struct tegra_pcie_soc_data tegra20_pcie_data = {
+	.num_max_ports = 2,
+	.pads_pll_ctl = PADS_PLL_CTL_T20,
+	.tx_ref_sel = PADS_PLL_CTL_TXCLKREF_DIV10,
+	.msi_base_shift = 0,
+	.pex_clkreq_en = false,
+	.pex_bias_ctrl = false,
+	.intr_prsnt_sense = false,
+	.need_avdd_supply = false,
+	.need_cml0_clk = false,
+};
+
+static const struct tegra_pcie_soc_data tegra30_pcie_data = {
+	.num_max_ports = 3,
+	.pads_pll_ctl = PADS_PLL_CTL_T30,
+	.tx_ref_sel = PADS_PLL_CTL_TXCLKREF_BUF_EN,
+	.msi_base_shift = 8,
+	.pex_clkreq_en = true,
+	.pex_bias_ctrl = true,
+	.intr_prsnt_sense = true,
+	.need_avdd_supply = true,
+	.need_cml0_clk = true,
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
 
@@ -1489,6 +1597,11 @@ static int tegra_pcie_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&pcie->busses);
 	INIT_LIST_HEAD(&pcie->ports);
 	pcie->dev = &pdev->dev;
+	match = of_match_device(tegra_pcie_of_match, &pdev->dev);
+	if (match)
+		pcie->soc_data = (struct tegra_pcie_soc_data *)match->data;
+	else
+		return -ENODEV;
 
 	err = tegra_pcie_parse_dt(pcie);
 	if (err < 0)
@@ -1560,11 +1673,6 @@ static int tegra_pcie_remove(struct platform_device *pdev)
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

