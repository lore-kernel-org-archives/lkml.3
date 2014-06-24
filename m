Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaFXJ41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 05:56:27 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15963 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaFXJ4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:56:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Jun 2014 02:50:21 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 3/3] drm/nouveau: hook up cache sync functions
Date: Tue, 24 Jun 2014 18:54:27 +0900
Message-ID: <1403603667-11302-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403603667-11302-1-git-send-email-acourbot@nvidia.com>
References: <1403603667-11302-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucas Stach <dev@lynxeye.de>

Use the newly-introduced TTM cache sync functions in Nouveau.

Signed-off-by: Lucas Stach <dev@lynxeye.de>
[acourbot@nvidia.com: rearrange code, make platform-friendly]
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c  | 47 +++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/nouveau/nouveau_bo.h  |  1 +
 drivers/gpu/drm/nouveau/nouveau_gem.c | 10 +++-----
 3 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index b6dc85c614be..74c68c16e777 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -284,6 +284,34 @@ set_placement_range(struct nouveau_bo *nvbo, uint32_t type)
 	}
 }
 
+static void
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
+static void
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
+
 void
 nouveau_bo_placement_set(struct nouveau_bo *nvbo, uint32_t type, uint32_t busy)
 {
@@ -407,6 +435,8 @@ nouveau_bo_validate(struct nouveau_bo *nvbo, bool interruptible,
 {
 	int ret;
 
+	nouveau_bo_sync_for_device(nvbo);
+
 	ret = ttm_bo_validate(&nvbo->bo, &nvbo->placement,
 			      interruptible, no_wait_gpu);
 	if (ret)
@@ -415,6 +445,23 @@ nouveau_bo_validate(struct nouveau_bo *nvbo, bool interruptible,
 	return 0;
 }
 
+int
+nouveau_bo_wait(struct nouveau_bo *nvbo, bool no_wait)
+{
+	int ret;
+
+	spin_lock(&nvbo->bo.bdev->fence_lock);
+	ret = ttm_bo_wait(&nvbo->bo, true, true, no_wait);
+	spin_unlock(&nvbo->bo.bdev->fence_lock);
+
+	if (ret)
+		return ret;
+
+	nouveau_bo_sync_for_cpu(nvbo);
+
+	return 0;
+}
+
 u16
 nouveau_bo_rd16(struct nouveau_bo *nvbo, unsigned index)
 {
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.h b/drivers/gpu/drm/nouveau/nouveau_bo.h
index ff17c1f432fc..a4e9052d54fd 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.h
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.h
@@ -81,6 +81,7 @@ void nouveau_bo_wr32(struct nouveau_bo *, unsigned index, u32 val);
 void nouveau_bo_fence(struct nouveau_bo *, struct nouveau_fence *);
 int  nouveau_bo_validate(struct nouveau_bo *, bool interruptible,
 			 bool no_wait_gpu);
+int nouveau_bo_wait(struct nouveau_bo *, bool no_wait);
 
 struct nouveau_vma *
 nouveau_bo_vma_find(struct nouveau_bo *, struct nouveau_vm *);
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index c90c0dc0afe8..916cb8ff568c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -884,19 +884,15 @@ nouveau_gem_ioctl_cpu_prep(struct drm_device *dev, void *data,
 {
 	struct drm_nouveau_gem_cpu_prep *req = data;
 	struct drm_gem_object *gem;
-	struct nouveau_bo *nvbo;
 	bool no_wait = !!(req->flags & NOUVEAU_GEM_CPU_PREP_NOWAIT);
-	int ret = -EINVAL;
+	int ret;
 
 	gem = drm_gem_object_lookup(dev, file_priv, req->handle);
 	if (!gem)
 		return -ENOENT;
-	nvbo = nouveau_gem_object(gem);
-
-	spin_lock(&nvbo->bo.bdev->fence_lock);
-	ret = ttm_bo_wait(&nvbo->bo, true, true, no_wait);
-	spin_unlock(&nvbo->bo.bdev->fence_lock);
+	ret = nouveau_bo_wait(nouveau_gem_object(gem), no_wait);
 	drm_gem_object_unreference_unlocked(gem);
+
 	return ret;
 }
 
-- 
2.0.0

