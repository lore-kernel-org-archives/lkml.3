Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaBKHMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:12:31 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51324 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaBKHM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:12:28 -0500
X-AuditID: 9c93016f-b7c65ae000004a2a-a3-52f9cd596382
Date: Tue, 11 Feb 2014 16:12:25 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] mm/compaction: disallow high-order page for
 migration target
Message-ID: <20140211071225.GA27870@lge.com>
References: <1391749726-28910-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1391749726-28910-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20140210132634.GE6732@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210132634.GE6732@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 01:26:34PM +0000, Mel Gorman wrote:
> On Fri, Feb 07, 2014 at 02:08:42PM +0900, Joonsoo Kim wrote:
> > Purpose of compaction is to get a high order page. Currently, if we find
> > high-order page while searching migration target page, we break it to
> > order-0 pages and use them as migration target. It is contrary to purpose
> > of compaction, so disallow high-order page to be used for
> > migration target.
> > 
> > Additionally, clean-up logic in suitable_migration_target() to simply.
> > There is no functional changes from this clean-up.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > 
> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index 3a91a2e..bbe1260 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -217,21 +217,12 @@ static inline bool compact_trylock_irqsave(spinlock_t *lock,
> >  /* Returns true if the page is within a block suitable for migration to */
> >  static bool suitable_migration_target(struct page *page)
> >  {
> > -	int migratetype = get_pageblock_migratetype(page);
> > -
> > -	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
> > -	if (migratetype == MIGRATE_RESERVE)
> > -		return false;
> > -
> 
> Why is this check removed? The reservation blocks are preserved as
> short-lived high-order atomic allocations depend on them.

Hello,

After disallowing high-order page to be used for migration target,
we only allow pages from movable or CMA pageblock for migration target on
migrate_async_suitable() check. So checking whether page comes from reserve or
isolate pageblock is useless.

> 
> > -	if (is_migrate_isolate(migratetype))
> > -		return false;
> > -
> 
> Why is this check removed?
> 
> > -	/* If the page is a large free page, then allow migration */
> > +	/* If the page is a large free page, then disallow migration */
> >  	if (PageBuddy(page) && page_order(page) >= pageblock_order)
> > -		return true;
> > +		return false;
> >  
> 
> The reason why this was originally allowed was to allow pageblocks that were
> marked MIGRATE_UNMOVABLE or MIGRATE_RECLAIMABLE to be used as compaction
> targets. However, compaction should not even be running if this is the
> case so the change makes sense.

Okay!

Thanks.
