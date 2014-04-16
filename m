Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaDPLrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:47:04 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49221 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbaDPLqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:46:54 -0400
From: Steve Capper <steve.capper@linaro.org>
To: linux@arm.linux.org.uk, akpm@linux-foundation.org
Cc: will.deacon@arm.com, catalin.marinas@arm.com, robherring2@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gerald.schaefer@de.ibm.com,
        Steve Capper <steve.capper@linaro.org>
Subject: [PATCH V2 2/5] arm: mm: Adjust the parameters for __sync_icache_dcache
Date: Wed, 16 Apr 2014 12:46:40 +0100
Message-Id: <1397648803-15961-3-git-send-email-steve.capper@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397648803-15961-1-git-send-email-steve.capper@linaro.org>
References: <1397648803-15961-1-git-send-email-steve.capper@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than take a pte_t as an input, break this down to the pfn
and whether or not the memory is executable.

This allows us to use this function for ptes and pmds.

Signed-off-by: Steve Capper <steve.capper@linaro.org>
---
 arch/arm/include/asm/pgtable.h | 6 +++---
 arch/arm/mm/flush.c            | 9 ++++-----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 5478e5d..3a9c238 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -228,11 +228,11 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 	(pte_valid(pte) && (pte_val(pte) & L_PTE_USER) && pte_young(pte))
 
 #if __LINUX_ARM_ARCH__ < 6
-static inline void __sync_icache_dcache(pte_t pteval)
+static inline void __sync_icache_dcache(unsigned long pfn, int exec);
 {
 }
 #else
-extern void __sync_icache_dcache(pte_t pteval);
+extern void __sync_icache_dcache(unsigned long pfn, int exec);
 #endif
 
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
@@ -241,7 +241,7 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 	unsigned long ext = 0;
 
 	if (addr < TASK_SIZE && pte_valid_user(pteval)) {
-		__sync_icache_dcache(pteval);
+		__sync_icache_dcache(pte_pfn(pteval), pte_exec(pteval));
 		ext |= PTE_EXT_NG;
 	}
 
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 3387e60..df0d5ca 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -232,16 +232,15 @@ static void __flush_dcache_aliases(struct address_space *mapping, struct page *p
 }
 
 #if __LINUX_ARM_ARCH__ >= 6
-void __sync_icache_dcache(pte_t pteval)
+void __sync_icache_dcache(unsigned long pfn, int exec)
 {
-	unsigned long pfn;
 	struct page *page;
 	struct address_space *mapping;
 
-	if (cache_is_vipt_nonaliasing() && !pte_exec(pteval))
+	if (cache_is_vipt_nonaliasing() && !exec)
 		/* only flush non-aliasing VIPT caches for exec mappings */
 		return;
-	pfn = pte_pfn(pteval);
+
 	if (!pfn_valid(pfn))
 		return;
 
@@ -254,7 +253,7 @@ void __sync_icache_dcache(pte_t pteval)
 	if (!test_and_set_bit(PG_dcache_clean, &page->flags))
 		__flush_dcache_page(mapping, page);
 
-	if (pte_exec(pteval))
+	if (exec)
 		__flush_icache_all();
 }
 #endif
-- 
1.8.1.4

