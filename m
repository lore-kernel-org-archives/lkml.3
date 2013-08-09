Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031404Ab3HIWme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:42:34 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:49065 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031355Ab3HIWmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:42:32 -0400
Date: Fri, 9 Aug 2013 16:42:28 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        adam radford <aradford@gmail.com>
Subject: Re: [PATCH v2] tile: support LSI MEGARAID SAS HBA hybrid dma_ops
Message-ID: <20130809224228.GA31372@google.com>
References: <52012B96.9000207@tilera.com>
 <201308061702.r76H2ORe011248@farm-0021.internal.tilera.com>
 <CAErSpo57cmg2ynLLLZw0yXH5Q1B0MZBdqSgFXUu2NpS=8W6Y2g@mail.gmail.com>
 <5203CB8E.60509@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5203CB8E.60509@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 12:47:10PM -0400, Chris Metcalf wrote:
> On 8/6/2013 1:48 PM, Bjorn Helgaas wrote:
> > [+cc Myron, Adam]
> >
> > On Fri, Aug 2, 2013 at 10:24 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> >> According to LSI,
> >> the firmware is not fully functional yet. This change implements a
> >> kind of hybrid dma_ops to support this.
> >>
> >> Note that on most other platforms, the 64-bit DMA addressing space is the
> >> same as the 32-bit DMA space and they overlap the physical memory space.
> >> No special arrangement is needed to support this kind of mixed DMA
> >> capability.  On TILE-Gx, the 64-bit DMA space is completely separate
> >> from the 32-bit DMA space.
> > Help me understand what's going on here.  My understanding is that on
> > typical systems, the 32-bit DMA space is a subset of the 64-bit DMA
> > space.  In conventional PCI, "a master that supports 64-bit addressing
> > must generate a SAC, instead of a DAC, when the upper 32 bits of the
> > address are zero" (PCI spec r3.0, sec 3.9).  PCIe doesn't have
> > SAC/DAC, but it has both 32-bit and 64-bit address headers and has a
> > similar requirement: "For Addresses below 4GB, Requesters must use the
> > 32-bit format" (PCIe spec r3.0, sec 2.2.4.1).
> >
> > Those imply to me that the 0-4GB region of the 64-bit DMA space must
> > be identical to the 0-4GB 32-bit DMA space, and in fact, the receiver
> > of a transaction shouldn't be able to distinguish them.
> >
> > But it sounds like something's different on TILE-Gx?  Does it
> > translate bus addresses to physical memory addresses based on the type
> > of the transaction (SAC vs DAC, or 32-bit vs 64-bit header) in
> > addition to the address?  Even if it does, the spec doesn't allow a
> > DAC cycle or a 64-bit header where the 32 high-order bits are zero, so
> > it shouldn't matter.
> 
> No, we don't translate based on the type of the transaction. Using
> "DMA space" in the commit message was probably misleading. What's
> really going on is different DMA windows. 32-bit DMA has the
> obvious naive implementation where [0,4GB] in DMA space maps to
> [0,4GB] in PA space.  However, for 64-bit DMA, we use DMA
> addresses with a non-zero high 32 bits, in the [1TB,2TB] range,
> but map the results down to PA [0,1TB] using our IOMMU.

I guess this means devices can DMA to physical addresses [0,3GB]
using either 32-bit bus addresses in the [0,3GB] range or 64-bit bus
addresses in the [1TB,1TB+3GB] range, right?

> We did consider having the 64-bit DMA window be [0,1TB] and map
> directly to PA space, like the 32-bit window. But this design
> suffers from the “PCI hole” problem. Basically, the BAR space is
> usually under 4GB (it occupies the range [3GB, 4GB] on tilegx) and
> the host bridge uses negative decoding in passing DMA traffic
> upstream. That is, DMA traffic with target address in [3GB, 4GB]
> are not passed to the host memory. This means that the same amount
> of physical memory as the BAR space cannot be used for DMA
> purpose. And because it is not easy avoid this region in
> allocating DMA memory, the kernel is simply told to not use this
> chunk of PA at all, so it is wasted.

OK, so physical memory in the [3GB,4GB] range is unreachable via DMA
as you describe.  And even if DMA *could* reach it, the CPU couldn't
see it because CPU accesses to that range would go to PCI for the
memory-mapped BAR space, not to memory.

But I can't figure out why Tile needs to do something special.  I
think other arches handle the PCI hole for MMIO space the same way.

I don't know if other arches alias the [0,3GB] physical address
range in both 32-bit and 64-bit DMA space like you do, but if that's
part of the problem, it seems like you could easily avoid the
aliasing by making the 64-bit DMA space [1TB+4GB,2TB] instead of
[1TB,2TB].

