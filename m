Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaHFHMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 03:12:33 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:36283 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbaHFHLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 03:11:19 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 7/8] mm/isolation: fix freepage counting bug on start/undo_isolat_page_range()
Date: Wed,  6 Aug 2014 16:18:36 +0900
Message-Id: <1407309517-3270-11-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407309517-3270-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1407309517-3270-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current isolation logic isolates each pageblock individually.
This causes freepage counting problem when page with pageblock order is
merged with other page on different buddy list. We can prevent it by
following solutions.

1. decrease MAX_ORDER to pageblock order
2. prevent merging buddy pages if they are on different buddy list

Solution 1. looks really easy, but, I'm not sure if there is a user
to allocate more than pageblock order.

Solution 2. seems not to get greeted, because it needs to inserts
hooks to the core part of allocator.

So, this is solution 3, that is, making start/undo_isolat_page_range()
bug free through handling whole range at one go. If given range is
aligned with MAX_ORDER properly, page isn't merged with other page on
different buddy list. So we can calm down freepage counting bug.
Unfortunately, this solution only works for MAX_ORDER aligned range
like as CMA and aligning range is caller's duty.

Although we can go with solution 1., this patch is still useful since
some synchronization call is reduced since we call them in batch.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/page_isolation.c |  105 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 84 insertions(+), 21 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index b91f9ec..063f1f9 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -222,30 +222,63 @@ int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 			     unsigned migratetype, bool skip_hwpoisoned_pages)
 {
 	unsigned long pfn;
-	unsigned long undo_pfn;
-	struct page *page;
+	unsigned long flags = 0, nr_pages;
+	struct page *page = NULL;
+	struct zone *zone = NULL;
 
 	BUG_ON((start_pfn) & (pageblock_nr_pages - 1));
 	BUG_ON((end_pfn) & (pageblock_nr_pages - 1));
 
-	for (pfn = start_pfn;
-	     pfn < end_pfn;
-	     pfn += pageblock_nr_pages) {
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
 		page = __first_valid_page(pfn, pageblock_nr_pages);
-		if (page &&
-		    set_migratetype_isolate(page, skip_hwpoisoned_pages)) {
-			undo_pfn = pfn;
-			goto undo;
+		if (!page)
+			continue;
+
+		if (!zone) {
+			zone = page_zone(page);
+			spin_lock_irqsave(&zone->lock, flags);
+		}
+
+		if (set_migratetype_isolate_pre(page, skip_hwpoisoned_pages)) {
+			spin_unlock_irqrestore(&zone->lock, flags);
+			return -EBUSY;
 		}
 	}
-	return 0;
-undo:
-	for (pfn = start_pfn;
-	     pfn < undo_pfn;
-	     pfn += pageblock_nr_pages)
-		unset_migratetype_isolate(pfn_to_page(pfn), migratetype);
 
-	return -EBUSY;
+	if (!zone)
+		return 0;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
+		page = __first_valid_page(pfn, pageblock_nr_pages);
+		if (!page)
+			continue;
+
+		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
+	}
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	zone_pcp_disable(zone);
+	/*
+	 * After this point, freed page will see MIGRATE_ISOLATE as
+	 * their pageblock migratetype on all cpus. And pcp list has
+	 * no free page.
+	 */
+	on_each_cpu(drain_local_pages, NULL, 1);
+
+	spin_lock_irqsave(&zone->lock, flags);
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
+		page = __first_valid_page(pfn, pageblock_nr_pages);
+		if (!page)
+			continue;
+
+		nr_pages = move_freepages_block(zone, page, MIGRATE_ISOLATE);
+		__mod_zone_freepage_state(zone, -nr_pages, migratetype);
+	}
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	zone_pcp_enable(zone);
+
+	return 0;
 }
 
 /*
@@ -256,18 +289,48 @@ int undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 {
 	unsigned long pfn;
 	struct page *page;
+	struct zone *zone = NULL;
+	unsigned long flags, nr_pages;
+
 	BUG_ON((start_pfn) & (pageblock_nr_pages - 1));
 	BUG_ON((end_pfn) & (pageblock_nr_pages - 1));
-	for (pfn = start_pfn;
-	     pfn < end_pfn;
-	     pfn += pageblock_nr_pages) {
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
+		page = __first_valid_page(pfn, pageblock_nr_pages);
+		if (!page)
+			continue;
+
+		if (!zone) {
+			zone = page_zone(page);
+			spin_lock_irqsave(&zone->lock, flags);
+		}
+
+		if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
+			continue;
+
+		nr_pages = move_freepages_block(zone, page, migratetype);
+		__mod_zone_freepage_state(zone, nr_pages, migratetype);
+		set_pageblock_migratetype(page, migratetype);
+	}
+
+	if (!zone)
+		return 0;
+
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	/* Freed pages will see original migratetype after this point */
+	kick_all_cpus_sync();
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
 		page = __first_valid_page(pfn, pageblock_nr_pages);
-		if (!page || get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
+		if (!page)
 			continue;
-		unset_migratetype_isolate(page, migratetype);
+
+		unset_migratetype_isolate_post(page, migratetype);
 	}
 	return 0;
 }
+
 /*
  * Test all pages in the range is free(means isolated) or not.
  * all pages in [start_pfn...end_pfn) must be in the same zone.
-- 
1.7.9.5

