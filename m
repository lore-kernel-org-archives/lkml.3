Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbaEWXe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 19:34:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbaEWXe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 19:34:26 -0400
Date: Fri, 23 May 2014 20:33:14 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org
Subject: Re: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations
Message-ID: <20140523233314.GA3775@amt.cnet>
References: <20140523193706.GA22854@amt.cnet>
 <alpine.DEB.2.02.1405231334460.13205@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405231334460.13205@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 01:51:12PM -0700, David Rientjes wrote:
> On Fri, 23 May 2014, Marcelo Tosatti wrote:
> 
> > Zone specific allocations, such as GFP_DMA32, should not be restricted
> > to cpusets allowed node list: the zones which such allocations demand
> > might be contained in particular nodes outside the cpuset node list.
> > 
> > The alternative would be to not perform such allocations from
> > applications which are cpuset restricted, which is unrealistic.
> > 
> 
> Or ensure applications that allocate from lowmem are allowed to do so, but 
> I understand that might be hard to make sure always happens.
> 
> > Fixes KVM's alloc_page(gfp_mask=GFP_DMA32) with cpuset as explained.
> > 
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 5dba293..f228039 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2698,6 +2698,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
> >  	unsigned int cpuset_mems_cookie;
> >  	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET|ALLOC_FAIR;
> >  	struct mem_cgroup *memcg = NULL;
> > +	nodemask_t *cpuset_mems_allowed = &cpuset_current_mems_allowed;
> >  
> >  	gfp_mask &= gfp_allowed_mask;
> >  
> > @@ -2726,9 +2727,14 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
> >  retry_cpuset:
> >  	cpuset_mems_cookie = read_mems_allowed_begin();
> >  
> > +#ifdef CONFIG_NUMA
> > +	if (gfp_zone(gfp_mask) < policy_zone)
> > +		cpuset_mems_allowed = NULL;
> > +#endif
> > +
> >  	/* The preferred zone is used for statistics later */
> >  	first_zones_zonelist(zonelist, high_zoneidx,
> > -				nodemask ? : &cpuset_current_mems_allowed,
> > +				nodemask ? : cpuset_mems_allowed,
> >  				&preferred_zone);
> >  	if (!preferred_zone)
> >  		goto out;
> > 
> 
> I think this is incomplete.  Correct me if I'm wrong on how this is 
> working: preferred_zone, today, is NULL because first_zones_zonelist() is 
> restricted to a cpuset.mems that does not include lowmem and your patch 
> fixes that.  
> But if the fastpath allocation with mandatory ALLOC_CPUSET 
> fails and we go to the slowpath, which may or may not have showed up in 
> your testing, there's still issues, 
> particularly if __GFP_WAIT and lots of 
> allocators do GFP_KERNEL | __GFP_DMA32.  This requires ALLOC_CPUSET on all 
> allocations and you haven't updated __cpuset_node_allowed_softwall() with 
> this exception nor zlc_setup().

Yes, thanks. Can you please review updated patch below.

> After that's done, I think all of this is really convoluted and deserves a 
> comment to describe the ALLOC_CPUSET and __GFP_DMA32 behavior.

The comment at mm/mempolicy.c seems sufficient:

/* Highest zone. An specific allocation for a zone below that is not
   policied. */
enum zone_type policy_zone = 0;

> Adding Li, the cpusets maintainer, to this as well.


diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3d54c41..b70a336 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2392,6 +2392,10 @@ int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 
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
