Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaCYNsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 09:48:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42036 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaCYNsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 09:48:00 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-dd-533188f60206
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Yong-Taek Lee <ytk.lee@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_alloc: fix freeing of MIGRATE_RESERVE
 migratetype pages
Date: Tue, 25 Mar 2014 14:47:15 +0100
Message-id: <4172657.DtyuUtBQfn@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <532C49BF.8090001@suse.cz>
References: <3269714.29dGMiCR2L@amdc1032> <532C49BF.8090001@suse.cz>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t9jAd1vHYbBBm/XW1g8/dTHYnF51xw2
	i3tr/rNarD1yl91i8rtnjBazG/sYLR6v53Zg91iwqdRj06dJ7B59W1YxepxZcITdY/Ppao/P
	m+QC2KK4bFJSczLLUov07RK4Mtbu28xUsM+44tSPI6wNjI80uhg5OSQETCRmtP1lhLDFJC7c
	W8/WxcjFISSwiFHi/7Y57BBOC5PE82vNzCBVbAJWEhPbV4F1iAioSDzacJQVpIhZ4DSjxK2t
	X1hAEsICkRIbfs9kA7FZBFQljk/ZzgRi8wpoShz4dgKsWVTAU2LH9pVgNZwC6hL7e7aygthC
	Ai4SN1Z1sEPUC0r8mHwPbCazgLzEvv1TWSFsHYn9rdPYJjAKzEJSNgtJ2SwkZQsYmVcxiqYW
	JBcUJ6XnGukVJ+YWl+al6yXn525iBAf7M+kdjKsaLA4xCnAwKvHwbjA1CBZiTSwrrsw9xCjB
	wawkwpvVbhgsxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1Oq
	gVHtb5vPjDb+65t53d+GCj3y/2+fqbj2f5mwOsvjrWyrfnnb6Fu+nOASb/VWmX2qOvuE52tl
	ZW7+ln+7vD9vy/odmzft00ieFzet4r3t6mNLXua557FZr9UuOcvdd4ql0+vA3/Pa2vNK3fzT
	Z88xXm4velT6g5dUuYRh3XdWUV+elzHrKuNSLZRYijMSDbWYi4oTAc4iVfpyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday, March 21, 2014 03:16:31 PM Vlastimil Babka wrote:
> On 03/06/2014 06:35 PM, Bartlomiej Zolnierkiewicz wrote:
> > Pages allocated from MIGRATE_RESERVE migratetype pageblocks
> > are not freed back to MIGRATE_RESERVE migratetype free
> > lists in free_pcppages_bulk()->__free_one_page() if we got
> > to free_pcppages_bulk() through drain_[zone_]pages().
> > The freeing through free_hot_cold_page() is okay because
> > freepage migratetype is set to pageblock migratetype before
> > calling free_pcppages_bulk().
> 
> I think this is somewhat misleading and got me confused for a while. 
> It's not about the call path of free_pcppages_bulk(), but about the
> fact that rmqueue_bulk() has been called at some point to fill up the 
> pcp lists, and had to resort to __rmqueue_fallback(). So, going through 
> free_hot_cold_page() might give you correct migratetype for the last 
> page freed, but the pcp lists may still contain misplaced pages from 
> earlier rmqueue_bulk().

Ok, you're right.  I'll fix this.

