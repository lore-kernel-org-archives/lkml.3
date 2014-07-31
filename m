Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaGaPdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:33:39 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56759 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaGaPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:33:37 -0400
Subject: [PATCH 07/19] drm/ttm: kill fence_lock
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Thu, 31 Jul 2014 17:33:27 +0200
Message-ID: <20140731153327.15061.16896.stgit@patser>
In-Reply-To: <20140731153245.15061.63023.stgit@patser>
References: <20140731153245.15061.63023.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users are left, kill it off! :D
Conversion to the reservation api is next on the list, after
that the functionality can be restored with rcu.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c      |   25 +++-------
 drivers/gpu/drm/nouveau/nouveau_display.c |    6 --
 drivers/gpu/drm/nouveau/nouveau_gem.c     |   16 +-----
 drivers/gpu/drm/qxl/qxl_cmd.c             |    2 -
 drivers/gpu/drm/qxl/qxl_fence.c           |    4 --
 drivers/gpu/drm/qxl/qxl_object.h          |    2 -
 drivers/gpu/drm/qxl/qxl_release.c         |    2 -
 drivers/gpu/drm/radeon/radeon_display.c   |    9 ++-
 drivers/gpu/drm/radeon/radeon_object.c    |    2 -
 drivers/gpu/drm/ttm/ttm_bo.c              |   75 +++++++----------------------
 drivers/gpu/drm/ttm/ttm_bo_util.c         |    5 --
 drivers/gpu/drm/ttm/ttm_bo_vm.c           |    3 -
 drivers/gpu/drm/ttm/ttm_execbuf_util.c    |    2 -
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c    |    4 --
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c  |   17 ++-----
 include/drm/ttm/ttm_bo_api.h              |    5 --
 include/drm/ttm/ttm_bo_driver.h           |    3 -
 17 files changed, 40 insertions(+), 142 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 62d79492c7c5..2cf5b0572f66 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -1196,9 +1196,7 @@ nouveau_bo_move(struct ttm_buffer_object *bo, bool evict, bool intr,
 	}
 
 	/* Fallback to software copy. */
-	spin_lock(&bo->bdev->fence_lock);
 	ret = ttm_bo_wait(bo, true, intr, no_wait_gpu);
-	spin_unlock(&bo->bdev->fence_lock);
 	if (ret == 0)
 		ret = ttm_bo_move_memcpy(bo, evict, no_wait_gpu, new_mem);
 
@@ -1425,26 +1423,19 @@ nouveau_ttm_tt_unpopulate(struct ttm_tt *ttm)
 	ttm_pool_unpopulate(ttm);
 }
 
+static void
+nouveau_bo_fence_unref(void **sync_obj)
+{
+	nouveau_fence_unref((struct nouveau_fence **)sync_obj);
+}
+
 void
 nouveau_bo_fence(struct nouveau_bo *nvbo, struct nouveau_fence *fence)
 {
-	struct nouveau_fence *new_fence = nouveau_fence_ref(fence);
-	struct nouveau_fence *old_fence = NULL;
-
 	lockdep_assert_held(&nvbo->bo.resv->lock.base);
 
-	spin_lock(&nvbo->bo.bdev->fence_lock);
-	old_fence = nvbo->bo.sync_obj;
-	nvbo->bo.sync_obj = new_fence;
-	spin_unlock(&nvbo->bo.bdev->fence_lock);
-
-	nouveau_fence_unref(&old_fence);
-}
-
-static void
-nouveau_bo_fence_unref(void **sync_obj)
-{
-	nouveau_fence_unref((struct nouveau_fence **)sync_obj);
+	nouveau_bo_fence_unref(&nvbo->bo.sync_obj);
+	nvbo->bo.sync_obj = nouveau_fence_ref(fence);
 }
 
 static void *
diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index 826b66c44235..7928f8f07334 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -721,11 +721,7 @@ nouveau_crtc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 		goto fail_unpin;
 
 	/* synchronise rendering channel with the kernel's channel */
