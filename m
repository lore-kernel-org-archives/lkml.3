Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaBDIox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:44:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52835 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaBDIoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:44:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Date: Tue, 04 Feb 2014 09:44:36 +0100
Message-ID: <3277167.UhkSU8Sf56@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140203213658.GA24036@e106497-lin.cambridge.arm.com>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com> <3808209.DeG1VobanZ@wuerfel> <20140203213658.GA24036@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vTHUsIoVV8nY34kZqGZeZm0wDWWyd7pUteyhxlZW5bE
 ymamGeszurqejYRcrLn+kERDhRK6LgnjBTI0bRU0dpccbOuVJJ
 uBHVWPeX/4ch7lRFOP3HM1ZH3+2ca58bKEYktsGdNWEpK9pnpS
 biynLqgfAYOfclrAR88evAqvooPdweZqZGoCcJSVuXfaw5t18Z
 ZZl3/p1Rq5q5Ljx8eZzS0o2muDSsA2+Dms2dFRPk2IOowB5E2/
 HbYMNFXpEcp1r3d85cFdicIwiCx0hxFJRc/iv3tV7EWGnDG43b
 nLt/8w78H9QyiFB5lm/dtL9S23/OG7Yde1YI2UzuZceDB3ck8J
 BQy3ac1JXMgHIm99NW9s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 February 2014 21:36:58 Liviu Dudau wrote:
> On Mon, Feb 03, 2014 at 08:05:56PM +0000, Arnd Bergmann wrote:
> > On Monday 03 February 2014 19:18:38 Liviu Dudau wrote:
> > > So ... defining it should mean no legacy ISA devices, right?
> > 
> > I would read that comment as referring to systems that don't have
> > any I/O space. If you have PCI, you can by definition have ISA
> > compatible devices behind a bridge. A typical example would be
> > a VGA card that supports the 03c0-03df port range.
> 
> But if you have PCI and don't want to support ISA do you have /dev/port? I guess yes.

Right, that is my interpretation. You could still have a tool
that tries to poke /dev/port from user space for any I/O BAR
the same way you'd use /dev/mem for memory BARs of PCI devices.

It's discouraged, but it's often the easiest solution for
a quick hack, and I'd expect tools to use this.

> > > > >  #define IO_SPACE_LIMIT		0xffff
> > > > 
> > > > You probably want to increase this a bit, to allow multiple host bridges
> > > > to have their own I/O space.
> > > 
> > > OK, but to what size?
> > 
> > 2 MB was a compromise on arm32 to allow up to 32 PCI host bridges but not
> > take up too much virtual space. On arm64 it should be at least as big.
> > Could be more than that, although I don't see a reason why it should be,
> > unless we expect to see systems with tons of host bridges, or buses
> > that exceed 64KB of I/O space.
> 
> I will increase the size to 2MB for v2.

Thinking about this some more, I'd go a little higher. In case of
pci_mv, we already register a 1MB region for one logical host
(which has multiple I/O spaces behind an emulated bridge), so
going to 16MB or more would let us handle multiple 1MB windows
for some amount of future proofing.

Maybe Catalin can assign us some virtual address space to use,
with the constraints that it should be 16MB or more in an
area that doesn't require additional kernel page table pages.
 
> > > > > +#define ioport_map(port, nr)	(PCI_IOBASE + ((port) & IO_SPACE_LIMIT))
> > > > > +#define ioport_unmap(addr)
> > > > 
> > > > inline functions?
> > > 
> > > Will do, thanks!
> > 
> > I suppose you can actually use the generic implementation from
> > asm-generic/io.h, and fix it by using the definition you have
> > above, since it's currently broken.
> 
> Not exactly broken, but it makes the assumption that your IO space starts at
> physical address zero and you have not remapped it. It does guard the
> definition with #ifndef CONFIG_GENERIC_IOMAP after all, so it does not
> expect to be generic :)

