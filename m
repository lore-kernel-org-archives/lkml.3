Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbaJ1Hga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:36:30 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46970 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbaJ1Hg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 03:36:27 -0400
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 28 Oct 2014 16:37:45 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 3/4] mm/page_alloc: move migratetype recheck logic to
 __free_one_page()
Message-ID: <20141028073745.GD27813@js1304-P5Q-DELUXE>
References: <1414051821-12769-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1414051821-12769-4-git-send-email-iamjoonsoo.kim@lge.com>
 <544E2117.9000809@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544E2117.9000809@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 11:40:23AM +0100, Vlastimil Babka wrote:
> On 10/23/2014 10:10 AM, Joonsoo Kim wrote:
> > All the caller of __free_one_page() has similar migratetype recheck logic,
> > so we can move it to __free_one_page(). This reduce line of code and help
> > future maintenance. This is also preparation step for "mm/page_alloc:
> > restrict max order of merging on isolated pageblock" which fix the
> > freepage accouting problem on freepage with more than pageblock order.
> > 
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > ---
> >  mm/page_alloc.c |   24 ++++++++----------------
> >  1 file changed, 8 insertions(+), 16 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 5d2f807..433f92c 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -579,7 +579,15 @@ static inline void __free_one_page(struct page *page,
> >  			return;
> >  
> >  	VM_BUG_ON(migratetype == -1);
> > +	if (unlikely(has_isolate_pageblock(zone) ||
> > +		is_migrate_isolate(migratetype))) {
> 
> Since the v4 change of patch 1, this now adds
> is_migrate_isolate(migratetype) also for the free_pcppages_bulk path,
> where it's not needed?

Yes, you are right. But, patch 4 needs is_migrate_isolate() check
in __free_one_page().

> 
> > +		migratetype = get_pfnblock_migratetype(page, pfn);
> > +		if (is_migrate_isolate(migratetype))
> > +			goto skip_counting;
> > +	}
> > +	__mod_zone_freepage_state(zone, 1 << order, migratetype);
> >  
> > +skip_counting:
> >  	page_idx = pfn & ((1 << MAX_ORDER) - 1);
> >  
> >  	VM_BUG_ON_PAGE(page_idx & ((1 << order) - 1), page);
> > @@ -725,14 +733,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
> >  			/* must delete as __free_one_page list manipulates */
> >  			list_del(&page->lru);
> >  			mt = get_freepage_migratetype(page);
> > -			if (unlikely(has_isolate_pageblock(zone))) {
> > -				mt = get_pageblock_migratetype(page);
> > -				if (is_migrate_isolate(mt))
> > -					goto skip_counting;
> > -			}
> > -			__mod_zone_freepage_state(zone, 1, mt);
> >  
> > -skip_counting:
> >  			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
> >  			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
> >  			trace_mm_page_pcpu_drain(page, 0, mt);
> 
> The 'mt' here for the tracepoint is now different. I know it's the same
> as before patch 2, but the value introduced by patch 2 is more correct
> than the reverting to pre-patch 2 done here.

Yes, you are right. I didn't notice that.

> This and the introduced check above are maybe minor things, but it makes
> me question the value of unifying the check when the conditions in the
> two call paths are not completely the same...
> 
> I understand this is also prerequisity for patch 4 in some sense, but if
> you are reworking it anyway, then maybe this won't be needed in the end?

As mentioned above, is_migrate_isolate() check is needed in __free_one_page()
in any case. Reworked patch also needs this.

Hmm... I'd like to check isolate migratetype in just one place, but, it
seems to be impossible. To correct tracepoint, I will remain the check
in each functions. :/

Thanks.
