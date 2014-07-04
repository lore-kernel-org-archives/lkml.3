Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965021AbaGDHxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:53:53 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:43574 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaGDHxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:53:08 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
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
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 10/10] mm/page_alloc: Stop merging pages on non-isolate and isolate buddy list
Date: Fri,  4 Jul 2014 16:57:55 +0900
Message-Id: <1404460675-24456-11-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404460675-24456-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1404460675-24456-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we merge pages on non-isolate buddy list and isolate buddy list,
respectively, we should fixup freepage count, because we don't regard
pages in isolate buddy list as freepage. But this will impose some
overhead on __free_one_page() which is core function of page free path
so this overhead looks undesirable to me. Instead, we can stop merging
in this case. With this approach, we can skip to fixup freepage count
with low overhead.

The side-effect of this change is that some buddies equal or larger than
pageblock order isn't merged if one of buddy is on isolate pageblock. But,
I think that this is no problem, because isolation means that we will use
page on isolate pageblock specially, so it will split soon in any case.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/page_alloc.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 80c9bd8..da4da66 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -648,6 +648,24 @@ static inline void __free_one_page(struct page *page,
 			break;
 
 		/*
+		 * Stop merging between page on non-isolate buddy list and
+		 * isolate buddy list, respectively. This case is only possible
+		 * for pages equal or larger than pageblock_order, because
+		 * pageblock migratetype can be changed in this granularity.
+		 */
+		if (unlikely(order >= pageblock_order &&
+			has_isolate_pageblock(zone))) {
+			int buddy_mt = get_onbuddy_migratetype(buddy);
+
+			if (migratetype != buddy_mt) {
+				if (is_migrate_isolate(migratetype))
+					break;
+				else if (is_migrate_isolate(buddy_mt))
+					break;
+			}
+		}
+
+		/*
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
 		 */
-- 
1.7.9.5

