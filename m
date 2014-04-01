Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaDARaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:30:14 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:59282 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751255AbaDARaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:30:12 -0400
Date: Tue, 1 Apr 2014 18:29:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: Bug(?) in patch "arm64: Implement coherent DMA API based on
 swiotlb" (was Re: [GIT PULL] arm64 patches for 3.15)
Message-ID: <20140401172939.GG20061@arm.com>
References: <20140331175230.GA7480@arm.com>
 <1396368657.3681.17.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396368657.3681.17.camel@linaro1.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 05:10:57PM +0100, Jon Medhurst (Tixy) wrote:
> On Mon, 2014-03-31 at 18:52 +0100, Catalin Marinas wrote:
> > The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:
> > 
> >   Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-upstream
> > 
> > for you to fetch changes up to 196adf2f3015eacac0567278ba538e3ffdd16d0e:
> > 
> >   arm64: Remove pgprot_dmacoherent() (2014-03-24 10:35:35 +0000)
> 
> I may have spotted a bug in commit 7363590d2c46 (arm64: Implement
> coherent DMA API based on swiotlb), see my inline comment below...
> 
> [...]
> > diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
> > index 1ea9f26..97fcef5 100644
> > --- a/arch/arm64/mm/cache.S
> > +++ b/arch/arm64/mm/cache.S
> > @@ -166,3 +166,81 @@ ENTRY(__flush_dcache_area)
> >  	dsb	sy
> >  	ret
> >  ENDPROC(__flush_dcache_area)
> > +
> > +/*
> > + *	__dma_inv_range(start, end)
> > + *	- start   - virtual start address of region
> > + *	- end     - virtual end address of region
> > + */
> > +__dma_inv_range:
> > +	dcache_line_size x2, x3
> > +	sub	x3, x2, #1
> > +	bic	x0, x0, x3
> > +	bic	x1, x1, x3
> 
> Why is the 'end' value in x1 above rounded down to be cache aligned?
> This means the cache invalidate won't include the cache line containing
> the final bytes of the region, unless it happened to already be cache
> line aligned. This looks especially suspect as the other two cache
> operations added in the same patch (below) don't do that.

Cache invalidation is destructive, so we want to make sure that it
doesn't affect anything beyond x1. But you are right, if either end of
the buffer is not cache line aligned it can get it wrong. The fix is to
use clean+invalidate on the unaligned ends:

diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index c46f48b33c14..6a26bf1965d3 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -175,10 +175,17 @@ ENDPROC(__flush_dcache_area)
 __dma_inv_range:
 	dcache_line_size x2, x3
 	sub	x3, x2, #1
-	bic	x0, x0, x3
+	tst	x1, x3				// end cache line aligned?
 	bic	x1, x1, x3
-1:	dc	ivac, x0			// invalidate D / U line
-	add	x0, x0, x2
+	b.eq	1f
+	dc	civac, x1			// clean & invalidate D / U line
+1:	tst	x0, x3				// start cache line aligned?
+	bic	x0, x0, x3
+	b.eq	2f
+	dc	civac, x0			// clean & invalidate D / U line
+	b	3f
+2:	dc	ivac, x0			// invalidate D / U line
+3:	add	x0, x0, x2
 	cmp	x0, x1
 	b.lo	1b
 	dsb	sy

-- 
Catalin
