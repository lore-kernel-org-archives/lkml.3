Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaFBVhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:37:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:22482 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaFBVg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:36:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,959,1392192000"; 
   d="scan'208";a="550474709"
Subject: [PATCH 10/10] mm: pagewalk: use locked walker for /proc/pid/numa_maps
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 02 Jun 2014 14:36:57 -0700
References: <20140602213644.925A26D0@viggo.jf.intel.com>
In-Reply-To: <20140602213644.925A26D0@viggo.jf.intel.com>
Message-Id: <20140602213657.A393F169@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Same deal as the last one.  Lots of code savings using the new
walker function.


Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/fs/proc/task_mmu.c |   39 ++++++++-------------------------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-pagewalk-use-locked-walker-numa_maps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-pagewalk-use-locked-walker-numa_maps	2014-06-02 14:20:21.518907178 -0700
+++ b/fs/proc/task_mmu.c	2014-06-02 14:20:21.522907359 -0700
@@ -1280,41 +1280,18 @@ static struct page *can_gather_numa_stat
 	return page;
 }
 
-static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
-		unsigned long end, struct mm_walk *walk)
+static int gather_stats_locked(pte_t *pte, unsigned long addr,
+		unsigned long size, struct mm_walk *walk)
 {
-	struct numa_maps *md;
-	spinlock_t *ptl;
-	pte_t *orig_pte;
-	pte_t *pte;
-
-	md = walk->private;
+	struct numa_maps *md = walk->private;
+	struct page *page = can_gather_numa_stats(*pte, walk->vma, addr);
 
-	if (pmd_trans_huge_lock(pmd, walk->vma, &ptl) == 1) {
-		pte_t huge_pte = *(pte_t *)pmd;
-		struct page *page;
-
-		page = can_gather_numa_stats(huge_pte, walk->vma, addr);
-		if (page)
-			gather_stats(page, md, pte_dirty(huge_pte),
-				     HPAGE_PMD_SIZE/PAGE_SIZE);
-		spin_unlock(ptl);
-		return 0;
-	}
+	if (page)
+		gather_stats(page, md, pte_dirty(*pte), size/PAGE_SIZE);
 
-	if (pmd_trans_unstable(pmd))
-		return 0;
-	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	do {
-		struct page *page = can_gather_numa_stats(*pte, walk->vma, addr);
-		if (!page)
-			continue;
-		gather_stats(page, md, pte_dirty(*pte), 1);
-
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	pte_unmap_unlock(orig_pte, ptl);
 	return 0;
 }
+
 #ifdef CONFIG_HUGETLB_PAGE
 static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
@@ -1366,7 +1343,7 @@ static int show_numa_map(struct seq_file
 	memset(md, 0, sizeof(*md));
 
 	walk.hugetlb_entry = gather_hugetbl_stats;
-	walk.pmd_entry = gather_pte_stats;
+	walk.locked_single_entry = gather_stats_locked;
 	walk.private = md;
 	walk.mm = mm;
 
_
