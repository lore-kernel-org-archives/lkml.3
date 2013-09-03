Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab3ICQZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:25:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46455 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952Ab3ICQYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:24:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 25/58] arch, mm: Remove tlb_fast_mode()
Date: Tue,  3 Sep 2013 09:23:29 -0700
Message-Id: <1378225442-20654-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 29eb77825cc7da8d45b642de2de3d423dc8a363f upstream.

Since the introduction of preemptible mmu_gather TLB fast mode has been
broken. TLB fast mode relies on there being absolutely no concurrency;
it frees pages first and invalidates TLBs later.

However now we can get concurrency and stuff goes *bang*.

This patch removes all tlb_fast_mode() code; it was found the better
option vs trying to patch the hole by entangling tlb invalidation with
the scheduler.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Reported-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: 3.8.y-stable prereq for:
  2b04725 Fix TLB gather virtual address range invalidation corner cases ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/include/asm/tlb.h  | 27 ++++-----------------------
 arch/ia64/include/asm/tlb.h | 41 ++++++++---------------------------------
 include/asm-generic/tlb.h   | 17 +----------------
 mm/memory.c                 |  9 ---------
 4 files changed, 13 insertions(+), 81 deletions(-)

diff --git a/arch/arm/include/asm/tlb.h b/arch/arm/include/asm/tlb.h
index 99a1951..bdf2b84 100644
--- a/arch/arm/include/asm/tlb.h
+++ b/arch/arm/include/asm/tlb.h
@@ -33,18 +33,6 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
-/*
- * We need to delay page freeing for SMP as other CPUs can access pages
- * which have been removed but not yet had their TLB entries invalidated.
- * Also, as ARMv7 speculative prefetch can drag new entries into the TLB,
- * we need to apply this same delaying tactic to ensure correct operation.
- */
-#if defined(CONFIG_SMP) || defined(CONFIG_CPU_32v7)
-#define tlb_fast_mode(tlb)	0
-#else
-#define tlb_fast_mode(tlb)	1
-#endif
-
 #define MMU_GATHER_BUNDLE	8
 
 /*
@@ -112,12 +100,10 @@ static inline void __tlb_alloc_page(struct mmu_gather *tlb)
 static inline void tlb_flush_mmu(struct mmu_gather *tlb)
 {
 	tlb_flush(tlb);
-	if (!tlb_fast_mode(tlb)) {
-		free_pages_and_swap_cache(tlb->pages, tlb->nr);
-		tlb->nr = 0;
-		if (tlb->pages == tlb->local)
-			__tlb_alloc_page(tlb);
-	}
+	free_pages_and_swap_cache(tlb->pages, tlb->nr);
+	tlb->nr = 0;
+	if (tlb->pages == tlb->local)
+		__tlb_alloc_page(tlb);
 }
 
 static inline void
@@ -178,11 +164,6 @@ tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
 
 static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
-	if (tlb_fast_mode(tlb)) {
-		free_page_and_swap_cache(page);
-		return 1; /* avoid calling tlb_flush_mmu */
-	}
-
 	tlb->pages[tlb->nr++] = page;
 	VM_BUG_ON(tlb->nr > tlb->max);
 	return tlb->max - tlb->nr;
diff --git a/arch/ia64/include/asm/tlb.h b/arch/ia64/include/asm/tlb.h
index c3ffe3e..ef3a9de 100644
--- a/arch/ia64/include/asm/tlb.h
+++ b/arch/ia64/include/asm/tlb.h
@@ -46,12 +46,6 @@
 #include <asm/tlbflush.h>
 #include <asm/machvec.h>
 
-#ifdef CONFIG_SMP
-# define tlb_fast_mode(tlb)	((tlb)->nr == ~0U)
-#else
-# define tlb_fast_mode(tlb)	(1)
-#endif
-
 /*
  * If we can't allocate a page to make a big batch of page pointers
  * to work on, then just handle a few from the on-stack structure.
@@ -60,7 +54,7 @@
 
 struct mmu_gather {
 	struct mm_struct	*mm;
-	unsigned int		nr;		/* == ~0U => fast mode */
+	unsigned int		nr;
 	unsigned int		max;
 	unsigned char		fullmm;		/* non-zero means full mm flush */
 	unsigned char		need_flush;	/* really unmapped some PTEs? */
@@ -103,6 +97,7 @@ extern struct ia64_tr_entry *ia64_idtrs[NR_CPUS];
 static inline void
 ia64_tlb_flush_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
+	unsigned long i;
 	unsigned int nr;
 
 	if (!tlb->need_flush)
