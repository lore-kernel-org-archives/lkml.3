Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaETF5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:57:51 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55072 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaETF5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:57:50 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <537AEEDB.2000001@lge.com>
Date: Tue, 20 May 2014 14:57:47 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?EUC-KR?B?J7Howdi89ic=?= <iamjoonsoo.kim@lge.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>
CC: =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
Subject: [RFC PATCH] arm: dma-mapping: fallback allocation for cma failure
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for your advise, Michal Nazarewicz.

Having discuss with Joonsoo, I'm adding fallback allocation after __alloc_from_contiguous().
The fallback allocation works if CMA kernel options is turned on but CMA size is zero.

--------------------- 8< ------------------------

>From 05e389683ddd07027e8acb61c25f3284f762300e Mon Sep 17 00:00:00 2001
From: Gioh Kim <gioh.kim@lge.com>
Date: Tue, 20 May 2014 14:16:20 +0900
Subject: [PATCH] arm: dma-mapping: fallback allocation for cma failure

If CMA is turned on and CMA size is set to zero, kernel should
behave as if CMA was not enabled at compile time.
Fallback allocation is added for CMA allocation failure.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 arch/arm/mm/dma-mapping.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 18e98df..2a6c883 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -379,7 +379,7 @@ static int __init atomic_pool_init(void)
        unsigned long *bitmap;
        struct page *page;
        struct page **pages;
-       void *ptr;
+       void *ptr = NULL;
        int bitmap_size = BITS_TO_LONGS(nr_pages) * sizeof(long);

        bitmap = kzalloc(bitmap_size, GFP_KERNEL);
@@ -393,9 +393,10 @@ static int __init atomic_pool_init(void)
        if (IS_ENABLED(CONFIG_DMA_CMA))
                ptr = __alloc_from_contiguous(NULL, pool->size, prot, &page,
                                              atomic_pool_init);
-       else
+       if (!ptr)
                ptr = __alloc_remap_buffer(NULL, pool->size, gfp, prot, &page,
                                           atomic_pool_init);
+
        if (ptr) {
                int i;

@@ -703,8 +704,12 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
                addr = __alloc_from_pool(size, &page);
        else if (!IS_ENABLED(CONFIG_DMA_CMA))
                addr = __alloc_remap_buffer(dev, size, gfp, prot, &page, caller);
-       else
+       else {
                addr = __alloc_from_contiguous(dev, size, prot, &page, caller);
+               if (!addr)
+                       addr = __alloc_remap_buffer(dev, size, gfp, prot,
+                                                   &page, caller);
+       }

        if (addr)
                *handle = pfn_to_dma(dev, page_to_pfn(page));
--
1.7.9.5
