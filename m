Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaF3Mds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:33:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755267AbaF3McA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:32:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, Russell King <rmk@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 110/181] hugetlb: restrict hugepage_migration_support() to x86_64
Date: Mon, 30 Jun 2014 13:52:11 +0200
Message-Id: <66ca3eb0dc576823529a5d54fa0a2578dbd3e2c2.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c177c81e09e517bbf75b67762cdab1b83aba6976 upstream.

Currently hugepage migration is available for all archs which support
pmd-level hugepage, but testing is done only for x86_64 and there're
bugs for other archs.  So to avoid breaking such archs, this patch
limits the availability strictly to x86_64 until developers of other
archs get interested in enabling this feature.

Simply disabling hugepage migration on non-x86_64 archs is not enough to
fix the reported problem where sys_move_pages() hits the BUG_ON() in
follow_page(FOLL_GET), so let's fix this by checking if hugepage
migration is supported in vma_migratable().

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mm/hugetlbpage.c     |  5 -----
 arch/arm64/mm/hugetlbpage.c   |  5 -----
 arch/ia64/mm/hugetlbpage.c    |  5 -----
 arch/metag/mm/hugetlbpage.c   |  5 -----
 arch/mips/mm/hugetlbpage.c    |  5 -----
 arch/powerpc/mm/hugetlbpage.c | 10 ----------
 arch/s390/mm/hugetlbpage.c    |  5 -----
 arch/sh/mm/hugetlbpage.c      |  5 -----
 arch/sparc/mm/hugetlbpage.c   |  5 -----
 arch/tile/mm/hugetlbpage.c    |  5 -----
 arch/x86/Kconfig              |  4 ++++
 arch/x86/mm/hugetlbpage.c     | 10 ----------
 include/linux/hugetlb.h       | 13 +++++--------
 include/linux/mempolicy.h     |  6 ++++++
 mm/Kconfig                    |  3 +++
 15 files changed, 18 insertions(+), 73 deletions(-)

diff --git a/arch/arm/mm/hugetlbpage.c b/arch/arm/mm/hugetlbpage.c
index 54ee6163c181..66781bf34077 100644
--- a/arch/arm/mm/hugetlbpage.c
+++ b/arch/arm/mm/hugetlbpage.c
@@ -56,8 +56,3 @@ int pmd_huge(pmd_t pmd)
 {
 	return pmd_val(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
 }
-
-int pmd_huge_support(void)
-{
-	return 1;
-}
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 31eb959e9aa8..023747bf4dd7 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -58,11 +58,6 @@ int pud_huge(pud_t pud)
 #endif
 }
 
-int pmd_huge_support(void)
-{
-	return 1;
-}
-
 static __init int setup_hugepagesz(char *opt)
 {
 	unsigned long ps = memparse(opt, &opt);
diff --git a/arch/ia64/mm/hugetlbpage.c b/arch/ia64/mm/hugetlbpage.c
index 68232db98baa..76069c18ee42 100644
--- a/arch/ia64/mm/hugetlbpage.c
+++ b/arch/ia64/mm/hugetlbpage.c
@@ -114,11 +114,6 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
-int pmd_huge_support(void)
-{
-	return 0;
-}
-
 struct page *
 follow_huge_pmd(struct mm_struct *mm, unsigned long address, pmd_t *pmd, int write)
 {
diff --git a/arch/metag/mm/hugetlbpage.c b/arch/metag/mm/hugetlbpage.c
index 042431509b56..3c52fa6d0f8e 100644
--- a/arch/metag/mm/hugetlbpage.c
+++ b/arch/metag/mm/hugetlbpage.c
@@ -110,11 +110,6 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
-int pmd_huge_support(void)
-{
-	return 1;
-}
-
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff --git a/arch/mips/mm/hugetlbpage.c b/arch/mips/mm/hugetlbpage.c
index 01fda4419ed0..a7fee0dfb7a9 100644
--- a/arch/mips/mm/hugetlbpage.c
+++ b/arch/mips/mm/hugetlbpage.c
@@ -85,11 +85,6 @@ int pud_huge(pud_t pud)
 	return (pud_val(pud) & _PAGE_HUGE) != 0;
 }
 
-int pmd_huge_support(void)
-{
-	return 1;
-}
-
 struct page *
 follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 		pmd_t *pmd, int write)
diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index d67db4bd672d..834ca8eb38f2 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -86,11 +86,6 @@ int pgd_huge(pgd_t pgd)
 	 */
 	return ((pgd_val(pgd) & 0x3) != 0x0);
 }
