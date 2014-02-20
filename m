Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaBTJzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:55:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaBTJzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:55:37 -0500
Date: Thu, 20 Feb 2014 10:55:34 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Anton Blanchard <anton@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ppc: RECLAIM_DISTANCE 10?
Message-ID: <20140220095534.GC12451@dhcp22.suse.cz>
References: <20140218090658.GA28130@dhcp22.suse.cz>
 <20140218233404.GB10844@linux.vnet.ibm.com>
 <20140218235800.GC10844@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402181737530.17521@chino.kir.corp.google.com>
 <20140219162438.GB27108@linux.vnet.ibm.com>
 <20140219163345.GD27108@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219163345.GD27108@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-02-14 08:33:45, Nishanth Aravamudan wrote:
> On 19.02.2014 [08:24:38 -0800], Nishanth Aravamudan wrote:
> > On 18.02.2014 [17:43:38 -0800], David Rientjes wrote:
> > > On Tue, 18 Feb 2014, Nishanth Aravamudan wrote:
> > > 
> > > > How about the following?
> > > > 
> > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > index 5de4337..1a0eced 100644
> > > > --- a/mm/page_alloc.c
> > > > +++ b/mm/page_alloc.c
> > > > @@ -1854,7 +1854,8 @@ static void __paginginit init_zone_allows_reclaim(int nid)
> > > >         int i;
> > > >  
> > > >         for_each_online_node(i)
> > > > -               if (node_distance(nid, i) <= RECLAIM_DISTANCE)
> > > > +               if (node_distance(nid, i) <= RECLAIM_DISTANCE ||
> > > > +                                       !NODE_DATA(i)->node_present_pages)
> > > >                         node_set(i, NODE_DATA(nid)->reclaim_nodes);
> > > >                 else
> > > >                         zone_reclaim_mode = 1;
> > > 
> > >  [ I changed the above from NODE_DATA(nid) -> NODE_DATA(i) as you caught 
> > >    so we're looking at the right code. ]
> > > 
> > > That can't be right, it would allow reclaiming from a memoryless node.  I 
> > > think what you want is
> > 
> > Gah, you're right.
> > 
> > > 	for_each_online_node(i) {
> > > 		if (!node_present_pages(i))
> > > 			continue;
> > > 		if (node_distance(nid, i) <= RECLAIM_DISTANCE) {
> > > 			node_set(i, NODE_DATA(nid)->reclaim_nodes);
> > > 			continue;
> > > 		}
> > > 		/* Always try to reclaim locally */
> > > 		zone_reclaim_mode = 1;
> > > 	}
> > > 
> > > but we really should be able to do for_each_node_state(i, N_MEMORY) here 
> > > and memoryless nodes should already be excluded from that mask.
> > 
> > Yep, I found that afterwards, which simplifies the logic. I'll add this
> > to my series :)
> 
> In looking at the code, I am wondering about the following:
> 
> init_zone_allows_reclaim() is called for each nid from
> free_area_init_node(). Which means that calculate_node_totalpages for
> other "later" nids and check_for_memory() [which sets up the N_MEMORY
> nodemask] hasn't been called yet.
> 
> So, would it make sense to pull up the
>                 /* Any memory on that node */
>                 if (pgdat->node_present_pages)
>                         node_set_state(nid, N_MEMORY);
>                 check_for_memory(pgdat, nid);
> into free_area_init_node()?

Dunno, but it shouldn't be needed because nodes are set N_MEMORY earlier
in early_calculate_totalpages as mentioned in other email.

-- 
Michal Hocko
SUSE Labs
