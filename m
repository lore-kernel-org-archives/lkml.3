Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab3GYSBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:01:11 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:54481 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722Ab3GYSBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:01:03 -0400
MIME-Version: 1.0
In-Reply-To: <1374774810-18459-9-git-send-email-thierry.reding@gmail.com>
References: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com> <1374774810-18459-9-git-send-email-thierry.reding@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Jul 2013 12:00:42 -0600
Message-ID: <CAErSpo7hcuqGcaYZCLa72Kavq-LVUP=HOPkWXDDj=cgP+LfT9g@mail.gmail.com>
Subject: Re: [PATCH v5 08/16] PCI: tegra: Add Tegra 30 PCIe support
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jay Agarwal <jagarwal@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        devicetree@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:53 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> From: Jay Agarwal <jagarwal@nvidia.com>
>
> Introduce a data structure to parameterize the driver according to SoC
> generation, add Tegra30 specific code and update the device tree binding
> document for Tegra30 support.
>
> Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  .../bindings/pci/nvidia,tegra20-pcie.txt           |   4 +-
>  drivers/pci/host/pci-tegra.c                       | 209 +++++++++++++++++----
>  2 files changed, 179 insertions(+), 34 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
> index 90c112f..6b75107 100644
> --- a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
> +++ b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
> @@ -1,7 +1,7 @@
>  NVIDIA Tegra PCIe controller
>
>  Required properties:
> -- compatible: "nvidia,tegra20-pcie"
> +- compatible: "nvidia,tegra20-pcie" or "nvidia,tegra30-pcie"
>  - device_type: Must be "pci"
>  - reg: A list of physical base address and length for each set of controller
>    registers. Must contain an entry for each entry in the reg-names property.
> @@ -16,6 +16,7 @@ Required properties:
>    "msi": The Tegra interrupt that is asserted when an MSI is received
>  - pex-clk-supply: Supply voltage for internal reference clock
>  - vdd-supply: Power supply for controller (1.05V)
> +- avdd-supply: Power supply for controller (1.05V) (not required for Tegra20)
>  - bus-range: Range of bus numbers associated with this controller
>  - #address-cells: Address representation for root ports (must be 3)
>    - cell 0 specifies the bus and device numbers of the root port:
> @@ -48,6 +49,7 @@ Required properties:
>    "afi": The Tegra clock of that name
>    "pcie_xclk": The Tegra clock of that name
>    "pll_e": The Tegra clock of that name
> +  "cml": The Tegra clock of that name (not required for Tegra20)
>
>  Root ports are defined as subnodes of the PCIe controller node.
>
> diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
> index 223069a..5347d7d 100644
> --- a/drivers/pci/host/pci-tegra.c
> +++ b/drivers/pci/host/pci-tegra.c
> @@ -1,5 +1,5 @@
>  /*
> - * PCIe host controller driver for TEGRA(2) SOCs
> + * PCIe host controller driver for Tegra SoCs
>   *
>   * Copyright (c) 2010, CompuLab, Ltd.
>   * Author: Mike Rapoport <mike@compulab.co.il>
> @@ -51,7 +51,6 @@
>  #include <asm/mach/pci.h>
>
>  #define INT_PCI_MSI_NR (8 * 32)
> -#define TEGRA_MAX_PORTS 2
>
>  /* register definitions */
>
> @@ -143,22 +142,30 @@
>  #define  AFI_INTR_EN_DFPCI_DECERR      (1 << 5)
>  #define  AFI_INTR_EN_AXI_DECERR                (1 << 6)
>  #define  AFI_INTR_EN_FPCI_TIMEOUT      (1 << 7)
> +#define  AFI_INTR_EN_PRSNT_SENSE       (1 << 8)
>
>  #define AFI_PCIE_CONFIG                                        0x0f8
>  #define  AFI_PCIE_CONFIG_PCIE_DISABLE(x)               (1 << ((x) + 1))
>  #define  AFI_PCIE_CONFIG_PCIE_DISABLE_ALL              0xe
>  #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_MASK      (0xf << 20)
>  #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_SINGLE    (0x0 << 20)
> +#define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_420       (0x0 << 20)
>  #define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_DUAL      (0x1 << 20)
> +#define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_222       (0x1 << 20)
> +#define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_411       (0x2 << 20)
>
>  #define AFI_FUSE                       0x104
>  #define  AFI_FUSE_PCIE_T0_GEN2_DIS     (1 << 2)
>
>  #define AFI_PEX0_CTRL                  0x110
>  #define AFI_PEX1_CTRL                  0x118
> +#define AFI_PEX2_CTRL                  0x128
>  #define  AFI_PEX_CTRL_RST              (1 << 0)
> +#define  AFI_PEX_CTRL_CLKREQ_EN                (1 << 1)
>  #define  AFI_PEX_CTRL_REFCLK_EN                (1 << 3)
>
> +#define AFI_PEXBIAS_CTRL_0             0x168
> +
>  #define RP_VEND_XP     0x00000F00
>  #define  RP_VEND_XP_DL_UP      (1 << 30)
>
> @@ -173,7 +180,8 @@
>  #define  PADS_CTL_TX_DATA_EN_1L        (1 << 6)
>  #define  PADS_CTL_RX_DATA_EN_1L        (1 << 10)
>
> -#define PADS_PLL_CTL                           0x000000B8
> +#define PADS_PLL_CTL_TEGRA20                   0x000000B8
> +#define PADS_PLL_CTL_TEGRA30                   0x000000B4
>  #define  PADS_PLL_CTL_RST_B4SM                 (1 << 1)
>  #define  PADS_PLL_CTL_LOCKDET                  (1 << 8)
>  #define  PADS_PLL_CTL_REFCLK_MASK              (0x3 << 16)
> @@ -183,6 +191,10 @@
>  #define  PADS_PLL_CTL_TXCLKREF_MASK            (0x1 << 20)
>  #define  PADS_PLL_CTL_TXCLKREF_DIV10           (0 << 20)
>  #define  PADS_PLL_CTL_TXCLKREF_DIV5            (1 << 20)
> +#define  PADS_PLL_CTL_TXCLKREF_BUF_EN          (1 << 22)
> +
> +#define PADS_REFCLK_CFG0                       0x000000C8
> +#define PADS_REFCLK_CFG1                       0x000000CC
>
>  struct tegra_msi {
>         struct msi_chip chip;
> @@ -193,6 +205,19 @@ struct tegra_msi {
>         int irq;
>  };
>
> +/* used to differentiate between Tegra SoC generations */
> +struct tegra_pcie_soc_data {
> +       unsigned int num_ports;
> +       unsigned int msi_base_shift;
> +       u32 pads_pll_ctl;
> +       u32 tx_ref_sel;
> +       bool has_pex_clkreq_en;
> +       bool has_pex_bias_ctrl;
> +       bool has_intr_prsnt_sense;
> +       bool has_avdd_supply;
> +       bool has_cml_clk;
> +};
> +
>  static inline struct tegra_msi *to_tegra_msi(struct msi_chip *chip)
>  {
>         return container_of(chip, struct tegra_msi, chip);
> @@ -217,6 +242,7 @@ struct tegra_pcie {
>         struct clk *afi_clk;
>         struct clk *pcie_xclk;
>         struct clk *pll_e;
> +       struct clk *cml_clk;
>
>         struct tegra_msi msi;
>
> @@ -226,6 +252,9 @@ struct tegra_pcie {
>
>         struct regulator *pex_clk_supply;
>         struct regulator *vdd_supply;
> +       struct regulator *avdd_supply;
> +
> +       const struct tegra_pcie_soc_data *soc_data;
>  };
>
>  struct tegra_pcie_port {
> @@ -470,6 +499,10 @@ static unsigned long tegra_pcie_port_get_pex_ctrl(struct tegra_pcie_port *port)
>         case 1:
>                 ret = AFI_PEX1_CTRL;
>                 break;
> +
> +       case 2:
> +               ret = AFI_PEX2_CTRL;
> +               break;
>         }
>
>         return ret;
> @@ -494,12 +527,17 @@ static void tegra_pcie_port_reset(struct tegra_pcie_port *port)
>
>  static void tegra_pcie_port_enable(struct tegra_pcie_port *port)
>  {
> +       const struct tegra_pcie_soc_data *soc = port->pcie->soc_data;
>         unsigned long ctrl = tegra_pcie_port_get_pex_ctrl(port);
>         unsigned long value;
>
>         /* enable reference clock */
>         value = afi_readl(port->pcie, ctrl);
>         value |= AFI_PEX_CTRL_REFCLK_EN;
> +
> +       if (soc->has_pex_clkreq_en)
> +               value |= AFI_PEX_CTRL_CLKREQ_EN;
> +
>         afi_writel(port->pcie, value, ctrl);
>
>         tegra_pcie_port_reset(port);
> @@ -552,6 +590,8 @@ static void tegra_pcie_fixup_class(struct pci_dev *dev)
>  }
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf0, tegra_pcie_fixup_class);
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf1, tegra_pcie_fixup_class);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0e1c, tegra_pcie_fixup_class);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0e1d, tegra_pcie_fixup_class);
>
>  /* Tegra PCIE requires relaxed ordering */
>  static void tegra_pcie_relax_enable(struct pci_dev *dev)
> @@ -724,10 +764,15 @@ static void tegra_pcie_setup_translations(struct tegra_pcie *pcie)
>
>  static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
>  {
> +       const struct tegra_pcie_soc_data *soc = pcie->soc_data;
>         struct tegra_pcie_port *port;
>         unsigned int timeout;
>         unsigned long value;
>
> +       /* power down PCIe slot clock bias pad */
> +       if (soc->has_pex_bias_ctrl)
> +               afi_writel(pcie, 0, AFI_PEXBIAS_CTRL_0);
> +
>         /* configure mode and disable all ports */
>         value = afi_readl(pcie, AFI_PCIE_CONFIG);
>         value &= ~AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_MASK;
> @@ -754,27 +799,26 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
>          * Set up PHY PLL inputs select PLLE output as refclock,
>          * set TX ref sel to div10 (not div5).
>          */
> -       value = pads_readl(pcie, PADS_PLL_CTL);
> +       value = pads_readl(pcie, soc->pads_pll_ctl);
>         value &= ~(PADS_PLL_CTL_REFCLK_MASK | PADS_PLL_CTL_TXCLKREF_MASK);
> -       value |= PADS_PLL_CTL_REFCLK_INTERNAL_CML |
> -                PADS_PLL_CTL_TXCLKREF_DIV10;
> -       pads_writel(pcie, value, PADS_PLL_CTL);
> +       value |= PADS_PLL_CTL_REFCLK_INTERNAL_CML | soc->tx_ref_sel;
> +       pads_writel(pcie, value, soc->pads_pll_ctl);
>
>         /* take PLL out of reset  */
> -       value = pads_readl(pcie, PADS_PLL_CTL);
> +       value = pads_readl(pcie, soc->pads_pll_ctl);
>         value |= PADS_PLL_CTL_RST_B4SM;
> -       pads_writel(pcie, value, PADS_PLL_CTL);
> +       pads_writel(pcie, value, soc->pads_pll_ctl);
>
>         /*
>          * Hack, set the clock voltage to the DEFAULT provided by hw folks.
>          * This doesn't exist in the documentation.
>          */
> -       pads_writel(pcie, 0xfa5cfa5c, 0xc8);
> +       pads_writel(pcie, 0xfa5cfa5c, PADS_REFCLK_CFG0);
>
>         /* wait for the PLL to lock */
>         timeout = 300;
>         do {
> -               value = pads_readl(pcie, PADS_PLL_CTL);
> +               value = pads_readl(pcie, soc->pads_pll_ctl);
>                 usleep_range(1000, 2000);
>                 if (--timeout == 0) {
>                         pr_err("Tegra PCIe error: timeout waiting for PLL\n");
> @@ -803,6 +847,10 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
>         value = AFI_INTR_EN_INI_SLVERR | AFI_INTR_EN_INI_DECERR |
>                 AFI_INTR_EN_TGT_SLVERR | AFI_INTR_EN_TGT_DECERR |
>                 AFI_INTR_EN_TGT_WRERR | AFI_INTR_EN_DFPCI_DECERR;
> +
> +       if (soc->has_intr_prsnt_sense)
> +               value |= AFI_INTR_EN_PRSNT_SENSE;
> +
>         afi_writel(pcie, value, AFI_AFI_INTR_ENABLE);
>         afi_writel(pcie, 0xffffffff, AFI_SM_INTR_ENABLE);
>
> @@ -817,6 +865,7 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
>
>  static void tegra_pcie_power_off(struct tegra_pcie *pcie)
>  {
> +       const struct tegra_pcie_soc_data *soc = pcie->soc_data;
>         int err;
>
>         /* TODO: disable and unprepare clocks? */
> @@ -828,19 +877,28 @@ static void tegra_pcie_power_off(struct tegra_pcie *pcie)
>         tegra_powergate_power_off(TEGRA_POWERGATE_PCIE);
>         tegra_pmc_pcie_xclk_clamp(true);
>
> +       if (soc->has_avdd_supply) {
> +               err = regulator_disable(pcie->avdd_supply);
> +               if (err < 0)
> +                       dev_warn(pcie->dev,
> +                                "failed to disable AVDD regulator: %d\n",
> +                                err);
> +       }
> +
>         err = regulator_disable(pcie->pex_clk_supply);
>         if (err < 0)
> -               dev_err(pcie->dev, "failed to disable pex-clk regulator: %d\n",
> -                       err);
> +               dev_warn(pcie->dev, "failed to disable pex-clk regulator: %d\n",
> +                        err);
>
>         err = regulator_disable(pcie->vdd_supply);
>         if (err < 0)
> -               dev_err(pcie->dev, "failed to disable VDD regulator: %d\n",
> -                       err);
> +               dev_warn(pcie->dev, "failed to disable VDD regulator: %d\n",
> +                        err);
>  }
>
>  static int tegra_pcie_power_on(struct tegra_pcie *pcie)
>  {
> +       const struct tegra_pcie_soc_data *soc = pcie->soc_data;
>         int err;
>
>         tegra_periph_reset_assert(pcie->pcie_xclk);
> @@ -864,6 +922,16 @@ static int tegra_pcie_power_on(struct tegra_pcie *pcie)
>                 return err;
>         }
>
> +       if (soc->has_avdd_supply) {
> +               err = regulator_enable(pcie->avdd_supply);
> +               if (err < 0) {
> +                       dev_err(pcie->dev,
> +                               "failed to enable AVDD regulator: %d\n",
> +                               err);
> +                       return err;
> +               }
> +       }
> +
>         err = tegra_powergate_sequence_power_up(TEGRA_POWERGATE_PCIE,
>                                                 pcie->pex_clk);
>         if (err) {
> @@ -881,6 +949,15 @@ static int tegra_pcie_power_on(struct tegra_pcie *pcie)
>                 return err;
>         }
>
> +       if (soc->has_cml_clk) {
> +               err = clk_prepare_enable(pcie->cml_clk);
> +               if (err < 0) {
> +                       dev_err(pcie->dev, "failed to enable CML clock: %d\n",
> +                               err);
> +                       return err;
> +               }
> +       }
> +
>         err = clk_prepare_enable(pcie->pll_e);
>         if (err < 0) {
>                 dev_err(pcie->dev, "failed to enable PLLE clock: %d\n", err);
> @@ -892,6 +969,8 @@ static int tegra_pcie_power_on(struct tegra_pcie *pcie)
>
>  static int tegra_pcie_clocks_get(struct tegra_pcie *pcie)
>  {
> +       const struct tegra_pcie_soc_data *soc = pcie->soc_data;
> +
>         pcie->pex_clk = devm_clk_get(pcie->dev, "pex");
>         if (IS_ERR(pcie->pex_clk))
>                 return PTR_ERR(pcie->pex_clk);
> @@ -908,6 +987,12 @@ static int tegra_pcie_clocks_get(struct tegra_pcie *pcie)
>         if (IS_ERR(pcie->pll_e))
>                 return PTR_ERR(pcie->pll_e);
>
> +       if (soc->has_cml_clk) {
> +               pcie->cml_clk = devm_clk_get(pcie->dev, "cml");
> +               if (IS_ERR(pcie->cml_clk))
> +                       return PTR_ERR(pcie->cml_clk);
> +       }
> +
>         return 0;
>  }
>
> @@ -1132,6 +1217,7 @@ static const struct irq_domain_ops msi_domain_ops = {
>  static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
>  {
>         struct platform_device *pdev = to_platform_device(pcie->dev);
> +       const struct tegra_pcie_soc_data *soc = pcie->soc_data;
>         struct tegra_msi *msi = &pcie->msi;
>         unsigned long base;
>         int err;
> @@ -1169,7 +1255,7 @@ static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
>         msi->pages = __get_free_pages(GFP_KERNEL, 0);
>         base = virt_to_phys((void *)msi->pages);
>
> -       afi_writel(pcie, base, AFI_MSI_FPCI_BAR_ST);
> +       afi_writel(pcie, base >> soc->msi_base_shift, AFI_MSI_FPCI_BAR_ST);
>         afi_writel(pcie, base, AFI_MSI_AXI_BAR_ST);
>         /* this register is in 4K increments */
>         afi_writel(pcie, 1, AFI_MSI_BAR_SZ);
> @@ -1238,16 +1324,35 @@ static int tegra_pcie_get_xbar_config(struct tegra_pcie *pcie, u32 lanes,
>  {
>         struct device_node *np = pcie->dev->of_node;
>
> -       switch (lanes) {
> -       case 0x00000004:
> -               dev_info(pcie->dev, "single-mode configuration\n");
> -               *xbar = AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_SINGLE;
> -               return 0;
> -
> -       case 0x00000202:
> -               dev_info(pcie->dev, "dual-mode configuration\n");
> -               *xbar = AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_DUAL;
> -               return 0;
> +       if (of_device_is_compatible(np, "nvidia,tegra30-pcie")) {
> +               switch (lanes) {
> +               case 0x00000204:
> +                       dev_info(pcie->dev, "4x1, 2x1 configuration\n");
> +                       *xbar = AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_420;
> +                       return 0;
> +
> +               case 0x00020202:
> +                       dev_info(pcie->dev, "2x3 configuration\n");
> +                       *xbar = AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_222;
> +                       return 0;
> +
> +               case 0x00010104:
> +                       dev_info(pcie->dev, "4x1, 1x2 configuration\n");
> +                       *xbar = AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_411;
> +                       return 0;
> +               }
> +       } else if (of_device_is_compatible(np, "nvidia,tegra20-pcie")) {
> +               switch (lanes) {
> +               case 0x00000004:
> +                       dev_info(pcie->dev, "single-mode configuration\n");
> +                       *xbar = AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_SINGLE;
> +                       return 0;
> +
> +               case 0x00000202:
> +                       dev_info(pcie->dev, "dual-mode configuration\n");
> +                       *xbar = AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_DUAL;
> +                       return 0;
> +               }
>         }
>
>         return -EINVAL;
> @@ -1255,6 +1360,7 @@ static int tegra_pcie_get_xbar_config(struct tegra_pcie *pcie, u32 lanes,
>
>  static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
>  {
> +       const struct tegra_pcie_soc_data *soc = pcie->soc_data;
>         struct device_node *np = pcie->dev->of_node, *port;
>         struct of_pci_range_parser parser;
>         struct of_pci_range range;
> @@ -1275,6 +1381,12 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
>         if (IS_ERR(pcie->pex_clk_supply))
>                 return PTR_ERR(pcie->pex_clk_supply);
>
> +       if (soc->has_avdd_supply) {
> +               pcie->avdd_supply = devm_regulator_get(pcie->dev, "avdd");
> +               if (IS_ERR(pcie->avdd_supply))
> +                       return PTR_ERR(pcie->avdd_supply);
> +       }
> +
>         for_each_of_pci_range(&parser, &range) {
>                 of_pci_range_to_resource(&range, np, &res);
>
> @@ -1321,7 +1433,7 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
>
>                 index = PCI_SLOT(err);
>
> -               if (index < 1 || index > TEGRA_MAX_PORTS) {
> +               if (index < 1 || index > soc->num_ports) {
>                         dev_err(pcie->dev, "invalid port number: %d\n", index);
>                         return -EINVAL;
>                 }
> @@ -1459,17 +1571,54 @@ static int tegra_pcie_enable(struct tegra_pcie *pcie)
>         return 0;
>  }
>
> +static const struct tegra_pcie_soc_data tegra20_pcie_data = {
> +       .num_ports = 2,
> +       .msi_base_shift = 0,
> +       .pads_pll_ctl = PADS_PLL_CTL_TEGRA20,
> +       .tx_ref_sel = PADS_PLL_CTL_TXCLKREF_DIV10,
> +       .has_pex_clkreq_en = false,
> +       .has_pex_bias_ctrl = false,
> +       .has_intr_prsnt_sense = false,
> +       .has_avdd_supply = false,
> +       .has_cml_clk = false,
> +};
> +
> +static const struct tegra_pcie_soc_data tegra30_pcie_data = {
> +       .num_ports = 3,
> +       .msi_base_shift = 8,
> +       .pads_pll_ctl = PADS_PLL_CTL_TEGRA30,
> +       .tx_ref_sel = PADS_PLL_CTL_TXCLKREF_BUF_EN,
> +       .has_pex_clkreq_en = true,
> +       .has_pex_bias_ctrl = true,
> +       .has_intr_prsnt_sense = true,
> +       .has_avdd_supply = true,
> +       .has_cml_clk = true,
> +};
> +
> +static const struct of_device_id tegra_pcie_of_match[] = {
> +       { .compatible = "nvidia,tegra30-pcie", .data = &tegra30_pcie_data },
> +       { .compatible = "nvidia,tegra20-pcie", .data = &tegra20_pcie_data },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, tegra_pcie_of_match);
> +
>  static int tegra_pcie_probe(struct platform_device *pdev)
>  {
> +       const struct of_device_id *match;
>         struct tegra_pcie *pcie;
>         int err;
>
> +       match = of_match_device(tegra_pcie_of_match, &pdev->dev);
> +       if (!match)
> +               return -ENODEV;
> +
>         pcie = devm_kzalloc(&pdev->dev, sizeof(*pcie), GFP_KERNEL);
>         if (!pcie)
>                 return -ENOMEM;
>
>         INIT_LIST_HEAD(&pcie->busses);
>         INIT_LIST_HEAD(&pcie->ports);
> +       pcie->soc_data = match->data;
>         pcie->dev = &pdev->dev;
>
>         err = tegra_pcie_parse_dt(pcie);
> @@ -1518,12 +1667,6 @@ put_resources:
>         return err;
>  }
>
> -static const struct of_device_id tegra_pcie_of_match[] = {
> -       { .compatible = "nvidia,tegra20-pcie", },
> -       { },
> -};
> -MODULE_DEVICE_TABLE(of, tegra_pcie_of_match);
> -
>  static struct platform_driver tegra_pcie_driver = {
>         .driver = {
>                 .name = "tegra-pcie",
> --
> 1.8.1.5
>
