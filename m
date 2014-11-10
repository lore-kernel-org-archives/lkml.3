Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaKJN4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:56:25 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55521 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaKJN4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:56:24 -0500
Date: Mon, 10 Nov 2014 13:56:17 +0000
From: Will Deacon <will.deacon@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
Message-ID: <20141110135617.GC23942@arm.com>
References: <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
 <CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
 <20141029194738.GA29911@arm.com>
 <20141104142955.GA24816@e104818-lin.cambridge.arm.com>
 <CA+55aFzBggoXtNXQeng5d_mRoDnaMBE5Y+URs+PHR67nUpMtaw@mail.gmail.com>
 <20141106135740.GC19702@e104818-lin.cambridge.arm.com>
 <CA+55aFzQM-yvvXYENiviLBm0=jiZoO7xPmz5mLowuTb-Pb8e6Q@mail.gmail.com>
 <20141106183808.GH19702@e104818-lin.cambridge.arm.com>
 <CA+55aFwE847pZgOpcLuZah6qhMDPV1v8oUpTV1_ROQNTtWhZKQ@mail.gmail.com>
 <20141107165003.GG29148@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107165003.GG29148@e104818-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 04:50:04PM +0000, Catalin Marinas wrote:
> On Thu, Nov 06, 2014 at 09:29:54PM +0000, Linus Torvalds wrote:
> > That's fine. That makes sense. In fact, how about adding "granularity"
> > to the mmu_gather structure, and then doing:\
> > 
> >  - in __tlb_reset_range(), setting it to ~0ul
> > 
> >  - add "granularity" to __tlb_adjust_range(), and make it do something like
> > 
> >        if (!tlb->fullmm) {
> >                tlb->granularity = min(tlb->granularity, granularity);
> >                tlb->start = min(tlb->start, address);
> >                tlb->end = max(tlb->end, address+1);
> >        }
> > 
> > and then the TLB flush logic would basically do
> > 
> >    address = tlb->start;
> >    do {
> >         flush(address);
> >         if (address + tlb->granularity < address)
> >                 break;
> >         address = address + tlb->granularity;
> >    } while (address < tlb->end);
> > 
> > or something like that.
> 
> Indeed. We'll come up with a patch after Will's clean-up.

My clean-up is the patch I sent previously, plus the removal of need_flush.

Incremental diff for the latter part below. We drop a set of need_flush
from tlb_remove_table, but I can't figure out why it was there in the
first place (need_flush was already set by pXd_free_tlb).

Will

--->8

diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
index a9c9df0f60ff..c028fe37456f 100644
--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -39,7 +39,7 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 {
 	if (tlb->fullmm) {
 		flush_tlb_mm(tlb->mm);
-	} else if (tlb->end > 0) {
+	} else {
 		struct vm_area_struct vma = { .vm_mm = tlb->mm, };
 		flush_tlb_range(&vma, tlb->start, tlb->end);
 	}
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 340bc5c5ca2d..08848050922e 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -96,10 +96,9 @@ struct mmu_gather {
 #endif
 	unsigned long		start;
 	unsigned long		end;
-	unsigned int		need_flush : 1,	/* Did free PTEs */
 	/* we are in the middle of an operation to clear
 	 * a full mm and can make some optimizations */
-				fullmm : 1,
+	unsigned int		fullmm : 1,
 	/* we have performed an operation which
 	 * requires a complete flush of the tlb */
 				need_flush_all : 1;
@@ -131,10 +130,8 @@ static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 static inline void __tlb_adjust_range(struct mmu_gather *tlb,
 				      unsigned long address)
 {
-	if (!tlb->fullmm) {
-		tlb->start = min(tlb->start, address);
-		tlb->end = max(tlb->end, address + PAGE_SIZE);
-	}
+	tlb->start = min(tlb->start, address);
+	tlb->end = max(tlb->end, address + PAGE_SIZE);
 }
 
 static inline void __tlb_reset_range(struct mmu_gather *tlb)
@@ -154,7 +151,7 @@ static inline void __tlb_reset_range(struct mmu_gather *tlb)
 
 #define __tlb_end_vma(tlb, vma)					\
 	do {							\
-		if (!tlb->fullmm) {				\
+		if (!tlb->fullmm && tlb->end) {			\
 			tlb_flush(tlb);				\
 			__tlb_reset_range(tlb);			\
 		}						\
@@ -171,13 +168,12 @@ static inline void __tlb_reset_range(struct mmu_gather *tlb)
 /**
  * tlb_remove_tlb_entry - remember a pte unmapping for later tlb invalidation.
  *
- * Record the fact that pte's were really umapped in ->need_flush, so we can
- * later optimise away the tlb invalidate.   This helps when userspace is
- * unmapping already-unmapped pages, which happens quite a lot.
+ * Record the fact that pte's were really unmapped by updating the range,
+ * so we can later optimise away the tlb invalidate.   This helps when
+ * userspace is unmapping already-unmapped pages, which happens quite a lot.
  */
 #define tlb_remove_tlb_entry(tlb, ptep, address)		\
 	do {							\
-		tlb->need_flush = 1;				\
 		__tlb_adjust_range(tlb, address);		\
 		__tlb_remove_tlb_entry(tlb, ptep, address);	\
 	} while (0)
@@ -192,14 +188,12 @@ static inline void __tlb_reset_range(struct mmu_gather *tlb)
 
 #define tlb_remove_pmd_tlb_entry(tlb, pmdp, address)		\
 	do {							\
-		tlb->need_flush = 1;				\
 		__tlb_adjust_range(tlb, address);		\
 		__tlb_remove_pmd_tlb_entry(tlb, pmdp, address);	\
 	} while (0)
 
 #define pte_free_tlb(tlb, ptep, address)			\
 	do {							\
-		tlb->need_flush = 1;				\
 		__tlb_adjust_range(tlb, address);		\
 		__pte_free_tlb(tlb, ptep, address);		\
 	} while (0)
@@ -207,7 +201,6 @@ static inline void __tlb_reset_range(struct mmu_gather *tlb)
 #ifndef __ARCH_HAS_4LEVEL_HACK
 #define pud_free_tlb(tlb, pudp, address)			\
 	do {							\
-		tlb->need_flush = 1;				\
 		__tlb_adjust_range(tlb, address);		\
 		__pud_free_tlb(tlb, pudp, address);		\
 	} while (0)
@@ -215,7 +208,6 @@ static inline void __tlb_reset_range(struct mmu_gather *tlb)
 
 #define pmd_free_tlb(tlb, pmdp, address)			\
 	do {							\
-		tlb->need_flush = 1;				\
 		__tlb_adjust_range(tlb, address);		\
 		__pmd_free_tlb(tlb, pmdp, address);		\
 	} while (0)
diff --git a/mm/memory.c b/mm/memory.c
index 0bc940e41ec9..8b1c1d2e7c67 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -220,7 +220,6 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long
 	/* Is it from 0 to ~0? */
 	tlb->fullmm     = !(start | (end+1));
 	tlb->need_flush_all = 0;
-	tlb->need_flush = 0;
 	tlb->local.next = NULL;
 	tlb->local.nr   = 0;
 	tlb->local.max  = ARRAY_SIZE(tlb->__pages);
@@ -236,7 +235,9 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long
 
 static void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
 {
-	tlb->need_flush = 0;
+	if (!tlb->end)
+		return;
+
 	tlb_flush(tlb);
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	tlb_table_flush(tlb);
@@ -257,8 +258,6 @@ static void tlb_flush_mmu_free(struct mmu_gather *tlb)
 
 void tlb_flush_mmu(struct mmu_gather *tlb)
 {
-	if (!tlb->need_flush)
-		return;
 	tlb_flush_mmu_tlbonly(tlb);
 	tlb_flush_mmu_free(tlb);
 }
@@ -293,7 +292,7 @@ int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	struct mmu_gather_batch *batch;
 
-	VM_BUG_ON(!tlb->need_flush);
+	VM_BUG_ON(!tlb->end);
 
 	batch = tlb->active;
 	batch->pages[batch->nr++] = page;
@@ -360,8 +359,6 @@ void tlb_remove_table(struct mmu_gather *tlb, void *table)
 {
 	struct mmu_table_batch **batch = &tlb->batch;
 
-	tlb->need_flush = 1;
-
 	/*
 	 * When there's less then two users of this mm there cannot be a
 	 * concurrent page-table walk.
