Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaENO5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:57:51 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42626 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaENO5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:57:49 -0400
Subject: [RFC PATCH v1 04/16] drm/nouveau: require reservations for
 nouveau_fence_sync and nouveau_bo_fence
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Wed, 14 May 2014 16:57:46 +0200
Message-ID: <20140514145746.21163.80399.stgit@patser>
In-Reply-To: <20140514145134.21163.32350.stgit@patser>
References: <20140514145134.21163.32350.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will ensure we always hold the required lock when calling those functions.
---
 drivers/gpu/drm/nouveau/nouveau_bo.c      |    2 ++
 drivers/gpu/drm/nouveau/nouveau_display.c |   17 +++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index b6dc85c614be..33eb7164525a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -1431,6 +1431,8 @@ nouveau_bo_fence(struct nouveau_bo *nvbo, struct nouveau_fence *fence)
 	struct nouveau_fence *new_fence = nouveau_fence_ref(fence);
 	struct nouveau_fence *old_fence = NULL;
 
+	lockdep_assert_held(&nvbo->bo.resv->lock.base);
+
 	spin_lock(&nvbo->bo.bdev->fence_lock);
 	old_fence = nvbo->bo.sync_obj;
 	nvbo->bo.sync_obj = new_fence;
diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index da764a4ed958..61b8c3375135 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -716,6 +716,9 @@ nouveau_crtc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 	}
 
 	mutex_lock(&chan->cli->mutex);
+	ret = ttm_bo_reserve(&new_bo->bo, true, false, false, NULL);
+	if (ret)
+		goto fail_unpin;
 
 	/* synchronise rendering channel with the kernel's channel */
 	spin_lock(&new_bo->bo.bdev->fence_lock);
@@ -723,12 +726,18 @@ nouveau_crtc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 	spin_unlock(&new_bo->bo.bdev->fence_lock);
 	ret = nouveau_fence_sync(fence, chan);
 	nouveau_fence_unref(&fence);
-	if (ret)
+	if (ret) {
+		ttm_bo_unreserve(&new_bo->bo);
 		goto fail_unpin;
+	}
 
-	ret = ttm_bo_reserve(&old_bo->bo, true, false, false, NULL);
-	if (ret)
-		goto fail_unpin;
+	if (new_bo != old_bo) {
+		ttm_bo_unreserve(&new_bo->bo);
+
+		ret = ttm_bo_reserve(&old_bo->bo, true, false, false, NULL);
+		if (ret)
+			goto fail_unpin;
+	}
 
 	/* Initialize a page flip struct */
 	*s = (struct nouveau_page_flip_state)

