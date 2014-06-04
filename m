Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbaFDAaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 20:30:11 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64433 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbaFDAaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 20:30:04 -0400
Date: Tue, 3 Jun 2014 17:30:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>, Rik van Riel <riel@redhat.com>
Subject: [patch -mm 3/3] mm, compaction: avoid compacting memory for thp if
 pageblock cannot become free
In-Reply-To: <alpine.DEB.2.02.1406031728390.5312@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1406031729410.5312@chino.kir.corp.google.com>
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz> <1400233673-11477-1-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com> <537DB0E5.40602@suse.cz> <alpine.DEB.2.02.1405220127320.13630@chino.kir.corp.google.com>
 <537DE799.3040400@suse.cz> <alpine.DEB.2.02.1406031728390.5312@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's pointless to migrate pages within a pageblock if the entire pageblock will 
not become free for a thp allocation.

If we encounter a page that cannot be migrated and a direct compactor other than 
khugepaged is trying to allocate a hugepage for thp, then skip the entire 
pageblock and avoid migrating pages needlessly.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/compaction.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -537,12 +537,12 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		if ((low_pfn & (MAX_ORDER_NR_PAGES - 1)) == 0) {
 			if (!pfn_valid(low_pfn)) {
 				low_pfn += MAX_ORDER_NR_PAGES - 1;
-				continue;
+				goto next;
 			}
 		}
 
 		if (!pfn_valid_within(low_pfn))
-			continue;
+			goto next;
 		nr_scanned++;
 
 		/*
@@ -553,7 +553,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		 */
 		page = pfn_to_page(low_pfn);
 		if (page_zone(page) != zone)
-			continue;
+			goto next;
 
 		if (!valid_page)
 			valid_page = page;
@@ -599,7 +599,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 					goto isolate_success;
 				}
 			}
-			continue;
+			goto next;
 		}
 
 		/*
@@ -616,7 +616,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			if (!locked)
 				goto next_pageblock;
 			low_pfn += (1 << compound_order(page)) - 1;
-			continue;
+			goto next;
 		}
 
 		/*
@@ -626,7 +626,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		 */
 		if (!page_mapping(page) &&
 		    page_count(page) > page_mapcount(page))
-			continue;
+			goto next;
 
 		/* Check if it is ok to still hold the lock */
 		locked = compact_checklock_irqsave(&zone->lru_lock, &flags,
@@ -636,17 +636,17 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 
 		/* Recheck PageLRU and PageTransHuge under lock */
 		if (!PageLRU(page))
-			continue;
+			goto next;
 		if (PageTransHuge(page)) {
 			low_pfn += (1 << compound_order(page)) - 1;
-			continue;
+			goto next;
 		}
 
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, mode) != 0)
-			continue;
+			goto next;
 
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
 
@@ -669,6 +669,24 @@ isolate_success:
 
 next_pageblock:
 		low_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages) - 1;
+
+next:
+		/*
+		 * It is too expensive for compaction to migrate pages from a
+		 * pageblock for thp page faults unless the entire pageblock
+		 * will become free.
+		 */
+		if ((cc->gfp_mask & __GFP_NO_KSWAPD) &&
+		    !(current->flags & PF_KTHREAD)) {
+			if (locked) {
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
+				locked = false;
+			}
+			putback_movable_pages(migratelist);
+			cc->nr_migratepages = 0;
+			nr_isolated = 0;
+			low_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages) - 1;
+		}
 	}
 
 	acct_isolated(zone, locked, cc);
@@ -880,7 +898,7 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 
 	cc->migrate_pfn = low_pfn;
 
-	return ISOLATE_SUCCESS;
+	return cc->nr_migratepages ? ISOLATE_SUCCESS : ISOLATE_NONE;
 }
 
 static int compact_finished(struct zone *zone, struct compact_control *cc,
@@ -1055,9 +1073,6 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 			;
 		}
 
-		if (!cc->nr_migratepages)
-			continue;
-
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
 				compaction_free, (unsigned long)cc, cc->mode,
 				MR_COMPACTION);