@@ -141,13 +136,11 @@ ia64_tlb_flush_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long e
 
 	/* lastly, release the freed pages */
 	nr = tlb->nr;
-	if (!tlb_fast_mode(tlb)) {
-		unsigned long i;
-		tlb->nr = 0;
-		tlb->start_addr = ~0UL;
-		for (i = 0; i < nr; ++i)
-			free_page_and_swap_cache(tlb->pages[i]);
-	}
+
+	tlb->nr = 0;
+	tlb->start_addr = ~0UL;
+	for (i = 0; i < nr; ++i)
+		free_page_and_swap_cache(tlb->pages[i]);
 }
 
 static inline void __tlb_alloc_page(struct mmu_gather *tlb)
@@ -167,20 +160,7 @@ tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_m
 	tlb->mm = mm;
 	tlb->max = ARRAY_SIZE(tlb->local);
 	tlb->pages = tlb->local;
-	/*
-	 * Use fast mode if only 1 CPU is online.
-	 *
-	 * It would be tempting to turn on fast-mode for full_mm_flush as well.  But this
-	 * doesn't work because of speculative accesses and software prefetching: the page
-	 * table of "mm" may (and usually is) the currently active page table and even
-	 * though the kernel won't do any user-space accesses during the TLB shoot down, a
-	 * compiler might use speculation or lfetch.fault on what happens to be a valid
-	 * user-space address.  This in turn could trigger a TLB miss fault (or a VHPT
-	 * walk) and re-insert a TLB entry we just removed.  Slow mode avoids such
-	 * problems.  (We could make fast-mode work by switching the current task to a
-	 * different "mm" during the shootdown.) --davidm 08/02/2002
-	 */
-	tlb->nr = (num_online_cpus() == 1) ? ~0U : 0;
+	tlb->nr = 0;
 	tlb->fullmm = full_mm_flush;
 	tlb->start_addr = ~0UL;
 }
@@ -214,11 +194,6 @@ static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	tlb->need_flush = 1;
 
-	if (tlb_fast_mode(tlb)) {
-		free_page_and_swap_cache(page);
-		return 1; /* avoid calling tlb_flush_mmu */
-	}
-
 	if (!tlb->nr && tlb->pages == tlb->local)
 		__tlb_alloc_page(tlb);
 
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index b1b1fa6..13821c3 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -97,11 +97,9 @@ struct mmu_gather {
 	unsigned long		start;
 	unsigned long		end;
 	unsigned int		need_flush : 1,	/* Did free PTEs */
-				fast_mode  : 1; /* No batching   */
-
 	/* we are in the middle of an operation to clear
 	 * a full mm and can make some optimizations */
-	unsigned int		fullmm : 1,
+				fullmm : 1,
 	/* we have performed an operation which
 	 * requires a complete flush of the tlb */
 				need_flush_all : 1;
@@ -114,19 +112,6 @@ struct mmu_gather {
 
 #define HAVE_GENERIC_MMU_GATHER
 
-static inline int tlb_fast_mode(struct mmu_gather *tlb)
-{
-#ifdef CONFIG_SMP
-	return tlb->fast_mode;
-#else
-	/*
-	 * For UP we don't need to worry about TLB flush
-	 * and page free order so much..
-	 */
-	return 1;
-#endif
-}
-
 void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm);
 void tlb_flush_mmu(struct mmu_gather *tlb);
 void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start,
diff --git a/mm/memory.c b/mm/memory.c
index b81825a..e4595bd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -216,7 +216,6 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm)
 	tlb->start	= -1UL;
 	tlb->end	= 0;
 	tlb->need_flush = 0;
-	tlb->fast_mode  = (num_possible_cpus() == 1);
 	tlb->local.next = NULL;
 	tlb->local.nr   = 0;
 	tlb->local.max  = ARRAY_SIZE(tlb->__pages);
@@ -240,9 +239,6 @@ void tlb_flush_mmu(struct mmu_gather *tlb)
 	tlb_table_flush(tlb);
 #endif
 
-	if (tlb_fast_mode(tlb))
-		return;
-
 	for (batch = &tlb->local; batch; batch = batch->next) {
 		free_pages_and_swap_cache(batch->pages, batch->nr);
 		batch->nr = 0;
@@ -284,11 +280,6 @@ int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 
 	VM_BUG_ON(!tlb->need_flush);
 
-	if (tlb_fast_mode(tlb)) {
-		free_page_and_swap_cache(page);
-		return 1; /* avoid calling tlb_flush_mmu() */
-	}
-
 	batch = tlb->active;
 	batch->pages[batch->nr++] = page;
 	if (batch->nr == batch->max) {
-- 
1.8.1.2

