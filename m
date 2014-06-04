Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaFDQNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:13:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbaFDQM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:12:29 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: [RFC PATCH 6/6] mm, compaction: don't migrate in blocks that cannot be fully compacted in async direct compaction
Date: Wed,  4 Jun 2014 18:11:50 +0200
Message-Id: <1401898310-14525-6-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1401898310-14525-1-git-send-email-vbabka@suse.cz>
References: <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com>
 <1401898310-14525-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In direct compaction, we want to allocate the high-order page as soon as
possible, so migrating from a block of pages that contains also unmigratable
pages just adds to allocation latency.

This patch therefore makes the migration scanner skip to the next cc->order
aligned block of pages as soon as it cannot isolate a non-free page. Everything
isolated up to that point is put back.

In this mode, the nr_isolated limit to COMPACT_CLUSTER_MAX is not observed,
allowing the scanner to scan the whole block at once, instead of migrating
COMPACT_CLUSTER_MAX pages and then finding an unmigratable page in the next
call. This might however have some implications on too_many_isolated.

Also in this RFC PATCH, the "skipping mode" is tied to async migration mode,
which is not optimal. What we most probably want is skipping in direct
compactions, but not from kswapd and hugepaged.

In very preliminary tests, this has reduced migrate_scanned, isolations and
migrations by about 10%, while the success rate of stress-highalloc mmtests
actually improved a bit.

Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
---
 mm/compaction.c | 48 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 5909a88..c648ade 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -626,7 +626,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		}
 
 		if (!pfn_valid_within(low_pfn))
-			continue;
+			goto isolation_failed;
 		nr_scanned++;
 
 		/*
@@ -637,7 +637,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		 */
 		page = pfn_to_page(low_pfn);
 		if (page_zone(page) != zone)
-			continue;
+			goto isolation_failed;
 
 		if (!valid_page)
 			valid_page = page;
@@ -673,8 +673,12 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		if (PageBuddy(page)) {
 			unsigned long freepage_order = page_order_unsafe(page);
 
-			if (freepage_order > 0 && freepage_order < MAX_ORDER)
-				low_pfn += (1UL << freepage_order) - 1;
+			if (freepage_order > 0 && freepage_order < MAX_ORDER) {
+                                low_pfn += (1UL << freepage_order) - 1;
+                                if (next_capture_pfn)
+                                        next_capture_pfn = ALIGN(low_pfn + 1,
+                                                        (1UL << cc->order));
+			}
 			continue;
 		}
 
@@ -690,7 +694,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 					goto isolate_success;
 				}
 			}
-			continue;
+			goto isolation_failed;
 		}
 
 		/*
@@ -710,7 +714,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			if (next_capture_pfn)
 				next_capture_pfn =
 					ALIGN(low_pfn + 1, (1UL << cc->order));
-			continue;
+			goto isolation_failed;
 		}
 
 		/*
@@ -720,7 +724,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		 */
 		if (!page_mapping(page) &&
 		    page_count(page) > page_mapcount(page))
-			continue;
+			goto isolation_failed;
 
 		/* If we already hold the lock, we can skip some rechecking */
 		if (locked)
@@ -732,11 +736,11 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 
 		/* Recheck PageLRU and PageTransHuge under lock */
 		if (!PageLRU(page))
-			continue;
+			goto isolation_failed;
 		if (PageTransHuge(page)) {
 			low_pfn += (1 << compound_order(page)) - 1;
 			next_capture_pfn = low_pfn + 1;
-			continue;
+			goto isolation_failed;
 		}
 
 skip_recheck:
@@ -744,7 +748,7 @@ skip_recheck:
 
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, mode) != 0)
-			continue;
+			goto isolation_failed;
 
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
 
@@ -754,11 +758,14 @@ skip_recheck:
 isolate_success:
 		cc->finished_update_migrate = true;
 		list_add(&page->lru, migratelist);
-		cc->nr_migratepages++;
 		nr_isolated++;
 
-		/* Avoid isolating too much */
-		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX) {
+		/*
+		 * Avoid isolating too much, except if we try to capture a
+		 * free page and want to find out at once if it can be done
+		 * or we should skip to the next block.
+		 */
+		if (!next_capture_pfn && nr_isolated == COMPACT_CLUSTER_MAX) {
 			++low_pfn;
 			break;
 		}
@@ -769,6 +776,20 @@ next_pageblock:
 		low_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages) - 1;
 		if (next_capture_pfn)
 			next_capture_pfn = low_pfn + 1;
+
+isolation_failed:
+		if (cc->mode == MIGRATE_ASYNC && next_capture_pfn) {
+			if (nr_isolated) {
+				if (locked) {
+					spin_unlock_irqrestore(&zone->lru_lock,
+									flags);
+					locked = false;
+				}
+				putback_movable_pages(migratelist);
+				nr_isolated = 0;
+			}
+			low_pfn = next_capture_pfn - 1;
+		}
 	}
 
 	/*
@@ -778,6 +799,7 @@ next_pageblock:
 	if (unlikely(low_pfn > end_pfn))
 		end_pfn = low_pfn;
 
+	cc->nr_migratepages = nr_isolated;
 	acct_isolated(zone, locked, cc);
 
 	if (locked)
-- 
1.8.4.5

