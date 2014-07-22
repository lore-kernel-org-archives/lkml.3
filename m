Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbaGVP4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:56:42 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:26928 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754795AbaGVP4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:56:41 -0400
Date: Tue, 22 Jul 2014 16:56:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Will Deacon <Will.Deacon@arm.com>, David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 5/5] arm64: Add atomic pool for non-coherent and CMA
 allocations.
Message-ID: <20140722155622.GL2219@arm.com>
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org>
 <1404324218-4743-6-git-send-email-lauraa@codeaurora.org>
 <20140718134343.GA4608@arm.com>
 <53CD9601.5070001@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CD9601.5070001@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:36:49PM +0100, Laura Abbott wrote:
> On 7/18/2014 6:43 AM, Catalin Marinas wrote:
> > On Wed, Jul 02, 2014 at 07:03:38PM +0100, Laura Abbott wrote:
> >> @@ -73,50 +124,56 @@ static void __dma_free_coherent(struct device *dev, size_t size,
> >>  				void *vaddr, dma_addr_t dma_handle,
> >>  				struct dma_attrs *attrs)
> >>  {
> >> +	bool freed;
> >> +	phys_addr_t paddr = dma_to_phys(dev, dma_handle);
> >> +
> >>  	if (dev == NULL) {
> >>  		WARN_ONCE(1, "Use an actual device structure for DMA allocation\n");
> >>  		return;
> >>  	}
> >>  
> >> -	if (IS_ENABLED(CONFIG_DMA_CMA)) {
> >> -		phys_addr_t paddr = dma_to_phys(dev, dma_handle);
> >>  
> >> -		dma_release_from_contiguous(dev,
> >> +	freed = dma_release_from_contiguous(dev,
> >>  					phys_to_page(paddr),
> >>  					size >> PAGE_SHIFT);
> >> -	} else {
> >> +	if (!freed)
> >>  		swiotlb_free_coherent(dev, size, vaddr, dma_handle);
> >> -	}
> >>  }
> > 
> > Is __dma_free_coherent() ever called in atomic context? If yes, the
> > dma_release_from_contiguous() may not like it since it tries to acquire
> > a mutex. But since we don't have the gfp flags here, we don't have an
> > easy way to know what to call.
> > 
> > So the initial idea of always calling __alloc_from_pool() for both
> > coherent/non-coherent cases would work better (but still with a single
> > shared pool, see below).
> 
> We should be okay
> 
> __dma_free_coherent -> dma_release_from_contiguous -> cma_release which
> bounds checks the CMA region before taking any mutexes unless I missed
> something.

Ah, good point. I missed the pfn range check in
dma_release_from_contiguous.

> The existing behavior on arm is to not allow non-atomic allocations to be
> freed atomic context when CMA is enabled so we'd be giving arm64 more
> leeway there.  Is being able to free non-atomic allocations in atomic
> context really necessary?

No. I was worried that an atomic coherent allocation (falling back to
swiotlb) would trigger some CMA mutex in atomic context on the freeing
path. But you are right, it shouldn't happen.

> >> +		page = dma_alloc_from_contiguous(NULL, nr_pages,
> >> +					get_order(atomic_pool_size));
> >> +	else
> >> +		page = alloc_pages(GFP_KERNEL, get_order(atomic_pool_size));
> > 
> > One problem here is that the atomic pool wouldn't be able to honour
> > GFP_DMA (in the latest kernel, CMA is by default in ZONE_DMA). You
> > should probably pass GFP_KERNEL|GFP_DMA here. You could also use the
> > swiotlb_alloc_coherent() which, with a NULL dev, assumes 32-bit DMA mask
> > but it still expects GFP_DMA to be passed.
> > 
> 
> I think I missed updating this to GFP_DMA. The only advantage I would see
> to using swiotlb_alloc_coherent vs. alloc_pages directly would be to
> allow the fallback to using a bounce buffer if __get_free_pages failed.
> I'll keep this as alloc_pages for now; it can be changed later if there
> is a particular need for swiotlb behavior.

That's fine. Since we don't have a device at this point, I don't see how
swiotlb could fall back to the bounce buffer.

Thanks.

-- 
Catalin
