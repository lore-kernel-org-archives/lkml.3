Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaGaPd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:33:26 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56730 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaGaPdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:33:23 -0400
Subject: [PATCH 05/19] drm/nouveau: require reservations for
 nouveau_fence_sync and nouveau_bo_fence
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Thu, 31 Jul 2014 17:33:15 +0200
Message-ID: <20140731153315.15061.61561.stgit@patser>
In-Reply-To: <20140731153245.15061.63023.stgit@patser>
References: <20140731153245.15061.63023.stgit@patser>
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
index ba29a701ca1d..62d79492c7c5 100644
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
index 47ad74255bf1..826b66c44235 100644
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

