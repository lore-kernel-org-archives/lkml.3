Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaFBVg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:36:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:47039 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbaFBVg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:36:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,959,1392192000"; 
   d="scan'208";a="521668204"
Subject: [PATCH 09/10] mm: pagewalk: use new locked walker for /proc/pid/smaps
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 02 Jun 2014 14:36:56 -0700
References: <20140602213644.925A26D0@viggo.jf.intel.com>
In-Reply-To: <20140602213644.925A26D0@viggo.jf.intel.com>
Message-Id: <20140602213656.7AE8FDC7@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The diffstat tells the story here.  Using the new walker function
greatly simplifies the code.  One side-effect here is that we'll
call cond_resched() more often than we did before.  It used to be
called once per pte page, but now it's called on every pte.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/fs/proc/task_mmu.c |   27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-pagewalk-use-locked-walker-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-pagewalk-use-locked-walker-smaps	2014-06-02 14:20:21.247895019 -0700
+++ b/fs/proc/task_mmu.c	2014-06-02 14:20:21.251895198 -0700
@@ -490,32 +490,15 @@ static void smaps_pte_entry(pte_t ptent,
 	}
 }
 
-static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+static int smaps_single_locked(pte_t *pte, unsigned long addr, unsigned long size,
 			   struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	pte_t *pte;
-	spinlock_t *ptl;
-
-	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_PMD_SIZE, walk);
-		spin_unlock(ptl);
+
+	if (size == HPAGE_PMD_SIZE)
 		mss->anonymous_thp += HPAGE_PMD_SIZE;
-		return 0;
-	}
 
-	if (pmd_trans_unstable(pmd))
-		return 0;
-	/*
-	 * The mmap_sem held all the way back in m_start() is what
-	 * keeps khugepaged out of here and from collapsing things
-	 * in here.
-	 */
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; pte++, addr += PAGE_SIZE)
-		smaps_pte_entry(*pte, addr, PAGE_SIZE, walk);
-	pte_unmap_unlock(pte - 1, ptl);
+	smaps_pte_entry(*pte, addr, size, walk);
 	cond_resched();
 	return 0;
 }
@@ -581,7 +564,7 @@ static int show_smap(struct seq_file *m,
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
 	struct mm_walk smaps_walk = {
-		.pmd_entry = smaps_pte_range,
+		.locked_single_entry = smaps_single_locked,
 		.mm = vma->vm_mm,
 		.private = &mss,
 	};
_
