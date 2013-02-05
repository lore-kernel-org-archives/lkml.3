Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3BEBnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 20:43:14 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48372 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab3BEBnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 20:43:13 -0500
X-AuditID: 9c930179-b7c24ae00000119c-2b-511063add4ab
Date: Tue, 5 Feb 2013 10:43:08 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rik van Riel <riel@redhat.com>, Luigi Semenzato <semenzato@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Sonny Rao <sonnyrao@google.com>, Bryan Freed <bfreed@google.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] mm: prevent to add a page to swap if may_writepage
 is unset
Message-ID: <20130205014308.GG2610@blaptop>
References: <1357712474-27595-1-git-send-email-minchan@kernel.org>
 <1357712474-27595-2-git-send-email-minchan@kernel.org>
 <20130116134155.18092f1a.akpm@linux-foundation.org>
 <20130117005314.GB18669@blaptop>
 <20130117142238.e32c46d5.akpm@linux-foundation.org>
 <20130117233641.GA31368@blaptop>
 <20130121015222.GA3666@blaptop>
 <50FD530A.6010500@redhat.com>
 <20130122000954.GH3666@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130122000954.GH3666@blaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 09:09:54AM +0900, Minchan Kim wrote:
> On Mon, Jan 21, 2013 at 09:39:06AM -0500, Rik van Riel wrote:
> > On 01/20/2013 08:52 PM, Minchan Kim wrote:
> > 
> > > From 94086dc7152359d052802c55c82ef19509fe8cce Mon Sep 17 00:00:00 2001
> > >From: Minchan Kim <minchan@kernel.org>
> > >Date: Mon, 21 Jan 2013 10:43:43 +0900
> > >Subject: [PATCH] mm: Use up free swap space before reaching OOM kill
> > >
> > >Recently, Luigi reported there are lots of free swap space when
> > >OOM happens. It's easily reproduced on zram-over-swap, where
> > >many instance of memory hogs are running and laptop_mode is enabled.
> > >He said there was no problem when he disabled laptop_mode.
> > >The problem when I investigate problem is following as.
> > >
> > >Assumption for easy explanation: There are no page cache page in system
> > >because they all are already reclaimed.
> > >
> > >1. try_to_free_pages disable may_writepage when laptop_mode is enabled.
> > >2. shrink_inactive_list isolates victim pages from inactive anon lru list.
> > >3. shrink_page_list adds them to swapcache via add_to_swap but it doesn't
> > >    pageout because sc->may_writepage is 0 so the page is rotated back into
> > >    inactive anon lru list. The add_to_swap made the page Dirty by SetPageDirty.
> > >4. 3 couldn't reclaim any pages so do_try_to_free_pages increase priority and
> > >    retry reclaim with higher priority.
> > >5. shrink_inactlive_list try to isolate victim pages from inactive anon lru list
> > >    but got failed because it try to isolate pages with ISOLATE_CLEAN mode but
> > >    inactive anon lru list is full of dirty pages by 3 so it just returns
> > >    without  any reclaim progress.
> > >6. do_try_to_free_pages doesn't set may_writepage due to zero total_scanned.
> > >    Because sc->nr_scanned is increased by shrink_page_list but we don't call
> > >    shrink_page_list in 5 due to short of isolated pages.
> > >
> > >Above loop is continued until OOM happens.
> > >The problem didn't happen before [1] was merged because old logic's
> > >isolatation in shrink_inactive_list was successful and tried to call
> > >shrink_page_list to pageout them but it still ends up failed to page out
> > >by may_writepage. But important point is that sc->nr_scanned was increased
> > >although we couldn't swap out them so do_try_to_free_pages could set
> > >may_writepages.
> > >
> > >Since [1] was introduced, it's not a good idea any more to depends on
> > >only the number of scanned pages for setting may_writepage. So this patch
> > >adds new trigger point of setting may_writepage as below DEF_PRIOIRTY - 2
> > >which is used to show the significant memory pressure in VM so it's good
> > >fit for our purpose which would be better to lose power saving or clickety
> > >rather than OOM killing.
> > >
> > >[1] f80c067[mm: zone_reclaim: make isolate_lru_page() filter-aware]
> > >
> > >Reported-by: Luigi Semenzato <semenzato@google.com>
> > >Signed-off-by: Minchan Kim <minchan@kernel.org>
> > 
> > Your patch is a nice simplification.  I am ok with the
> > change, provided it works for Luigi :)
> 
> Thanks, Rik.
> 
> Oops, I missed to Ccing Luigi. Add him again.
> Luigi, Could you test this patch?
> Thanks for your endless effort.
> 
> > 
> > Acked-by: Rik van Riel <riel@redhat.com>
> > 


