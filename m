Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaBCUGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:06:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53344 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbaBCUGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:06:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Date: Mon, 03 Feb 2014 21:05:56 +0100
Message-ID: <3808209.DeG1VobanZ@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140203191837.GC4889@e106497-lin.cambridge.arm.com>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com> <21596846.kVTqp7roW4@wuerfel> <20140203191837.GC4889@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:K+GHTgL277Gglfxk/LcKP0TuS6FhbLuPZYm+9aoMXEW
 mzD/izv2z6qit9wGpEOQ7kLbLFrEAphCJKbaqY0RTxps/1NrFk
 jhkvAZGOswnPJGS7hrKv02ohu0nJ+DD53ZDfeVS/bXRIamfvrH
 7xXPSWm95fDJj+HpCiASjheLpabyL5pdg2uU3YAmkLl0JyQxO2
 XmgtaYpzhM//ZnOfBtiSxjGzSCWwDxm6CJY1bcF73Y2WfBBh3K
 ss7AfZxpEqHeFWQIz3jt6JekZ1hRaeUX5CsodlBvT5CV0YtKj9
 K7UeJXhKsC7YBsfywYSQsPZvo+ewiycKktbKm1kmzHTDnXkXXf
 Dr2/hllK1THwO8BK4kh4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 February 2014 19:18:38 Liviu Dudau wrote:
> On Mon, Feb 03, 2014 at 06:58:56PM +0000, Arnd Bergmann wrote:
> > On Monday 03 February 2014 18:43:48 Liviu Dudau wrote:
> > > diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> > > index 4cc813e..ce5bad2 100644
> > > --- a/arch/arm64/include/asm/io.h
> > > +++ b/arch/arm64/include/asm/io.h
> > > @@ -120,9 +120,13 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
> > >  /*
> > >   *  I/O port access primitives.
> > >   */
> > > +#define arch_has_dev_port()	(0)
> > 
> > Why not?
> 
> Maybe I got it the wrong way around, but the comment in include/linux/io.h says:
> 
> /*
>  * Some systems do not have legacy ISA devices.
>  * /dev/port is not a valid interface on these systems.
>  * So for those archs, <asm/io.h> should define the following symbol.
>  */
> 
> So ... defining it should mean no legacy ISA devices, right?

I would read that comment as referring to systems that don't have
any I/O space. If you have PCI, you can by definition have ISA
compatible devices behind a bridge. A typical example would be
a VGA card that supports the 03c0-03df port range.

> > 
> > >  #define IO_SPACE_LIMIT		0xffff
> > 
> > You probably want to increase this a bit, to allow multiple host bridges
> > to have their own I/O space.
> 
> OK, but to what size?

2 MB was a compromise on arm32 to allow up to 32 PCI host bridges but not
take up too much virtual space. On arm64 it should be at least as big.
Could be more than that, although I don't see a reason why it should be,
unless we expect to see systems with tons of host bridges, or buses
that exceed 64KB of I/O space.

> > > +#define ioport_map(port, nr)	(PCI_IOBASE + ((port) & IO_SPACE_LIMIT))
> > > +#define ioport_unmap(addr)
> > 
> > inline functions?
> 
> Will do, thanks!

I suppose you can actually use the generic implementation from
asm-generic/io.h, and fix it by using the definition you have
above, since it's currently broken.

> > > diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
> > > new file mode 100644
> > > index 0000000..dd084a3
> > > --- /dev/null
> > > +++ b/arch/arm64/include/asm/pci.h
> > > @@ -0,0 +1,35 @@
> > > +#ifndef __ASM_PCI_H
> > > +#define __ASM_PCI_H
> > > +#ifdef __KERNEL__
> > > +
> > > +#include <linux/types.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/dma-mapping.h>
> > > +
> > > +#include <asm/io.h>
> > > +#include <asm-generic/pci-bridge.h>
> > > +#include <asm-generic/pci-dma-compat.h>
> > > +
> > > +#define PCIBIOS_MIN_IO		0
> > > +#define PCIBIOS_MIN_MEM		0
> > 
> > PCIBIOS_MIN_IO is normally set to 0x1000, to stay out of the ISA range.
> 
> :) No ISA support! (Die ISA, die!!) 

If only it were that easy.

> > > diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
> > > new file mode 100644
> > > index 0000000..7b652cf
> > > --- /dev/null
> > > +++ b/arch/arm64/kernel/pci.c
> > > @@ -0,0 +1,112 @@
> > 
> > None of this looks really arm64 specific, nor should it be. I think
> > we should try a little harder to move this as a default implementation
> > into common code, even if we start out by having all architectures
> > override it.
> 
> Agree. This is the RFC version. I didn't dare to post a patch with fixes
> for all architectures. :)

No need to change the other architectures. You can make it opt-in for
now and just put the code into a common location.
 
An interesting question however is what the transition plan is to
have the code shared between arm32 and arm64: We will certainly need
to share at least the dw-pcie and the generic SBSA compliant pci
implementation.

> > > +int pci_ioremap_io(unsigned int offset, phys_addr_t phys_addr)
> > > +{
> > > +	BUG_ON(offset + SZ_64K - 1 > IO_SPACE_LIMIT);
> > > +
> > > +	return ioremap_page_range((unsigned long)PCI_IOBASE + offset,
> > > +				(unsigned long)PCI_IOBASE + offset + SZ_64K,
> > > +				phys_addr,
> > > +				__pgprot(PROT_DEVICE_nGnRE));
> > > +}
> > 
> > Not sure if we want to treat this one as architecture specific though.
> > It certainly won't be portable to x86, but it could be shared with
> > a couple of others. We may also want to redesign the interface.
> > I've been thinking we could make this function allocate space in the
> > Linux virtual I/O space aperture, and pass two resources into it
> > (physical I/O aperture and bus I/O range), and get the actual
> > io_offset as the return value, or a negative error number.
> 
> Not sure I completely follow your idea.

Something like this (coded in mail client, don't try to compile):

#define IO_SPACE_PAGES (IO_SPACE_LIMIT + 1) / PAGE_SIZE)
static DECLARE_BITMAP(pci_iospace, IO_SPACE_PAGES);
unsigned long pci_ioremap_io(const struct resource *bus, const struct resource phys)
{
	unsigned long start, len, virt_start;
	int error;

	/* use logical address == bus address if possible */
	start = bus->start / PAGE_SIZE;
	if (start > IO_SPACE_LIMIT / PAGE_SIZE)
		start = 0;

	/*
	 * try finding free space for the whole size first,
	 * fall back to 64K if not available
	 */
	len = min(resource_size(bus), resource_size(phys);
	start = bitmap_find_next_zero_area(pci_iospace, IO_SPACE_PAGES,
				start, len / PAGE_SIZE, 0);
	if (start == IO_SPACE_PAGES && len > SZ_64K)
		len = SZ_64K;
		start = 0;
		start = bitmap_find_next_zero_area(pci_iospace, IO_SPACE_PAGES,
				start, len / PAGE_SIZE, 0);
	}

	/* no 64K area found */
	if (start == IO_SPACE_PAGES)
		return -ENOMEM;

	/* ioremap physical aperture to virtual aperture */
	virt_start = start * PAGE_SIZE + (unsigned long)PCI_IOBASE;
	error = ioremap_page_range(virt_start, virt_start + len,
				    phys->start, __pgprot(PROT_DEVICE_nGnRE));
	if (error)
		return error;

	bitmap_set(start, len / PAGE_SIZE);

	/* return io_offset */
	return start * PAGE_SIZE - bus->start;
}
EXPORT_SYMBOL_GPL(pci_ioremap_io);

	Arnd