> > If pages of MIGRATE_RESERVE
> > migratetype end up on the free lists of other migratetype
> > whole Reserved pageblock may be later changed to the other
> > migratetype in __rmqueue_fallback() and it will be never
> > changed back to be a Reserved pageblock.  Fix the issue by
> > moving freepage migratetype setting from rmqueue_bulk() to
> > __rmqueue[_fallback]() and preserving freepage migratetype
> > as an original pageblock migratetype for MIGRATE_RESERVE
> > migratetype pages.
> 
> Actually wouldn't the easiest solution to this particular problem to 
> check current pageblock migratetype in try_to_steal_freepages() and 
> disallow changing it. However I agree that preventing the misplaced page 
> in the first place would be even better.
> 
> > The problem was introduced in v2.6.31 by commit ed0ae21
> > ("page allocator: do not call get_pageblock_migratetype()
> > more than necessary").
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Hugh Dickins <hughd@google.com>
> > ---
> > v2:
> > - updated patch description, there is no __zone_pcp_update()
> >    in newer kernels
> > v3:
> > - set freepage migratetype in __rmqueue[_fallback]()
> >    instead of rmqueue_bulk() (per Mel's request)
> >
> >   mm/page_alloc.c |   27 ++++++++++++++++++---------
> >   1 file changed, 18 insertions(+), 9 deletions(-)
> >
> > Index: b/mm/page_alloc.c
> > ===================================================================
> > --- a/mm/page_alloc.c	2014-03-06 18:10:21.884422983 +0100
> > +++ b/mm/page_alloc.c	2014-03-06 18:10:27.016422895 +0100
> > @@ -1094,7 +1094,7 @@ __rmqueue_fallback(struct zone *zone, in
> >   	struct free_area *area;
> >   	int current_order;
> >   	struct page *page;
> > -	int migratetype, new_type, i;
> > +	int migratetype, new_type, mt = start_migratetype, i;
> 
> A better naming would help, "mt" and "migratetype" are the same thing 
> and it gets too confusing.

Well, yes, though 'mt' is short and the check code is consistent with
the corresponding code in rmqueue_bulk().

Do you have a proposal for a better name for this variable?

> >
> >   	/* Find the largest possible block of pages in the other list */
> >   	for (current_order = MAX_ORDER-1; current_order >= order;
> > @@ -1125,6 +1125,14 @@ __rmqueue_fallback(struct zone *zone, in
> >   			expand(zone, page, order, current_order, area,
> >   			       new_type);
> >
> > +			if (IS_ENABLED(CONFIG_CMA)) {
> > +				mt = get_pageblock_migratetype(page);
> > +				if (!is_migrate_cma(mt) &&
> > +				    !is_migrate_isolate(mt))
> > +					mt = start_migratetype;
> > +			}
> > +			set_freepage_migratetype(page, mt);
> > +
> >   			trace_mm_page_alloc_extfrag(page, order, current_order,
> >   				start_migratetype, migratetype, new_type);
> >
> > @@ -1147,7 +1155,9 @@ static struct page *__rmqueue(struct zon
> >   retry_reserve:
> >   	page = __rmqueue_smallest(zone, order, migratetype);
> >
> > -	if (unlikely(!page) && migratetype != MIGRATE_RESERVE) {
> > +	if (likely(page)) {
> > +		set_freepage_migratetype(page, migratetype);
> 
> Are you sure that here the checking of of CMA and ISOLATE is not needed? 

CMA and ISOLATE migratetype pages are always put back on the correct
free lists (since set_freepage_migratetype() sets freepage migratetype
to the original one for CMA and ISOLATE migratetype pages) and
__rmqueue_smallest() can take page only from the 'migratetype' free
list.

+ It was suggested to do it this way by Mel.

> Did the original rmqueue_bulk() have this checking only for the 
> __rmqueue_fallback() case? Why wouldn't the check already be only in 
> __rmqueue_fallback() then?

Probably because of historical reasons.  The rmqueue_bulk() contained
set_page_private() call when CMA was introduced and added the special
handling for CMA and ISOLATE migratetype pages, please see commit
47118af ("mm: mmzone: MIGRATE_CMA migration type added").

> > +	} else if (migratetype != MIGRATE_RESERVE) {
> >   		page = __rmqueue_fallback(zone, order, migratetype);
> >
> >   		/*
> > @@ -1174,7 +1184,7 @@ static int rmqueue_bulk(struct zone *zon
> >   			unsigned long count, struct list_head *list,
> >   			int migratetype, int cold)
> >   {
> > -	int mt = migratetype, i;
> > +	int i;
> >
> >   	spin_lock(&zone->lock);
> >   	for (i = 0; i < count; ++i) {
> > @@ -1195,16 +1205,15 @@ static int rmqueue_bulk(struct zone *zon
> >   			list_add(&page->lru, list);
> >   		else
> >   			list_add_tail(&page->lru, list);
> > +		list = &page->lru;
> >   		if (IS_ENABLED(CONFIG_CMA)) {
> > -			mt = get_pageblock_migratetype(page);
> > +			int mt = get_pageblock_migratetype(page);
> >   			if (!is_migrate_cma(mt) && !is_migrate_isolate(mt))
> >   				mt = migratetype;
> > +			if (is_migrate_cma(mt))
> > +				__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
> > +						      -(1 << order));
> >   		}
> > -		set_freepage_migratetype(page, mt);
> > -		list = &page->lru;
> > -		if (is_migrate_cma(mt))
> > -			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
> > -					      -(1 << order));
> >   	}
> >   	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
> >   	spin_unlock(&zone->lock);

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

