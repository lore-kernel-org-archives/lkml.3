Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847Ab3BSTd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:33:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35621 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933180Ab3BSTdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:33:24 -0500
Date: Tue, 19 Feb 2013 14:33:20 -0500 (EST)
Message-Id: <20130219.143320.1413047009797673492.davem@davemloft.net>
To: mroos@ut.ee
Cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: THP bug and crash on sparc64 3.8
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1302191405140.10147@math.ut.ee>
References: <alpine.SOC.1.00.1302191350280.10147@math.ut.ee>
	<alpine.SOC.1.00.1302191405140.10147@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Feb 2013 11:33:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@ut.ee>
Date: Tue, 19 Feb 2013 14:05:42 +0200 (EET)

>> Call Trace:
>>  [0000000000488d9c] __might_sleep+0x13c/0x240
>>  [000000000051204c] kmem_cache_alloc+0xcc/0x120
>>  [000000000044bfc0] tsb_grow+0x80/0x480
>>  [000000000044e814] hugetlb_setup+0x14/0xc0
>>  [000000000044bcb0] set_pmd_at+0x110/0x120
>>  [00000000005170b8] khugepaged+0xd78/0xf80
>>  [000000000047e508] kthread+0x88/0xa0
>>  [00000000004060a4] ret_from_syscall+0x1c/0x2c
>>  [0000000000000000]           (null)

First, thanks for (unlike me) testing with CONFIG_DEBUG_ATOMIC_SLEEP.

I'm testing the following patch and if you would do so as well I'd
appreciate it.

Thanks!

diff --git a/arch/sparc/include/asm/hugetlb.h b/arch/sparc/include/asm/hugetlb.h
index 9661e9b..d49dc54 100644
--- a/arch/sparc/include/asm/hugetlb.h
+++ b/arch/sparc/include/asm/hugetlb.h
@@ -12,7 +12,7 @@ pte_t huge_ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 
 static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm)
 {
-	hugetlb_setup(mm);
+	hugetlb_setup(mm, GFP_KERNEL);
 }
 
 static inline int is_hugepage_only_range(struct mm_struct *mm,
diff --git a/arch/sparc/include/asm/mmu_context_64.h b/arch/sparc/include/asm/mmu_context_64.h
index 9191ca6..fd6786f8 100644
--- a/arch/sparc/include/asm/mmu_context_64.h
+++ b/arch/sparc/include/asm/mmu_context_64.h
@@ -46,7 +46,7 @@ static inline void tsb_context_switch(struct mm_struct *mm)
 			     , __pa(&mm->context.tsb_descr[0]));
 }
 
-extern void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long mm_rss);
+extern void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long mm_rss, gfp_t gfp);
 #ifdef CONFIG_SMP
 extern void smp_tsb_sync(struct mm_struct *mm);
 #else
diff --git a/arch/sparc/include/asm/page_64.h b/arch/sparc/include/asm/page_64.h
index 4b39f74..f97ee3b 100644
--- a/arch/sparc/include/asm/page_64.h
+++ b/arch/sparc/include/asm/page_64.h
@@ -28,7 +28,7 @@
 
 #if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
 struct mm_struct;
-extern void hugetlb_setup(struct mm_struct *mm);
+extern void hugetlb_setup(struct mm_struct *mm, gfp_t gfp);
 #endif
 
 #define WANT_PAGE_VIRTUAL
diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index 097aee7..0852d98 100644
--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -468,12 +468,12 @@ good_area:
 #endif
 	if (unlikely(mm_rss >
 		     mm->context.tsb_block[MM_TSB_BASE].tsb_rss_limit))
-		tsb_grow(mm, MM_TSB_BASE, mm_rss);
+		tsb_grow(mm, MM_TSB_BASE, mm_rss, GFP_KERNEL);
 #if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
 	mm_rss = mm->context.huge_pte_count;
 	if (unlikely(mm_rss >
 		     mm->context.tsb_block[MM_TSB_HUGE].tsb_rss_limit))
