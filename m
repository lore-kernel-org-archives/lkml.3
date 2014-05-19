Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaESHLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 03:11:34 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19761 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbaESHLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 03:11:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 19 May 2014 00:05:45 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 3/4] drm/nouveau: hook up cache sync functions
Date: Mon, 19 May 2014 16:10:57 +0900
Message-ID: <1400483458-9648-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucas Stach <dev@lynxeye.de>

Signed-off-by: Lucas Stach <dev@lynxeye.de>
[acourbot@nvidia.com: make conditional and platform-friendly]
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c  | 32 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/nouveau/nouveau_bo.h  | 20 ++++++++++++++++++++
 drivers/gpu/drm/nouveau/nouveau_gem.c |  8 +++++++-
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index b6dc85c614be..0886f47e5244 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -407,6 +407,8 @@ nouveau_bo_validate(struct nouveau_bo *nvbo, bool interruptible,
 {
 	int ret;
 
+	nouveau_bo_sync_for_device(nvbo);
+
 	ret = ttm_bo_validate(&nvbo->bo, &nvbo->placement,
 			      interruptible, no_wait_gpu);
 	if (ret)
@@ -487,6 +489,36 @@ nouveau_bo_invalidate_caches(struct ttm_bo_device *bdev, uint32_t flags)
 	return 0;
 }
 
+#ifdef NOUVEAU_NEED_CACHE_SYNC
+void
+nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
+{
+	struct nouveau_device *device;
+	struct ttm_tt *ttm = nvbo->bo.ttm;
+
+	device = nouveau_dev(nouveau_bdev(ttm->bdev)->dev);
+
+	if (nvbo->bo.ttm && nvbo->bo.ttm->caching_state == tt_cached)
+		ttm_dma_tt_cache_sync_for_cpu((struct ttm_dma_tt *)nvbo->bo.ttm,
+					      nv_device_base(device));
+}
+
+void
+nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
+{
+	struct ttm_tt *ttm = nvbo->bo.ttm;
+
+	if (ttm && ttm->caching_state == tt_cached) {
+		struct nouveau_device *device;
+
+		device = nouveau_dev(nouveau_bdev(ttm->bdev)->dev);
+
+		ttm_dma_tt_cache_sync_for_device((struct ttm_dma_tt *)ttm,
+						 nv_device_base(device));
+	}
+}
+#endif
+
 static int
 nouveau_bo_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
 			 struct ttm_mem_type_manager *man)
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.h b/drivers/gpu/drm/nouveau/nouveau_bo.h
index ff17c1f432fc..ead214931223 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.h
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.h
@@ -89,6 +89,26 @@ int  nouveau_bo_vma_add(struct nouveau_bo *, struct nouveau_vm *,
 			struct nouveau_vma *);
 void nouveau_bo_vma_del(struct nouveau_bo *, struct nouveau_vma *);
 
+#if IS_ENABLED(CONFIG_ARCH_TEGRA)
+#define NOUVEAU_NEED_CACHE_SYNC
+#endif
+
+#ifdef NOUVEAU_NEED_CACHE_SYNC
+void nouveau_bo_sync_for_cpu(struct nouveau_bo *);
+void nouveau_bo_sync_for_device(struct nouveau_bo *);
+#else
+static inline void
+nouveau_bo_sync_for_cpu(struct nouveau_bo *)
+{
+}
+
+static inline void
+nouveau_bo_sync_for_device(struct nouveau_bo *)
+{
+}
+#endif
+
+
 /* TODO: submit equivalent to TTM generic API upstream? */
 static inline void __iomem *
 nvbo_kmap_obj_iovirtual(struct nouveau_bo *nvbo)
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index c90c0dc0afe8..b7e42fdc9634 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -897,7 +897,13 @@ nouveau_gem_ioctl_cpu_prep(struct drm_device *dev, void *data,
 	ret = ttm_bo_wait(&nvbo->bo, true, true, no_wait);
 	spin_unlock(&nvbo->bo.bdev->fence_lock);
 	drm_gem_object_unreference_unlocked(gem);
-	return ret;
+
+	if (ret)
+		return ret;
+
+	nouveau_bo_sync_for_cpu(nvbo);
+
+	return 0;
 }
 
 int
-- 
1.9.2

