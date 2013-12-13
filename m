Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3LMW1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:49 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:45380 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3LMW1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:46 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 063/115] gpu: ion: ion_chunk_heap: Zero chunk heap memory at creation time
Date: Fri, 13 Dec 2013 14:24:37 -0800
Message-Id: <1386973529-4884-64-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Allocations from the ion heap need to be zeroed to protect userspace
from seeing memory belonging to other processes.  First allocations
from this heap were not zero'd allowing users to see memory from other
processes on a warm reset.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_chunk_heap.c | 34 ++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index ac7cf13..4c2f223 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -140,6 +140,10 @@ static struct ion_heap_ops chunk_heap_ops = {
 struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 {
 	struct ion_chunk_heap *chunk_heap;
+	struct vm_struct *vm_struct;
+	pgprot_t pgprot = pgprot_writecombine(PAGE_KERNEL);
+	int i, ret;
+
 
 	chunk_heap = kzalloc(sizeof(struct ion_chunk_heap), GFP_KERNEL);
 	if (!chunk_heap)
@@ -149,12 +153,30 @@ struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 	chunk_heap->pool = gen_pool_create(get_order(chunk_heap->chunk_size) +
 					   PAGE_SHIFT, -1);
 	if (!chunk_heap->pool) {
-		kfree(chunk_heap);
-		return ERR_PTR(-ENOMEM);
+		ret = -ENOMEM;
+		goto error_gen_pool_create;
 	}
 	chunk_heap->base = heap_data->base;
 	chunk_heap->size = heap_data->size;
 	chunk_heap->allocated = 0;
+
+	vm_struct = get_vm_area(PAGE_SIZE, VM_ALLOC);
+	if (!vm_struct) {
+		ret = -ENOMEM;
+		goto error;
+	}
+	for (i = 0; i < chunk_heap->size; i += PAGE_SIZE) {
+		struct page *page = phys_to_page(chunk_heap->base + i);
+		struct page **pages = &page;
+
+		ret = map_vm_area(vm_struct, pgprot, &pages);
+		if (ret)
+			goto error_map_vm_area;
+		memset(vm_struct->addr, 0, PAGE_SIZE);
+		unmap_kernel_range((unsigned long)vm_struct->addr, PAGE_SIZE);
+	}
+	free_vm_area(vm_struct);
+
 	__dma_page_cpu_to_dev(phys_to_page(heap_data->base), 0, heap_data->size,
 			      DMA_BIDIRECTIONAL);
 	gen_pool_add(chunk_heap->pool, chunk_heap->base, heap_data->size, -1);
@@ -165,6 +187,14 @@ struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 		heap_data->size, heap_data->align);
 
 	return &chunk_heap->heap;
+
+error_map_vm_area:
+	free_vm_area(vm_struct);
+error:
+	gen_pool_destroy(chunk_heap->pool);
+error_gen_pool_create:
+	kfree(chunk_heap);
+	return ERR_PTR(ret);
 }
 
 void ion_chunk_heap_destroy(struct ion_heap *heap)
-- 
1.8.3.2

