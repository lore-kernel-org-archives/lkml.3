Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3J3Vq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:46:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab3J3Vqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:46:52 -0400
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
Subject: [PATCH 10/11] pagewalk: remove argument hmask from hugetlb_entry()
Date: Wed, 30 Oct 2013 17:44:58 -0400
Message-Id: <1383169499-25144-11-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1383169499-25144-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1383169499-25144-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of callbacks connected to hugetlb_entry() are changed not to
use the argument hmask. So we can remove it now.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 fs/proc/task_mmu.c | 12 ++++++------
 include/linux/mm.h |  5 ++---
 mm/pagewalk.c      |  2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git v3.12-rc7-mmots-2013-10-29-16-24.orig/fs/proc/task_mmu.c v3.12-rc7-mmots-2013-10-29-16-24/fs/proc/task_mmu.c
index 486737a..7c7f82b 100644
--- v3.12-rc7-mmots-2013-10-29-16-24.orig/fs/proc/task_mmu.c
+++ v3.12-rc7-mmots-2013-10-29-16-24/fs/proc/task_mmu.c
@@ -1043,8 +1043,7 @@ static void huge_pte_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *
 }
 
 /* This function walks within one hugetlb entry in the single call */
-static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
-				 unsigned long addr, unsigned long end,
+static int pagemap_hugetlb(pte_t *pte, unsigned long addr, unsigned long end,
 				 struct mm_walk *walk)
 {
 	struct pagemapread *pm = walk->private;
@@ -1052,6 +1051,7 @@ static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
 	int err = 0;
 	int flags2;
 	pagemap_entry_t pme;
+	unsigned long hmask;
 
 	WARN_ON_ONCE(!vma);
 
@@ -1313,8 +1313,8 @@ static int gather_pmd_stats(pmd_t *pmd, unsigned long addr,
 	return 0;
 }
 #ifdef CONFIG_HUGETLB_PAGE
-static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
-		unsigned long addr, unsigned long end, struct mm_walk *walk)
+static int gather_hugetlb_stats(pte_t *pte, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
 {
 	struct numa_maps *md;
 	struct page *page;
@@ -1332,8 +1332,8 @@ static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
 }
 
 #else
-static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
-		unsigned long addr, unsigned long end, struct mm_walk *walk)
+static int gather_hugetlb_stats(pte_t *pte, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
 {
 	return 0;
 }
diff --git v3.12-rc7-mmots-2013-10-29-16-24.orig/include/linux/mm.h v3.12-rc7-mmots-2013-10-29-16-24/include/linux/mm.h
index f31f22f..35334e7 100644
--- v3.12-rc7-mmots-2013-10-29-16-24.orig/include/linux/mm.h
+++ v3.12-rc7-mmots-2013-10-29-16-24/include/linux/mm.h
@@ -1050,9 +1050,8 @@ struct mm_walk {
 			 unsigned long next, struct mm_walk *walk);
 	int (*pte_hole)(unsigned long addr, unsigned long next,
 			struct mm_walk *walk);
-	int (*hugetlb_entry)(pte_t *pte, unsigned long hmask,
-			     unsigned long addr, unsigned long next,
-			     struct mm_walk *walk);
+	int (*hugetlb_entry)(pte_t *pte, unsigned long addr,
+			unsigned long next, struct mm_walk *walk);
 	int (*test_walk)(unsigned long addr, unsigned long next,
 			struct mm_walk *walk);
 	struct mm_struct *mm;
diff --git v3.12-rc7-mmots-2013-10-29-16-24.orig/mm/pagewalk.c v3.12-rc7-mmots-2013-10-29-16-24/mm/pagewalk.c
index e837502..60bc4cf 100644
--- v3.12-rc7-mmots-2013-10-29-16-24.orig/mm/pagewalk.c
+++ v3.12-rc7-mmots-2013-10-29-16-24/mm/pagewalk.c
@@ -189,7 +189,7 @@ static int walk_hugetlb_range(unsigned long addr, unsigned long end,
 		 * in walk->hugetlb_entry().
 		 */
 		if (pte && walk->hugetlb_entry)
-			err = walk->hugetlb_entry(pte, hmask, addr, next, walk);
+			err = walk->hugetlb_entry(pte, addr, next, walk);
 		spin_unlock(ptl);
 		if (err)
 			break;
-- 
1.8.3.1

