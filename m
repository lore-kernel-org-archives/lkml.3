Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaGaPev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:34:51 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57073 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaGaPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:34:48 -0400
Subject: [PATCH 19/19] drm/ttm: use rcu in core ttm
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Thu, 31 Jul 2014 17:34:44 +0200
Message-ID: <20140731153444.15061.2426.stgit@patser>
In-Reply-To: <20140731153245.15061.63023.stgit@patser>
References: <20140731153245.15061.63023.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_bo.c |   76 +++++++-----------------------------------
 1 file changed, 13 insertions(+), 63 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 9d36cffad3b7..d119ae4419d4 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -466,66 +466,6 @@ static void ttm_bo_cleanup_refs_or_queue(struct ttm_buffer_object *bo)
 			      ((HZ / 100) < 1) ? 1 : HZ / 100);
 }
 
-static int ttm_bo_unreserve_and_wait(struct ttm_buffer_object *bo,
-				     bool interruptible)
-{
-	struct ttm_bo_global *glob = bo->glob;
-	struct reservation_object_list *fobj;
-	struct fence *excl = NULL;
-	struct fence **shared = NULL;
-	u32 shared_count = 0, i;
-	int ret = 0;
-
-	fobj = reservation_object_get_list(bo->resv);
-	if (fobj && fobj->shared_count) {
-		shared = kmalloc(sizeof(*shared) * fobj->shared_count,
-				 GFP_KERNEL);
-
-		if (!shared) {
-			ret = -ENOMEM;
-			__ttm_bo_unreserve(bo);
-			spin_unlock(&glob->lru_lock);
-			return ret;
-		}
-
-		for (i = 0; i < fobj->shared_count; ++i) {
-			if (!fence_is_signaled(fobj->shared[i])) {
-				fence_get(fobj->shared[i]);
-				shared[shared_count++] = fobj->shared[i];
-			}
-		}
-		if (!shared_count) {
-			kfree(shared);
-			shared = NULL;
-		}
-	}
-
-	excl = reservation_object_get_excl(bo->resv);
-	if (excl && !fence_is_signaled(excl))
-		fence_get(excl);
-	else
-		excl = NULL;
-
-	__ttm_bo_unreserve(bo);
-	spin_unlock(&glob->lru_lock);
-
-	if (excl) {
-		ret = fence_wait(excl, interruptible);
-		fence_put(excl);
-	}
-
-	if (shared_count > 0) {
-		for (i = 0; i < shared_count; ++i) {
-			if (!ret)
-				ret = fence_wait(shared[i], interruptible);
-			fence_put(shared[i]);
-		}
-		kfree(shared);
-	}
-
-	return ret;
-}
-
 /**
  * function ttm_bo_cleanup_refs_and_unlock
  * If bo idle, remove from delayed- and lru lists, and unref.
@@ -549,9 +489,19 @@ static int ttm_bo_cleanup_refs_and_unlock(struct ttm_buffer_object *bo,
 	ret = ttm_bo_wait(bo, false, false, true);
 
 	if (ret && !no_wait_gpu) {
-		ret = ttm_bo_unreserve_and_wait(bo, interruptible);
-		if (ret)
-			return ret;
+		long lret;
+		ww_mutex_unlock(&bo->resv->lock);
+		spin_unlock(&glob->lru_lock);
+
+		lret = reservation_object_wait_timeout_rcu(bo->resv,
+							   true,
+							   interruptible,
+							   30 * HZ);
+
+		if (lret < 0)
+			return lret;
+		else if (lret == 0)
+			return -EBUSY;
 
 		spin_lock(&glob->lru_lock);
 		ret = __ttm_bo_reserve(bo, false, true, false, NULL);

