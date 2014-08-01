Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbaHASw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:52:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbaHASwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:52:55 -0400
Date: Fri, 1 Aug 2014 20:52:51 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] memcg, vmscan: Fix forced scan of anonymous pages
Message-ID: <20140801185251.GA31417@dhcp22.suse.cz>
References: <1406807385-5168-1-git-send-email-jmarchan@redhat.com>
 <1406807385-5168-3-git-send-email-jmarchan@redhat.com>
 <20140731123026.GE13561@dhcp22.suse.cz>
 <20140801184525.GK9952@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801184525.GK9952@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 01-08-14 14:45:25, Johannes Weiner wrote:
> On Thu, Jul 31, 2014 at 02:30:26PM +0200, Michal Hocko wrote:
> > On Thu 31-07-14 13:49:45, Jerome Marchand wrote:
> > > @@ -1950,8 +1950,11 @@ static void get_scan_count(struct lruvec *lruvec, int swappiness,
> > >  	 */
> > >  	if (global_reclaim(sc)) {
> > >  		unsigned long free = zone_page_state(zone, NR_FREE_PAGES);
> > > +		unsigned long zonefile =
> > > +			zone_page_state(zone, NR_LRU_BASE + LRU_ACTIVE_FILE) +
> > > +			zone_page_state(zone, NR_LRU_BASE + LRU_INACTIVE_FILE);
> > >  
> > > -		if (unlikely(file + free <= high_wmark_pages(zone))) {
> > > +		if (unlikely(zonefile + free <= high_wmark_pages(zone))) {
> > >  			scan_balance = SCAN_ANON;
> > >  			goto out;
> > >  		}
> > 
> > You could move file and anon further down when we actually use them.
> 
> Agreed with that.  Can we merge this into the original patch?
> 
> ---
> From e49bef8d2751d9b27f1733e3e0eced325ffce700 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Fri, 1 Aug 2014 10:48:26 -0400
> Subject: [patch] memcg, vmscan: Fix forced scan of anonymous pages fix -
>  cleanups
> 
> o Use enum zone_stat_item symbols directly to select zone stats,
>   rather than NR_LRU_BASE plus LRU index
> 
> o scanned/rotated scaling is the only user of the lruvec anon/file
>   counters, so move the reads of those values to right before that
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Yes, please.
Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

> ---
>  mm/vmscan.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b3f629bdf4fe..2836b5373b2e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1934,11 +1934,6 @@ static void get_scan_count(struct lruvec *lruvec, int swappiness,
>  		goto out;
>  	}
>  
> -	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
> -		get_lru_size(lruvec, LRU_INACTIVE_ANON);
> -	file  = get_lru_size(lruvec, LRU_ACTIVE_FILE) +
> -		get_lru_size(lruvec, LRU_INACTIVE_FILE);
> -
>  	/*
>  	 * Prevent the reclaimer from falling into the cache trap: as
>  	 * cache pages start out inactive, every cache fault will tip
> @@ -1949,12 +1944,14 @@ static void get_scan_count(struct lruvec *lruvec, int swappiness,
>  	 * anon pages.  Try to detect this based on file LRU size.
>  	 */
>  	if (global_reclaim(sc)) {
> -		unsigned long free = zone_page_state(zone, NR_FREE_PAGES);
> -		unsigned long zonefile =
> -			zone_page_state(zone, NR_LRU_BASE + LRU_ACTIVE_FILE) +
> -			zone_page_state(zone, NR_LRU_BASE + LRU_INACTIVE_FILE);
> +		unsigned long zonefile;
> +		unsigned long zonefree;
> +
> +		zonefree = zone_page_state(zone, NR_FREE_PAGES);
> +		zonefile = zone_page_state(zone, NR_ACTIVE_FILE) +
> +			   zone_page_state(zone, NR_INACTIVE_FILE);
>  
> -		if (unlikely(zonefile + free <= high_wmark_pages(zone))) {
> +		if (unlikely(zonefile + zonefree <= high_wmark_pages(zone))) {
>  			scan_balance = SCAN_ANON;
>  			goto out;
>  		}
> @@ -1989,6 +1986,12 @@ static void get_scan_count(struct lruvec *lruvec, int swappiness,
>  	 *
>  	 * anon in [0], file in [1]
>  	 */
> +
> +	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
> +		get_lru_size(lruvec, LRU_INACTIVE_ANON);
> +	file  = get_lru_size(lruvec, LRU_ACTIVE_FILE) +
> +		get_lru_size(lruvec, LRU_INACTIVE_FILE);
> +
>  	spin_lock_irq(&zone->lru_lock);
>  	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
>  		reclaim_stat->recent_scanned[0] /= 2;
> -- 
> 2.0.3
> 

-- 
Michal Hocko
SUSE Labs
