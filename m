Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaBDACj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 19:02:39 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42838 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaBDACi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 19:02:38 -0500
X-Original-SENDERIP: 10.177.222.146
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 4 Feb 2014 09:02:37 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, compaction: avoid isolating pinned pages
Message-ID: <20140204000237.GA17331@lge.com>
References: <alpine.DEB.2.02.1402012145510.2593@chino.kir.corp.google.com>
 <20140203095329.GH6732@suse.de>
 <alpine.DEB.2.02.1402030231590.31061@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402030231590.31061@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 02:49:32AM -0800, David Rientjes wrote:
> On Mon, 3 Feb 2014, Mel Gorman wrote:
> 
> > > Page migration will fail for memory that is pinned in memory with, for
> > > example, get_user_pages().  In this case, it is unnecessary to take
> > > zone->lru_lock or isolating the page and passing it to page migration
> > > which will ultimately fail.
> > > 
> > > This is a racy check, the page can still change from under us, but in
> > > that case we'll just fail later when attempting to move the page.
> > > 
> > > This avoids very expensive memory compaction when faulting transparent
> > > hugepages after pinning a lot of memory with a Mellanox driver.
> > > 
> > > On a 128GB machine and pinning ~120GB of memory, before this patch we
> > > see the enormous disparity in the number of page migration failures
> > > because of the pinning (from /proc/vmstat):
> > > 
> > > compact_blocks_moved 7609
> > > compact_pages_moved 3431
> > > compact_pagemigrate_failed 133219
> > > compact_stall 13
> > > 
> > > After the patch, it is much more efficient:
> > > 
> > > compact_blocks_moved 7998
> > > compact_pages_moved 6403
> > > compact_pagemigrate_failed 3
> > > compact_stall 15
> > > 
> > > Signed-off-by: David Rientjes <rientjes@google.com>
> > > ---
> > >  mm/compaction.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/mm/compaction.c b/mm/compaction.c
> > > --- a/mm/compaction.c
> > > +++ b/mm/compaction.c
> > > @@ -578,6 +578,14 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
> > >  			continue;
> > >  		}
> > >  
> > > +		/*
> > > +		 * Migration will fail if an anonymous page is pinned in memory,
> > > +		 * so avoid taking zone->lru_lock and isolating it unnecessarily
> > > +		 * in an admittedly racy check.
> > > +		 */
> > > +		if (!page_mapping(page) && page_count(page))
> > > +			continue;
> > > +

Hello,

I think that you need more code to skip this type of page correctly.
Without page_mapped() check, this code makes migratable pages be skipped,
since if page_mapped() case, page_count() may be more than zero.

So I think that you need following change.

(!page_mapping(page) && !page_mapped(page) && page_count(page))

Thanks.
