Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab3LMW05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:26:57 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36007 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3LMW0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:55 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 031/115] gpu: ion: Add support for cached mappings that don't fault
Date: Fri, 13 Dec 2013 14:24:05 -0800
Message-Id: <1386973529-4884-32-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

We have found that faulting in the mappings for cached
allocations has a significant performance impact and is
only a benefit if only a small part of the buffer is
touched by the cpu (an uncommon case for software rendering).
This patch introduces a ION_FLAG_CACHED_NEEDS_SYNC
which determines whether a mapping should be created by
faulting or at mmap time.  If this flag is set,
userspace must manage the caches explictly using the SYNC ioctl.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 28 ++++++++++++++++++----------
 drivers/staging/android/ion/ion.h |  3 +++
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 3aeb41c..d1c7b84 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -164,7 +164,8 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 		return ERR_PTR(PTR_ERR(table));
 	}
 	buffer->sg_table = table;
-	if (buffer->flags & ION_FLAG_CACHED) {
+	if (buffer->flags & ION_FLAG_CACHED &&
+	    !(buffer->flags & ION_FLAG_CACHED_NEEDS_SYNC)) {
 		for_each_sg(buffer->sg_table->sgl, sg, buffer->sg_table->nents,
 			    i) {
 			if (sg_dma_len(sg) == PAGE_SIZE)
@@ -763,7 +764,8 @@ static void ion_buffer_sync_for_device(struct ion_buffer *buffer,
 	pr_debug("%s: syncing for device %s\n", __func__,
 		 dev ? dev_name(dev) : "null");
 
-	if (!(buffer->flags & ION_FLAG_CACHED))
+	if (!(buffer->flags & ION_FLAG_CACHED) ||
+	    (buffer->flags & ION_FLAG_CACHED_NEEDS_SYNC))
 		return;
 
 	mutex_lock(&buffer->lock);
@@ -853,18 +855,22 @@ static int ion_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
-	if (buffer->flags & ION_FLAG_CACHED) {
+	if (buffer->flags & ION_FLAG_CACHED &&
+	    !(buffer->flags & ION_FLAG_CACHED_NEEDS_SYNC)) {
 		vma->vm_private_data = buffer;
 		vma->vm_ops = &ion_vma_ops;
 		ion_vm_open(vma);
-	} else {
-		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-		mutex_lock(&buffer->lock);
-		/* now map it to userspace */
-		ret = buffer->heap->ops->map_user(buffer->heap, buffer, vma);
-		mutex_unlock(&buffer->lock);
+		return 0;
 	}
 
+	if (!(buffer->flags & ION_FLAG_CACHED))
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+
+	mutex_lock(&buffer->lock);
+	/* now map it to userspace */
+	ret = buffer->heap->ops->map_user(buffer->heap, buffer, vma);
+	mutex_unlock(&buffer->lock);
+
 	if (ret)
 		pr_err("%s: failure mapping buffer to userspace\n",
 		       __func__);
@@ -1021,7 +1027,9 @@ static int ion_sync_for_device(struct ion_client *client, int fd)
 		return -EINVAL;
 	}
 	buffer = dmabuf->priv;
-	ion_buffer_sync_for_device(buffer, NULL, DMA_BIDIRECTIONAL);
+
+	dma_sync_sg_for_device(NULL, buffer->sg_table->sgl,
+			       buffer->sg_table->nents, DMA_BIDIRECTIONAL);
 	dma_buf_put(dmabuf);
 	return 0;
 }
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 83baa38..072d64d 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -50,6 +50,9 @@ enum ion_heap_type {
 					   cached, ion will do cache
 					   maintenance when the buffer is
 					   mapped for dma */
+#define ION_FLAG_CACHED_NEEDS_SYNC 2	/* mappings of this buffer will created
+					   at mmap time, if this is set
+					   caches must be managed manually */
 
 #ifdef __KERNEL__
 struct ion_device;
-- 
1.8.3.2

