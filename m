Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3LMW1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:10 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:40049 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab3LMW1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:06 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 038/115] gpu: ion: Modify gfp flags in ion_system_heap
Date: Fri, 13 Dec 2013 14:24:12 -0800
Message-Id: <1386973529-4884-39-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

When allocations larger than order 4 are made, use _GFP_NORETRY
and __GFP_NO_KSWAPD so kswapd doesn't get kicked off to reclaim
these larger chunks.  For smaller allocaitons, these are
unnecessary, as the system should be able to reclaim these.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 35fbfff..b99fa0e 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -26,6 +26,11 @@
 #include "ion.h"
 #include "ion_priv.h"
 
+static unsigned int high_order_gfp_flags = (GFP_HIGHUSER | __GFP_ZERO |
+					    __GFP_NOWARN | __GFP_NORETRY |
+					    __GFP_NO_KSWAPD);
+static unsigned int low_order_gfp_flags  = (GFP_HIGHUSER | __GFP_ZERO |
+					 __GFP_NOWARN);
 static const unsigned int orders[] = {8, 4, 0};
 static const int num_orders = ARRAY_SIZE(orders);
 static int order_to_index(unsigned int order)
@@ -63,11 +68,15 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 	struct ion_page_pool *pool = heap->pools[order_to_index(order)];
 	struct page *page;
 
-	if (!cached)
+	if (!cached) {
 		page = ion_page_pool_alloc(pool);
-	else
-		page = alloc_pages(GFP_HIGHUSER | __GFP_ZERO |
-				   __GFP_NOWARN | __GFP_NORETRY, order);
+	} else {
+		gfp_t gfp_flags = low_order_gfp_flags;
+
+		if (order > 4)
+			gfp_flags = high_order_gfp_flags;
+		page = alloc_pages(gfp_flags, order);
+	}
 	if (!page)
 		return 0;
 	if (split_pages)
@@ -342,9 +351,11 @@ struct ion_heap *ion_system_heap_create(struct ion_platform_heap *unused)
 		goto err_alloc_pools;
 	for (i = 0; i < num_orders; i++) {
 		struct ion_page_pool *pool;
-		pool = ion_page_pool_create(GFP_HIGHUSER | __GFP_ZERO |
-					   __GFP_NOWARN | __GFP_NORETRY,
-					   orders[i]);
+		gfp_t gfp_flags = low_order_gfp_flags;
+
+		if (orders[i] > 4)
+			gfp_flags = high_order_gfp_flags;
+		pool = ion_page_pool_create(gfp_flags, orders[i]);
 		if (!pool)
 			goto err_create_pool;
 		heap->pools[i] = pool;
-- 
1.8.3.2

