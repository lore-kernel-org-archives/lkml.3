Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936705Ab3DJN5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:57:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760323Ab3DJN5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:57:18 -0400
Date: Wed, 10 Apr 2013 14:57:13 +0100
From: Mel Gorman <mgorman@suse.de>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] mm: vmscan: Decide whether to compact the pgdat
 based on reclaim progress
Message-ID: <20130410135713.GB3710@suse.de>
References: <1365505625-9460-1-git-send-email-mgorman@suse.de>
 <1365505625-9460-5-git-send-email-mgorman@suse.de>
 <51651D3A.4000301@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <51651D3A.4000301@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 05:05:14PM +0900, Kamezawa Hiroyuki wrote:
> (2013/04/09 20:06), Mel Gorman wrote:
> > In the past, kswapd makes a decision on whether to compact memory after the
> > pgdat was considered balanced. This more or less worked but it is late to
> > make such a decision and does not fit well now that kswapd makes a decision
> > whether to exit the zone scanning loop depending on reclaim progress.
> > 
> > This patch will compact a pgdat if at least the requested number of pages
> > were reclaimed from unbalanced zones for a given priority. If any zone is
> > currently balanced, kswapd will not call compaction as it is expected the
> > necessary pages are already available.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> I like this way.
> 

Thanks
> > <SNIP>
> > @@ -2873,42 +2895,20 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
> >   		if (try_to_freeze() || kthread_should_stop())
> >   			break;
> >   
> > +		/* Compact if necessary and kswapd is reclaiming efficiently */
> > +		this_reclaimed = sc.nr_reclaimed - nr_reclaimed;
> > +		if (pgdat_needs_compaction && this_reclaimed > nr_attempted)
> > +			compact_pgdat(pgdat, order);
> > +
> 
> What does "this_reclaimed" mean ?   
> "the total amount of reclaimed memory - reclaimed memory at this iteration" ?
> 

It's meant to be "reclaimed memory at this iteration" but I made a merge
error when I decided to reset sc.nr_reclaimed to 0 on every loop in the patch
"mm: vmscan: Flatten kswapd priority loop". Once I did that, nr_reclaimed
became redundant and should have been removed. I've done that now.

> And this_reclaimed > nr_attempted means kswapd is efficient ?
> What "efficient" means here ?
> 

Reclaim efficiency is normally the ratio between pages scanned and pages
reclaimed. Ideally, every page scanned is reclaimed. In this case, being
efficient means that we reclaimed at least the number of pages requested
which is sc->nr_to_reclaim which in the case of kswapd is the high
watermark. I changed the comment to

                /*
                 * Compact if necessary and kswapd is reclaiming at least the
                 * high watermark number of pages as requested
                 */

-- 
Mel Gorman
SUSE Labs
