Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbbAFIXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:23:37 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:36163 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbbAFIXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:23:35 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 6 Jan 2015 17:23:29 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Gregory Fong <gregory.0xf0@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>, Marek@jasper.es,
        linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] CMA: aggressively allocate the pages on cma
 reserved memory when not used
Message-ID: <20150106082329.GB18346@js1304-P5Q-DELUXE>
References: <1401260672-28339-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1401260672-28339-3-git-send-email-iamjoonsoo.kim@lge.com>
 <CADtm3G5Cb2vzVo61qDJ7-1ZNzQ2zOisfjb7GiFXvZR0ocKZy0A@mail.gmail.com>
 <CADtm3G4CEhpmrohufmthB_1a49bKEVdVUAQxjWtigq07G4QeTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADtm3G4CEhpmrohufmthB_1a49bKEVdVUAQxjWtigq07G4QeTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 08:01:45PM -0800, Gregory Fong wrote:
> +linux-mm and linux-kernel (not sure how those got removed from cc,
> sorry about that)
> 
> On Mon, Jan 5, 2015 at 7:58 PM, Gregory Fong <gregory.0xf0@gmail.com> wrote:
> > Hi Joonsoo,
> >
> > On Wed, May 28, 2014 at 12:04 AM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index 674ade7..ca678b6 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -788,6 +788,56 @@ void __init __free_pages_bootmem(struct page *page, unsigned int order)
> >>  }
> >>
> >>  #ifdef CONFIG_CMA
> >> +void adjust_managed_cma_page_count(struct zone *zone, long count)
> >> +{
> >> +       unsigned long flags;
> >> +       long total, cma, movable;
> >> +
> >> +       spin_lock_irqsave(&zone->lock, flags);
> >> +       zone->managed_cma_pages += count;
> >> +
> >> +       total = zone->managed_pages;
> >> +       cma = zone->managed_cma_pages;
> >> +       movable = total - cma - high_wmark_pages(zone);
> >> +
> >> +       /* No cma pages, so do only movable allocation */
> >> +       if (cma <= 0) {
> >> +               zone->max_try_movable = pageblock_nr_pages;
> >> +               zone->max_try_cma = 0;
> >> +               goto out;
> >> +       }
> >> +
> >> +       /*
> >> +        * We want to consume cma pages with well balanced ratio so that
> >> +        * we have consumed enough cma pages before the reclaim. For this
> >> +        * purpose, we can use the ratio, movable : cma. And we doesn't
> >> +        * want to switch too frequently, because it prevent allocated pages
> >> +        * from beging successive and it is bad for some sorts of devices.
> >> +        * I choose pageblock_nr_pages for the minimum amount of successive
> >> +        * allocation because it is the size of a huge page and fragmentation
> >> +        * avoidance is implemented based on this size.
> >> +        *
> >> +        * To meet above criteria, I derive following equation.
> >> +        *
> >> +        * if (movable > cma) then; movable : cma = X : pageblock_nr_pages
> >> +        * else (movable <= cma) then; movable : cma = pageblock_nr_pages : X
> >> +        */
> >> +       if (movable > cma) {
> >> +               zone->max_try_movable =
> >> +                       (movable * pageblock_nr_pages) / cma;
> >> +               zone->max_try_cma = pageblock_nr_pages;
> >> +       } else {
> >> +               zone->max_try_movable = pageblock_nr_pages;
> >> +               zone->max_try_cma = cma * pageblock_nr_pages / movable;
> >
> > I don't know if anyone's already pointed this out (didn't see anything
> > when searching lkml), but while testing this, I noticed this can
> > result in a div by zero under memory pressure (movable becomes 0).
> > This is not unlikely when the majority of pages are in CMA regions
> > (this may seem pathological but we do actually do this right now).

Hello,

Yes, you are right. Thanks for pointing this out.
I will fix it on next version.

Thanks.
