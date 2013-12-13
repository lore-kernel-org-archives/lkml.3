Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab3LMWte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:49:34 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44192 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3LMW0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:19 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 008/115] gpu: ion: support begin/end and kmap/kunmap dma_buf ops
Date: Fri, 13 Dec 2013 14:23:42 -0800
Message-Id: <1386973529-4884-9-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

These ops were added in the 3.4 kernel.  This patch adds support
for them to ion.  Previous ion_map/unmap_kernel api is also
retained in addition to this new api.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 88 +++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 75bf8f2..8937618 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -391,6 +391,22 @@ int ion_phys(struct ion_client *client, struct ion_handle *handle,
 	return ret;
 }
 
+static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
+{
+	void *vaddr;
+
+	if (buffer->kmap_cnt) {
+		buffer->kmap_cnt++;
+		return buffer->vaddr;
+	}
+	vaddr = buffer->heap->ops->map_kernel(buffer->heap, buffer);
+	if (IS_ERR_OR_NULL(vaddr))
+		return vaddr;
+	buffer->vaddr = vaddr;
+	buffer->kmap_cnt++;
+	return vaddr;
+}
+
 static void *ion_handle_kmap_get(struct ion_handle *handle)
 {
 	struct ion_buffer *buffer = handle->buffer;
@@ -399,34 +415,30 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
 	if (handle->kmap_cnt) {
 		handle->kmap_cnt++;
 		return buffer->vaddr;
-	} else if (buffer->kmap_cnt) {
-		handle->kmap_cnt++;
-		buffer->kmap_cnt++;
-		return buffer->vaddr;
 	}
-
-	vaddr = buffer->heap->ops->map_kernel(buffer->heap, buffer);
-	buffer->vaddr = vaddr;
-	if (IS_ERR_OR_NULL(vaddr)) {
-		buffer->vaddr = NULL;
+	vaddr = ion_buffer_kmap_get(buffer);
+	if (IS_ERR_OR_NULL(vaddr))
 		return vaddr;
-	}
 	handle->kmap_cnt++;
-	buffer->kmap_cnt++;
 	return vaddr;
 }
 
+static void ion_buffer_kmap_put(struct ion_buffer *buffer)
+{
+	buffer->kmap_cnt--;
+	if (!buffer->kmap_cnt) {
+		buffer->heap->ops->unmap_kernel(buffer->heap, buffer);
+		buffer->vaddr = NULL;
+	}
+}
+
 static void ion_handle_kmap_put(struct ion_handle *handle)
 {
 	struct ion_buffer *buffer = handle->buffer;
 
 	handle->kmap_cnt--;
 	if (!handle->kmap_cnt)
-		buffer->kmap_cnt--;
-	if (!buffer->kmap_cnt) {
-		buffer->heap->ops->unmap_kernel(buffer->heap, buffer);
-		buffer->vaddr = NULL;
-	}
+		ion_buffer_kmap_put(buffer);
 }
 
 void *ion_map_kernel(struct ion_client *client, struct ion_handle *handle)
@@ -675,7 +687,8 @@ static void ion_dma_buf_release(struct dma_buf *dmabuf)
 
 static void *ion_dma_buf_kmap(struct dma_buf *dmabuf, unsigned long offset)
 {
-	return NULL;
+	struct ion_buffer *buffer = dmabuf->priv;
+	return buffer->vaddr + offset;
 }
 
 static void ion_dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long offset,
@@ -684,26 +697,49 @@ static void ion_dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long offset,
 	return;
 }
 
-static void *ion_dma_buf_kmap_atomic(struct dma_buf *dmabuf,
-				     unsigned long offset)
+static int ion_dma_buf_begin_cpu_access(struct dma_buf *dmabuf, size_t start,
+					size_t len,
+					enum dma_data_direction direction)
 {
-	return NULL;
+	struct ion_buffer *buffer = dmabuf->priv;
+	void *vaddr;
+
+	if (!buffer->heap->ops->map_kernel) {
+		pr_err("%s: map kernel is not implemented by this heap.\n",
+		       __func__);
+		return -ENODEV;
+	}
+
+	mutex_lock(&buffer->lock);
+	vaddr = ion_buffer_kmap_get(buffer);
+	mutex_unlock(&buffer->lock);
+	if (IS_ERR(vaddr))
+		return PTR_ERR(vaddr);
+	if (!vaddr)
+		return -ENOMEM;
+	return 0;
 }
 
-static void ion_dma_buf_kunmap_atomic(struct dma_buf *dmabuf,
-				      unsigned long offset, void *ptr)
+static void ion_dma_buf_end_cpu_access(struct dma_buf *dmabuf, size_t start,
+				       size_t len,
+				       enum dma_data_direction direction)
 {
-	return;
-}
+	struct ion_buffer *buffer = dmabuf->priv;
 
+	mutex_lock(&buffer->lock);
+	ion_buffer_kmap_put(buffer);
+	mutex_unlock(&buffer->lock);
+}
 
 struct dma_buf_ops dma_buf_ops = {
 	.map_dma_buf = ion_map_dma_buf,
 	.unmap_dma_buf = ion_unmap_dma_buf,
 	.mmap = ion_mmap,
 	.release = ion_dma_buf_release,
-	.kmap_atomic = ion_dma_buf_kmap_atomic,
-	.kunmap_atomic = ion_dma_buf_kunmap_atomic,
+	.begin_cpu_access = ion_dma_buf_begin_cpu_access,
+	.end_cpu_access = ion_dma_buf_end_cpu_access,
+	.kmap_atomic = ion_dma_buf_kmap,
+	.kunmap_atomic = ion_dma_buf_kunmap,
 	.kmap = ion_dma_buf_kmap,
 	.kunmap = ion_dma_buf_kunmap,
 };
-- 
1.8.3.2

