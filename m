Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423049Ab3CVU1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:27:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422903Ab3CVUZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:25:17 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] soft-offline: use migrate_pages() instead of migrate_huge_page()
Date: Fri, 22 Mar 2013 16:23:48 -0400
Message-Id: <1363983835-20184-4-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
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
 mm/memory-failure.c | 15 ++++++++++++---
 mm/migrate.c        |  2 ++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git v3.9-rc3.orig/mm/memory-failure.c v3.9-rc3/mm/memory-failure.c
index df0694c..4e01082 100644
--- v3.9-rc3.orig/mm/memory-failure.c
+++ v3.9-rc3/mm/memory-failure.c
@@ -1467,6 +1467,7 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	int ret;
 	unsigned long pfn = page_to_pfn(page);
 	struct page *hpage = compound_head(page);
+	LIST_HEAD(pagelist);
 
 	/*
 	 * This double-check of PageHWPoison is to avoid the race with
@@ -1482,12 +1483,20 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	unlock_page(hpage);
 
 	/* Keep page count to indicate a given hugepage is isolated. */
-	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL,
-				MIGRATE_SYNC);
-	put_page(hpage);
+	list_move(&hpage->lru, &pagelist);
+	ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
+				MIGRATE_SYNC, MR_MEMORY_FAILURE);
 	if (ret) {
 		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 			pfn, ret, page->flags);
+		/*
+		 * We know that soft_offline_huge_page() tries to migrate
+		 * only one hugepage pointed to by hpage, so we need not
+		 * run through the pagelist here.
+		 */
+		putback_active_hugepage(hpage);
+		if (ret > 0)
+			ret = -EIO;
 	} else {
 		set_page_hwpoison_huge_page(hpage);
 		dequeue_hwpoisoned_huge_page(hpage);
diff --git v3.9-rc3.orig/mm/migrate.c v3.9-rc3/mm/migrate.c
index f69f354..66030b6 100644
--- v3.9-rc3.orig/mm/migrate.c
+++ v3.9-rc3/mm/migrate.c
@@ -981,6 +981,8 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 
 	unlock_page(hpage);
 out:
+	if (rc != -EAGAIN)
+		putback_active_hugepage(hpage);
 	put_page(new_hpage);
 	if (result) {
 		if (rc)
-- 
1.7.11.7