Well, I/O space never starts at physical zero in reality, so it is
broken in practice. The CONFIG_GENERIC_IOMAP option tries to solve
the problem of I/O spaces that are not memory mapped, which is
actually quite rare (x86, ia64, some rare powerpc bridges, and possibly
Alpha). The norm is that if you have I/O space, it is memory mapped
and you don't need GENERIC_IOMAP. I think most of the architectures
selecting GENERIC_IOMAP have incorrectly copied that from x86.

> > > > > diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
> > > > > new file mode 100644
> > > > > index 0000000..dd084a3
> > > > > --- /dev/null
> > > > > +++ b/arch/arm64/include/asm/pci.h
> > > > > @@ -0,0 +1,35 @@
> > > > > +#ifndef __ASM_PCI_H
> > > > > +#define __ASM_PCI_H
> > > > > +#ifdef __KERNEL__
> > > > > +
> > > > > +#include <linux/types.h>
> > > > > +#include <linux/slab.h>
> > > > > +#include <linux/dma-mapping.h>
> > > > > +
> > > > > +#include <asm/io.h>
> > > > > +#include <asm-generic/pci-bridge.h>
> > > > > +#include <asm-generic/pci-dma-compat.h>
> > > > > +
> > > > > +#define PCIBIOS_MIN_IO		0
> > > > > +#define PCIBIOS_MIN_MEM		0
> > > > 
> > > > PCIBIOS_MIN_IO is normally set to 0x1000, to stay out of the ISA range.
> > > 
> > > :) No ISA support! (Die ISA, die!!) 
> > 
> > If only it were that easy.
> 
> Lets try! :)
> 
> I wonder how many active devices that have an ISA slot are still supported
> by mainline kernel.

This is missing the point, but any architecture that has a PCI
slot can have an ISA device behind a bridge like this:

http://www.altera.com/products/ip/iup/pci/m-eur-pci-to-isa.html

The real reason is that a lot of PCI cards for practical reasons
expose some non-relocatable memory and I/O BARs in ISA-compatible
locations. Looking at /proc/ioports on my PC, I can spot a couple
of things that may well show up on any ARM machine:

0000-03af : PCI Bus 0000:00
  02f8-02ff : serial
03c0-03df : PCI Bus 0000:40
  03c0-03df : PCI Bus 0000:00
    03c0-03df : vga+
03e0-0cf7 : PCI Bus 0000:00
  03e8-03ef : serial
  03f8-03ff : serial
  0b00-0b0f : pnp 00:08
    0b00-0b07 : piix4_smbus
  0b20-0b3f : pnp 00:08
    0b20-0b27 : piix4_smbus
  0ca2-0ca3 : pnp 00:08
    0ca2-0ca2 : ipmi_si
    0ca3-0ca3 : ipmi_si
  0cf8-0cff : PCI conf1

Nothing wrong with the above. Now, it's also possible that
someone decides to build an ARM server by using a PC south
bridge with integrated legacy PC peripherals, such as these:

0000-03af : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00b0-00b0 : APEI ERST
  00c0-00df : dma2
  00f0-00ff : fpu

There is some hope that it won't happen, but these things
exist and come with a regular PCIe front-end bus in some
cases.

Finally, there is the LPC bus, which can give you additional
ISAPnP compatible devices.

> I will update PCIBIOS_MIN_xxxx to match arch/arm for v2.

Ok.

> > > > > diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
> > > > > new file mode 100644
> > > > > index 0000000..7b652cf
> > > > > --- /dev/null
> > > > > +++ b/arch/arm64/kernel/pci.c
> > > > > @@ -0,0 +1,112 @@
> > > > 
> > > > None of this looks really arm64 specific, nor should it be. I think
> > > > we should try a little harder to move this as a default implementation
> > > > into common code, even if we start out by having all architectures
> > > > override it.
> > > 
> > > Agree. This is the RFC version. I didn't dare to post a patch with fixes
> > > for all architectures. :)
> > 
> > No need to change the other architectures. You can make it opt-in for
> > now and just put the code into a common location.
> >  
> > An interesting question however is what the transition plan is to
> > have the code shared between arm32 and arm64: We will certainly need
> > to share at least the dw-pcie and the generic SBSA compliant pci
> > implementation.
> 
> My vote would be for updating the host controllers to the new API and
> to offer the CONFIG option to choose between arch APIs. The alternative
> is to use the existing API to wrap the generic implementation.

