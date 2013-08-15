Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab3HOLa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:30:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab3HOLaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:30:25 -0400
Date: Thu, 15 Aug 2013 12:30:19 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Xishi Qiu <qiuxishi@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        riel@redhat.com, aquini@redhat.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: skip the page buddy block instead of one page
Message-ID: <20130815113019.GV2296@suse.de>
References: <520B0B75.4030708@huawei.com>
 <20130814085711.GK2296@suse.de>
 <20130814155205.GA2706@gmail.com>
 <20130814161642.GM2296@suse.de>
 <20130814163921.GC2706@gmail.com>
 <20130814180012.GO2296@suse.de>
 <520C3DD2.8010905@huawei.com>
 <20130815024427.GA2718@gmail.com>
 <520C4EFF.8040305@huawei.com>
 <20130815041736.GA2592@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130815041736.GA2592@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 01:17:55PM +0900, Minchan Kim wrote:
> Hello,
> 

Well, this thread managed to get out of control for no good reason!

> > > <SNIP>
> > > So, what's the result by that?
> > > As I said, it's just skipping (pageblock_nr_pages -1) at worst case
> > 
> > Hi Minchan,
> > I mean if the private is set to a large number, it will skip 2^private 
> > pages, not (pageblock_nr_pages -1). I find somewhere will use page->private, 
> > such as fs. Here is the comment about parivate.
> > /* Mapping-private opaque data:
> >  * usually used for buffer_heads
> >  * if PagePrivate set; used for
> >  * swp_entry_t if PageSwapCache;
> >  * indicates order in the buddy
> >  * system if PG_buddy is set.
> >  */
> 
> Please read full thread in detail.
> 
> Mel suggested following as
> 
> if (PageBuddy(page)) {
>         int nr_pages = (1 << page_order(page)) - 1;
>         if (PageBuddy(page)) {
>                 nr_pages = min(nr_pages, MAX_ORDER_NR_PAGES - 1);
>                 low_pfn += nr_pages;
>                 continue;
>         }
> }
> 
> min(nr_pages, xxx) removes your concern but I think Mel's version
> isn't right. It should be aligned with pageblock boundary so I 
> suggested following.
> 

Why? We're looking for pages to migrate. If the page is free and at the
maximum order then there is no point searching in the middle of a free
page.

> if (PageBuddy(page)) {
> #ifdef CONFIG_MEMORY_ISOLATION
> 	unsigned long order = page_order(page);
> 	if (PageBuddy(page)) {
> 		low_pfn += (1 << order) - 1;
> 		low_pfn = min(low_pfn, end_pfn);
> 	}
> #endif
> 	continue;
> }
> 
> so worst case is (pageblock_nr_pages - 1).

No it isn't. The worst case it that the whole region being searched is
skipped. For THP allocations, it would happen to work as being the
pageblock boundary but it is not required by the API. I expect that
end_pfn is not necessarily the next pageblock boundary for CMA
allocations.

-- 
Mel Gorman
SUSE Labs
