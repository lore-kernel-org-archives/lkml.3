Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3LMW1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:41 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41414 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3LMW1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:37 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rschultz@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 057/115] gpu: ion: Modify zeroing code so it only allocates address space once
Date: Fri, 13 Dec 2013 14:24:31 -0800
Message-Id: <1386973529-4884-58-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rschultz@google.com>

vmap/vunmap spend a significant amount of time allocating the
address space to map into.  Rather than allocating address space
for each page, instead allocate once for the entire allocation
and then just map and unmap each page into that address space.

Signed-off-by: Rebecca Schultz Zavin <rschultz@google.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 28 ++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 89247cf..e54307f 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -91,7 +91,7 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 
 static void free_buffer_page(struct ion_system_heap *heap,
 			     struct ion_buffer *buffer, struct page *page,
-			     unsigned int order)
+			     unsigned int order, struct vm_struct *vm_struct)
 {
 	bool cached = ion_buffer_cached(buffer);
 	bool split_pages = ion_buffer_fault_user_mappings(buffer);
@@ -105,10 +105,13 @@ static void free_buffer_page(struct ion_system_heap *heap,
 		   purpose is to keep the pages out of the cache */
 		for (i = 0; i < (1 << order); i++) {
 			struct page *sub_page = page + i;
-			void *addr = vmap(&sub_page, 1, VM_MAP,
-					  pgprot_writecombine(PAGE_KERNEL));
-			memset(addr, 0, PAGE_SIZE);
-			vunmap(addr);
+			struct page **pages = &sub_page;
+			map_vm_area(vm_struct,
+					 pgprot_writecombine(PAGE_KERNEL),
+					 &pages);
+			memset(vm_struct->addr, 0, PAGE_SIZE);
+			unmap_kernel_range((unsigned long)vm_struct->addr,
+					PAGE_SIZE);
 		}
 		ion_page_pool_free(pool, page);
 	} else if (split_pages) {
@@ -164,6 +167,8 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	long size_remaining = PAGE_ALIGN(size);
 	unsigned int max_order = orders[0];
 	bool split_pages = ion_buffer_fault_user_mappings(buffer);
+	struct vm_struct *vm_struct;
+	pte_t *ptes;
 
 	INIT_LIST_HEAD(&pages);
 	while (size_remaining > 0) {
@@ -211,10 +216,13 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 err1:
 	kfree(table);
 err:
+	vm_struct = get_vm_area(PAGE_SIZE, &ptes);
 	list_for_each_entry(info, &pages, list) {
-		free_buffer_page(sys_heap, buffer, info->page, info->order);
+		free_buffer_page(sys_heap, buffer, info->page, info->order,
+				vm_struct);
 		kfree(info);
 	}
+	free_vm_area(vm_struct);
 	return -ENOMEM;
 }
 
@@ -227,10 +235,16 @@ void ion_system_heap_free(struct ion_buffer *buffer)
 	struct sg_table *table = buffer->sg_table;
 	struct scatterlist *sg;
 	LIST_HEAD(pages);
+	struct vm_struct *vm_struct;
+	pte_t *ptes;
 	int i;
 
+	vm_struct = get_vm_area(PAGE_SIZE, &ptes);
+
 	for_each_sg(table->sgl, sg, table->nents, i)
-		free_buffer_page(sys_heap, buffer, sg_page(sg), get_order(sg_dma_len(sg)));
+		free_buffer_page(sys_heap, buffer, sg_page(sg),
+				get_order(sg_dma_len(sg)), vm_struct);
+	free_vm_area(vm_struct);
 	sg_free_table(table);
 	kfree(table);
 }
-- 
1.8.3.2