-		tsb_grow(mm, MM_TSB_HUGE, mm_rss);
+		tsb_grow(mm, MM_TSB_HUGE, mm_rss, GFP_KERNEL);
 #endif
 	return;
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index c3b7242..0c23fa1 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2712,16 +2712,18 @@ static void context_reload(void *__data)
 		load_secondary_context(mm);
 }
 
-void hugetlb_setup(struct mm_struct *mm)
+void hugetlb_setup(struct mm_struct *mm, gfp_t gfp)
 {
 	struct tsb_config *tp = &mm->context.tsb_block[MM_TSB_HUGE];
 
 	if (likely(tp->tsb != NULL))
 		return;
 
-	tsb_grow(mm, MM_TSB_HUGE, 0);
-	tsb_context_switch(mm);
-	smp_tsb_sync(mm);
+	tsb_grow(mm, MM_TSB_HUGE, 0, gfp);
+	if (tp->tsb != NULL) {
+		tsb_context_switch(mm);
+		smp_tsb_sync(mm);
+	}
 
 	/* On UltraSPARC-III+ and later, configure the second half of
 	 * the Data-TLB for huge pages.
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index 3e8fec3..de51c40 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -136,7 +136,7 @@ void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 		else
 			mm->context.huge_pte_count--;
 		if (mm->context.huge_pte_count == 1)
-			hugetlb_setup(mm);
+			hugetlb_setup(mm, GFP_ATOMIC);
 	}
 
 	if (!pmd_none(orig)) {
diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index 7f64743..338b406 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -288,14 +288,13 @@ static unsigned long tsb_size_to_rss_limit(unsigned long new_size)
  * the number of entries that the current TSB can hold at once.  Currently,
  * we trigger when the RSS hits 3/4 of the TSB capacity.
  */
-void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss)
+void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss, gfp_t gfp)
 {
 	unsigned long max_tsb_size = 1 * 1024 * 1024;
 	unsigned long new_size, old_size, flags;
 	struct tsb *old_tsb, *new_tsb;
 	unsigned long new_cache_index, old_cache_index;
 	unsigned long new_rss_limit;
-	gfp_t gfp_flags;
 
 	if (max_tsb_size > (PAGE_SIZE << MAX_ORDER))
 		max_tsb_size = (PAGE_SIZE << MAX_ORDER);
@@ -312,12 +311,11 @@ void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss)
 		new_rss_limit = ~0UL;
 
 retry_tsb_alloc:
-	gfp_flags = GFP_KERNEL;
 	if (new_size > (PAGE_SIZE * 2))
-		gfp_flags = __GFP_NOWARN | __GFP_NORETRY;
+		gfp = __GFP_NOWARN | __GFP_NORETRY;
 
 	new_tsb = kmem_cache_alloc_node(tsb_caches[new_cache_index],
-					gfp_flags, numa_node_id());
+					gfp, numa_node_id());
 	if (unlikely(!new_tsb)) {
 		/* Not being able to fork due to a high-order TSB
 		 * allocation failure is very bad behavior.  Just back
@@ -457,11 +455,11 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 	/* If this is fork, inherit the parent's TSB size.  We would
 	 * grow it to that size on the first page fault anyways.
 	 */
-	tsb_grow(mm, MM_TSB_BASE, get_mm_rss(mm));
+	tsb_grow(mm, MM_TSB_BASE, get_mm_rss(mm), GFP_KERNEL);
 
 #if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
 	if (unlikely(huge_pte_count))
-		tsb_grow(mm, MM_TSB_HUGE, huge_pte_count);
+		tsb_grow(mm, MM_TSB_HUGE, huge_pte_count, GFP_KERNEL);
 #endif
 
 	if (unlikely(!mm->context.tsb_block[MM_TSB_BASE].tsb))
