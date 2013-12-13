Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3LMW0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:26:19 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47017 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab3LMW0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:14 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 007/115] gpu: ion: Use alloc_pages instead of vmalloc from the system heap
Date: Fri, 13 Dec 2013 14:23:41 -0800
Message-Id: <1386973529-4884-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

With this change the ion_system_heap will only use kernel address
space when the memory is mapped into the kernel (rare case).

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 94 +++++++++++++++++----------
 1 file changed, 61 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index d7e0fa0..3383a88 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -27,74 +27,102 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 				     unsigned long size, unsigned long align,
 				     unsigned long flags)
 {
-	buffer->priv_virt = vmalloc_user(size);
-	if (!buffer->priv_virt)
-		return -ENOMEM;
-	return 0;
-}
-
-void ion_system_heap_free(struct ion_buffer *buffer)
-{
-	vfree(buffer->priv_virt);
-}
-
-struct sg_table *ion_system_heap_map_dma(struct ion_heap *heap,
-					 struct ion_buffer *buffer)
-{
 	struct sg_table *table;
 	struct scatterlist *sg;
-	int i;
-	int npages = PAGE_ALIGN(buffer->size) / PAGE_SIZE;
-	void *vaddr = buffer->priv_virt;
-	int ret;
+	int i, j;
+	int npages = PAGE_ALIGN(size) / PAGE_SIZE;
 
-	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
+	table = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
 	if (!table)
-		return ERR_PTR(-ENOMEM);
-	ret = sg_alloc_table(table, npages, GFP_KERNEL);
-	if (ret)
+		return -ENOMEM;
+	i = sg_alloc_table(table, npages, GFP_KERNEL);
+	if (i)
 		goto err0;
 	for_each_sg(table->sgl, sg, table->nents, i) {
 		struct page *page;
-		page = vmalloc_to_page(vaddr);
-		if (!page) {
-			ret = -ENOMEM;
+		page = alloc_page(GFP_KERNEL);
+		if (!page)
 			goto err1;
-		}
 		sg_set_page(sg, page, PAGE_SIZE, 0);
-		vaddr += PAGE_SIZE;
 	}
-	return table;
+	buffer->priv_virt = table;
+	return 0;
 err1:
+	for_each_sg(table->sgl, sg, i, j)
+		__free_page(sg_page(sg));
 	sg_free_table(table);
 err0:
 	kfree(table);
-	return ERR_PTR(ret);
+	return -ENOMEM;
 }
 
-void ion_system_heap_unmap_dma(struct ion_heap *heap,
-			       struct ion_buffer *buffer)
+void ion_system_heap_free(struct ion_buffer *buffer)
 {
+	int i;
+	struct scatterlist *sg;
+	struct sg_table *table = buffer->priv_virt;
+
+	for_each_sg(table->sgl, sg, table->nents, i)
+		__free_page(sg_page(sg));
 	if (buffer->sg_table)
 		sg_free_table(buffer->sg_table);
 	kfree(buffer->sg_table);
 }
 
+struct sg_table *ion_system_heap_map_dma(struct ion_heap *heap,
+					 struct ion_buffer *buffer)
+{
+	return buffer->priv_virt;
+}
+
+void ion_system_heap_unmap_dma(struct ion_heap *heap,
+			       struct ion_buffer *buffer)
+{
+	return;
+}
+
 void *ion_system_heap_map_kernel(struct ion_heap *heap,
 				 struct ion_buffer *buffer)
 {
-	return buffer->priv_virt;
+	struct scatterlist *sg;
+	int i;
+	void *vaddr;
+	struct sg_table *table = buffer->priv_virt;
+	struct page **pages = kmalloc(sizeof(struct page *) * table->nents,
+				      GFP_KERNEL);
+
+	for_each_sg(table->sgl, sg, table->nents, i)
+		pages[i] = sg_page(sg);
+	vaddr = vmap(pages, table->nents, VM_MAP, PAGE_KERNEL);
+	kfree(pages);
+
+	return vaddr;
 }
 
 void ion_system_heap_unmap_kernel(struct ion_heap *heap,
 				  struct ion_buffer *buffer)
 {
+	vunmap(buffer->vaddr);
 }
 
 int ion_system_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
 			     struct vm_area_struct *vma)
 {
-	return remap_vmalloc_range(vma, buffer->priv_virt, vma->vm_pgoff);
+	struct sg_table *table = buffer->priv_virt;
+	unsigned long addr = vma->vm_start;
+	unsigned long offset = vma->vm_pgoff;
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(table->sgl, sg, table->nents, i) {
+		if (offset) {
+			offset--;
+			continue;
+		}
+		vm_insert_page(vma, addr, sg_page(sg));
+		addr += PAGE_SIZE;
+	}
+	return 0;
 }
 
 static struct ion_heap_ops vmalloc_ops = {
-- 
1.8.3.2

