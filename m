Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaKFSiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:38:21 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:54150 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaKFSiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:38:18 -0500
Date: Thu, 6 Nov 2014 18:38:08 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <Will.Deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
Message-ID: <20141106183808.GH19702@e104818-lin.cambridge.arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
 <1414496662-25202-2-git-send-email-will.deacon@arm.com>
 <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
 <CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
 <20141029194738.GA29911@arm.com>
 <20141104142955.GA24816@e104818-lin.cambridge.arm.com>
 <CA+55aFzBggoXtNXQeng5d_mRoDnaMBE5Y+URs+PHR67nUpMtaw@mail.gmail.com>
 <20141106135740.GC19702@e104818-lin.cambridge.arm.com>
 <CA+55aFzQM-yvvXYENiviLBm0=jiZoO7xPmz5mLowuTb-Pb8e6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzQM-yvvXYENiviLBm0=jiZoO7xPmz5mLowuTb-Pb8e6Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 05:53:58PM +0000, Linus Torvalds wrote:
> On Thu, Nov 6, 2014 at 5:57 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > Anyway, even without special "leaf" operations, it would be useful to
> > make the distinction between unmap_vmas() and free_pgtables() with
> > regards to the ranges tracked by mmu_gather. For the former, tlb_flush()
> > needs to flush the range in PAGE_SIZE increments (assuming a mix of
> > small and huge pages). For the latter, PMD_SIZE increments would be
> > enough.
> 
> Why woyuld you *ever* care about the increments?

Sorry, I wasn't clear enough about the "increments" part. I agreed with
not using end = start + PMD_SIZE/PAGE_SIZE from your previous email
already.

The flush_tlb_range() implementation on ARM(64) uses a loop that goes
over the given range in PAGE_SIZE increments. This is fine and even
optimal when we flush the PTEs. But it could be even faster when we go
over the same range again and only need to flush the page table cache
(PMD/PUD/PGD). A new flush_tlb_table_range() function could loop in
PMD_SIZE increments. That's an arm64-only implementation of the TLB
range flushing, I'm not suggesting the PAGE_SIZE/PMD_SIZE increments
when setting mmu_gather.end at all.

> Quite frankly, I think even the PAGE_SIZE thing is just (a) stupid and
> (b) misleading.
> 
> It might actually be better to instead of
> 
>     tlb->end = max(tlb->end, address + PAGE_SIZE);
> 
> it might as well be a simpler
> 
>     tlb->end = max(tlb->end, address+1)

I fully agree.

One minor drawback is that the TLB invalidation instructions on ARM work
on pfn and end >> PAGE_SHIFT would make it equal to start. It can be
fixed in the arch code though.

> So what matters for the non-leaf operations is not size. Not AT ALL.
> It's a totally different operation, and you'd need not a different
> size, but a different flag entirely - the same way we already have a
> different flag for the "full_mm" case. And it's actually for exactly
> the same reason as "full_mm": you do the flush itself differently,
> it's not that the range is different. If it was just about the range,
> then "full_mm" would just initialize the range to the whole VM. But it
> *isn't* about the range. It's about the fact that a full-MM tear-down
> can fundamentally do different operations, knowing that there are no
> other threads using that VM any more.
> 
> So I really really object to playing games with PMD_SIZE or other
> idiocies, because it fundamentally mis-states the whole problem.

That's not what I suggesting (though I agree I wasn't clear).

The use of PMD_SIZE steps in a new flush_tlb_table_range() loop is
entirely and arch-specific optimisation. Only that the arch code doesn't
currently know which tlb_flush() it should use because need_flush is set
for both PTEs and page table tear down. We just need different flags
here to be able to optimise the arch code further.

> If ARM64 wants to make the "lead vs non-leaf" TLB operation, then you
> need to add a new flag, and you just set that flag when you tear down
> a page table (as opposed to just a PTE).

Indeed. Actually we could use need_flag only for PTEs and ignore it for
page table tear-down. With Will's patch, we can already check tlb->end
for what need_flush is currently doing and use need_flush in an
arch-specific way (and we could give a new name as well).

> > With RCU_TABLE_FREE, I think checking tlb->local.next would do the trick
> > but for x86 we can keep mmu_gather.need_flush only for pte clearing
> > and remove need_flush = 1 from p*_free_tlb() functions.
> 
> This is more confusion about what is going on.

Yes, and if we do this we may no longer understand the code in few weeks
time.

> I'd actually really really prefer to have the "need_flush = 1" for the
> page table tear-down case even for x86. No, if you never removed any
> PTE at all, it is possible that it's not actually needed because an
> x86 CPU isn't supposed to cache non-present page table entries (so if
> you could tear down the page tables because there were no entries,
> there should be no TLB entries, and there *hopefully* should be no
> caches of mid-level page tables either that need a TLB invalidate).

On ARM, as long as an intermediate page table entry is valid, even
though the full translation (PTE) is not, the CPU can go and cache it.
What's worse (and we've hit it before) is that it may even end up
reading something that looks like a valid PTE (of the PTE page has been
freed before the TLB invalidation) and it will stick around as a full
translation. So we need to flush the page table cache before freeing the
page table pages.

> But in practice, I'd not take that chance. If you tear down a page
> table, you should flush the TLB in that range (and note how I say *in*
> that range - an invalidate anywhere in the range should be sufficient,
> not "over the whole range"!), because quite frankly, from an
> implementation standpoint, I really think it's the sane and safe thing
> to do.

A single TLB is indeed enough for a single page table page removed. If
we queue multiple page table pages freeing, we accumulate the range via
pmd_free_tlb() etc. and we would eventually need multiple TLB
invalidations, at most one every PMD_SIZE (that's when !fullmm).

> So I would suggest you think of the x86 invlpg instruction as your
> "non-leaf invalidate". The same way you'd want to do non-leaf
> invalidate whenever you tear down a page table, you'd do "invlpg" on
> x86.

I need to dig some more in the x86 code, I'm not familiar with it. We
could do the page table cache invalidation non-lazily every time
pmd_free_tlb() is called, though it's not as optimal as we need a heavy
DSB barrier on ARM after each TLB invalidate.

> And no, we should *not* play games with "tlb->local.next". That just
> sounds completely and utterly insane. That's a hack, it's unclear,
> it's stupid, and it's connected to a totally irrelevant implementation
> detail, namely that random RCU freeing.
> 
> Set a flag, for chrissake. Just say "when you free a pmd/pud/pgd, set
> tlb->need_flush_inner to let the flusher know" (probably in *addition*
> to "tlb->need_flush", just to maintain that rule). Make it explicit,
> and make it obvious, and don't play games.

I agree.

-- 
Catalin
