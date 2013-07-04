Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3GDEYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:24:54 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55796 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3GDEYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:24:52 -0400
X-AuditID: 9c930197-b7c79ae000003295-7e-51d4f9113d33
Date: Thu, 4 Jul 2013 13:24:50 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Support multiple pages allocation
Message-ID: <20130704042450.GA7132@lge.com>
References: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130703152824.GB30267@dhcp22.suse.cz>
 <51D44890.4080003@gmail.com>
 <51D44AE7.1090701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D44AE7.1090701@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 12:01:43AM +0800, Zhang Yanfei wrote:
> On 07/03/2013 11:51 PM, Zhang Yanfei wrote:
> > On 07/03/2013 11:28 PM, Michal Hocko wrote:
> >> On Wed 03-07-13 17:34:15, Joonsoo Kim wrote:
> >> [...]
> >>> For one page allocation at once, this patchset makes allocator slower than
> >>> before (-5%). 
> >>
> >> Slowing down the most used path is a no-go. Where does this slow down
> >> come from?
> > 
> > I guess, it might be: for one page allocation at once, comparing to the original
> > code, this patch adds two parameters nr_pages and pages and will do extra checks
> > for the parameter nr_pages in the allocation path.
> > 
> 
> If so, adding a separate path for the multiple allocations seems better.

Hello, all.

I modify the code for optimizing one page allocation via likely macro.
I attach a new one at the end of this mail.

In this case, performance degradation for one page allocation at once is -2.5%.
I guess, remained overhead comes from two added parameters.
Is it unreasonable cost to support this new feature?
I think that readahead path is one of the most used path, so this penalty looks
endurable. And after supporting this feature, we can find more use cases.

I will try to add a new function for the multiple allocations and test it. But,
IMHO, adding a new function is not good idea, because we should duplicate
various checks which are already in __alloc_pages_nodemask and even if
we introduce a new function, we cannot avoid to pass two parameters
to get_page_from_freelist(), so slight performance degradation on
one page allocation is inevitable. Anyway, I will do and test it.

Thanks.

-------------------------------8<----------------------------
>From cee05ad3bcf1c5774fabf797b5dc8f78f812ca36 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Wed, 26 Jun 2013 13:37:57 +0900
Subject: [PATCH] mm, page_alloc: support multiple pages allocation

This patch introduces multiple pages allocation feature to buddy
allocator. Currently, there is no ability to allocate multiple
pages at once, so we should invoke single page allocation logic
repeatedly. This has some overheads like as function call
overhead with many arguments and overhead for finding proper
node and zone.

With this patchset, we can reduce these overheads. Device I/O is
getting faster rapidly and allocator should catch up this speed.
This patch help this situation.

In this patch, I introduce new arguments, nr_pages and pages, to
core function of allocator and try to allocate multiple pages
in first attempt(fast path). I think that multiple page allocation
is not valid for slow path, so current implementation consider
just fast path.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0f615eb..8bfa87b 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -298,13 +298,15 @@ static inline void arch_alloc_page(struct page *page, int order) { }
 
 struct page *
 __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
-		       struct zonelist *zonelist, nodemask_t *nodemask);
+		       struct zonelist *zonelist, nodemask_t *nodemask,
+		       unsigned long *nr_pages, struct page **pages);
 
 static inline struct page *
 __alloc_pages(gfp_t gfp_mask, unsigned int order,
 		struct zonelist *zonelist)
 {
-	return __alloc_pages_nodemask(gfp_mask, order, zonelist, NULL);
+	return __alloc_pages_nodemask(gfp_mask, order,
+				zonelist, NULL, NULL, NULL);
 }
 
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 7431001..b17e48c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2004,7 +2004,8 @@ retry_cpuset:
 	}
 	page = __alloc_pages_nodemask(gfp, order,
 				      policy_zonelist(gfp, pol, node),
-				      policy_nodemask(gfp, pol));
+				      policy_nodemask(gfp, pol),
+				      NULL, NULL);
 	if (unlikely(mpol_needs_cond_ref(pol)))
 		__mpol_put(pol);
 	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
