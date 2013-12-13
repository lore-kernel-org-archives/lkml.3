Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab3LMWvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:51:05 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51006 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3LMW0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:08 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 003/115] ion: Switch map/unmap dma api to sg_tables
Date: Fri, 13 Dec 2013 14:23:37 -0800
Message-Id: <1386973529-4884-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Switch these api's from scatterlists to sg_tables

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c             | 16 +++----
 drivers/staging/android/ion/ion.h             |  6 +--
 drivers/staging/android/ion/ion_priv.h        | 18 ++------
 drivers/staging/android/ion/ion_system_heap.c | 66 ++++++++++++++++-----------
 4 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index d93fb33..bca8d9e 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -445,11 +445,11 @@ void *ion_map_kernel(struct ion_client *client, struct ion_handle *handle)
 	return vaddr;
 }
 
-struct scatterlist *ion_map_dma(struct ion_client *client,
+struct sg_table *ion_map_dma(struct ion_client *client,
 				struct ion_handle *handle)
 {
 	struct ion_buffer *buffer;
-	struct scatterlist *sglist;
+	struct sg_table *table;
 
 	mutex_lock(&client->lock);
 	if (!ion_handle_validate(client, handle)) {
@@ -469,16 +469,16 @@ struct scatterlist *ion_map_dma(struct ion_client *client,
 		return ERR_PTR(-ENODEV);
 	}
 	if (_ion_map(&buffer->dmap_cnt, &handle->dmap_cnt)) {
-		sglist = buffer->heap->ops->map_dma(buffer->heap, buffer);
-		if (IS_ERR_OR_NULL(sglist))
+		table = buffer->heap->ops->map_dma(buffer->heap, buffer);
+		if (IS_ERR_OR_NULL(table))
 			_ion_unmap(&buffer->dmap_cnt, &handle->dmap_cnt);
-		buffer->sglist = sglist;
+		buffer->sg_table = table;
 	} else {
-		sglist = buffer->sglist;
+		table = buffer->sg_table;
 	}
 	mutex_unlock(&buffer->lock);
 	mutex_unlock(&client->lock);
-	return sglist;
+	return table;
 }
 
 void ion_unmap_kernel(struct ion_client *client, struct ion_handle *handle)
@@ -505,7 +505,7 @@ void ion_unmap_dma(struct ion_client *client, struct ion_handle *handle)
 	mutex_lock(&buffer->lock);
 	if (_ion_unmap(&buffer->dmap_cnt, &handle->dmap_cnt)) {
 		buffer->heap->ops->unmap_dma(buffer->heap, buffer);
-		buffer->sglist = NULL;
+		buffer->sg_table = NULL;
 	}
 	mutex_unlock(&buffer->lock);
 	mutex_unlock(&client->lock);
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 60b2543..87f6a45 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -169,10 +169,10 @@ void ion_unmap_kernel(struct ion_client *client, struct ion_handle *handle);
  * @client:	the client
  * @handle:	handle to map
  *
- * Return an sglist describing the given handle
+ * Return an sg_table describing the given handle
  */
-struct scatterlist *ion_map_dma(struct ion_client *client,
-				struct ion_handle *handle);
+struct sg_table *ion_map_dma(struct ion_client *client,
+			     struct ion_handle *handle);
 
 /**
  * ion_unmap_dma() - destroy a dma mapping for a handle
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index cbd9f03..7a77f6f 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -24,18 +24,6 @@
 
 #include "ion.h"
 
-struct ion_mapping;
-
-struct ion_dma_mapping {
-	struct kref ref;
-	struct scatterlist *sglist;
-};
-
-struct ion_kernel_mapping {
-	struct kref ref;
-	void *vaddr;
-};
-
 struct ion_buffer *ion_handle_buffer(struct ion_handle *handle);
 
 /**
@@ -54,7 +42,7 @@ struct ion_buffer *ion_handle_buffer(struct ion_handle *handle);
  * @kmap_cnt:		number of times the buffer is mapped to the kernel
  * @vaddr:		the kenrel mapping if kmap_cnt is not zero
  * @dmap_cnt:		number of times the buffer is mapped for dma
- * @sglist:		the scatterlist for the buffer is dmap_cnt is not zero
+ * @sg_table:		the sg table for the buffer if dmap_cnt is not zero
 */
 struct ion_buffer {
 	struct kref ref;
@@ -71,7 +59,7 @@ struct ion_buffer {
 	int kmap_cnt;
 	void *vaddr;
 	int dmap_cnt;
-	struct scatterlist *sglist;
+	struct sg_table *sg_table;
 };
 
 /**
@@ -93,7 +81,7 @@ struct ion_heap_ops {
 	void (*free) (struct ion_buffer *buffer);
 	int (*phys) (struct ion_heap *heap, struct ion_buffer *buffer,
 		     ion_phys_addr_t *addr, size_t *len);
-	struct scatterlist *(*map_dma) (struct ion_heap *heap,
+	struct sg_table *(*map_dma) (struct ion_heap *heap,
 					struct ion_buffer *buffer);
 	void (*unmap_dma) (struct ion_heap *heap, struct ion_buffer *buffer);
 	void * (*map_kernel) (struct ion_heap *heap, struct ion_buffer *buffer);
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 3daa1ee..d7e0fa0 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -38,40 +38,46 @@ void ion_system_heap_free(struct ion_buffer *buffer)
 	vfree(buffer->priv_virt);
 }
 
-struct scatterlist *ion_system_heap_map_dma(struct ion_heap *heap,
-					    struct ion_buffer *buffer)
+struct sg_table *ion_system_heap_map_dma(struct ion_heap *heap,
+					 struct ion_buffer *buffer)
 {
-	struct scatterlist *sglist;
-	struct page *page;
+	struct sg_table *table;
+	struct scatterlist *sg;
 	int i;
 	int npages = PAGE_ALIGN(buffer->size) / PAGE_SIZE;
 	void *vaddr = buffer->priv_virt;
+	int ret;
 
-	sglist = vmalloc(npages * sizeof(struct scatterlist));
-	if (!sglist)
+	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
+	if (!table)
 		return ERR_PTR(-ENOMEM);
-	memset(sglist, 0, npages * sizeof(struct scatterlist));
-	sg_init_table(sglist, npages);
-	for (i = 0; i < npages; i++) {
+	ret = sg_alloc_table(table, npages, GFP_KERNEL);
+	if (ret)
+		goto err0;
+	for_each_sg(table->sgl, sg, table->nents, i) {
+		struct page *page;
 		page = vmalloc_to_page(vaddr);
-		if (!page)
-			goto end;
-		sg_set_page(&sglist[i], page, PAGE_SIZE, 0);
+		if (!page) {
+			ret = -ENOMEM;
+			goto err1;
+		}
+		sg_set_page(sg, page, PAGE_SIZE, 0);
 		vaddr += PAGE_SIZE;
 	}
-	/* XXX do cache maintenance for dma? */
-	return sglist;
-end:
-	vfree(sglist);
-	return NULL;
+	return table;
+err1:
+	sg_free_table(table);
+err0:
+	kfree(table);
+	return ERR_PTR(ret);
 }
 
 void ion_system_heap_unmap_dma(struct ion_heap *heap,
 			       struct ion_buffer *buffer)
 {
-	/* XXX undo cache maintenance for dma? */
-	if (buffer->sglist)
-		vfree(buffer->sglist);
+	if (buffer->sg_table)
+		sg_free_table(buffer->sg_table);
+	kfree(buffer->sg_table);
 }
 
 void *ion_system_heap_map_kernel(struct ion_heap *heap,
@@ -144,17 +150,23 @@ static int ion_system_contig_heap_phys(struct ion_heap *heap,
 	return 0;
 }
 
-struct scatterlist *ion_system_contig_heap_map_dma(struct ion_heap *heap,
+struct sg_table *ion_system_contig_heap_map_dma(struct ion_heap *heap,
 						   struct ion_buffer *buffer)
 {
-	struct scatterlist *sglist;
+	struct sg_table *table;
+	int ret;
 
-	sglist = vmalloc(sizeof(struct scatterlist));
-	if (!sglist)
+	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
+	if (!table)
 		return ERR_PTR(-ENOMEM);
-	sg_init_table(sglist, 1);
-	sg_set_page(sglist, virt_to_page(buffer->priv_virt), buffer->size, 0);
-	return sglist;
+	ret = sg_alloc_table(table, 1, GFP_KERNEL);
+	if (ret) {
+		kfree(table);
+		return ERR_PTR(ret);
+	}
+	sg_set_page(table->sgl, virt_to_page(buffer->priv_virt), buffer->size,
+		    0);
+	return table;
 }
 
 int ion_system_contig_heap_map_user(struct ion_heap *heap,
-- 
1.8.3.2

