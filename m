Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbbALTZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:25:01 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60682 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbbALTY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:24:58 -0500
Date: Mon, 12 Jan 2015 19:24:51 +0000
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Laszlo Ersek <lersek@redhat.com>, Mark Langsdorf <mlangsdo@redhat.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        "vishnu.ps@samsung.com" <vishnu.ps@samsung.com>,
        main kernel list <linux-kernel@vger.kernel.org>,
        arm kernel list <linux-arm-kernel@lists.infradead.org>,
        Kyle McMartin <kmcmarti@redhat.com>, Dave Hansen <dave@sr71.net>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150112192451.GQ13360@arm.com>
References: <20150109175702.GA27787@leverpostej>
 <54B01FF0.3020900@arm.com>
 <20150109194333.GA23028@arm.com>
 <54B09CA3.1060501@redhat.com>
 <CA+55aFw3aGeiWOiKxQaC23VVX_Q9B0cDeZc37vVfK+SJVjGwFw@mail.gmail.com>
 <20150110133742.GA6999@arm.com>
 <CA+55aFxBA6F4Kr89iZwPPeBnkiRO4GnrbUSd0CqVG-LD6ZQyiw@mail.gmail.com>
 <20150112124256.GB13360@arm.com>
 <CA+55aFxD63S0PE4zBnEw2jn3pPSALO0BdxY7tP++8wKVdRKJ5g@mail.gmail.com>
 <CA+55aFw=urngjyQvuOWHP1BBe-tNKy0E4DC0c5PwP+XuvpSmEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw=urngjyQvuOWHP1BBe-tNKy0E4DC0c5PwP+XuvpSmEg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 07:07:12PM +0000, Linus Torvalds wrote:
> On Tue, Jan 13, 2015 at 8:06 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So I'm ok with it, as long as we don't have a performance regression.
> >
> > Your "don't bother freeing when the batch is empty" should hopefully
> > be fine. Dave, does that work for your case?
> 
> Oh, and Dave just replied that it's ok. So should I just take it
> directly, or expect it through the arm64 tree? Either works for me.

Although I do have a couple of arm64 fixes on the radar, it'd be quicke
if you just take the patch. I added a commit log/SoB below.

Cheers,

Will

--->8

>From bcf792ffc9ce29415261d2055954b883c5bec978 Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Mon, 12 Jan 2015 19:10:55 +0000
Subject: [PATCH] mm: mmu_gather: use tlb->end != 0 only for TLB invalidation

When batching up address ranges for TLB invalidation, we check tlb->end
!= 0 to indicate that some pages have actually been unmapped.

As of commit f045bbb9fa1b ("mmu_gather: fix over-eager
tlb_flush_mmu_free() calling"), we use the same check for freeing these
pages in order to avoid a performance regression where we call
free_pages_and_swap_cache even when no pages are actually queued up.

Unfortunately, the range could have been reset (tlb->end = 0) by
tlb_end_vma, which has been shown to cause memory leaks on arm64.
Furthermore, investigation into these leaks revealed that the fullmm
case on task exit no longer invalidates the TLB, by virtue of tlb->end
 == 0 (in 3.18, need_flush would have been set).

This patch resolves the problem by reverting f045bbb9fa1b, using
tlb->local.nr as the predicate for page freeing in tlb_flush_mmu_free
and ensuring that tlb->end is initialised to a non-zero value in the
fullmm case.

Tested-by: Mark Langsdorf <mlangsdo@redhat.com>
Tested-by: Dave Hansen <dave@sr71.net>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 include/asm-generic/tlb.h | 8 ++++++--
 mm/memory.c               | 8 ++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

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
-- 
2.1.4

