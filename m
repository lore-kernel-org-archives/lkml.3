Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaFLVss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbaFLVsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:48:45 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm v2 10/11] fs/proc/task_mmu.c: clean up gather_*_stats()
Date: Thu, 12 Jun 2014 17:48:10 -0400
Message-Id: <1402609691-13950-11-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1402609691-13950-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1402609691-13950-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most code of gather_(pte|pmd|hugetlb)_stats() are duplicate, so let's clean
them up with a single function.

vm_normal_page() doesn't calculate pgoff correctly for hugetlbfs, so this
patch also fixes it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 fs/proc/task_mmu.c | 58 ++++++------------------------------------------------
 mm/memory.c        |  5 ++---
 2 files changed, 8 insertions(+), 55 deletions(-)

diff --git mmotm-2014-05-21-16-57.orig/fs/proc/task_mmu.c mmotm-2014-05-21-16-57/fs/proc/task_mmu.c
index 1f2eab58ae14..27ad736c6b30 100644
--- mmotm-2014-05-21-16-57.orig/fs/proc/task_mmu.c
+++ mmotm-2014-05-21-16-57/fs/proc/task_mmu.c
@@ -1243,63 +1243,17 @@ static struct page *can_gather_numa_stats(pte_t pte, struct vm_area_struct *vma,
 	return page;
 }
 
-static int gather_pte_stats(void *entry, unsigned long addr,
+static int gather_stats_entry(void *entry, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
 	pte_t *pte = entry;
 	struct numa_maps *md = walk->private;
-
 	struct page *page = can_gather_numa_stats(*pte, walk->vma, addr);
-	if (!page)
-		return 0;
-	gather_stats(page, md, pte_dirty(*pte), 1);
-	return 0;
-}
-
-static int gather_pmd_stats(void *entry, unsigned long addr,
-		unsigned long end, struct mm_walk *walk)
-{
-	struct numa_maps *md = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	pte_t huge_pte = *(pte_t *)entry;
-	struct page *page;
-
-	page = can_gather_numa_stats(huge_pte, vma, addr);
 	if (page)
-		gather_stats(page, md, pte_dirty(huge_pte),
-			     HPAGE_PMD_SIZE/PAGE_SIZE);
+		gather_stats(page, md, pte_dirty(*pte),
+			     walk->size >> PAGE_SHIFT);
 	return 0;
 }
-#ifdef CONFIG_HUGETLB_PAGE
-static int gather_hugetlb_stats(void *entry, unsigned long addr,
-				unsigned long end, struct mm_walk *walk)
-{
-	pte_t *pte = entry;
-	struct numa_maps *md;
-	struct page *page;
-
-	if (pte_none(*pte))
-		return 0;
-
-	if (!pte_present(*pte))
-		return 0;
-
-	page = pte_page(*pte);
-	if (!page)
-		return 0;
-
-	md = walk->private;
-	gather_stats(page, md, pte_dirty(*pte), 1);
-	return 0;
-}
-
-#else
-static int gather_hugetlb_stats(void *entry, unsigned long addr,
-				unsigned long end, struct mm_walk *walk)
-{
-	return 0;
-}
-#endif
 
 /*
  * Display pages allocated per node and memory policy via /proc.
@@ -1324,9 +1278,9 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	/* Ensure we start with an empty set of numa_maps statistics. */
 	memset(md, 0, sizeof(*md));
 
-	walk.hugetlb_entry = gather_hugetlb_stats;
-	walk.pmd_entry = gather_pmd_stats;
-	walk.pte_entry = gather_pte_stats;
+	walk.hugetlb_entry = gather_stats_entry;
+	walk.pmd_entry = gather_stats_entry;
+	walk.pte_entry = gather_stats_entry;
 	walk.private = md;
 	walk.mm = mm;
 	walk.vma = vma;
diff --git mmotm-2014-05-21-16-57.orig/mm/memory.c mmotm-2014-05-21-16-57/mm/memory.c
index fd16b767dd68..7389dd04370f 100644
--- mmotm-2014-05-21-16-57.orig/mm/memory.c
+++ mmotm-2014-05-21-16-57/mm/memory.c
@@ -768,9 +768,8 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 				return NULL;
 			goto out;
 		} else {
-			unsigned long off;
-			off = (addr - vma->vm_start) >> PAGE_SHIFT;
-			if (pfn == vma->vm_pgoff + off)
+			unsigned long off = linear_page_index(vma, addr);
+			if (pfn == off)
 				return NULL;
 			if (!is_cow_mapping(vma->vm_flags))
 				return NULL;
-- 
1.9.3

