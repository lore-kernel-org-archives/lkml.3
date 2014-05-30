Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbaE3Gv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:51:56 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1439 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbaE3Gvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:51:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 29 May 2014 23:46:50 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, Thierry Reding <treding@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] drm/gk20a/fb: use dma_alloc_coherent() for VRAM
Date: Fri, 30 May 2014 15:47:00 +0900
Message-ID: <1401432420-29477-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GK20A's RAM driver was using CMA functions in order to allocate VRAM.
This is wrong because these functions are not exported, which causes
compilation to fail when CMA is enabled and Nouveau is built as a
module. On top of that the driver was leaking (or rather bleeding)
memory.

dma_alloc_coherent() will also use CMA when needed but has the
advantage of being properly exported. It creates a permanent kernel
mapping, but experiment revealed that the lowmem mapping is actually
reused, and this mapping can also be taken advantage of to implement
faster instmem. We lose the ability to allocate memory at finer
granularity, but that's what CMA is here for and it also simplifies the
driver.

This driver is to be replaced by an IOMMU-based one in the future ;
until then, its current form will allow it to do its job.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c | 97 ++++++++++-------------
 1 file changed, 42 insertions(+), 55 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
index 7effd1a63458..10cdcf8b8a7f 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
@@ -24,32 +24,32 @@
 
 #include <subdev/fb.h>
 
-#include <linux/mm.h>
 #include <linux/types.h>
-#include <linux/dma-contiguous.h>
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+
+struct gk20a_mem {
+	struct nouveau_mem base;
+	void *cpuaddr;
+	dma_addr_t handle;
+};
+#define to_gk20a_mem(m) container_of(m, struct gk20a_mem, base)
 
 static void
 gk20a_ram_put(struct nouveau_fb *pfb, struct nouveau_mem **pmem)
 {
 	struct device *dev = nv_device_base(nv_device(pfb));
-	struct nouveau_mem *mem = *pmem;
-	int i;
+	struct gk20a_mem *mem = to_gk20a_mem(*pmem);
 
 	*pmem = NULL;
 	if (unlikely(mem == NULL))
 		return;
 
-	for (i = 0; i < mem->size; i++) {
-		struct page *page;
-
-		if (mem->pages[i] == 0)
-			break;
+	if (likely(mem->cpuaddr))
+		dma_free_coherent(dev, mem->base.size << PAGE_SHIFT,
+				  mem->cpuaddr, mem->handle);
 
-		page = pfn_to_page(mem->pages[i] >> PAGE_SHIFT);
-		dma_release_from_contiguous(dev, page, 1);
-	}
-
-	kfree(mem->pages);
+	kfree(mem->base.pages);
 	kfree(mem);
 }
 
@@ -58,11 +58,9 @@ gk20a_ram_get(struct nouveau_fb *pfb, u64 size, u32 align, u32 ncmin,
 	     u32 memtype, struct nouveau_mem **pmem)
 {
 	struct device *dev = nv_device_base(nv_device(pfb));
-	struct nouveau_mem *mem;
-	int type = memtype & 0xff;
-	dma_addr_t dma_addr;
-	int npages;
-	int order;
+	struct gk20a_mem *mem;
+	u32 type = memtype & 0xff;
+	u32 npages, order;
 	int i;
 
 	nv_debug(pfb, "%s: size: %llx align: %x, ncmin: %x\n", __func__, size,
@@ -80,59 +78,48 @@ gk20a_ram_get(struct nouveau_fb *pfb, u64 size, u32 align, u32 ncmin,
 	order = fls(align);
 	if ((align & (align - 1)) == 0)
 		order--;
+	align = BIT(order);
 
-	ncmin >>= PAGE_SHIFT;
-	/*
-	 * allocate pages by chunks of "align" size, otherwise we may leave
-	 * holes in the contiguous memory area.
-	 */
-	if (ncmin == 0)
-		ncmin = npages;
-	else if (align > ncmin)
-		ncmin = align;
+	/* ensure returned address is correctly aligned */
+	npages = max(align, npages);
 
 	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
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
 
-	while (npages) {
-		struct page *pages;
-		int pos = 0;
-
-		/* don't overflow in case size is not a multiple of ncmin */
-		if (ncmin > npages)
-			ncmin = npages;
-
-		pages = dma_alloc_from_contiguous(dev, ncmin, order);
-		if (!pages) {
-			gk20a_ram_put(pfb, &mem);
-			return -ENOMEM;
-		}
+	*pmem = &mem->base;
 
-		dma_addr = (dma_addr_t)(page_to_pfn(pages) << PAGE_SHIFT);
+	mem->cpuaddr = dma_alloc_coherent(dev, npages << PAGE_SHIFT,
+					  &mem->handle, GFP_KERNEL);
+	if (!mem->cpuaddr) {
+		nv_error(pfb, "%s: cannot allocate memory!\n", __func__);
+		gk20a_ram_put(pfb, pmem);
+		return -ENOMEM;
+	}
 
-		nv_debug(pfb, "  alloc count: %x, order: %x, addr: %pad\n", ncmin,
-			 order, &dma_addr);
+	align <<= PAGE_SHIFT;
 
-		for (i = 0; i < ncmin; i++)
-			mem->pages[pos + i] = dma_addr + (PAGE_SIZE * i);
+	/* alignment check */
+	if (unlikely(mem->handle & (align - 1)))
+		nv_warn(pfb, "memory not aligned as requested: %pad (0x%x)\n",
+			&mem->handle, align);
 
-		pos += ncmin;
-		npages -= ncmin;
-	}
+	nv_debug(pfb, "alloc size: 0x%x, align: 0x%x, paddr: %pad, vaddr: %p\n",
+		 npages << PAGE_SHIFT, align, &mem->handle, mem->cpuaddr);
 
-	mem->offset = (u64)mem->pages[0];
+	for (i = 0; i < npages; i++)
+		mem->base.pages[i] = mem->handle + (PAGE_SIZE * i);
 
-	*pmem = mem;
+	mem->base.offset = (u64)mem->base.pages[0];
 
 	return 0;
 }
-- 
1.9.3

