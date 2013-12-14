Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab3LND1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:53 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48356 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab3LND1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:09 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 107/115] ion: use alloc_pages in system contig heap
Date: Fri, 13 Dec 2013 19:26:27 -0800
Message-Id: <1386991595-6251-15-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

There is no reason to use kzalloc, just call alloc_pages directly.
Change the GFP from GFP_KERNEL to include __GFP_HIGH, to allow it
to return contiguous pages from highmem.  virt_to_* functions
aren't valid on highmem pages, so store the struct page * in an
sg_table in buffer->priv_virt like most other heaps, and replace
virt_to_* with page_to_*.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 71 ++++++++++++++++++---------
 1 file changed, 48 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 53afa33..841511d 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -360,29 +360,69 @@ static int ion_system_contig_heap_allocate(struct ion_heap *heap,
 					   unsigned long flags)
 {
 	int order = get_order(len);
+	struct page *page;
+	struct sg_table *table;
+	unsigned long i;
+	int ret;
 
 	if (align > (PAGE_SIZE << order))
 		return -EINVAL;
 
-	if (ion_buffer_fault_user_mappings(buffer))
-		return -EINVAL;
-
-	buffer->priv_virt = kzalloc(len, GFP_KERNEL);
-	if (!buffer->priv_virt)
+	page = alloc_pages(low_order_gfp_flags, order);
+	if (!page)
 		return -ENOMEM;
+
+	split_page(page, order);
+
+	len = PAGE_ALIGN(len);
+	for (i = len >> PAGE_SHIFT; i < (1 << order); i++)
+		__free_page(page + i);
+
+	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
+	if (!table) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = sg_alloc_table(table, 1, GFP_KERNEL);
+	if (ret)
+		goto out;
+
+	sg_set_page(table->sgl, page, len, 0);
+
+	buffer->priv_virt = table;
+
+	ion_pages_sync_for_device(NULL, page, len, DMA_BIDIRECTIONAL);
+
 	return 0;
+
+out:
+	for (i = 0; i < len >> PAGE_SHIFT; i++)
+		__free_page(page + i);
+	kfree(table);
+	return ret;
 }
 
 void ion_system_contig_heap_free(struct ion_buffer *buffer)
 {
-	kfree(buffer->priv_virt);
+	struct sg_table *table = buffer->priv_virt;
+	struct page *page = sg_page(table->sgl);
+	unsigned long pages = PAGE_ALIGN(buffer->size) >> PAGE_SHIFT;
+	unsigned long i;
+
+	for (i = 0; i < pages; i++)
+		__free_page(page + i);
+	sg_free_table(table);
+	kfree(table);
 }
 
 static int ion_system_contig_heap_phys(struct ion_heap *heap,
 				       struct ion_buffer *buffer,
 				       ion_phys_addr_t *addr, size_t *len)
 {
-	*addr = virt_to_phys(buffer->priv_virt);
+	struct sg_table *table = buffer->priv_virt;
+	struct page *page = sg_page(table->sgl);
+	*addr = page_to_phys(page);
 	*len = buffer->size;
 	return 0;
 }
@@ -390,27 +430,12 @@ static int ion_system_contig_heap_phys(struct ion_heap *heap,
 struct sg_table *ion_system_contig_heap_map_dma(struct ion_heap *heap,
 						struct ion_buffer *buffer)
 {
-	struct sg_table *table;
-	int ret;
-
-	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
-	if (!table)
-		return ERR_PTR(-ENOMEM);
-	ret = sg_alloc_table(table, 1, GFP_KERNEL);
-	if (ret) {
-		kfree(table);
-		return ERR_PTR(ret);
-	}
-	sg_set_page(table->sgl, virt_to_page(buffer->priv_virt), buffer->size,
-		    0);
-	return table;
+	return buffer->priv_virt;
 }
 
 void ion_system_contig_heap_unmap_dma(struct ion_heap *heap,
 				      struct ion_buffer *buffer)
 {
-	sg_free_table(buffer->sg_table);
-	kfree(buffer->sg_table);
 }
 
 static struct ion_heap_ops kmalloc_ops = {
-- 
1.8.3.2

