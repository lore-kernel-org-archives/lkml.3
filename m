Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab3LFIkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:40:10 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54407 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3LFIjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:39:14 -0500
X-AuditID: 9c930179-b7ce4ae000000e86-45-52a18d2fbff7
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/4] mm/migrate: remove putback_lru_pages, fix comment on putback_movable_pages
Date: Fri,  6 Dec 2013 17:41:49 +0900
Message-Id: <1386319310-28016-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some part of putback_lru_pages() and putback_movable_pages() is
duplicated, so it could confuse us what we should use.
We can remove putback_lru_pages() since it is not really needed now.
This makes us undestand and maintain the code more easily.

And comment on putback_movable_pages() is stale now, so fix it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index f5096b5..7782b74 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -35,7 +35,6 @@ enum migrate_reason {
 
 #ifdef CONFIG_MIGRATION
 
-extern void putback_lru_pages(struct list_head *l);
 extern void putback_movable_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *, enum migrate_mode);
@@ -59,7 +58,6 @@ extern int migrate_page_move_mapping(struct address_space *mapping,
 #else
 
 static inline void putback_lru_pages(struct list_head *l) {}
-static inline void putback_movable_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, enum migrate_mode mode, int reason)
 	{ return -ENOSYS; }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b7c1716..1debdea 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1569,7 +1569,13 @@ static int __soft_offline_page(struct page *page, int flags)
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
 		if (ret) {
-			putback_lru_pages(&pagelist);
+			if (!list_empty(&pagelist)) {
+				list_del(&page->lru);
+				dec_zone_page_state(page, NR_ISOLATED_ANON +
+						page_is_file_cache(page));
+				putback_lru_page(page);
+			}
+
 			pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 				pfn, ret, page->flags);
 			if (ret > 0)
diff --git a/mm/migrate.c b/mm/migrate.c
index 1f59ccc..8392de4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -71,28 +71,12 @@ int migrate_prep_local(void)
 }
 
 /*
- * Add isolated pages on the list back to the LRU under page lock
- * to avoid leaking evictable pages back onto unevictable list.
- */
-void putback_lru_pages(struct list_head *l)
-{
-	struct page *page;
-	struct page *page2;
-
-	list_for_each_entry_safe(page, page2, l, lru) {
-		list_del(&page->lru);
-		dec_zone_page_state(page, NR_ISOLATED_ANON +
-				page_is_file_cache(page));
-			putback_lru_page(page);
-	}
-}
-
-/*
  * Put previously isolated pages back onto the appropriate lists
  * from where they were once taken off for compaction/migration.
  *
- * This function shall be used instead of putback_lru_pages(),
- * whenever the isolated pageset has been built by isolate_migratepages_range()
+ * This function shall be used whenever the isolated pageset has been
+ * built from lru, balloon, hugetlbfs page. See isolate_migratepages_range()
+ * and isolate_huge_page().
  */
 void putback_movable_pages(struct list_head *l)
 {
@@ -1697,6 +1681,12 @@ int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_page,
 				     node, MIGRATE_ASYNC, MR_NUMA_MISPLACED);
 	if (nr_remaining) {
+		if (!list_empty(&migratepages)) {
+			list_del(&page->lru);
+			dec_zone_page_state(page, NR_ISOLATED_ANON +
+					page_is_file_cache(page));
+			putback_lru_page(page);
+		}
 		putback_lru_pages(&migratepages);
 		isolated = 0;
 	} else
-- 
1.7.9.5

