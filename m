Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaFBVlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:41:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:47039 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbaFBVgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:36:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,959,1392192000"; 
   d="scan'208";a="521668160"
Subject: [PATCH 04/10] mm: pagewalk: add page walker for mincore()
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 02 Jun 2014 14:36:50 -0700
References: <20140602213644.925A26D0@viggo.jf.intel.com>
In-Reply-To: <20140602213644.925A26D0@viggo.jf.intel.com>
Message-Id: <20140602213650.417E9C67@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This converts the sys_mincore() code over to use the
walk_page_range() infrastructure.  This provides some pretty
nice code savings.

Note that the (now removed) comment:

       /*
	* Huge pages are always in RAM for now, but
	* theoretically it needs to be checked.
	*/

is bogus and has been for years.  We started demand-faulting them
long ago.  Thank goodness theory matters!

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/mm/mincore.c |  123 +++++++++++++++++----------------------------------------
 1 file changed, 37 insertions(+), 86 deletions(-)

diff -puN mm/mincore.c~mincore-page-walker-0 mm/mincore.c
--- a/mm/mincore.c~mincore-page-walker-0	2014-06-02 14:20:19.879833634 -0700
+++ b/mm/mincore.c	2014-06-02 14:20:19.883833814 -0700
@@ -19,38 +19,29 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
-static void mincore_hugetlb_page_range(struct vm_area_struct *vma,
-				unsigned long addr, unsigned long end,
-				unsigned char *vec)
+static int mincore_hugetlb_page_range(pte_t *ptep, unsigned long hmask,
+					unsigned long addr, unsigned long end,
+					struct mm_walk *walk)
 {
 #ifdef CONFIG_HUGETLB_PAGE
-	struct hstate *h;
-
-	h = hstate_vma(vma);
+	unsigned char *vec = walk->private;
 	while (1) {
-		unsigned char present;
-		pte_t *ptep;
-		/*
-		 * Huge pages are always in RAM for now, but
-		 * theoretically it needs to be checked.
-		 */
-		ptep = huge_pte_offset(current->mm,
-				       addr & huge_page_mask(h));
-		present = ptep && !huge_pte_none(huge_ptep_get(ptep));
+		int present = !huge_pte_none(huge_ptep_get(ptep));
 		while (1) {
 			*vec = present;
 			vec++;
 			addr += PAGE_SIZE;
 			if (addr == end)
-				return;
+				return 0;
 			/* check hugepage border */
-			if (!(addr & ~huge_page_mask(h)))
+			if (!(addr & hmask))
 				break;
 		}
 	}
 #else
 	BUG();
 #endif
+	return 0;
 }
 
 /*
@@ -94,10 +85,11 @@ static unsigned char mincore_page(struct
 	return present;
 }
 
-static void mincore_unmapped_range(struct vm_area_struct *vma,
-				unsigned long addr, unsigned long end,
-				unsigned char *vec)
+static int mincore_unmapped_range(unsigned long addr, unsigned long end,
+				struct mm_walk *walk)
 {
+	struct vm_area_struct *vma = walk->vma;
+	unsigned char *vec = walk->private;
 	unsigned long nr = (end - addr) >> PAGE_SHIFT;
 	int i;
 
@@ -111,27 +103,35 @@ static void mincore_unmapped_range(struc
 		for (i = 0; i < nr; i++)
 			vec[i] = 0;
 	}
+	return 0;
 }
 
-static void mincore_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-			unsigned long addr, unsigned long end,
-			unsigned char *vec)
+static int mincore_pte_range(pmd_t *pmd,
+			     unsigned long addr, unsigned long end,
+			     struct mm_walk *walk)
 {
+	struct vm_area_struct *vma = walk->vma;
+	unsigned char *vec = walk->private;
 	unsigned long next;
 	spinlock_t *ptl;
 	pte_t *ptep;
 
+	if (pmd_trans_huge(*pmd)) {
+		int success = mincore_huge_pmd(vma, pmd, addr, end, vec);
+		if (success)
+			return 0;
+		/* the trans huge pmd just split, handle as small */
+	}
+
 	ptep = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	do {
 		pte_t pte = *ptep;
 		pgoff_t pgoff;
 
 		next = addr + PAGE_SIZE;
-		if (pte_none(pte))
-			mincore_unmapped_range(vma, addr, next, vec);
-		else if (pte_present(pte))
+		if (pte_present(pte)) {
 			*vec = 1;
-		else if (pte_file(pte)) {
+		} else if (pte_file(pte)) {
 			pgoff = pte_to_pgoff(pte);
 			*vec = mincore_page(vma->vm_file->f_mapping, pgoff);
 		} else { /* pte is a swap entry */
@@ -154,67 +154,21 @@ static void mincore_pte_range(struct vm_
 		vec++;
 	} while (ptep++, addr = next, addr != end);
 	pte_unmap_unlock(ptep - 1, ptl);
-}
-
-static void mincore_pmd_range(struct vm_area_struct *vma, pud_t *pud,
-			unsigned long addr, unsigned long end,
-			unsigned char *vec)
-{
-	unsigned long next;
-	pmd_t *pmd;
-
-	pmd = pmd_offset(pud, addr);
-	do {
-		next = pmd_addr_end(addr, end);
-		if (pmd_trans_huge(*pmd)) {
-			if (mincore_huge_pmd(vma, pmd, addr, next, vec)) {
-				vec += (next - addr) >> PAGE_SHIFT;
-				continue;
-			}
-			/* fall through */
-		}
-		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
-			mincore_unmapped_range(vma, addr, next, vec);
-		else
-			mincore_pte_range(vma, pmd, addr, next, vec);
-		vec += (next - addr) >> PAGE_SHIFT;
-	} while (pmd++, addr = next, addr != end);
-}
-
-static void mincore_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
-			unsigned long addr, unsigned long end,
-			unsigned char *vec)
-{
-	unsigned long next;
-	pud_t *pud;
-
-	pud = pud_offset(pgd, addr);
-	do {
-		next = pud_addr_end(addr, end);
-		if (pud_none_or_clear_bad(pud))
-			mincore_unmapped_range(vma, addr, next, vec);
-		else
-			mincore_pmd_range(vma, pud, addr, next, vec);
-		vec += (next - addr) >> PAGE_SHIFT;
-	} while (pud++, addr = next, addr != end);
+	return 0;
 }
 
 static void mincore_page_range(struct vm_area_struct *vma,
 			unsigned long addr, unsigned long end,
 			unsigned char *vec)
 {
-	unsigned long next;
-	pgd_t *pgd;
-
-	pgd = pgd_offset(vma->vm_mm, addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		if (pgd_none_or_clear_bad(pgd))
-			mincore_unmapped_range(vma, addr, next, vec);
-		else
-			mincore_pud_range(vma, pgd, addr, next, vec);
-		vec += (next - addr) >> PAGE_SHIFT;
-	} while (pgd++, addr = next, addr != end);
+	struct mm_walk mincore_walk = {
+		.pte_hole      = mincore_unmapped_range,
+		.pmd_entry     = mincore_pte_range,
+		.hugetlb_entry = mincore_hugetlb_page_range,
+		.private = vec,
+		.mm = vma->vm_mm,
+	};
+	walk_page_range(vma->vm_start, vma->vm_end, &mincore_walk);
 }
 
 /*
@@ -233,10 +187,7 @@ static long do_mincore(unsigned long add
 
 	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 
-	if (is_vm_hugetlb_page(vma))
-		mincore_hugetlb_page_range(vma, addr, end, vec);
-	else
-		mincore_page_range(vma, addr, end, vec);
+	mincore_page_range(vma, addr, end, vec);
 
 	return (end - addr) >> PAGE_SHIFT;
 }
_
