Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3HBQNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:13:19 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:12676 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab3HBQND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:13:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,802,1367971200"; 
   d="scan'208";a="39079642"
Date: Fri, 2 Aug 2013 17:12:48 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>
Subject: Re: [PATCH RFC 7/8] swiotlb-xen: support autotranslate guests
In-Reply-To: <20130802123740.GI24540@konrad-lan.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1308021529090.4893@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1307311833040.4893@kaball.uk.xensource.com> <1375292732-7627-7-git-send-email-stefano.stabellini@eu.citrix.com> <20130802123740.GI24540@konrad-lan.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Aug 2013, Konrad Rzeszutek Wilk wrote:
> On Wed, Jul 31, 2013 at 06:45:31PM +0100, Stefano Stabellini wrote:
> > Support autotranslate guests in swiotlb-xen by keeping track of the
> > phys-to-bus and bus-to-phys mappings of the swiotlb buffer
> > (xen_io_tlb_start-xen_io_tlb_end).
> > 
> > Use a simple direct access on a pre-allocated array for phys-to-bus
> > queries. Use a red-black tree for bus-to-phys queries.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > CC: david.vrabel@citrix.com
> > ---
> >  drivers/xen/swiotlb-xen.c |  127 +++++++++++++++++++++++++++++++++++++++------
> >  1 files changed, 111 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> > index 353f013..c79ac88 100644
> > --- a/drivers/xen/swiotlb-xen.c
> > +++ b/drivers/xen/swiotlb-xen.c
> > @@ -38,32 +38,116 @@
> >  #include <linux/bootmem.h>
> >  #include <linux/dma-mapping.h>
> >  #include <linux/export.h>
> > +#include <linux/slab.h>
> > +#include <linux/spinlock_types.h>
> > +#include <linux/rbtree.h>
> >  #include <xen/swiotlb-xen.h>
> >  #include <xen/page.h>
> >  #include <xen/xen-ops.h>
> >  #include <xen/hvc-console.h>
> > +#include <xen/features.h>
> >  /*
> >   * Used to do a quick range check in swiotlb_tbl_unmap_single and
> >   * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
> >   * API.
> >   */
> >  
> > +#define NR_DMA_SEGS  ((xen_io_tlb_nslabs + IO_TLB_SEGSIZE - 1) / IO_TLB_SEGSIZE)
> >  static char *xen_io_tlb_start, *xen_io_tlb_end;
> >  static unsigned long xen_io_tlb_nslabs;
> >  /*
> >   * Quick lookup value of the bus address of the IOTLB.
> >   */
> >  
> > -static u64 start_dma_addr;
> > +struct xen_dma{
>                  ^
> Ahem! I think scripts/checkpath.pl would tell you about.
> 
> You did run checkpath.pl right :-)
> 
> The name is very generic. Xen DMA. Brings a lot of ideas around but none
> of them to do with tracking a tuple. Perhaps a name of 'xen_dma_entry'?
> 'xen_dma_node' ? 'xen_dma_info' ?

Thanks for the detailed review. I have made this and all the other
changes that you mentioned, except the ones commented below.


> > +	spin_lock(&xen_dma_lock);
> > +
> > +	while (n) {
> > +		e = rb_entry(n, struct xen_dma, rbnode);
> > +		if (e->dma_addr <= dma_addr && e->dma_addr + e->size > dma_addr) {
> 
> Shouldn't this check be for '==' not '<=' ?

Nope: e->dma_addr is the start address of one of the contiguous chucks of
memory of size (IO_TLB_SEGSIZE << IO_TLB_SHIFT). However
xen_swiotlb_map_page can be called asking for a smaller buffer. As a
result xen_phys_to_bus is going to be called passing dma addresses that
do not always match the beginning of a contiguous region.


> Hm, maybe I am not sure what this tree is suppose to do. Somehow I
> thought it was to keep a consistent mapping of phys and dma addresses.
> But this seems to be more of 'free' phys and dma addresses. In which
> case I think you need to change the name of the rb root node to have the
> word 'free' in it.

It keeps track of the bus to phys mappings.  It doesn't matter whether
the corresponding buffers are free or in use as long as the mapping is
valid.


> > +
> > +	offset = vaddr - xen_io_tlb_start;
> > +	nr_seg = offset / (IO_TLB_SEGSIZE << IO_TLB_SHIFT);
> > +
> > +	return xen_dma_seg[nr_seg].dma_addr + (paddr & ((IO_TLB_SEGSIZE << IO_TLB_SHIFT) - 1));
> >  }
> >  
> >  static phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
> >  {
> > -	return machine_to_phys(XMADDR(baddr)).paddr;
> > +	if (xen_feature(XENFEAT_auto_translated_physmap))
> 
> I am curios to how this will work with PVH x86 which is
> auto_translated_physmap, but maps the whole kernel in its IOMMU context.
> 
> Perhaps we should have some extra logic here? For guests that have IOMMU
> support and for those that don't?

I would avoid using the swiotlb altogether if an IOMMU is available.
Maybe we can pass a flag in xen_features.


> B/c in some way this could be used on x86 with VT-x + without an VT-d
> and PVH for dom0 I think.

Right, it could be a good fit for that.
We could spot whether Xen passes a certain flag in xen_features and
enable the swiotlb if we need it.


> > +		else
> > +			return dma->phys_addr + (baddr & ((IO_TLB_SEGSIZE << IO_TLB_SHIFT) - 1));
> > +	} else
> > +		return machine_to_phys(XMADDR(baddr)).paddr;
> >  }
> >  
> >  static dma_addr_t xen_virt_to_bus(void *address)
> > @@ -107,6 +191,9 @@ static int is_xen_swiotlb_buffer(dma_addr_t dma_addr)
> >  	unsigned long pfn = mfn_to_local_pfn(mfn);
> >  	phys_addr_t paddr;
> >  
> > +	if (xen_feature(XENFEAT_auto_translated_physmap))
> > +		return 1;
> > +
> 
> That does not look right to me. I think this would make PVH go bonk.