> For the LSI device, the way we manage it is to ensure that the
> device’s streaming buffers and the consistent buffers come from
> different pools, with the latter using the under-4GB bounce
> buffers. Obviously, normal devices use the same buffer pool for
> both streaming and consistent, either under 4GB or the whole PA.

It seems like you could make your DMA space be the union of [0,3GB]
and [1TB+4GB,2TB], then use pci_set_dma_mask(dev, DMA_BIT_MASK(64))
and pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(32)) (I assume the
driver already sets those masks correctly if it works on other
arches).

> Given all of that, does this change make sense? I can certainly
> amend the commit description to include more commentary.

Obviously, I'm missing something.  I guess it really doesn't matter
because this is all arch code and I don't need to understand it, but
it does niggle at me somehow.

Bjorn

> >> Due to the use of the IOMMU, the 64-bit DMA
> >> space doesn't overlap the physical memory space.  On the other hand,
> >> the 32-bit DMA space overlaps the physical memory space under 4GB.
> >> The separate address spaces make it necessary to have separate dma_ops.
> >>
> >> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> >> ---
> >>  arch/tile/include/asm/dma-mapping.h | 10 +++++++---
> >>  arch/tile/kernel/pci-dma.c          | 40 ++++++++++++++++++++++++++++---------
> >>  2 files changed, 38 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/arch/tile/include/asm/dma-mapping.h b/arch/tile/include/asm/dma-mapping.h
> >> index f2ff191..4a60059 100644
> >> --- a/arch/tile/include/asm/dma-mapping.h
> >> +++ b/arch/tile/include/asm/dma-mapping.h
> >> @@ -23,6 +23,7 @@
> >>  extern struct dma_map_ops *tile_dma_map_ops;
> >>  extern struct dma_map_ops *gx_pci_dma_map_ops;
> >>  extern struct dma_map_ops *gx_legacy_pci_dma_map_ops;
> >> +extern struct dma_map_ops *gx_hybrid_pci_dma_map_ops;
> >>
> >>  static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> >>  {
> >> @@ -44,12 +45,12 @@ static inline void set_dma_offset(struct device *dev, dma_addr_t off)
> >>
> >>  static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
> >>  {
> >> -       return paddr + get_dma_offset(dev);
> >> +       return paddr;
> >>  }
> >>
> >>  static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
> >>  {
> >> -       return daddr - get_dma_offset(dev);
> >> +       return daddr;
> >>  }
> >>
> >>  static inline void dma_mark_clean(void *addr, size_t size) {}
> >> @@ -88,7 +89,10 @@ dma_set_mask(struct device *dev, u64 mask)
> >>         struct dma_map_ops *dma_ops = get_dma_ops(dev);
> >>
> >>         /* Handle legacy PCI devices with limited memory addressability. */
> >> -       if ((dma_ops == gx_pci_dma_map_ops) && (mask <= DMA_BIT_MASK(32))) {
> >> +       if ((dma_ops == gx_pci_dma_map_ops ||
> >> +            dma_ops == gx_hybrid_pci_dma_map_ops ||
> >> +            dma_ops == gx_legacy_pci_dma_map_ops) &&
> >> +           (mask <= DMA_BIT_MASK(32))) {
> >>                 set_dma_ops(dev, gx_legacy_pci_dma_map_ops);
> >>                 set_dma_offset(dev, 0);
> >>                 if (mask > dev->archdata.max_direct_dma_addr)
> >> diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
> >> index b9fe80e..7e22e73 100644
> >> --- a/arch/tile/kernel/pci-dma.c
> >> +++ b/arch/tile/kernel/pci-dma.c
> >> @@ -357,7 +357,7 @@ static void *tile_pci_dma_alloc_coherent(struct device *dev, size_t size,
> >>
> >>         addr = page_to_phys(pg);
> >>
> >> -       *dma_handle = phys_to_dma(dev, addr);
> >> +       *dma_handle = addr + get_dma_offset(dev);
> >>
> >>         return page_address(pg);
> >>  }
> >> @@ -387,7 +387,7 @@ static int tile_pci_dma_map_sg(struct device *dev, struct scatterlist *sglist,
> >>                 sg->dma_address = sg_phys(sg);
> >>                 __dma_prep_pa_range(sg->dma_address, sg->length, direction);
> >>
> >> -               sg->dma_address = phys_to_dma(dev, sg->dma_address);
> >> +               sg->dma_address = sg->dma_address + get_dma_offset(dev);
> >>  #ifdef CONFIG_NEED_SG_DMA_LENGTH
> >>                 sg->dma_length = sg->length;
> >>  #endif
> >> @@ -422,7 +422,7 @@ static dma_addr_t tile_pci_dma_map_page(struct device *dev, struct page *page,
> >>         BUG_ON(offset + size > PAGE_SIZE);
> >>         __dma_prep_page(page, offset, size, direction);
> >>
> >> -       return phys_to_dma(dev, page_to_pa(page) + offset);
> >> +       return page_to_pa(page) + offset + get_dma_offset(dev);
> >>  }
> >>
> >>  static void tile_pci_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
> >> @@ -432,7 +432,7 @@ static void tile_pci_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
> >>  {
> >>         BUG_ON(!valid_dma_direction(direction));
> >>
> >> -       dma_address = dma_to_phys(dev, dma_address);
> >> +       dma_address -= get_dma_offset(dev);
> >>
> >>         __dma_complete_page(pfn_to_page(PFN_DOWN(dma_address)),
> >>                             dma_address & PAGE_OFFSET, size, direction);
> >> @@ -445,7 +445,7 @@ static void tile_pci_dma_sync_single_for_cpu(struct device *dev,
> >>  {
> >>         BUG_ON(!valid_dma_direction(direction));
> >>
> >> -       dma_handle = dma_to_phys(dev, dma_handle);
> >> +       dma_handle -= get_dma_offset(dev);
> >>
> >>         __dma_complete_pa_range(dma_handle, size, direction);
> >>  }
> >> @@ -456,7 +456,7 @@ static void tile_pci_dma_sync_single_for_device(struct device *dev,
> >>                                                 enum dma_data_direction
> >>                                                 direction)
> >>  {
> >> -       dma_handle = dma_to_phys(dev, dma_handle);
> >> +       dma_handle -= get_dma_offset(dev);
> >>
> >>         __dma_prep_pa_range(dma_handle, size, direction);
> >>  }
> >> @@ -558,21 +558,43 @@ static struct dma_map_ops pci_swiotlb_dma_ops = {
> >>         .mapping_error = swiotlb_dma_mapping_error,
> >>  };
> >>
> >> +static struct dma_map_ops pci_hybrid_dma_ops = {
> >> +       .alloc = tile_swiotlb_alloc_coherent,
> >> +       .free = tile_swiotlb_free_coherent,
> >> +       .map_page = tile_pci_dma_map_page,
> >> +       .unmap_page = tile_pci_dma_unmap_page,
> >> +       .map_sg = tile_pci_dma_map_sg,
> >> +       .unmap_sg = tile_pci_dma_unmap_sg,
> >> +       .sync_single_for_cpu = tile_pci_dma_sync_single_for_cpu,
> >> +       .sync_single_for_device = tile_pci_dma_sync_single_for_device,
> >> +       .sync_sg_for_cpu = tile_pci_dma_sync_sg_for_cpu,
> >> +       .sync_sg_for_device = tile_pci_dma_sync_sg_for_device,
> >> +       .mapping_error = tile_pci_dma_mapping_error,
> >> +       .dma_supported = tile_pci_dma_supported
> >> +};
> >> +
> >>  struct dma_map_ops *gx_legacy_pci_dma_map_ops = &pci_swiotlb_dma_ops;
> >> +struct dma_map_ops *gx_hybrid_pci_dma_map_ops = &pci_hybrid_dma_ops;
> >>  #else
> >>  struct dma_map_ops *gx_legacy_pci_dma_map_ops;
> >> +struct dma_map_ops *gx_hybrid_pci_dma_map_ops;
> >>  #endif
> >>  EXPORT_SYMBOL(gx_legacy_pci_dma_map_ops);
> >> +EXPORT_SYMBOL(gx_hybrid_pci_dma_map_ops);
> >>
> >>  #ifdef CONFIG_ARCH_HAS_DMA_SET_COHERENT_MASK
> >>  int dma_set_coherent_mask(struct device *dev, u64 mask)
> >>  {
> >>         struct dma_map_ops *dma_ops = get_dma_ops(dev);
> >>
> >> -       /* Handle legacy PCI devices with limited memory addressability. */
> >> -       if (((dma_ops == gx_pci_dma_map_ops) ||
> >> -           (dma_ops == gx_legacy_pci_dma_map_ops)) &&
> >> +       /* Handle hybrid PCI devices with limited memory addressability. */
> >> +       if ((dma_ops == gx_pci_dma_map_ops ||
> >> +            dma_ops == gx_hybrid_pci_dma_map_ops ||
> >> +            dma_ops == gx_legacy_pci_dma_map_ops) &&
> >>             (mask <= DMA_BIT_MASK(32))) {
> >> +               if (dma_ops == gx_pci_dma_map_ops)
> >> +                       set_dma_ops(dev, gx_hybrid_pci_dma_map_ops);
> >> +
> >>                 if (mask > dev->archdata.max_direct_dma_addr)
> >>                         mask = dev->archdata.max_direct_dma_addr;
> >>         }
> >> --
> >> 1.8.3.1
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com
> 
