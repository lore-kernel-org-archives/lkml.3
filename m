Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbaJ2Trr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:47:47 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:50458 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaJ2Trq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:47:46 -0400
Date: Wed, 29 Oct 2014 19:47:39 +0000
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
Message-ID: <20141029194738.GA29911@arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
 <1414496662-25202-2-git-send-email-will.deacon@arm.com>
 <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
 <CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:40:35PM +0000, Linus Torvalds wrote:
> On Tue, Oct 28, 2014 at 8:30 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Tue, Oct 28, 2014 at 4:44 AM, Will Deacon <will.deacon@arm.com> wrote:
> >>
> >> This patch fixes the problem by incrementing addr by the PAGE_SIZE
> >> before breaking out of the loop on batch failure.
> >
> > This patch seems harmless and right [..]
> 
> I've applied it (commit ce9ec37bddb6), and marked it for stable.
> 
> I think that bug has been around since at least commit 2b047252d087
> ("Fix TLB gather virtual address range invalidation corner cases")
> which went into 3.11, but that has in turn then was also marked for
> stable, so I'm not sure just how far back this fix needs to go. I
> suspect the simple answer is "as far back as it applies" ;)

Thanks for that.

> I'll wait and see what you'll do about the other patch.

I've cooked up something (see below), but it unfortunately makes a couple
of minor changes to powerpc and microblaze to address redefinitions of
some of the gather callbacks (tlb{start,end}vma, __tlb_remove_tlb_entry).

On the plus side, it tidies up the force_flush case in zap_pte_range
quite nicely (assuming I didn't screw it up again).

Cheers,

Will

--->8

commit f51dd616639dfbfe0685c82b47e0f31e4a34f16b
Author: Will Deacon <will.deacon@arm.com>
Date:   Wed Oct 29 10:03:09 2014 +0000

    mmu_gather: move minimal range calculations into generic code
    
    On architectures with hardware broadcasting of TLB invalidation messages
    , it makes sense to reduce the range of the mmu_gather structure when
    unmapping page ranges based on the dirty address information passed to
    tlb_remove_tlb_entry.
    
    arm64 already does this by directly manipulating the start/end fields
    of the gather structure, but this confuses the generic code which
    does not expect these fields to change and can end up calculating
    invalid, negative ranges when forcing a flush in zap_pte_range.
    
    This patch moves the minimal range calculation out of the arm64 code
    and into the generic implementation, simplifying zap_pte_range in the
    process (which no longer needs to care about start/end, since they will
    point to the appropriate ranges already).
    
    Signed-off-by: Will Deacon <will.deacon@arm.com>

diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
index a82c0c5c8b52..a9c9df0f60ff 100644
--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -19,10 +19,6 @@
 #ifndef __ASM_TLB_H
 #define __ASM_TLB_H
 
-#define  __tlb_remove_pmd_tlb_entry __tlb_remove_pmd_tlb_entry
-
-#include <asm-generic/tlb.h>
-
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 
@@ -37,16 +33,8 @@ static inline void __tlb_remove_table(void *_table)
 #define tlb_remove_entry(tlb, entry)	tlb_remove_page(tlb, entry)
 #endif /* CONFIG_HAVE_RCU_TABLE_FREE */
 
-/*
- * There's three ways the TLB shootdown code is used:
- *  1. Unmapping a range of vmas.  See zap_page_range(), unmap_region().
- *     tlb->fullmm = 0, and tlb_start_vma/tlb_end_vma will be called.
- *  2. Unmapping all vmas.  See exit_mmap().
- *     tlb->fullmm = 1, and tlb_start_vma/tlb_end_vma will be called.
- *     Page tables will be freed.
- *  3. Unmapping argument pages.  See shift_arg_pages().
- *     tlb->fullmm = 0, but tlb_start_vma/tlb_end_vma will not be called.
- */
+#include <asm-generic/tlb.h>
+
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
 	if (tlb->fullmm) {
@@ -54,54 +42,13 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 	} else if (tlb->end > 0) {
 		struct vm_area_struct vma = { .vm_mm = tlb->mm, };
 		flush_tlb_range(&vma, tlb->start, tlb->end);
-		tlb->start = TASK_SIZE;
-		tlb->end = 0;
-	}
-}
-
-static inline void tlb_add_flush(struct mmu_gather *tlb, unsigned long addr)
-{
-	if (!tlb->fullmm) {
-		tlb->start = min(tlb->start, addr);
-		tlb->end = max(tlb->end, addr + PAGE_SIZE);
-	}
-}
-
-/*
- * Memorize the range for the TLB flush.
- */
-static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep,
-					  unsigned long addr)
-{
-	tlb_add_flush(tlb, addr);
-}
-
-/*
- * In the case of tlb vma handling, we can optimise these away in the
- * case where we're doing a full MM flush.  When we're doing a munmap,
- * the vmas are adjusted to only cover the region to be torn down.
- */
-static inline void tlb_start_vma(struct mmu_gather *tlb,
-				 struct vm_area_struct *vma)
-{
-	if (!tlb->fullmm) {
-		tlb->start = TASK_SIZE;
-		tlb->end = 0;
 	}
 }
 
