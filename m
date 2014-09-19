Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbaISVyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:54:10 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:57804 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728AbaISVyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:54:06 -0400
Date: Fri, 19 Sep 2014 15:54:00 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
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
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v11 10/10] PCI: Introduce pci_remap_iospace() for
 remapping PCI I/O bus resources into CPU space
Message-ID: <20140919215400.GA30239@google.com>
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com>
 <1411003825-21521-11-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411003825-21521-11-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 02:30:25AM +0100, Liviu Dudau wrote:
> Introduce a default implementation for remapping PCI bus I/O resources
> onto the CPU address space. Architectures with special needs may
> provide their own version, but most should be able to use this one.

I see that this is used by Tanmay's APM X-Gene PCIe host controller driver.
Since it's not used in this series, it'd be nice to mention where it *will*
be used.

> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Rob Herring <robh+dt@kernel.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> ---
>  drivers/pci/pci.c             | 33 +++++++++++++++++++++++++++++++++
>  include/asm-generic/pgtable.h |  4 ++++
>  include/linux/pci.h           |  3 +++
>  3 files changed, 40 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 2c9ac70..654b44c 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2704,6 +2704,39 @@ int pci_request_regions_exclusive(struct pci_dev *pdev, const char *res_name)
>  }
>  EXPORT_SYMBOL(pci_request_regions_exclusive);
>  
> +/**
> + *	pci_remap_iospace - Remap the memory mapped I/O space
> + *	@res: Resource describing the I/O space
> + *	@phys_addr: physical address where the range will be mapped.
> + *
> + *	Remap the memory mapped I/O space described by the @res
> + *	into the CPU physical address space. 

This comment doesn't seem quite right.  I think the space is already in the
CPU physical address space.  ioremap() and friends normally map existing
physical space into the *virtual* address space, i.e., they create mappings
from a virtual address to a physical address.

> Only architectures
> + *	that have memory mapped IO defined (and hence PCI_IOBASE)
> + *	should call this function.
> + */
> +int __weak pci_remap_iospace(const struct resource *res, phys_addr_t phys_addr)
> +{
> +	int err = -ENODEV;
> +
> +#ifdef PCI_IOBASE
> +	if (!(res->flags & IORESOURCE_IO))
> +		return -EINVAL;
> +
> +	if (res->end > IO_SPACE_LIMIT)
> +		return -EINVAL;
> +

PCI_IOBASE is a virtual address.  So PCI_IOBASE + res->start is also a
virtual address (only for IORESOURCE_IO).

Since res->start is normally a *physical* address, I think it would be less
confusing to do something like this:

    vaddr = PCI_IOBASE + res->start;
    ioremap_page_range(vaddr, vaddr + resource_size(res), ...);

so we have a hint that the first two ioremap_page_range() parameters are
virtual addresses.  It's also confusing that it uses "unsigned long" for
the virtual addresses, when we usually use "void *".  But that's out of
scope for this patch.

> +	err = ioremap_page_range(res->start + (unsigned long)PCI_IOBASE,
> +				res->end + 1 + (unsigned long)PCI_IOBASE,
> +				phys_addr, pgprot_device(PAGE_KERNEL));
> +#else
> +	/* this architecture does not have memory mapped I/O space,
> +	   so this function should never be called */
> +	WARN_ON(1);
> +#endif
> +
> +	return err;
> +}
> +
>  static void __pci_set_master(struct pci_dev *dev, bool enable)
>  {
>  	u16 old_cmd, cmd;
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index 53b2acc..977e545 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -249,6 +249,10 @@ static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
>  #define pgprot_writecombine pgprot_noncached
>  #endif
>  
> +#ifndef pgprot_device
> +#define pgprot_device pgprot_noncached
> +#endif
> +
>  /*
>   * When walking page tables, get the address of the next boundary,
>   * or the end address of the range if that comes earlier.  Although no
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index a494e5d..fc8c529 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1100,6 +1100,9 @@ int __must_check pci_bus_alloc_resource(struct pci_bus *bus,
>  						  resource_size_t),
>  			void *alignf_data);
>  
> +
> +int pci_remap_iospace(const struct resource *res, phys_addr_t phys_addr);
> +
>  static inline dma_addr_t pci_bus_address(struct pci_dev *pdev, int bar)
>  {
>  	struct pci_bus_region region;
> -- 
> 2.1.0
> 