The problem with an either/or CONFIG option is that it breaks
multiplatform support. A lot of the arm32 PCI implementations
are only used on platforms that are not multiplatform enabled
though, so we could get away by requiring all multiplatform
configurations to use the new API.

> My main concern with the existing API is the requirement to have a subsys_initcall
> in your host bridge or mach code, due to the way the initialisation is done (you
> need the DT code to probe your driver, but you cannot start the scanning of the 
> PCI bus until the arch code is initialised, so it gets deferred via 
> subsys_initcall when it calls pci_common_init). I bet that if one tries to
> instantiate a Tegra PCI host bridge controller on a Marvell platform things will
> break pretty quickly (random example here).

I'm not following here. All the new host controller drivers should
be platform drivers that only bind to the host devices in DT
that are present. Both mvebu and tegra use a normal "module_platform_driver"
for initialization, not a "subsys_initcall".

> > Something like this (coded in mail client, don't try to compile):
> > 
> > #define IO_SPACE_PAGES (IO_SPACE_LIMIT + 1) / PAGE_SIZE)
> > static DECLARE_BITMAP(pci_iospace, IO_SPACE_PAGES);
> > unsigned long pci_ioremap_io(const struct resource *bus, const struct resource phys)
> > {
> > 	unsigned long start, len, virt_start;
> > 	int error;
> > 
> > 	/* use logical address == bus address if possible */
> > 	start = bus->start / PAGE_SIZE;
> > 	if (start > IO_SPACE_LIMIT / PAGE_SIZE)
> > 		start = 0;
> > 
> > 	/*
> > 	 * try finding free space for the whole size first,
> > 	 * fall back to 64K if not available
> > 	 */
> > 	len = min(resource_size(bus), resource_size(phys);
> > 	start = bitmap_find_next_zero_area(pci_iospace, IO_SPACE_PAGES,
> > 				start, len / PAGE_SIZE, 0);
> > 	if (start == IO_SPACE_PAGES && len > SZ_64K)
> > 		len = SZ_64K;
> > 		start = 0;
> > 		start = bitmap_find_next_zero_area(pci_iospace, IO_SPACE_PAGES,
> > 				start, len / PAGE_SIZE, 0);
> > 	}
> > 
> > 	/* no 64K area found */
> > 	if (start == IO_SPACE_PAGES)
> > 		return -ENOMEM;
> > 
> > 	/* ioremap physical aperture to virtual aperture */
> > 	virt_start = start * PAGE_SIZE + (unsigned long)PCI_IOBASE;
> > 	error = ioremap_page_range(virt_start, virt_start + len,
> > 				    phys->start, __pgprot(PROT_DEVICE_nGnRE));
> > 	if (error)
> > 		return error;
> > 
> > 	bitmap_set(start, len / PAGE_SIZE);
> > 
> > 	/* return io_offset */
> > 	return start * PAGE_SIZE - bus->start;
> > }
> > EXPORT_SYMBOL_GPL(pci_ioremap_io);
> > 
> > 	Arnd
> > 
> 
> I see. I need to think how this will change the existing code. Current users
> of pci_ioremap_io  ask for multiples of SZ_64K offsets regardless of the
> actual need. 

Right. I guess we can support both interfaces on ARM32 for the forseeable
future (renaming the new one) and just change the existing implementation
to update the bitmap. Any cross-platform host controller driver would
have to use the new interface however.

	Arnd
