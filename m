Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab3LKWLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:11:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab3LKWKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:10:32 -0500
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
Date: Wed, 11 Dec 2013 17:09:06 -0500
Message-Id: <1386799747-31069-11-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386799747-31069-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1386799747-31069-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hugetlb_entry() doesn't use the argument hmask any more,
so let's remove it now.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 fs/proc/task_mmu.c | 12 ++++++------
 include/linux/mm.h |  5 ++---
 mm/pagewalk.c      |  2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git v3.13-rc3-mmots-2013-12-10-16-38.orig/fs/proc/task_mmu.c v3.13-rc3-mmots-2013-12-10-16-38/fs/proc/task_mmu.c
index 8b23bbcc5e04..f819d0d4a0e8 100644
--- v3.13-rc3-mmots-2013-12-10-16-38.orig/fs/proc/task_mmu.c
+++ v3.13-rc3-mmots-2013-12-10-16-38/fs/proc/task_mmu.c
@@ -1022,8 +1022,7 @@ static void huge_pte_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *
 }
 
 /* This function walks within one hugetlb entry in the single call */
-static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
-				 unsigned long addr, unsigned long end,
+static int pagemap_hugetlb(pte_t *pte, unsigned long addr, unsigned long end,
 				 struct mm_walk *walk)
 {
 	struct pagemapread *pm = walk->private;
@@ -1031,6 +1030,7 @@ static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
 	int err = 0;
 	int flags2;
 	pagemap_entry_t pme;
+	unsigned long hmask;
 
 	WARN_ON_ONCE(!vma);
 
@@ -1292,8 +1292,8 @@ static int gather_pmd_stats(pmd_t *pmd, unsigned long addr,
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
@@ -1311,8 +1311,8 @@ static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
 }
 
 #else
-static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
-		unsigned long addr, unsigned long end, struct mm_walk *walk)
+static int gather_hugetlb_stats(pte_t *pte, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
 {
 	return 0;
 }
diff --git v3.13-rc3-mmots-2013-12-10-16-38.orig/include/linux/mm.h v3.13-rc3-mmots-2013-12-10-16-38/include/linux/mm.h
index 8d1a3659419d..8008afa6dd64 100644
--- v3.13-rc3-mmots-2013-12-10-16-38.orig/include/linux/mm.h
+++ v3.13-rc3-mmots-2013-12-10-16-38/include/linux/mm.h
@@ -1088,9 +1088,8 @@ struct mm_walk {
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
diff --git v3.13-rc3-mmots-2013-12-10-16-38.orig/mm/pagewalk.c v3.13-rc3-mmots-2013-12-10-16-38/mm/pagewalk.c
index f4ba2c212330..31333473c725 100644
--- v3.13-rc3-mmots-2013-12-10-16-38.orig/mm/pagewalk.c
+++ v3.13-rc3-mmots-2013-12-10-16-38/mm/pagewalk.c
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

