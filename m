Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaGKHiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:38:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:37389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbaGKHiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:38:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="571590244"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC Patch V1 28/30] mm: Update _mem_id_[] for every possible CPU when memory configuration changes
Date: Fri, 11 Jul 2014 15:37:45 +0800
Message-Id: <1405064267-11678-29-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kernel only updates _mem_id_[cpu] for onlined CPUs when memory
configuration changes. So kernel may allocate memory from remote node
for a CPU if the CPU is still in absent or offline state even if the
node associated with the CPU has already been onlined. This patch tries
to improve performance by updating _mem_id_[cpu] for each possible CPU
when memory configuration changes, thus kernel could always allocate
from local node once the node is onlined.

We check node_online(cpu_to_node(cpu)) because:
1) local_memory_node(nid) needs to access NODE_DATA(nid)
2) try_offline_node(nid) just zeroes out NODE_DATA(nid) instead of free it

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0ea758b898fd..de86e941ed57 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3844,13 +3844,13 @@ static int __build_all_zonelists(void *data)
 		/*
 		 * We now know the "local memory node" for each node--
 		 * i.e., the node of the first zone in the generic zonelist.
-		 * Set up numa_mem percpu variable for on-line cpus.  During
-		 * boot, only the boot cpu should be on-line;  we'll init the
-		 * secondary cpus' numa_mem as they come on-line.  During
-		 * node/memory hotplug, we'll fixup all on-line cpus.
+		 * Set up numa_mem percpu variable for all possible cpus
+		 * if associated node has been onlined.
 		 */
-		if (cpu_online(cpu))
+		if (node_online(cpu_to_node(cpu)))
 			set_cpu_numa_mem(cpu, local_memory_node(cpu_to_node(cpu)));
+		else
+			set_cpu_numa_mem(cpu, NUMA_NO_NODE);
 #endif
 	}
 
-- 
1.7.10.4

