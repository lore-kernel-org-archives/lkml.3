Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaBSSur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:50:47 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60117 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbaBSSuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:50:46 -0500
Date: Wed, 19 Feb 2014 08:24:38 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Anton Blanchard <anton@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ppc: RECLAIM_DISTANCE 10?
Message-ID: <20140219162438.GB27108@linux.vnet.ibm.com>
References: <20140218090658.GA28130@dhcp22.suse.cz>
 <20140218233404.GB10844@linux.vnet.ibm.com>
 <20140218235800.GC10844@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402181737530.17521@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402181737530.17521@chino.kir.corp.google.com>
X-Operating-System: Linux 3.11.0-15-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021918-5806-0000-0000-0000242B69CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.02.2014 [17:43:38 -0800], David Rientjes wrote:
> On Tue, 18 Feb 2014, Nishanth Aravamudan wrote:
> 
> > How about the following?
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 5de4337..1a0eced 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1854,7 +1854,8 @@ static void __paginginit init_zone_allows_reclaim(int nid)
> >         int i;
> >  
> >         for_each_online_node(i)
> > -               if (node_distance(nid, i) <= RECLAIM_DISTANCE)
> > +               if (node_distance(nid, i) <= RECLAIM_DISTANCE ||
> > +                                       !NODE_DATA(i)->node_present_pages)
> >                         node_set(i, NODE_DATA(nid)->reclaim_nodes);
> >                 else
> >                         zone_reclaim_mode = 1;
> 
>  [ I changed the above from NODE_DATA(nid) -> NODE_DATA(i) as you caught 
>    so we're looking at the right code. ]
> 
> That can't be right, it would allow reclaiming from a memoryless node.  I 
> think what you want is

Gah, you're right.

> 	for_each_online_node(i) {
> 		if (!node_present_pages(i))
> 			continue;
> 		if (node_distance(nid, i) <= RECLAIM_DISTANCE) {
> 			node_set(i, NODE_DATA(nid)->reclaim_nodes);
> 			continue;
> 		}
> 		/* Always try to reclaim locally */
> 		zone_reclaim_mode = 1;
> 	}
> 
> but we really should be able to do for_each_node_state(i, N_MEMORY) here 
> and memoryless nodes should already be excluded from that mask.

Yep, I found that afterwards, which simplifies the logic. I'll add this
to my series :)

<snip>

> > I think it's safe to move init_zone_allows_reclaim, because I don't
> > think any allocates are occurring here that could cause us to reclaim
> > anyways, right? Moving it allows us to safely reference
> > node_present_pages.
> > 
> 
> Yeah, this is fine.

Thanks,
Nish