-static inline void tlb_end_vma(struct mmu_gather *tlb,
-			       struct vm_area_struct *vma)
-{
-	if (!tlb->fullmm)
-		tlb_flush(tlb);
-}
-
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 				  unsigned long addr)
 {
 	pgtable_page_dtor(pte);
-	tlb_add_flush(tlb, addr);
 	tlb_remove_entry(tlb, pte);
 }
 
@@ -109,7 +56,6 @@ static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
 				  unsigned long addr)
 {
-	tlb_add_flush(tlb, addr);
 	tlb_remove_entry(tlb, virt_to_page(pmdp));
 }
 #endif
@@ -118,15 +64,8 @@ static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
 static inline void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pudp,
 				  unsigned long addr)
 {
-	tlb_add_flush(tlb, addr);
 	tlb_remove_entry(tlb, virt_to_page(pudp));
 }
 #endif
 
-static inline void __tlb_remove_pmd_tlb_entry(struct mmu_gather *tlb, pmd_t *pmdp,
-						unsigned long address)
-{
-	tlb_add_flush(tlb, address);
-}
-
 #endif
diff --git a/arch/microblaze/include/asm/tlb.h b/arch/microblaze/include/asm/tlb.h
index 8aa97817cc8c..99b6ded54849 100644
--- a/arch/microblaze/include/asm/tlb.h
+++ b/arch/microblaze/include/asm/tlb.h
@@ -14,7 +14,6 @@
 #define tlb_flush(tlb)	flush_tlb_mm((tlb)->mm)
 
 #include <linux/pagemap.h>
-#include <asm-generic/tlb.h>
 
 #ifdef CONFIG_MMU
 #define tlb_start_vma(tlb, vma)		do { } while (0)
@@ -22,4 +21,6 @@
 #define __tlb_remove_tlb_entry(tlb, pte, address) do { } while (0)
 #endif
 
+#include <asm-generic/tlb.h>
+
 #endif /* _ASM_MICROBLAZE_TLB_H */
diff --git a/arch/powerpc/include/asm/pgalloc.h b/arch/powerpc/include/asm/pgalloc.h
index e9a9f60e596d..fc3ee06eab87 100644
--- a/arch/powerpc/include/asm/pgalloc.h
+++ b/arch/powerpc/include/asm/pgalloc.h
@@ -3,7 +3,6 @@
 #ifdef __KERNEL__
 
 #include <linux/mm.h>
-#include <asm-generic/tlb.h>
 
 #ifdef CONFIG_PPC_BOOK3E
 extern void tlb_flush_pgtable(struct mmu_gather *tlb, unsigned long address);
@@ -14,6 +13,8 @@ static inline void tlb_flush_pgtable(struct mmu_gather *tlb,
 }
 #endif /* !CONFIG_PPC_BOOK3E */
 
+extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
+
 #ifdef CONFIG_PPC64
 #include <asm/pgalloc-64.h>
 #else
diff --git a/arch/powerpc/include/asm/tlb.h b/arch/powerpc/include/asm/tlb.h
index e2b428b0f7ba..20733fa518ae 100644
--- a/arch/powerpc/include/asm/tlb.h
+++ b/arch/powerpc/include/asm/tlb.h
@@ -27,6 +27,7 @@
 
 #define tlb_start_vma(tlb, vma)	do { } while (0)
 #define tlb_end_vma(tlb, vma)	do { } while (0)
+#define __tlb_remove_tlb_entry	__tlb_remove_tlb_entry
 
 extern void tlb_flush(struct mmu_gather *tlb);
 
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 5672d7ea1fa0..340bc5c5ca2d 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -128,6 +128,46 @@ static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 		tlb_flush_mmu(tlb);
 }
 
