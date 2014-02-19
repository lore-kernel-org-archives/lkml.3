Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaBSXGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 18:06:09 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:57228 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaBSXGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 18:06:07 -0500
Date: Wed, 19 Feb 2014 15:05:58 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] mm: exclude memory less nodes from zone_reclaim
Message-ID: <20140219230558.GA28062@linux.vnet.ibm.com>
References: <20140219082313.GB14783@dhcp22.suse.cz>
 <1392829383-4125-1-git-send-email-mhocko@suse.cz>
 <20140219175339.GG27108@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402191353540.31921@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402191353540.31921@chino.kir.corp.google.com>
X-Operating-System: Linux 3.11.0-15-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021923-7164-0000-0000-0000063BD107
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.02.2014 [13:56:00 -0800], David Rientjes wrote:
> On Wed, 19 Feb 2014, Nishanth Aravamudan wrote:
> 
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 3e953f07edb0..4a44bdc7a8cf 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -1855,7 +1855,7 @@ static void __paginginit init_zone_allows_reclaim(int nid)
> > >  {
> > >  	int i;
> > > 
> > > -	for_each_online_node(i)
> > > +	for_each_node_state(i, N_HIGH_MEMORY)
> > >  		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
> > >  			node_set(i, NODE_DATA(nid)->reclaim_nodes);
> > >  		else
> > > @@ -4901,7 +4901,8 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
> > > 
> > >  	pgdat->node_id = nid;
> > >  	pgdat->node_start_pfn = node_start_pfn;
> > > -	init_zone_allows_reclaim(nid);
> > > +	if (node_state(nid, N_HIGH_MEMORY))
> > > +		init_zone_allows_reclaim(nid);
> > 
> > I'm still new to this code, but isn't this saying that if a node has no
> > memory, then it shouldn't reclaim from any node? But, for a memoryless
> > node to ensure progress later if reclaim is necessary, it *must* reclaim
> > from other nodes? So wouldn't we want to set reclaim_nodes() in that
> > case to node_states[N_MEMORY]?
> > 
> 
> The only time when pgdat->reclaim_nodes or zone_reclaim_mode matters is 
> when iterating through a zonelist for page allocation and a memoryless 
> node should never appear in a zonelist for page allocation, so this is 
> just preventing setting zone_reclaim_mode unnecessarily because the only 
> nodes with > RECLAIM_DISTANCE to another node are memoryless.  So this 
> patch is fine as long as it gets s/N_HIGH_MEMORY/N_MEMORY/.

Ah yes, sorry, I've been looking at this code perhaps too much and going
a bit cross-eyed!

I wonder if we should also put some comments in? But

Acked-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Tested-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

Thanks,
Nish

