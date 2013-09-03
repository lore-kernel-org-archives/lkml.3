Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187Ab3ICQbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:31:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46647 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933081Ab3ICQ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:28:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 26/58] Fix TLB gather virtual address range invalidation corner cases
Date: Tue,  3 Sep 2013 09:23:30 -0700
Message-Id: <1378225442-20654-27-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 2b047252d087be7f2ba088b4933cd904f92e6fce upstream.

Ben Tebulin reported:

 "Since v3.7.2 on two independent machines a very specific Git
  repository fails in 9/10 cases on git-fsck due to an SHA1/memory
  failures.  This only occurs on a very specific repository and can be
  reproduced stably on two independent laptops.  Git mailing list ran
  out of ideas and for me this looks like some very exotic kernel issue"

and bisected the failure to the backport of commit 53a59fc67f97 ("mm:
limit mmu_gather batching to fix soft lockups on !CONFIG_PREEMPT").

That commit itself is not actually buggy, but what it does is to make it
much more likely to hit the partial TLB invalidation case, since it
introduces a new case in tlb_next_batch() that previously only ever
happened when running out of memory.

The real bug is that the TLB gather virtual memory range setup is subtly
buggered.  It was introduced in commit 597e1c3580b7 ("mm/mmu_gather:
enable tlb flush range in generic mmu_gather"), and the range handling
was already fixed at least once in commit e6c495a96ce0 ("mm: fix the TLB
range flushed when __tlb_remove_page() runs out of slots"), but that fix
was not complete.

The problem with the TLB gather virtual address range is that it isn't
set up by the initial tlb_gather_mmu() initialization (which didn't get
the TLB range information), but it is set up ad-hoc later by the
functions that actually flush the TLB.  And so any such case that forgot
to update the TLB range entries would potentially miss TLB invalidates.

Rather than try to figure out exactly which particular ad-hoc range
setup was missing (I personally suspect it's the hugetlb case in
zap_huge_pmd(), which didn't have the same logic as zap_pte_range()
did), this patch just gets rid of the problem at the source: make the
TLB range information available to tlb_gather_mmu(), and initialize it
when initializing all the other tlb gather fields.

This makes the patch larger, but conceptually much simpler.  And the end
result is much more understandable; even if you want to play games with
partial ranges when invalidating the TLB contents in chunks, now the
range information is always there, and anybody who doesn't want to
bother with it won't introduce subtle bugs.

Ben verified that this fixes his problem.

Reported-bisected-and-tested-by: Ben Tebulin <tebulin@googlemail.com>
Build-testing-by: Stephen Rothwell <sfr@canb.auug.org.au>
Build-testing-by: Richard Weinberger <richard.weinberger@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/include/asm/tlb.h   |  7 +++++--
 arch/arm64/include/asm/tlb.h |  7 +++++--
 arch/ia64/include/asm/tlb.h  |  9 ++++++---
 arch/s390/include/asm/tlb.h  |  8 ++++++--
 arch/sh/include/asm/tlb.h    |  6 ++++--
 arch/um/include/asm/tlb.h    |  6 ++++--
 fs/exec.c                    |  4 ++--
 include/asm-generic/tlb.h    |  2 +-
 mm/hugetlb.c                 |  2 +-
 mm/memory.c                  | 36 +++++++++++++++++++++---------------
 mm/mmap.c                    |  4 ++--
 11 files changed, 57 insertions(+), 34 deletions(-)

diff --git a/arch/arm/include/asm/tlb.h b/arch/arm/include/asm/tlb.h
index bdf2b84..aa9b4ac 100644
--- a/arch/arm/include/asm/tlb.h
+++ b/arch/arm/include/asm/tlb.h
@@ -43,6 +43,7 @@ struct mmu_gather {
 	struct mm_struct	*mm;
 	unsigned int		fullmm;
 	struct vm_area_struct	*vma;
+	unsigned long		start, end;
 	unsigned long		range_start;
 	unsigned long		range_end;
 	unsigned int		nr;
@@ -107,10 +108,12 @@ static inline void tlb_flush_mmu(struct mmu_gather *tlb)
 }
 
 static inline void
-tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int fullmm)
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	tlb->mm = mm;
-	tlb->fullmm = fullmm;
+	tlb->fullmm = !(start | (end+1));
+	tlb->start = start;
+	tlb->end = end;
 	tlb->vma = NULL;
 	tlb->max = ARRAY_SIZE(tlb->local);
 	tlb->pages = tlb->local;
diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
index 654f096..5546653 100644
--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -35,6 +35,7 @@ struct mmu_gather {
 	struct mm_struct	*mm;
 	unsigned int		fullmm;
 	struct vm_area_struct	*vma;
+	unsigned long		start, end;
 	unsigned long		range_start;
 	unsigned long		range_end;
 	unsigned int		nr;
@@ -97,10 +98,12 @@ static inline void tlb_flush_mmu(struct mmu_gather *tlb)
 }
 
 static inline void
-tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int fullmm)
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	tlb->mm = mm;
-	tlb->fullmm = fullmm;
+	tlb->fullmm = !(start | (end+1));
+	tlb->start = start;
+	tlb->end = end;
 	tlb->vma = NULL;
 	tlb->max = ARRAY_SIZE(tlb->local);
 	tlb->pages = tlb->local;
diff --git a/arch/ia64/include/asm/tlb.h b/arch/ia64/include/asm/tlb.h
index ef3a9de..bc5efc7 100644
--- a/arch/ia64/include/asm/tlb.h
+++ b/arch/ia64/include/asm/tlb.h
@@ -22,7 +22,7 @@
  * unmapping a portion of the virtual address space, these hooks are called according to
  * the following template:
  *
- *	tlb <- tlb_gather_mmu(mm, full_mm_flush);	// start unmap for address space MM
+ *	tlb <- tlb_gather_mmu(mm, start, end);		// start unmap for address space MM
  *	{
  *	  for each vma that needs a shootdown do {
  *	    tlb_start_vma(tlb, vma);
@@ -58,6 +58,7 @@ struct mmu_gather {
 	unsigned int		max;
 	unsigned char		fullmm;		/* non-zero means full mm flush */
 	unsigned char		need_flush;	/* really unmapped some PTEs? */
+	unsigned long		start, end;
 	unsigned long		start_addr;
 	unsigned long		end_addr;
 	struct page		**pages;
@@ -155,13 +156,15 @@ static inline void __tlb_alloc_page(struct mmu_gather *tlb)
 
 
 static inline void
-tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	tlb->mm = mm;
 	tlb->max = ARRAY_SIZE(tlb->local);
 	tlb->pages = tlb->local;
 	tlb->nr = 0;
-	tlb->fullmm = full_mm_flush;
+	tlb->fullmm = !(start | (end+1));
+	tlb->start = start;
+	tlb->end = end;
 	tlb->start_addr = ~0UL;
 }
 
diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index b75d7d6..23a64d2 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -32,6 +32,7 @@ struct mmu_gather {
 	struct mm_struct *mm;
 	struct mmu_table_batch *batch;
 	unsigned int fullmm;
+	unsigned long start, unsigned long end;
 };
 
 struct mmu_table_batch {
@@ -48,10 +49,13 @@ extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 
 static inline void tlb_gather_mmu(struct mmu_gather *tlb,
 				  struct mm_struct *mm,
-				  unsigned int full_mm_flush)
+				  unsigned long start,
+				  unsigned long end)
 {
 	tlb->mm = mm;
-	tlb->fullmm = full_mm_flush;
+	tlb->start = start;
+	tlb->end = end;
+	tlb->fullmm = !(start | (end+1));
 	tlb->batch = NULL;
 	if (tlb->fullmm)
 		__tlb_flush_mm(mm);
diff --git a/arch/sh/include/asm/tlb.h b/arch/sh/include/asm/tlb.h
index e61d43d..362192e 100644
--- a/arch/sh/include/asm/tlb.h
+++ b/arch/sh/include/asm/tlb.h
@@ -36,10 +36,12 @@ static inline void init_tlb_gather(struct mmu_gather *tlb)
 }
 
 static inline void
-tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	tlb->mm = mm;
-	tlb->fullmm = full_mm_flush;
+	tlb->start = start;
+	tlb->end = end;
+	tlb->fullmm = !(start | (end+1));
 
 	init_tlb_gather(tlb);
 }
diff --git a/arch/um/include/asm/tlb.h b/arch/um/include/asm/tlb.h
index 4febacd..29b0301 100644
--- a/arch/um/include/asm/tlb.h
+++ b/arch/um/include/asm/tlb.h
@@ -45,10 +45,12 @@ static inline void init_tlb_gather(struct mmu_gather *tlb)
 }
 
 static inline void
-tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	tlb->mm = mm;
-	tlb->fullmm = full_mm_flush;
+	tlb->start = start;
+	tlb->end = end;
+	tlb->fullmm = !(start | (end+1));
 
 	init_tlb_gather(tlb);
 }
