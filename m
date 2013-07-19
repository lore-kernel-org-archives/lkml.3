Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab3GSU4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 16:56:35 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50544 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3GSUzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 16:55:44 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 2/3] mm: page_alloc: rearrange watermark checking in get_page_from_freelist
Date: Fri, 19 Jul 2013 16:55:24 -0400
Message-Id: <1374267325-22865-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374267325-22865-1-git-send-email-hannes@cmpxchg.org>
References: <1374267325-22865-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocations that do not have to respect the watermarks are rare
high-priority events.  Reorder the code such that per-zone dirty
limits and future checks important only to regular page allocations
are ignored in these extraordinary situations.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_alloc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d9df57d..af1d956b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1867,12 +1867,17 @@ zonelist_scan:
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						high_zoneidx, nodemask) {
+		unsigned long mark;
+
 		if (IS_ENABLED(CONFIG_NUMA) && zlc_active &&
 			!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
 		if ((alloc_flags & ALLOC_CPUSET) &&
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				continue;
+		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
+		if (alloc_flags & ALLOC_NO_WATERMARKS)
+			goto try_this_zone;
 		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a zone that is within its dirty
@@ -1903,16 +1908,11 @@ zonelist_scan:
 		    (gfp_mask & __GFP_WRITE) && !zone_dirty_ok(zone))
 			goto this_zone_full;
 
-		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
-		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
-			unsigned long mark;
+		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
+		if (!zone_watermark_ok(zone, order, mark,
+				       classzone_idx, alloc_flags)) {
 			int ret;
 
-			mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
-			if (zone_watermark_ok(zone, order, mark,
-				    classzone_idx, alloc_flags))
-				goto try_this_zone;
-
 			if (IS_ENABLED(CONFIG_NUMA) &&
 					!did_zlc_setup && nr_online_nodes > 1) {
 				/*
-- 
1.8.3.2

