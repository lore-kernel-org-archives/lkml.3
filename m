Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaF0LWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:22:48 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13158 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaF0LWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:22:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 27 Jun 2014 04:12:45 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 1/2] drm/nouveau: cleanup TTM population logic
Date: Fri, 27 Jun 2014 20:22:13 +0900
Message-ID: <1403868134-31741-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403868134-31741-1-git-send-email-acourbot@nvidia.com>
References: <1403868134-31741-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TTM pages can currently be populated using 3 different methods, but the
code does not make it clear which one is used. The same complex
conditions are tested in various parts of the code, which makes it
difficult to follow and error prone.

This patch introduces an enum into the nouveau_drm struct that indicates
which population method will be used for TT-backed BOs. It is set once
and for all during TTM initialization so the same conditions need not be
tested again and again. This will also allow us to add new non-default
TTM population cases by changing a single piece of code in
nouveau_ttm_init() instead of all over nouveau_bo.c

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c  | 63 ++++++++++++++++++-----------------
 drivers/gpu/drm/nouveau/nouveau_drm.h | 11 ++++++
 drivers/gpu/drm/nouveau/nouveau_ttm.c | 15 +++++++++
 3 files changed, 59 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 4db886f9f793..82c6b479abcb 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -28,7 +28,6 @@
  */
 
 #include <core/engine.h>
-#include <linux/swiotlb.h>
 
 #include <subdev/fb.h>
 #include <subdev/vm.h>
