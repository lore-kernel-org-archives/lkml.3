Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbaKFRyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:54:00 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:54220 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaKFRx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:53:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141106135740.GC19702@e104818-lin.cambridge.arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	<1414496662-25202-2-git-send-email-will.deacon@arm.com>
	<CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
	<CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
	<20141029194738.GA29911@arm.com>
	<20141104142955.GA24816@e104818-lin.cambridge.arm.com>
	<CA+55aFzBggoXtNXQeng5d_mRoDnaMBE5Y+URs+PHR67nUpMtaw@mail.gmail.com>
	<20141106135740.GC19702@e104818-lin.cambridge.arm.com>
Date: Thu, 6 Nov 2014 09:53:58 -0800
X-Google-Sender-Auth: jDBnQrAs6vEIFVTh2xW-SuyD4VA
Message-ID: <CA+55aFzQM-yvvXYENiviLBm0=jiZoO7xPmz5mLowuTb-Pb8e6Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 5:57 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> Anyway, even without special "leaf" operations, it would be useful to
> make the distinction between unmap_vmas() and free_pgtables() with
> regards to the ranges tracked by mmu_gather. For the former, tlb_flush()
> needs to flush the range in PAGE_SIZE increments (assuming a mix of
> small and huge pages). For the latter, PMD_SIZE increments would be
> enough.

Why woyuld you *ever* care about the increments?

Quite frankly, I think even the PAGE_SIZE thing is just (a) stupid and
(b) misleading.

It might actually be better to instead of

    tlb->end = max(tlb->end, address + PAGE_SIZE);

it might as well be a simpler

    tlb->end = max(tlb->end, address+1)

(Even the "+1" is kind of unnecessary, but it's there to distinguish
the zero address from the initial condition).

The thing is, absolutely *no* architecture has a TLB flush that
involves giving the start and end of the page you want to flush. None.
Nada. Zilch. Trying to think of it as a "range of bytes I need to
flush" is wrong. And it's misleading, and it makes people think in
stupid ways like "I should change PAGE_SIZE to PMD_SIZE when I flush a
PMD". That's *wrong*.

Every single TLB flush is about a variation of "flush the TLB entry
that contains the mapping for this address". The whole "add page-size"
is pointless, because the *flushing* is not about giving a page-sized
range, it's about giving *one* address in that page.

Using "address+1" is actually equally descriptive of what the range is
("flush the tlb entry that maps this *byte*"), but is less amenable to
the above kind of silly PMD_SIZE confusion. Because the exact same
thing that is true for a single page is true for a page table
operation too. There is just a *single* page table directory entry
cache, it's not like you have one page table directory entry cache for
each page.

So what matters for the non-leaf operations is not size. Not AT ALL.
It's a totally different operation, and you'd need not a different
size, but a different flag entirely - the same way we already have a
different flag for the "full_mm" case. And it's actually for exactly
the same reason as "full_mm": you do the flush itself differently,
it's not that the range is different. If it was just about the range,
then "full_mm" would just initialize the range to the whole VM. But it
*isn't* about the range. It's about the fact that a full-MM tear-down
can fundamentally do different operations, knowing that there are no
other threads using that VM any more.

So I really really object to playing games with PMD_SIZE or other
idiocies, because it fundamentally mis-states the whole problem.

If ARM64 wants to make the "lead vs non-leaf" TLB operation, then you
need to add a new flag, and you just set that flag when you tear down
a page table (as opposed to just a PTE).

It doesn't affect the "range" at all in any way as far as I can tell.

> With RCU_TABLE_FREE, I think checking tlb->local.next would do the trick
> but for x86 we can keep mmu_gather.need_flush only for pte clearing
> and remove need_flush = 1 from p*_free_tlb() functions.

This is more confusion about what is going on.

I'd actually really really prefer to have the "need_flush = 1" for the
page table tear-down case even for x86. No, if you never removed any
PTE at all, it is possible that it's not actually needed because an
x86 CPU isn't supposed to cache non-present page table entries (so if
you could tear down the page tables because there were no entries,
there should be no TLB entries, and there *hopefully* should be no
caches of mid-level page tables either that need a TLB invalidate).
But in practice, I'd not take that chance. If you tear down a page
table, you should flush the TLB in that range (and note how I say *in*
that range - an invalidate anywhere in the range should be sufficient,
not "over the whole range"!), because quite frankly, from an
implementation standpoint, I really think it's the sane and safe thing
to do.

So I would suggest you think of the x86 invlpg instruction as your
"non-leaf invalidate". The same way you'd want to do non-leaf
invalidate whenever you tear down a page table, you'd do "invlpg" on
x86.

And no, we should *not* play games with "tlb->local.next". That just
sounds completely and utterly insane. That's a hack, it's unclear,
it's stupid, and it's connected to a totally irrelevant implementation
detail, namely that random RCU freeing.

Set a flag, for chrissake. Just say "when you free a pmd/pud/pgd, set
tlb->need_flush_inner to let the flusher know" (probably in *addition*
to "tlb->need_flush", just to maintain that rule). Make it explicit,
and make it obvious, and don't play games.

And don't make it be about range sizes. Because I really don't see how
the exact end/start could ever be relevant. TLB's aren't byte-based,
they are entry-based.

                         Linus
