Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaDPQ5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:57:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45205 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaDPQ53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:57:29 -0400
Date: Wed, 16 Apr 2014 17:57:24 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC PATCH 1/2] PCI: designware: Add ARM64 PCI support
Message-ID: <20140416165724.GG7802@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Jingoo Han <jg1.han@samsung.com>,
	'linux-pci' <linux-pci@vger.kernel.org>,
	'Bjorn Helgaas' <bhelgaas@google.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	'Arnd Bergmann' <arnd@arndb.de>,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
 <000901cf592e$563bc8c0$02b35a40$%han@samsung.com>
MIME-Version: 1.0
In-Reply-To: <000901cf592e$563bc8c0$02b35a40$%han@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 16 Apr 2014 16:57:40.0750 (UTC) FILETIME=[FA5D8AE0:01CF5994]
X-MC-Unique: 114041617572600201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jingoo,

Thanks for taking a stab at trying to convert a host bridge
driver to use the new generic host bridge code.

I do however have concerns on the direction you took. You have split
your driver in two, depending on whether it was CONFIG_ARM or CONFIG_ARM64,
even if (with my series) it should be no reason why the host bridge
driver should not work on other architectures as well once they are
converted.

Also, some of the functions that you use have identical names but different
signatures depending on what arch you have selected. This is really bad
in my books!

What about creating functions that use my series directly if CONFIG_ARM64 is
defined (or any CONFIG_ you want to create for your driver that you select
from CONFIG_ARM64) and otherwise implement the CONFIG_ARM version? That
way your driver will call only one API without any #ifdef and when arm code
gets converted you drop your adaptation functions. Or (better yet), have a
stab at converting bios32 (Rob Herring has already provided some hints on
how to do it for arch/arm).

To give an example on how things are not going well in your version (not obvious
from your patch, but you can see it once you apply it): dw_pcie_host_init()
will still carry the handcoded version of DT parsing and that is not guarded
against CONFIG_ARM64 being defined, where the parsing will happen again
when you call of_create_pci_host_bridge().

Speaking of the handcoded DT parsing of resources: you are using restype == 0
as a way of selecting config space, *and then split the range size into two
halves*. From what Jason Gunthorpe and Arnd were saying, config ranges in the DT
tree should only be used for ECAM space, so no split is allowed.

Arnd, are you allowing this non-standard use to creep in the bindings?

Best regards,
Liviu

On Wed, Apr 16, 2014 at 05:42:56AM +0100, Jingoo Han wrote:
> Add ARM64 PCI support for Synopsys designware PCIe, by using
> pcie arm64 arch support and creating generic pcie bridge from
> device tree.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/pci/host/pcie-designware.c |   32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index 6d23d8c..fac0440 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -65,14 +65,27 @@
>  #define PCIE_ATU_FUNC(x)		(((x) & 0x7) << 16)
>  #define PCIE_ATU_UPPER_TARGET		0x91C
>  
> +#ifdef CONFIG_ARM
>  static struct hw_pci dw_pci;
> +#endif
>  
>  static unsigned long global_io_offset;
>  
> +#ifdef CONFIG_ARM
>  static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys)
>  {
>  	return sys->private_data;
>  }
> +#endif
> +
> +#ifdef CONFIG_ARM64
> +static inline struct pcie_port *sys_to_pcie(struct pcie_port *pp)
> +{
> +	return pp;
> +}
> +
> +static struct pci_ops dw_pcie_ops;
> +#endif
>  
>  int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val)
>  {
> @@ -381,7 +394,9 @@ static int dw_pcie_msi_map(struct irq_domain *domain, unsigned int irq,
>  {
>  	irq_set_chip_and_handler(irq, &dw_msi_irq_chip, handle_simple_irq);
>  	irq_set_chip_data(irq, domain->host_data);
> +#ifdef CONFIG_ARM
>  	set_irq_flags(irq, IRQF_VALID);
> +#endif
>  
>  	return 0;
>  }
> @@ -397,6 +412,10 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  	struct of_pci_range_parser parser;
>  	u32 val;
>  	int i;
> +#ifdef CONFIG_ARM64
> +	struct pci_host_bridge *bridge;
> +	resource_size_t lastbus;
> +#endif
>  
>  	if (of_pci_range_parser_init(&parser, np)) {
>  		dev_err(pp->dev, "missing ranges property\n");
> @@ -489,6 +508,7 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  	val |= PORT_LOGIC_SPEED_CHANGE;
>  	dw_pcie_wr_own_conf(pp, PCIE_LINK_WIDTH_SPEED_CONTROL, 4, val);
>  
> +#ifdef CONFIG_ARM
>  	dw_pci.nr_controllers = 1;
>  	dw_pci.private_data = (void **)&pp;
>  
> @@ -497,6 +517,16 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  #ifdef CONFIG_PCI_DOMAINS
>  	dw_pci.domain++;
>  #endif
> +#endif
> +
> +#ifdef CONFIG_ARM64
> +	bridge = of_create_pci_host_bridge(pp->dev, &dw_pcie_ops, pp);
> +	if (IS_ERR_OR_NULL(bridge))
> +		return PTR_ERR(bridge);
> +
> +	lastbus = pci_rescan_bus(bridge->bus);
> +	pci_bus_update_busn_res_end(bridge->bus, lastbus);
> +#endif
>  
>  	return 0;
>  }
> @@ -695,6 +725,7 @@ static struct pci_ops dw_pcie_ops = {
>  	.write = dw_pcie_wr_conf,
>  };
>  
> +#ifdef CONFIG_ARM
>  static int dw_pcie_setup(int nr, struct pci_sys_data *sys)
>  {
>  	struct pcie_port *pp;
> @@ -758,6 +789,7 @@ static struct hw_pci dw_pci = {
>  	.map_irq	= dw_pcie_map_irq,
>  	.add_bus	= dw_pcie_add_bus,
>  };
> +#endif /* CONFIG_ARM */
>  
>  void dw_pcie_setup_rc(struct pcie_port *pp)
>  {
> -- 
> 1.7.10.4
> 
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

