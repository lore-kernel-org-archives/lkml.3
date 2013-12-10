Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3LJI5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:57:24 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51389 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3LJI5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:57:20 -0500
X-AuditID: 9c930197-b7bdbae000000e78-d4-52a6d76efaa1
Date: Tue, 10 Dec 2013 18:00:13 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 4/7] mm/migrate: remove putback_lru_pages, fix comment
 on putback_movable_pages
Message-ID: <20131210090012.GE24992@lge.com>
References: <1386580248-22431-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1386580248-22431-5-git-send-email-iamjoonsoo.kim@lge.com>
 <52a67d8c.6966420a.7a42.555fSMTPIN_ADDED_BROKEN@mx.google.com>
 <20131210085147.GD24992@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210085147.GD24992@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 05:51:47PM +0900, Joonsoo Kim wrote:
> > >@@ -1704,6 +1688,12 @@ int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
> > > 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_page,
> > > 				     node, MIGRATE_ASYNC, MR_NUMA_MISPLACED);
> > > 	if (nr_remaining) {
> > >+		if (!list_empty(&migratepages)) {
> > >+			list_del(&page->lru);
> > >+			dec_zone_page_state(page, NR_ISOLATED_ANON +
> > >+					page_is_file_cache(page));
> > >+			putback_lru_page(page);
> > >+		}
> > > 		putback_lru_pages(&migratepages);
> > 
> > You should remove this line. Otherwise,
> 
> Yes, you are right. I will send next version. T_T

Here is the next version.
Thanks.

-----------8<------------------------
>From 5495abbe8ed8a39712d733b08110dcf97e0b53f5 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Fri, 6 Dec 2013 16:58:18 +0900
Subject: [PATCH v2-fix 4/7] mm/migrate: remove putback_lru_pages, fix comment
 on putback_movable_pages

Some part of putback_lru_pages() and putback_movable_pages() is
duplicated, so it could confuse us what we should use.
We can remove putback_lru_pages() since it is not really needed now.
This makes us undestand and maintain the code more easily.

And comment on putback_movable_pages() is stale now, so fix it.

Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index f5096b5..e4671f9 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -35,7 +35,6 @@ enum migrate_reason {
 
 #ifdef CONFIG_MIGRATION
 
-extern void putback_lru_pages(struct list_head *l);
 extern void putback_movable_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *, enum migrate_mode);
@@ -58,7 +57,6 @@ extern int migrate_page_move_mapping(struct address_space *mapping,
 		struct buffer_head *head, enum migrate_mode mode);
 #else
 
-static inline void putback_lru_pages(struct list_head *l) {}
 static inline void putback_movable_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, enum migrate_mode mode, int reason)
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
index b1cfd01..fa73ee3 100644
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
@@ -1704,7 +1688,12 @@ int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_page,
 				     node, MIGRATE_ASYNC, MR_NUMA_MISPLACED);
 	if (nr_remaining) {
-		putback_lru_pages(&migratepages);
+		if (!list_empty(&migratepages)) {
+			list_del(&page->lru);
+			dec_zone_page_state(page, NR_ISOLATED_ANON +
+					page_is_file_cache(page));
+			putback_lru_page(page);
+		}
 		isolated = 0;
 	} else
 		count_vm_numa_event(NUMA_PAGE_MIGRATE);
-- 
1.7.9.5

