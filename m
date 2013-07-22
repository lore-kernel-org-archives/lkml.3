Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3GVPEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:04:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44966 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab3GVPEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:04:11 -0400
Message-ID: <51ED49D6.9050209@ti.com>
Date: Mon, 22 Jul 2013 20:33:50 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Bjorn Helgaas'" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH V3] pci: exynos: split into two parts such as Synopsys
 part and Exynos part
References: <002801ce8376$a807dbf0$f81793d0$@samsung.com>
In-Reply-To: <002801ce8376$a807dbf0$f81793d0$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 18 July 2013 10:51 AM, Jingoo Han wrote:
> Exynos PCIe IP consists of Synopsys specific part and Exynos
> specific part. Only core block is a Synopsys designware part;
> other parts are Exynos specific.
> Also, the Synopsys designware part can be shared with other
> platforms; thus, it can be split two parts such as Synopsys
> designware part and Exynos specific part.

some more queries and comments..
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Pratyush Anand <pratyush.anand@st.com>
> Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
> ---
> Changes since v2:
.
.
<snip>
.
.
> +
> +static struct pcie_host_ops exynos_pcie_host_ops = {
> +	.readl_rc = exynos_pcie_readl_rc,
> +	.writel_rc = exynos_pcie_writel_rc,
> +	.rd_own_conf = exynos_pcie_rd_own_conf,
> +	.wr_own_conf = exynos_pcie_wr_own_conf,
> +	.link_up = exynos_pcie_link_up,
> +	.host_init = exynos_pcie_host_init,
> +};
> +
> +static int add_pcie_port(struct pcie_port *pp, struct platform_device *pdev)
> +{
> +	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);

We can move the exynos_pcie specific initialization to probe and leave only
pcie_port initialization here.
> +	struct resource *elbi_base;
> +	struct resource *phy_base;
> +	struct resource *block_base;
> +	int ret;
> +
> +	elbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!elbi_base) {
> +		dev_err(&pdev->dev, "couldn't get elbi base resource\n");
> +		return -EINVAL;
> +	}
> +	exynos_pcie->elbi_base = devm_ioremap_resource(&pdev->dev, elbi_base);
> +	if (IS_ERR(exynos_pcie->elbi_base))
> +		return PTR_ERR(exynos_pcie->elbi_base);
> +
> +	phy_base = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!phy_base) {
> +		dev_err(&pdev->dev, "couldn't get phy base resource\n");
> +		return -EINVAL;
> +	}
> +	exynos_pcie->phy_base = devm_ioremap_resource(&pdev->dev, phy_base);
> +	if (IS_ERR(exynos_pcie->phy_base))
> +		return PTR_ERR(exynos_pcie->phy_base);
> +
> +	block_base = platform_get_resource(pdev, IORESOURCE_MEM, 2);
> +	if (!block_base) {
> +		dev_err(&pdev->dev, "couldn't get block base resource\n");
> +		return -EINVAL;
> +	}
> +	exynos_pcie->block_base = devm_ioremap_resource(&pdev->dev, block_base);
> +	if (IS_ERR(exynos_pcie->block_base))
> +		return PTR_ERR(exynos_pcie->block_base);

