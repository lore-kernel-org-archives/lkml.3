Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaEWThp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 15:37:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbaEWThn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 15:37:43 -0400
Date: Fri, 23 May 2014 16:37:07 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations 
Message-ID: <20140523193706.GA22854@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zone specific allocations, such as GFP_DMA32, should not be restricted
to cpusets allowed node list: the zones which such allocations demand
might be contained in particular nodes outside the cpuset node list.

The alternative would be to not perform such allocations from
applications which are cpuset restricted, which is unrealistic.

Fixes KVM's alloc_page(gfp_mask=GFP_DMA32) with cpuset as explained.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5dba293..f228039 100644
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
