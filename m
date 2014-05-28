Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaE1WqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:46:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbaE1WqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:46:03 -0400
Date: Wed, 28 May 2014 19:43:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations (v3)
Message-ID: <20140528224324.GA1132@amt.cnet>
References: <20140523193706.GA22854@amt.cnet>
 <20140526185344.GA19976@amt.cnet>
 <53858A06.8080507@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53858A06.8080507@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zone specific allocations, such as GFP_DMA32, should not be restricted
to cpusets allowed node list: the zones which such allocations demand
might be contained in particular nodes outside the cpuset node list.

Necessary for the following usecase:
- driver which requires zone specific memory (such as KVM, which
requires root pagetable at paddr < 4GB).
- user wants to limit allocations of application to nodeX, and nodeX has
no memory < 4GB.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3d54c41..3bbc23f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2374,6 +2374,7 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
  * variable 'wait' is not set, and the bit ALLOC_CPUSET is not set
  * in alloc_flags.  That logic and the checks below have the combined
  * affect that:
+ *	gfp_zone(mask) < policy_zone - any node ok
  *	in_interrupt - any node ok (current task context irrelevant)
  *	GFP_ATOMIC   - any node ok
  *	TIF_MEMDIE   - any node ok
@@ -2392,6 +2393,10 @@ int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 
 	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
 		return 1;
+#ifdef CONFIG_NUMA
+	if (gfp_zone(gfp_mask) < policy_zone)
+		return 1;
+#endif
 	might_sleep_if(!(gfp_mask & __GFP_HARDWALL));
 	if (node_isset(node, current->mems_allowed))
 		return 1;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5dba293..dfea3dc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2698,6 +2698,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	unsigned int cpuset_mems_cookie;
 	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET|ALLOC_FAIR;
 	struct mem_cgroup *memcg = NULL;
+	nodemask_t *cpuset_mems_allowed = &cpuset_current_mems_allowed;
 
 	gfp_mask &= gfp_allowed_mask;
 
@@ -2726,9 +2727,14 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
+#ifdef CONFIG_NUMA
+	if (gfp_zone(gfp_mask) < policy_zone)
+		cpuset_mems_allowed = NULL;
+#endif
+
 	/* The preferred zone is used for statistics later */
 	first_zones_zonelist(zonelist, high_zoneidx,
-				nodemask ? : &cpuset_current_mems_allowed,
+				nodemask ? : cpuset_mems_allowed,
 				&preferred_zone);
 	if (!preferred_zone)
 		goto out;
