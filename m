Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217Ab3LRFme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:42:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33322 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3LRFmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:42:32 -0500
From: Allen Pais <allen.pais@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: sparclinux@vger.kernel.org, bigeasy@linutronix.de,
        Allen Pais <allen.pais@oracle.com>
Subject: [PATCH 2/3] [RESEND]sparc64: convert spinloc_t to raw_spinlock_t in  mmu_context_t
Date: Wed, 18 Dec 2013 11:12:05 +0530
Message-Id: <1387345326-20185-1-git-send-email-allen.pais@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the attempt of get PREEMPT_RT working on sparc64 using
linux-stable-rt version 3.10.22-rt19+, the kernel crash
with the following trace:

[ 1487.027884] I7: <rt_mutex_setprio+0x3c/0x2c0>
[ 1487.027885] Call Trace:
[ 1487.027887]  [00000000004967dc] rt_mutex_setprio+0x3c/0x2c0
[ 1487.027892]  [00000000004afe20] task_blocks_on_rt_mutex+0x180/0x200
[ 1487.027895]  [0000000000819114] rt_spin_lock_slowlock+0x94/0x300
[ 1487.027897]  [0000000000817ebc] __schedule+0x39c/0x53c
[ 1487.027899]  [00000000008185fc] schedule+0x1c/0xc0
[ 1487.027908]  [000000000048fff4] smpboot_thread_fn+0x154/0x2e0
[ 1487.027913]  [000000000048753c] kthread+0x7c/0xa0
[ 1487.027920]  [00000000004060c4] ret_from_syscall+0x1c/0x2c
[ 1487.027922]  [0000000000000000]           (null)

Thomas debugged this issue and pointed to switch_mm

        spin_lock_irqsave(&mm->context.lock, flags);

context.lock needs to be a raw_spinlock.

