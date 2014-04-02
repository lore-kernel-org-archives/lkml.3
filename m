Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbaDBLt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:49:29 -0400
Received: from queue01c.mail.zen.net.uk ([212.23.3.237]:52891 "EHLO
	queue01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559AbaDBLt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:49:27 -0400
X-Greylist: delayed 3955 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2014 07:49:27 EDT
Message-ID: <1396435290.3554.52.camel@linaro1.home>
Subject: Re: Bug(?) in patch "arm64: Implement coherent DMA API based on
 swiotlb"
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Date: Wed, 02 Apr 2014 11:41:30 +0100
In-Reply-To: <20140402092032.GB31892@arm.com>
References: <20140331175230.GA7480@arm.com>
	 <1396368657.3681.17.camel@linaro1.home> <20140401172939.GG20061@arm.com>
	 <1396428722.3554.20.camel@linaro1.home> <20140402092032.GB31892@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 10:20 +0100, Catalin Marinas wrote:
> On Wed, Apr 02, 2014 at 09:52:02AM +0100, Jon Medhurst (Tixy) wrote:
> > On Tue, 2014-04-01 at 18:29 +0100, Catalin Marinas wrote:
> > > On Tue, Apr 01, 2014 at 05:10:57PM +0100, Jon Medhurst (Tixy) wrote:
> > > > On Mon, 2014-03-31 at 18:52 +0100, Catalin Marinas wrote:
> > > > > +__dma_inv_range:
> > > > > +	dcache_line_size x2, x3
> > > > > +	sub	x3, x2, #1
> > > > > +	bic	x0, x0, x3
> > > > > +	bic	x1, x1, x3
> > > > 
> > > > Why is the 'end' value in x1 above rounded down to be cache aligned?
> > > > This means the cache invalidate won't include the cache line containing
> > > > the final bytes of the region, unless it happened to already be cache
> > > > line aligned. This looks especially suspect as the other two cache
> > > > operations added in the same patch (below) don't do that.
> > > 
> > > Cache invalidation is destructive, so we want to make sure that it
> > > doesn't affect anything beyond x1. But you are right, if either end of
> > > the buffer is not cache line aligned it can get it wrong. The fix is to
> > > use clean+invalidate on the unaligned ends:
> > 
> > Like the ARMv7 implementation does :-) However, I wonder, is it possible
> > for the Cache Writeback Granule (CWG) to come into play? If the CWG of
> > further out caches was bigger than closer (to CPU) caches then it would
> > cause data corruption. So for these region ends, should we not be using
> > the CWG size, not the minimum D cache line size? On second thoughts,
> > that wouldn't be safe either in the converse case where the CWG of a
> > closer cache was bigger. So we would need to first use minimum cache
> > line size to clean a CWG sized region, then invalidate cache lines by
> > the same method.
> 
> CWG gives us the maximum size (of all cache levels in the system, even
> on a different CPU for example in big.LITTLE configurations) that would
> be evicted by the cache operation. So we need small loops of Dmin size
> that go over the bigger CWG (and that's guaranteed to be at least Dmin).

Yes, that's what I was getting at.

> 
> > But then that leaves a time period where a write can
> > happen between the clean and the invalidate, again leading to data
> > corruption. I hope all this means I've either got rather confused or
> > that that cache architectures are smart enough to automatically cope. 
> 
> You are right. I think having unaligned DMA buffers for inbound
> transfers is pointless. We can avoid losing data written by another CPU
> in the same cache line but, depending on the stage of the DMA transfer,
> it can corrupt the DMA data.
> 
> I wonder whether it's easier to define the cache_line_size() macro to
> read CWG

That won't work, the stride of cache operations needs to be the
_minimum_ cache line size, otherwise we might skip over some cache lines
and not flush them. (We've been hit before by bugs caused by the fact
that big.LITTLE systems report different minimum i-cache line sizes
depend on whether you execute on the big or LITTLE cores [1], we need
the 'real' minimum otherwise things go horribly wrong.)

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149950.html

>  and assume that the DMA buffers are always aligned,

We can't assume the region in any particular DMA transfer is cache
aligned, but I agree, that if multiple actors were operating on adjacent
memory locations in the same cache line, without implementing their own
coordination then there's nothing the low level DMA code can do to avoid
data corruption from cache cleaning.

We at least need to make sure that the memory allocation functions used
for DMA buffers return regions of whole CWG size, to avoid unrelated
buffers corrupting each other. If I have correctly read
__dma_alloc_noncoherent and the functions it calls, then it looks like
buffers are actually whole pages, so that's not a problem.

>  ignoring
> the invalidation of the unaligned boundaries. This wouldn't be much
> different from your scenario where the shared cache line is written
> (just less likely to trigger but still a bug, so I would rather notice
> this early).
> 
> The ARMv7 code has a similar issue, it performs clean&invalidate on the
> unaligned start but it doesn't move r0, so it goes into the main loop
> invalidating the same cache line again.

Yes, and as it's missing a dsb could also lead to the wrong behaviour if
the invalidate was reordered to execute prior to the clean+invalidate on
the same line. I just dug into git history to see if I could find a clue
as to how the v7 code came to look like it does, but I see that it's
been like that since the day it was submitted in 2007, by a certain
Catalin Marinas ;-)

-- 
Tixy

