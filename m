Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab3LMWdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:33:07 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:44565 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3LMW2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:04 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 075/115] ion: remove IS_ERR_OR_NULL
Date: Fri, 13 Dec 2013 14:24:49 -0800
Message-Id: <1386973529-4884-76-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

IS_ERR_OR_NULL is often part of a bad pattern that can accidentally
return 0 on error:
if (IS_ERR_OR_NULL(ptr))
    return PTR_ERR(ptr);

It also usually means that the errors of a function are not well
defined.  Replace all uses in ion.c by ensure that the return
type of any function in ion is an ERR_PTR.

Specify that the expected return value from map_kernel or map_dma
heap ops is ERR_PTR, and warn if a heap returns NULL.

Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c      | 28 +++++++++++++++-------------
 drivers/staging/android/ion/ion_priv.h |  3 +++
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 93b84a9..54a00fe 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -197,7 +197,9 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 	buffer->size = len;
 
 	table = heap->ops->map_dma(heap, buffer);
-	if (IS_ERR_OR_NULL(table)) {
+	if (WARN_ONCE(table == NULL, "heap->ops->map_dma should return ERR_PTR on error"))
+		table = ERR_PTR(-EINVAL);
+	if (IS_ERR(table)) {
 		heap->ops->free(buffer);
 		kfree(buffer);
 		return ERR_PTR(PTR_ERR(table));
@@ -389,7 +391,7 @@ static struct ion_handle *ion_handle_lookup(struct ion_client *client,
 		if (handle->buffer == buffer)
 			return handle;
 	}
-	return NULL;
+	return ERR_PTR(-EINVAL);
 }
 
 static bool ion_handle_validate(struct ion_client *client, struct ion_handle *handle)
@@ -459,7 +461,7 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 		if (!((1 << heap->id) & heap_id_mask))
 			continue;
 		buffer = ion_buffer_create(heap, dev, len, align, flags);
-		if (!IS_ERR_OR_NULL(buffer))
+		if (!IS_ERR(buffer))
 			break;
 	}
 	up_read(&dev->lock);
@@ -543,7 +545,9 @@ static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
 		return buffer->vaddr;
 	}
 	vaddr = buffer->heap->ops->map_kernel(buffer->heap, buffer);
-	if (IS_ERR_OR_NULL(vaddr))
+	if (WARN_ONCE(vaddr == NULL, "heap->ops->map_kernel should return ERR_PTR on error"))
+		return ERR_PTR(-EINVAL);
+	if (IS_ERR(vaddr))
 		return vaddr;
 	buffer->vaddr = vaddr;
 	buffer->kmap_cnt++;
@@ -560,7 +564,7 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
 		return buffer->vaddr;
 	}
 	vaddr = ion_buffer_kmap_get(buffer);
-	if (IS_ERR_OR_NULL(vaddr))
+	if (IS_ERR(vaddr))
 		return vaddr;
 	handle->kmap_cnt++;
 	return vaddr;
@@ -954,8 +958,6 @@ static int ion_dma_buf_begin_cpu_access(struct dma_buf *dmabuf, size_t start,
 	mutex_unlock(&buffer->lock);
 	if (IS_ERR(vaddr))
 		return PTR_ERR(vaddr);
-	if (!vaddr)
-		return -ENOMEM;
 	return 0;
 }
 
@@ -1034,7 +1036,7 @@ struct ion_handle *ion_import_dma_buf(struct ion_client *client, int fd)
 	struct ion_handle *handle;
 
 	dmabuf = dma_buf_get(fd);
-	if (IS_ERR_OR_NULL(dmabuf))
+	if (IS_ERR(dmabuf))
 		return ERR_PTR(PTR_ERR(dmabuf));
 	/* if this memory came from ion */
 
@@ -1049,12 +1051,12 @@ struct ion_handle *ion_import_dma_buf(struct ion_client *client, int fd)
 	mutex_lock(&client->lock);
 	/* if a handle exists for this buffer just take a reference to it */
 	handle = ion_handle_lookup(client, buffer);
-	if (!IS_ERR_OR_NULL(handle)) {
+	if (!IS_ERR(handle)) {
 		ion_handle_get(handle);
 		goto end;
 	}
 	handle = ion_handle_create(client, buffer);
-	if (IS_ERR_OR_NULL(handle))
+	if (IS_ERR(handle))
 		goto end;
 	ion_handle_add(client, handle);
 end:
@@ -1070,7 +1072,7 @@ static int ion_sync_for_device(struct ion_client *client, int fd)
 	struct ion_buffer *buffer;
 
 	dmabuf = dma_buf_get(fd);
-	if (IS_ERR_OR_NULL(dmabuf))
+	if (IS_ERR(dmabuf))
 		return PTR_ERR(dmabuf);
 
 	/* if this memory came from ion */
@@ -1204,7 +1206,7 @@ static int ion_open(struct inode *inode, struct file *file)
 
 	pr_debug("%s: %d\n", __func__, __LINE__);
 	client = ion_client_create(dev, "user");
-	if (IS_ERR_OR_NULL(client))
+	if (IS_ERR(client))
 		return PTR_ERR(client);
 	file->private_data = client;
 
@@ -1400,7 +1402,7 @@ struct ion_device *ion_device_create(long (*custom_ioctl)
 	}
 
 	idev->debug_root = debugfs_create_dir("ion", NULL);
-	if (IS_ERR_OR_NULL(idev->debug_root))
+	if (!idev->debug_root)
 		pr_err("ion: failed to create debug files.\n");
 
 	idev->custom_ioctl = custom_ioctl;
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 965471a..f263563 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -94,6 +94,9 @@ void ion_buffer_destroy(struct ion_buffer *buffer);
  * @map_kernel		map memory to the kernel
  * @unmap_kernel	unmap memory to the kernel
  * @map_user		map memory to userspace
+ *
+ * allocate, phys, and map_user return 0 on success, -errno on error.
+ * map_dma and map_kernel return pointer on success, ERR_PTR on error.
  */
 struct ion_heap_ops {
 	int (*allocate) (struct ion_heap *heap,
-- 
1.8.3.2

