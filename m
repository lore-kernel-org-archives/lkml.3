Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaG1NPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:15:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaG1NMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:12:06 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH v5 03/14] mm, compaction: do not count compact_stall if all zones skipped compaction
Date: Mon, 28 Jul 2014 15:11:30 +0200
Message-Id: <1406553101-29326-4-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406553101-29326-1-git-send-email-vbabka@suse.cz>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compact_stall vmstat counter counts the number of allocations stalled by
direct compaction. It does not count when all attempted zones had deferred
compaction, but it does count when all zones skipped compaction. The skipping
is decided based on very early check of compaction_suitable(), based on
watermarks and memory fragmentation. Therefore it makes sense not to count
skipped compactions as stalls. Moreover, compact_success or compact_fail is
also already not being counted when compaction was skipped, so this patch
changes the compact_stall counting to match the other two.

Additionally, restructure __alloc_pages_direct_compact() code for better
readability.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c | 75 +++++++++++++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 34 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a14efeb..91191fb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2300,6 +2300,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	unsigned long *did_some_progress)
 {
 	struct zone *last_compact_zone = NULL;
+	struct page *page;
 
 	if (!order)
 		return NULL;
@@ -2311,49 +2312,55 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 						&last_compact_zone);
 	current->flags &= ~PF_MEMALLOC;
 
-	if (*did_some_progress > COMPACT_DEFERRED)
-		count_vm_event(COMPACTSTALL);
-	else
+	switch (*did_some_progress) {
+	case COMPACT_DEFERRED:
 		*deferred_compaction = true;
+		/* fall-through */
+	case COMPACT_SKIPPED:
+		return NULL;
+	default:
+		break;
+	}
 
-	if (*did_some_progress > COMPACT_SKIPPED) {
-		struct page *page;
+	/*
+	 * At least in one zone compaction wasn't deferred or skipped, so let's
+	 * count a compaction stall
+	 */
+	count_vm_event(COMPACTSTALL);
 
-		/* Page migration frees to the PCP lists but we want merging */
-		drain_pages(get_cpu());
-		put_cpu();
+	/* Page migration frees to the PCP lists but we want merging */
+	drain_pages(get_cpu());
+	put_cpu();
 
-		page = get_page_from_freelist(gfp_mask, nodemask,
-				order, zonelist, high_zoneidx,
-				alloc_flags & ~ALLOC_NO_WATERMARKS,
-				preferred_zone, classzone_idx, migratetype);
+	page = get_page_from_freelist(gfp_mask, nodemask,
+			order, zonelist, high_zoneidx,
+			alloc_flags & ~ALLOC_NO_WATERMARKS,
+			preferred_zone, classzone_idx, migratetype);
 
-		if (page) {
-			struct zone *zone = page_zone(page);
+	if (page) {
+		struct zone *zone = page_zone(page);
 
-			zone->compact_blockskip_flush = false;
-			compaction_defer_reset(zone, order, true);
-			count_vm_event(COMPACTSUCCESS);
-			return page;
-		}
+		zone->compact_blockskip_flush = false;
+		compaction_defer_reset(zone, order, true);
+		count_vm_event(COMPACTSUCCESS);
+		return page;
+	}
 
-		/*
-		 * last_compact_zone is where try_to_compact_pages thought
-		 * allocation should succeed, so it did not defer compaction.
-		 * But now we know that it didn't succeed, so we do the defer.
-		 */
-		if (last_compact_zone && mode != MIGRATE_ASYNC)
-			defer_compaction(last_compact_zone, order);
+	/*
+	 * last_compact_zone is where try_to_compact_pages thought allocation
+	 * should succeed, so it did not defer compaction. But here we know
+	 * that it didn't succeed, so we do the defer.
+	 */
+	if (last_compact_zone && mode != MIGRATE_ASYNC)
+		defer_compaction(last_compact_zone, order);
 
-		/*
-		 * It's bad if compaction run occurs and fails.
-		 * The most likely reason is that pages exist,
-		 * but not enough to satisfy watermarks.
-		 */
-		count_vm_event(COMPACTFAIL);
+	/*
+	 * It's bad if compaction run occurs and fails. The most likely reason
+	 * is that pages exist, but not enough to satisfy watermarks.
+	 */
+	count_vm_event(COMPACTFAIL);
 
-		cond_resched();
-	}
+	cond_resched();
 
 	return NULL;
 }
-- 
1.8.4.5

