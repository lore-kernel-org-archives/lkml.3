Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3DKKBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 06:01:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab3DKKBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:01:19 -0400
Date: Thu, 11 Apr 2013 11:01:15 +0100
From: Mel Gorman <mgorman@suse.de>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] mm: vmscan: Have kswapd shrink slab only once per
 priority
Message-ID: <20130411100115.GJ3710@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-9-git-send-email-mgorman@suse.de>
 <20130409065325.GA4411@lge.com>
 <20130409111358.GB2002@suse.de>
 <20130410052142.GB5872@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130410052142.GB5872@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 02:21:42PM +0900, Joonsoo Kim wrote:
> > > > @@ -2673,9 +2674,15 @@ static bool kswapd_shrink_zone(struct zone *zone,
> > > >  	sc->nr_to_reclaim = max(SWAP_CLUSTER_MAX, high_wmark_pages(zone));
> > > >  	shrink_zone(zone, sc);
> > > >  
> > > > -	reclaim_state->reclaimed_slab = 0;
> > > > -	nr_slab = shrink_slab(&shrink, sc->nr_scanned, lru_pages);
> > > > -	sc->nr_reclaimed += reclaim_state->reclaimed_slab;
> > > > +	/*
> > > > +	 * Slabs are shrunk for each zone once per priority or if the zone
> > > > +	 * being balanced is otherwise unreclaimable
> > > > +	 */
> > > > +	if (shrinking_slab || !zone_reclaimable(zone)) {
> > > > +		reclaim_state->reclaimed_slab = 0;
> > > > +		nr_slab = shrink_slab(&shrink, sc->nr_scanned, lru_pages);
> > > > +		sc->nr_reclaimed += reclaim_state->reclaimed_slab;
> > > > +	}
> > > >  
> > > >  	if (nr_slab == 0 && !zone_reclaimable(zone))
> > > >  		zone->all_unreclaimable = 1;
> > > 
> > > Why shrink_slab() is called here?
> > 
> > Preserves existing behaviour.
> 
> Yes, but, with this patch, existing behaviour is changed, that is, we call
> shrink_slab() once per priority. For now, there is no reason this function
> is called here. How about separating it and executing it outside of
> zone loop?
> 

We are calling it fewer times but it's still receiving the same information
from sc->nr_scanned it received before. With the change you are suggesting
it would be necessary to accumulating sc->nr_scanned for each zone shrunk
and then pass the sum to shrink_slab() once per priority. While this is not
necessarily wrong, there is little or no motivation to alter the shrinkers
in this manner in this series.

-- 
Mel Gorman
SUSE Labs
