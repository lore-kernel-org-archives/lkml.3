Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaGKHgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:36:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:36972 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbaGKHgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:36:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="571589569"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: [RFC Patch V1 09/30] mm, memcg: Use cpu_to_mem()/numa_mem_id() to support memoryless node
Date: Fri, 11 Jul 2014 15:37:26 +0800
Message-Id: <1405064267-11678-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_HAVE_MEMORYLESS_NODES is enabled, cpu_to_node()/numa_node_id()
may return a node without memory, and later cause system failure/panic
when calling kmalloc_node() and friends with returned node id.
So use cpu_to_mem()/numa_mem_id() instead to get the nearest node with
memory for the/current cpu.

If CONFIG_HAVE_MEMORYLESS_NODES is disabled, cpu_to_mem()/numa_mem_id()
is the same as cpu_to_node()/numa_node_id().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a2c7bcb0e6eb..d6c4b7255ca9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1933,7 +1933,7 @@ int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
 	 * we use curret node.
 	 */
 	if (unlikely(node == MAX_NUMNODES))
-		node = numa_node_id();
+		node = numa_mem_id();
 
 	memcg->last_scanned_node = node;
 	return node;
-- 
1.7.10.4

