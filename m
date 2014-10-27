Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaJ0Jts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:49:48 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3026 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaJ0Jtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:49:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 27 Oct 2014 02:49:06 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v5 4/4] drm: synchronize BOs when required
Date: Mon, 27 Oct 2014 18:49:19 +0900
Message-ID: <1414403359-22332-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414403359-22332-1-git-send-email-acourbot@nvidia.com>
References: <1414403359-22332-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On architectures for which access to GPU memory is non-coherent,
caches need to be flushed and invalidated explicitly when BO control
changes between CPU and GPU.

This patch adds buffer synchronization functions which invokes the
correct API (PCI or DMA) to ensure synchronization is effective.

Based on the TTM DMA cache helper patches by Lucas Stach.

Signed-off-by: Lucas Stach <dev@lynxeye.de>
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drm/nouveau_bo.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
 drm/nouveau_bo.h  |  2 ++
 drm/nouveau_gem.c | 12 ++++++++++++
 3 files changed, 56 insertions(+)

diff --git a/drm/nouveau_bo.c b/drm/nouveau_bo.c
index ed9a6946f6d6..d2a4768e3efd 100644
--- a/drm/nouveau_bo.c
+++ b/drm/nouveau_bo.c
@@ -426,6 +426,46 @@ nouveau_bo_unmap(struct nouveau_bo *nvbo)
 		ttm_bo_kunmap(&nvbo->kmap);
 }
 
+void
+nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
+{
+	struct nouveau_drm *drm = nouveau_bdev(nvbo->bo.bdev);
+	struct nouveau_device *device = nvkm_device(&drm->device);
+	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
+	int i;
+
+	if (!ttm_dma)
+		return;
+
+	/* Don't waste time looping if the object is coherent */
+	if (nvbo->force_coherent)
+		return;
+
+	for (i = 0; i < ttm_dma->ttm.num_pages; i++)
+		dma_sync_single_for_device(nv_device_base(device),
+			ttm_dma->dma_address[i], PAGE_SIZE, DMA_TO_DEVICE);
+}
+
+void
+nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
+{
+	struct nouveau_drm *drm = nouveau_bdev(nvbo->bo.bdev);
+	struct nouveau_device *device = nvkm_device(&drm->device);
+	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
+	int i;
+
+	if (!ttm_dma)
+		return;
+
+	/* Don't waste time looping if the object is coherent */
+	if (nvbo->force_coherent)
+		return;
+
+	for (i = 0; i < ttm_dma->ttm.num_pages; i++)
+		dma_sync_single_for_cpu(nv_device_base(device),
+			ttm_dma->dma_address[i], PAGE_SIZE, DMA_FROM_DEVICE);
+}
+
 int
 nouveau_bo_validate(struct nouveau_bo *nvbo, bool interruptible,
 		    bool no_wait_gpu)
@@ -437,6 +477,8 @@ nouveau_bo_validate(struct nouveau_bo *nvbo, bool interruptible,
 	if (ret)
 		return ret;
 
+	nouveau_bo_sync_for_device(nvbo);
+
 	return 0;
 }
 
diff --git a/drm/nouveau_bo.h b/drm/nouveau_bo.h
index 0f8bbd48a0b9..c827f233e41d 100644
--- a/drm/nouveau_bo.h
+++ b/drm/nouveau_bo.h
@@ -85,6 +85,8 @@ void nouveau_bo_wr32(struct nouveau_bo *, unsigned index, u32 val);
 void nouveau_bo_fence(struct nouveau_bo *, struct nouveau_fence *, bool exclusive);
 int  nouveau_bo_validate(struct nouveau_bo *, bool interruptible,
 			 bool no_wait_gpu);
+void nouveau_bo_sync_for_device(struct nouveau_bo *nvbo);
+void nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo);
 
 struct nouveau_vma *
 nouveau_bo_vma_find(struct nouveau_bo *, struct nouveau_vm *);
diff --git a/drm/nouveau_gem.c b/drm/nouveau_gem.c
index 36951ee4b157..42c34babc2e5 100644
--- a/drm/nouveau_gem.c
+++ b/drm/nouveau_gem.c
@@ -867,6 +867,7 @@ nouveau_gem_ioctl_cpu_prep(struct drm_device *dev, void *data,
 		else
 			ret = lret;
 	}
+	nouveau_bo_sync_for_cpu(nvbo);
 	drm_gem_object_unreference_unlocked(gem);
 
 	return ret;
@@ -876,6 +877,17 @@ int
 nouveau_gem_ioctl_cpu_fini(struct drm_device *dev, void *data,
 			   struct drm_file *file_priv)
 {
+	struct drm_nouveau_gem_cpu_fini *req = data;
+	struct drm_gem_object *gem;
+	struct nouveau_bo *nvbo;
+
+	gem = drm_gem_object_lookup(dev, file_priv, req->handle);
+	if (!gem)
+		return -ENOENT;
+	nvbo = nouveau_gem_object(gem);
+
+	nouveau_bo_sync_for_device(nvbo);
+	drm_gem_object_unreference_unlocked(gem);
 	return 0;
 }
 
-- 
2.1.2

