Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaH1SsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:48:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbaH1ShE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:04 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 75/97] mm: page_alloc: take the ALLOC_NO_WATERMARK check out of the fast path
Date: Thu, 28 Aug 2014 19:35:23 +0100
Message-Id: <1409250945-30874-76-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 5dab29113ca56335c78be3f98bf5ddf2ef8eb6a6 upstream.

ALLOC_NO_WATERMARK is set in a few cases.  Always by kswapd, always for
__GFP_MEMALLOC, sometimes for swap-over-nfs, tasks etc.  Each of these
cases are relatively rare events but the ALLOC_NO_WATERMARK check is an
unlikely branch in the fast path.  This patch moves the check out of the
fast path and after it has been determined that the watermarks have not
been met.  This helps the common fast path at the cost of making the slow
path slower and hitting kswapd with a performance cost.  It's a reasonable
tradeoff.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cb4cadd..332066b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1934,9 +1934,6 @@ zonelist_scan:
 			(alloc_flags & ALLOC_CPUSET) &&
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				continue;
-		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
-		if (unlikely(alloc_flags & ALLOC_NO_WATERMARKS))
-			goto try_this_zone;
 		/*
 		 * Distribute pages in proportion to the individual
 		 * zone size to ensure fair page aging.  The zone a
@@ -1983,6 +1980,11 @@ zonelist_scan:
 				       classzone_idx, alloc_flags)) {
 			int ret;
 
+			/* Checked here to keep the fast path fast */
+			BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
+			if (alloc_flags & ALLOC_NO_WATERMARKS)
+				goto try_this_zone;
+
 			if (IS_ENABLED(CONFIG_NUMA) &&
 					!did_zlc_setup && nr_online_nodes > 1) {
 				/*
-- 
1.8.4.5

