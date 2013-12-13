Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3LMW2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:28:06 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33273 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3LMW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:00 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 072/115] ion: chunk_heap: fix leak in allocated counter
Date: Fri, 13 Dec 2013 14:24:46 -0800
Message-Id: <1386973529-4884-73-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

buffer->size is controlled by the outer ion layer, don't modify it
inside the heap.  Instead, compute the rounded up allocated size
on demand.

Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_chunk_heap.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 410c08e..85fefe7 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -47,15 +47,15 @@ static int ion_chunk_heap_allocate(struct ion_heap *heap,
 	struct scatterlist *sg;
 	int ret, i;
 	unsigned long num_chunks;
+	unsigned long allocated_size;
 
 	if (ion_buffer_fault_user_mappings(buffer))
 		return -ENOMEM;
 
-	num_chunks = ALIGN(size, chunk_heap->chunk_size) /
-		chunk_heap->chunk_size;
-	buffer->size = num_chunks * chunk_heap->chunk_size;
+	allocated_size = ALIGN(size, chunk_heap->chunk_size);
+	num_chunks = allocated_size / chunk_heap->chunk_size;
 
-	if (buffer->size > chunk_heap->size - chunk_heap->allocated)
+	if (allocated_size > chunk_heap->size - chunk_heap->allocated)
 		return -ENOMEM;
 
 	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
@@ -78,7 +78,7 @@ static int ion_chunk_heap_allocate(struct ion_heap *heap,
 	}
 
 	buffer->priv_virt = table;
-	chunk_heap->allocated += buffer->size;
+	chunk_heap->allocated += allocated_size;
 	return 0;
 err:
 	sg = table->sgl;
@@ -100,6 +100,9 @@ static void ion_chunk_heap_free(struct ion_buffer *buffer)
 	struct sg_table *table = buffer->priv_virt;
 	struct scatterlist *sg;
 	int i;
+	unsigned long allocated_size;
+
+	allocated_size = ALIGN(buffer->size, chunk_heap->chunk_size);
 
 	ion_heap_buffer_zero(buffer);
 
@@ -111,7 +114,7 @@ static void ion_chunk_heap_free(struct ion_buffer *buffer)
 		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
 			      sg_dma_len(sg));
 	}
-	chunk_heap->allocated -= buffer->size;
+	chunk_heap->allocated -= allocated_size;
 	sg_free_table(table);
 	kfree(table);
 }
-- 
1.8.3.2

