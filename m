Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3LMWnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:43:41 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:37577 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3LMW04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:56 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 032/115] gpu: ion: optimize system heap for non fault buffers
Date: Fri, 13 Dec 2013 14:24:06 -0800
Message-Id: <1386973529-4884-33-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

If a buffer's user mappings are not going to be faulted
in it need not be allocated page wise.  We can optimize
this common case by allocating an sglist of larger chunks
rather than creating an entry for each page in the
allocation.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c             | 21 ++++++++------
 drivers/staging/android/ion/ion_priv.h        |  9 ++++++
 drivers/staging/android/ion/ion_system_heap.c | 40 ++++++++++++++++++++-------
 3 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index d1c7b84..6c589cb 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -100,6 +100,12 @@ struct ion_handle {
 	unsigned int kmap_cnt;
 };
 
+bool ion_buffer_fault_user_mappings(struct ion_buffer *buffer)
+{
+        return ((buffer->flags & ION_FLAG_CACHED) &&
+                !(buffer->flags & ION_FLAG_CACHED_NEEDS_SYNC));
+}
+
 /* this function should only be called while dev->lock is held */
 static void ion_buffer_add(struct ion_device *dev,
 			   struct ion_buffer *buffer)
@@ -145,6 +151,7 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 		return ERR_PTR(-ENOMEM);
 
 	buffer->heap = heap;
+	buffer->flags = flags;
 	kref_init(&buffer->ref);
 
 	ret = heap->ops->allocate(heap, buffer, len, align, flags);
@@ -155,7 +162,6 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 
 	buffer->dev = dev;
 	buffer->size = len;
-	buffer->flags = flags;
 
 	table = heap->ops->map_dma(heap, buffer);
 	if (IS_ERR_OR_NULL(table)) {
@@ -164,14 +170,13 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 		return ERR_PTR(PTR_ERR(table));
 	}
 	buffer->sg_table = table;
-	if (buffer->flags & ION_FLAG_CACHED &&
-	    !(buffer->flags & ION_FLAG_CACHED_NEEDS_SYNC)) {
+	if (ion_buffer_fault_user_mappings(buffer)) {
 		for_each_sg(buffer->sg_table->sgl, sg, buffer->sg_table->nents,
 			    i) {
 			if (sg_dma_len(sg) == PAGE_SIZE)
 				continue;
-			pr_err("%s: cached mappings must have pagewise "
-			       "sg_lists\n", __func__);
+			pr_err("%s: cached mappings that will be faulted in "
+			       "must have pagewise sg_lists\n", __func__);
 			ret = -EINVAL;
 			goto err;
 		}
@@ -764,8 +769,7 @@ static void ion_buffer_sync_for_device(struct ion_buffer *buffer,
 	pr_debug("%s: syncing for device %s\n", __func__,
 		 dev ? dev_name(dev) : "null");
 
-	if (!(buffer->flags & ION_FLAG_CACHED) ||
-	    (buffer->flags & ION_FLAG_CACHED_NEEDS_SYNC))
+	if (!ion_buffer_fault_user_mappings(buffer))
 		return;
 
 	mutex_lock(&buffer->lock);
@@ -855,8 +859,7 @@ static int ion_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
-	if (buffer->flags & ION_FLAG_CACHED &&
-	    !(buffer->flags & ION_FLAG_CACHED_NEEDS_SYNC)) {
+	if (ion_buffer_fault_user_mappings(buffer)) {
 		vma->vm_private_data = buffer;
 		vma->vm_ops = &ion_vma_ops;
 		ion_vm_open(vma);
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index dabe1e8..1027ef4 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -132,6 +132,15 @@ struct ion_heap {
 };
 
 /**
+ * ion_buffer_fault_user_mappings - fault in user mappings of this buffer
+ * @buffer:		buffer
+ *
+ * indicates whether userspace mappings of this buffer will be faulted
+ * in, this can affect how buffers are allocated from the heap.
+ */
+bool ion_buffer_fault_user_mappings(struct ion_buffer *buffer);
+
+/**
  * ion_device_create - allocates and returns an ion device
  * @custom_ioctl:	arch specific ioctl function if applicable
  *
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 2fb9a64..ef8afc7 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -31,7 +31,8 @@ struct page_info {
 	struct list_head list;
 };
 
-static struct page_info *alloc_largest_available(unsigned long size)
+static struct page_info *alloc_largest_available(unsigned long size,
+						 bool split_pages)
 {
 	static unsigned int orders[] = {8, 4, 0};
 	struct page *page;
@@ -45,7 +46,8 @@ static struct page_info *alloc_largest_available(unsigned long size)
 				   __GFP_NOWARN | __GFP_NORETRY, orders[i]);
 		if (!page)
 			continue;
-		split_page(page, orders[i]);
+		if (split_pages)
+			split_page(page, orders[i]);
 		info = kmalloc(sizeof(struct page_info *), GFP_KERNEL);
 		info->page = page;
 		info->order = orders[i];
@@ -64,35 +66,49 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	int ret;
 	struct list_head pages;
 	struct page_info *info, *tmp_info;
-	int i;
+	int i = 0;
 	long size_remaining = PAGE_ALIGN(size);
+	bool split_pages = ion_buffer_fault_user_mappings(buffer);
+
 
 	INIT_LIST_HEAD(&pages);
 	while (size_remaining > 0) {
-		info = alloc_largest_available(size_remaining);
+		info = alloc_largest_available(size_remaining, split_pages);
 		if (!info)
 			goto err;
 		list_add_tail(&info->list, &pages);
 		size_remaining -= (1 << info->order) * PAGE_SIZE;
+		i++;
 	}
 
 	table = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
 	if (!table)
 		goto err;
 
-	ret = sg_alloc_table(table, PAGE_ALIGN(size) / PAGE_SIZE, GFP_KERNEL);
+	if (split_pages)
+		ret = sg_alloc_table(table, PAGE_ALIGN(size) / PAGE_SIZE,
+				     GFP_KERNEL);
+	else
+		ret = sg_alloc_table(table, i, GFP_KERNEL);
+
 	if (ret)
 		goto err1;
 
 	sg = table->sgl;
 	list_for_each_entry_safe(info, tmp_info, &pages, list) {
 		struct page *page = info->page;
-		for (i = 0; i < (1 << info->order); i++) {
-			sg_set_page(sg, page + i, PAGE_SIZE, 0);
+
+		if (split_pages) {
+			for (i = 0; i < (1 << info->order); i++) {
+				sg_set_page(sg, page + i, PAGE_SIZE, 0);
+				sg = sg_next(sg);
+			}
+		} else {
+			sg_set_page(sg, page, (1 << info->order) * PAGE_SIZE,
+				    0);
 			sg = sg_next(sg);
 		}
 		list_del(&info->list);
-		memset(info, 0, sizeof(struct page_info));
 		kfree(info);
 	}
 
@@ -105,8 +121,12 @@ err1:
 	kfree(table);
 err:
 	list_for_each_entry(info, &pages, list) {
-		for (i = 0; i < (1 << info->order); i++)
-			__free_page(info->page + i);
+		if (split_pages)
+			for (i = 0; i < (1 << info->order); i++)
+				__free_page(info->page + i);
+		else
+			__free_pages(info->page, info->order);
+
 		kfree(info);
 	}
 	return -ENOMEM;
-- 
1.8.3.2