diff --git a/fs/exec.c b/fs/exec.c
index ea5dc8d..0b5038a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -607,7 +607,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
 		return -ENOMEM;
 
 	lru_add_drain();
-	tlb_gather_mmu(&tlb, mm, 0);
+	tlb_gather_mmu(&tlb, mm, old_start, old_end);
 	if (new_end > old_start) {
 		/*
 		 * when the old and new regions overlap clear from new_end.
@@ -624,7 +624,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
 		free_pgd_range(&tlb, old_start, old_end, new_end,
 			vma->vm_next ? vma->vm_next->vm_start : USER_PGTABLES_CEILING);
 	}
-	tlb_finish_mmu(&tlb, new_end, old_end);
+	tlb_finish_mmu(&tlb, old_start, old_end);
 
 	/*
 	 * Shrink the vma to just the new range.  Always succeeds.
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 13821c3..5672d7e 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -112,7 +112,7 @@ struct mmu_gather {
 
 #define HAVE_GENERIC_MMU_GATHER
 
-void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm);
+void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long start, unsigned long end);
 void tlb_flush_mmu(struct mmu_gather *tlb);
 void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start,
 							unsigned long end);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 430dca0..0f5e584 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2477,7 +2477,7 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 
 	mm = vma->vm_mm;
 
-	tlb_gather_mmu(&tlb, mm, 0);
+	tlb_gather_mmu(&tlb, mm, start, end);
 	__unmap_hugepage_range(&tlb, vma, start, end, ref_page);
 	tlb_finish_mmu(&tlb, start, end);
 }
diff --git a/mm/memory.c b/mm/memory.c
index e4595bd..35b6109 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -207,14 +207,15 @@ static int tlb_next_batch(struct mmu_gather *tlb)
  *	tear-down from @mm. The @fullmm argument is used when @mm is without
  *	users and we're going to destroy the full address space (exit/execve).
  */
-void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm)
+void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	tlb->mm = mm;
 
