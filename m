Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3LMW3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:29:55 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:58264 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab3LMW20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:26 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 088/115] ion: convert sg_dma_len(sg) to sg->length
Date: Fri, 13 Dec 2013 14:25:02 -0800
Message-Id: <1386973529-4884-89-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

ion is always dealing with the allocation and not the mapping,
so it should always be using sg->length and not sg->dma_length.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c             |  2 +-
 drivers/staging/android/ion/ion_chunk_heap.c  |  4 ++--
 drivers/staging/android/ion/ion_heap.c        | 12 ++++++------
 drivers/staging/android/ion/ion_system_heap.c |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 4bdbdec..8d568ca 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -224,7 +224,7 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 		for_each_sg(table->sgl, sg, table->nents, i) {
 			struct page *page = sg_page(sg);
 
-			for (j = 0; j < sg_dma_len(sg) / PAGE_SIZE; j++)
+			for (j = 0; j < sg->length / PAGE_SIZE; j++)
 				buffer->pages[k++] = page++;
 		}
 
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 2fddc04..62f7439 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -84,7 +84,7 @@ err:
 	sg = table->sgl;
 	for (i -= 1; i >= 0; i--) {
 		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
-			      sg_dma_len(sg));
+			      sg->length);
 		sg = sg_next(sg);
 	}
 	sg_free_table(table);
@@ -112,7 +112,7 @@ static void ion_chunk_heap_free(struct ion_buffer *buffer)
 
 	for_each_sg(table->sgl, sg, table->nents, i) {
 		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
-			      sg_dma_len(sg));
+			      sg->length);
 	}
 	chunk_heap->allocated -= allocated_size;
 	sg_free_table(table);
diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index a584ec0..a5a7c572 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -46,7 +46,7 @@ void *ion_heap_map_kernel(struct ion_heap *heap,
 		pgprot = pgprot_writecombine(PAGE_KERNEL);
 
 	for_each_sg(table->sgl, sg, table->nents, i) {
-		int npages_this_entry = PAGE_ALIGN(sg_dma_len(sg)) / PAGE_SIZE;
+		int npages_this_entry = PAGE_ALIGN(sg->length) / PAGE_SIZE;
 		struct page *page = sg_page(sg);
 		BUG_ON(i >= npages);
 		for (j = 0; j < npages_this_entry; j++) {
@@ -80,14 +80,14 @@ int ion_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
 	for_each_sg(table->sgl, sg, table->nents, i) {
 		struct page *page = sg_page(sg);
 		unsigned long remainder = vma->vm_end - addr;
-		unsigned long len = sg_dma_len(sg);
+		unsigned long len = sg->length;
 
-		if (offset >= sg_dma_len(sg)) {
-			offset -= sg_dma_len(sg);
+		if (offset >= sg->length) {
+			offset -= sg->length;
 			continue;
 		} else if (offset) {
 			page += offset / PAGE_SIZE;
-			len = sg_dma_len(sg) - offset;
+			len = sg->length - offset;
 			offset = 0;
 		}
 		len = min(len, remainder);
@@ -119,7 +119,7 @@ int ion_heap_buffer_zero(struct ion_buffer *buffer)
 
 	for_each_sg(table->sgl, sg, table->nents, i) {
 		struct page *page = sg_page(sg);
-		unsigned long len = sg_dma_len(sg);
+		unsigned long len = sg->length;
 
 		for (j = 0; j < len / PAGE_SIZE; j++) {
 			struct page *sub_page = page + j;
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 792cade..967eedc 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -209,7 +209,7 @@ void ion_system_heap_free(struct ion_buffer *buffer)
 
 	for_each_sg(table->sgl, sg, table->nents, i)
 		free_buffer_page(sys_heap, buffer, sg_page(sg),
-				get_order(sg_dma_len(sg)));
+				get_order(sg->length));
 	sg_free_table(table);
 	kfree(table);
 }
-- 
1.8.3.2

