Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaAMQyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:54:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaAMQyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:54:49 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
        Cliff Wickman <cpw@sgi.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Rik van Riel <riel@redhat.com>,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] madvise: redefine callback functions for page table walker
Date: Mon, 13 Jan 2014 11:54:08 -0500
Message-Id: <1389632051-25159-9-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1389632051-25159-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1389632051-25159-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swapin_walk_pmd_entry() is defined as pmd_entry(), but it has no code
about pmd handling (except pmd_none_or_trans_huge_or_clear_bad, but the
same check are now done in core page table walk code).
So let's move this function on pte_entry() as swapin_walk_pte_entry().

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/madvise.c | 43 +++++++++++++------------------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff --git mmotm-2014-01-09-16-23.orig/mm/madvise.c mmotm-2014-01-09-16-23/mm/madvise.c
index 539eeb96b323..5e957b984c14 100644
--- mmotm-2014-01-09-16-23.orig/mm/madvise.c
+++ mmotm-2014-01-09-16-23/mm/madvise.c
@@ -135,38 +135,22 @@ static long madvise_behavior(struct vm_area_struct *vma,
 }
 
 #ifdef CONFIG_SWAP
-static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
+static int swapin_walk_pte_entry(pte_t *pte, unsigned long start,
 	unsigned long end, struct mm_walk *walk)
 {
-	pte_t *orig_pte;
-	struct vm_area_struct *vma = walk->private;
-	unsigned long index;
+	swp_entry_t entry;
+	struct page *page;
+	struct vm_area_struct *vma = walk->vma;
 
-	if (pmd_none_or_trans_huge_or_clear_bad(pmd))
+	if (pte_present(*pte) || pte_none(*pte) || pte_file(*pte))
 		return 0;
-
-	for (index = start; index != end; index += PAGE_SIZE) {
-		pte_t pte;
-		swp_entry_t entry;
-		struct page *page;
-		spinlock_t *ptl;
-
-		orig_pte = pte_offset_map_lock(vma->vm_mm, pmd, start, &ptl);
-		pte = *(orig_pte + ((index - start) / PAGE_SIZE));
-		pte_unmap_unlock(orig_pte, ptl);
-
-		if (pte_present(pte) || pte_none(pte) || pte_file(pte))
-			continue;
-		entry = pte_to_swp_entry(pte);
-		if (unlikely(non_swap_entry(entry)))
-			continue;
-
-		page = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
-								vma, index);
-		if (page)
-			page_cache_release(page);
-	}
-
+	entry = pte_to_swp_entry(*pte);
+	if (unlikely(non_swap_entry(entry)))
+		return 0;
+	page = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
+				     vma, start);
+	if (page)
+		page_cache_release(page);
 	return 0;
 }
 
@@ -175,8 +159,7 @@ static void force_swapin_readahead(struct vm_area_struct *vma,
 {
 	struct mm_walk walk = {
 		.mm = vma->vm_mm,
-		.pmd_entry = swapin_walk_pmd_entry,
-		.private = vma,
+		.pte_entry = swapin_walk_pte_entry,
 	};
 
 	walk_page_range(start, end, &walk);
-- 
1.8.4.2

