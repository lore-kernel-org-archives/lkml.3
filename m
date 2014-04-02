Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbaDBJVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:21:06 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:40045 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755178AbaDBJVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:21:03 -0400
Date: Wed, 2 Apr 2014 10:20:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: Bug(?) in patch "arm64: Implement coherent DMA API based on
 swiotlb" (was Re: [GIT PULL] arm64 patches for 3.15)
Message-ID: <20140402092032.GB31892@arm.com>
References: <20140331175230.GA7480@arm.com>
 <1396368657.3681.17.camel@linaro1.home>
 <20140401172939.GG20061@arm.com>
 <1396428722.3554.20.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396428722.3554.20.camel@linaro1.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 09:52:02AM +0100, Jon Medhurst (Tixy) wrote:
> On Tue, 2014-04-01 at 18:29 +0100, Catalin Marinas wrote:
> > On Tue, Apr 01, 2014 at 05:10:57PM +0100, Jon Medhurst (Tixy) wrote:
> > > On Mon, 2014-03-31 at 18:52 +0100, Catalin Marinas wrote:
> > > > +__dma_inv_range:
> > > > +	dcache_line_size x2, x3
> > > > +	sub	x3, x2, #1
> > > > +	bic	x0, x0, x3
> > > > +	bic	x1, x1, x3
> > > 
> > > Why is the 'end' value in x1 above rounded down to be cache aligned?
> > > This means the cache invalidate won't include the cache line containing
> > > the final bytes of the region, unless it happened to already be cache
> > > line aligned. This looks especially suspect as the other two cache
> > > operations added in the same patch (below) don't do that.
> > 
> > Cache invalidation is destructive, so we want to make sure that it
> > doesn't affect anything beyond x1. But you are right, if either end of
> > the buffer is not cache line aligned it can get it wrong. The fix is to
> > use clean+invalidate on the unaligned ends:
> 
> Like the ARMv7 implementation does :-) However, I wonder, is it possible
> for the Cache Writeback Granule (CWG) to come into play? If the CWG of
> further out caches was bigger than closer (to CPU) caches then it would
> cause data corruption. So for these region ends, should we not be using
> the CWG size, not the minimum D cache line size? On second thoughts,
> that wouldn't be safe either in the converse case where the CWG of a
> closer cache was bigger. So we would need to first use minimum cache
> line size to clean a CWG sized region, then invalidate cache lines by
> the same method.

CWG gives us the maximum size (of all cache levels in the system, even
on a different CPU for example in big.LITTLE configurations) that would
be evicted by the cache operation. So we need small loops of Dmin size
that go over the bigger CWG (and that's guaranteed to be at least Dmin).

> But then that leaves a time period where a write can
> happen between the clean and the invalidate, again leading to data
> corruption. I hope all this means I've either got rather confused or
> that that cache architectures are smart enough to automatically cope. 

You are right. I think having unaligned DMA buffers for inbound
transfers is pointless. We can avoid losing data written by another CPU
in the same cache line but, depending on the stage of the DMA transfer,
it can corrupt the DMA data.

I wonder whether it's easier to define the cache_line_size() macro to
read CWG and assume that the DMA buffers are always aligned, ignoring
the invalidation of the unaligned boundaries. This wouldn't be much
different from your scenario where the shared cache line is written
(just less likely to trigger but still a bug, so I would rather notice
this early).

The ARMv7 code has a similar issue, it performs clean&invalidate on the
unaligned start but it doesn't move r0, so it goes into the main loop
invalidating the same cache line again. If it was written by something
else, the information would be lost.

> I also have a couple of comments on the specific changes below...
> 
> > diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
> > index c46f48b33c14..6a26bf1965d3 100644
> > --- a/arch/arm64/mm/cache.S
> > +++ b/arch/arm64/mm/cache.S
> > @@ -175,10 +175,17 @@ ENDPROC(__flush_dcache_area)
> >  __dma_inv_range:
> >  	dcache_line_size x2, x3
> >  	sub	x3, x2, #1
> > -	bic	x0, x0, x3
> > +	tst	x1, x3				// end cache line aligned?
> >  	bic	x1, x1, x3
> > -1:	dc	ivac, x0			// invalidate D / U line
> > -	add	x0, x0, x2
> > +	b.eq	1f
> > +	dc	civac, x1			// clean & invalidate D / U line
> 
> That is actually cleaning the address one byte past the end of the
> region, not sure it matters though because it is still within the same
> minimum cache line sized region.

It shouldn't, there is a "bic x1, x1, x3" above and this dc only happens
if the address was unaligned.

> > +1:	tst	x0, x3				// start cache line aligned?
> > +	bic	x0, x0, x3
> > +	b.eq	2f
> > +	dc	civac, x0			// clean & invalidate D / U line
> > +	b	3f
> > +2:	dc	ivac, x0			// invalidate D / U line
> > +3:	add	x0, x0, x2
> >  	cmp	x0, x1
> >  	b.lo	1b
> 
> The above obviously also needs changing to branch to 3b

Good point.

(but I'm no longer convinced we need the hassle above ;))

-- 
Catalin
