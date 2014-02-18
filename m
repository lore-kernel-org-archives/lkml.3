Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaBRX6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:58:11 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33411 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbaBRX6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:58:09 -0500
Date: Tue, 18 Feb 2014 15:58:00 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ppc: RECLAIM_DISTANCE 10?
Message-ID: <20140218235800.GC10844@linux.vnet.ibm.com>
References: <20140218090658.GA28130@dhcp22.suse.cz>
 <20140218233404.GB10844@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218233404.GB10844@linux.vnet.ibm.com>
X-Operating-System: Linux 3.11.0-15-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021823-0320-0000-0000-0000027E327E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.02.2014 [15:34:05 -0800], Nishanth Aravamudan wrote:
> Hi Michal,
> 
> On 18.02.2014 [10:06:58 +0100], Michal Hocko wrote:
> > Hi,
> > I have just noticed that ppc has RECLAIM_DISTANCE reduced to 10 set by
> > 56608209d34b (powerpc/numa: Set a smaller value for RECLAIM_DISTANCE to
> > enable zone reclaim). The commit message suggests that the zone reclaim
> > is desirable for all NUMA configurations.
> > 
> > History has shown that the zone reclaim is more often harmful than
> > helpful and leads to performance problems. The default RECLAIM_DISTANCE
> > for generic case has been increased from 20 to 30 around 3.0
> > (32e45ff43eaf mm: increase RECLAIM_DISTANCE to 30).
> 
> Interesting.
> 
> > I strongly suspect that the patch is incorrect and it should be
> > reverted. Before I will send a revert I would like to understand what
> > led to the patch in the first place. I do not see why would PPC use only
> > LOCAL_DISTANCE and REMOTE_DISTANCE distances and in fact machines I have
> > seen use different values.
> > 
> > Anton, could you comment please?
> 
> I'll let Anton comment here, but in looking into this issue in working
> on CONFIG_HAVE_MEMORYLESS_NODE support, I realized that any LPAR with
> memoryless nodes will set zone_reclaim_mode to 1. I think we want to
> ignore memoryless nodes when we set up the reclaim mode like the
> following? I'll send it as a proper patch if you agree?
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5de4337..4f6ff6f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1853,8 +1853,9 @@ static void __paginginit init_zone_allows_reclaim(int nid)
>  {
>         int i;
> 
> -       for_each_online_node(i)
> -               if (node_distance(nid, i) <= RECLAIM_DISTANCE)
> +       for_each_online_node(i) {
> +               if (node_distance(nid, i) <= RECLAIM_DISTANCE ||
> +                                       local_memory_node(nid) != nid)
>                         node_set(i, NODE_DATA(nid)->reclaim_nodes);
>                 else
>                         zone_reclaim_mode = 1;
> 
> Note, this won't actually do anything if CONFIG_HAVE_MEMORYLESS_NODES is
> not set, but if it is, I think semantically it will indicate that
> memoryless nodes *have* to reclaim remotely.
> 
> And actually the above won't work, because the callpath is
> 
> start_kernel -> setup_arch -> paging_init [-> free_area_init_nodes ->
> free_area_init_node -> init_zone_allows_reclaim] which is called before
> build_all_zonelists. This is a similar ordering problem as I'm having
> with the MEMORYLESS_NODE support, will work on it.

How about the following?

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5de4337..1a0eced 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1854,7 +1854,8 @@ static void __paginginit init_zone_allows_reclaim(int nid)
        int i;
 
        for_each_online_node(i)
-               if (node_distance(nid, i) <= RECLAIM_DISTANCE)
+               if (node_distance(nid, i) <= RECLAIM_DISTANCE ||
+                                       !NODE_DATA(nid)->node_present_pages)
                        node_set(i, NODE_DATA(nid)->reclaim_nodes);
                else
                        zone_reclaim_mode = 1;
@@ -4901,13 +4902,13 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 
        pgdat->node_id = nid;
        pgdat->node_start_pfn = node_start_pfn;
-       init_zone_allows_reclaim(nid);
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
        get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 #endif
        calculate_node_totalpages(pgdat, start_pfn, end_pfn,
                                  zones_size, zholes_size);
 
+       init_zone_allows_reclaim(nid);
        alloc_node_mem_map(pgdat);
 #ifdef CONFIG_FLAT_NODE_MEM_MAP
        printk(KERN_DEBUG "free_area_init_node: node %d, pgdat %08lx, node_mem_map %08lx\n",

I think it's safe to move init_zone_allows_reclaim, because I don't
think any allocates are occurring here that could cause us to reclaim
anyways, right? Moving it allows us to safely reference
node_present_pages.

Thanks,
Nish

