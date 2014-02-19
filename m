Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaBSSAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:00:15 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55257 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbaBSSAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:00:12 -0500
Date: Wed, 19 Feb 2014 08:26:04 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: ppc: RECLAIM_DISTANCE 10?
Message-ID: <20140219162604.GC27108@linux.vnet.ibm.com>
References: <20140218090658.GA28130@dhcp22.suse.cz>
 <20140218233404.GB10844@linux.vnet.ibm.com>
 <20140219082313.GB14783@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219082313.GB14783@dhcp22.suse.cz>
X-Operating-System: Linux 3.11.0-15-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021918-0320-0000-0000-000002801700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.02.2014 [09:23:13 +0100], Michal Hocko wrote:
> On Tue 18-02-14 15:34:05, Nishanth Aravamudan wrote:
> > Hi Michal,
> > 
> > On 18.02.2014 [10:06:58 +0100], Michal Hocko wrote:
> > > Hi,
> > > I have just noticed that ppc has RECLAIM_DISTANCE reduced to 10 set by
> > > 56608209d34b (powerpc/numa: Set a smaller value for RECLAIM_DISTANCE to
> > > enable zone reclaim). The commit message suggests that the zone reclaim
> > > is desirable for all NUMA configurations.
> > > 
> > > History has shown that the zone reclaim is more often harmful than
> > > helpful and leads to performance problems. The default RECLAIM_DISTANCE
> > > for generic case has been increased from 20 to 30 around 3.0
> > > (32e45ff43eaf mm: increase RECLAIM_DISTANCE to 30).
> > 
> > Interesting.
> > 
> > > I strongly suspect that the patch is incorrect and it should be
> > > reverted. Before I will send a revert I would like to understand what
> > > led to the patch in the first place. I do not see why would PPC use only
> > > LOCAL_DISTANCE and REMOTE_DISTANCE distances and in fact machines I have
> > > seen use different values.
> > > 
> > > Anton, could you comment please?
> > 
> > I'll let Anton comment here, but in looking into this issue in working
> > on CONFIG_HAVE_MEMORYLESS_NODE support, I realized that any LPAR with
> > memoryless nodes will set zone_reclaim_mode to 1. I think we want to
> > ignore memoryless nodes when we set up the reclaim mode like the
> > following? I'll send it as a proper patch if you agree?
> 
> Funny enough, ppc memoryless node setup is what led me to this code.
> We had a setup like this:
> node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
> node 0 size: 0 MB
> node 0 free: 0 MB
> node 2 cpus:
> node 2 size: 7168 MB
> node 2 free: 6019 MB
> node distances:
> node   0   2
> 0:  10  40
> 2:  40  10

Yeah, I think this happens fairly often ... and we didn't properly
support it (particularly with SLUB) on powerpc. I'll cc you on my
patchset.

> Which ends up enabling zone_reclaim although there is only a single node
> with memory. Not that RECLAIM_DISTANCE would make any difference here as
> the distance is even above default RECLAIM_DISTANCE.
> 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 5de4337..4f6ff6f 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1853,8 +1853,9 @@ static void __paginginit init_zone_allows_reclaim(int nid)
> >  {
> >         int i;
> >  
> > -       for_each_online_node(i)
> > -               if (node_distance(nid, i) <= RECLAIM_DISTANCE)
> > +       for_each_online_node(i) {
> > +               if (node_distance(nid, i) <= RECLAIM_DISTANCE ||
> > +                                       local_memory_node(nid) != nid)
> >                         node_set(i, NODE_DATA(nid)->reclaim_nodes);
> >                 else
> >                         zone_reclaim_mode = 1;
> > 
> > Note, this won't actually do anything if CONFIG_HAVE_MEMORYLESS_NODES is
> > not set, but if it is, I think semantically it will indicate that
> > memoryless nodes *have* to reclaim remotely.
> > 
> > And actually the above won't work, because the callpath is
> > 
> > start_kernel -> setup_arch -> paging_init [-> free_area_init_nodes ->
> > free_area_init_node -> init_zone_allows_reclaim] which is called before
> > build_all_zonelists. This is a similar ordering problem as I'm having
> > with the MEMORYLESS_NODE support, will work on it.
> 
> I think you just want for_each_node_state(nid, N_MEMORY) and skip all
> the memory less nodes, no?

Yep, thanks!
-Nish

