Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaJ0Juj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:50:39 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15561 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaJ0Jti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:49:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 27 Oct 2014 02:45:03 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v5 2/4] drm: implement explicitly coherent BOs
Date: Mon, 27 Oct 2014 18:49:17 +0900
Message-ID: <1414403359-22332-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414403359-22332-1-git-send-email-acourbot@nvidia.com>
References: <1414403359-22332-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow nouveau_bo_new() to recognize the TTM_PL_FLAG_UNCACHED flag, which
means that we want the allocated BO to be perfectly coherent between the
CPU and GPU. This is useful on non-coherent architectures for which we
do not want to manually sync some rarely-accessed buffers: typically,
fences and pushbuffers.

A TTM BO allocated with the TTM_PL_FLAG_UNCACHED on a non-coherent
architecture will be populated using the DMA API, and accesses to it
performed using the coherent mapping performed by dma_alloc_coherent().

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drm/nouveau_bo.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 drm/nouveau_bo.h |  1 +
 2 files changed, 73 insertions(+), 8 deletions(-)

diff --git a/drm/nouveau_bo.c b/drm/nouveau_bo.c
index 9a8adeec80cd..ed9a6946f6d6 100644
--- a/drm/nouveau_bo.c
+++ b/drm/nouveau_bo.c
@@ -214,6 +214,9 @@ nouveau_bo_new(struct drm_device *dev, int size, int align,
 	nvbo->tile_flags = tile_flags;
 	nvbo->bo.bdev = &drm->ttm.bdev;
 
+	if (!nv_device_is_cpu_coherent(nvkm_device(&drm->device)))
+		nvbo->force_coherent = flags & TTM_PL_FLAG_UNCACHED;
+
 	nvbo->page_shift = 12;
 	if (drm->client.vm) {
 		if (!(flags & TTM_PL_FLAG_TT) && size > 256 * 1024)
@@ -291,8 +294,9 @@ void
 nouveau_bo_placement_set(struct nouveau_bo *nvbo, uint32_t type, uint32_t busy)
 {
 	struct ttm_placement *pl = &nvbo->placement;
-	uint32_t flags = TTM_PL_MASK_CACHING |
-		(nvbo->pin_refcnt ? TTM_PL_FLAG_NO_EVICT : 0);
+	uint32_t flags = (nvbo->force_coherent ? TTM_PL_FLAG_UNCACHED :
+						 TTM_PL_MASK_CACHING) |
+			 (nvbo->pin_refcnt ? TTM_PL_FLAG_NO_EVICT : 0);
 
 	pl->placement = nvbo->placements;
 	set_placement_list(nvbo->placements, &pl->num_placement,
@@ -396,7 +400,14 @@ nouveau_bo_map(struct nouveau_bo *nvbo)
 	if (ret)
 		return ret;
 
-	ret = ttm_bo_kmap(&nvbo->bo, 0, nvbo->bo.mem.num_pages, &nvbo->kmap);
+	/*
+	 * TTM buffers allocated using the DMA API already have a mapping, let's
+	 * use it instead.
+	 */
+	if (!nvbo->force_coherent)
+		ret = ttm_bo_kmap(&nvbo->bo, 0, nvbo->bo.mem.num_pages,
+				  &nvbo->kmap);
+
 	ttm_bo_unreserve(&nvbo->bo);
 	return ret;
 }
@@ -404,7 +415,14 @@ nouveau_bo_map(struct nouveau_bo *nvbo)
 void
 nouveau_bo_unmap(struct nouveau_bo *nvbo)
 {
-	if (nvbo)
+	if (!nvbo)
+		return;
+
+	/*
+	 * TTM buffers allocated using the DMA API already had a coherent
+	 * mapping which we used, no need to unmap.
+	 */
+	if (!nvbo->force_coherent)
 		ttm_bo_kunmap(&nvbo->kmap);
 }
 
@@ -422,12 +440,36 @@ nouveau_bo_validate(struct nouveau_bo *nvbo, bool interruptible,
 	return 0;
 }
 
+static inline void *
+_nouveau_bo_mem_index(struct nouveau_bo *nvbo, unsigned index, void *mem, u8 sz)
+{
+	struct ttm_dma_tt *dma_tt;
+	u8 *m = mem;
+
+	index *= sz;
+
+	if (m) {
+		/* kmap'd address, return the corresponding offset */
+		m += index;
+	} else {
+		/* DMA-API mapping, lookup the right address */
+		dma_tt = (struct ttm_dma_tt *)nvbo->bo.ttm;
+		m = dma_tt->cpu_address[index / PAGE_SIZE];
+		m += index % PAGE_SIZE;
+	}
+
+	return m;
+}
+#define nouveau_bo_mem_index(o, i, m) _nouveau_bo_mem_index(o, i, m, sizeof(*m))
+
 u16
 nouveau_bo_rd16(struct nouveau_bo *nvbo, unsigned index)
 {
 	bool is_iomem;
 	u16 *mem = ttm_kmap_obj_virtual(&nvbo->kmap, &is_iomem);
-	mem = &mem[index];
+
+	mem = nouveau_bo_mem_index(nvbo, index, mem);
+
 	if (is_iomem)
 		return ioread16_native((void __force __iomem *)mem);
 	else
@@ -439,7 +481,9 @@ nouveau_bo_wr16(struct nouveau_bo *nvbo, unsigned index, u16 val)
 {
 	bool is_iomem;
 	u16 *mem = ttm_kmap_obj_virtual(&nvbo->kmap, &is_iomem);
-	mem = &mem[index];
+
+	mem = nouveau_bo_mem_index(nvbo, index, mem);
+
 	if (is_iomem)
 		iowrite16_native(val, (void __force __iomem *)mem);
 	else
@@ -451,7 +495,9 @@ nouveau_bo_rd32(struct nouveau_bo *nvbo, unsigned index)
 {
 	bool is_iomem;
 	u32 *mem = ttm_kmap_obj_virtual(&nvbo->kmap, &is_iomem);
-	mem = &mem[index];
+
+	mem = nouveau_bo_mem_index(nvbo, index, mem);
+
 	if (is_iomem)
 		return ioread32_native((void __force __iomem *)mem);
 	else
@@ -463,7 +509,9 @@ nouveau_bo_wr32(struct nouveau_bo *nvbo, unsigned index, u32 val)
 {
 	bool is_iomem;
 	u32 *mem = ttm_kmap_obj_virtual(&nvbo->kmap, &is_iomem);
-	mem = &mem[index];
+
+	mem = nouveau_bo_mem_index(nvbo, index, mem);
+
 	if (is_iomem)
 		iowrite32_native(val, (void __force __iomem *)mem);
 	else
@@ -1383,6 +1431,14 @@ nouveau_ttm_tt_populate(struct ttm_tt *ttm)
 	dev = drm->dev;
 	pdev = nv_device_base(device);
 
+	/*
+	 * Objects matching this condition have been marked as force_coherent,
+	 * so use the DMA API for them.
+	 */
+	if (!nv_device_is_cpu_coherent(device) &&
+	    ttm->caching_state == tt_uncached)
+		return ttm_dma_populate(ttm_dma, dev->dev);
+
 #if __OS_HAS_AGP
 	if (drm->agp.stat == ENABLED) {
 		return ttm_agp_tt_populate(ttm);
@@ -1440,6 +1496,14 @@ nouveau_ttm_tt_unpopulate(struct ttm_tt *ttm)
 	dev = drm->dev;
 	pdev = nv_device_base(device);
 
+	/*
+	 * Objects matching this condition have been marked as force_coherent,
+	 * so use the DMA API for them.
+	 */
+	if (!nv_device_is_cpu_coherent(device) &&
+	    ttm->caching_state == tt_uncached)
+		ttm_dma_unpopulate(ttm_dma, dev->dev);
+
 #if __OS_HAS_AGP
 	if (drm->agp.stat == ENABLED) {
 		ttm_agp_tt_unpopulate(ttm);
diff --git a/drm/nouveau_bo.h b/drm/nouveau_bo.h
index 22d2c764d80b..0f8bbd48a0b9 100644
--- a/drm/nouveau_bo.h
+++ b/drm/nouveau_bo.h
@@ -13,6 +13,7 @@ struct nouveau_bo {
 	u32 valid_domains;
 	struct ttm_place placements[3];
 	struct ttm_place busy_placements[3];
+	bool force_coherent;
 	struct ttm_bo_kmap_obj kmap;
 	struct list_head head;
 
-- 
2.1.2

