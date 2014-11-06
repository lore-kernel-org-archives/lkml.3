Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaKFPmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:42:24 -0500
Received: from mx2.parallels.com ([199.115.105.18]:36176 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaKFPmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:42:23 -0500
Date: Thu, 6 Nov 2014 18:42:04 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm v2 3/9] vmscan: shrink slab on memcg pressure
Message-ID: <20141106154204.GG4839@esperanza>
References: <cover.1414145862.git.vdavydov@parallels.com>
 <68df6349e5cecdf8b2950e8eb2c27965163a110b.1414145863.git.vdavydov@parallels.com>
 <20141106152135.GA17628@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141106152135.GA17628@phnom.home.cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On Thu, Nov 06, 2014 at 10:21:35AM -0500, Johannes Weiner wrote:
> On Fri, Oct 24, 2014 at 02:37:34PM +0400, Vladimir Davydov wrote:
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index a384339bf718..2cf6b04a4e0c 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -339,6 +339,26 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
> >  	return freed;
> >  }
> >  
> > +static unsigned long
> > +run_shrinker(struct shrink_control *shrinkctl, struct shrinker *shrinker,
> > +	     unsigned long nr_pages_scanned, unsigned long lru_pages)
> > +{
> > +	unsigned long freed = 0;
> > +
> > +	if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
> > +		shrinkctl->nid = 0;
> > +		return shrink_slab_node(shrinkctl, shrinker,
> > +					nr_pages_scanned, lru_pages);
> > +	}
> > +
> > +	for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
> > +		if (node_online(shrinkctl->nid))
> > +			freed += shrink_slab_node(shrinkctl, shrinker,
> > +						  nr_pages_scanned, lru_pages);
> > +	}
> > +	return freed;
> > +}
> 
> The slab shrinking logic accumulates the lru pages, as well as the
> nodes_to_scan mask, when going over the zones, only to go over the
> zones here again using the accumulated node information.  Why not just
> invoke the thing per-zone instead in the first place?  Kswapd already
> does that (although it could probably work with the per-zone lru_pages
> and nr_scanned deltas) and direct reclaim should as well.  It would
> simplify the existing code as well as your series a lot.

100% agree. Yet another argument for invoking shrinkers per-zone is soft
(or low?) memory limit reclaim (when it's fixed/rewritten): the current
code would shrink slab of all memory cgroups even if only those that
exceeded the limit were scanned - unfair.

> 
> > +		/*
> > +		 * For memcg-aware shrinkers iterate over the target memcg
> > +		 * hierarchy and run the shrinker on each kmem-active memcg
> > +		 * found in the hierarchy.
> > +		 */
> > +		shrinkctl->memcg = shrinkctl->target_mem_cgroup;
> > +		do {
> > +			if (!shrinkctl->memcg ||
> > +			    memcg_kmem_is_active(shrinkctl->memcg))
> > +				freed += run_shrinker(shrinkctl, shrinker,
> >  						nr_pages_scanned, lru_pages);
> > -
> > -		}
> > +		} while ((shrinkctl->memcg =
> > +			  mem_cgroup_iter(shrinkctl->target_mem_cgroup,
> > +					  shrinkctl->memcg, NULL)) != NULL);
> 
> More symptoms of the above.  This hierarchy walk is duplicative and
> potentially quite expensive.
> 
> > @@ -2381,6 +2414,7 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
> >  	gfp_t orig_mask;
> >  	struct shrink_control shrink = {
> >  		.gfp_mask = sc->gfp_mask,
> > +		.target_mem_cgroup = sc->target_mem_cgroup,
> >  	};
> >  	enum zone_type requested_highidx = gfp_zone(sc->gfp_mask);
> >  	bool reclaimable = false;
> > @@ -2400,18 +2434,22 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
> >  					gfp_zone(sc->gfp_mask), sc->nodemask) {
> >  		if (!populated_zone(zone))
> >  			continue;
> > +
> > +		if (global_reclaim(sc) &&
> > +		    !cpuset_zone_allowed(zone, GFP_KERNEL | __GFP_HARDWALL))
> > +			continue;
> > +
> > +		lru_pages += global_reclaim(sc) ?
> > +				zone_reclaimable_pages(zone) :
> > +				mem_cgroup_zone_reclaimable_pages(zone,
> > +						sc->target_mem_cgroup);
> > +		node_set(zone_to_nid(zone), shrink.nodes_to_scan);
> 
> And yet another costly hierarchy walk.
> 
> The reclaim code walks zonelists according to a nodemask, and within
> each zone it walks lruvecs according to the memcg hierarchy.  The
> shrinkers are wrong in making up an ad-hoc concept of NUMA nodes that
> otherwise does not exist anywhere in the VM.  Please integrate them
> properly instead of adding more duplication on top.

Will do.

Thanks,
Vladimir
