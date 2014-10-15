Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaJOHfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:35:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:52032 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaJOHfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:35:34 -0400
Message-ID: <1413358507.4748.4.camel@pasglop>
Subject: Re: of/pci: Fix the conversion of IO ranges into IO resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Michael Ellerman <michaele@au1.ibm.com>
Date: Wed, 15 Oct 2014 18:35:07 +1100
In-Reply-To: <20141009200235.55E5166107E@gitolite.kernel.org>
References: <20141009200235.55E5166107E@gitolite.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-09 at 20:02 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=0b0b0893d49b34201a6c4416b1a707b580b91e3d
> Commit:     0b0b0893d49b34201a6c4416b1a707b580b91e3d
> Parent:     83bbde1cc0ec9d156b9271e29ffe0dc89c687feb
> Refname:    refs/heads/master
> Author:     Liviu Dudau <Liviu.Dudau@arm.com>
> AuthorDate: Mon Sep 29 15:29:25 2014 +0100
> Committer:  Bjorn Helgaas <bhelgaas@google.com>
> CommitDate: Tue Sep 30 17:08:40 2014 -0600
> 
>     of/pci: Fix the conversion of IO ranges into IO resources
>     
>     The ranges property for a host bridge controller in DT describes the
>     mapping between the PCI bus address and the CPU physical address.  The
>     resources framework however expects that the IO resources start at a pseudo
>     "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.  The
>     conversion from PCI ranges to resources failed to take that into account,
>     returning a CPU physical address instead of a port number.
>     
>     Also fix all the drivers that depend on the old behaviour by fetching the
>     CPU physical address based on the port number where it is being needed.

Michael just signaled me that this completely breaks IO space on powerpc ...

I hadn't paid enough attention it seems... looking at that and the
previous patches in the series, I must sate I absolutely HATE the way it
lazily allocates IO space addresses implicitly/lazily from what looks
like a conversion function.

It also doesn't work. The powerpc arch has very different and well
defined conversions to IO space which may or may not look like something
allocated from a magical "IO port 0".

It is somewhat like that on ppc64 but we have our own allocator which is
completely out of sync here as far as I can tell, and on ppc32, we have
something a *bit* like that but we allow full pointer arithmetic for IO
ports so that they can be negative in case the physical address of the
resource ends up below IO BASE.

In any case, this whole approach looks terminally broken to us, and in
fact doesn't even look that nice for ARM, I would having a much clearer
API to explicitly establish the relationship between IO ports PCI vs.
physical addresses separate from the conversion functions.

For now I'm not sure how to fix it without asking Linus to revert the
whole lot.... I don't have time to dive and untangle that whole series,
maybe Michael can tomorrow, otherwise I'll need you guys to help, or a
revert.

Cheers,
Ben.


