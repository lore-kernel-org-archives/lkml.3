Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbaDBIwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:52:08 -0400
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:54825 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758036AbaDBIwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:52:05 -0400
Message-ID: <1396428722.3554.20.camel@linaro1.home>
Subject: Re: Bug(?) in patch "arm64: Implement coherent DMA API based on
 swiotlb" (was Re: [GIT PULL] arm64 patches for 3.15)
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Date: Wed, 02 Apr 2014 09:52:02 +0100
In-Reply-To: <20140401172939.GG20061@arm.com>
References: <20140331175230.GA7480@arm.com>
	 <1396368657.3681.17.camel@linaro1.home> <20140401172939.GG20061@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 18:29 +0100, Catalin Marinas wrote:
> On Tue, Apr 01, 2014 at 05:10:57PM +0100, Jon Medhurst (Tixy) wrote:
> > On Mon, 2014-03-31 at 18:52 +0100, Catalin Marinas wrote:
> > > The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:
> > > 
> > >   Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-upstream
> > > 
> > > for you to fetch changes up to 196adf2f3015eacac0567278ba538e3ffdd16d0e:
> > > 
> > >   arm64: Remove pgprot_dmacoherent() (2014-03-24 10:35:35 +0000)
> > 
> > I may have spotted a bug in commit 7363590d2c46 (arm64: Implement
> > coherent DMA API based on swiotlb), see my inline comment below...
> > 
> > [...]
> > > diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
> > > index 1ea9f26..97fcef5 100644
> > > --- a/arch/arm64/mm/cache.S
> > > +++ b/arch/arm64/mm/cache.S
> > > @@ -166,3 +166,81 @@ ENTRY(__flush_dcache_area)
> > >  	dsb	sy
> > >  	ret
> > >  ENDPROC(__flush_dcache_area)
> > > +
> > > +/*
> > > + *	__dma_inv_range(start, end)
> > > + *	- start   - virtual start address of region
> > > + *	- end     - virtual end address of region
> > > + */
> > > +__dma_inv_range:
> > > +	dcache_line_size x2, x3
> > > +	sub	x3, x2, #1
> > > +	bic	x0, x0, x3
> > > +	bic	x1, x1, x3
> > 
> > Why is the 'end' value in x1 above rounded down to be cache aligned?
> > This means the cache invalidate won't include the cache line containing
> > the final bytes of the region, unless it happened to already be cache
> > line aligned. This looks especially suspect as the other two cache
> > operations added in the same patch (below) don't do that.
> 
> Cache invalidation is destructive, so we want to make sure that it
> doesn't affect anything beyond x1. But you are right, if either end of
> the buffer is not cache line aligned it can get it wrong. The fix is to
> use clean+invalidate on the unaligned ends:

Like the ARMv7 implementation does :-) However, I wonder, is it possible
for the Cache Writeback Granule (CWG) to come into play? If the CWG of
further out caches was bigger than closer (to CPU) caches then it would
cause data corruption. So for these region ends, should we not be using
the CWG size, not the minimum D cache line size? On second thoughts,
that wouldn't be safe either in the converse case where the CWG of a
closer cache was bigger. So we would need to first use minimum cache
line size to clean a CWG sized region, then invalidate cache lines by
the same method. But then that leaves a time period where a write can
happen between the clean and the invalidate, again leading to data
corruption. I hope all this means I've either got rather confused or
that that cache architectures are smart enough to automatically cope. 

I also have a couple of comments on the specific changes below...

> 
> diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
> index c46f48b33c14..6a26bf1965d3 100644
> --- a/arch/arm64/mm/cache.S
> +++ b/arch/arm64/mm/cache.S
> @@ -175,10 +175,17 @@ ENDPROC(__flush_dcache_area)
>  __dma_inv_range:
>  	dcache_line_size x2, x3
>  	sub	x3, x2, #1
> -	bic	x0, x0, x3
> +	tst	x1, x3				// end cache line aligned?
>  	bic	x1, x1, x3
> -1:	dc	ivac, x0			// invalidate D / U line
> -	add	x0, x0, x2
> +	b.eq	1f
> +	dc	civac, x1			// clean & invalidate D / U line

That is actually cleaning the address one byte past the end of the
region, not sure it matters though because it is still within the same
minimum cache line sized region.

> +1:	tst	x0, x3				// start cache line aligned?
> +	bic	x0, x0, x3
> +	b.eq	2f
> +	dc	civac, x0			// clean & invalidate D / U line
> +	b	3f
> +2:	dc	ivac, x0			// invalidate D / U line
> +3:	add	x0, x0, x2
>  	cmp	x0, x1
>  	b.lo	1b

The above obviously also needs changing to branch to 3b

>  	dsb	sy
> 

-- 
Tixy

