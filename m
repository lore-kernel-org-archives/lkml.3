Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006Ab3HNPwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:52:41 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51427 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759950Ab3HNPwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:52:40 -0400
Date: Thu, 15 Aug 2013 00:52:29 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Xishi Qiu <qiuxishi@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        riel@redhat.com, aquini@redhat.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: skip the page buddy block instead of one page
Message-ID: <20130814155205.GA2706@gmail.com>
References: <520B0B75.4030708@huawei.com>
 <20130814085711.GK2296@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814085711.GK2296@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Wed, Aug 14, 2013 at 09:57:11AM +0100, Mel Gorman wrote:
> On Wed, Aug 14, 2013 at 12:45:41PM +0800, Xishi Qiu wrote:
> > A large free page buddy block will continue many times, so if the page 
> > is free, skip the whole page buddy block instead of one page.
> > 
> > Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> 
> page_order cannot be used unless zone->lock is held which is not held in
> this path. Acquiring the lock would prevent parallel allocations from the

Argh, I missed that. And it seems you already pointed it out long time ago
someone try to do same things if I remember correctly. :(
But let's think about it more.

It's always not right because CMA and memory-hotplug already isolated
free pages in the range to MIGRATE_ISOLATE right before starting migration
so we could use page_order safely in those contexts even if we don't hold
zone->lock.
 
In addition, it's likely to have many free pages in case of CMA because CMA
makes MIGRATE_CMA fallback of MIGRATE_MOVABLE to minimize number of migrations.
Even CMA area was full, it could have many free pages once driver who is
CMA area's owner releases the CMA area. So, the bigger CMA space is,
the bigger patch's benefit is. And it could help memory-hotplug, too.

Only problem is normal compaction. The worst case is just skipping
pageblock_nr_pages, for instace, 4M(of course, it depends on configuration).
but we can make the race window very small by dobule checking PageBuddy.
Still, it could make the race theoretically but I think it's really really
unlikely and still enhance compaction overhead withtout holding the lock.
Even if the race happens, normal compaction's customers(ex, THP) doesn't
have critical result and just fallback. So I think it isn't not bad tradeoff.

>From a8172e2197b80e183f2425f4ce8dd060d7d80f1a Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Thu, 15 Aug 2013 00:37:21 +0900
Subject: [PATCH] compaction: skip buddy page during compaction

When isolate_migratepages_range meets free page, it just skip
a page instead whole free page block. It makes unnecessary
overhead of compaction so we might want to use page_order to skip whole
free page block but it's not safe without zone->lock.

With more thinking, it's always not right because CMA and memory-hotplug
already isolated free pages in the range to MIGRATE_ISOLATE right before
starting migration so we could use page_order safely in those contexts
even if we don't hold zone->lock.

In addition to that, it's likely to have many free pages in case of CMA
because CMA makes MIGRATE_CMA fallback of MIGRATE_MOVABLE to minimize
number of migrations. Even CMA area was full, it could have many free pages
once driver who is CMA area's owner releases the CMA area.
So, the bigger CMA space is, the bigger patch's benefit is.
And it could help memory-hotplug, too.

Only problem is normal compaction. The worst case is just skipping
pageblock_nr_pages, for instace, 4M(of course, it depends on configuration).
but we can make the race window very small by dobule checking PageBuddy.
Still, it could make the race theoretically but I think it's really really
unlikely and enhance compaction overhead withtout holding the lock.
Even if the race happens, normal compaction's customers which want to
higher order allocatoin don't have critical result due to failing and
can fallback.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/compaction.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 05ccb4c..2341d52 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -520,8 +520,18 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			goto next_pageblock;
 
 		/* Skip if free */
-		if (PageBuddy(page))
+		if (PageBuddy(page)) {
+			/*
+			 * page_order is racy without zone->lock but worst case
+			 * by the racing is just skipping pageblock_nr_pages.
+			 * but even the race is really unlikely by double
+			 * check of PageBuddy.
+			 */
+			unsigned long order = page_order(page);
+			if (PageBuddy(page))
+				low_pfn += (1 << order) - 1;
 			continue;
+		}
 
 		/*
 		 * For async migration, also only scan in MOVABLE blocks. Async
-- 
1.8.3.2


> buddy allocator (per-cpu allocator would be ok except for refills).  I expect
> it would not be a good tradeoff to acquire the lock just to use page_order.
> 
> Nak.
> 
> -- 
> Mel Gorman
> SUSE Labs

-- 
Kind regards,
Minchan Kim
