Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3LMW1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:54 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61349 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3LMW1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:51 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 066/115] gpu: ion: __dma_page_cpu_to_dev -> arm_dma_ops.sync_single_for_device hack
Date: Fri, 13 Dec 2013 14:24:40 -0800
Message-Id: <1386973529-4884-67-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Signed-off-by: Arve Hjønnevåg <arve@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_chunk_heap.c  | 10 ++++++----
 drivers/staging/android/ion/ion_page_pool.c   |  6 ++++--
 drivers/staging/android/ion/ion_system_heap.c |  5 +++--
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 4c2f223..410c08e 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -105,8 +105,9 @@ static void ion_chunk_heap_free(struct ion_buffer *buffer)
 
 	for_each_sg(table->sgl, sg, table->nents, i) {
 		if (ion_buffer_cached(buffer))
-			__dma_page_cpu_to_dev(sg_page(sg), 0, sg_dma_len(sg),
-					      DMA_BIDIRECTIONAL);
+			arm_dma_ops.sync_single_for_device(NULL,
+				pfn_to_dma(NULL, page_to_pfn(sg_page(sg))),
+				sg_dma_len(sg), DMA_BIDIRECTIONAL);
 		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
 			      sg_dma_len(sg));
 	}
@@ -177,8 +178,9 @@ struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 	}
 	free_vm_area(vm_struct);
 
-	__dma_page_cpu_to_dev(phys_to_page(heap_data->base), 0, heap_data->size,
-			      DMA_BIDIRECTIONAL);
+	arm_dma_ops.sync_single_for_device(NULL,
+		pfn_to_dma(NULL, page_to_pfn(phys_to_page(heap_data->base))),
+		heap_data->size, DMA_BIDIRECTIONAL);
 	gen_pool_add(chunk_heap->pool, chunk_heap->base, heap_data->size, -1);
 	chunk_heap->heap.ops = &chunk_heap_ops;
 	chunk_heap->heap.type = ION_HEAP_TYPE_CHUNK;
diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index d624dee..855f30c 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -37,8 +37,10 @@ static void *ion_page_pool_alloc_pages(struct ion_page_pool *pool)
 	/* this is only being used to flush the page for dma,
 	   this api is not really suitable for calling from a driver
 	   but no better way to flush a page for dma exist at this time */
-	__dma_page_cpu_to_dev(page, 0, PAGE_SIZE << pool->order,
-			      DMA_BIDIRECTIONAL);
+	arm_dma_ops.sync_single_for_device(NULL,
+					   pfn_to_dma(NULL, page_to_pfn(page)),
+					   PAGE_SIZE << pool->order,
+					   DMA_BIDIRECTIONAL);
 	return page;
 }
 
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index fedbc0d..d4f0a56 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -78,8 +78,9 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 		page = alloc_pages(gfp_flags, order);
 		if (!page)
 			return 0;
-		__dma_page_cpu_to_dev(page, 0, PAGE_SIZE << order,
-				      DMA_BIDIRECTIONAL);
+		arm_dma_ops.sync_single_for_device(NULL,
+			pfn_to_dma(NULL, page_to_pfn(page)),
+			PAGE_SIZE << order, DMA_BIDIRECTIONAL);
 	}
 	if (!page)
 		return 0;
-- 
1.8.3.2

