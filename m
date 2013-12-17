Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab3LQLN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:13:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab3LQLN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:13:56 -0500
Date: Tue, 17 Dec 2013 11:13:52 +0000
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] mm: page_alloc: Use zone node IDs to approximate
 locality
Message-ID: <20131217111352.GZ11295@suse.de>
References: <1386943807-29601-1-git-send-email-mgorman@suse.de>
 <1386943807-29601-4-git-send-email-mgorman@suse.de>
 <20131216202507.GZ21724@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131216202507.GZ21724@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 03:25:07PM -0500, Johannes Weiner wrote:
> On Fri, Dec 13, 2013 at 02:10:03PM +0000, Mel Gorman wrote:
> > zone_local is using node_distance which is a more expensive call than
> > necessary. On x86, it's another function call in the allocator fast path
> > and increases cache footprint. This patch makes the assumption zones on a
> > local node will share the same node ID. The necessary information should
> > already be cache hot.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > ---
> >  mm/page_alloc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 64020eb..fd9677e 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1816,7 +1816,7 @@ static void zlc_clear_zones_full(struct zonelist *zonelist)
> >  
> >  static bool zone_local(struct zone *local_zone, struct zone *zone)
> >  {
> > -	return node_distance(local_zone->node, zone->node) == LOCAL_DISTANCE;
> > +	return zone_to_nid(zone) == numa_node_id();
> 
> Why numa_node_id()?  We pass in the preferred zone as @local_zone:
> 

Initially because I was thinking "local node" and numa_node_id() is a
per-cpu variable that should be cheap to access and in some cases
cache-hot as the top-level gfp API calls numa_node_id().

Thinking about it more though it still makes sense because the preferred
zone is not necessarily local. If the allocation request requires ZONE_DMA32
and the local node does not have that zone then preferred zone is on a
remote node.

-- 
Mel Gorman
SUSE Labs
