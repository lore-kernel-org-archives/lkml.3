Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaB0Nl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:41:56 -0500
Received: from service87.mimecast.com ([91.220.42.44]:47752 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaB0Nlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:41:53 -0500
Date: Thu, 27 Feb 2014 13:41:50 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] arm64: Add architecture support for PCI
Message-ID: <20140227134150.GI1692@e106497-lin.cambridge.arm.com>
Mail-Followup-To: linux-pci <linux-pci@vger.kernel.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1393506599-11561-1-git-send-email-Liviu.Dudau@arm.com>
 <1393506599-11561-4-git-send-email-Liviu.Dudau@arm.com>
 <CAPcvp5G_xZQqcySBfxFbCBCmeYL3n6OeaVW6qZ2k3cGQkga2QA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcvp5G_xZQqcySBfxFbCBCmeYL3n6OeaVW6qZ2k3cGQkga2QA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 27 Feb 2014 13:41:50.0891 (UTC) FILETIME=[AB1357B0:01CF33C1]
X-MC-Unique: 114022713415109601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 01:35:22PM +0000, Andrew Murray wrote:
> On 27 February 2014 13:09, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > Use the generic host bridge functions to provide support for
> > PCI Express on arm64. There is no support for ISA memory.
> >
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> >
> >  create mode 100644 arch/arm64/include/asm/pci.h
> >  create mode 100644 arch/arm64/kernel/pci.c
> >
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 27bbcfc..d1c8568 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -62,7 +62,7 @@ config MMU
> >         def_bool y
> >
> >  config NO_IOPORT
> > -       def_bool y
> > +       def_bool y if !PCI
> >
> >  config STACKTRACE_SUPPORT
> >         def_bool y
> > @@ -134,6 +134,23 @@ menu "Bus support"
> >  config ARM_AMBA
> >         bool
> >
> > +config PCI
> > +       bool "PCI support"
> > +       help
> > +         This feature enables support for PCIe bus system. If you say Y
> > +         here, the kernel will include drivers and infrastructure code
> > +         to support PCIe bus devices.
> > +
> > +config PCI_DOMAINS
> > +       def_bool PCI
> > +
> > +config PCI_SYSCALL
> > +       def_bool PCI
> > +
> > +source "drivers/pci/Kconfig"
> > +source "drivers/pci/pcie/Kconfig"
> > +source "drivers/pci/hotplug/Kconfig"
> > +
> >  endmenu
> >
> >  menu "Kernel Features"
> > diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
> > index 71c53ec..46924bc 100644
> > --- a/arch/arm64/include/asm/Kbuild
> > +++ b/arch/arm64/include/asm/Kbuild
> > @@ -26,6 +26,7 @@ generic-y += mman.h
> >  generic-y += msgbuf.h
> >  generic-y += mutex.h
> >  generic-y += pci.h
> > +generic-y += pci-bridge.h
> >  generic-y += poll.h
> >  generic-y += posix_types.h
> >  generic-y += resource.h
> > diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> > index 7846a6b..67463a5 100644
> > --- a/arch/arm64/include/asm/io.h
> > +++ b/arch/arm64/include/asm/io.h
> > @@ -120,7 +120,8 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
> >  /*
> >   *  I/O port access primitives.
> >   */
> > -#define IO_SPACE_LIMIT         0xffff
> > +#define arch_has_dev_port()    (1)
> > +#define IO_SPACE_LIMIT         0x1ffffff
> >  #define PCI_IOBASE             ((void __iomem *)(MODULES_VADDR - SZ_32M))
> >
> >  static inline u8 inb(unsigned long addr)
> > diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
> > new file mode 100644
> > index 0000000..3edf9e0
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/pci.h
> > @@ -0,0 +1,47 @@
> > +#ifndef __ASM_PCI_H
> > +#define __ASM_PCI_H
> > +#ifdef __KERNEL__
> > +
> > +#include <linux/types.h>
> > +#include <linux/slab.h>
> > +#include <linux/dma-mapping.h>
> > +
> > +#include <asm/io.h>
> > +#include <asm-generic/pci-bridge.h>
> > +#include <asm-generic/pci-dma-compat.h>
> > +
> > +#define PCIBIOS_MIN_IO         0x1000
> > +#define PCIBIOS_MIN_MEM                0
> > +
> > +/*
> > + * Set to 1 if the kernel should re-assign all PCI bus numbers
> > + */
> > +#define pcibios_assign_all_busses() \
> > +       (pci_has_flag(PCI_REASSIGN_ALL_BUS))
> > +
> > +/*
> > + * PCI address space differs from physical memory address space
> > + */
> > +#define PCI_DMA_BUS_IS_PHYS    (0)
> > +
> > +extern int isa_dma_bridge_buggy;
> > +
> > +static inline int pci_domain_nr(struct pci_bus *bus)
> > +{
> > +       struct pci_host_bridge *bridge = to_pci_host_bridge(bus->bridge);
> > +
> > +       if (bridge)
> > +               return bridge->domain_nr;
> > +
> > +       return 0;
> > +}
> > +
> > +static inline int pci_proc_domain(struct pci_bus *bus)
> > +{
> > +       return pci_domain_nr(bus);
> > +}
> > +
> > +extern unsigned long pci_ioremap_io(const struct resource *res, phys_addr_t phys_addr);
> > +
> > +#endif  /* __KERNEL__ */
> > +#endif  /* __ASM_PCI_H */
> > diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> > index 2d4554b..64fc479 100644
> > --- a/arch/arm64/kernel/Makefile
> > +++ b/arch/arm64/kernel/Makefile
> > @@ -20,6 +20,7 @@ arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
> >  arm64-obj-$(CONFIG_EARLY_PRINTK)       += early_printk.o
> >  arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)  += sleep.o suspend.o
> >  arm64-obj-$(CONFIG_JUMP_LABEL)         += jump_label.o
> > +arm64-obj-$(CONFIG_PCI)                        += pci.o
> >
> >  obj-y                                  += $(arm64-obj-y) vdso/
> >  obj-m                                  += $(arm64-obj-m)
> > diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
> > new file mode 100644
> > index 0000000..496df41
> > --- /dev/null
> > +++ b/arch/arm64/kernel/pci.c
> > @@ -0,1 +1,126 @@
> > +/*
> > + * Code borrowed from powerpc/kernel/pci-common.c
> > + *
> > + * Copyright (C) 2003 Anton Blanchard <anton@au.ibm.com>, IBM
> > + * Copyright (C) 2014 ARM Ltd.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * version 2 as published by the Free Software Foundation.
> > + *
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/io.h>
> > +#include <linux/kernel.h>
> > +#include <linux/mm.h>
> > +#include <linux/of_pci.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/slab.h>
> > +
> > +#include <asm/pci-bridge.h>
> > +
> > +
> > +/*
> > + * Called after each bus is probed, but before its children are examined
> > + */
> > +void pcibios_fixup_bus(struct pci_bus *bus)
> > +{
> > +       struct pci_dev *dev;
> > +       struct resource *res;
> > +       int i;
> > +
> > +       if (!pci_is_root_bus(bus)) {
> > +               pci_read_bridge_bases(bus);
> > +
> > +               pci_bus_for_each_resource(bus, res, i) {
> > +                       if (!res || !res->flags || res->parent)
> > +                               continue;
> > +
> > +                       /*
> > +                        * If we are going to reassign everything, we can
> > +                        * shrink the P2P resource to have zero size to
> > +                        * save space
> > +                        */
> > +                       if (pci_has_flag(PCI_REASSIGN_ALL_RSRC)) {
> > +                               res->flags |= IORESOURCE_UNSET;
> > +                               res->start = 0;
> > +                               res->end = -1;
> > +                               continue;
> > +                       }
> > +               }
> > +       }
> > +
> > +       list_for_each_entry(dev, &bus->devices, bus_list) {
> > +               /* Ignore fully discovered devices */
> > +               if (dev->is_added)
> > +                       continue;
> > +
> > +               set_dev_node(&dev->dev, pcibus_to_node(dev->bus));
> > +
> > +               /* Read default IRQs and fixup if necessary */
> > +               dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
> > +       }
> > +}
> > +EXPORT_SYMBOL(pcibios_fixup_bus);
> > +
> > +/*
> > + * We don't have to worry about legacy ISA devices, so nothing to do here
> > + */
> > +resource_size_t pcibios_align_resource(void *data, const struct resource *res,
> > +                               resource_size_t size, resource_size_t align)
> > +{
> > +       return ALIGN(res->start, align);
> > +}
> > +EXPORT_SYMBOL(pcibios_align_resource);
> > +
> > +int pcibios_enable_device(struct pci_dev *dev, int mask)
> > +{
> > +       return pci_enable_resources(dev, mask);
> > +}
> 
> It looks like you will soon be able to remove this and rely on the
> shinny new weak implementation of pcibios_enable_device now
> (http://www.spinics.net/lists/linux-pci/msg29387.html)

Yes, I've seen the patches, will probably remove before the final version
gets submitted.

Thanks,
Liviu


> 
> Andrew Murray
> 
> > +
> > +void pcibios_fixup_bridge_ranges(struct list_head *resources)
> > +{
> > +}
> > +
> > +#define IO_SPACE_PAGES ((IO_SPACE_LIMIT + 1) / PAGE_SIZE)
> > +static DECLARE_BITMAP(pci_iospace, IO_SPACE_PAGES);
> > +
> > +unsigned long pci_ioremap_io(const struct resource *res, phys_addr_t phys_addr)
> > +{
> > +       unsigned long start, len, virt_start;
> > +       int err;
> > +
> > +       if (res->end > IO_SPACE_LIMIT)
> > +               return -EINVAL;
> > +
> > +       /*
> > +        * try finding free space for the whole size first,
> > +        * fall back to 64K if not available
> > +        */
> > +       len = resource_size(res);
> > +       start = bitmap_find_next_zero_area(pci_iospace, IO_SPACE_PAGES,
> > +                               res->start / PAGE_SIZE, len / PAGE_SIZE, 0);
> > +       if (start == IO_SPACE_PAGES && len > SZ_64K) {
> > +               len = SZ_64K;
> > +               start = 0;
> > +               start = bitmap_find_next_zero_area(pci_iospace, IO_SPACE_PAGES,
> > +                                       start, len / PAGE_SIZE, 0);
> > +       }
> > +
> > +       /* no 64K area found */
> > +       if (start == IO_SPACE_PAGES)
> > +               return -ENOMEM;
> > +
> > +       /* ioremap physical aperture to virtual aperture */
> > +       virt_start = start * PAGE_SIZE + (unsigned long)PCI_IOBASE;
> > +       err = ioremap_page_range(virt_start, virt_start + len,
> > +                               phys_addr, __pgprot(PROT_DEVICE_nGnRE));
> > +       if (err)
> > +               return err;
> > +
> > +       bitmap_set(pci_iospace, start, len / PAGE_SIZE);
> > +
> > +       /* return io_offset */
> > +       return start * PAGE_SIZE - res->start;
> > +}
> > --
> > 1.9.0
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
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

