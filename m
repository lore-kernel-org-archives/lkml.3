Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3HPWkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:40:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3HPWkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 068/133] drm/nouveau: fix semaphore dmabuf obj
Date: Fri, 16 Aug 2013 15:33:30 -0700
Message-Id: <1376692475-28413-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

commit 7a7da592cbb22a1d360638dbecc393470c5effe3 upstream.

Fixes some dmabuf object errors on nv50 chipset and below.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/nv10_fence.c |  2 +-
 drivers/gpu/drm/nouveau/nv50_fence.c | 14 +++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv10_fence.c b/drivers/gpu/drm/nouveau/nv10_fence.c
index 03017f2..4f1d5d3 100644
--- a/drivers/gpu/drm/nouveau/nv10_fence.c
+++ b/drivers/gpu/drm/nouveau/nv10_fence.c
@@ -132,7 +132,7 @@ nv10_fence_context_new(struct nouveau_channel *chan)
 		struct ttm_mem_reg *mem = &priv->bo->bo.mem;
 		struct nouveau_object *object;
 		u32 start = mem->start * PAGE_SIZE;
-		u32 limit = mem->start + mem->size - 1;
+		u32 limit = start + mem->size - 1;
 
 		ret = nouveau_object_new(nv_object(chan->cli), chan->handle,
 					 NvSema, 0x0002,
diff --git a/drivers/gpu/drm/nouveau/nv50_fence.c b/drivers/gpu/drm/nouveau/nv50_fence.c
index d889f3a..923c7ef 100644
--- a/drivers/gpu/drm/nouveau/nv50_fence.c
+++ b/drivers/gpu/drm/nouveau/nv50_fence.c
@@ -50,6 +50,8 @@ nv50_fence_context_new(struct nouveau_channel *chan)
 	struct nv50_fence_chan *fctx;
 	struct ttm_mem_reg *mem = &priv->bo->bo.mem;
 	struct nouveau_object *object;
+	u32 start = mem->start * PAGE_SIZE;
+	u32 limit = start + mem->size - 1;
 	int ret, i;
 
 	fctx = chan->fence = kzalloc(sizeof(*fctx), GFP_KERNEL);
@@ -59,26 +61,28 @@ nv50_fence_context_new(struct nouveau_channel *chan)
 	nouveau_fence_context_new(&fctx->base);
 
 	ret = nouveau_object_new(nv_object(chan->cli), chan->handle,
-				 NvSema, 0x0002,
+				 NvSema, 0x003d,
 				 &(struct nv_dma_class) {
 					.flags = NV_DMA_TARGET_VRAM |
 						 NV_DMA_ACCESS_RDWR,
-					.start = mem->start * PAGE_SIZE,
-					.limit = mem->size - 1,
+					.start = start,
+					.limit = limit,
 				 }, sizeof(struct nv_dma_class),
 				 &object);
 
 	/* dma objects for display sync channel semaphore blocks */
 	for (i = 0; !ret && i < dev->mode_config.num_crtc; i++) {
 		struct nouveau_bo *bo = nv50_display_crtc_sema(dev, i);
+		u32 start = bo->bo.mem.start * PAGE_SIZE;
+		u32 limit = start + bo->bo.mem.size - 1;
 
 		ret = nouveau_object_new(nv_object(chan->cli), chan->handle,
 					 NvEvoSema0 + i, 0x003d,
 					 &(struct nv_dma_class) {
 						.flags = NV_DMA_TARGET_VRAM |
 							 NV_DMA_ACCESS_RDWR,
-						.start = bo->bo.offset,
-						.limit = bo->bo.offset + 0xfff,
+						.start = start,
+						.limit = limit,
 					 }, sizeof(struct nv_dma_class),
 					 &object);
 	}
-- 
1.8.1.2