@@ -467,11 +466,11 @@ static struct ttm_tt *
 nouveau_ttm_tt_create(struct ttm_bo_device *bdev, unsigned long size,
 		      uint32_t page_flags, struct page *dummy_read)
 {
-#if __OS_HAS_AGP
+#if defined(TTM_HAS_AGP)
 	struct nouveau_drm *drm = nouveau_bdev(bdev);
 	struct drm_device *dev = drm->dev;
 
-	if (drm->agp.stat == ENABLED) {
+	if (drm->ttm.populate_method == AGP) {
 		return ttm_agp_tt_create(bdev, dev->agp->bridge, size,
 					 page_flags, dummy_read);
 	}
@@ -524,21 +523,23 @@ nouveau_bo_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
 		if (nv_device(drm->device)->card_type >= NV_50)
 			man->func = &nouveau_gart_manager;
 		else
-		if (drm->agp.stat != ENABLED)
+		if (drm->ttm.populate_method != AGP)
 			man->func = &nv04_gart_manager;
 		else
 			man->func = &ttm_bo_manager_func;
 
-		if (drm->agp.stat == ENABLED) {
-			man->flags = TTM_MEMTYPE_FLAG_MAPPABLE;
+		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE;
+
+		if (drm->ttm.populate_method != AGP)
+			man->flags |= TTM_MEMTYPE_FLAG_CMA;
+
+		if (drm->ttm.populate_method == POOL) {
+			man->available_caching = TTM_PL_MASK_CACHING;
+			man->default_caching = TTM_PL_FLAG_CACHED;
+		} else {
 			man->available_caching = TTM_PL_FLAG_UNCACHED |
 				TTM_PL_FLAG_WC;
 			man->default_caching = TTM_PL_FLAG_WC;
-		} else {
-			man->flags = TTM_MEMTYPE_FLAG_MAPPABLE |
-				     TTM_MEMTYPE_FLAG_CMA;
-			man->available_caching = TTM_PL_MASK_CACHING;
-			man->default_caching = TTM_PL_FLAG_CACHED;
 		}
 
 		break;
@@ -1249,13 +1250,11 @@ nouveau_ttm_io_mem_reserve(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem)
 		/* System memory */
 		return 0;
 	case TTM_PL_TT:
-#if __OS_HAS_AGP
-		if (drm->agp.stat == ENABLED) {
+		if (drm->ttm.populate_method == AGP) {
 			mem->bus.offset = mem->start << PAGE_SHIFT;
 			mem->bus.base = drm->agp.base;
 			mem->bus.is_iomem = !dev->agp->cant_use_aperture;
 		}
-#endif
 		if (nv_device(drm->device)->card_type < NV_50 || !node->memtype)
 			/* untiled */
 			break;
@@ -1359,17 +1358,20 @@ nouveau_ttm_tt_populate(struct ttm_tt *ttm)
 	device = nv_device(drm->device);
 	dev = drm->dev;
 
-#if __OS_HAS_AGP
-	if (drm->agp.stat == ENABLED) {
+	switch (drm->ttm.populate_method) {
+	case AGP:
+#if defined(TTM_HAS_AGP)
 		return ttm_agp_tt_populate(ttm);
-	}
+#else
+		return 0;
 #endif
+	case DMA:
+		return ttm_dma_populate(ttm_dma, dev->dev);
 
-#ifdef CONFIG_SWIOTLB
-	if (swiotlb_nr_tbl()) {
-		return ttm_dma_populate((void *)ttm, dev->dev);
+	case POOL:
+		/* POOL case is handled below */
+		break;
 	}
-#endif
 
 	r = ttm_pool_populate(ttm);
 	if (r) {
@@ -1409,19 +1411,20 @@ nouveau_ttm_tt_unpopulate(struct ttm_tt *ttm)
 	device = nv_device(drm->device);
 	dev = drm->dev;
 
-#if __OS_HAS_AGP
-	if (drm->agp.stat == ENABLED) {
+	switch (drm->ttm.populate_method) {
+	case AGP:
+#if defined(TTM_HAS_AGP)
 		ttm_agp_tt_unpopulate(ttm);
-		return;
-	}
 #endif
-
-#ifdef CONFIG_SWIOTLB
-	if (swiotlb_nr_tbl()) {
-		ttm_dma_unpopulate((void *)ttm, dev->dev);
 		return;
+	case DMA:
+		ttm_dma_unpopulate(ttm_dma, dev->dev);
+		return;
+
+	case POOL:
+		/* POOL case is handled below */
+		break;
 	}
-#endif
 
 	for (i = 0; i < ttm->num_pages; i++) {
 		if (ttm_dma->dma_address[i]) {
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.h b/drivers/gpu/drm/nouveau/nouveau_drm.h
index 7efbafaf7c1d..0d4b9eff8863 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.h
@@ -103,6 +103,17 @@ struct nouveau_drm {
 			    struct ttm_mem_reg *, struct ttm_mem_reg *);
 		struct nouveau_channel *chan;
 		int mtrr;
+		/*
+		 * How TTM objects are populated:
+		 * POOL: use ttm_pool_populate()
+		 * AGP: use ttm_agp_tt_populate()
+		 * DMA: use ttm_dma_populate()
+		 */
+		enum {
+			POOL,
+			AGP,
+			DMA,
+		} populate_method;
 	} ttm;
 
 	/* GEM interface support */
diff --git a/drivers/gpu/drm/nouveau/nouveau_ttm.c b/drivers/gpu/drm/nouveau/nouveau_ttm.c
index ab0228f640a5..70893416d4b6 100644
--- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
@@ -24,6 +24,10 @@
  * USE OR OTHER DEALINGS IN THE SOFTWARE.
  */
 
+#include <linux/dma-mapping.h>
+#include <linux/swiotlb.h>
+#include <linux/kconfig.h>
+
 #include <subdev/fb.h>
 #include <subdev/vm.h>
 #include <subdev/instmem.h>
@@ -375,6 +379,17 @@ nouveau_ttm_init(struct nouveau_drm *drm)
 						    DMA_BIT_MASK(32));
 	}
 
+	drm->ttm.populate_method = POOL;
+
+#ifdef CONFIG_SWIOTLB
+	if (swiotlb_nr_tbl())
+		drm->ttm.populate_method = DMA;
+#endif
+#if defined(TTM_HAS_AGP)
+	if (drm->agp.stat == ENABLED)
+		drm->ttm.populate_method = AGP;
+#endif
+
 	ret = nouveau_ttm_global_init(drm);
 	if (ret)
 		return ret;
-- 
2.0.0

