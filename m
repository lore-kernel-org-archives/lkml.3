Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaEGSnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:43:17 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:41090 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaEGSnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:43:15 -0400
Date: Wed, 7 May 2014 12:43:27 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-doc@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 1/5] DMA-API: Clarify physical/bus address distinction
Message-ID: <20140507184327.GA28307@google.com>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140506224819.17968.2922.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <4295045.447pOn727x@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4295045.447pOn727x@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 09:37:04AM +0200, Arnd Bergmann wrote:
> On Tuesday 06 May 2014 16:48:19 Bjorn Helgaas wrote:
> > The DMA-API documentation sometimes refers to "physical addresses" when it
> > really means "bus addresses."  Sometimes these are identical, but they may
> > be different if the bridge leading to the bus performs address translation.
> > Update the documentation to use "bus address" when appropriate.
> > 
> > Also, consistently capitalize "DMA", use parens with function names, use
> > dev_printk() in examples, and reword a few sections for clarity.
> > 
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> Looks great!
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Just some minor comments that you may include if you like (my Ack
> holds if you don't as well).
> 
> > @@ -30,16 +28,16 @@ hardware exists.
> >  
> >  Note that the DMA API works with any bus independent of the underlying
> >  microprocessor architecture. You should use the DMA API rather than
> > -the bus specific DMA API (e.g. pci_dma_*).
> > +the bus-specific DMA API (e.g. pci_dma_*).
> 
> It might make sense to change the example to dma_map_* rather than pci_dma_*,
> which is rarely used these days. I think there was at one point a move
> to replace remove the include/asm-generic/pci-dma-compat.h APIs.

I reworded this as:

  You should use the DMA API rather than the bus-specific DMA API, i.e.,
  use the dma_map_*() interfaces rather than the pci_map_*() interfaces.

Does that clear it up?

> >  First of all, you should make sure
> >  
> >  #include <linux/dma-mapping.h>
> >  
> > -is in your driver. This file will obtain for you the definition of the
> > -dma_addr_t (which can hold any valid DMA address for the platform)
> > -type which should be used everywhere you hold a DMA (bus) address
> > -returned from the DMA mapping functions.
> > +is in your driver, which provides the definition of dma_addr_t.  This type
> > +can hold any valid DMA or bus address for the platform and should be used
> > +everywhere you hold a DMA address returned from the DMA mapping functions
> > +or a bus address read from a device register such as a PCI BAR.
> 
> The PCI BAR example is misleading I think: While the raw value of the
> BAR would be a dma_addr_t that can be used for pci-pci DMA, we normally
> only deal with translated BARs from pci_resource_*, which would be
> a resource_size_t in the same space as phys_addr_t, which has the
> PCI mem_offset added in.

I removed the last line ("or a bus address ...")

> > + * A dma_addr_t can hold any valid DMA or bus address for the platform.
> > + * It can be given to a device to use as a DMA source or target, or it may
> > + * appear on the bus when a CPU performs programmed I/O.  A CPU cannot
> > + * reference a dma_addr_t directly because there may be translation between
> > + * its physical address space and the bus address space.
> 
> On a similar note, I think the part 'or it may appear on the bus when a CPU
> performs programmed I/O' is somewhat misleading: While true in theory, we
> would never use a dma_addr_t to store an address to be used for PIO, because
> the CPU needs to use either the phys_addr_t value associated with the physical
> MMIO address or the __iomem pointer for the virtually mapped address.

Yep, makes sense, I removed that too, thanks!

I wrote the text below to give a little background.  Maybe it's overkill for
DMA-API-HOWTO.txt, but there really isn't much coverage of this elsewhere
in Documentation/.  If I did include this, I'd propose removing this text
at the same time (I think it's a bit over-specific now, and I still have a
brief IOMMU description):

  -Most of the 64bit platforms have special hardware that translates bus
  -addresses (DMA addresses) into physical addresses.  This is similar to
  -how page tables and/or a TLB translates virtual addresses to physical
  -addresses on a CPU.  This is needed so that e.g. PCI devices can
  -access with a Single Address Cycle (32bit DMA address) any page in the
  -64bit physical address space.  Previously in Linux those 64bit
  -platforms had to set artificial limits on the maximum RAM size in the
  -system, so that the virt_to_bus() static scheme works (the DMA address
  -translation tables were simply filled on bootup to map each bus
  -address to the physical page __pa(bus_to_virt())).

Bjorn


                       CPU and DMA addresses

There are several kinds of addresses involved in the DMA API, and it's
important to understand the differences.

The kernel normally uses virtual addresses.  Any address returned by
kmalloc(), vmalloc(), and similar interfaces is a virtual address and can
be stored in a "void *".

The virtual memory system (TLB, page tables, etc.) translates virtual
addresses to CPU physical addresses, which are stored as "phys_addr_t" or
"resource_size_t".  The kernel manages device resources like registers as
physical addresses.  These are the addresses in /proc/iomem.  The physical
address is not directly useful to a driver; it must use ioremap() to map
the space and produce a virtual address.

I/O devices use a third kind of address, a "bus address" or "DMA address".
If a device has registers at an MMIO address, or if it performs DMA to read  
or write system memory, the addresses used by the device are bus addresses.
In some systems, bus addresses are identical to CPU physical addresses, but
in general they are not.  IOMMUs and host bridges can produce arbitrary
mappings between physical and bus addresses.

Here's a picture and some examples:

               CPU                  CPU                  Bus
             Virtual              Physical             Address
             Address              Address               Space
              Space                Space

            +-------+             +------+             +------+
            |       |             |MMIO  |   Offset    |      |
            |       |  Virtual    |Space |   applied   |      |
          C +-------+ --------> B +------+ ----------> +------+ A
            |       |  mapping    |      |   by host   |      |
  +-----+   |       |             |      |   bridge    |      |   +--------+
  |     |   |       |             +------+             |      |   |        |
  | CPU |   |       |             | RAM  |             |      |   | Device |
  |     |   |       |             |      |             |      |   |        |
  +-----+   +-------+             +------+             +------+   +--------+
            |       |  Virtual    |Buffer|   Mapping   |      |
          X +-------+ --------> Y +------+ <---------- +------+ Z
            |       |  mapping    | RAM  |   by IOMMU
            |       |             |      |
            |       |             |      |
            +-------+             +------+

During the enumeration process, the kernel learns about I/O devices and
their MMIO space and the host bridges that connect them to the system.  For
example, if a PCI device has a BAR, the kernel reads the bus address (A)
from the BAR and converts it to a CPU physical address (B).  The address B
is stored in a struct resource and usually exposed via /proc/iomem.  When a
driver claims a device, it typically uses ioremap() to map physical address
B at a virtual address (C).  It can then pass C to interfaces like 
ioread32() to perform MMIO accesses to device registers.

If the device supports DMA, the driver sets up a buffer using kmalloc() or
a similar interface, which returns a virtual address (X).  The virtual
memory system maps X to a physical address (Y) in system RAM.  The driver
can use virtual address X to access the buffer, but the device itself
cannot because DMA doesn't go through the CPU virtual memory system.

In some simple systems, the device can do DMA directly to physical
address Y.  But in many others, there is special IOMMU hardware that
translates bus addresses, e.g., Z, to physical addresses.  This is part of
the reason for the DMA API: the driver can give a virtual address X to an
interface like dma_map_single(), which sets up any required IOMMU mapping
and returns the bus address Z.  The driver then tells the device to do DMA
to Z, and the IOMMU maps it to the buffer in system RAM.
