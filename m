Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbaIXBOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 21:14:20 -0400
Received: from dliviu.plus.com ([80.229.23.120]:58993 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809AbaIXBOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 21:14:19 -0400
Date: Wed, 24 Sep 2014 02:12:50 +0100
From: Liviu Dudau <liviu@dudau.co.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Andrew Murray <amurray@embedded-bits.co.uk>
Subject: Re: [PATCH v12 05/12] PCI: OF: Fix the conversion of IO ranges into
 IO resources.
Message-ID: <20140924011249.GC32643@bart.dudau.co.uk>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
 <1411498874-9864-6-git-send-email-Liviu.Dudau@arm.com>
 <20140924002253.GB27357@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140924002253.GB27357@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Sep 24 02:14:15 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 13,54221ae73111045828584
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 06:22:53PM -0600, Bjorn Helgaas wrote:
> [+cc Andrew]
> 
> On Tue, Sep 23, 2014 at 08:01:07PM +0100, Liviu Dudau wrote:
> > The ranges property for a host bridge controller in DT describes
> > the mapping between the PCI bus address and the CPU physical address.
> > The resources framework however expects that the IO resources start
> > at a pseudo "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.
> > The conversion from pci ranges to resources failed to take that into account,
> > returning a CPU physical address instead of a port number.
> > 
> > Also fix all the drivers that depend on the old behaviour by fetching
> > the CPU physical address based on the port number where it is being needed.
> > 
> > Cc: Grant Likely <grant.likely@linaro.org>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Thierry Reding <thierry.reding@gmail.com>
> > Cc: Simon Horman <horms@verge.net.au>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > ---
> >  arch/arm/mach-integrator/pci_v3.c | 23 ++++++++++----------
> >  drivers/of/address.c              | 44 +++++++++++++++++++++++++++++++++++----
> >  drivers/pci/host/pci-tegra.c      | 10 ++++++---
> >  drivers/pci/host/pcie-rcar.c      | 21 +++++++++++++------
> >  include/linux/of_address.h        | 15 ++++++-------
> >  5 files changed, 82 insertions(+), 31 deletions(-)
> > ...
> 
> The of_pci_range_to_resource() implementation in drivers/of/address.c is
> always compiled when CONFIG_OF_ADDRESS=y, but when CONFIG_OF_ADDRESS=y and
> CONFIG_PCI is not set, we get the static inline version from
> include/linux/of_address.h as well, causing a redefinition error.
> 
> > diff --git a/drivers/of/address.c b/drivers/of/address.c
> > @@ -957,12 +957,48 @@ bool of_dma_is_coherent(struct device_node *np)
> > ...
> > +int of_pci_range_to_resource(struct of_pci_range *range,
> > +	struct device_node *np, struct resource *res)
> 
> > diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> > ...
> >  #else /* CONFIG_OF_ADDRESS && CONFIG_PCI */
> >  static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
> >  				             struct resource *r)
> > @@ -144,6 +139,12 @@ static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
> >  	return -ENOSYS;
> >  }
> >  
> > +static inline int of_pci_range_to_resource(struct of_pci_range *range,
> > +		struct device_node *np, struct resource *res)
> > +{
> > +	return -ENOSYS;
> > +}
> 
> My proposal to fix it is the following three patches.  The first moves the
> inline version of of_pci_range_to_resource() into the existing "#if
> defined(CONFIG_OF_ADDRESS) && defined(CONFIG_PCI)" block.
> 
> Andrew added it (and some other PCI-related things) with 29b635c00f3e
> ("of/pci: Provide support for parsing PCI DT ranges property") to
> of_address.h outside of any ifdefs, so it's always available.  Maybe
> there's a reason that's needed in the non-CONFIG_PCI case, but I didn't see
> it with a quick look.
> 
> The second moves of_pci_range_to_resource() to address.c, still inside the
> "#ifdef CONFIG_PCI" block.

Hi Bjorn,

Looks good to me. Sorry for messing this up, I've tested a combination of
CONFIG_PCI=y and CONFIG_PCI=n but it looks like I've only tested
CONFIG_OF_ADDRESS=CONFIG_PCI (both enabled or both disabled).

Best regards,
Liviu

