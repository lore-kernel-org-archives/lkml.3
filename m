Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaGHI1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:27:55 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12197 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaGHI0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:26:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 08 Jul 2014 01:19:52 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 5/6] drm/nouveau: implement explicitly coherent BOs
Date: Tue, 8 Jul 2014 17:26:00 +0900
Message-ID: <1404807961-30530-6-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
References: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
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
 drivers/gpu/drm/nouveau/nouveau_bo.c | 76 ++++++++++++++++++++++++++++++++----
 drivers/gpu/drm/nouveau/nouveau_bo.h |  1 +
 2 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 47e4e8886769..23a29adfabf0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -219,6 +219,9 @@ nouveau_bo_new(struct drm_device *dev, int size, int align,
 	nvbo->tile_flags = tile_flags;
 	nvbo->bo.bdev = &drm->ttm.bdev;
 
+	if (!nv_device_is_cpu_coherent(nouveau_dev(dev)))
+		nvbo->force_coherent = flags & TTM_PL_FLAG_UNCACHED;
+
 	nvbo->page_shift = 12;
 	if (drm->client.base.vm) {
 		if (!(flags & TTM_PL_FLAG_TT) && size > 256 * 1024)
@@ -289,8 +292,9 @@ void
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
@@ -390,7 +394,14 @@ nouveau_bo_map(struct nouveau_bo *nvbo)
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
@@ -398,7 +409,14 @@ nouveau_bo_map(struct nouveau_bo *nvbo)
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
 
@@ -482,12 +500,36 @@ nouveau_bo_validate(struct nouveau_bo *nvbo, bool interruptible,
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
@@ -499,7 +541,9 @@ nouveau_bo_wr16(struct nouveau_bo *nvbo, unsigned index, u16 val)
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
@@ -511,7 +555,9 @@ nouveau_bo_rd32(struct nouveau_bo *nvbo, unsigned index)
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
@@ -523,7 +569,9 @@ nouveau_bo_wr32(struct nouveau_bo *nvbo, unsigned index, u32 val)
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
@@ -1426,6 +1474,14 @@ nouveau_ttm_tt_populate(struct ttm_tt *ttm)
 	device = nv_device(drm->device);
 	dev = drm->dev;
 
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
@@ -1476,6 +1532,10 @@ nouveau_ttm_tt_unpopulate(struct ttm_tt *ttm)
 	device = nv_device(drm->device);
 	dev = drm->dev;
 
+	if (!nv_device_is_cpu_coherent(device) &&
+	    ttm->caching_state == tt_uncached)
+		ttm_dma_unpopulate(ttm_dma, dev->dev);
+
 #if __OS_HAS_AGP
 	if (drm->agp.stat == ENABLED) {
 		ttm_agp_tt_unpopulate(ttm);
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.h b/drivers/gpu/drm/nouveau/nouveau_bo.h
index fa42298d2dca..9a111b92fb34 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.h
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.h
@@ -11,6 +11,7 @@ struct nouveau_bo {
 	u32 valid_domains;
 	u32 placements[3];
 	u32 busy_placements[3];
+	bool force_coherent;
 	struct ttm_bo_kmap_obj kmap;
 	struct list_head head;
 
-- 
2.0.0

