Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3JBRcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:32:43 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:5693 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab3JBRcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:32:42 -0400
X-IronPort-AV: E=Sophos;i="4.90,1019,1371081600"; 
   d="scan'208";a="57052508"
Date: Wed, 2 Oct 2013 18:31:57 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v6 12/19] swiotlb: don't assume that io_tlb_start-io_tlb_end
 is coherent
In-Reply-To: <20130930155617.GS3106@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1310021826410.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com> <1380298207-29151-12-git-send-email-stefano.stabellini@eu.citrix.com> <20130930155617.GS3106@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Sep 2013, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 27, 2013 at 05:10:00PM +0100, Stefano Stabellini wrote:
> > The swiotlb code has appropriate calls to dma_mark_clean in place for
> > buffers passed to swiotlb_map_page as an argument. However it assumes
> > that the swiotlb bounce buffer (io_tlb_start-io_tlb_end) is already
> > coherent and doesn't need any calls to dma_mark_clean.
> > 
> > On ARM the swiotlb bounce buffer is not coherent (the memory is
> > writealloc while it should be bufferable) and therefore we need to call
> > dma_mark_clean appropriately on the bounce buffer code paths too.
> > 
> > Note that most architecures have an empty dma_mark_clean implementation
> > anyway.
> 
> The other architecture that uses swiotlb is IA64 and that does have
> an implementation where it touches on page attributes.
> 
> Which means I have to figure out why my HP zx6000 won't boot with 3.11 now :-(
> 

Now this is a very thorny issue.

Honestly I don't like the dma_mark_clean interface very much: it's one
big hammer, when we actually need some finesse to handle coherency.

For example on ARM some devices might not need the dma_mark_clean call,
while others do. Calling it all the times is at the very best
inefficient and incorrect at worst.

I am thinking of calling the original map/unmap_page functions instead
(arm_dma_map_page or arm_coherent_dma_map_page in the arm case).
However in order to do that I would need to add more __get_dma_ops calls in
both lib/swiotlb.c and drivers/xen/swiotlb-xen.c


> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  lib/swiotlb.c |   13 ++++++++++---
> >  1 files changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> > index 4e8686c..eb45d17 100644
> > --- a/lib/swiotlb.c
> > +++ b/lib/swiotlb.c
> > @@ -515,6 +515,7 @@ found:
> >  		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
> >  	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
> >  		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
> > +	dma_mark_clean(phys_to_virt(tlb_addr), size);
> >  
> >  	return tlb_addr;
> >  }
> > @@ -547,7 +548,10 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
> >  	 * First, sync the memory before unmapping the entry
> >  	 */
> >  	if (orig_addr && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
> > +	{
> > +		dma_mark_clean(phys_to_virt(tlb_addr), size);
> >  		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_FROM_DEVICE);
> > +	}
> >  
> >  	/*
> >  	 * Return the buffer to the free list by setting the corresponding
> > @@ -587,17 +591,20 @@ void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
> >  
> >  	switch (target) {
> >  	case SYNC_FOR_CPU:
> > -		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
> > +		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)) {
> > +			dma_mark_clean(phys_to_virt(tlb_addr), size);
> >  			swiotlb_bounce(orig_addr, tlb_addr,
> >  				       size, DMA_FROM_DEVICE);
> > +		}
> >  		else
> >  			BUG_ON(dir != DMA_TO_DEVICE);
> >  		break;
> >  	case SYNC_FOR_DEVICE:
> > -		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
> > +		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)) {
> >  			swiotlb_bounce(orig_addr, tlb_addr,
> >  				       size, DMA_TO_DEVICE);
> > -		else
> > +			dma_mark_clean(phys_to_virt(tlb_addr), size);
> > +		} else
> >  			BUG_ON(dir != DMA_FROM_DEVICE);
> >  		break;
> >  	default:
> > -- 
> > 1.7.2.5
> > 
> 
