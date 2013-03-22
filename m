Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3CVHyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 03:54:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab3CVHya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 03:54:30 -0400
Date: Fri, 22 Mar 2013 08:54:27 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] mm: vmscan: Obey proportional scanning
 requirements for kswapd
Message-ID: <20130322075413.GA31457@dhcp22.suse.cz>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-3-git-send-email-mgorman@suse.de>
 <20130321140154.GL6094@dhcp22.suse.cz>
 <20130321143114.GM2055@suse.de>
 <20130321150755.GN6094@dhcp22.suse.cz>
 <20130321153442.GJ1878@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321153442.GJ1878@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-03-13 15:34:42, Mel Gorman wrote:
> On Thu, Mar 21, 2013 at 04:07:55PM +0100, Michal Hocko wrote:
> > > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > > index 4835a7a..182ff15 100644
> > > > > --- a/mm/vmscan.c
> > > > > +++ b/mm/vmscan.c
> > > > > @@ -1815,6 +1815,45 @@ out:
> > > > >  	}
> > > > >  }
> > > > >  
> > > > > +static void recalculate_scan_count(unsigned long nr_reclaimed,
> > > > > +		unsigned long nr_to_reclaim,
> > > > > +		unsigned long nr[NR_LRU_LISTS])
> > > > > +{
> > > > > +	enum lru_list l;
> > > > > +
> > > > > +	/*
> > > > > +	 * For direct reclaim, reclaim the number of pages requested. Less
> > > > > +	 * care is taken to ensure that scanning for each LRU is properly
> > > > > +	 * proportional. This is unfortunate and is improper aging but
> > > > > +	 * minimises the amount of time a process is stalled.
> > > > > +	 */
> > > > > +	if (!current_is_kswapd()) {
> > > > > +		if (nr_reclaimed >= nr_to_reclaim) {
> > > > > +			for_each_evictable_lru(l)
> > > > > +				nr[l] = 0;
> > > > > +		}
> > > > > +		return;
> > > > 
> > > > Heh, this is nicely cryptically said what could be done in shrink_lruvec
> > > > as
> > > > 	if (!current_is_kswapd()) {
> > > > 		if (nr_reclaimed >= nr_to_reclaim)
> > > > 			break;
> > > > 	}
> > > > 
> > > 
> > > Pretty much. At one point during development, this function was more
> > > complex and it evolved into this without me rechecking if splitting it
> > > out still made sense.
> > > 
> > > > Besides that this is not memcg aware which I think it would break
> > > > targeted reclaim which is kind of direct reclaim but it still would be
> > > > good to stay proportional because it starts with DEF_PRIORITY.
> > > > 
> > > 
> > > This does break memcg because it's a special sort of direct reclaim.
> > > 
> > > > I would suggest moving this back to shrink_lruvec and update the test as
> > > > follows:
> > > 
> > > I also noticed that we check whether the scan counts need to be
> > > normalised more than once
> > 
> > I didn't mind this because it "disqualified" at least one LRU every
> > round which sounds reasonable to me because all LRUs would be scanned
> > proportionally.
> 
> Once the scan count for one LRU is 0 then min will always be 0 and no
> further adjustment is made. It's just redundant to check again.

Hmm, I was almost sure I wrote that min should be adjusted only if it is >0
in the first loop but it is not there...

So for real this time.
			for_each_evictable_lru(l)
				if (nr[l] && nr[l] < min)
					min = nr[l];

This should work, no? Everytime you shrink all LRUs you and you have
reclaimed enough already you get the smallest LRU out of game. This
should keep proportions evenly.
-- 
Michal Hocko
SUSE Labs
