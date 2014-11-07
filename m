Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaKGQ2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:28:00 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:58557 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaKGQ15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:27:57 -0500
Date: Fri, 7 Nov 2014 11:27:38 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Dave Chinner <david@fromorbit.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc patch] mm: vmscan: invoke slab shrinkers for each lruvec
Message-ID: <20141107162738.GA22732@phnom.home.cmpxchg.org>
References: <1415317828-19390-1-git-send-email-hannes@cmpxchg.org>
 <20141107091811.GH4839@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107091811.GH4839@esperanza>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 12:18:11PM +0300, Vladimir Davydov wrote:
> On Thu, Nov 06, 2014 at 06:50:28PM -0500, Johannes Weiner wrote:
> [...]
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index a384339bf718..6a9ab5adf118 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> [...]
> > @@ -1876,7 +1872,8 @@ enum scan_balance {
> >   * nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
> >   */
> >  static void get_scan_count(struct lruvec *lruvec, int swappiness,
> > -			   struct scan_control *sc, unsigned long *nr)
> > +			   struct scan_control *sc, unsigned long *nr,
> > +			   unsigned long *lru_pages)
> >  {
> >  	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
> >  	u64 fraction[2];
> > @@ -2022,39 +2019,34 @@ out:
> >  	some_scanned = false;
> >  	/* Only use force_scan on second pass. */
> >  	for (pass = 0; !some_scanned && pass < 2; pass++) {
> > +		*lru_pages = 0;
> >  		for_each_evictable_lru(lru) {
> >  			int file = is_file_lru(lru);
> >  			unsigned long size;
> >  			unsigned long scan;
> >  
> > +			/* Scan one type exclusively */
> > +			if ((scan_balance == SCAN_FILE) != file) {
> > +				nr[lru] = 0;
> > +				continue;
> > +			}
> > +
> 
> Why do you move this piece of code? AFAIU, we only want to accumulate
> the total number of evictable pages on the lruvec, so the patch for
> shrink_lruvec should look much simpler. Is it a kind of cleanup? If so,
> I guess it'd be better to submit it separately.

Yes, it started out as a separate patch to make the setting of
*lru_pages more readable.

> Anyways, this hunk doesn't look right to me. With it applied, if
> scan_balance equals SCAN_EQUAL or SCAN_FRACT we won't scan file lists at
> all.

Urgh, brain fart.  I reverted back to the original switch, it should
be readable enough.

> > @@ -2173,6 +2172,23 @@ static void shrink_lruvec(struct lruvec *lruvec, int swappiness,
> >  	sc->nr_reclaimed += nr_reclaimed;
> >  
> >  	/*
> > +	 * Shrink slab caches in the same proportion that the eligible
> > +	 * LRU pages were scanned.
> > +	 *
> > +	 * XXX: Skip memcg limit reclaim, as the slab shrinkers are
> > +	 * not cgroup-aware yet and we can't know if the objects in
> > +	 * the global lists contribute to the memcg limit.
> > +	 */
> > +	if (global_reclaim(sc) && lru_pages) {
> > +		nr_scanned = sc->nr_scanned - nr_scanned;
> > +		shrink_slab(&shrink, nr_scanned, lru_pages);
> 
> I've a few concerns about slab-vs-pagecache reclaim proportion:

Well, hopefully! :-)

> If a node has > 1 zones, then we will scan slabs more aggressively than
> lru pages. Not sure, if it really matters, because on x86_64 most nodes
> have 1 zone.

It shouldn't be a big problem, but it is also fairly easy to fix.  We
can safely assume that most slab objects are allocated without any
zone restrictions (except that they have to be lowmem), so the aging
pressure of the Normal zone should be the most suitable to translate
to the slab objects as well.  Thus, we should shrink slabs only when
scanning the LRU pages of the Normal zone.

> If there are > 1 nodes, NUMA-unaware shrinkers will get more pressure
> than NUMA-aware ones. However, we have the same behavior in kswapd at
> present. This might be an issue if there are many nodes.

There is nothing we can do about this.  Kswapd does the majority of
reclaim, and by its nature has a per-node view.  We can't provide a
bigger granularity than that.

> If there are > 1 memory cgroups, slab shrinkers will get significantly
> more pressure on global reclaim than they should. The introduction of
> memcg-aware shrinkers will help, but only for memcg-aware shrinkers.
> Other shrinkers (if there are any) will be treated unfairly. I think for
> memcg-unaware shrinkers (i.e. for all shrinkers right now) we should
> pass lru_pages=zone_reclaimable_pages.

Agreed, we need separate entry points for cgroup-aware and
cgroup-unaware shrinkers.  I'm putting the node shrinker into
shrink_zone() for now, which will later remain memcg-unaware.

The memcg one you can later add in shrink_lruvec(), along with a
filter that skips over memcg-aware shrinkers on the node-level.

I'm propagating the pages that get_scan_count() considers up to
shrink_zone(), so they are available to you in shrink_lruvec().

> BTW, may be we'd better pass the scan priority for shrink_slab to
> calculate the pressure instead of messing with nr_scanned/lru_pages?

The scan goal itself is lru_pages >> priority, so the priority level
is already encoded in the nr_scanned / lru_pages ratio.

> > +		if (reclaim_state) {
> > +			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
> > +			reclaim_state->reclaimed_slab = 0;
> > +		}
> 
> OFF TOPIC: I wonder why we need the reclaim_state. The main shrink
> candidates, dentries and inodes, are mostly freed by RCU, so they won't
> count there.

Good point.  I'll make a note of it, but might defer it in this
series.

Thanks!
