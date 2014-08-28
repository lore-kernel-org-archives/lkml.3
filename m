Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaH1SgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:36:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbaH1Sfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:35:53 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 07/97] mm: exclude memoryless nodes from zone_reclaim
Date: Thu, 28 Aug 2014 19:34:15 +0100
Message-Id: <1409250945-30874-8-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

commit 70ef57e6c22c3323dce179b7d0d433c479266612 upstream.

We had a report about strange OOM killer strikes on a PPC machine
although there was a lot of swap free and a tons of anonymous memory
which could be swapped out.  In the end it turned out that the OOM was a
side effect of zone reclaim which wasn't unmapping and swapping out and
so the system was pushed to the OOM.  Although this sounds like a bug
somewhere in the kswapd vs.  zone reclaim vs.  direct reclaim
interaction numactl on the said hardware suggests that the zone reclaim
should not have been set in the first place:

  node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
  node 0 size: 0 MB
  node 0 free: 0 MB
  node 2 cpus:
  node 2 size: 7168 MB
  node 2 free: 6019 MB
  node distances:
  node   0   2
  0:  10  40
  2:  40  10

So all the CPUs are associated with Node0 which doesn't have any memory
while Node2 contains all the available memory.  Node distances cause an
automatic zone_reclaim_mode enabling.

Zone reclaim is intended to keep the allocations local but this doesn't
make any sense on the memoryless nodes.  So let's exclude such nodes for
init_zone_allows_reclaim which evaluates zone reclaim behavior and
suitable reclaim_nodes.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Tested-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bffedeb..d37e8cd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1850,7 +1850,7 @@ static void __paginginit init_zone_allows_reclaim(int nid)
 {
 	int i;
 
-	for_each_online_node(i)
+	for_each_node_state(i, N_MEMORY)
 		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
 			node_set(i, NODE_DATA(nid)->reclaim_nodes);
 		else
@@ -4903,7 +4903,8 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
-	init_zone_allows_reclaim(nid);
+	if (node_state(nid, N_MEMORY))
+		init_zone_allows_reclaim(nid);
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 #endif
-- 
1.8.4.5

