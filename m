Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab3CUPrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:47:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab3CUPre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:47:34 -0400
Date: Thu, 21 Mar 2013 15:47:31 +0000
From: Mel Gorman <mgorman@suse.de>
To: Michal Hocko <mhocko@suse.cz>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] mm: vmscan: Decide whether to compact the pgdat
 based on reclaim progress
Message-ID: <20130321154730.GK1878@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-5-git-send-email-mgorman@suse.de>
 <20130321153231.GP6094@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130321153231.GP6094@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 04:32:31PM +0100, Michal Hocko wrote:
> On Sun 17-03-13 13:04:10, Mel Gorman wrote:
> > In the past, kswapd makes a decision on whether to compact memory after the
> > pgdat was considered balanced. This more or less worked but it is late to
> > make such a decision and does not fit well now that kswapd makes a decision
> > whether to exit the zone scanning loop depending on reclaim progress.
> > 
> > This patch will compact a pgdat if at least  the requested number of pages
> > were reclaimed from unbalanced zones for a given priority. If any zone is
> > currently balanced, kswapd will not call compaction as it is expected the
> > necessary pages are already available.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > ---
> >  mm/vmscan.c | 52 +++++++++++++++++++++-------------------------------
> >  1 file changed, 21 insertions(+), 31 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 279d0c2..7513bd1 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2694,8 +2694,11 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
> >  
> >  	do {
> >  		unsigned long lru_pages = 0;
> > +		unsigned long nr_to_reclaim = 0;
> >  		unsigned long nr_reclaimed = sc.nr_reclaimed;
> > +		unsigned long this_reclaimed;
> >  		bool raise_priority = true;
> > +		bool pgdat_needs_compaction = true;
> 
> I am confused. We don't want to compact for order == 0, do we?
> 

No, but an order check is made later which I felt it was clearer.  You are
the second person to bring it up so I'll base the initialisation on order.

-- 
Mel Gorman
SUSE Labs
