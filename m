Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab3LKSJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:09:29 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:46164 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab3LKSJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:09:26 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: page_alloc: exclude unreclaimable allocations from zone fairness policy
Date: Wed, 11 Dec 2013 13:09:16 -0500
Message-Id: <1386785356-19911-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen noted a regression in a microbenchmark that loops around
open() and close() on an 8-node NUMA machine and bisected it down to
81c0a2bb515f ("mm: page_alloc: fair zone allocator policy").  That
change forces the slab allocations of the file descriptor to spread
out to all 8 nodes, causing remote references in the page allocator
and slab.

The round-robin policy is only there to provide fairness among memory
allocations that are reclaimed involuntarily based on pressure in each
zone.  It does not make sense to apply it to unreclaimable kernel
allocations that are freed manually, in this case instantly after the
allocation, and incur the remote reference costs twice for no reason.

Only round-robin allocations that are usually freed through page
reclaim or slab shrinking.

Bisected-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@kernel.org>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 580a5f075ed0..f861d0257e90 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1920,7 +1920,8 @@ zonelist_scan:
 		 * back to remote zones that do not partake in the
 		 * fairness round-robin cycle of this zonelist.
 		 */
-		if (alloc_flags & ALLOC_WMARK_LOW) {
+		if ((alloc_flags & ALLOC_WMARK_LOW) &&
+		    (gfp_mask & GFP_MOVABLE_MASK)) {
 			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
 				continue;
 			if (zone_reclaim_mode &&
-- 
1.8.4.2

