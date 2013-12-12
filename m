Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3LLPGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:06:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab3LLPGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:06:25 -0500
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3/4] mm: page_alloc: Use zone node IDs to approximate locality
Date: Thu, 12 Dec 2013 15:06:18 +0000
Message-Id: <1386860779-2301-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386860779-2301-1-git-send-email-mgorman@suse.de>
References: <1386860779-2301-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zone_local is using node_distance which is a more expensive call than
necessary. On x86, it's another function call in the allocator fast path
and increases cache footprint. This patch makes the assumption zones on a
local node will share the same node ID. The necessary information should
already be cache hot.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 64020eb..fd9677e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1816,7 +1816,7 @@ static void zlc_clear_zones_full(struct zonelist *zonelist)
 
 static bool zone_local(struct zone *local_zone, struct zone *zone)
 {
-	return node_distance(local_zone->node, zone->node) == LOCAL_DISTANCE;
+	return zone_to_nid(zone) == numa_node_id();
 }
 
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
-- 
1.8.4

