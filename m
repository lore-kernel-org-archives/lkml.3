Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3HBKiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:38:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030498Ab3HBKMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:12:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 84/99] drm/nouveau: fix semaphore dmabuf obj
Date: Fri,  2 Aug 2013 18:08:37 +0800
Message-Id: <20130802100237.613209901@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

commit 7a7da592cbb22a1d360638dbecc393470c5effe3 upstream.

Fixes some dmabuf object errors on nv50 chipset and below.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nv17_fence.c |    2 +-
 drivers/gpu/drm/nouveau/nv50_fence.c |   14 +++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/nouveau/nv17_fence.c
+++ b/drivers/gpu/drm/nouveau/nv17_fence.c
@@ -76,7 +76,7 @@ nv17_fence_context_new(struct nouveau_ch
 	struct ttm_mem_reg *mem = &priv->bo->bo.mem;
 	struct nouveau_object *object;
 	u32 start = mem->start * PAGE_SIZE;
-	u32 limit = mem->start + mem->size - 1;
+	u32 limit = start + mem->size - 1;
 	int ret = 0;
 
 	fctx = chan->fence = kzalloc(sizeof(*fctx), GFP_KERNEL);
--- a/drivers/gpu/drm/nouveau/nv50_fence.c
+++ b/drivers/gpu/drm/nouveau/nv50_fence.c
@@ -39,6 +39,8 @@ nv50_fence_context_new(struct nouveau_ch
 	struct nv10_fence_chan *fctx;
 	struct ttm_mem_reg *mem = &priv->bo->bo.mem;
 	struct nouveau_object *object;
+	u32 start = mem->start * PAGE_SIZE;
+	u32 limit = start + mem->size - 1;
 	int ret, i;
 
 	fctx = chan->fence = kzalloc(sizeof(*fctx), GFP_KERNEL);
@@ -51,26 +53,28 @@ nv50_fence_context_new(struct nouveau_ch
 	fctx->base.sync = nv17_fence_sync;
 
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