So all this till here can be moved to probe.
> +
> +	pp->irq = platform_get_irq(pdev, 1);
> +	if (!pp->irq) {
> +		dev_err(&pdev->dev, "failed to get irq\n");
> +		return -ENODEV;
> +	}
> +	ret = devm_request_irq(&pdev->dev, pp->irq, exynos_pcie_irq_handler,
> +				IRQF_SHARED, "exynos-pcie", pp);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to request irq\n");
> +		return ret;
> +	}
> +
> +	pp->root_bus_nr = -1;
> +	pp->ops = &exynos_pcie_host_ops;
> +
> +	spin_lock_init(&pp->conf_lock);
> +	ret = dw_pcie_host_init(pp);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to initialize host\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __init exynos_pcie_probe(struct platform_device *pdev)
> +{
> +	struct exynos_pcie *exynos_pcie;
> +	struct pcie_port *pp;
> +	struct device_node *np = pdev->dev.of_node;
> +	int ret;
> +
> +	exynos_pcie = devm_kzalloc(&pdev->dev, sizeof(*exynos_pcie),
> +				GFP_KERNEL);
> +	if (!exynos_pcie) {
> +		dev_err(&pdev->dev, "no memory for exynos pcie\n");
> +		return -ENOMEM;
> +	}
> +
> +	pp = &exynos_pcie->pp;
> +
> +	pp->dev = &pdev->dev;
> +
> +	exynos_pcie->reset_gpio = of_get_named_gpio(np, "reset-gpio", 0);
> +
> +	exynos_pcie->clk = devm_clk_get(&pdev->dev, "pcie");
> +	if (IS_ERR(exynos_pcie->clk)) {
> +		dev_err(&pdev->dev, "Failed to get pcie rc clock\n");
> +		return PTR_ERR(exynos_pcie->clk);
> +	}
> +	ret = clk_prepare_enable(exynos_pcie->clk);
> +	if (ret)
> +		return ret;
> +
> +	exynos_pcie->bus_clk = devm_clk_get(&pdev->dev, "pcie_bus");
> +	if (IS_ERR(exynos_pcie->bus_clk)) {
> +		dev_err(&pdev->dev, "Failed to get pcie bus clock\n");
> +		ret = PTR_ERR(exynos_pcie->bus_clk);
> +		goto fail_clk;
> +	}
> +	ret = clk_prepare_enable(exynos_pcie->bus_clk);
> +	if (ret)
> +		goto fail_clk;
> +
> +	ret = add_pcie_port(pp, pdev);
> +	if (ret < 0)
> +		goto fail_bus_clk;

I think we should move all the below code to designware core file. IMO it
should be common everyone who use designware core.
> +
> +	dw_pci.nr_controllers = 1;
> +	dw_pci.private_data = (void **)&pp;
> +
> +	pci_common_init(&dw_pci);
> +	pci_assign_unassigned_resources();
> +#ifdef CONFIG_PCI_DOMAINS
> +	dw_pci.domain++;
> +#endif
> +
> +	platform_set_drvdata(pdev, exynos_pcie);
> +	return 0;
> +
> +fail_bus_clk:
> +	clk_disable_unprepare(exynos_pcie->bus_clk);
> +fail_clk:
> +	clk_disable_unprepare(exynos_pcie->clk);
> +	return ret;
> +}
> +
> +static int __exit exynos_pcie_remove(struct platform_device *pdev)
> +{
> +	struct exynos_pcie *exynos_pcie = platform_get_drvdata(pdev);
> +
> +	clk_disable_unprepare(exynos_pcie->bus_clk);
> +	clk_disable_unprepare(exynos_pcie->clk);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id exynos_pcie_of_match[] = {
> +	{ .compatible = "samsung,exynos5440-pcie", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_pcie_of_match);
> +
> +static struct platform_driver exynos_pcie_driver = {
> +	.remove		= __exit_p(exynos_pcie_remove),
> +	.driver = {
> +		.name	= "exynos-pcie",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(exynos_pcie_of_match),
> +	},
> +};
> +
> +/* Exynos PCIe driver does not allow module unload */
> +
> +static int __init pcie_init(void)
> +{
> +	return platform_driver_probe(&exynos_pcie_driver, exynos_pcie_probe);
> +}
> +subsys_initcall(pcie_init);
> +
> +MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
> +MODULE_DESCRIPTION("Samsung PCIe host controller driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index 26bdbda..f097eff 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -1,5 +1,5 @@
>  /*
> - * PCIe host controller driver for Samsung EXYNOS SoCs
> + * Synopsys Designware PCIe host controller driver
>   *
>   * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>   *		http://www.samsung.com
> @@ -11,74 +11,28 @@
>   * published by the Free Software Foundation.
>   */
>  
> -#include <linux/clk.h>
> -#include <linux/delay.h>
> -#include <linux/gpio.h>
> -#include <linux/interrupt.h>
>  #include <linux/kernel.h>
> -#include <linux/list.h>
>  #include <linux/module.h>
> -#include <linux/of.h>
>  #include <linux/of_address.h>
> -#include <linux/of_gpio.h>
> -#include <linux/of_pci.h>
>  #include <linux/pci.h>
>  #include <linux/pci_regs.h>
> -#include <linux/platform_device.h>
> -#include <linux/resource.h>
> -#include <linux/signal.h>
> -#include <linux/slab.h>
>  #include <linux/types.h>
>  
> -struct pcie_port_info {
> -	u32		cfg0_size;
> -	u32		cfg1_size;
> -	u32		io_size;
> -	u32		mem_size;
> -	phys_addr_t	io_bus_addr;
> -	phys_addr_t	mem_bus_addr;
> -};
> -
> -struct pcie_port {
> -	struct device		*dev;
> -	u8			controller;
> -	u8			root_bus_nr;
> -	void __iomem		*dbi_base;
> -	void __iomem		*elbi_base;
> -	void __iomem		*phy_base;
> -	void __iomem		*purple_base;
> -	u64			cfg0_base;
> -	void __iomem		*va_cfg0_base;
> -	u64			cfg1_base;
> -	void __iomem		*va_cfg1_base;
> -	u64			io_base;
> -	u64			mem_base;
> -	spinlock_t		conf_lock;
> -	struct resource		cfg;
> -	struct resource		io;
> -	struct resource		mem;
> -	struct pcie_port_info	config;
> -	struct clk		*clk;
> -	struct clk		*bus_clk;
> -	int			irq;
> -	int			reset_gpio;
> -};
> -
> -/*
> - * Exynos PCIe IP consists of Synopsys specific part and Exynos
> - * specific part. Only core block is a Synopsys designware part;
> - * other parts are Exynos specific.
> - */
> +#include "pcie-designware.h"
>  
>  /* Synopsis specific PCIE configuration registers */
>  #define PCIE_PORT_LINK_CONTROL		0x710
>  #define PORT_LINK_MODE_MASK		(0x3f << 16)
> +#define PORT_LINK_MODE_1_LANES		(0x1 << 16)
> +#define PORT_LINK_MODE_2_LANES		(0x3 << 16)
>  #define PORT_LINK_MODE_4_LANES		(0x7 << 16)
>  
>  #define PCIE_LINK_WIDTH_SPEED_CONTROL	0x80C
>  #define PORT_LOGIC_SPEED_CHANGE		(0x1 << 17)
>  #define PORT_LOGIC_LINK_WIDTH_MASK	(0x1ff << 8)
> -#define PORT_LOGIC_LINK_WIDTH_4_LANES	(0x7 << 8)
> +#define PORT_LOGIC_LINK_WIDTH_1_LANES	(0x1 << 8)
> +#define PORT_LOGIC_LINK_WIDTH_2_LANES	(0x2 << 8)
> +#define PORT_LOGIC_LINK_WIDTH_4_LANES	(0x4 << 8)
>  
>  #define PCIE_MSI_ADDR_LO		0x820
>  #define PCIE_MSI_ADDR_HI		0x824
> @@ -108,69 +62,14 @@ struct pcie_port {
>  #define PCIE_ATU_FUNC(x)		(((x) & 0x7) << 16)
>  #define PCIE_ATU_UPPER_TARGET		0x91C
>  
> -/* Exynos specific PCIE configuration registers */
> -
> -/* PCIe ELBI registers */
> -#define PCIE_IRQ_PULSE			0x000
> -#define IRQ_INTA_ASSERT			(0x1 << 0)
> -#define IRQ_INTB_ASSERT			(0x1 << 2)
> -#define IRQ_INTC_ASSERT			(0x1 << 4)
> -#define IRQ_INTD_ASSERT			(0x1 << 6)
> -#define PCIE_IRQ_LEVEL			0x004
> -#define PCIE_IRQ_SPECIAL		0x008
> -#define PCIE_IRQ_EN_PULSE		0x00c
> -#define PCIE_IRQ_EN_LEVEL		0x010
> -#define PCIE_IRQ_EN_SPECIAL		0x014
> -#define PCIE_PWR_RESET			0x018
> -#define PCIE_CORE_RESET			0x01c
> -#define PCIE_CORE_RESET_ENABLE		(0x1 << 0)
> -#define PCIE_STICKY_RESET		0x020
> -#define PCIE_NONSTICKY_RESET		0x024
> -#define PCIE_APP_INIT_RESET		0x028
> -#define PCIE_APP_LTSSM_ENABLE		0x02c
> -#define PCIE_ELBI_RDLH_LINKUP		0x064
> -#define PCIE_ELBI_LTSSM_ENABLE		0x1
> -#define PCIE_ELBI_SLV_AWMISC		0x11c
> -#define PCIE_ELBI_SLV_ARMISC		0x120
> -#define PCIE_ELBI_SLV_DBI_ENABLE	(0x1 << 21)
> -
> -/* PCIe Purple registers */
> -#define PCIE_PHY_GLOBAL_RESET		0x000
> -#define PCIE_PHY_COMMON_RESET		0x004
> -#define PCIE_PHY_CMN_REG		0x008
> -#define PCIE_PHY_MAC_RESET		0x00c
> -#define PCIE_PHY_PLL_LOCKED		0x010
> -#define PCIE_PHY_TRSVREG_RESET		0x020
> -#define PCIE_PHY_TRSV_RESET		0x024
> -
> -/* PCIe PHY registers */
> -#define PCIE_PHY_IMPEDANCE		0x004
> -#define PCIE_PHY_PLL_DIV_0		0x008
> -#define PCIE_PHY_PLL_BIAS		0x00c
> -#define PCIE_PHY_DCC_FEEDBACK		0x014
> -#define PCIE_PHY_PLL_DIV_1		0x05c
> -#define PCIE_PHY_TRSV0_EMP_LVL		0x084
> -#define PCIE_PHY_TRSV0_DRV_LVL		0x088
> -#define PCIE_PHY_TRSV0_RXCDR		0x0ac
> -#define PCIE_PHY_TRSV0_LVCC		0x0dc
> -#define PCIE_PHY_TRSV1_EMP_LVL		0x144
> -#define PCIE_PHY_TRSV1_RXCDR		0x16c
> -#define PCIE_PHY_TRSV1_LVCC		0x19c
> -#define PCIE_PHY_TRSV2_EMP_LVL		0x204
> -#define PCIE_PHY_TRSV2_RXCDR		0x22c
> -#define PCIE_PHY_TRSV2_LVCC		0x25c
> -#define PCIE_PHY_TRSV3_EMP_LVL		0x2c4
> -#define PCIE_PHY_TRSV3_RXCDR		0x2ec
> -#define PCIE_PHY_TRSV3_LVCC		0x31c
> -
> -static struct hw_pci exynos_pci;
> +unsigned long global_io_offset;
>  
>  static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys)
>  {
>  	return sys->private_data;
>  }
>  
> -static inline int cfg_read(void *addr, int where, int size, u32 *val)
> +int cfg_read(void *addr, int where, int size, u32 *val)
>  {
>  	*val = readl(addr);
>  
> @@ -184,7 +83,7 @@ static inline int cfg_read(void *addr, int where, int size, u32 *val)
>  	return PCIBIOS_SUCCESSFUL;
>  }
>  
> -static inline int cfg_write(void *addr, int where, int size, u32 val)
> +int cfg_write(void *addr, int where, int size, u32 val)
>  {
>  	if (size == 4)
>  		writel(val, addr);
> @@ -198,155 +97,230 @@ static inline int cfg_write(void *addr, int where, int size, u32 val)
>  	return PCIBIOS_SUCCESSFUL;
>  }
>  
> -static void exynos_pcie_sideband_dbi_w_mode(struct pcie_port *pp, bool on)
> -{
> -	u32 val;
> -
> -	if (on) {
> -		val = readl(pp->elbi_base + PCIE_ELBI_SLV_AWMISC);
> -		val |= PCIE_ELBI_SLV_DBI_ENABLE;
> -		writel(val, pp->elbi_base + PCIE_ELBI_SLV_AWMISC);
> -	} else {
> -		val = readl(pp->elbi_base + PCIE_ELBI_SLV_AWMISC);
> -		val &= ~PCIE_ELBI_SLV_DBI_ENABLE;
> -		writel(val, pp->elbi_base + PCIE_ELBI_SLV_AWMISC);
> -	}
> -}
> -
> -static void exynos_pcie_sideband_dbi_r_mode(struct pcie_port *pp, bool on)
> +static inline void dw_pcie_readl_rc(struct pcie_port *pp,
> +				void __iomem *dbi_addr, u32 *val)
>  {
> -	u32 val;
> -
> -	if (on) {
> -		val = readl(pp->elbi_base + PCIE_ELBI_SLV_ARMISC);
> -		val |= PCIE_ELBI_SLV_DBI_ENABLE;
> -		writel(val, pp->elbi_base + PCIE_ELBI_SLV_ARMISC);
> -	} else {
> -		val = readl(pp->elbi_base + PCIE_ELBI_SLV_ARMISC);
> -		val &= ~PCIE_ELBI_SLV_DBI_ENABLE;
> -		writel(val, pp->elbi_base + PCIE_ELBI_SLV_ARMISC);
> -	}
> -}
> -
> -static inline void readl_rc(struct pcie_port *pp, void *dbi_base, u32 *val)
> -{
> -	exynos_pcie_sideband_dbi_r_mode(pp, true);
> -	*val = readl(dbi_base);
> -	exynos_pcie_sideband_dbi_r_mode(pp, false);
> -	return;
> +	if (pp->ops->readl_rc)
> +		pp->ops->readl_rc(pp, dbi_addr, val);
> +	else
> +		*val = readl(dbi_addr);
>  }
>  
> -static inline void writel_rc(struct pcie_port *pp, u32 val, void *dbi_base)
> +static inline void dw_pcie_writel_rc(struct pcie_port *pp,
> +				u32 val, void __iomem *dbi_addr)
>  {
> -	exynos_pcie_sideband_dbi_w_mode(pp, true);
> -	writel(val, dbi_base);
> -	exynos_pcie_sideband_dbi_w_mode(pp, false);
> -	return;
> +	if (pp->ops->writel_rc)
> +		pp->ops->writel_rc(pp, val, dbi_addr);
> +	else
> +		writel(val, dbi_addr);
>  }
>  
> -static int exynos_pcie_rd_own_conf(struct pcie_port *pp, int where, int size,
> +int dw_pcie_rd_own_conf(struct pcie_port *pp, int where, int size,
>  				u32 *val)
>  {
>  	int ret;
>  
> -	exynos_pcie_sideband_dbi_r_mode(pp, true);
> -	ret = cfg_read(pp->dbi_base + (where & ~0x3), where, size, val);
> -	exynos_pcie_sideband_dbi_r_mode(pp, false);
> +	if (pp->ops->rd_own_conf)
> +		ret = pp->ops->rd_own_conf(pp, where, size, val);
> +	else
> +		ret = cfg_read(pp->dbi_base + (where & ~0x3), where, size, val);
> +
>  	return ret;
>  }
>  
> -static int exynos_pcie_wr_own_conf(struct pcie_port *pp, int where, int size,
> +int dw_pcie_wr_own_conf(struct pcie_port *pp, int where, int size,
>  				u32 val)
>  {
>  	int ret;
>  
> -	exynos_pcie_sideband_dbi_w_mode(pp, true);
> -	ret = cfg_write(pp->dbi_base + (where & ~0x3), where, size, val);
> -	exynos_pcie_sideband_dbi_w_mode(pp, false);
> +	if (pp->ops->wr_own_conf)
> +		ret = pp->ops->wr_own_conf(pp, where, size, val);
> +	else
> +		ret = cfg_write(pp->dbi_base + (where & ~0x3), where, size,
> +				val);
> +
>  	return ret;
>  }
>  
> -static void exynos_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
> +int dw_pcie_link_up(struct pcie_port *pp)
> +{
> +	if (pp->ops->link_up)
> +		return pp->ops->link_up(pp);
> +	else
> +		return 0;
> +}
> +
> +int dw_pcie_host_init(struct pcie_port *pp)
> +{
> +	struct device_node *np = pp->dev->of_node;
> +	struct of_pci_range range;
> +	struct of_pci_range_parser parser;
> +	u32 val;
> +
> +	if (of_pci_range_parser_init(&parser, np)) {
> +		dev_err(pp->dev, "missing ranges property\n");
> +		return -EINVAL;
> +	}

I have some confusion here w.r.t address space :-s
> +
> +	/* Get the I/O and memory ranges from DT */
> +	for_each_of_pci_range(&parser, &range) {
> +		unsigned long restype = range.flags & IORESOURCE_TYPE_BITS;
> +		if (restype == IORESOURCE_IO) {
> +			of_pci_range_to_resource(&range, np, &pp->io);
> +			pp->io.name = "I/O";
> +			pp->io.start = max_t(resource_size_t,
> +					     PCIBIOS_MIN_IO,
> +					     range.pci_addr + global_io_offset);
> +			pp->io.end = min_t(resource_size_t,
> +					   IO_SPACE_LIMIT,
> +					   range.pci_addr + range.size
> +					   + global_io_offset);
> +			pp->config.io_size = resource_size(&pp->io);
> +			pp->config.io_bus_addr = range.pci_addr;
> +		}
> +		if (restype == IORESOURCE_MEM) {
> +			of_pci_range_to_resource(&range, np, &pp->mem);
> +			pp->mem.name = "MEM";
> +			pp->config.mem_size = resource_size(&pp->mem);
> +			pp->config.mem_bus_addr = range.pci_addr;
> +		}
> +		if (restype == 0) {
> +			of_pci_range_to_resource(&range, np, &pp->cfg);
> +			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
> +			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
> +		}
> +	}
> +
> +	pp->dbi_base = devm_ioremap(pp->dev, pp->cfg.start,
> +				resource_size(&pp->cfg));

Why is configuraion space divided into two? Why should it be same as dbi_base?
AFAIK, jacinto6 has a dedicated configuration/io/memory space that is entirely
different from dbi_base.

Thanks
Kishon
