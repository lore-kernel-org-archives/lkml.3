Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3BUTnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:43:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab3BUTms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:42:48 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] mbind: enable mbind() to migrate hugepage
Date: Thu, 21 Feb 2013 14:41:46 -0500
Message-Id: <1361475708-25991-8-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables mbind(2) to migrate hugepages.
Page collecting function check_range() are already aware of hugepage
by the previous patch in this series.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 include/linux/hugetlb.h |  3 +++
 mm/hugetlb.c            |  2 +-
 mm/mempolicy.c          | 15 ++++++---------
 mm/migrate.c            |  7 ++++++-
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git v3.8.orig/include/linux/hugetlb.h v3.8/include/linux/hugetlb.h
index eb33df5..86a4d78 100644
--- v3.8.orig/include/linux/hugetlb.h
+++ v3.8/include/linux/hugetlb.h
@@ -263,6 +263,8 @@ struct huge_bootmem_page {
 #endif
 };
 
+struct page *alloc_huge_page(struct vm_area_struct *vma,
+				unsigned long addr, int avoid_reserve);
 struct page *alloc_huge_page_node(struct hstate *h, int nid);
 
 /* arch callback */
@@ -358,6 +360,7 @@ static inline int hstate_index(struct hstate *h)
 
 #else
 struct hstate {};
+#define alloc_huge_page(v, a, r) NULL
 #define alloc_huge_page_node(h, nid) NULL
 #define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
diff --git v3.8.orig/mm/hugetlb.c v3.8/mm/hugetlb.c
index 86ffcb7..ccf9995 100644
--- v3.8.orig/mm/hugetlb.c
+++ v3.8/mm/hugetlb.c
@@ -1116,7 +1116,7 @@ static void vma_commit_reservation(struct hstate *h,
 	}
 }
 
-static struct page *alloc_huge_page(struct vm_area_struct *vma,
+struct page *alloc_huge_page(struct vm_area_struct *vma,
 				    unsigned long addr, int avoid_reserve)
 {
 	struct hugepage_subpool *spool = subpool_vma(vma);
diff --git v3.8.orig/mm/mempolicy.c v3.8/mm/mempolicy.c
index 8627135..9f56c40 100644
--- v3.8.orig/mm/mempolicy.c
+++ v3.8/mm/mempolicy.c
@@ -1187,6 +1187,8 @@ static struct page *new_vma_page(struct page *page, unsigned long private, int *
 		vma = vma->vm_next;
 	}
 
+	if (PageHuge(page))
+		return alloc_huge_page(vma, address, 1);
 	/*
 	 * if !vma, alloc_page_vma() will use task or system default policy
 	 */
@@ -1291,15 +1293,10 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (!err) {
 		int nr_failed = 0;
 
-		if (!list_empty(&pagelist)) {
-			WARN_ON_ONCE(flags & MPOL_MF_LAZY);
-			nr_failed = migrate_pages(&pagelist, new_vma_page,
-						(unsigned long)vma,
-						false, MIGRATE_SYNC,
-						MR_MEMPOLICY_MBIND);
-			if (nr_failed)
-				putback_lru_pages(&pagelist);
-		}
+		WARN_ON_ONCE(flags & MPOL_MF_LAZY);
+		nr_failed = migrate_movable_pages(&pagelist, new_vma_page,
+					(unsigned long)vma, false,
+					MIGRATE_SYNC, MR_MEMPOLICY_MBIND);
 
 		if (nr_failed && (flags & MPOL_MF_STRICT))
 			err = -EIO;
diff --git v3.8.orig/mm/migrate.c v3.8/mm/migrate.c
index 36959d6..8c457e7 100644
--- v3.8.orig/mm/migrate.c
+++ v3.8/mm/migrate.c
@@ -974,7 +974,12 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 	struct page *new_hpage = get_new_page(hpage, private, &result);
 	struct anon_vma *anon_vma = NULL;
 
-	if (!new_hpage)
+	/*
+	 * Getting a new hugepage with alloc_huge_page() (which can happen
+	 * when migration is caused by mbind()) can return ERR_PTR value,
+	 * so we need take care of the case here.
+	 */
+	if (!new_hpage || IS_ERR_VALUE(new_hpage))
 		return -ENOMEM;
 
 	rc = -EAGAIN;
-- 
1.7.11.7