>     Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     Acked-by: Linus Walleij <linus.walleij@linaro.org>
>     CC: Grant Likely <grant.likely@linaro.org>
>     CC: Rob Herring <robh+dt@kernel.org>
>     CC: Arnd Bergmann <arnd@arndb.de>
>     CC: Thierry Reding <thierry.reding@gmail.com>
>     CC: Simon Horman <horms@verge.net.au>
>     CC: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm/mach-integrator/pci_v3.c | 23 ++++++++++----------
>  drivers/of/address.c              | 44 +++++++++++++++++++++++++++++++++++----
>  drivers/pci/host/pci-tegra.c      | 10 ++++++---
>  drivers/pci/host/pcie-rcar.c      | 21 +++++++++++++------
>  include/linux/of_address.h        | 12 +++++------
>  5 files changed, 80 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
> index 05e1f73..c186a17 100644
> --- a/arch/arm/mach-integrator/pci_v3.c
> +++ b/arch/arm/mach-integrator/pci_v3.c
> @@ -660,6 +660,7 @@ static void __init pci_v3_preinit(void)
>  {
>  	unsigned long flags;
>  	unsigned int temp;
> +	phys_addr_t io_address = pci_pio_to_address(io_mem.start);
>  
>  	pcibios_min_mem = 0x00100000;
>  
> @@ -701,7 +702,7 @@ static void __init pci_v3_preinit(void)
>  	/*
>  	 * Setup window 2 - PCI IO
>  	 */
> -	v3_writel(V3_LB_BASE2, v3_addr_to_lb_base2(io_mem.start) |
> +	v3_writel(V3_LB_BASE2, v3_addr_to_lb_base2(io_address) |
>  			V3_LB_BASE_ENABLE);
>  	v3_writew(V3_LB_MAP2, v3_addr_to_lb_map2(0));
>  
> @@ -742,6 +743,7 @@ static void __init pci_v3_preinit(void)
>  static void __init pci_v3_postinit(void)
>  {
>  	unsigned int pci_cmd;
> +	phys_addr_t io_address = pci_pio_to_address(io_mem.start);
>  
>  	pci_cmd = PCI_COMMAND_MEMORY |
>  		  PCI_COMMAND_MASTER | PCI_COMMAND_INVALIDATE;
> @@ -758,7 +760,7 @@ static void __init pci_v3_postinit(void)
>  		       "interrupt: %d\n", ret);
>  #endif
>  
> -	register_isa_ports(non_mem.start, io_mem.start, 0);
> +	register_isa_ports(non_mem.start, io_address, 0);
>  }
>  
>  /*
> @@ -867,33 +869,32 @@ static int __init pci_v3_probe(struct platform_device *pdev)
>  
>  	for_each_of_pci_range(&parser, &range) {
>  		if (!range.flags) {
> -			of_pci_range_to_resource(&range, np, &conf_mem);
> +			ret = of_pci_range_to_resource(&range, np, &conf_mem);
>  			conf_mem.name = "PCIv3 config";
>  		}
>  		if (range.flags & IORESOURCE_IO) {
> -			of_pci_range_to_resource(&range, np, &io_mem);
> +			ret = of_pci_range_to_resource(&range, np, &io_mem);
>  			io_mem.name = "PCIv3 I/O";
>  		}
>  		if ((range.flags & IORESOURCE_MEM) &&
>  			!(range.flags & IORESOURCE_PREFETCH)) {
>  			non_mem_pci = range.pci_addr;
>  			non_mem_pci_sz = range.size;
> -			of_pci_range_to_resource(&range, np, &non_mem);
> +			ret = of_pci_range_to_resource(&range, np, &non_mem);
>  			non_mem.name = "PCIv3 non-prefetched mem";
>  		}
>  		if ((range.flags & IORESOURCE_MEM) &&
>  			(range.flags & IORESOURCE_PREFETCH)) {
>  			pre_mem_pci = range.pci_addr;
>  			pre_mem_pci_sz = range.size;
> -			of_pci_range_to_resource(&range, np, &pre_mem);
> +			ret = of_pci_range_to_resource(&range, np, &pre_mem);
>  			pre_mem.name = "PCIv3 prefetched mem";
>  		}
> -	}
>  
> -	if (!conf_mem.start || !io_mem.start ||
> -	    !non_mem.start || !pre_mem.start) {
> -		dev_err(&pdev->dev, "missing ranges in device node\n");
> -		return -EINVAL;
> +		if (ret < 0) {
> +			dev_err(&pdev->dev, "missing ranges in device node\n");
> +			return ret;
> +		}
>  	}
>  
>  	pci_v3.map_irq = of_irq_parse_and_map_pci;
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index 327a574..afdb782 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -295,14 +295,50 @@ struct of_pci_range *of_pci_range_parser_one(struct of_pci_range_parser *parser,
>  }
>  EXPORT_SYMBOL_GPL(of_pci_range_parser_one);
>  
> -void of_pci_range_to_resource(struct of_pci_range *range,
> -			      struct device_node *np, struct resource *res)
> +/*
> + * of_pci_range_to_resource - Create a resource from an of_pci_range
> + * @range:	the PCI range that describes the resource
> + * @np:		device node where the range belongs to
> + * @res:	pointer to a valid resource that will be updated to
> + *              reflect the values contained in the range.
> + *
> + * Returns EINVAL if the range cannot be converted to resource.
> + *
> + * Note that if the range is an IO range, the resource will be converted
> + * using pci_address_to_pio() which can fail if it is called too early or
> + * if the range cannot be matched to any host bridge IO space (our case here).
> + * To guard against that we try to register the IO range first.
> + * If that fails we know that pci_address_to_pio() will do too.
> + */
> +int of_pci_range_to_resource(struct of_pci_range *range,
> +			     struct device_node *np, struct resource *res)
>  {
> +	int err;
>  	res->flags = range->flags;
> -	res->start = range->cpu_addr;
> -	res->end = range->cpu_addr + range->size - 1;
>  	res->parent = res->child = res->sibling = NULL;
>  	res->name = np->full_name;
> +
> +	if (res->flags & IORESOURCE_IO) {
> +		unsigned long port;
> +		err = pci_register_io_range(range->cpu_addr, range->size);
> +		if (err)
> +			goto invalid_range;
> +		port = pci_address_to_pio(range->cpu_addr);
> +		if (port == (unsigned long)-1) {
> +			err = -EINVAL;
> +			goto invalid_range;
> +		}
> +		res->start = port;
> +	} else {
> +		res->start = range->cpu_addr;
> +	}
> +	res->end = res->start + range->size - 1;
> +	return 0;
> +
> +invalid_range:
> +	res->start = (resource_size_t)OF_BAD_ADDR;
> +	res->end = (resource_size_t)OF_BAD_ADDR;
> +	return err;
>  }
>  #endif /* CONFIG_PCI */
>  
> diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
> index 0fb0fdb..946935d 100644
> --- a/drivers/pci/host/pci-tegra.c
> +++ b/drivers/pci/host/pci-tegra.c
> @@ -626,13 +626,14 @@ DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, tegra_pcie_relax_enable);
>  static int tegra_pcie_setup(int nr, struct pci_sys_data *sys)
>  {
>  	struct tegra_pcie *pcie = sys_to_pcie(sys);
> +	phys_addr_t io_start = pci_pio_to_address(pcie->io.start);
>  
>  	pci_add_resource_offset(&sys->resources, &pcie->mem, sys->mem_offset);
>  	pci_add_resource_offset(&sys->resources, &pcie->prefetch,
>  				sys->mem_offset);
>  	pci_add_resource(&sys->resources, &pcie->busn);
>  
> -	pci_ioremap_io(nr * SZ_64K, pcie->io.start);
> +	pci_ioremap_io(nr * SZ_64K, io_start);
>  
>  	return 1;
>  }
> @@ -737,6 +738,7 @@ static irqreturn_t tegra_pcie_isr(int irq, void *arg)
>  static void tegra_pcie_setup_translations(struct tegra_pcie *pcie)
>  {
>  	u32 fpci_bar, size, axi_address;
> +	phys_addr_t io_start = pci_pio_to_address(pcie->io.start);
>  
>  	/* Bar 0: type 1 extended configuration space */
>  	fpci_bar = 0xfe100000;
> @@ -749,7 +751,7 @@ static void tegra_pcie_setup_translations(struct tegra_pcie *pcie)
>  	/* Bar 1: downstream IO bar */
>  	fpci_bar = 0xfdfc0000;
>  	size = resource_size(&pcie->io);
> -	axi_address = pcie->io.start;
> +	axi_address = io_start;
>  	afi_writel(pcie, axi_address, AFI_AXI_BAR1_START);
>  	afi_writel(pcie, size >> 12, AFI_AXI_BAR1_SZ);
>  	afi_writel(pcie, fpci_bar, AFI_FPCI_BAR1);
> @@ -1520,7 +1522,9 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
>  	}
>  
>  	for_each_of_pci_range(&parser, &range) {
> -		of_pci_range_to_resource(&range, np, &res);
> +		err = of_pci_range_to_resource(&range, np, &res);
> +		if (err < 0)
> +			return err;
>  
>  		switch (res.flags & IORESOURCE_TYPE_BITS) {
>  		case IORESOURCE_IO:
> diff --git a/drivers/pci/host/pcie-rcar.c b/drivers/pci/host/pcie-rcar.c
> index 4884ee5..61158e0 100644
> --- a/drivers/pci/host/pcie-rcar.c
> +++ b/drivers/pci/host/pcie-rcar.c
> @@ -323,6 +323,7 @@ static void rcar_pcie_setup_window(int win, struct rcar_pcie *pcie)
>  
>  	/* Setup PCIe address space mappings for each resource */
>  	resource_size_t size;
> +	resource_size_t res_start;
>  	u32 mask;
>  
>  	rcar_pci_write_reg(pcie, 0x00000000, PCIEPTCTLR(win));
> @@ -335,8 +336,13 @@ static void rcar_pcie_setup_window(int win, struct rcar_pcie *pcie)
>  	mask = (roundup_pow_of_two(size) / SZ_128) - 1;
>  	rcar_pci_write_reg(pcie, mask << 7, PCIEPAMR(win));
>  
> -	rcar_pci_write_reg(pcie, upper_32_bits(res->start), PCIEPARH(win));
> -	rcar_pci_write_reg(pcie, lower_32_bits(res->start), PCIEPARL(win));
> +	if (res->flags & IORESOURCE_IO)
> +		res_start = pci_pio_to_address(res->start);
> +	else
> +		res_start = res->start;
> +
> +	rcar_pci_write_reg(pcie, upper_32_bits(res_start), PCIEPARH(win));
> +	rcar_pci_write_reg(pcie, lower_32_bits(res_start), PCIEPARL(win));
>  
>  	/* First resource is for IO */
>  	mask = PAR_ENABLE;
> @@ -363,9 +369,10 @@ static int rcar_pcie_setup(int nr, struct pci_sys_data *sys)
>  
>  		rcar_pcie_setup_window(i, pcie);
>  
> -		if (res->flags & IORESOURCE_IO)
> -			pci_ioremap_io(nr * SZ_64K, res->start);
> -		else
> +		if (res->flags & IORESOURCE_IO) {
> +			phys_addr_t io_start = pci_pio_to_address(res->start);
> +			pci_ioremap_io(nr * SZ_64K, io_start);
> +		} else
>  			pci_add_resource(&sys->resources, res);
>  	}
>  	pci_add_resource(&sys->resources, &pcie->busn);
> @@ -935,8 +942,10 @@ static int rcar_pcie_probe(struct platform_device *pdev)
>  	}
>  
>  	for_each_of_pci_range(&parser, &range) {
> -		of_pci_range_to_resource(&range, pdev->dev.of_node,
> +		err = of_pci_range_to_resource(&range, pdev->dev.of_node,
>  						&pcie->res[win++]);
> +		if (err < 0)
> +			return err;
>  
>  		if (win > RCAR_PCI_MAX_RESOURCES)
>  			break;
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index a38e1c8..8cb14eb 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -134,9 +134,9 @@ extern const __be32 *of_get_pci_address(struct device_node *dev, int bar_no,
>  			       u64 *size, unsigned int *flags);
>  extern int of_pci_address_to_resource(struct device_node *dev, int bar,
>  				      struct resource *r);
> -extern void of_pci_range_to_resource(struct of_pci_range *range,
> -				     struct device_node *np,
> -				     struct resource *res);
> +extern int of_pci_range_to_resource(struct of_pci_range *range,
> +				    struct device_node *np,
> +				    struct resource *res);
>  #else /* CONFIG_OF_ADDRESS && CONFIG_PCI */
>  static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
>  				             struct resource *r)
> @@ -149,9 +149,9 @@ static inline const __be32 *of_get_pci_address(struct device_node *dev,
>  {
>  	return NULL;
>  }
> -static inline void of_pci_range_to_resource(struct of_pci_range *range,
> -					    struct device_node *np,
> -					    struct resource *res)
> +static inline int of_pci_range_to_resource(struct of_pci_range *range,
> +					   struct device_node *np,
> +					   struct resource *res)
>  {
>  	return -ENOSYS;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


