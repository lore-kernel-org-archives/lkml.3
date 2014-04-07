Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbaDGWfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:35:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbaDGWec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:34:32 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/2] mm: Disable zone_reclaim_mode by default
Date: Mon,  7 Apr 2014 23:34:27 +0100
Message-Id: <1396910068-11637-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1396910068-11637-1-git-send-email-mgorman@suse.de>
References: <1396910068-11637-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zone_reclaim_mode causes processes to prefer reclaiming memory from local
node instead of spilling over to other nodes. This made sense initially when
NUMA machines were almost exclusively HPC and the workload was partitioned
into nodes. The NUMA penalties were sufficiently high to justify reclaiming
the memory. On current machines and workloads it is often the case that
zone_reclaim_mode destroys performance but not all users know how to detect
this. Favour the common case and disable it by default. Users that are
sophisticated enough to know they need zone_reclaim_mode will detect it.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 Documentation/sysctl/vm.txt | 17 +++++++++--------
 mm/page_alloc.c             |  2 --
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index d614a9b..ff5da70 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -751,16 +751,17 @@ This is value ORed together of
 2	= Zone reclaim writes dirty pages out
 4	= Zone reclaim swaps pages
 
-zone_reclaim_mode is set during bootup to 1 if it is determined that pages
-from remote zones will cause a measurable performance reduction. The
-page allocator will then reclaim easily reusable pages (those page
-cache pages that are currently not used) before allocating off node pages.
-
-It may be beneficial to switch off zone reclaim if the system is
-used for a file server and all of memory should be used for caching files
-from disk. In that case the caching effect is more important than
+zone_reclaim_mode is disabled by default.  For file servers or workloads
+that benefit from having their data cached, zone_reclaim_mode should be
+left disabled as the caching effect is likely to be more important than
 data locality.
 
+zone_reclaim may be enabled if it's known that the workload is partitioned
+such that each partition fits within a NUMA node and that accessing remote
+memory would cause a measurable performance reduction.  The page allocator
+will then reclaim easily reusable pages (those page cache pages that are
+currently not used) before allocating off node pages.
+
 Allowing zone reclaim to write out pages stops processes that are
 writing large amounts of data from dirtying pages on other nodes. Zone
 reclaim will write out dirty pages if a zone fills up and so effectively
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3bac76a..a256f85 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1873,8 +1873,6 @@ static void __paginginit init_zone_allows_reclaim(int nid)
 	for_each_online_node(i)
 		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
 			node_set(i, NODE_DATA(nid)->reclaim_nodes);
-		else
-			zone_reclaim_mode = 1;
 }
 
 #else	/* CONFIG_NUMA */
-- 
1.8.4.5

