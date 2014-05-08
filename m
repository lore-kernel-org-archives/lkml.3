Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaEHLhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 07:37:06 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:57062 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaEHLhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 07:37:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-doc@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Magnus Damm <damm@opensource.se>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 3/5] sh/PCI: Pass GAPSPCI_DMA_BASE CPU address to dma_declare_coherent_memory()
Date: Thu, 08 May 2014 13:36:26 +0200
Message-ID: <7530420.5q1IGMpiC3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140507231822.GA4951@google.com>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com> <4271645.KYLAoYxC5v@wuerfel> <20140507231822.GA4951@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8t3lvELnvyGMv+ovVQVr/Qa5BPob1Ta4275N98dlvlv
 Sd/0axkd9M6M/EHJEnibeefWQHmbNCLwTxV9KuAMNKBChoSPqr
 pwNJusBdJ42KdgVb6tRuHJ7I4LCC1o9qBvCo275sXQIOszsuHM
 vAts0E7MNxZt87IRCYbTUwQsoHOyBFeIVrSnf50PESQceRF1wq
 Vpzz8Go9vI1I6xYAnQk2sUeTv8A57A/Yggp59J4pcqRVwlMxju
 NopicF+PLc6DqXLg/TsWDWcrRw/jM6EuVaZ/A1TxN1vRxLXmJO
 x1nmY10YeIeXoxv7Eny+FHT/pLXFm6cdiRJ9m4rneWyBEYHNv1
 CTuK2717dwQ1b83uhl5Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 May 2014 17:18:22 Bjorn Helgaas wrote:
> [+cc Magnus, linux-sh (sorry, I forgot to tell stgit to cc you)]
> 
> On Wed, May 07, 2014 at 10:15:10AM +0200, Arnd Bergmann wrote:
> > On Wednesday 07 May 2014 09:55:16 Arnd Bergmann wrote:
> > > On Tuesday 06 May 2014 16:48:33 Bjorn Helgaas wrote:
> > > > @@ -51,8 +53,12 @@ static void gapspci_fixup_resources(struct pci_dev *dev)
> > > >                 /*
> > > >                  * Redirect dma memory allocations to special memory window.
> > > >                  */
> > > > +               region.start = GAPSPCI_DMA_BASE;
> > > > +               region.end = GAPSPCI_DMA_BASE + GAPSPCI_DMA_SIZE - 1;
> > > > +               res.flags = IORESOURCE_MEM;
> > > > +               pcibios_bus_to_resource(dev->bus, &res, &region);
> > > >                 BUG_ON(!dma_declare_coherent_memory(&dev->dev,
> > > > -                                               GAPSPCI_DMA_BASE,
> > > > +                                               res->start,
> > > >                                                 GAPSPCI_DMA_BASE,
> > > >                                                 GAPSPCI_DMA_SIZE,
> > > >                                                 DMA_MEMORY_MAP |
> > > 
> > > Not sure if this is an improvement. I understand the intention, but
> > > it's actually possible for the offset to be different both ways:
> > > 
> > > Your patch applies the outbound mem_offset that was provided when
> > > registering the MMIO resource for the PCI host bridge. What the driver
> > > needs instead is the inbound DMA offset that gets applied by some
> > > host bridges that don't have a 1:1 mapping but also don't have an
> > > IOMMU.
> 
> I don't understand where the inbound DMA offset comes into play.  As I
> understand it, we're talking about a region of memory on the PCI bus,
> not in system RAM, and there are two ways to access it: (1) the CPU
> makes MMIO accesses to it, and (2) the device makes DMA accesses to
> it.

I was actually assuming that it's in system RAM but happens to have
some property that lets PCI devices access it coherently.

Your explanation also seems plausible, I have no idea which one is
true.

> The CPU accesses go through the host bridge MMIO aperture and will
> have the outbound mem_offset applied to them.  The DMA accesses are
> handled by the device itself and there's no host bridge or IOMMU or
> inbound DMA offset involved.
> 
> I think there are two reasonable ways a PCI driver could use
> dma_declare_coherent_memory():
> 
>   1) The bus address of the region might be in a BAR.  In that case,
>   it should pass pci_resource_start() (the CPU phys_addr_t) as the
>   first address, and pci_bus_address(pci_resource_start()) (the bus
>   dma_addr_t) as the second.
> 
>   2) The bus address of the region might be discovered from the device
>   in some non-standard way.  In this case, the driver reads the bus
>   address dma_addr_t directly from the device, and it should use
>   something like the pcibios_bus_to_resource() code I proposed to find
>   the CPU phys_addr_t.
> 
> For this platform, all the addresses are hard-coded and there is no
> outbound MMIO offset, so we can't tell which to use and in this
> system, it doesn't matter if we do anything at all.

