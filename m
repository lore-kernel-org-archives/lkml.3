Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbaGVTBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:01:30 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:41489 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbaGVTB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:01:27 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        linux-kernel@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 2/8] xtensa: allow fixmap and kmap span more than one page table
Date: Tue, 22 Jul 2014 23:01:07 +0400
Message-Id: <1406055673-10100-3-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
References: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support aliasing cache both kmap region sizes are multiplied by the
number of data cache colors. After that expansion page tables that cover
kmap regions may become larger than one page. Correctly allocate and
initialize page tables in this case.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/mm/mmu.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/xtensa/mm/mmu.c b/arch/xtensa/mm/mmu.c
index 3429b48..abe4513 100644
--- a/arch/xtensa/mm/mmu.c
+++ b/arch/xtensa/mm/mmu.c
@@ -18,32 +18,38 @@
 #include <asm/io.h>
 
 #if defined(CONFIG_HIGHMEM)
-static void * __init init_pmd(unsigned long vaddr)
+static void * __init init_pmd(unsigned long vaddr, unsigned long n_pages)
 {
 	pgd_t *pgd = pgd_offset_k(vaddr);
 	pmd_t *pmd = pmd_offset(pgd, vaddr);
+	pte_t *pte;
+	unsigned long i;
 
-	if (pmd_none(*pmd)) {
-		unsigned i;
-		pte_t *pte = alloc_bootmem_low_pages(PAGE_SIZE);
+	n_pages = ALIGN(n_pages, PTRS_PER_PTE);
 
-		for (i = 0; i < 1024; i++)
-			pte_clear(NULL, 0, pte + i);
+	pr_debug("%s: vaddr: 0x%08lx, n_pages: %ld\n",
+		 __func__, vaddr, n_pages);
 
-		set_pmd(pmd, __pmd(((unsigned long)pte) & PAGE_MASK));
-		BUG_ON(pte != pte_offset_kernel(pmd, 0));
-		pr_debug("%s: vaddr: 0x%08lx, pmd: 0x%p, pte: 0x%p\n",
-			 __func__, vaddr, pmd, pte);
-		return pte;
-	} else {
-		return pte_offset_kernel(pmd, 0);
+	pte = alloc_bootmem_low_pages(n_pages * sizeof(pte_t));
+
+	for (i = 0; i < n_pages; ++i)
+		pte_clear(NULL, 0, pte + i);
+
+	for (i = 0; i < n_pages; i += PTRS_PER_PTE, ++pmd) {
+		pte_t *cur_pte = pte + i;
+
+		BUG_ON(!pmd_none(*pmd));
+		set_pmd(pmd, __pmd(((unsigned long)cur_pte) & PAGE_MASK));
+		BUG_ON(cur_pte != pte_offset_kernel(pmd, 0));
+		pr_debug("%s: pmd: 0x%p, pte: 0x%p\n",
+			 __func__, pmd, cur_pte);
 	}
+	return pte;
 }
 
 static void __init fixedrange_init(void)
 {
-	BUILD_BUG_ON(FIXADDR_SIZE > PMD_SIZE);
-	init_pmd(__fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK);
+	init_pmd(__fix_to_virt(0), __end_of_fixed_addresses);
 }
 #endif
 
@@ -52,7 +58,7 @@ void __init paging_init(void)
 	memset(swapper_pg_dir, 0, PAGE_SIZE);
 #ifdef CONFIG_HIGHMEM
 	fixedrange_init();
-	pkmap_page_table = init_pmd(PKMAP_BASE);
+	pkmap_page_table = init_pmd(PKMAP_BASE, LAST_PKMAP);
 	kmap_init();
 #endif
 }
-- 
1.8.1.4

