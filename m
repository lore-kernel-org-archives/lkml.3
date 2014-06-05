Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaFEVa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:30:56 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:64390 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaFEVax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:30:53 -0400
Date: Thu, 5 Jun 2014 14:30:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 4/6] mm, compaction: skip buddy pages by their order
 in the migrate scanner
In-Reply-To: <5390374E.5080708@suse.cz>
Message-ID: <alpine.DEB.2.02.1406051428360.18119@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com> <1401898310-14525-1-git-send-email-vbabka@suse.cz> <1401898310-14525-4-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1406041656400.22536@chino.kir.corp.google.com>
 <5390374E.5080708@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014, Vlastimil Babka wrote:

> > > diff --git a/mm/compaction.c b/mm/compaction.c
> > > index ae7db5f..3dce5a7 100644
> > > --- a/mm/compaction.c
> > > +++ b/mm/compaction.c
> > > @@ -640,11 +640,18 @@ isolate_migratepages_range(struct zone *zone, struct
> > > compact_control *cc,
> > >   		}
> > > 
> > >   		/*
> > > -		 * Skip if free. page_order cannot be used without zone->lock
> > > -		 * as nothing prevents parallel allocations or buddy merging.
> > > +		 * Skip if free. We read page order here without zone lock
> > > +		 * which is generally unsafe, but the race window is small and
> > > +		 * the worst thing that can happen is that we skip some
> > > +		 * potential isolation targets.
> > 
> > Should we only be doing the low_pfn adjustment based on the order for
> > MIGRATE_ASYNC?  It seems like sync compaction, including compaction that
> > is triggered from the command line, would prefer to scan over the
> > following pages.
> 
> I thought even sync compaction would benefit from the skipped iterations. I'd
> say the probability of this race is smaller than probability of somebody
> allocating what compaction just freed.
> 

Ok.

> > > diff --git a/mm/internal.h b/mm/internal.h
> > > index 1a8a0d4..6aa1f74 100644
> > > --- a/mm/internal.h
> > > +++ b/mm/internal.h
> > > @@ -164,7 +164,8 @@ isolate_migratepages_range(struct zone *zone, struct
> > > compact_control *cc,
> > >    * general, page_zone(page)->lock must be held by the caller to prevent
> > > the
> > >    * page from being allocated in parallel and returning garbage as the
> > > order.
> > >    * If a caller does not hold page_zone(page)->lock, it must guarantee
> > > that the
> > > - * page cannot be allocated or merged in parallel.
> > > + * page cannot be allocated or merged in parallel. Alternatively, it must
> > > + * handle invalid values gracefully, and use page_order_unsafe() below.
> > >    */
> > >   static inline unsigned long page_order(struct page *page)
> > >   {
> > > @@ -172,6 +173,23 @@ static inline unsigned long page_order(struct page
> > > *page)
> > >   	return page_private(page);
> > >   }
> > > 
> > > +/*
> > > + * Like page_order(), but for callers who cannot afford to hold the zone
> > > lock,
> > > + * and handle invalid values gracefully. ACCESS_ONCE is used so that if
> > > the
> > > + * caller assigns the result into a local variable and e.g. tests it for
> > > valid
> > > + * range  before using, the compiler cannot decide to remove the variable
> > > and
> > > + * inline the function multiple times, potentially observing different
> > > values
> > > + * in the tests and the actual use of the result.
> > > + */
> > > +static inline unsigned long page_order_unsafe(struct page *page)
> > > +{
> > > +	/*
> > > +	 * PageBuddy() should be checked by the caller to minimize race
> > > window,
> > > +	 * and invalid values must be handled gracefully.
> > > +	 */
> > > +	return ACCESS_ONCE(page_private(page));
> > > +}
> > > +
> > >   /* mm/util.c */
> > >   void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
> > >   		struct vm_area_struct *prev, struct rb_node *rb_parent);
> > 
> > I don't like this change at all, I don't think we should have header
> > functions that imply the context in which the function will be called.  I
> > think it would make much more sense to just do
> > ACCESS_ONCE(page_order(page)) in the migration scanner with a comment.
> 
> But that won't compile. It would have to be converted to a #define, unless
> there's some trick I don't know. Sure I would hope this could be done cleaner
> somehow.
> 

Sorry, I meant ACCESS_ONCE(page_private(page)) in the migration scanner 
with a comment about it being racy.  It also helps to understand why 
you're testing for order < MAX_ORDER before skipping low_pfn there which 
is a little subtle right now.
