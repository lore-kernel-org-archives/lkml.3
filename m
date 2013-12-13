Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab3LMWoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:44:00 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50569 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3LMW0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:53 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 030/115] gpu: ion: Fix memory leak of dirty bits
Date: Fri, 13 Dec 2013 14:24:04 -0800
Message-Id: <1386973529-4884-31-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 6ba2c39..3aeb41c 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -164,24 +164,20 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 		return ERR_PTR(PTR_ERR(table));
 	}
 	buffer->sg_table = table;
-	if (buffer->flags & ION_FLAG_CACHED)
+	if (buffer->flags & ION_FLAG_CACHED) {
 		for_each_sg(buffer->sg_table->sgl, sg, buffer->sg_table->nents,
 			    i) {
 			if (sg_dma_len(sg) == PAGE_SIZE)
 				continue;
 			pr_err("%s: cached mappings must have pagewise "
 			       "sg_lists\n", __func__);
-			heap->ops->unmap_dma(heap, buffer);
-			kfree(buffer);
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto err;
 		}
 
-	ret = ion_buffer_alloc_dirty(buffer);
-	if (ret) {
-		heap->ops->unmap_dma(heap, buffer);
-		heap->ops->free(buffer);
-		kfree(buffer);
-		return ERR_PTR(ret);
+		ret = ion_buffer_alloc_dirty(buffer);
+		if (ret)
+			goto err;
 	}
 
 	buffer->dev = dev;
@@ -200,6 +196,12 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 		sg_dma_address(sg) = sg_phys(sg);
 	ion_buffer_add(dev, buffer);
 	return buffer;
+
+err:
+	heap->ops->unmap_dma(heap, buffer);
+	heap->ops->free(buffer);
+	kfree(buffer);
+	return ERR_PTR(ret);
 }
 
 static void ion_buffer_destroy(struct kref *kref)
@@ -209,12 +211,13 @@ static void ion_buffer_destroy(struct kref *kref)
 
 	if (WARN_ON(buffer->kmap_cnt > 0))
 		buffer->heap->ops->unmap_kernel(buffer->heap, buffer);
-
 	buffer->heap->ops->unmap_dma(buffer->heap, buffer);
 	buffer->heap->ops->free(buffer);
 	mutex_lock(&dev->lock);
 	rb_erase(&buffer->node, &dev->buffers);
 	mutex_unlock(&dev->lock);
+	if (buffer->flags & ION_FLAG_CACHED)
+		kfree(buffer->dirty);
 	kfree(buffer);
 }
 
-- 
1.8.3.2

