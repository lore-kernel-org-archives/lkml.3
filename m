Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaEAIpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 04:45:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbaEAIo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 04:44:57 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/17] mm: page_alloc: Take the ALLOC_NO_WATERMARK check out of the fast path
Date: Thu,  1 May 2014 09:44:38 +0100
Message-Id: <1398933888-4940-8-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1398933888-4940-1-git-send-email-mgorman@suse.de>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ALLOC_NO_WATERMARK is set in a few cases. Always by kswapd, always for
__GFP_MEMALLOC, sometimes for swap-over-nfs, tasks etc. Each of these cases
are relatively rare events but the ALLOC_NO_WATERMARK check is an unlikely
branch in the fast path.  This patch moves the check out of the fast path
and after it has been determined that the watermarks have not been met. This
helps the common fast path at the cost of making the slow path slower and
hitting kswapd with a performance cost. It's a reasonable tradeoff.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_alloc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2e576fd..dc123ff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1944,9 +1944,6 @@ zonelist_scan:
 			(alloc_flags & ALLOC_CPUSET) &&
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				continue;
-		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
-		if (unlikely(alloc_flags & ALLOC_NO_WATERMARKS))
-			goto try_this_zone;
 		/*
 		 * Distribute pages in proportion to the individual
 		 * zone size to ensure fair page aging.  The zone a
@@ -1993,6 +1990,11 @@ zonelist_scan:
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

