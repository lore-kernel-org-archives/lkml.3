Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3EHXj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:39:59 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61069 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3EHXjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:39:15 -0400
X-AuditID: 9c930179-b7bb6ae000001131-d3-518ae218f3b6
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>
Subject: [PATCH v4 3/6] mm: Remove shrink_page
Date: Thu,  9 May 2013 08:38:59 +0900
Message-Id: <1368056342-30836-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368056342-30836-1-git-send-email-minchan@kernel.org>
References: <1368056342-30836-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By previous patch, shrink_page_list can handle pages from
multiple zone so let's remove shrink_page.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c | 47 ++++++++++++++---------------------------------
 1 file changed, 14 insertions(+), 33 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a1fb526..0d4df03 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -924,6 +924,13 @@ free_it:
 		 * appear not as the counts should be low
 		 */
 		list_add(&page->lru, &free_pages);
+		/*
+		 * If pagelist are from multiple zones, we should decrease
+		 * NR_ISOLATED_ANON + x on freed pages in here.
+		 */
+		if (!zone)
+			dec_zone_page_state(page, NR_ISOLATED_ANON +
+					page_is_file_cache(page));
 		continue;
 
 cull_mlocked:
@@ -994,28 +1001,6 @@ unsigned long reclaim_clean_pages_from_list(struct zone *zone,
 }
 
 #ifdef CONFIG_PROCESS_RECLAIM
-static unsigned long shrink_page(struct page *page,
-					struct zone *zone,
-					struct scan_control *sc,
-					enum ttu_flags ttu_flags,
-					unsigned long *ret_nr_dirty,
-					unsigned long *ret_nr_writeback,
-					bool force_reclaim,
-					struct list_head *ret_pages)
-{
-	int reclaimed;
-	LIST_HEAD(page_list);
-	list_add(&page->lru, &page_list);
-
-	reclaimed = shrink_page_list(&page_list, zone, sc, ttu_flags,
-				ret_nr_dirty, ret_nr_writeback,
-				force_reclaim);
-	if (!reclaimed)
-		list_splice(&page_list, ret_pages);
-
-	return reclaimed;
-}
-
 unsigned long reclaim_pages_from_list(struct list_head *page_list)
 {
 	struct scan_control sc = {
@@ -1025,23 +1010,19 @@ unsigned long reclaim_pages_from_list(struct list_head *page_list)
 		.may_swap = 1,
 	};
 
-	LIST_HEAD(ret_pages);
+	unsigned long nr_reclaimed;
 	struct page *page;
 	unsigned long dummy1, dummy2;
-	unsigned long nr_reclaimed = 0;
-
-	while (!list_empty(page_list)) {
-		page = lru_to_page(page_list);
-		list_del(&page->lru);
 
+	list_for_each_entry(page, page_list, lru)
 		ClearPageActive(page);
-		nr_reclaimed += shrink_page(page, page_zone(page), &sc,
+
+	nr_reclaimed = shrink_page_list(page_list, NULL, &sc,
 				TTU_UNMAP|TTU_IGNORE_ACCESS,
-				&dummy1, &dummy2, true, &ret_pages);
-	}
+				&dummy1, &dummy2, true);
 
-	while (!list_empty(&ret_pages)) {
-		page = lru_to_page(&ret_pages);
+	while (!list_empty(page_list)) {
+		page = lru_to_page(page_list);
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
-- 
1.8.2.1

