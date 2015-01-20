Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbbATJ5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:57:40 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:40446 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbbATJ5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:57:36 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v2 03/11] powerpc32: Use kmem_cache memory for PGDIR
Message-Id: <20150120095734.4C1B01A5E88@localhost.localdomain>
Date: Tue, 20 Jan 2015 10:57:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pages are not 4K, PGDIR table is allocated with kmalloc(). In order to
optimise TLB handlers, aligned memory is needed. kmalloc() doesn't provide
aligned memory blocks, so lets use a kmem_cache pool instead.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2: changed to apply cleanly to linux-next (due to patch ab090dc)

 arch/powerpc/include/asm/pgtable-ppc32.h |  4 ++++
 arch/powerpc/mm/pgtable_32.c             | 16 ++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
index c718bfd..affc703 100644
--- a/arch/powerpc/include/asm/pgtable-ppc32.h
+++ b/arch/powerpc/include/asm/pgtable-ppc32.h
@@ -341,10 +341,14 @@ static inline void __ptep_set_access_flags(pte_t *ptep, pte_t entry)
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) >> 3 })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val << 3 })
 
+#ifndef CONFIG_PPC_4K_PAGES
+void pgtable_cache_init(void);
+#else
 /*
  * No page table caches to initialise
  */
 #define pgtable_cache_init()	do { } while (0)
+#endif
 
 extern int get_pteptr(struct mm_struct *mm, unsigned long addr, pte_t **ptep,
 		      pmd_t **pmdp);
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 50fad38..c06599f 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -73,13 +73,25 @@ extern unsigned long p_mapped_by_tlbcam(phys_addr_t pa);
 
 #define PGDIR_ORDER	(32 + PGD_T_LOG2 - PGDIR_SHIFT)
 
+#ifndef CONFIG_PPC_4K_PAGES
+static struct kmem_cache *pgtable_cache;
+
+void pgtable_cache_init(void)
+{
+	pgtable_cache = kmem_cache_create("PGDIR cache", 1 << PGDIR_ORDER,
+					  1 << PGDIR_ORDER, 0, NULL);
+	if (pgtable_cache == NULL)
+		panic("Couldn't allocate pgtable caches");
+}
+#endif
+
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *ret;
 
 	/* pgdir take page or two with 4K pages and a page fraction otherwise */
 #ifndef CONFIG_PPC_4K_PAGES
-	ret = kzalloc(1 << PGDIR_ORDER, GFP_KERNEL);
+	ret = kmem_cache_alloc(pgtable_cache, GFP_KERNEL | __GFP_ZERO);
 #else
 	ret = (pgd_t *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
 			PGDIR_ORDER - PAGE_SHIFT);
@@ -90,7 +102,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
 #ifndef CONFIG_PPC_4K_PAGES
-	kfree((void *)pgd);
+	kmem_cache_free(pgtable_cache, (void *)pgd);
 #else
 	free_pages((unsigned long)pgd, PGDIR_ORDER - PAGE_SHIFT);
 #endif
-- 
2.1.0