Andrew,
I hope Luigi confirms this patch but he seems to be very busy.
At a minimum, I tested this patch and passed my test.
Could you apply this and remove [2]?
Otherwise, should I wait for Luigi?

[2] mm: prevent addition of pages to swap if may_writepage is unset

>From 72cdf4159427c1ecdbd21a40b8bd1f13d5b8d5e2 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Mon, 21 Jan 2013 10:52:22 +0900
Subject: [PATCH] mm: Use up free swap space before reaching OOM kill

Recently, Luigi reported there are lots of free swap space when
OOM happens. It's easily reproduced on zram-over-swap, where
many instance of memory hogs are running and laptop_mode is enabled.
He said there was no problem when he disabled laptop_mode.
The problem when I investigate problem is following as.

Assumption for easy explanation: There are no page cache page in system
because they all are already reclaimed.

1. try_to_free_pages disable may_writepage when laptop_mode is enabled.
2. shrink_inactive_list isolates victim pages from inactive anon lru list.
3. shrink_page_list adds them to swapcache via add_to_swap but it doesn't
   pageout because sc->may_writepage is 0 so the page is rotated back into
   inactive anon lru list. The add_to_swap made the page Dirty by SetPageDirty.
4. 3 couldn't reclaim any pages so do_try_to_free_pages increase priority and
   retry reclaim with higher priority.
5. shrink_inactlive_list try to isolate victim pages from inactive anon lru list
   but got failed because it try to isolate pages with ISOLATE_CLEAN mode but
   inactive anon lru list is full of dirty pages by 3 so it just returns
   without  any reclaim progress.
6. do_try_to_free_pages doesn't set may_writepage due to zero total_scanned.
   Because sc->nr_scanned is increased by shrink_page_list but we don't call
   shrink_page_list in 5 due to short of isolated pages.

Above loop is continued until OOM happens.
The problem didn't happen before [1] was merged because old logic's
isolatation in shrink_inactive_list was successful and tried to call
shrink_page_list to pageout them but it still ends up failed to page out
by may_writepage. But important point is that sc->nr_scanned was increased
although we couldn't swap out them so do_try_to_free_pages could set
may_writepages.

Since [1] was introduced, it's not a good idea any more to depends on
only the number of scanned pages for setting may_writepage. So this patch
adds new trigger point of setting may_writepage as below DEF_PRIOIRTY - 2
which is used to show the significant memory pressure in VM so it's good
fit for our purpose which would be better to lose power saving or clickety
rather than OOM killing.

[1] f80c067[mm: zone_reclaim: make isolate_lru_page() filter-aware]

Reported-by: Luigi Semenzato <semenzato@google.com>
[Rik is ok if the patch works for Luigi]
Not-yet-Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d75c1ec..4fb3a6d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2204,6 +2204,13 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 			goto out;
 
 		/*
+		 * If we're getting trouble reclaiming, start doing
+		 * writepage even in laptop mode.
+		 */
+		if (sc->priority < DEF_PRIORITY - 2)
+			sc->may_writepage = 1;
+
+		/*
 		 * Try to write back as many pages as we just scanned.  This
 		 * tends to cause slow streaming writers to write data to the
 		 * disk smoothly, at the dirtying rate, which is nice.   But
@@ -2774,12 +2781,10 @@ loop_again:
 			}
 
 			/*
-			 * If we've done a decent amount of scanning and
-			 * the reclaim ratio is low, start doing writepage
-			 * even in laptop mode
+			 * If we're getting trouble reclaiming, start doing
+			 * writepage even in laptop mode.
 			 */
-			if (total_scanned > SWAP_CLUSTER_MAX * 2 &&
-			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
+			if (sc.priority < DEF_PRIORITY - 2)
 				sc.may_writepage = 1;
 
 			if (zone->all_unreclaimable) {
-- 
1.8.1.1

-- 
Kind regards,
Minchan Kim
