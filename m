Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbbALMnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:43:06 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:59931 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbbALMnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:43:04 -0500
Date: Mon, 12 Jan 2015 12:42:56 +0000
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Laszlo Ersek <lersek@redhat.com>, Mark Langsdorf <mlangsdo@redhat.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        "vishnu.ps@samsung.com" <vishnu.ps@samsung.com>,
        main kernel list <linux-kernel@vger.kernel.org>,
        arm kernel list <linux-arm-kernel@lists.infradead.org>,
        Kyle McMartin <kmcmarti@redhat.com>, dave@sr71.net
Subject: Re: Linux 3.19-rc3
Message-ID: <20150112124256.GB13360@arm.com>
References: <20150109121348.GD12942@leverpostej>
 <CAPvkgC23LHhs7Tw4rdAPFooimonji8R7kEAbWYRKPJwouwUzBA@mail.gmail.com>
 <54AFE53A.4020004@redhat.com>
 <20150109175702.GA27787@leverpostej>
 <54B01FF0.3020900@arm.com>
 <20150109194333.GA23028@arm.com>
 <54B09CA3.1060501@redhat.com>
 <CA+55aFw3aGeiWOiKxQaC23VVX_Q9B0cDeZc37vVfK+SJVjGwFw@mail.gmail.com>
 <20150110133742.GA6999@arm.com>
 <CA+55aFxBA6F4Kr89iZwPPeBnkiRO4GnrbUSd0CqVG-LD6ZQyiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxBA6F4Kr89iZwPPeBnkiRO4GnrbUSd0CqVG-LD6ZQyiw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 07:51:03PM +0000, Linus Torvalds wrote:
> On Sat, Jan 10, 2015 at 5:37 AM, Will Deacon <will.deacon@arm.com> wrote:
> >>
> >> Will?
> >
> > I'm wondering if this is now broken in the fullmm case, because tlb->end
> > will be zero and we won't actually free any of the pages being unmapped
> > on task exit. Does that sound plausible?
> 
> But did anything change wrt fullmm? I don't see any changes wrt fullmm
> logic in generic code.

No, and now that I've had a play, the issue is worse than I thought.

> The arm64 code changed more, so maybe there was somethinig I missed.
> Again, arm64 uses tlb_end_vma() etc, so arm64 certainly triggers code
> that x86 does not.

Yup, and I think tlb_end_vma is also problematic. The issue is that we
reset the range in __tlb_end_vma, and therefore the batched pages don't
get freed. We also have an issue in the fullmm case, because
tlb_flush_mmu tests tlb->end != 0 before doing any freeing.

The fundamental problem is that tlb->end *only* indicates whether or not
TLB invalidation is required, *not* whether there are pages to be freed.
The advantage of the old need_flush flag was that it was sticky over
calls to things like tlb_flush_mmu_tlbonly.

> I can revert the commit that causes problems, but considering the
> performance impact on x86 (it would be a regression since 3.18), I
> would *really* like to fix the arm64 problem instead. So I'll wait
> with the revert for at least a week, I think, hoping that the arm64
> people figure this out. Sound reasonable?

Sure. I've put together the following patch which:

  (1) Uses tlb->end != 0 only as the predicate for TLB invalidation

  (2) Uses tlb->local.nr as the predicate for page freeing in
      tlb_flush_mmu_free

  (3) Ensures tlb->end != 0 for the fullmm case (I think this was a
      benign change introduced by my original patch, but this puts us
      back to 3.18 behaviour)

Since this effectively reverts f045bbb9fa1b, I've added Dave to Cc. It
should fix the leak without reintroducing the performance regression.

Linus: this moves the tlb->end check back into tlb_flush_mmu_tlbonly.
How much do you hate that?

Will

--->8

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 08848050922e..db284bff29dc 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -136,8 +136,12 @@ static inline void __tlb_adjust_range(struct mmu_gather *tlb,
 
 static inline void __tlb_reset_range(struct mmu_gather *tlb)
 {
-	tlb->start = TASK_SIZE;
-	tlb->end = 0;
+	if (tlb->fullmm) {
+		tlb->start = tlb->end = ~0;
+	} else {
+		tlb->start = TASK_SIZE;
+		tlb->end = 0;
+	}
 }
 
 /*
diff --git a/mm/memory.c b/mm/memory.c
index c6565f00fb38..54f3a9b00956 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -235,6 +235,9 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long
 
 static void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
 {
+	if (!tlb->end)
+		return;
+
 	tlb_flush(tlb);
 	mmu_notifier_invalidate_range(tlb->mm, tlb->start, tlb->end);
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
@@ -247,7 +250,7 @@ static void tlb_flush_mmu_free(struct mmu_gather *tlb)
 {
 	struct mmu_gather_batch *batch;
 
-	for (batch = &tlb->local; batch; batch = batch->next) {
+	for (batch = &tlb->local; batch && batch->nr; batch = batch->next) {
 		free_pages_and_swap_cache(batch->pages, batch->nr);
 		batch->nr = 0;
 	}
@@ -256,9 +259,6 @@ static void tlb_flush_mmu_free(struct mmu_gather *tlb)
 
 void tlb_flush_mmu(struct mmu_gather *tlb)
 {
-	if (!tlb->end)
-		return;
-
 	tlb_flush_mmu_tlbonly(tlb);
 	tlb_flush_mmu_free(tlb);
 }