> 
> Bjorn
> 
> 
> commit 95a60df1c2d400c676ab1d20271735e2b4735437
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Tue Sep 23 17:27:42 2014 -0600
> 
>     of/pci: Define of_pci_range_to_resource() only when CONFIG_PCI=y
>     
>     of_pci_range_to_resource() was previously defined always, but it's only
>     used by PCI code, so move the definition inside the CONFIG_OF_ADDRESS &&
>     CONFIG_PCI block.
>     
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index f8cc7daa420c..ecf913cf53b2 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -23,17 +23,6 @@ struct of_pci_range {
>  #define for_each_of_pci_range(parser, range) \
>  	for (; of_pci_range_parser_one(parser, range);)
>  
> -static inline void of_pci_range_to_resource(struct of_pci_range *range,
> -					    struct device_node *np,
> -					    struct resource *res)
> -{
> -	res->flags = range->flags;
> -	res->start = range->cpu_addr;
> -	res->end = range->cpu_addr + range->size - 1;
> -	res->parent = res->child = res->sibling = NULL;
> -	res->name = np->full_name;
> -}
> -
>  /* Translate a DMA address from device space to CPU space */
>  extern u64 of_translate_dma_address(struct device_node *dev,
>  				    const __be32 *in_addr);
> @@ -140,6 +129,18 @@ extern const __be32 *of_get_pci_address(struct device_node *dev, int bar_no,
>  			       u64 *size, unsigned int *flags);
>  extern int of_pci_address_to_resource(struct device_node *dev, int bar,
>  				      struct resource *r);
> +
> +static inline void of_pci_range_to_resource(struct of_pci_range *range,
> +					    struct device_node *np,
> +					    struct resource *res)
> +{
> +	res->flags = range->flags;
> +	res->start = range->cpu_addr;
> +	res->end = range->cpu_addr + range->size - 1;
> +	res->parent = res->child = res->sibling = NULL;
> +	res->name = np->full_name;
> +}
> +
>  #else /* CONFIG_OF_ADDRESS && CONFIG_PCI */
>  static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
>  				             struct resource *r)
> @@ -155,4 +156,3 @@ static inline const __be32 *of_get_pci_address(struct device_node *dev,
>  #endif /* CONFIG_OF_ADDRESS && CONFIG_PCI */
>  
>  #endif /* __OF_ADDRESS_H */
> -
> 
> commit 501857889201723da06aab0ec68186a5beaa9f72
> Author: Liviu Dudau <Liviu.Dudau@arm.com>
> Date:   Tue Sep 23 20:01:06 2014 +0100
> 
>     of/pci: Move of_pci_range_to_resources() to of/address.c
>     
>     We need to enhance of_pci_range_to_resources() enough that it won't make
>     sense for it to be inline anymore.  Move it to drivers/of/address.c,
>     keeping it under #ifdef CONFIG_PCI.
>     
>     [bhelgaas: drop extra detail from changelog, move def under CONFIG_PCI]
>     Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     CC: Grant Likely <grant.likely@linaro.org>
>     CC: Rob Herring <robh+dt@kernel.org>
>     CC: Arnd Bergmann <arnd@arndb.de>
>     CC: Catalin Marinas <catalin.marinas@arm.com>
> 
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index 758d4f04d4aa..327a57410797 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -295,6 +295,15 @@ struct of_pci_range *of_pci_range_parser_one(struct of_pci_range_parser *parser,
>  }
>  EXPORT_SYMBOL_GPL(of_pci_range_parser_one);
>  
> +void of_pci_range_to_resource(struct of_pci_range *range,
> +			      struct device_node *np, struct resource *res)
> +{
> +	res->flags = range->flags;
> +	res->start = range->cpu_addr;
> +	res->end = range->cpu_addr + range->size - 1;
> +	res->parent = res->child = res->sibling = NULL;
> +	res->name = np->full_name;
> +}
>  #endif /* CONFIG_PCI */
>  
>  /*
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index ecf913cf53b2..fa20aa15463d 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -129,18 +129,9 @@ extern const __be32 *of_get_pci_address(struct device_node *dev, int bar_no,
>  			       u64 *size, unsigned int *flags);
>  extern int of_pci_address_to_resource(struct device_node *dev, int bar,
>  				      struct resource *r);
> -
> -static inline void of_pci_range_to_resource(struct of_pci_range *range,
> -					    struct device_node *np,
> -					    struct resource *res)
> -{
> -	res->flags = range->flags;
> -	res->start = range->cpu_addr;
> -	res->end = range->cpu_addr + range->size - 1;
> -	res->parent = res->child = res->sibling = NULL;
> -	res->name = np->full_name;
> -}
> -
> +extern void of_pci_range_to_resource(struct of_pci_range *range,
> +				     struct device_node *np,
> +				     struct resource *res);
>  #else /* CONFIG_OF_ADDRESS && CONFIG_PCI */
>  static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
>  				             struct resource *r)
> 
> commit e01c1ebeee0bc45d6ac5f52b22c57d278799869b
> Author: Liviu Dudau <Liviu.Dudau@arm.com>
> Date:   Tue Sep 23 20:01:07 2014 +0100
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
>     
>     Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     Acked-by: Linus Walleij <linus.walleij@linaro.org>
>     CC: Grant Likely <grant.likely@linaro.org>
>     CC: Rob Herring <robh+dt@kernel.org>
>     CC: Arnd Bergmann <arnd@arndb.de>
>     CC: Thierry Reding <thierry.reding@gmail.com>
>     CC: Simon Horman <horms@verge.net.au>
>     CC: Catalin Marinas <catalin.marinas@arm.com>
> 
> diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
> index 05e1f73a1e8d..c186a17c2cff 100644
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
> index 327a57410797..afdb78299f61 100644
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
> index 0fb0fdb223d5..946935db62b6 100644
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
> index 4884ee5e07d4..61158e03ab5f 100644
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
> index fa20aa15463d..7ebb877b07c2 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -129,9 +129,9 @@ extern const __be32 *of_get_pci_address(struct device_node *dev, int bar_no,
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------
   .oooO
   (   )
    \ (  Oooo.
     \_) (   )
          ) /
         (_/

 One small step
   for me ...