Signed-off-by: Allen Pais <allen.pais@oracle.com>
---
 arch/sparc/Kconfig                      |    1 +
 arch/sparc/include/asm/mmu_64.h         |    2 +-
 arch/sparc/include/asm/mmu_context_64.h |    8 ++++----
 arch/sparc/kernel/smp_64.c              |    4 ++--
 arch/sparc/mm/init_64.c                 |    4 ++--
 arch/sparc/mm/tsb.c                     |   16 ++++++++--------
 6 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 554995d..aae5aa9 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -27,6 +27,7 @@ config SPARC
 	select HAVE_DMA_API_DEBUG
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_GENERIC_HARDIRQS
+	select IRQ_FORCED_THREADING
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select USE_GENERIC_SMP_HELPERS if SMP
diff --git a/arch/sparc/include/asm/mmu_64.h b/arch/sparc/include/asm/mmu_64.h
index 76092c4..e945ddb 100644
--- a/arch/sparc/include/asm/mmu_64.h
+++ b/arch/sparc/include/asm/mmu_64.h
@@ -90,7 +90,7 @@ struct tsb_config {
 #endif
 
 typedef struct {
-	spinlock_t		lock;
+	raw_spinlock_t		lock;
 	unsigned long		sparc64_ctx_val;
 	unsigned long		huge_pte_count;
 	struct page		*pgtable_page;
diff --git a/arch/sparc/include/asm/mmu_context_64.h b/arch/sparc/include/asm/mmu_context_64.h
index 3d528f0..3a85624 100644
--- a/arch/sparc/include/asm/mmu_context_64.h
+++ b/arch/sparc/include/asm/mmu_context_64.h
@@ -77,7 +77,7 @@ static inline void switch_mm(struct mm_struct *old_mm, struct mm_struct *mm, str
 	if (unlikely(mm == &init_mm))
 		return;
 
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 	ctx_valid = CTX_VALID(mm->context);
 	if (!ctx_valid)
 		get_new_mmu_context(mm);
@@ -125,7 +125,7 @@ static inline void switch_mm(struct mm_struct *old_mm, struct mm_struct *mm, str
 		__flush_tlb_mm(CTX_HWBITS(mm->context),
 			       SECONDARY_CONTEXT);
 	}
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 }
 
 #define deactivate_mm(tsk,mm)	do { } while (0)
@@ -136,7 +136,7 @@ static inline void activate_mm(struct mm_struct *active_mm, struct mm_struct *mm
 	unsigned long flags;
 	int cpu;
 
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 	if (!CTX_VALID(mm->context))
 		get_new_mmu_context(mm);
 	cpu = smp_processor_id();
@@ -146,7 +146,7 @@ static inline void activate_mm(struct mm_struct *active_mm, struct mm_struct *mm
 	load_secondary_context(mm);
 	__flush_tlb_mm(CTX_HWBITS(mm->context), SECONDARY_CONTEXT);
 	tsb_context_switch(mm);
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 }
 
 #endif /* !(__ASSEMBLY__) */
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 77539ed..f42e1a7 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -975,12 +975,12 @@ void __irq_entry smp_new_mmu_context_version_client(int irq, struct pt_regs *reg
 	if (unlikely(!mm || (mm == &init_mm)))
 		return;
 
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 
 	if (unlikely(!CTX_VALID(mm->context)))
 		get_new_mmu_context(mm);
 
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 
 	load_secondary_context(mm);
 	__flush_tlb_mm(CTX_HWBITS(mm->context),
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 04fd55a..bd5253d 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -350,7 +350,7 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *
 
 	mm = vma->vm_mm;
 
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 
 #if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
 	if (mm->context.huge_pte_count && is_hugetlb_pte(pte))
@@ -361,7 +361,7 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *
 		__update_mmu_tsb_insert(mm, MM_TSB_BASE, PAGE_SHIFT,
 					address, pte_val(pte));
 
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 }
 
 void flush_dcache_page(struct page *page)
diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index 2cc3bce..d84d4ea 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -73,7 +73,7 @@ void flush_tsb_user(struct tlb_batch *tb)
 	struct mm_struct *mm = tb->mm;
 	unsigned long nentries, base, flags;
 
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 
 	base = (unsigned long) mm->context.tsb_block[MM_TSB_BASE].tsb;
 	nentries = mm->context.tsb_block[MM_TSB_BASE].tsb_nentries;
@@ -90,14 +90,14 @@ void flush_tsb_user(struct tlb_batch *tb)
 		__flush_tsb_one(tb, HPAGE_SHIFT, base, nentries);
 	}
 #endif
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 }
 
 void flush_tsb_user_page(struct mm_struct *mm, unsigned long vaddr)
 {
 	unsigned long nentries, base, flags;
 
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 
 	base = (unsigned long) mm->context.tsb_block[MM_TSB_BASE].tsb;
 	nentries = mm->context.tsb_block[MM_TSB_BASE].tsb_nentries;
@@ -114,7 +114,7 @@ void flush_tsb_user_page(struct mm_struct *mm, unsigned long vaddr)
 		__flush_tsb_one_entry(base, vaddr, HPAGE_SHIFT, nentries);
 	}
 #endif
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 }
 
 #define HV_PGSZ_IDX_BASE	HV_PGSZ_IDX_8K
@@ -392,7 +392,7 @@ retry_tsb_alloc:
 	 * the lock and ask all other cpus running this address space
 	 * to run tsb_context_switch() to see the new TSB table.
 	 */
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 
 	old_tsb = mm->context.tsb_block[tsb_index].tsb;
 	old_cache_index =
@@ -407,7 +407,7 @@ retry_tsb_alloc:
 	 */
 	if (unlikely(old_tsb &&
 		     (rss < mm->context.tsb_block[tsb_index].tsb_rss_limit))) {
-		spin_unlock_irqrestore(&mm->context.lock, flags);
+		raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 
 		kmem_cache_free(tsb_caches[new_cache_index], new_tsb);
 		return;
@@ -433,7 +433,7 @@ retry_tsb_alloc:
 	mm->context.tsb_block[tsb_index].tsb = new_tsb;
 	setup_tsb_params(mm, tsb_index, new_size);
 
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 
 	/* If old_tsb is NULL, we're being invoked for the first time
 	 * from init_new_context().
@@ -459,7 +459,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 #endif
 	unsigned int i;
 
-	spin_lock_init(&mm->context.lock);
+	raw_spin_lock_init(&mm->context.lock);
 
 	mm->context.sparc64_ctx_val = 0UL;
 
-- 
1.7.10.4

