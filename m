Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab3LPEIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:08:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47594 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3LPEIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:08:18 -0500
From: Allen Pais <allen.pais@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: sparclinux@vger.kernel.org, bigeasy@linutronix.de,
        Allen Pais <allen.pais@oracle.com>
Subject: [PATCH 3/3] sparc64: convert ctx_alloc_lock raw_spinlock_t
Date: Mon, 16 Dec 2013 09:37:33 +0530
Message-Id: <1387166853-10782-4-git-send-email-allen.pais@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387166853-10782-1-git-send-email-allen.pais@oracle.com>
References: <1387166853-10782-1-git-send-email-allen.pais@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Allen Pais <allen.pais@oracle.com>
---
 arch/sparc/include/asm/mmu_context_64.h |    2 +-
 arch/sparc/mm/init_64.c                 |   10 +++++-----
 arch/sparc/mm/tsb.c                     |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/sparc/include/asm/mmu_context_64.h b/arch/sparc/include/asm/mmu_context_64.h
index 3a85624..44e393b 100644
--- a/arch/sparc/include/asm/mmu_context_64.h
+++ b/arch/sparc/include/asm/mmu_context_64.h
@@ -13,7 +13,7 @@ static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 }
 
-extern spinlock_t ctx_alloc_lock;
+extern raw_spinlock_t ctx_alloc_lock;
 extern unsigned long tlb_context_cache;
 extern unsigned long mmu_context_bmap[];
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index bd5253d..ac5ae7a 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -661,7 +661,7 @@ void __flush_dcache_range(unsigned long start, unsigned long end)
 EXPORT_SYMBOL(__flush_dcache_range);
 
 /* get_new_mmu_context() uses "cache + 1".  */
-DEFINE_SPINLOCK(ctx_alloc_lock);
+DEFINE_RAW_SPINLOCK(ctx_alloc_lock);
 unsigned long tlb_context_cache = CTX_FIRST_VERSION - 1;
 #define MAX_CTX_NR	(1UL << CTX_NR_BITS)
 #define CTX_BMAP_SLOTS	BITS_TO_LONGS(MAX_CTX_NR)
@@ -683,7 +683,7 @@ void get_new_mmu_context(struct mm_struct *mm)
 	unsigned long orig_pgsz_bits;
 	int new_version;
 
-	spin_lock(&ctx_alloc_lock);
+	raw_spin_lock(&ctx_alloc_lock);
 	orig_pgsz_bits = (mm->context.sparc64_ctx_val & CTX_PGSZ_MASK);
 	ctx = (tlb_context_cache + 1) & CTX_NR_MASK;
 	new_ctx = find_next_zero_bit(mmu_context_bmap, 1 << CTX_NR_BITS, ctx);
@@ -719,7 +719,7 @@ void get_new_mmu_context(struct mm_struct *mm)
 out:
 	tlb_context_cache = new_ctx;
 	mm->context.sparc64_ctx_val = new_ctx | orig_pgsz_bits;
-	spin_unlock(&ctx_alloc_lock);
+	raw_spin_unlock(&ctx_alloc_lock);
 
 	if (unlikely(new_version))
 		smp_new_mmu_context_version();
@@ -2739,7 +2739,7 @@ void hugetlb_setup(struct pt_regs *regs)
 	if (tlb_type == cheetah_plus) {
 		unsigned long ctx;
 
-		spin_lock(&ctx_alloc_lock);
+		raw_spin_lock(&ctx_alloc_lock);
 		ctx = mm->context.sparc64_ctx_val;
 		ctx &= ~CTX_PGSZ_MASK;
 		ctx |= CTX_PGSZ_BASE << CTX_PGSZ0_SHIFT;
@@ -2760,7 +2760,7 @@ void hugetlb_setup(struct pt_regs *regs)
 			mm->context.sparc64_ctx_val = ctx;
 			on_each_cpu(context_reload, mm, 0);
 		}
-		spin_unlock(&ctx_alloc_lock);
+		raw_spin_unlock(&ctx_alloc_lock);
 	}
 }
 #endif
diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index d84d4ea..9eb10b4 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -523,12 +523,12 @@ void destroy_context(struct mm_struct *mm)
 		free_hot_cold_page(page, 0);
 	}
 
-	spin_lock_irqsave(&ctx_alloc_lock, flags);
+	raw_spin_lock_irqsave(&ctx_alloc_lock, flags);
 
 	if (CTX_VALID(mm->context)) {
 		unsigned long nr = CTX_NRBITS(mm->context);
 		mmu_context_bmap[nr>>6] &= ~(1UL << (nr & 63));
 	}
 
-	spin_unlock_irqrestore(&ctx_alloc_lock, flags);
+	raw_spin_unlock_irqrestore(&ctx_alloc_lock, flags);
 }
-- 
1.7.10.4