+static inline void __tlb_adjust_range(struct mmu_gather *tlb,
+				      unsigned long address)
+{
+	if (!tlb->fullmm) {
+		tlb->start = min(tlb->start, address);
+		tlb->end = max(tlb->end, address + PAGE_SIZE);
+	}
+}
+
+static inline void __tlb_reset_range(struct mmu_gather *tlb)
+{
+	tlb->start = TASK_SIZE;
+	tlb->end = 0;
+}
+
+/*
+ * In the case of tlb vma handling, we can optimise these away in the
+ * case where we're doing a full MM flush.  When we're doing a munmap,
+ * the vmas are adjusted to only cover the region to be torn down.
+ */
+#ifndef tlb_start_vma
+#define tlb_start_vma(tlb, vma) do { } while (0)
+#endif
+
+#define __tlb_end_vma(tlb, vma)					\
+	do {							\
+		if (!tlb->fullmm) {				\
+			tlb_flush(tlb);				\
+			__tlb_reset_range(tlb);			\
+		}						\
+	} while (0)
+
+#ifndef tlb_end_vma
+#define tlb_end_vma	__tlb_end_vma
+#endif
+
+#ifndef __tlb_remove_tlb_entry
+#define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
+#endif
+
 /**
  * tlb_remove_tlb_entry - remember a pte unmapping for later tlb invalidation.
  *
@@ -138,6 +178,7 @@ static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 #define tlb_remove_tlb_entry(tlb, ptep, address)		\
 	do {							\
 		tlb->need_flush = 1;				\
+		__tlb_adjust_range(tlb, address);		\
 		__tlb_remove_tlb_entry(tlb, ptep, address);	\
 	} while (0)
 
@@ -152,12 +193,14 @@ static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 #define tlb_remove_pmd_tlb_entry(tlb, pmdp, address)		\
 	do {							\
 		tlb->need_flush = 1;				\
+		__tlb_adjust_range(tlb, address);		\
 		__tlb_remove_pmd_tlb_entry(tlb, pmdp, address);	\
 	} while (0)
 
 #define pte_free_tlb(tlb, ptep, address)			\
 	do {							\
 		tlb->need_flush = 1;				\
+		__tlb_adjust_range(tlb, address);		\
 		__pte_free_tlb(tlb, ptep, address);		\
 	} while (0)
 
@@ -165,6 +208,7 @@ static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 #define pud_free_tlb(tlb, pudp, address)			\
 	do {							\
 		tlb->need_flush = 1;				\
+		__tlb_adjust_range(tlb, address);		\
 		__pud_free_tlb(tlb, pudp, address);		\
 	} while (0)
 #endif
@@ -172,6 +216,7 @@ static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 #define pmd_free_tlb(tlb, pmdp, address)			\
 	do {							\
 		tlb->need_flush = 1;				\
+		__tlb_adjust_range(tlb, address);		\
 		__pmd_free_tlb(tlb, pmdp, address);		\
 	} while (0)
 
diff --git a/mm/memory.c b/mm/memory.c
index 3e503831e042..0bc940e41ec9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -220,8 +220,6 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long
 	/* Is it from 0 to ~0? */
 	tlb->fullmm     = !(start | (end+1));
 	tlb->need_flush_all = 0;
-	tlb->start	= start;
-	tlb->end	= end;
 	tlb->need_flush = 0;
 	tlb->local.next = NULL;
 	tlb->local.nr   = 0;
@@ -232,6 +230,8 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	tlb->batch = NULL;
 #endif
+
+	__tlb_reset_range(tlb);
 }
 
 static void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
@@ -241,6 +241,7 @@ static void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	tlb_table_flush(tlb);
 #endif
+	__tlb_reset_range(tlb);
 }
 
 static void tlb_flush_mmu_free(struct mmu_gather *tlb)
@@ -1186,20 +1187,8 @@ again:
 	arch_leave_lazy_mmu_mode();
 
 	/* Do the actual TLB flush before dropping ptl */
-	if (force_flush) {
-		unsigned long old_end;
-
-		/*
-		 * Flush the TLB just for the previous segment,
-		 * then update the range to be the remaining
-		 * TLB range.
-		 */
-		old_end = tlb->end;
-		tlb->end = addr;
+	if (force_flush)
 		tlb_flush_mmu_tlbonly(tlb);
-		tlb->start = addr;
-		tlb->end = old_end;
-	}
 	pte_unmap_unlock(start_pte, ptl);
 
 	/*
