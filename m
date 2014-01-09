Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbaAIHFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:05:04 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43856 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaAIHEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:04:33 -0500
X-AuditID: 9c930197-b7b37ae000002e5a-ca-52ce49fe07e5
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        Mel Gorman <mgorman@suse.de>, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>, Andi Kleen <ak@linux.intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 4/7] mm/isolation: remove invalid check condition
Date: Thu,  9 Jan 2014 16:04:44 +0900
Message-Id: <1389251087-10224-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

test_page_isolated() checks stability of pages. It checks two conditions,
one is that the page is on isolate migratetype and the other is that
the page is on the buddy and the isolate freelist. With satisfying
these two conditions, we can determine that the page is stable and then
go forward.

__test_page_isolated_in_pageblock() is one of the main functions for this
test. In that function, if it meets the page with page_count 0 and
isolate migratetype, it decides that this page is stable. But this is not
true, because there is possiblity that this kind of page is on the pcp
and then it can be allocated by other users even though we hold the zone
lock. So removing this check.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index d1473b2..534fb3a 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -199,9 +199,6 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
 			}
 			pfn += 1 << page_order(page);
 		}
-		else if (page_count(page) == 0 &&
-			get_freepage_migratetype(page) == MIGRATE_ISOLATE)
-			pfn += 1;
 		else if (skip_hwpoisoned_pages && PageHWPoison(page)) {
 			/*
 			 * The HWPoisoned page may be not in buddy
-- 
1.7.9.5

