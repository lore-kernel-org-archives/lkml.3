Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3CUM7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:59:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab3CUM7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:59:41 -0400
Date: Thu, 21 Mar 2013 13:59:39 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd
 reclaims at each priority
Message-ID: <20130321125939.GK6094@dhcp22.suse.cz>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-2-git-send-email-mgorman@suse.de>
 <20130320161847.GD27375@dhcp22.suse.cz>
 <20130321094713.GD1878@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321094713.GD1878@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-03-13 09:47:13, Mel Gorman wrote:
> On Wed, Mar 20, 2013 at 05:18:47PM +0100, Michal Hocko wrote:
> > On Sun 17-03-13 13:04:07, Mel Gorman wrote:
> > [...]
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 88c5fed..4835a7a 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -2593,6 +2593,32 @@ static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order, long remaining,
> > >  }
> > >  
> > >  /*
> > > + * kswapd shrinks the zone by the number of pages required to reach
> > > + * the high watermark.
> > > + */
> > > +static void kswapd_shrink_zone(struct zone *zone,
> > > +			       struct scan_control *sc,
> > > +			       unsigned long lru_pages)
> > > +{
> > > +	unsigned long nr_slab;
> > > +	struct reclaim_state *reclaim_state = current->reclaim_state;
> > > +	struct shrink_control shrink = {
> > > +		.gfp_mask = sc->gfp_mask,
> > > +	};
> > > +
> > > +	/* Reclaim above the high watermark. */
> > > +	sc->nr_to_reclaim = max(SWAP_CLUSTER_MAX, high_wmark_pages(zone));
> > 
> > OK, so the cap is at high watermark which sounds OK to me, although I
> > would expect balance_gap being considered here. Is it not used
> > intentionally or you just wanted to have a reasonable upper bound?
> > 
> 
> It's intentional. The balance_gap is taken into account before the
> decision to shrink but not afterwards. As the watermark check after
> shrinking is based on just the high watermark, I decided to have
> shrink_zone reclaim on that basis.

OK, it makes sense. Thanks both you and Rik for clarification.

-- 
Michal Hocko
SUSE Labs
