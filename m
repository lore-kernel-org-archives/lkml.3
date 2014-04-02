Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbaDBLiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:38:16 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:32662 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758423AbaDBLiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:38:14 -0400
Date: Wed, 2 Apr 2014 12:37:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: Bug(?) in patch "arm64: Implement coherent DMA API based on
 swiotlb"
Message-ID: <20140402113750.GD31892@arm.com>
References: <20140331175230.GA7480@arm.com>
 <1396368657.3681.17.camel@linaro1.home>
 <20140401172939.GG20061@arm.com>
 <1396428722.3554.20.camel@linaro1.home>
 <20140402092032.GB31892@arm.com>
 <1396435290.3554.52.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396435290.3554.52.camel@linaro1.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 11:41:30AM +0100, Jon Medhurst (Tixy) wrote:
> On Wed, 2014-04-02 at 10:20 +0100, Catalin Marinas wrote:
> > On Wed, Apr 02, 2014 at 09:52:02AM +0100, Jon Medhurst (Tixy) wrote:
> > > But then that leaves a time period where a write can
> > > happen between the clean and the invalidate, again leading to data
> > > corruption. I hope all this means I've either got rather confused or
> > > that that cache architectures are smart enough to automatically cope. 
> > 
> > You are right. I think having unaligned DMA buffers for inbound
> > transfers is pointless. We can avoid losing data written by another CPU
> > in the same cache line but, depending on the stage of the DMA transfer,
> > it can corrupt the DMA data.
> > 
> > I wonder whether it's easier to define the cache_line_size() macro to
> > read CWG
> 
> That won't work, the stride of cache operations needs to be the
> _minimum_ cache line size, otherwise we might skip over some cache lines
> and not flush them. (We've been hit before by bugs caused by the fact
> that big.LITTLE systems report different minimum i-cache line sizes
> depend on whether you execute on the big or LITTLE cores [1], we need
> the 'real' minimum otherwise things go horribly wrong.)
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149950.html

Yes, I remember this. CWG should also be the same in a big.LITTLE
system.

> >  and assume that the DMA buffers are always aligned,
> 
> We can't assume the region in any particular DMA transfer is cache
> aligned, but I agree, that if multiple actors were operating on adjacent
> memory locations in the same cache line, without implementing their own
> coordination then there's nothing the low level DMA code can do to avoid
> data corruption from cache cleaning.
> 
> We at least need to make sure that the memory allocation functions used
> for DMA buffers return regions of whole CWG size, to avoid unrelated
> buffers corrupting each other. If I have correctly read
> __dma_alloc_noncoherent and the functions it calls, then it looks like
> buffers are actually whole pages, so that's not a problem.

It's not about dma_alloc but the streaming DMA API like dma_map_sg().

> >  ignoring
> > the invalidation of the unaligned boundaries. This wouldn't be much
> > different from your scenario where the shared cache line is written
> > (just less likely to trigger but still a bug, so I would rather notice
> > this early).
> > 
> > The ARMv7 code has a similar issue, it performs clean&invalidate on the
> > unaligned start but it doesn't move r0, so it goes into the main loop
> > invalidating the same cache line again.
> 
> Yes, and as it's missing a dsb could also lead to the wrong behaviour if
> the invalidate was reordered to execute prior to the clean+invalidate on
> the same line. I just dug into git history to see if I could find a clue
> as to how the v7 code came to look like it does, but I see that it's
> been like that since the day it was submitted in 2007, by a certain
> Catalin Marinas ;-)

I don't remember ;). But there are some rules about reordering of cache
line operations by MVA with regards to memory accesses. I have to check
whether they apply to other d-cache maintenance to the same address as
well.

I'll try to come up with another patch using CWG.

-- 
Catalin
