Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab3HLQQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:16:03 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:58861 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab3HLQPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:15:52 -0400
Message-ID: <201308121615.r7CGFpwu024704@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 12 Aug 2013 11:15:46 -0400
Subject: [PATCH] tile: handle super huge pages in virt_to_pte
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tile-specific API had a minor bug, in that if a super huge (>4GB)
page mapped a particular address range, we wouldn't handle it correctly.
As part of fixing that bug, I also cleaned up some of the pud and pmd
accessors to make them more consistent.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/pgtable_32.h |  2 ++
 arch/tile/include/asm/pgtable_64.h | 24 +++++++++++++++++-------
 arch/tile/mm/pgtable.c             |  3 +++
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/tile/include/asm/pgtable_32.h b/arch/tile/include/asm/pgtable_32.h
index 4ce4a7a..e5bdc0e 100644
--- a/arch/tile/include/asm/pgtable_32.h
+++ b/arch/tile/include/asm/pgtable_32.h
@@ -84,6 +84,8 @@ extern unsigned long VMALLOC_RESERVE /* = CONFIG_VMALLOC_RESERVE */;
 /* We have no pmd or pud since we are strictly a two-level page table */
 #include <asm-generic/pgtable-nopmd.h>
 
+static inline int pud_huge_page(pud_t pud)	{ return 0; }
+
 /* We don't define any pgds for these addresses. */
 static inline int pgd_addr_invalid(unsigned long addr)
 {
diff --git a/arch/tile/include/asm/pgtable_64.h b/arch/tile/include/asm/pgtable_64.h
index 2492fa5..7cb8d35 100644
--- a/arch/tile/include/asm/pgtable_64.h
+++ b/arch/tile/include/asm/pgtable_64.h
@@ -63,6 +63,15 @@
 /* We have no pud since we are a three-level page table. */
 #include <asm-generic/pgtable-nopud.h>
 
+/*
+ * pmds are the same as pgds and ptes, so converting is a no-op.
+ */
+#define pmd_pte(pmd) (pmd)
+#define pmdp_ptep(pmdp) (pmdp)
+#define pte_pmd(pte) (pte)
+
+#define pud_pte(pud) ((pud).pgd)
+
 static inline int pud_none(pud_t pud)
 {
 	return pud_val(pud) == 0;
@@ -73,6 +82,11 @@ static inline int pud_present(pud_t pud)
 	return pud_val(pud) & _PAGE_PRESENT;
 }
 
+static inline int pud_huge_page(pud_t pud)
+{
+	return pud_val(pud) & _PAGE_HUGE_PAGE;
+}
+
 #define pmd_ERROR(e) \
 	pr_err("%s:%d: bad pmd 0x%016llx.\n", __FILE__, __LINE__, pmd_val(e))
 
@@ -89,6 +103,9 @@ static inline int pud_bad(pud_t pud)
 /* Return the page-table frame number (ptfn) that a pud_t points at. */
 #define pud_ptfn(pud) hv_pte_get_ptfn((pud).pgd)
 
+/* Return the page frame number (pfn) that a pud_t points at. */
+#define pud_pfn(pud) pte_pfn(pud_pte(pud))
+
 /*
  * A given kernel pud_t maps to a kernel pmd_t table at a specific
  * virtual address.  Since kernel pmd_t tables can be aligned at
@@ -152,13 +169,6 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	return hv_pte(__insn_exch(&ptep->val, 0UL));
 }
 
-/*
- * pmds are the same as pgds and ptes, so converting is a no-op.
- */
-#define pmd_pte(pmd) (pmd)
-#define pmdp_ptep(pmdp) (pmdp)
-#define pte_pmd(pte) (pte)
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_TILE_PGTABLE_64_H */
diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index e41487e..3004433 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -338,6 +338,8 @@ pte_t *virt_to_pte(struct mm_struct* mm, unsigned long addr)
 	pud = pud_offset(pgd, addr);
 	if (!pud_present(*pud))
 		return NULL;
+	if (pud_huge_page(*pud))
+		return (pte_t *)pud;
 	pmd = pmd_offset(pud, addr);
 	if (pmd_huge_page(*pmd))
 		return (pte_t *)pmd;
@@ -345,6 +347,7 @@ pte_t *virt_to_pte(struct mm_struct* mm, unsigned long addr)
 		return NULL;
 	return pte_offset_kernel(pmd, addr);
 }
+EXPORT_SYMBOL(virt_to_pte);
 
 pgprot_t set_remote_cache_cpu(pgprot_t prot, int cpu)
 {
-- 
1.8.3.1

