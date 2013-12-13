Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab3LMWsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:48:53 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51857 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab3LMW0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:21 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 009/115] gpu: ion: Allocate the sg_table at creation time rather than dynamically
Date: Fri, 13 Dec 2013 14:23:43 -0800
Message-Id: <1386973529-4884-10-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Rather than calling map_dma on the allocations dynamically, this patch
switches to creating the sg_table at the time the buffer is created.
This is necessary because in future updates the sg_table will be used
for cache maintenance.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 79 ++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 8937618..b95202b 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -135,6 +135,7 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 				     unsigned long flags)
 {
 	struct ion_buffer *buffer;
+	struct sg_table *table;
 	int ret;
 
 	buffer = kzalloc(sizeof(struct ion_buffer), GFP_KERNEL);
@@ -149,6 +150,15 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 		kfree(buffer);
 		return ERR_PTR(ret);
 	}
+
+	table = buffer->heap->ops->map_dma(buffer->heap, buffer);
+	if (IS_ERR_OR_NULL(table)) {
+		heap->ops->free(buffer);
+		kfree(buffer);
+		return ERR_PTR(PTR_ERR(table));
+	}
+	buffer->sg_table = table;
+
 	buffer->dev = dev;
 	buffer->size = len;
 	mutex_init(&buffer->lock);
@@ -164,9 +174,7 @@ static void ion_buffer_destroy(struct kref *kref)
 	if (WARN_ON(buffer->kmap_cnt > 0))
 		buffer->heap->ops->unmap_kernel(buffer->heap, buffer);
 
-	if (WARN_ON(buffer->dmap_cnt > 0))
-		buffer->heap->ops->unmap_dma(buffer->heap, buffer);
-
+	buffer->heap->ops->unmap_dma(buffer->heap, buffer);
 	buffer->heap->ops->free(buffer);
 	mutex_lock(&dev->lock);
 	rb_erase(&buffer->node, &dev->buffers);
@@ -346,6 +354,7 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 		mutex_unlock(&client->lock);
 	}
 
+
 	return handle;
 }
 
@@ -607,53 +616,42 @@ void ion_client_destroy(struct ion_client *client)
 	kfree(client);
 }
 
-static struct sg_table *ion_map_dma_buf(struct dma_buf_attachment *attachment,
-					enum dma_data_direction direction)
+struct sg_table *ion_map_dma(struct ion_client *client,
+			     struct ion_handle *handle)
 {
-	struct dma_buf *dmabuf = attachment->dmabuf;
-	struct ion_buffer *buffer = dmabuf->priv;
+	struct ion_buffer *buffer;
 	struct sg_table *table;
 
-	mutex_lock(&buffer->lock);
-
-	if (!buffer->heap->ops->map_dma) {
-		pr_err("%s: map_dma is not implemented by this heap.\n",
+	mutex_lock(&client->lock);
+	if (!ion_handle_validate(client, handle)) {
+		pr_err("%s: invalid handle passed to map_dma.\n",
 		       __func__);
-		mutex_unlock(&buffer->lock);
-		return ERR_PTR(-ENODEV);
-	}
-	/* if an sg list already exists for this buffer just return it */
-	if (buffer->dmap_cnt) {
-		table = buffer->sg_table;
-		goto end;
+		mutex_unlock(&client->lock);
+		return ERR_PTR(-EINVAL);
 	}
-
-	/* otherwise call into the heap to create one */
-	table = buffer->heap->ops->map_dma(buffer->heap, buffer);
-	if (IS_ERR_OR_NULL(table))
-		goto err;
-	buffer->sg_table = table;
-end:
-	buffer->dmap_cnt++;
-err:
-	mutex_unlock(&buffer->lock);
+	buffer = handle->buffer;
+	table = buffer->sg_table;
+	mutex_unlock(&client->lock);
 	return table;
 }
 
-static void ion_unmap_dma_buf(struct dma_buf_attachment *attachment,
-			      struct sg_table *table,
-			      enum dma_data_direction direction)
+void ion_unmap_dma(struct ion_client *client, struct ion_handle *handle)
+{
+}
+
+static struct sg_table *ion_map_dma_buf(struct dma_buf_attachment *attachment,
+					enum dma_data_direction direction)
 {
 	struct dma_buf *dmabuf = attachment->dmabuf;
 	struct ion_buffer *buffer = dmabuf->priv;
 
-	mutex_lock(&buffer->lock);
-	buffer->dmap_cnt--;
-	if (!buffer->dmap_cnt) {
-		buffer->heap->ops->unmap_dma(buffer->heap, buffer);
-		buffer->sg_table = NULL;
-	}
-	mutex_unlock(&buffer->lock);
+	return buffer->sg_table;
+}
+
+static void ion_unmap_dma_buf(struct dma_buf_attachment *attachment,
+			      struct sg_table *table,
+			      enum dma_data_direction direction)
+{
 }
 
 static int ion_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
@@ -987,6 +985,11 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 	struct rb_node *parent = NULL;
 	struct ion_heap *entry;
 
+	if (!heap->ops->allocate || !heap->ops->free || !heap->ops->map_dma ||
+	    !heap->ops->unmap_dma)
+		pr_err("%s: can not add heap with invalid ops struct.\n",
+		       __func__);
+
 	heap->dev = dev;
 	mutex_lock(&dev->lock);
 	while (*p) {
-- 
1.8.3.2