-	spin_lock(&new_bo->bo.bdev->fence_lock);
-	fence = nouveau_fence_ref(new_bo->bo.sync_obj);
-	spin_unlock(&new_bo->bo.bdev->fence_lock);
-	ret = nouveau_fence_sync(fence, chan);
-	nouveau_fence_unref(&fence);
+	ret = nouveau_fence_sync(new_bo->bo.sync_obj, chan);
 	if (ret) {
 		ttm_bo_unreserve(&new_bo->bo);
 		goto fail_unpin;
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 0da3740f150f..474f67238cef 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -105,9 +105,7 @@ nouveau_gem_object_unmap(struct nouveau_bo *nvbo, struct nouveau_vma *vma)
 	list_del(&vma->head);
 
 	if (mapped) {
-		spin_lock(&nvbo->bo.bdev->fence_lock);
 		fence = nouveau_fence_ref(nvbo->bo.sync_obj);
-		spin_unlock(&nvbo->bo.bdev->fence_lock);
 	}
 
 	if (fence) {
@@ -432,17 +430,11 @@ retry:
 static int
 validate_sync(struct nouveau_channel *chan, struct nouveau_bo *nvbo)
 {
-	struct nouveau_fence *fence = NULL;
+	struct nouveau_fence *fence = nvbo->bo.sync_obj;
 	int ret = 0;
 
-	spin_lock(&nvbo->bo.bdev->fence_lock);
-	fence = nouveau_fence_ref(nvbo->bo.sync_obj);
-	spin_unlock(&nvbo->bo.bdev->fence_lock);
-
-	if (fence) {
+	if (fence)
 		ret = nouveau_fence_sync(fence, chan);
-		nouveau_fence_unref(&fence);
-	}
 
 	return ret;
 }
@@ -661,9 +653,7 @@ nouveau_gem_pushbuf_reloc_apply(struct nouveau_cli *cli,
 				data |= r->vor;
 		}
 
-		spin_lock(&nvbo->bo.bdev->fence_lock);
 		ret = ttm_bo_wait(&nvbo->bo, false, false, false);
-		spin_unlock(&nvbo->bo.bdev->fence_lock);
 		if (ret) {
 			NV_ERROR(cli, "reloc wait_idle failed: %d\n", ret);
 			break;
@@ -896,11 +886,9 @@ nouveau_gem_ioctl_cpu_prep(struct drm_device *dev, void *data,
 
 	ret = ttm_bo_reserve(&nvbo->bo, true, false, false, 0);
 	if (!ret) {
-		spin_lock(&nvbo->bo.bdev->fence_lock);
 		ret = ttm_bo_wait(&nvbo->bo, true, true, true);
 		if (!no_wait && ret)
 			fence = nouveau_fence_ref(nvbo->bo.sync_obj);
-		spin_unlock(&nvbo->bo.bdev->fence_lock);
 
 		ttm_bo_unreserve(&nvbo->bo);
 	}
diff --git a/drivers/gpu/drm/qxl/qxl_cmd.c b/drivers/gpu/drm/qxl/qxl_cmd.c
index eb89653a7a17..45fad7b45486 100644
--- a/drivers/gpu/drm/qxl/qxl_cmd.c
+++ b/drivers/gpu/drm/qxl/qxl_cmd.c
@@ -628,9 +628,7 @@ static int qxl_reap_surf(struct qxl_device *qdev, struct qxl_bo *surf, bool stal
 	if (stall)
 		mutex_unlock(&qdev->surf_evict_mutex);
 
-	spin_lock(&surf->tbo.bdev->fence_lock);
 	ret = ttm_bo_wait(&surf->tbo, true, true, !stall);
-	spin_unlock(&surf->tbo.bdev->fence_lock);
 
 	if (stall)
 		mutex_lock(&qdev->surf_evict_mutex);
diff --git a/drivers/gpu/drm/qxl/qxl_fence.c b/drivers/gpu/drm/qxl/qxl_fence.c
index ae59e91cfb9a..c7248418117d 100644
--- a/drivers/gpu/drm/qxl/qxl_fence.c
+++ b/drivers/gpu/drm/qxl/qxl_fence.c
@@ -60,9 +60,6 @@ int qxl_fence_remove_release(struct qxl_fence *qfence, uint32_t rel_id)
 {
 	void *ret;
 	int retval = 0;
-	struct qxl_bo *bo = container_of(qfence, struct qxl_bo, fence);
-
-	spin_lock(&bo->tbo.bdev->fence_lock);
 
 	ret = radix_tree_delete(&qfence->tree, rel_id);
 	if (ret == qfence)
@@ -71,7 +68,6 @@ int qxl_fence_remove_release(struct qxl_fence *qfence, uint32_t rel_id)
 		DRM_DEBUG("didn't find fence in radix tree for %d\n", rel_id);
 		retval = -ENOENT;
 	}
-	spin_unlock(&bo->tbo.bdev->fence_lock);
 	return retval;
 }
 
diff --git a/drivers/gpu/drm/qxl/qxl_object.h b/drivers/gpu/drm/qxl/qxl_object.h
index 83a423293afd..1edaf5768086 100644
--- a/drivers/gpu/drm/qxl/qxl_object.h
+++ b/drivers/gpu/drm/qxl/qxl_object.h
@@ -76,12 +76,10 @@ static inline int qxl_bo_wait(struct qxl_bo *bo, u32 *mem_type,
 		}
 		return r;
 	}
-	spin_lock(&bo->tbo.bdev->fence_lock);
 	if (mem_type)
 		*mem_type = bo->tbo.mem.mem_type;
 	if (bo->tbo.sync_obj)
 		r = ttm_bo_wait(&bo->tbo, true, true, no_wait);
-	spin_unlock(&bo->tbo.bdev->fence_lock);
 	ttm_bo_unreserve(&bo->tbo);
 	return r;
 }
diff --git a/drivers/gpu/drm/qxl/qxl_release.c b/drivers/gpu/drm/qxl/qxl_release.c
index e85c4d274dc0..4045ba873ab8 100644
--- a/drivers/gpu/drm/qxl/qxl_release.c
+++ b/drivers/gpu/drm/qxl/qxl_release.c
@@ -337,7 +337,6 @@ void qxl_release_fence_buffer_objects(struct qxl_release *release)
 	glob = bo->glob;
 
 	spin_lock(&glob->lru_lock);
-	spin_lock(&bdev->fence_lock);
 
 	list_for_each_entry(entry, &release->bos, head) {
 		bo = entry->bo;
@@ -351,7 +350,6 @@ void qxl_release_fence_buffer_objects(struct qxl_release *release)
 		ttm_bo_add_to_lru(bo);
 		__ttm_bo_unreserve(bo);
 	}
-	spin_unlock(&bdev->fence_lock);
 	spin_unlock(&glob->lru_lock);
 	ww_acquire_fini(&release->ticket);
 }
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index bf25061c8ac4..3402540aa641 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -462,11 +462,6 @@ static int radeon_crtc_page_flip(struct drm_crtc *crtc,
 	obj = new_radeon_fb->obj;
 	new_rbo = gem_to_radeon_bo(obj);
 
-	spin_lock(&new_rbo->tbo.bdev->fence_lock);
-	if (new_rbo->tbo.sync_obj)
-		work->fence = radeon_fence_ref(new_rbo->tbo.sync_obj);
-	spin_unlock(&new_rbo->tbo.bdev->fence_lock);
-
 	/* pin the new buffer */
 	DRM_DEBUG_DRIVER("flip-ioctl() cur_rbo = %p, new_rbo = %p\n",
 			 work->old_rbo, new_rbo);
@@ -485,6 +480,10 @@ static int radeon_crtc_page_flip(struct drm_crtc *crtc,
 		DRM_ERROR("failed to pin new rbo buffer before flip\n");
 		goto cleanup;
 	}
+
+	if (new_rbo->tbo.sync_obj)
+		work->fence = radeon_fence_ref(new_rbo->tbo.sync_obj);
+
 	radeon_bo_get_tiling_flags(new_rbo, &tiling_flags, NULL);
 	radeon_bo_unreserve(new_rbo);
 
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index a3ed725ea641..8538aebb6580 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -734,12 +734,10 @@ int radeon_bo_wait(struct radeon_bo *bo, u32 *mem_type, bool no_wait)
 	r = ttm_bo_reserve(&bo->tbo, true, no_wait, false, NULL);
 	if (unlikely(r != 0))
 		return r;
-	spin_lock(&bo->tbo.bdev->fence_lock);
 	if (mem_type)
 		*mem_type = bo->tbo.mem.mem_type;
 	if (bo->tbo.sync_obj)
 		r = ttm_bo_wait(&bo->tbo, true, true, no_wait);
-	spin_unlock(&bo->tbo.bdev->fence_lock);
 	ttm_bo_unreserve(&bo->tbo);
 	return r;
 }
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index df08f18f05ac..c441ac6d546b 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -414,24 +414,20 @@ static void ttm_bo_cleanup_refs_or_queue(struct ttm_buffer_object *bo)
 	spin_lock(&glob->lru_lock);
 	ret = __ttm_bo_reserve(bo, false, true, false, NULL);
 
-	spin_lock(&bdev->fence_lock);
-	(void) ttm_bo_wait(bo, false, false, true);
-	if (!ret && !bo->sync_obj) {
-		spin_unlock(&bdev->fence_lock);
-		put_count = ttm_bo_del_from_lru(bo);
+	if (!ret) {
+		(void) ttm_bo_wait(bo, false, false, true);
 
-		spin_unlock(&glob->lru_lock);
-		ttm_bo_cleanup_memtype_use(bo);
+		if (!bo->sync_obj) {
+			put_count = ttm_bo_del_from_lru(bo);
 
-		ttm_bo_list_ref_sub(bo, put_count, true);
+			spin_unlock(&glob->lru_lock);
+			ttm_bo_cleanup_memtype_use(bo);
 
-		return;
-	}
-	if (bo->sync_obj)
-		sync_obj = driver->sync_obj_ref(bo->sync_obj);
-	spin_unlock(&bdev->fence_lock);
+			ttm_bo_list_ref_sub(bo, put_count, true);
 
-	if (!ret) {
+			return;
+		}
+		sync_obj = driver->sync_obj_ref(bo->sync_obj);
 
 		/*
 		 * Make NO_EVICT bos immediately available to
@@ -480,7 +476,6 @@ static int ttm_bo_cleanup_refs_and_unlock(struct ttm_buffer_object *bo,
 	int put_count;
 	int ret;
 
-	spin_lock(&bdev->fence_lock);
 	ret = ttm_bo_wait(bo, false, false, true);
 
 	if (ret && !no_wait_gpu) {
@@ -492,7 +487,6 @@ static int ttm_bo_cleanup_refs_and_unlock(struct ttm_buffer_object *bo,
 		 * no new sync objects can be attached.
 		 */
 		sync_obj = driver->sync_obj_ref(bo->sync_obj);
-		spin_unlock(&bdev->fence_lock);
 
 		__ttm_bo_unreserve(bo);
 		spin_unlock(&glob->lru_lock);
@@ -522,11 +516,9 @@ static int ttm_bo_cleanup_refs_and_unlock(struct ttm_buffer_object *bo,
 		 * remove sync_obj with ttm_bo_wait, the wait should be
 		 * finished, and no new wait object should have been added.
 		 */
-		spin_lock(&bdev->fence_lock);
 		ret = ttm_bo_wait(bo, false, false, true);
 		WARN_ON(ret);
 	}
-	spin_unlock(&bdev->fence_lock);
 
 	if (ret || unlikely(list_empty(&bo->ddestroy))) {
 		__ttm_bo_unreserve(bo);
@@ -664,9 +656,7 @@ static int ttm_bo_evict(struct ttm_buffer_object *bo, bool interruptible,
 	struct ttm_placement placement;
 	int ret = 0;
 
-	spin_lock(&bdev->fence_lock);
 	ret = ttm_bo_wait(bo, false, interruptible, no_wait_gpu);
-	spin_unlock(&bdev->fence_lock);
 
 	if (unlikely(ret != 0)) {
 		if (ret != -ERESTARTSYS) {
@@ -963,7 +953,6 @@ static int ttm_bo_move_buffer(struct ttm_buffer_object *bo,
 {
 	int ret = 0;
 	struct ttm_mem_reg mem;
-	struct ttm_bo_device *bdev = bo->bdev;
 
 	lockdep_assert_held(&bo->resv->lock.base);
 
@@ -972,9 +961,7 @@ static int ttm_bo_move_buffer(struct ttm_buffer_object *bo,
 	 * Have the driver move function wait for idle when necessary,
 	 * instead of doing it here.
 	 */
-	spin_lock(&bdev->fence_lock);
 	ret = ttm_bo_wait(bo, false, interruptible, no_wait_gpu);
-	spin_unlock(&bdev->fence_lock);
 	if (ret)
 		return ret;
 	mem.num_pages = bo->num_pages;
@@ -1474,7 +1461,6 @@ int ttm_bo_device_init(struct ttm_bo_device *bdev,
 	bdev->glob = glob;
 	bdev->need_dma32 = need_dma32;
 	bdev->val_seq = 0;
-	spin_lock_init(&bdev->fence_lock);
 	mutex_lock(&glob->device_list_mutex);
 	list_add_tail(&bdev->device_list, &glob->device_list);
 	mutex_unlock(&glob->device_list_mutex);
@@ -1532,7 +1518,6 @@ int ttm_bo_wait(struct ttm_buffer_object *bo,
 		bool lazy, bool interruptible, bool no_wait)
 {
 	struct ttm_bo_driver *driver = bo->bdev->driver;
-	struct ttm_bo_device *bdev = bo->bdev;
 	void *sync_obj;
 	int ret = 0;
 
@@ -1541,53 +1526,33 @@ int ttm_bo_wait(struct ttm_buffer_object *bo,
 	if (likely(bo->sync_obj == NULL))
 		return 0;
 
-	while (bo->sync_obj) {
-
+	if (bo->sync_obj) {
 		if (driver->sync_obj_signaled(bo->sync_obj)) {
-			void *tmp_obj = bo->sync_obj;
-			bo->sync_obj = NULL;
+			driver->sync_obj_unref(&bo->sync_obj);
 			clear_bit(TTM_BO_PRIV_FLAG_MOVING, &bo->priv_flags);
-			spin_unlock(&bdev->fence_lock);
-			driver->sync_obj_unref(&tmp_obj);
-			spin_lock(&bdev->fence_lock);
-			continue;
+			return 0;
 		}
 
 		if (no_wait)
 			return -EBUSY;
 
 		sync_obj = driver->sync_obj_ref(bo->sync_obj);
-		spin_unlock(&bdev->fence_lock);
 		ret = driver->sync_obj_wait(sync_obj,
 					    lazy, interruptible);
-		if (unlikely(ret != 0)) {
-			driver->sync_obj_unref(&sync_obj);
-			spin_lock(&bdev->fence_lock);
-			return ret;
-		}
-		spin_lock(&bdev->fence_lock);
-		if (likely(bo->sync_obj == sync_obj)) {
-			void *tmp_obj = bo->sync_obj;
-			bo->sync_obj = NULL;
+
+		if (likely(ret == 0)) {
 			clear_bit(TTM_BO_PRIV_FLAG_MOVING,
 				  &bo->priv_flags);
-			spin_unlock(&bdev->fence_lock);
-			driver->sync_obj_unref(&sync_obj);
-			driver->sync_obj_unref(&tmp_obj);
-			spin_lock(&bdev->fence_lock);
-		} else {
-			spin_unlock(&bdev->fence_lock);
-			driver->sync_obj_unref(&sync_obj);
-			spin_lock(&bdev->fence_lock);
+			driver->sync_obj_unref(&bo->sync_obj);
 		}
+		driver->sync_obj_unref(&sync_obj);
 	}
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(ttm_bo_wait);
 
 int ttm_bo_synccpu_write_grab(struct ttm_buffer_object *bo, bool no_wait)
 {
-	struct ttm_bo_device *bdev = bo->bdev;
 	int ret = 0;
 
 	/*
@@ -1597,9 +1562,7 @@ int ttm_bo_synccpu_write_grab(struct ttm_buffer_object *bo, bool no_wait)
 	ret = ttm_bo_reserve(bo, true, no_wait, false, NULL);
 	if (unlikely(ret != 0))
 		return ret;
-	spin_lock(&bdev->fence_lock);
 	ret = ttm_bo_wait(bo, false, true, no_wait);
-	spin_unlock(&bdev->fence_lock);
 	if (likely(ret == 0))
 		atomic_inc(&bo->cpu_writers);
 	ttm_bo_unreserve(bo);
@@ -1656,9 +1619,7 @@ static int ttm_bo_swapout(struct ttm_mem_shrink *shrink)
 	 * Wait for GPU, then move to system cached.
 	 */
 
-	spin_lock(&bo->bdev->fence_lock);
 	ret = ttm_bo_wait(bo, false, false, false);
-	spin_unlock(&bo->bdev->fence_lock);
 
 	if (unlikely(ret != 0))
 		goto out;
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 30e5d90cb7bc..495aebf0f9c3 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -466,12 +466,10 @@ static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
 	drm_vma_node_reset(&fbo->vma_node);
 	atomic_set(&fbo->cpu_writers, 0);
 
-	spin_lock(&bdev->fence_lock);
 	if (bo->sync_obj)
 		fbo->sync_obj = driver->sync_obj_ref(bo->sync_obj);
 	else
 		fbo->sync_obj = NULL;
-	spin_unlock(&bdev->fence_lock);
 	kref_init(&fbo->list_kref);
 	kref_init(&fbo->kref);
 	fbo->destroy = &ttm_transfered_destroy;
@@ -657,7 +655,6 @@ int ttm_bo_move_accel_cleanup(struct ttm_buffer_object *bo,
 	struct ttm_buffer_object *ghost_obj;
 	void *tmp_obj = NULL;
 
-	spin_lock(&bdev->fence_lock);
 	if (bo->sync_obj) {
 		tmp_obj = bo->sync_obj;
 		bo->sync_obj = NULL;
@@ -665,7 +662,6 @@ int ttm_bo_move_accel_cleanup(struct ttm_buffer_object *bo,
 	bo->sync_obj = driver->sync_obj_ref(sync_obj);
 	if (evict) {
 		ret = ttm_bo_wait(bo, false, false, false);
-		spin_unlock(&bdev->fence_lock);
 		if (tmp_obj)
 			driver->sync_obj_unref(&tmp_obj);
 		if (ret)
@@ -688,7 +684,6 @@ int ttm_bo_move_accel_cleanup(struct ttm_buffer_object *bo,
 		 */
 
 		set_bit(TTM_BO_PRIV_FLAG_MOVING, &bo->priv_flags);
-		spin_unlock(&bdev->fence_lock);
 		if (tmp_obj)
 			driver->sync_obj_unref(&tmp_obj);
 
diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
index 0ce48e5a9cb4..d05437f219e9 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -45,10 +45,8 @@ static int ttm_bo_vm_fault_idle(struct ttm_buffer_object *bo,
 				struct vm_area_struct *vma,
 				struct vm_fault *vmf)
 {
-	struct ttm_bo_device *bdev = bo->bdev;
 	int ret = 0;
 
-	spin_lock(&bdev->fence_lock);
 	if (likely(!test_bit(TTM_BO_PRIV_FLAG_MOVING, &bo->priv_flags)))
 		goto out_unlock;
 
@@ -82,7 +80,6 @@ static int ttm_bo_vm_fault_idle(struct ttm_buffer_object *bo,
 			VM_FAULT_NOPAGE;
 
 out_unlock:
-	spin_unlock(&bdev->fence_lock);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/ttm/ttm_execbuf_util.c b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
index 6db47a72667e..108730e9147b 100644
--- a/drivers/gpu/drm/ttm/ttm_execbuf_util.c
+++ b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
@@ -180,7 +180,6 @@ void ttm_eu_fence_buffer_objects(struct ww_acquire_ctx *ticket,
 	glob = bo->glob;
 
 	spin_lock(&glob->lru_lock);
-	spin_lock(&bdev->fence_lock);
 
 	list_for_each_entry(entry, list, head) {
 		bo = entry->bo;
@@ -189,7 +188,6 @@ void ttm_eu_fence_buffer_objects(struct ww_acquire_ctx *ticket,
 		ttm_bo_add_to_lru(bo);
 		__ttm_bo_unreserve(bo);
 	}
-	spin_unlock(&bdev->fence_lock);
 	spin_unlock(&glob->lru_lock);
 	if (ticket)
 		ww_acquire_fini(ticket);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
index 6327cfc36805..4a36bb1dc525 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
@@ -829,11 +829,7 @@ static void vmw_move_notify(struct ttm_buffer_object *bo,
  */
 static void vmw_swap_notify(struct ttm_buffer_object *bo)
 {
-	struct ttm_bo_device *bdev = bo->bdev;
-
-	spin_lock(&bdev->fence_lock);
 	ttm_bo_wait(bo, false, false, false);
-	spin_unlock(&bdev->fence_lock);
 }
 
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index 9d8c0a3f391c..936777e469bb 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -567,12 +567,12 @@ static int vmw_user_dmabuf_synccpu_grab(struct vmw_user_dma_buffer *user_bo,
 	int ret;
 
 	if (flags & drm_vmw_synccpu_allow_cs) {
-		struct ttm_bo_device *bdev = bo->bdev;
-
-		spin_lock(&bdev->fence_lock);
-		ret = ttm_bo_wait(bo, false, true,
-				  !!(flags & drm_vmw_synccpu_dontblock));
-		spin_unlock(&bdev->fence_lock);
+		ret = ttm_bo_reserve(bo, true, !!(flags & drm_vmw_synccpu_dontblock), false, 0);
+		if (!ret) {
+			ret = ttm_bo_wait(bo, false, true,
+					  !!(flags & drm_vmw_synccpu_dontblock));
+			ttm_bo_unreserve(bo);
+		}
 		return ret;
 	}
 
@@ -1429,12 +1429,10 @@ void vmw_fence_single_bo(struct ttm_buffer_object *bo,
 	else
 		driver->sync_obj_ref(fence);
 
-	spin_lock(&bdev->fence_lock);
 
 	old_fence_obj = bo->sync_obj;
 	bo->sync_obj = fence;
 
-	spin_unlock(&bdev->fence_lock);
 
 	if (old_fence_obj)
 		vmw_fence_obj_unreference(&old_fence_obj);
@@ -1475,7 +1473,6 @@ void vmw_resource_move_notify(struct ttm_buffer_object *bo,
 
 	if (mem->mem_type != VMW_PL_MOB) {
 		struct vmw_resource *res, *n;
-		struct ttm_bo_device *bdev = bo->bdev;
 		struct ttm_validate_buffer val_buf;
 
 		val_buf.bo = bo;
@@ -1491,9 +1488,7 @@ void vmw_resource_move_notify(struct ttm_buffer_object *bo,
 			list_del_init(&res->mob_head);
 		}
 
-		spin_lock(&bdev->fence_lock);
 		(void) ttm_bo_wait(bo, false, false, false);
-		spin_unlock(&bdev->fence_lock);
 	}
 }
 
diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
index 7526c5bf5610..67df9d7c06cc 100644
--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -227,10 +227,7 @@ struct ttm_buffer_object {
 	struct list_head io_reserve_lru;
 
 	/**
-	 * Members protected by struct buffer_object_device::fence_lock
-	 * In addition, setting sync_obj to anything else
-	 * than NULL requires bo::reserved to be held. This allows for
-	 * checking NULL while reserved but not holding the mentioned lock.
+	 * Members protected by a bo reservation.
 	 */
 
 	void *sync_obj;
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 202f0a7171e8..ff725df48595 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -520,8 +520,6 @@ struct ttm_bo_global {
  *
  * @driver: Pointer to a struct ttm_bo_driver struct setup by the driver.
  * @man: An array of mem_type_managers.
- * @fence_lock: Protects the synchronizing members on *all* bos belonging
- * to this device.
  * @vma_manager: Address space manager
  * lru_lock: Spinlock that protects the buffer+device lru lists and
  * ddestroy lists.
@@ -541,7 +539,6 @@ struct ttm_bo_device {
 	struct ttm_bo_global *glob;
 	struct ttm_bo_driver *driver;
 	struct ttm_mem_type_manager man[TTM_NUM_MEM_TYPES];
-	spinlock_t fence_lock;
 
 	/*
 	 * Protected by internal locks.

