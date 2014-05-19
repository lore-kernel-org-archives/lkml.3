Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaESGve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:51:34 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11083 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaESGvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:51:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 18 May 2014 23:45:46 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/2] drm/gk20a/fb: fix huge memory leak
Date: Mon, 19 May 2014 15:51:07 +0900
Message-ID: <1400482268-4971-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400482268-4971-1-git-send-email-acourbot@nvidia.com>
References: <1400482268-4971-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CMA-allocated memory must be freed by an exact mirror call to
dma_release_from_contiguous(). It cannot be freed page-by-page as was
previously believed without severe memory leakage.

This page records the address and size of every allocated memory chunk
so they can be properly freed when needed.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c | 74 ++++++++++++++---------
 1 file changed, 46 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
index 7effd1a63458..5904af52e6d6 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
@@ -28,28 +28,34 @@
 #include <linux/types.h>
 #include <linux/dma-contiguous.h>
 
+struct gk20a_mem_chunk {
+	struct list_head list;
+	struct page *pages;
+	u32 npages;
+};
+
+struct gk20a_mem {
+	struct nouveau_mem base;
+	struct list_head head;
+};
+
 static void
 gk20a_ram_put(struct nouveau_fb *pfb, struct nouveau_mem **pmem)
 {
 	struct device *dev = nv_device_base(nv_device(pfb));
-	struct nouveau_mem *mem = *pmem;
-	int i;
+	struct gk20a_mem *mem = container_of(*pmem, struct gk20a_mem, base);
+	struct gk20a_mem_chunk *chunk, *n;
 
 	*pmem = NULL;
 	if (unlikely(mem == NULL))
 		return;
 
-	for (i = 0; i < mem->size; i++) {
-		struct page *page;
-
-		if (mem->pages[i] == 0)
-			break;
-
-		page = pfn_to_page(mem->pages[i] >> PAGE_SHIFT);
-		dma_release_from_contiguous(dev, page, 1);
+	list_for_each_entry_safe(chunk, n, &mem->head, list) {
+		dma_release_from_contiguous(dev, chunk->pages, chunk->npages);
+		kfree(chunk);
 	}
 
-	kfree(mem->pages);
+	kfree(mem->base.pages);
 	kfree(mem);
 }
 
@@ -58,9 +64,8 @@ gk20a_ram_get(struct nouveau_fb *pfb, u64 size, u32 align, u32 ncmin,
 	     u32 memtype, struct nouveau_mem **pmem)
 {
 	struct device *dev = nv_device_base(nv_device(pfb));
-	struct nouveau_mem *mem;
+	struct gk20a_mem *mem;
 	int type = memtype & 0xff;
-	dma_addr_t dma_addr;
 	int npages;
 	int order;
 	int i;
@@ -95,44 +100,57 @@ gk20a_ram_get(struct nouveau_fb *pfb, u64 size, u32 align, u32 ncmin,
 	if (!mem)
 		return -ENOMEM;
 
-	mem->size = npages;
-	mem->memtype = type;
+	mem->base.size = npages;
+	mem->base.memtype = type;
 
-	mem->pages = kzalloc(sizeof(dma_addr_t) * npages, GFP_KERNEL);
-	if (!mem) {
+	mem->base.pages = kzalloc(sizeof(dma_addr_t) * npages, GFP_KERNEL);
+	if (!mem->base.pages) {
 		kfree(mem);
 		return -ENOMEM;
 	}
 
+	INIT_LIST_HEAD(&mem->head);
+
+	*pmem = &mem->base;
+
 	while (npages) {
-		struct page *pages;
+		struct gk20a_mem_chunk *chunk;
+		dma_addr_t addr;
 		int pos = 0;
 
 		/* don't overflow in case size is not a multiple of ncmin */
 		if (ncmin > npages)
 			ncmin = npages;
 
-		pages = dma_alloc_from_contiguous(dev, ncmin, order);
-		if (!pages) {
-			gk20a_ram_put(pfb, &mem);
+		chunk = kzalloc(sizeof(*chunk), GFP_KERNEL);
+		if (!chunk) {
+			gk20a_ram_put(pfb, pmem);
 			return -ENOMEM;
 		}
 
-		dma_addr = (dma_addr_t)(page_to_pfn(pages) << PAGE_SHIFT);
+		chunk->pages = dma_alloc_from_contiguous(dev, ncmin, order);
+		if (!chunk->pages) {
+			kfree(chunk);
+			gk20a_ram_put(pfb, pmem);
+			return -ENOMEM;
+		}
 
-		nv_debug(pfb, "  alloc count: %x, order: %x, addr: %pad\n", ncmin,
-			 order, &dma_addr);
+		chunk->npages = ncmin;
+		list_add_tail(&chunk->list, &mem->head);
+
+		addr = (dma_addr_t)(page_to_pfn(chunk->pages) << PAGE_SHIFT);
+
+		nv_debug(pfb, "  alloc count: %x, order: %x, addr: %pad\n",
+			 ncmin, order, &addr);
 
 		for (i = 0; i < ncmin; i++)
-			mem->pages[pos + i] = dma_addr + (PAGE_SIZE * i);
+			mem->base.pages[pos + i] = addr + (PAGE_SIZE * i);
 
 		pos += ncmin;
 		npages -= ncmin;
 	}
 
-	mem->offset = (u64)mem->pages[0];
-
-	*pmem = mem;
+	mem->base.offset = (u64)mem->base.pages[0];
 
 	return 0;
 }
-- 
1.9.2

