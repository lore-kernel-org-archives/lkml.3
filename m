Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3LND0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:26:48 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59210 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab3LND0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:26:47 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 093/115] ion: don't use phys_to_page or __phys_to_pfn
Date: Fri, 13 Dec 2013 19:26:13 -0800
Message-Id: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

phys_to_page and __phys_to_pfn don't exist on all platforms.
Use a combination of pfn_to_page, PFN_DOWN, page_to_pfn, and
virt_to_page to get the same results.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_carveout_heap.c | 4 ++--
 drivers/staging/android/ion/ion_chunk_heap.c    | 5 +++--
 drivers/staging/android/ion/ion_system_heap.c   | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index 051363a..1d53e91 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -96,8 +96,8 @@ struct sg_table *ion_carveout_heap_map_dma(struct ion_heap *heap,
 		kfree(table);
 		return ERR_PTR(ret);
 	}
-	sg_set_page(table->sgl, phys_to_page(buffer->priv_phys), buffer->size,
-		    0);
+	sg_set_page(table->sgl, pfn_to_page(PFN_DOWN(buffer->priv_phys)),
+			buffer->size, 0);
 	return table;
 }
 
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index d3363d6..fb1a7b9 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -71,7 +71,8 @@ static int ion_chunk_heap_allocate(struct ion_heap *heap,
 						     chunk_heap->chunk_size);
 		if (!paddr)
 			goto err;
-		sg_set_page(sg, phys_to_page(paddr), chunk_heap->chunk_size, 0);
+		sg_set_page(sg, pfn_to_page(PFN_DOWN(paddr)),
+				chunk_heap->chunk_size, 0);
 		sg = sg_next(sg);
 	}
 
@@ -167,7 +168,7 @@ struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 		goto error;
 	}
 	for (i = 0; i < chunk_heap->size; i += PAGE_SIZE) {
-		struct page *page = phys_to_page(chunk_heap->base + i);
+		struct page *page = pfn_to_page(PFN_DOWN(chunk_heap->base + i));
 		struct page **pages = &page;
 
 		ret = map_vm_area(vm_struct, pgprot, &pages);
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 62a07ec..3b2f420 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -426,7 +426,7 @@ int ion_system_contig_heap_map_user(struct ion_heap *heap,
 				    struct ion_buffer *buffer,
 				    struct vm_area_struct *vma)
 {
-	unsigned long pfn = __phys_to_pfn(virt_to_phys(buffer->priv_virt));
+	unsigned long pfn = page_to_pfn(virt_to_page(buffer->priv_virt));
 	return remap_pfn_range(vma, vma->vm_start, pfn + vma->vm_pgoff,
 			       vma->vm_end - vma->vm_start,
 			       vma->vm_page_prot);
-- 
1.8.3.2

