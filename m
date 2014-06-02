Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaFBVhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:37:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:31941 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaFBVg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:36:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,959,1392192000"; 
   d="scan'208";a="541439359"
Subject: [PATCH 08/10] mm: pagewalk: add locked pte walker
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 02 Jun 2014 14:36:55 -0700
References: <20140602213644.925A26D0@viggo.jf.intel.com>
In-Reply-To: <20140602213644.925A26D0@viggo.jf.intel.com>
Message-Id: <20140602213655.B913463C@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Neither the locking nor the splitting logic needed for
transparent huge pages is trivial.  We end up having to teach
each of the page walkers about it individually, and have the same
pattern copied across several of them.

This patch introduces a new handler: ->locked_single_entry.  It
does two things: it handles the page table locking, including the
difference between pmds and ptes, and it lets you have a single
handler for large and small pages.

This greatly simplifies the handlers.  I only implemented this
for two of the walk_page_range() users for now.  I believe this
can at least be applied to a few more of them going forward.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/include/linux/mm.h |    7 +++++++
 b/mm/pagewalk.c      |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff -puN include/linux/mm.h~mm-pagewalk-add-locked-walker include/linux/mm.h
--- a/include/linux/mm.h~mm-pagewalk-add-locked-walker	2014-06-02 14:20:20.963882275 -0700
+++ b/include/linux/mm.h	2014-06-02 14:20:20.969882545 -0700
@@ -1096,6 +1096,11 @@ void unmap_vmas(struct mmu_gather *tlb,
  *	       pmd_trans_huge() pmds.  They may simply choose to
  *	       split_huge_page() instead of handling it explicitly.
  * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
+ * @locked_pte_entry: if set, called for each pmd or pte entry. The
+ * 		      page table lock for the entry is also acquired
+ * 		      such that the handler does not have to worry
+ * 		      about the entry disappearing (or being split in
+ * 		      the case of a pmd_trans_huge).
  * @pte_hole: if set, called for each hole at all levels
  * @hugetlb_entry: if set, called for each hugetlb entry
  *		   *Caution*: The caller must hold mmap_sem() if @hugetlb_entry
@@ -1112,6 +1117,8 @@ struct mm_walk {
 			 unsigned long next, struct mm_walk *walk);
 	int (*pte_entry)(pte_t *pte, unsigned long addr,
 			 unsigned long next, struct mm_walk *walk);
+	int (*locked_single_entry)(pte_t *pte, unsigned long addr,
+			 unsigned long pte_size, struct mm_walk *walk);
 	int (*pte_hole)(unsigned long addr, unsigned long next,
 			struct mm_walk *walk);
 	int (*hugetlb_entry)(pte_t *pte, unsigned long hmask,
diff -puN mm/pagewalk.c~mm-pagewalk-add-locked-walker mm/pagewalk.c
--- a/mm/pagewalk.c~mm-pagewalk-add-locked-walker	2014-06-02 14:20:20.965882364 -0700
+++ b/mm/pagewalk.c	2014-06-02 14:20:20.969882545 -0700
@@ -57,6 +57,40 @@ static int walk_pte_range(pmd_t *pmd, un
 	return err;
 }
 
+static int walk_single_entry_locked(pmd_t *pmd, unsigned long addr,
+				    unsigned long end, struct mm_walk *walk)
+{
+	int ret = 0;
+        struct vm_area_struct *vma = walk->vma;
+	pte_t *pte;
+	spinlock_t *ptl;
+
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+		ret = walk->locked_single_entry((pte_t *)pmd, addr,
+						HPAGE_PMD_SIZE, walk);
+		spin_unlock(ptl);
+		return ret;
+	}
+
+	/*
+	 * See pmd_none_or_trans_huge_or_clear_bad() for a
+	 * description of the races we are avoiding with this.
+	 * Note that this essentially acts as if the pmd were
+	 * NULL (empty).
+	 */
+	if (pmd_trans_unstable(pmd))
+		return 0;
+
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
+		ret = walk->locked_single_entry(pte, addr, PAGE_SIZE, walk);
+		if (ret)
+			break;
+	}
+	pte_unmap_unlock(pte - 1, ptl);
+	return ret;
+}
+
 static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 			  struct mm_walk *walk)
 {
@@ -77,6 +111,15 @@ again:
 			continue;
 		}
 		/*
+		 * A ->locked_single_entry must be able to handle
+		 * arbitrary (well, pmd or pte-sized) sizes
+		 */
+		if (walk->locked_single_entry)
+			err = walk_single_entry_locked(pmd, addr, next, walk);
+		if (err)
+			break;
+
+		/*
 		 * This implies that each ->pmd_entry() handler
 		 * needs to know about pmd_trans_huge() pmds
 		 */
_