On PVH if an IOMMU is available we would never initialize the swiotlb
and we would never use this function.
If no IOMMUs are available and we initialized the swiotlb, then this
assumption is correct: all contiguous buffers used with
xen_swiotlb_sync_single and xen_unmap_single are swiotlb bounce buffers.


> > @@ -351,14 +444,15 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
> >  	 * we can safely return the device addr and not worry about bounce
> >  	 * buffering it.
> >  	 */
> > -	if (dma_capable(dev, dev_addr, size) &&
> > +	if (!xen_feature(XENFEAT_auto_translated_physmap) &&
> > +	    dma_capable(dev, dev_addr, size) &&
> >  	    !range_straddles_page_boundary(phys, size) && !swiotlb_force)
> >  		return dev_addr;
> 
> I am returning back to PVH on these and just not sure what the impact
> is. Mukesh, thoughts?

Same as before: any dma_capable and range_straddles_page_boundary checks
on a random buffer are meaningless for XENFEAT_auto_translated_physmap
guests (we don't know the p2m mapping of a given page and that mapping
might be transient).
It's best to avoid them altogether and take the slow path.

It should have no impact for PVH today though: PVH guests should just
assume that an IOMMU is present and avoid initializing the swiotlb for
now.  If we want to give them a backup option in case no IOMMU is
available, then we can come back to this later.


> >  	/*
> >  	 * Oh well, have to allocate and map a bounce buffer.
> >  	 */
> > -	map = swiotlb_tbl_map_single(dev, start_dma_addr, phys, size, dir);
> > +	map = swiotlb_tbl_map_single(dev, xen_dma_seg[0].dma_addr, phys, size, dir);
> 
> At 0? Not some index?

Right, I agree with you, I doesn't make sense to me either.
However the code does exactly the same thing that was done before. It's
just a naming change.


> >  	if (map == SWIOTLB_MAP_ERROR)
> >  		return DMA_ERROR_CODE;
> >  
> > @@ -494,10 +588,11 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
> >  		dma_addr_t dev_addr = xen_phys_to_bus(paddr);
> >  
> >  		if (swiotlb_force ||
> > +		    xen_feature(XENFEAT_auto_translated_physmap) ||
> >  		    !dma_capable(hwdev, dev_addr, sg->length) ||
> >  		    range_straddles_page_boundary(paddr, sg->length)) {
> >  			phys_addr_t map = swiotlb_tbl_map_single(hwdev,
> > -								 start_dma_addr,
> > +								 xen_dma_seg[0].dma_addr,
> 
> I am not sure I understand the purpose of 'xen_dma_seg'. Could you
> clarify that please?

xen_dma_seg is an array of struct xen_dma that keeps track of the phys
to bus mappings. Each entry is (IO_TLB_SEGSIZE << IO_TLB_SHIFT) bytes,
except for the last one that could be smaller. Getting the dma address
corresponding to a physical address within xen_io_tlb_start -
xen_io_tlb_end is just a matter of calculating the index in the array,
see xen_phys_to_bus.

Also the bus_to_phys tree is conveniently built upon these pre-allocated
xen_dma_seg entries.
