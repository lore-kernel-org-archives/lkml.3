Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaCRCb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 22:31:29 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:45785 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaCRCb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 22:31:28 -0400
Message-ID: <5327AF4B.6000100@huawei.com>
Date: Tue, 18 Mar 2014 10:28:27 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Xishi Qiu <qiuxishi@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] kmemcheck: move hook into __alloc_pages_nodemask() for the
 page allocator
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now kmemcheck_pagealloc_alloc() is only called by __alloc_pages_slowpath().
__alloc_pages_nodemask()
	__alloc_pages_slowpath()
		kmemcheck_pagealloc_alloc()

And the page will not be tracked by kmemcheck in the following path.
__alloc_pages_nodemask()
	get_page_from_freelist()

So move kmemcheck_pagealloc_alloc() into __alloc_pages_nodemask(), 
like this:
__alloc_pages_nodemask()
	...
	get_page_from_freelist()
	if (!page)
		__alloc_pages_slowpath()
	kmemcheck_pagealloc_alloc()
	...

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/page_alloc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e3758a0..ce596b4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2671,11 +2671,7 @@ rebalance:
 
 nopage:
 	warn_alloc_failed(gfp_mask, order, NULL);
-	return page;
 got_pg:
-	if (kmemcheck_enabled)
-		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
-
 	return page;
 }
 
@@ -2748,6 +2744,8 @@ retry_cpuset:
 				preferred_zone, migratetype);
 	}
 
+	if (kmemcheck_enabled && page)
+		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
 	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
 
 out:
-- 
1.7.1


