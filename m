Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921AbaEMOXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:23:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbaEMOXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:23:09 -0400
Date: Tue, 13 May 2014 15:23:05 +0100
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 11/19] mm: page_alloc: Lookup pageblock migratetype with
 IRQs enabled during free
Message-ID: <20140513142305.GT23991@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
 <1399974350-11089-12-git-send-email-mgorman@suse.de>
 <53721FD9.6000106@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <53721FD9.6000106@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 03:36:25PM +0200, Vlastimil Babka wrote:
> On 05/13/2014 11:45 AM, Mel Gorman wrote:
> >get_pageblock_migratetype() is called during free with IRQs disabled. This
> >is unnecessary and disables IRQs for longer than necessary.
> >
> >Signed-off-by: Mel Gorman <mgorman@suse.de>
> >Acked-by: Rik van Riel <riel@redhat.com>
> 
> With a comment below,
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> 

Thanks

> >---
> >  mm/page_alloc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >index 3948f0a..fcbf637 100644
> >--- a/mm/page_alloc.c
> >+++ b/mm/page_alloc.c
> >@@ -773,9 +773,9 @@ static void __free_pages_ok(struct page *page, unsigned int order)
> >  	if (!free_pages_prepare(page, order))
> >  		return;
> >
> >+	migratetype = get_pfnblock_migratetype(page, pfn);
> >  	local_irq_save(flags);
> >  	__count_vm_events(PGFREE, 1 << order);
> >-	migratetype = get_pfnblock_migratetype(page, pfn);
> >  	set_freepage_migratetype(page, migratetype);
> 
> The line above could be also outside disabled IRQ, no?
> 

I guess it could but the difference would be marginal at
best. get_pfnblock_migratetype is a lookup of the pageblock bitfield and is
an expensive operation. set_freepage_migratetype() on the other hand is just

static inline void set_freepage_migratetype(struct page *page, int migratetype)
{
        page->index = migratetype;
}

If anything the line could be just removed as right now nothing below
that level is actually using the information (it's primarily of interest
in the per-cpu allocator) but that would be outside the scope of this
patch as move_freepages would also need addressing. I feel the gain is
too marginal to justify the churn.

> >  	free_one_page(page_zone(page), page, pfn, order, migratetype);
> >  	local_irq_restore(flags);
> >
> 

-- 
Mel Gorman
SUSE Labs
