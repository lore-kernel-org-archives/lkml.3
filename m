Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaKGITy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 03:19:54 -0500
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:54736 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKGITs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 03:19:48 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Feiner <pfeiner@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH -mm v7 06/13] pagemap: use walk->vma instead of calling
 find_vma()
Thread-Topic: [PATCH -mm v7 06/13] pagemap: use walk->vma instead of calling
 find_vma()
Thread-Index: AQHP+li5Sj7VEY8NDEabj5YzdulzuA==
Date: Fri, 7 Nov 2014 07:01:58 +0000
Message-ID: <1415343692-6314-7-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1415343692-6314-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1415343692-6314-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.22]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page table walker has the information of the current vma in mm_walk,
so we don't have to call find_vma() in each pagemap_(pte|hugetlb)_range()
call any longer. Currently pagemap_pte_range() does vma loop itself, so
this patch reduces many lines of code.

NULL-vma check is omitted because we assume that we never run these
callbacks on any address outside vma. And even if it were broken, NULL
pointer dereference would be detected, so we can get enough information
for debugging.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
ChangeLog v7:
- remove while-loop in pagemap_pte_range() (thanks to Peter Feiner)
- remove Kirill's Ack because this patch has non-minor change since v6
---
 fs/proc/task_mmu.c | 68 +++++++++++++-----------------------------------------
 1 file changed, 16 insertions(+), 52 deletions(-)

diff --git mmotm-2014-11-05-16-01.orig/fs/proc/task_mmu.c mmotm-2014-11-05-16-01/fs/proc/task_mmu.c
index 9aaab24677ae..f997734d2b4b 100644
--- mmotm-2014-11-05-16-01.orig/fs/proc/task_mmu.c
+++ mmotm-2014-11-05-16-01/fs/proc/task_mmu.c
@@ -1054,15 +1054,13 @@ static inline void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme, struct pagemap
 static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			     struct mm_walk *walk)
 {
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = walk->vma;
 	struct pagemapread *pm = walk->private;
 	spinlock_t *ptl;
 	pte_t *pte;
 	int err = 0;
 
-	/* find the first VMA at or above 'addr' */
-	vma = find_vma(walk->mm, addr);
-	if (vma && pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		int pmd_flags2;
 
 		if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(*pmd))
@@ -1088,50 +1086,19 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
-	while (1) {
-		/* End of address space hole, which we mark as non-present. */
-		unsigned long hole_end;
-
-		if (vma)
-			hole_end = min(end, vma->vm_start);
-		else
-			hole_end = end;
-
-		for (; addr < hole_end; addr += PAGE_SIZE) {
-			pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
-
-			err = add_to_pagemap(addr, &pme, pm);
-			if (err)
-				return err;
-		}
-
-		if (!vma || vma->vm_start >= end)
-			break;
-		/*
-		 * We can't possibly be in a hugetlb VMA. In general,
-		 * for a mm_walk with a pmd_entry and a hugetlb_entry,
-		 * the pmd_entry can only be called on addresses in a
-		 * hugetlb if the walk starts in a non-hugetlb VMA and
-		 * spans a hugepage VMA. Since pagemap_read walks are
-		 * PMD-sized and PMD-aligned, this will never be true.
-		 */
-		BUG_ON(is_vm_hugetlb_page(vma));
-
-		/* Addresses in the VMA. */
-		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
-			pagemap_entry_t pme;
-			pte = pte_offset_map(pmd, addr);
-			pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
-			pte_unmap(pte);
-			err = add_to_pagemap(addr, &pme, pm);
-			if (err)
-				return err;
-		}
-
-		if (addr == end)
-			break;
+	/*
+	 * We can assume that @vma always points to a valid one and @end never
+	 * goes beyond vma->vm_end.
+	 */
+	for (; addr < end; addr += PAGE_SIZE) {
+		pagemap_entry_t pme;
 
-		vma = find_vma(walk->mm, addr);
+		pte = pte_offset_map(pmd, addr);
+		pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
+		pte_unmap(pte);
+		err = add_to_pagemap(addr, &pme, pm);
+		if (err)
+			return err;
 	}
 
 	cond_resched();
@@ -1158,15 +1125,12 @@ static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
 				 struct mm_walk *walk)
 {
 	struct pagemapread *pm = walk->private;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = walk->vma;
 	int err = 0;
 	int flags2;
 	pagemap_entry_t pme;
 
-	vma = find_vma(walk->mm, addr);
-	WARN_ON_ONCE(!vma);
-
-	if (vma && (vma->vm_flags & VM_SOFTDIRTY))
+	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags2 = __PM_SOFT_DIRTY;
 	else
 		flags2 = 0;
-- 
2.2.0.rc0.2.gf745acb