Based on your initial assumption, this all is correct.

> The only reason I would make a change here is because the current code
> cannot be safely copied (another driver might be used in systems where
> the host bridge does have an outbound MMIO offset).  If we make this
> code use either strategy, it would be a clue to future users that they
> should not assume the physical address is the same as the bus address.
> 
> I changed the patch (below) to add a comment and to use the first
> strategy (though there isn't an actual BAR, so we can't do it exactly
> that way).

Ok.

> > > We know that on this particular platform, both are zero, so
> > > the original code works and it will keep working with your change,
> > > but I think it's a mistake anyway. I have seen both kinds of offsets
> > > in the past on real machines, but I am not aware of any where they
> > > are both nonzero and have the same value.
> > 
> > Hmm, looking at it again, it seem even weirder: the address we register
> > for DMA allocations is the same that gets passed into the PCI host
> > for MMIO resources. Something is very strange here. Still, I'd rather
> > not touch it at all, whatever it does.
> 
> It's definitely strange.  It looks to me like the memory on the device
> takes up the entire 32KB host bridge MMIO aperture.  I don't know what
> driver uses this, but the device must be programmed via I/O ports,
> which sort of makes sense given the previous lines in this quirk that
> set the BAR1 resource to be in the I/O aperture.

>From what I can tell, the only device on the PCI bus is an ethernet
adapter with the 8139too configured into MMIO mode (the driver as well
as the hardware supports both PIO and MMIO modes).

The gapspci_fixup_resources() in arch/sh/drivers/pci/fixups-dreamcast.c
seems to manually adjust MMIO BAR to point to the correct place, which
is probably required because the MMIO aperture provided is fake.


> sh/PCI: Pass GAPSPCI_DMA_BASE CPU & bus address to dma_declare_coherent_memory()
> 
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> dma_declare_coherent_memory() needs both the CPU physical address and the
> bus address of the device memory.  They are the same on this platform, but
> in general we should use pcibios_resource_to_bus() to account for any
> address translation done by the PCI host bridge.
> 
> This makes no difference on Dreamcast, but is safer if the usage is copied
> to future drivers.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: Magnus Damm <damm@opensource.se>
> CC: linux-sh@vger.kernel.org

Unless Magnus or someone else is able to clarify where GAPSPCI_DMA_BASE
actually is in the system (on the CPU bus or the PCI bus), your patch
does help anyone copying this code to a driver that needs it for coherent
memory on the PCI bus.

Acked-by: Arnd Bergmann <arnd@arndb.de>

> ---
>  arch/sh/drivers/pci/fixups-dreamcast.c |   18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/sh/drivers/pci/fixups-dreamcast.c b/arch/sh/drivers/pci/fixups-dreamcast.c
> index d6cde700e316..f22127f966ce 100644
> --- a/arch/sh/drivers/pci/fixups-dreamcast.c
> +++ b/arch/sh/drivers/pci/fixups-dreamcast.c
> @@ -31,6 +31,8 @@
>  static void gapspci_fixup_resources(struct pci_dev *dev)
>  {
>  	struct pci_channel *p = dev->sysdata;
> +	struct resource res;
> +	struct pci_bus_region region;
>  
>  	printk(KERN_NOTICE "PCI: Fixing up device %s\n", pci_name(dev));
>  
> @@ -50,11 +52,21 @@ static void gapspci_fixup_resources(struct pci_dev *dev)
>  
>  		/*
>  		 * Redirect dma memory allocations to special memory window.
> +		 *
> +		 * If this GAPSPCI region were mapped by a BAR, the CPU
> +		 * phys_addr_t would be pci_resource_start(), and the bus
> +		 * address would be pci_bus_address(pci_resource_start()).
> +		 * But apparently there's no BAR mapping it, so we just
> +		 * "know" its CPU address is GAPSPCI_DMA_BASE.
>  		 */
> +		res.start = GAPSPCI_DMA_BASE;
> +		res.end = GAPSPCI_DMA_BASE + GAPSPCI_DMA_SIZE - 1;
> +		res.flags = IORESOURCE_MEM;
> +		pcibios_resource_to_bus(dev, &region, &resource);
>  		BUG_ON(!dma_declare_coherent_memory(&dev->dev,
> -						GAPSPCI_DMA_BASE,
> -						GAPSPCI_DMA_BASE,
> -						GAPSPCI_DMA_SIZE,
> +						res.start,
> +						region.start,
> +						resource_size(&res),
>  						DMA_MEMORY_MAP |
>  						DMA_MEMORY_EXCLUSIVE));
>  		break;

