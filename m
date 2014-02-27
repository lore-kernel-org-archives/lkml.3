Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaB0QHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:07:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:50302 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaB0QHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:07:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/3] arm64: Add architecture support for PCI
Date: Thu, 27 Feb 2014 17:06:24 +0100
Message-ID: <5402126.Dbh9PNPIjR@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1393506599-11561-4-git-send-email-Liviu.Dudau@arm.com>
References: <1393506599-11561-1-git-send-email-Liviu.Dudau@arm.com> <1393506599-11561-4-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Ajxqk7UEZEFwuTvzSOHy53T7yV6QS/h52RC7q5bBmJT
 oYsrfp1o05oeGS4QMh0mV09sxpbp//yuYO1lwAbvZZII4j5I6I
 L4v63Warfk876uVfImv58erft3JSKztc1nZf2tbP69/HtTPM5H
 TBMiLidmlDgE/lb5490p8jvnUVaGf2Xnfdw0iVS9HhURxMfh8F
 V0ASn93q1qaw9ZTQuiCFAkjtPjifVK6rrq6KARlGnH0rA4o6Ey
 jzmMqyFDUvPhd68AuYpwlIuWCIDQVKqBhnycpbIUKI3Sv3vgpS
 vF3Ehmo9ZgePNxyTQldUft7q8LYrqgfotPb/SkavcZmf8803U6
 MnF4/o1BIj/X5OWkpEqc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 February 2014 13:09:59 Liviu Dudau wrote:

> +/*
> + * PCI address space differs from physical memory address space
> + */
> +#define PCI_DMA_BUS_IS_PHYS	(0)
> +
> +extern int isa_dma_bridge_buggy;

I got curious about isa_dma_bridge_buggy: apparently this is a quirk for
some old x86 bridges. We don't have those on arm64, and we also don't have
ISA_DMA_API, so just define this to (0).

> +static inline int pci_domain_nr(struct pci_bus *bus)
> +{
> +	struct pci_host_bridge *bridge = to_pci_host_bridge(bus->bridge);
> +
> +	if (bridge)
> +		return bridge->domain_nr;
> +
> +	return 0;
> +}
> +
> +static inline int pci_proc_domain(struct pci_bus *bus)
> +{
> +	return pci_domain_nr(bus);
> +}

And this one I would change to always return '1': we can deal with
domain numbers showing up in /procfs for all buses, since there is
no legacy software to worry about.

> diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
> new file mode 100644
> index 0000000..496df41
> --- /dev/null
> +++ b/arch/arm64/kernel/pci.c
> @@ -0,1 +1,126 @@

Ok, this is nice and short. Let's see if we can reduce it to nothing ;-)

> +/*
> + * Called after each bus is probed, but before its children are examined
> + */
> +void pcibios_fixup_bus(struct pci_bus *bus)
> +{
> +	struct pci_dev *dev;
> +	struct resource *res;
> +	int i;
> +
> +	if (!pci_is_root_bus(bus)) {
> +		pci_read_bridge_bases(bus);
> +
> +		pci_bus_for_each_resource(bus, res, i) {
> +			if (!res || !res->flags || res->parent)
> +				continue;
> +
> +			/*
> +			 * If we are going to reassign everything, we can
> +			 * shrink the P2P resource to have zero size to
> +			 * save space
> +			 */
> +			if (pci_has_flag(PCI_REASSIGN_ALL_RSRC)) {
> +				res->flags |= IORESOURCE_UNSET;
> +				res->start = 0;
> +				res->end = -1;
> +				continue;
> +			}
> +		}
> +	}
> +
> +	list_for_each_entry(dev, &bus->devices, bus_list) {
> +		/* Ignore fully discovered devices */
> +		if (dev->is_added)
> +			continue;
> +
> +		set_dev_node(&dev->dev, pcibus_to_node(dev->bus));
> +
> +		/* Read default IRQs and fixup if necessary */
> +		dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
> +	}
> +}
> +EXPORT_SYMBOL(pcibios_fixup_bus);

Shrinking the P2P resources I suppose is optional, but everything
else is in fact needed for any DT based architecture. Could this
be turned into a generic helper function in the PCI core that we
can call from architecture code?

If you name it pci_generic_fixup_bus(), we can add a weak helper
like:

void __weak pcibios_fixup_bus(struct pci_bus *bus)
{
	pci_generic_fixup_bus(bus);
}

for architectures like arm64 that don't actually need to do anything
else.

> +/*
> + * We don't have to worry about legacy ISA devices, so nothing to do here
> + */
> +resource_size_t pcibios_align_resource(void *data, const struct resource *res,
> +				resource_size_t size, resource_size_t align)
> +{
> +	return ALIGN(res->start, align);
> +}
> +EXPORT_SYMBOL(pcibios_align_resource);

Where did this come from? The most common implementation seems to be

resource_size_t pcibios_align_resource(void *data, const struct resource *res,
				resource_size_t size, resource_size_t align)
{
	return start;
}
EXPORT_SYMBOL(pcibios_align_resource);

if you don't have to worry about ISA devices. The ALIGN() part seems to
be handled by __find_resource() already.

I'd say that should be made the default implementation in the PCI core.

I'm also pretty sure you don't need the EXPORT_SYMBOL, since the PCI
core cannot be a loadable module (yet).

> +int pcibios_enable_device(struct pci_dev *dev, int mask)
> +{
> +	return pci_enable_resources(dev, mask);
> +}
> +
> +void pcibios_fixup_bridge_ranges(struct list_head *resources)
> +{
> +}

These are clearly the right implementations, but they should be weak
functions, too.

> +#define IO_SPACE_PAGES	((IO_SPACE_LIMIT + 1) / PAGE_SIZE)
> +static DECLARE_BITMAP(pci_iospace, IO_SPACE_PAGES);
> +
> +unsigned long pci_ioremap_io(const struct resource *res, phys_addr_t phys_addr)
> +{
> +	unsigned long start, len, virt_start;
> +	int err;
> +
> +	if (res->end > IO_SPACE_LIMIT)
> +		return -EINVAL;
> +
> +	/*
> +	 * try finding free space for the whole size first,
> +	 * fall back to 64K if not available
> +	 */
> +	len = resource_size(res);
> +	start = bitmap_find_next_zero_area(pci_iospace, IO_SPACE_PAGES,
> +				res->start / PAGE_SIZE, len / PAGE_SIZE, 0);
> +	if (start == IO_SPACE_PAGES && len > SZ_64K) {
> +		len = SZ_64K;
> +		start = 0;
> +		start = bitmap_find_next_zero_area(pci_iospace, IO_SPACE_PAGES,
> +					start, len / PAGE_SIZE, 0);
> +	}
> +
> +	/* no 64K area found */
> +	if (start == IO_SPACE_PAGES)
> +		return -ENOMEM;
> +
> +	/* ioremap physical aperture to virtual aperture */
> +	virt_start = start * PAGE_SIZE + (unsigned long)PCI_IOBASE;
> +	err = ioremap_page_range(virt_start, virt_start + len,
> +				phys_addr, __pgprot(PROT_DEVICE_nGnRE));
> +	if (err)
> +		return err;
> +
> +	bitmap_set(pci_iospace, start, len / PAGE_SIZE);
> +
> +	/* return io_offset */
> +	return start * PAGE_SIZE - res->start;
> +}

Maybe this can become an optional helper function with a separate Kconfig symbol
to enable it.

	Arnd
