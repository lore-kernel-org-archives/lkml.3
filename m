Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab3LND1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:41 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51682 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3LND07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:26:59 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 101/115] ion: optimize ion_heap_buffer_zero
Date: Fri, 13 Dec 2013 19:26:21 -0800
Message-Id: <1386991595-6251-9-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

ion_heap_buffer_zero can spend a long time in unmap_kernel_range
if it has to broadcast a tlb flush to every cpu for every page.
Modify it to batch pages into a larger region to clear using a
single mapping.  This may cause the mapping size to change if
the buffer size is not a multiple of the mapping size, so
switch to allocating the address space for each chunk.  This
allows us to use vm_map_ram to handle the allocation and mapping
together.

The number of pages to zero using a single mapping is set to 32
to hit the fastpath in vm_map_ram.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_heap.c | 36 +++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index 0a5cea0..ce31561 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -100,40 +100,48 @@ int ion_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
 	return 0;
 }
 
+static int ion_heap_clear_pages(struct page **pages, int num, pgprot_t pgprot)
+{
+	void *addr = vm_map_ram(pages, num, -1, pgprot);
+	if (!addr)
+		return -ENOMEM;
+	memset(addr, 0, PAGE_SIZE * num);
+	vm_unmap_ram(addr, num);
+
+	return 0;
+}
+
 int ion_heap_buffer_zero(struct ion_buffer *buffer)
 {
 	struct sg_table *table = buffer->sg_table;
 	pgprot_t pgprot;
 	struct scatterlist *sg;
-	struct vm_struct *vm_struct;
 	int i, j, ret = 0;
+	struct page *pages[32];
+	int k = 0;
 
 	if (buffer->flags & ION_FLAG_CACHED)
 		pgprot = PAGE_KERNEL;
 	else
 		pgprot = pgprot_writecombine(PAGE_KERNEL);
 
-	vm_struct = get_vm_area(PAGE_SIZE, VM_ALLOC);
-	if (!vm_struct)
-		return -ENOMEM;
-
 	for_each_sg(table->sgl, sg, table->nents, i) {
 		struct page *page = sg_page(sg);
 		unsigned long len = sg->length;
 
 		for (j = 0; j < len / PAGE_SIZE; j++) {
-			struct page *sub_page = page + j;
-			struct page **pages = &sub_page;
-			ret = map_vm_area(vm_struct, pgprot, &pages);
-			if (ret)
-				goto end;
-			memset(vm_struct->addr, 0, PAGE_SIZE);
-			unmap_kernel_range((unsigned long)vm_struct->addr,
-					   PAGE_SIZE);
+			pages[k++] = page + j;
+			if (k == ARRAY_SIZE(pages)) {
+				ret = ion_heap_clear_pages(pages, k, pgprot);
+				if (ret)
+					goto end;
+				k = 0;
+			}
 		}
+		if (k)
+			ret = ion_heap_clear_pages(pages, k, pgprot);
 	}
 end:
-	free_vm_area(vm_struct);
 	return ret;
 }
 
-- 
1.8.3.2

