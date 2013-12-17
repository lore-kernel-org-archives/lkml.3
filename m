Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3LQPil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:38:41 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:50245 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345Ab3LQPij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:38:39 -0500
Date: Tue, 17 Dec 2013 10:38:29 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] mm: page_alloc: Use zone node IDs to approximate
 locality
Message-ID: <20131217153829.GC21724@cmpxchg.org>
References: <1386943807-29601-1-git-send-email-mgorman@suse.de>
 <1386943807-29601-4-git-send-email-mgorman@suse.de>
 <20131216202507.GZ21724@cmpxchg.org>
 <20131217111352.GZ11295@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217111352.GZ11295@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:13:52AM +0000, Mel Gorman wrote:
> On Mon, Dec 16, 2013 at 03:25:07PM -0500, Johannes Weiner wrote:
> > On Fri, Dec 13, 2013 at 02:10:03PM +0000, Mel Gorman wrote:
> > > zone_local is using node_distance which is a more expensive call than
> > > necessary. On x86, it's another function call in the allocator fast path
> > > and increases cache footprint. This patch makes the assumption zones on a
> > > local node will share the same node ID. The necessary information should
> > > already be cache hot.
> > > 
> > > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > > ---
> > >  mm/page_alloc.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 64020eb..fd9677e 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -1816,7 +1816,7 @@ static void zlc_clear_zones_full(struct zonelist *zonelist)
> > >  
> > >  static bool zone_local(struct zone *local_zone, struct zone *zone)
> > >  {
> > > -	return node_distance(local_zone->node, zone->node) == LOCAL_DISTANCE;
> > > +	return zone_to_nid(zone) == numa_node_id();
> > 
> > Why numa_node_id()?  We pass in the preferred zone as @local_zone:
> > 
> 
> Initially because I was thinking "local node" and numa_node_id() is a
> per-cpu variable that should be cheap to access and in some cases
> cache-hot as the top-level gfp API calls numa_node_id().
> 
> Thinking about it more though it still makes sense because the preferred
> zone is not necessarily local. If the allocation request requires ZONE_DMA32
> and the local node does not have that zone then preferred zone is on a
> remote node.

Don't we treat everything in relation to the preferred zone?
zone_reclaim_mode itself does not compare with numa_node_id() but with
whatever is the preferred zone.

I could see some value in changing that to numa_node_id(), but then
zone_local() and zone_allows_reclaim() should probably both switch.
