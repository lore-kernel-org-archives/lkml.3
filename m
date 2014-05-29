Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaE2X3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:29:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbaE2X3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:29:05 -0400
Date: Thu, 29 May 2014 20:28:19 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations (v5)
Message-ID: <20140529232819.GA29803@amt.cnet>
References: <20140523193706.GA22854@amt.cnet>
 <20140526185344.GA19976@amt.cnet>
 <53858A06.8080507@huawei.com>
 <20140528224324.GA1132@amt.cnet>
 <20140529184303.GA20571@amt.cnet>
 <alpine.DEB.2.02.1405291555120.9336@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405291555120.9336@chino.kir.corp.google.com>
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
- user wants to limit allocations of application to nodeX, and nodeX
has no memory < 4GB.

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
index 5dba293..0fd6923 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2723,6 +2723,11 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	if (!memcg_kmem_newpage_charge(gfp_mask, &memcg, order))
 		return NULL;
 
+#ifdef CONFIG_NUMA
+	if (!nodemask && gfp_zone(gfp_mask) < policy_zone)
+		nodemask = &node_states[N_MEMORY];
+#endif
+
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 

