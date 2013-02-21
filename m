Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab3BUTpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:45:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340Ab3BUTmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:42:45 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] soft-offline: use migrate_pages() instead of migrate_huge_page()
Date: Thu, 21 Feb 2013 14:41:42 -0500
Message-Id: <1361475708-25991-4-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently migrate_huge_page() takes a pointer to a hugepage to be
migrated as an argument, instead of taking a pointer to the list of
hugepages to be migrated. This behavior was introduced in commit
189ebff28 ("hugetlb: simplify migrate_huge_page()"), and was OK
because until now hugepage migration is enabled only for soft-offlining
which takes only one hugepage in a single call.

But the situation will change in the later patches in this series
which enable other users of page migration to support hugepage migration.
They can kick migration for both of normal pages and hugepages
in a single call, so we need to go back to original implementation
of using linked lists to collect the hugepages to be migrated.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/memory-failure.c | 20 ++++++++++++++++----
 mm/migrate.c        |  2 ++
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git v3.8.orig/mm/memory-failure.c v3.8/mm/memory-failure.c
index bc126f6..01e4676 100644
--- v3.8.orig/mm/memory-failure.c
+++ v3.8/mm/memory-failure.c
@@ -1467,6 +1467,7 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	int ret;
 	unsigned long pfn = page_to_pfn(page);
 	struct page *hpage = compound_head(page);
+	LIST_HEAD(pagelist);
 
 	/* Synchronized using the page lock with memory_failure() */
 	lock_page(hpage);
@@ -1479,13 +1480,24 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	unlock_page(hpage);
 
 	/* Keep page count to indicate a given hugepage is isolated. */
-	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL, false,
-				MIGRATE_SYNC);
-	put_page(hpage);
+	list_move(&hpage->lru, &pagelist);
+	ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, false,
+				MIGRATE_SYNC, MR_MEMORY_FAILURE);
 	if (ret) {
 		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 			pfn, ret, page->flags);
-		return ret;
+		/*
+		 * We know that soft_offline_huge_page() tries to migrate
+		 * only one hugepage pointed to by hpage, so we need not
+		 * run through the pagelist here.
+		 */
+		putback_active_hugepage(hpage);
+		if (ret > 0)
+			ret = -EIO;
+	} else {
+		set_page_hwpoison_huge_page(hpage);
+		dequeue_hwpoisoned_huge_page(hpage);
+		atomic_long_add(1<<compound_trans_order(hpage), &mce_bad_pages);
 	}
 	/* keep elevated page count for bad page */
 	return ret;
diff --git v3.8.orig/mm/migrate.c v3.8/mm/migrate.c
index e305dc0..8c13cc5 100644
--- v3.8.orig/mm/migrate.c
+++ v3.8/mm/migrate.c
@@ -1004,6 +1004,8 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 
 	unlock_page(hpage);
 out:
+	if (rc != -EAGAIN)
+		putback_active_hugepage(hpage);
 	put_page(new_hpage);
 	if (result) {
 		if (rc)
-- 
1.7.11.7