@@ -2052,7 +2053,8 @@ retry_cpuset:
 	else
 		page = __alloc_pages_nodemask(gfp, order,
 				policy_zonelist(gfp, pol, numa_node_id()),
-				policy_nodemask(gfp, pol));
+				policy_nodemask(gfp, pol),
+				NULL, NULL);
 
 	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
 		goto retry_cpuset;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c3edb62..0ba9f63 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1846,7 +1846,8 @@ static inline void init_zone_allows_reclaim(int nid)
 static struct page *
 get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 		struct zonelist *zonelist, int high_zoneidx, int alloc_flags,
-		struct zone *preferred_zone, int migratetype)
+		struct zone *preferred_zone, int migratetype,
+		unsigned long *nr_pages, struct page **pages)
 {
 	struct zoneref *z;
 	struct page *page = NULL;
@@ -1968,8 +1969,33 @@ zonelist_scan:
 try_this_zone:
 		page = buffered_rmqueue(preferred_zone, zone, order,
 						gfp_mask, migratetype);
-		if (page)
+		if (page) {
+			unsigned long mark;
+			unsigned long count;
+			unsigned long nr;
+
+			if (likely(!nr_pages))
+				break;
+
+			count = 0;
+			pages[count++] = page;
+			mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
+			nr = *nr_pages;
+			while (count < nr) {
+				if (!zone_watermark_ok(zone, order, mark,
+					classzone_idx, alloc_flags))
+					break;
+				page = buffered_rmqueue(preferred_zone, zone,
+						order, gfp_mask, migratetype);
+				if (!page)
+					break;
+				pages[count++] = page;
+			}
+			*nr_pages = count;
+			page = pages[0];
 			break;
+		}
+
 this_zone_full:
 		if (IS_ENABLED(CONFIG_NUMA))
 			zlc_mark_zone_full(zonelist, z);
@@ -2125,7 +2151,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
 		order, zonelist, high_zoneidx,
 		ALLOC_WMARK_HIGH|ALLOC_CPUSET,
-		preferred_zone, migratetype);
+		preferred_zone, migratetype,
+		NULL, NULL);
 	if (page)
 		goto out;
 
@@ -2188,7 +2215,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		page = get_page_from_freelist(gfp_mask, nodemask,
 				order, zonelist, high_zoneidx,
 				alloc_flags & ~ALLOC_NO_WATERMARKS,
-				preferred_zone, migratetype);
+				preferred_zone, migratetype,
+				NULL, NULL);
 		if (page) {
 			preferred_zone->compact_blockskip_flush = false;
 			preferred_zone->compact_considered = 0;
@@ -2282,7 +2310,8 @@ retry:
 	page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
 					alloc_flags & ~ALLOC_NO_WATERMARKS,
-					preferred_zone, migratetype);
+					preferred_zone, migratetype,
+					NULL, NULL);
 
 	/*
 	 * If an allocation failed after direct reclaim, it could be because
@@ -2312,7 +2341,8 @@ __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
 	do {
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
-			preferred_zone, migratetype);
+			preferred_zone, migratetype,
+			NULL, NULL);
 
 		if (!page && gfp_mask & __GFP_NOFAIL)
 			wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
@@ -2449,7 +2479,8 @@ rebalance:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
-			preferred_zone, migratetype);
+			preferred_zone, migratetype,
+			NULL, NULL);
 	if (page)
 		goto got_pg;
 
@@ -2598,7 +2629,8 @@ got_pg:
  */
 struct page *
 __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
-			struct zonelist *zonelist, nodemask_t *nodemask)
+			struct zonelist *zonelist, nodemask_t *nodemask,
+			unsigned long *nr_pages, struct page **pages)
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	struct zone *preferred_zone;
@@ -2647,9 +2679,11 @@ retry_cpuset:
 		alloc_flags |= ALLOC_CMA;
 #endif
 	/* First allocation attempt */
+	/* We only try to allocate nr_pages in first attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, alloc_flags,
-			preferred_zone, migratetype);
+			preferred_zone, migratetype,
+			nr_pages, pages);
 	if (unlikely(!page)) {
 		/*
 		 * Runtime PM, block IO and its error handling path
-- 
1.7.9.5

