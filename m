Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbaDHIXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:23:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaDHIXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:23:04 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/2] mm: Disable zone_reclaim_mode by default
Date: Tue,  8 Apr 2014 09:22:59 +0100
Message-Id: <1396945380-18592-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1396945380-18592-1-git-send-email-mgorman@suse.de>
References: <1396945380-18592-1-git-send-email-mgorman@suse.de>
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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 Documentation/sysctl/vm.txt         | 17 +++++++++--------
 arch/ia64/include/asm/topology.h    |  3 ++-
 arch/powerpc/include/asm/topology.h |  8 ++------
 include/linux/topology.h            |  3 ++-
 mm/page_alloc.c                     |  2 --
 5 files changed, 15 insertions(+), 18 deletions(-)

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
diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index a2496e4..e1d484e 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -21,7 +21,8 @@
 #define PENALTY_FOR_NODE_WITH_CPUS 255
 
 /*
- * Distance above which we begin to use zone reclaim
+ * Nodes within this distance are eligible for reclaim by zone_reclaim() when
+ * zone_reclaim_mode is enabled.
  */
 #define RECLAIM_DISTANCE 15
 
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index d0b5fca..c778ca0 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -9,12 +9,8 @@ struct device_node;
 #ifdef CONFIG_NUMA
 
 /*
- * Before going off node we want the VM to try and reclaim from the local
- * node. It does this if the remote distance is larger than RECLAIM_DISTANCE.
- * With the default REMOTE_DISTANCE of 20 and the default RECLAIM_DISTANCE of
- * 20, we never reclaim and go off node straight away.
- *
- * To fix this we choose a smaller value of RECLAIM_DISTANCE.
+ * If zone_reclaim_mode is enabled, a RECLAIM_DISTANCE of 10 will mean that
+ * all zones on all nodes will be eligible for zone_reclaim().
  */
 #define RECLAIM_DISTANCE 10
 
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 12ae6ce..a1e9186 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -58,7 +58,8 @@ int arch_update_cpu_topology(void);
 /*
  * If the distance between nodes in a system is larger than RECLAIM_DISTANCE
  * (in whatever arch specific measurement units returned by node_distance())
- * then switch on zone reclaim on boot.
+ * and zone_reclaim_mode is enabled then the VM will only call zone_reclaim()
+ * on nodes within this distance.
  */
 #define RECLAIM_DISTANCE 30
 #endif
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

