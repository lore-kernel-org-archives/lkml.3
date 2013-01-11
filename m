Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab3AKAsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 19:48:53 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39905 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3AKAsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 19:48:51 -0500
Message-ID: <50EF616E.7040609@wwwdotorg.org>
Date: Thu, 10 Jan 2013 17:48:46 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <1357764194-12677-11-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1357764194-12677-11-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 01:43 PM, Thierry Reding wrote:
> Move the PCIe driver from arch/arm/mach-tegra into the drivers/pci/host
> directory. The motivation is to collect various host controller drivers
> in the same location in order to facilitate refactoring.
> 
> The Tegra PCIe driver has been largely rewritten, both in order to turn
> it into a proper platform driver and to add MSI (based on code by
> Krishna Kishore <kthota@nvidia.com>) as well as device tree support.

> diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c

>  static void __init trimslice_init(void)
>  {
>  #ifdef CONFIG_TEGRA_PCI
> -	int ret;
> -
> -	ret = tegra_pcie_init(true, true);
> -	if (ret)
> -		pr_err("tegra_pci_init() failed: %d\n", ret);
> +	platform_device_register(&tegra_pcie_device);

That struct doesn't actually exist anywhere; only an extern definition
is added (and that extern definition isn't removed by patch 14 either).

> diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig

> +config PCI_TEGRA
> +	bool "NVIDIA Tegra PCIe controller"
> +	depends on ARCH_TEGRA_2x_SOC

Perhaps depend on ARCH_TEGRA; that will save churn once this is ported
to Tegra30, and shouldn't cause any problems before then.

> diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c

> +#define AFI_INTR_CODE		0xb8
> +#define  AFI_INTR_CODE_MASK	0xf
> +#define  AFI_INTR_MASTER_ABORT	4
> +#define  AFI_INTR_LEGACY	6

Adding defines for at least some other codes here, would help further
below ...

> +static irqreturn_t tegra_pcie_isr(int irq, void *arg)

> +	if (code == AFI_INTR_MASTER_ABORT) {
> +		dev_dbg(pcie->dev, "%s, signature: %08x\n", err_msg[code],
> +			signature);
> +	} else
> +		dev_err(pcie->dev, "%s, signature: %08x\n", err_msg[code],
> +			signature);
> +
> +	if (code == 3 || code == 4 || code == 7) {

... i.e. here.

> +		u32 fpci = afi_readl(pcie, AFI_UPPER_FPCI_ADDRESS) & 0xff;
> +		u64 address = (u64)fpci << 32 | (signature & 0xfffffffc);
> +		dev_dbg(pcie->dev, "  FPCI address: %10llx\n", address);

I'd suggest making that dev_err(), or at least something higher than
debug, since the message indicating the error happened is dev_err(), so
the complete details may as well be available since they're small.

> +static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
> +{
> +	unsigned int timeout;
> +	unsigned long value;
> +
> +	/* enable dual controller and both ports */
> +	value = afi_readl(pcie, AFI_PCIE_CONFIG);
> +	value &= ~(AFI_PCIE_CONFIG_PCIEC0_DISABLE_DEVICE |
> +		   AFI_PCIE_CONFIG_PCIEC1_DISABLE_DEVICE |
> +		   AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_MASK);
> +	value |= AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_DUAL;
> +	afi_writel(pcie, value, AFI_PCIE_CONFIG);

Eventually, we should probably derive the port enables from the state of
the root port DT nodes, so that we can disable some and presumably save
a little power. Also, I notice that the nvidia,num-lanes property isn't
implemented yet. Still, we can probably take care of this later.

> +static void tegra_pcie_power_off(struct tegra_pcie *pcie)

> +	if (!IS_ERR_OR_NULL(pcie->pex_clk_supply)) {

Hmm. I think we should make supplies mandatory; it doesn't make sense
for regulator support to be disabled on Tegra, and where a specific
board doesn't actually have a regulator, you're supposed to provide a
dummy fixed regulator so the driver doesn't have to care.

The same comment obviously applies to tegra_pcie_power_on() and wherever
regulator_get() happens.

> +static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)

> +	pcie->vdd_supply = devm_regulator_get(pcie->dev, "vdd");
> +	if (IS_ERR(pcie->vdd_supply))
> +		return PTR_ERR(pcie->vdd_supply);
> +
> +	pcie->pex_clk_supply = devm_regulator_get(pcie->dev, "pex-clk");
> +	if (IS_ERR(pcie->pex_clk_supply))
> +		return PTR_ERR(pcie->pex_clk_supply);

Oh, I guess the regulator_get() calls are already strict.

> +static int tegra_pcie_add_port(struct tegra_pcie *pcie, struct device_node *np)

> +	port = devm_kzalloc(pcie->dev, sizeof(*port), GFP_KERNEL);
> +	if (!port)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&port->list);
> +	port->index = index;
> +	port->pcie = pcie;
> +
> +	port->base = devm_request_and_ioremap(pcie->dev, &regs);
> +	if (!port->base)
> +		return -EADDRNOTAVAIL;
> +
> +	if (!tegra_pcie_port_check_link(port)) {
> +		dev_info(pcie->dev, "link %u down, ignoring\n", port->index);

Perhaps devm_kfree(port)? Not a big leak, but equally if you don't, it's
an unreferenced memory block.

> +		return -ENODEV;
> +	}
> +
> +	list_add_tail(&port->list, &pcie->ports);
> +
> +	return 0;
> +}
