Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaEVEqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:46:10 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:57787 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaEVEqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:46:08 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: mina86@mina86.com, m.szyprowski@samsung.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        heesub.shin@samsung.com, mgorman@suse.de, hannes@cmpxchg.org
Cc: gunho.lee@lge.com, chanho.min@lge.com, gurugio@gmail.com,
        Gioh Kim <gioh.kim@lge.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] arm: dma-mapping: add checking cma area initialized
Date: Thu, 22 May 2014 13:38:23 +0900
Message-Id: <1400733503-1302-1-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CMA is turned on and CMA size is set to zero, kernel should
behave as if CMA was not enabled at compile time.
Every dma allocation should check existence of cma area
before requesting memory.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
---
 arch/arm/mm/dma-mapping.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 18e98df..9173a13 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -390,12 +390,13 @@ static int __init atomic_pool_init(void)
 	if (!pages)
 		goto no_pages;
 
-	if (IS_ENABLED(CONFIG_DMA_CMA))
+	if (dev_get_cma_area(NULL))
 		ptr = __alloc_from_contiguous(NULL, pool->size, prot, &page,
 					      atomic_pool_init);
 	else
 		ptr = __alloc_remap_buffer(NULL, pool->size, gfp, prot, &page,
 					   atomic_pool_init);
+
 	if (ptr) {
 		int i;
 
@@ -701,7 +702,7 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
 		addr = __alloc_simple_buffer(dev, size, gfp, &page);
 	else if (!(gfp & __GFP_WAIT))
 		addr = __alloc_from_pool(size, &page);
-	else if (!IS_ENABLED(CONFIG_DMA_CMA))
+	else if (!dev_get_cma_area(dev))
 		addr = __alloc_remap_buffer(dev, size, gfp, prot, &page, caller);
 	else
 		addr = __alloc_from_contiguous(dev, size, prot, &page, caller);
@@ -790,7 +791,7 @@ static void __arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
 		__dma_free_buffer(page, size);
 	} else if (__free_from_pool(cpu_addr, size)) {
 		return;
-	} else if (!IS_ENABLED(CONFIG_DMA_CMA)) {
+	} else if (!dev_get_cma_area(dev)) {
 		__dma_free_remap(cpu_addr, size);
 		__dma_free_buffer(page, size);
 	} else {
-- 
1.7.9.5

