Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaBSBnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:43:41 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34335 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaBSBnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:43:40 -0500
Date: Tue, 18 Feb 2014 17:43:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Anton Blanchard <anton@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ppc: RECLAIM_DISTANCE 10?
In-Reply-To: <20140218235800.GC10844@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1402181737530.17521@chino.kir.corp.google.com>
References: <20140218090658.GA28130@dhcp22.suse.cz> <20140218233404.GB10844@linux.vnet.ibm.com> <20140218235800.GC10844@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, Nishanth Aravamudan wrote:

> How about the following?
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5de4337..1a0eced 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1854,7 +1854,8 @@ static void __paginginit init_zone_allows_reclaim(int nid)
>         int i;
>  
>         for_each_online_node(i)
> -               if (node_distance(nid, i) <= RECLAIM_DISTANCE)
> +               if (node_distance(nid, i) <= RECLAIM_DISTANCE ||
> +                                       !NODE_DATA(i)->node_present_pages)
>                         node_set(i, NODE_DATA(nid)->reclaim_nodes);
>                 else
>                         zone_reclaim_mode = 1;

 [ I changed the above from NODE_DATA(nid) -> NODE_DATA(i) as you caught 
   so we're looking at the right code. ]

That can't be right, it would allow reclaiming from a memoryless node.  I 
think what you want is

	for_each_online_node(i) {
		if (!node_present_pages(i))
			continue;
		if (node_distance(nid, i) <= RECLAIM_DISTANCE) {
			node_set(i, NODE_DATA(nid)->reclaim_nodes);
			continue;
		}
		/* Always try to reclaim locally */
		zone_reclaim_mode = 1;
	}

but we really should be able to do for_each_node_state(i, N_MEMORY) here 
and memoryless nodes should already be excluded from that mask.

> @@ -4901,13 +4902,13 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
>  
>         pgdat->node_id = nid;
>         pgdat->node_start_pfn = node_start_pfn;
> -       init_zone_allows_reclaim(nid);
>  #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
>         get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
>  #endif
>         calculate_node_totalpages(pgdat, start_pfn, end_pfn,
>                                   zones_size, zholes_size);
>  
> +       init_zone_allows_reclaim(nid);
>         alloc_node_mem_map(pgdat);
>  #ifdef CONFIG_FLAT_NODE_MEM_MAP
>         printk(KERN_DEBUG "free_area_init_node: node %d, pgdat %08lx, node_mem_map %08lx\n",
> 
> I think it's safe to move init_zone_allows_reclaim, because I don't
> think any allocates are occurring here that could cause us to reclaim
> anyways, right? Moving it allows us to safely reference
> node_present_pages.
> 

Yeah, this is fine.