-
-int pmd_huge_support(void)
-{
-	return 1;
-}
 #else
 int pmd_huge(pmd_t pmd)
 {
@@ -106,11 +101,6 @@ int pgd_huge(pgd_t pgd)
 {
 	return 0;
 }
-
-int pmd_huge_support(void)
-{
-	return 0;
-}
 #endif
 
 pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
diff --git a/arch/s390/mm/hugetlbpage.c b/arch/s390/mm/hugetlbpage.c
index d261c62e40a6..248445f92604 100644
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -223,11 +223,6 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
-int pmd_huge_support(void)
-{
-	return 1;
-}
-
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmdp, int write)
 {
diff --git a/arch/sh/mm/hugetlbpage.c b/arch/sh/mm/hugetlbpage.c
index 0d676a41081e..d7762349ea48 100644
--- a/arch/sh/mm/hugetlbpage.c
+++ b/arch/sh/mm/hugetlbpage.c
@@ -83,11 +83,6 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
-int pmd_huge_support(void)
-{
-	return 0;
-}
-
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff --git a/arch/sparc/mm/hugetlbpage.c b/arch/sparc/mm/hugetlbpage.c
index 96399646570a..d2b59441ebdd 100644
--- a/arch/sparc/mm/hugetlbpage.c
+++ b/arch/sparc/mm/hugetlbpage.c
@@ -234,11 +234,6 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
-int pmd_huge_support(void)
-{
-	return 0;
-}
-
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff --git a/arch/tile/mm/hugetlbpage.c b/arch/tile/mm/hugetlbpage.c
index 0cb3bbaa580c..e514899e1100 100644
--- a/arch/tile/mm/hugetlbpage.c
+++ b/arch/tile/mm/hugetlbpage.c
@@ -166,11 +166,6 @@ int pud_huge(pud_t pud)
 	return !!(pud_val(pud) & _PAGE_HUGE_PAGE);
 }
 
-int pmd_huge_support(void)
-{
-	return 1;
-}
-
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f67e839f06c8..eb2dfa61eabe 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1881,6 +1881,10 @@ config USE_PERCPU_NUMA_NODE_ID
 	def_bool y
 	depends on NUMA
 
+config ARCH_ENABLE_HUGEPAGE_MIGRATION
+	def_bool y
+	depends on X86_64 && HUGETLB_PAGE && MIGRATION
+
 menu "Power management and ACPI options"
 
 config ARCH_HIBERNATION_HEADER
diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 9d980d88b747..fa029fb2afae 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -58,11 +58,6 @@ follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 {
 	return NULL;
 }
-
-int pmd_huge_support(void)
-{
-	return 0;
-}
 #else
 
 struct page *
@@ -80,11 +75,6 @@ int pud_huge(pud_t pud)
 {
 	return !!(pud_val(pud) & _PAGE_PSE);
 }
-
-int pmd_huge_support(void)
-{
-	return 1;
-}
 #endif
 
 /* x86_64 also uses this file */
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 6125579b5207..5214ff63c351 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -387,15 +387,13 @@ static inline pgoff_t basepage_index(struct page *page)
 
 extern void dissolve_free_huge_pages(unsigned long start_pfn,
 				     unsigned long end_pfn);
-int pmd_huge_support(void);
-/*
- * Currently hugepage migration is enabled only for pmd-based hugepage.
- * This function will be updated when hugepage migration is more widely
- * supported.
- */
 static inline int hugepage_migration_support(struct hstate *h)
 {
-	return pmd_huge_support() && (huge_page_shift(h) == PMD_SHIFT);
+#ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
+	return huge_page_shift(h) == PMD_SHIFT;
+#else
+	return 0;
+#endif
 }
 
 #else	/* CONFIG_HUGETLB_PAGE */
@@ -425,7 +423,6 @@ static inline pgoff_t basepage_index(struct page *page)
 	return page->index;
 }
 #define dissolve_free_huge_pages(s, e)	do {} while (0)
-#define pmd_huge_support()	0
 #define hugepage_migration_support(h)	0
 #endif	/* CONFIG_HUGETLB_PAGE */
 
diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index da6716b9e3fe..ccc1b718c8f3 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -175,6 +175,12 @@ static inline int vma_migratable(struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
 		return 0;
+
+#ifndef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
+	if (vma->vm_flags & VM_HUGETLB)
+		return 0;
+#endif
+
 	/*
 	 * Migration allocates pages in the highest zone. If we cannot
 	 * do so then migration (at least from node to node) is not
diff --git a/mm/Kconfig b/mm/Kconfig
index 394838f489eb..2a092f5fa95a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -254,6 +254,9 @@ config MIGRATION
 	  pages as migration can relocate pages to satisfy a huge page
 	  allocation instead of reclaiming.
 
+config ARCH_ENABLE_HUGEPAGE_MIGRATION
+	boolean
+
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
 
-- 
2.0.0