-	tlb->fullmm     = fullmm;
+	/* Is it from 0 to ~0? */
+	tlb->fullmm     = !(start | (end+1));
 	tlb->need_flush_all = 0;
-	tlb->start	= -1UL;
-	tlb->end	= 0;
+	tlb->start	= start;
+	tlb->end	= end;
 	tlb->need_flush = 0;
 	tlb->local.next = NULL;
 	tlb->local.nr   = 0;
@@ -254,8 +255,6 @@ void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long e
 {
 	struct mmu_gather_batch *batch, *next;
 
-	tlb->start = start;
-	tlb->end   = end;
 	tlb_flush_mmu(tlb);
 
 	/* keep the page table cache within bounds */
@@ -1097,7 +1096,6 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	spinlock_t *ptl;
 	pte_t *start_pte;
 	pte_t *pte;
-	unsigned long range_start = addr;
 
 again:
 	init_rss_vec(rss);
@@ -1200,17 +1198,25 @@ again:
 	 * and page-free while holding it.
 	 */
 	if (force_flush) {
+		unsigned long old_end;
+
 		force_flush = 0;
 
-#ifdef HAVE_GENERIC_MMU_GATHER
-		tlb->start = range_start;
+		/*
+		 * Flush the TLB just for the previous segment,
+		 * then update the range to be the remaining
+		 * TLB range.
+		 */
+		old_end = tlb->end;
 		tlb->end = addr;
-#endif
+
 		tlb_flush_mmu(tlb);
-		if (addr != end) {
-			range_start = addr;
+
+		tlb->start = addr;
+		tlb->end = old_end;
+
+		if (addr != end)
 			goto again;
-		}
 	}
 
 	return addr;
@@ -1395,7 +1401,7 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
 	unsigned long end = start + size;
 
 	lru_add_drain();
-	tlb_gather_mmu(&tlb, mm, 0);
+	tlb_gather_mmu(&tlb, mm, start, end);
 	update_hiwater_rss(mm);
 	mmu_notifier_invalidate_range_start(mm, start, end);
 	for ( ; vma && vma->vm_start < end; vma = vma->vm_next)
@@ -1421,7 +1427,7 @@ static void zap_page_range_single(struct vm_area_struct *vma, unsigned long addr
 	unsigned long end = address + size;
 
 	lru_add_drain();
-	tlb_gather_mmu(&tlb, mm, 0);
+	tlb_gather_mmu(&tlb, mm, address, end);
 	update_hiwater_rss(mm);
 	mmu_notifier_invalidate_range_start(mm, address, end);
 	unmap_single_vma(&tlb, vma, address, end, details);
diff --git a/mm/mmap.c b/mm/mmap.c
index 6efac36..82fbbab 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2294,7 +2294,7 @@ static void unmap_region(struct mm_struct *mm,
 	struct mmu_gather tlb;
 
 	lru_add_drain();
-	tlb_gather_mmu(&tlb, mm, 0);
+	tlb_gather_mmu(&tlb, mm, start, end);
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end);
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
@@ -2671,7 +2671,7 @@ void exit_mmap(struct mm_struct *mm)
 
 	lru_add_drain();
 	flush_cache_mm(mm);
-	tlb_gather_mmu(&tlb, mm, 1);
+	tlb_gather_mmu(&tlb, mm, 0, -1);
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, vma, 0, -1);
-- 
1.8.1.2

