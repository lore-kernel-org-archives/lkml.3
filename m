Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaJ1QHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:07:39 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:49836 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaJ1QHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:07:37 -0400
Date: Tue, 28 Oct 2014 16:07:29 +0000
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
Message-ID: <20141028160729.GH29706@arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
 <1414496662-25202-2-git-send-email-will.deacon@arm.com>
 <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Oct 28, 2014 at 03:30:43PM +0000, Linus Torvalds wrote:
> On Tue, Oct 28, 2014 at 4:44 AM, Will Deacon <will.deacon@arm.com> wrote:
> > This patch fixes the problem by incrementing addr by the PAGE_SIZE
> > before breaking out of the loop on batch failure.
> 
> This patch seems harmless and right, unlike the other one.

Yes; the other patch was more of a discussion point, as I was really
struggling to solve the problem without changing arch code. It was also
broken, as you discovered.

> I'd be ok with changing the *generic* code to do the "update start/end
> pointers in the mmu_gather structure", but then it really has to be
> done in *generic* code. Move your arm64 start/end updates to
> include/asm-generic/tlb.h, and change the initialization of start/end
> entirely. Right now we initialize those things to the maximal range
> (see tlb_gather_mmu()), and the arm64 logic seems to be to initialize
> them to TASK_SIZE/0 respectively and then update start/end as you add
> pages, so that you get the minimal range.
> 
> But because of this arm64 confusion (the "minimal range" really is
> *not* how this is designed to work), the current existing
> tlb_gather_mmu() does the wrong initialization.
> 
> In other words: my argument is that right now the arm64 code is just
> *wrong*. I'd be ok with making it the right thing to do, but if so, it
> needs to be made generic.

Ok, that's useful, thanks. Out of curiosity, what *is* the current intention
of __tlb_remove_tlb_entry, if start/end shouldn't be touched by
architectures? Is it just for the PPC hash thing?

> Are there any actual advantages to teh whole "minimal range" model? It
> adds overhead and complexity, and the only case where it would seem to
> be worth it is for benchmarks that do mmap/munmap in a loop and then
> only map a single page. Normal loads don't tend to have those kinds of
> "minimal range is very different from whole range" cases. Do you have
> a real case for why it does that minimal range thing.

I was certainly seeing this issue trigger regularly when running firefox,
but I'll need to dig and find out the differences in range size.

> Because if you don't have a real case, I'd really suggest you get rid
> of all the arm64 games with start/end. That still leaves this one
> patch the correct thing to do (because even without the start/end
> games the "need_flush" flag goes with the range, but it makes the
> second patch a complete non-issue.

Since we have hardware broadcasting of TLB invalidations on ARM, it is
in our interest to keep the number of outstanding operations as small as
possible, particularly on large systems where we don't get the targetted
shootdown with a single message that you can perform using IPIs (i.e.
you can only broadcast to all or no CPUs, and that happens for each pte).

Now, what I'd actually like to do is to keep track of discrete ranges,
so that we can avoid sending a TLB invalidation for each PAGE_SIZE region
of a huge-page mapping. That information is lost with our current minimal
range scheme and it was whilst I was thinking about this that I noticed
we were getting passed negative ranges with the current implementation.

> If you *do* have a real case, I think you need to modify your second patch to:
> 
>  - move the arm start/end updates from tlb_flush/tlb_add_flush to asm-generic
> 
>  - make tlb_gather_mmu() initialize start/end to TASK_SIZE/0 the same
> way your tlb_flush does (so that the subsequent min/max games work).
> 
> so that *everybody* does the start/end games. I'd be ok with that.

I'll try and come up with something which addresses the above, and we can
go from there.

> What I'm not ok with is arm64 using the generic TLB gather way in odd
> ways that then breaks code and results in things like your 2/2 patch
> that fixes ARM64 but breaks x86.

Understood, that certainly wasn't my intention.

Cheers,

Will
