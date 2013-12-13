Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab3LMW2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:28:35 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:37704 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3LMW2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:32 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 092/115] ion: don't use __arm_ioremap to map pages
Date: Fri, 13 Dec 2013 14:25:06 -0800
Message-Id: <1386973529-4884-93-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

ion_heap_map_kernel already implements mapping a scatterlist of
pages into the kernel, and all heaps are required to have struct
pages associated with them, so delete the functions that use
__arm_ioremap and use ion_heap_map_kernel instead.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_carveout_heap.c | 42 ++-----------------------
 drivers/staging/android/ion/ion_chunk_heap.c    |  2 --
 2 files changed, 3 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index 36df34c..051363a 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -25,8 +25,6 @@
 #include "ion.h"
 #include "ion_priv.h"
 
-#include <asm/mach/map.h>
-
 struct ion_carveout_heap {
 	struct ion_heap heap;
 	struct gen_pool *pool;
@@ -109,49 +107,15 @@ void ion_carveout_heap_unmap_dma(struct ion_heap *heap,
 	sg_free_table(buffer->sg_table);
 }
 
-void *ion_carveout_heap_map_kernel(struct ion_heap *heap,
-				   struct ion_buffer *buffer)
-{
-	void *ret;
-	int mtype = MT_MEMORY_NONCACHED;
-
-	if (buffer->flags & ION_FLAG_CACHED)
-		mtype = MT_MEMORY;
-
-	ret = __arm_ioremap(buffer->priv_phys, buffer->size,
-			      mtype);
-	if (ret == NULL)
-		return ERR_PTR(-ENOMEM);
-
-	return ret;
-}
-
-void ion_carveout_heap_unmap_kernel(struct ion_heap *heap,
-				    struct ion_buffer *buffer)
-{
-	__arm_iounmap(buffer->vaddr);
-	buffer->vaddr = NULL;
-	return;
-}
-
-int ion_carveout_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
-			       struct vm_area_struct *vma)
-{
-	return remap_pfn_range(vma, vma->vm_start,
-			       __phys_to_pfn(buffer->priv_phys) + vma->vm_pgoff,
-			       vma->vm_end - vma->vm_start,
-			       pgprot_noncached(vma->vm_page_prot));
-}
-
 static struct ion_heap_ops carveout_heap_ops = {
 	.allocate = ion_carveout_heap_allocate,
 	.free = ion_carveout_heap_free,
 	.phys = ion_carveout_heap_phys,
 	.map_dma = ion_carveout_heap_map_dma,
 	.unmap_dma = ion_carveout_heap_unmap_dma,
-	.map_user = ion_carveout_heap_map_user,
-	.map_kernel = ion_carveout_heap_map_kernel,
-	.unmap_kernel = ion_carveout_heap_unmap_kernel,
+	.map_user = ion_heap_map_user,
+	.map_kernel = ion_heap_map_kernel,
+	.unmap_kernel = ion_heap_unmap_kernel,
 };
 
 struct ion_heap *ion_carveout_heap_create(struct ion_platform_heap *heap_data)
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 62f7439..d3363d6 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -25,8 +25,6 @@
 #include "ion.h"
 #include "ion_priv.h"
 
-#include <asm/mach/map.h>
-
 struct ion_chunk_heap {
 	struct ion_heap heap;
 	struct gen_pool *pool;
-- 
1.8.3.2

