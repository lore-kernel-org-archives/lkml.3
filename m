Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaGaPej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:34:39 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56973 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaGaPeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:34:37 -0400
Subject: [PATCH 15/19] drm/ttm: flip the switch, and convert to dma_fence
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Thu, 31 Jul 2014 17:34:20 +0200
Message-ID: <20140731153419.15061.43298.stgit@patser>
In-Reply-To: <20140731153245.15061.63023.stgit@patser>
References: <20140731153245.15061.63023.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---
 drivers/gpu/drm/nouveau/nouveau_bo.c     |   48 +-------
 drivers/gpu/drm/nouveau/nouveau_fence.c  |   24 +---
 drivers/gpu/drm/nouveau/nouveau_fence.h  |    2 
 drivers/gpu/drm/nouveau/nouveau_gem.c    |   16 ++-
 drivers/gpu/drm/qxl/qxl_debugfs.c        |    6 +
 drivers/gpu/drm/qxl/qxl_drv.h            |    2 
 drivers/gpu/drm/qxl/qxl_kms.c            |    1 
 drivers/gpu/drm/qxl/qxl_object.h         |    4 -
 drivers/gpu/drm/qxl/qxl_release.c        |    3 -
 drivers/gpu/drm/qxl/qxl_ttm.c            |  104 ------------------
 drivers/gpu/drm/radeon/radeon_cs.c       |   10 +-
 drivers/gpu/drm/radeon/radeon_display.c  |    3 -
 drivers/gpu/drm/radeon/radeon_object.c   |    4 -
 drivers/gpu/drm/radeon/radeon_ttm.c      |   34 ------
 drivers/gpu/drm/radeon/radeon_uvd.c      |    8 +
 drivers/gpu/drm/radeon/radeon_vm.c       |   14 ++
 drivers/gpu/drm/ttm/ttm_bo.c             |  171 +++++++++++++++++++++---------
 drivers/gpu/drm/ttm/ttm_bo_util.c        |   23 +---
 drivers/gpu/drm/ttm/ttm_execbuf_util.c   |   10 --
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c   |   40 -------
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |   14 +-
 include/drm/ttm/ttm_bo_api.h             |    2 
 include/drm/ttm/ttm_bo_driver.h          |   26 -----
 include/drm/ttm/ttm_execbuf_util.h       |   10 +-
 24 files changed, 193 insertions(+), 386 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 6e71d3dc2d87..3d8a8e18caea 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -92,13 +92,13 @@ nv10_bo_get_tile_region(struct drm_device *dev, int i)
 
 static void
 nv10_bo_put_tile_region(struct drm_device *dev, struct nouveau_drm_tile *tile,
-			struct nouveau_fence *fence)
+			struct fence *fence)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 
 	if (tile) {
 		spin_lock(&drm->tile.lock);
-		tile->fence = nouveau_fence_ref(fence);
+		tile->fence = nouveau_fence_ref((struct nouveau_fence *)fence);
 		tile->used = false;
 		spin_unlock(&drm->tile.lock);
 	}
@@ -965,7 +965,8 @@ nouveau_bo_move_m2mf(struct ttm_buffer_object *bo, int evict, bool intr,
 		if (ret == 0) {
 			ret = nouveau_fence_new(chan, false, &fence);
 			if (ret == 0) {
-				ret = ttm_bo_move_accel_cleanup(bo, fence,
+				ret = ttm_bo_move_accel_cleanup(bo,
+								&fence->base,
 								evict,
 								no_wait_gpu,
 								new_mem);
@@ -1151,8 +1152,9 @@ nouveau_bo_vm_cleanup(struct ttm_buffer_object *bo,
 {
 	struct nouveau_drm *drm = nouveau_bdev(bo->bdev);
 	struct drm_device *dev = drm->dev;
+	struct fence *fence = reservation_object_get_excl(bo->resv);
 
-	nv10_bo_put_tile_region(dev, *old_tile, bo->sync_obj);
+	nv10_bo_put_tile_region(dev, *old_tile, fence);
 	*old_tile = new_tile;
 }
 
@@ -1423,47 +1425,14 @@ nouveau_ttm_tt_unpopulate(struct ttm_tt *ttm)
 	ttm_pool_unpopulate(ttm);
 }
 
-static void
-nouveau_bo_fence_unref(void **sync_obj)
-{
-	nouveau_fence_unref((struct nouveau_fence **)sync_obj);
-}
-
 void
 nouveau_bo_fence(struct nouveau_bo *nvbo, struct nouveau_fence *fence)
 {
 	struct reservation_object *resv = nvbo->bo.resv;
 
-	nouveau_bo_fence_unref(&nvbo->bo.sync_obj);
-	nvbo->bo.sync_obj = nouveau_fence_ref(fence);
-
 	reservation_object_add_excl_fence(resv, &fence->base);
 }
 
-static void *
-nouveau_bo_fence_ref(void *sync_obj)
-{
-	return nouveau_fence_ref(sync_obj);
-}
-
-static bool
-nouveau_bo_fence_signalled(void *sync_obj)
-{
-	return nouveau_fence_done(sync_obj);
-}
-
-static int
-nouveau_bo_fence_wait(void *sync_obj, bool lazy, bool intr)
-{
-	return nouveau_fence_wait(sync_obj, lazy, intr);
-}
-
-static int
-nouveau_bo_fence_flush(void *sync_obj)
-{
-	return 0;
-}
-
 struct ttm_bo_driver nouveau_bo_driver = {
 	.ttm_tt_create = &nouveau_ttm_tt_create,
 	.ttm_tt_populate = &nouveau_ttm_tt_populate,
@@ -1474,11 +1443,6 @@ struct ttm_bo_driver nouveau_bo_driver = {
 	.move_notify = nouveau_bo_move_ntfy,
 	.move = nouveau_bo_move,
 	.verify_access = nouveau_bo_verify_access,
-	.sync_obj_signaled = nouveau_bo_fence_signalled,
-	.sync_obj_wait = nouveau_bo_fence_wait,
-	.sync_obj_flush = nouveau_bo_fence_flush,
-	.sync_obj_unref = nouveau_bo_fence_unref,
-	.sync_obj_ref = nouveau_bo_fence_ref,
 	.fault_reserve_notify = &nouveau_ttm_fault_reserve_notify,
 	.io_mem_reserve = &nouveau_ttm_io_mem_reserve,
 	.io_mem_free = &nouveau_ttm_io_mem_free,
diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/nouveau/nouveau_fence.c
index d24f8ce4341a..9f92ad37637d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -139,17 +139,18 @@ static bool nouveau_fence_is_signaled(struct fence *f)
 }
 
 void
-nouveau_fence_work(struct nouveau_fence *fence,
+nouveau_fence_work(struct fence *fence,
 		   void (*func)(void *), void *data)
 {
 	struct nouveau_fence_work *work;
 
-	if (fence_is_signaled(&fence->base))
+	if (fence_is_signaled(fence))
 		goto err;
 
 	work = kmalloc(sizeof(*work), GFP_KERNEL);
 	if (!work) {
-		WARN_ON(nouveau_fence_wait(fence, false, false));
+		WARN_ON(nouveau_fence_wait((struct nouveau_fence *)fence,
+					   false, false));
 		goto err;
 	}
 
@@ -157,7 +158,7 @@ nouveau_fence_work(struct nouveau_fence *fence,
 	work->func = func;
 	work->data = data;
 
-	if (fence_add_callback(&fence->base, &work->cb, nouveau_fence_work_cb) < 0)
+	if (fence_add_callback(fence, &work->cb, nouveau_fence_work_cb) < 0)
 		goto err_free;
 	return;
 
@@ -322,14 +323,9 @@ nouveau_fence_sync(struct nouveau_bo *nvbo, struct nouveau_channel *chan)
 	struct reservation_object_list *fobj;
 	int ret = 0, i;
 
-	fence = nvbo->bo.sync_obj;
-	if (fence && fence_is_signaled(fence)) {
-		nouveau_fence_unref((struct nouveau_fence **)
-				    &nvbo->bo.sync_obj);
-		fence = NULL;
-	}
+	fence = reservation_object_get_excl(resv);
 
-	if (fence) {
+	if (fence && !fence_is_signaled(fence)) {
 		struct nouveau_fence *f = container_of(fence,
 						       struct nouveau_fence,
 						       base);
@@ -345,12 +341,8 @@ nouveau_fence_sync(struct nouveau_bo *nvbo, struct nouveau_channel *chan)
 	if (ret)
 		return ret;
 
-	fence = reservation_object_get_excl(resv);
-	if (fence && !nouveau_local_fence(fence, chan->drm))
-		ret = fence_wait(fence, true);
-
 	fobj = reservation_object_get_list(resv);
-	if (!fobj || ret)
+	if (!fobj)
 		return ret;
 
 	for (i = 0; i < fobj->shared_count && !ret; ++i) {
diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.h b/drivers/gpu/drm/nouveau/nouveau_fence.h
index 1989ec22e66e..41abc8a44e3c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.h
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.h
@@ -26,7 +26,7 @@ void nouveau_fence_unref(struct nouveau_fence **);
 
 int  nouveau_fence_emit(struct nouveau_fence *, struct nouveau_channel *);
 bool nouveau_fence_done(struct nouveau_fence *);
-void nouveau_fence_work(struct nouveau_fence *, void (*)(void *), void *);
+void nouveau_fence_work(struct fence *, void (*)(void *), void *);
 int  nouveau_fence_wait(struct nouveau_fence *, bool lazy, bool intr);
 int  nouveau_fence_sync(struct nouveau_bo *, struct nouveau_channel *);
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 2bd62f4ecf6a..0a1fee7eb211 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -100,13 +100,12 @@ static void
 nouveau_gem_object_unmap(struct nouveau_bo *nvbo, struct nouveau_vma *vma)
 {
 	const bool mapped = nvbo->bo.mem.mem_type != TTM_PL_SYSTEM;
-	struct nouveau_fence *fence = NULL;
+	struct fence *fence = NULL;
 
 	list_del(&vma->head);
 
-	if (mapped) {
-		fence = nouveau_fence_ref(nvbo->bo.sync_obj);
-	}
+	if (mapped)
+		fence = reservation_object_get_excl(nvbo->bo.resv);
 
 	if (fence) {
 		nouveau_fence_work(fence, nouveau_gem_object_delete, vma);
@@ -116,7 +115,6 @@ nouveau_gem_object_unmap(struct nouveau_bo *nvbo, struct nouveau_vma *vma)
 		nouveau_vm_put(vma);
 		kfree(vma);
 	}
-	nouveau_fence_unref(&fence);
 }
 
 void
@@ -876,8 +874,12 @@ nouveau_gem_ioctl_cpu_prep(struct drm_device *dev, void *data,
 	ret = ttm_bo_reserve(&nvbo->bo, true, false, false, 0);
 	if (!ret) {
 		ret = ttm_bo_wait(&nvbo->bo, true, true, true);
-		if (!no_wait && ret)
-			fence = nouveau_fence_ref(nvbo->bo.sync_obj);
+		if (!no_wait && ret) {
+			struct fence *excl;
+
+			excl = reservation_object_get_excl(nvbo->bo.resv);
+			fence = nouveau_fence_ref((struct nouveau_fence *)excl);
+		}
 
 		ttm_bo_unreserve(&nvbo->bo);
 	}
diff --git a/drivers/gpu/drm/qxl/qxl_debugfs.c b/drivers/gpu/drm/qxl/qxl_debugfs.c
index 0d144e0646d6..a4a63fd84803 100644
--- a/drivers/gpu/drm/qxl/qxl_debugfs.c
+++ b/drivers/gpu/drm/qxl/qxl_debugfs.c
@@ -67,9 +67,9 @@ qxl_debugfs_buffers_info(struct seq_file *m, void *data)
 		rel = fobj ? fobj->shared_count : 0;
 		rcu_read_unlock();
 
-		seq_printf(m, "size %ld, pc %d, sync obj %p, num releases %d\n",
-			   (unsigned long)bo->gem_base.size, bo->pin_count,
-			   bo->tbo.sync_obj, rel);
+		seq_printf(m, "size %ld, pc %d, num releases %d\n",
+			   (unsigned long)bo->gem_base.size,
+			   bo->pin_count, rel);
 	}
 	spin_unlock(&qdev->release_lock);
 	return 0;
diff --git a/drivers/gpu/drm/qxl/qxl_drv.h b/drivers/gpu/drm/qxl/qxl_drv.h
index d547cbdebeb4..74e2117ee0e6 100644
--- a/drivers/gpu/drm/qxl/qxl_drv.h
+++ b/drivers/gpu/drm/qxl/qxl_drv.h
@@ -280,9 +280,7 @@ struct qxl_device {
 	uint8_t		slot_gen_bits;
 	uint64_t	va_slot_mask;
 
-	/* XXX: when rcu becomes available, release_lock can be killed */
 	spinlock_t	release_lock;
-	spinlock_t	fence_lock;
 	struct idr	release_idr;
 	uint32_t	release_seqno;
 	spinlock_t release_idr_lock;
diff --git a/drivers/gpu/drm/qxl/qxl_kms.c b/drivers/gpu/drm/qxl/qxl_kms.c
index a9e7c30e92c5..7234561e09d9 100644
--- a/drivers/gpu/drm/qxl/qxl_kms.c
+++ b/drivers/gpu/drm/qxl/qxl_kms.c
@@ -224,7 +224,6 @@ static int qxl_device_init(struct qxl_device *qdev,
 	idr_init(&qdev->release_idr);
 	spin_lock_init(&qdev->release_idr_lock);
 	spin_lock_init(&qdev->release_lock);
-	spin_lock_init(&qdev->fence_lock);
 
 	idr_init(&qdev->surf_id_idr);
 	spin_lock_init(&qdev->surf_id_idr_lock);
diff --git a/drivers/gpu/drm/qxl/qxl_object.h b/drivers/gpu/drm/qxl/qxl_object.h
index 1edaf5768086..37af1bc0dd00 100644
--- a/drivers/gpu/drm/qxl/qxl_object.h
+++ b/drivers/gpu/drm/qxl/qxl_object.h
@@ -78,8 +78,8 @@ static inline int qxl_bo_wait(struct qxl_bo *bo, u32 *mem_type,
 	}
 	if (mem_type)
 		*mem_type = bo->tbo.mem.mem_type;
-	if (bo->tbo.sync_obj)
-		r = ttm_bo_wait(&bo->tbo, true, true, no_wait);
+
+	r = ttm_bo_wait(&bo->tbo, true, true, no_wait);
 	ttm_bo_unreserve(&bo->tbo);
 	return r;
 }
diff --git a/drivers/gpu/drm/qxl/qxl_release.c b/drivers/gpu/drm/qxl/qxl_release.c
index 9731d2540a40..15158c5a5b3a 100644
--- a/drivers/gpu/drm/qxl/qxl_release.c
+++ b/drivers/gpu/drm/qxl/qxl_release.c
@@ -464,9 +464,6 @@ void qxl_release_fence_buffer_objects(struct qxl_release *release)
 		bo = entry->bo;
 		qbo = to_qxl_bo(bo);
 
-		if (!entry->bo->sync_obj)
-			entry->bo->sync_obj = qbo;
-
 		reservation_object_add_shared_fence(bo->resv, &release->base);
 		ttm_bo_add_to_lru(bo);
 		__ttm_bo_unreserve(bo);
diff --git a/drivers/gpu/drm/qxl/qxl_ttm.c b/drivers/gpu/drm/qxl/qxl_ttm.c
index 6230251fa5b0..99b7ee110a98 100644
--- a/drivers/gpu/drm/qxl/qxl_ttm.c
+++ b/drivers/gpu/drm/qxl/qxl_ttm.c
@@ -355,105 +355,6 @@ static int qxl_bo_move(struct ttm_buffer_object *bo,
 	return ttm_bo_move_memcpy(bo, evict, no_wait_gpu, new_mem);
 }
 
-static bool qxl_sync_obj_signaled(void *sync_obj);
-
-static int qxl_sync_obj_wait(void *sync_obj,
-			     bool lazy, bool interruptible)
-{
-	struct qxl_bo *bo = (struct qxl_bo *)sync_obj;
-	struct qxl_device *qdev = bo->gem_base.dev->dev_private;
-	struct reservation_object_list *fobj;
-	int count = 0, sc = 0, num_release = 0;
-	bool have_drawable_releases;
-
-retry:
-	if (sc == 0) {
-		if (bo->type == QXL_GEM_DOMAIN_SURFACE)
-			qxl_update_surface(qdev, bo);
-	} else if (sc >= 1) {
-		qxl_io_notify_oom(qdev);
-	}
-
-	sc++;
-
-	for (count = 0; count < 10; count++) {
-		if (qxl_sync_obj_signaled(sync_obj))
-			return 0;
-
-		if (!qxl_queue_garbage_collect(qdev, true))
-			break;
-	}
-
-	have_drawable_releases = false;
-	num_release = 0;
-
-	spin_lock(&qdev->release_lock);
-	fobj = bo->tbo.resv->fence;
-	for (count = 0; fobj && count < fobj->shared_count; count++) {
-		struct qxl_release *release;
-
-		release = container_of(fobj->shared[count],
-				       struct qxl_release, base);
-
-		if (fence_is_signaled(&release->base))
-			continue;
-
-		num_release++;
-
-		if (release->type == QXL_RELEASE_DRAWABLE)
-			have_drawable_releases = true;
-	}
-	spin_unlock(&qdev->release_lock);
-
-	qxl_queue_garbage_collect(qdev, true);
-
-	if (have_drawable_releases || sc < 4) {
-		if (sc > 2)
-			/* back off */
-			usleep_range(500, 1000);
-		if (have_drawable_releases && sc > 300) {
-			WARN(1, "sync obj %d still has outstanding releases %d %d %d %ld %d\n", sc, bo->surface_id, bo->is_primary, bo->pin_count, (unsigned long)bo->gem_base.size, num_release);
-			return -EBUSY;
-		}
-		goto retry;
-	}
-	return 0;
-}
-
-static int qxl_sync_obj_flush(void *sync_obj)
-{
-	return 0;
-}
-
-static void qxl_sync_obj_unref(void **sync_obj)
-{
-	*sync_obj = NULL;
-}
-
-static void *qxl_sync_obj_ref(void *sync_obj)
-{
-	return sync_obj;
-}
-
-static bool qxl_sync_obj_signaled(void *sync_obj)
-{
-	struct qxl_bo *qbo = (struct qxl_bo *)sync_obj;
-	struct qxl_device *qdev = qbo->gem_base.dev->dev_private;
-	struct reservation_object_list *fobj;
-	bool ret = true;
-	unsigned i;
-
-	spin_lock(&qdev->release_lock);
-	fobj = qbo->tbo.resv->fence;
-	for (i = 0; fobj && i < fobj->shared_count; ++i) {
-		ret = fence_is_signaled(fobj->shared[i]);
-		if (!ret)
-			break;
-	}
-	spin_unlock(&qdev->release_lock);
-	return ret;
-}
-
 static void qxl_bo_move_notify(struct ttm_buffer_object *bo,
 			       struct ttm_mem_reg *new_mem)
 {
@@ -480,11 +381,6 @@ static struct ttm_bo_driver qxl_bo_driver = {
 	.verify_access = &qxl_verify_access,
 	.io_mem_reserve = &qxl_ttm_io_mem_reserve,
 	.io_mem_free = &qxl_ttm_io_mem_free,
-	.sync_obj_signaled = &qxl_sync_obj_signaled,
-	.sync_obj_wait = &qxl_sync_obj_wait,
-	.sync_obj_flush = &qxl_sync_obj_flush,
-	.sync_obj_unref = &qxl_sync_obj_unref,
-	.sync_obj_ref = &qxl_sync_obj_ref,
 	.move_notify = &qxl_bo_move_notify,
 };
 
diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index ae763f60c8a0..687b4fdc988e 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -228,11 +228,17 @@ static void radeon_cs_sync_rings(struct radeon_cs_parser *p)
 	int i;
 
 	for (i = 0; i < p->nrelocs; i++) {
+		struct reservation_object *resv;
+		struct fence *fence;
+
 		if (!p->relocs[i].robj)
 			continue;
 
+		resv = p->relocs[i].robj->tbo.resv;
+		fence = reservation_object_get_excl(resv);
+
 		radeon_semaphore_sync_to(p->ib.semaphore,
-					 p->relocs[i].robj->tbo.sync_obj);
+					 (struct radeon_fence *)fence);
 	}
 }
 
@@ -402,7 +408,7 @@ static void radeon_cs_parser_fini(struct radeon_cs_parser *parser, int error, bo
 
 		ttm_eu_fence_buffer_objects(&parser->ticket,
 					    &parser->validated,
-					    parser->ib.fence);
+					    &parser->ib.fence->base);
 	} else if (backoff) {
 		ttm_eu_backoff_reservation(&parser->ticket,
 					   &parser->validated);
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 3402540aa641..45bdc829bb14 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -481,8 +481,7 @@ static int radeon_crtc_page_flip(struct drm_crtc *crtc,
 		goto cleanup;
 	}
 
-	if (new_rbo->tbo.sync_obj)
-		work->fence = radeon_fence_ref(new_rbo->tbo.sync_obj);
+	work->fence = fence_get(reservation_object_get_excl(new_rbo->tbo.resv));
 
 	radeon_bo_get_tiling_flags(new_rbo, &tiling_flags, NULL);
 	radeon_bo_unreserve(new_rbo);
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index 8538aebb6580..53104f80d382 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -736,8 +736,8 @@ int radeon_bo_wait(struct radeon_bo *bo, u32 *mem_type, bool no_wait)
 		return r;
 	if (mem_type)
 		*mem_type = bo->tbo.mem.mem_type;
-	if (bo->tbo.sync_obj)
-		r = ttm_bo_wait(&bo->tbo, true, true, no_wait);
+
+	r = ttm_bo_wait(&bo->tbo, true, true, no_wait);
 	ttm_bo_unreserve(&bo->tbo);
 	return r;
 }
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index c8a8a5144ec1..715e29f984c1 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -265,12 +265,12 @@ static int radeon_move_blit(struct ttm_buffer_object *bo,
 	BUILD_BUG_ON((PAGE_SIZE % RADEON_GPU_PAGE_SIZE) != 0);
 
 	/* sync other rings */
-	fence = bo->sync_obj;
+	fence = (struct radeon_fence *)reservation_object_get_excl(bo->resv);
 	r = radeon_copy(rdev, old_start, new_start,
 			new_mem->num_pages * (PAGE_SIZE / RADEON_GPU_PAGE_SIZE), /* GPU pages */
 			&fence);
 	/* FIXME: handle copy error */
-	r = ttm_bo_move_accel_cleanup(bo, (void *)fence,
+	r = ttm_bo_move_accel_cleanup(bo, &fence->base,
 				      evict, no_wait_gpu, new_mem);
 	radeon_fence_unref(&fence);
 	return r;
@@ -483,31 +483,6 @@ static void radeon_ttm_io_mem_free(struct ttm_bo_device *bdev, struct ttm_mem_re
 {
 }
 
-static int radeon_sync_obj_wait(void *sync_obj, bool lazy, bool interruptible)
-{
-	return radeon_fence_wait((struct radeon_fence *)sync_obj, interruptible);
-}
-
-static int radeon_sync_obj_flush(void *sync_obj)
-{
-	return 0;
-}
-
-static void radeon_sync_obj_unref(void **sync_obj)
-{
-	radeon_fence_unref((struct radeon_fence **)sync_obj);
-}
-
-static void *radeon_sync_obj_ref(void *sync_obj)
-{
-	return radeon_fence_ref((struct radeon_fence *)sync_obj);
-}
-
-static bool radeon_sync_obj_signaled(void *sync_obj)
-{
-	return radeon_fence_signaled((struct radeon_fence *)sync_obj);
-}
-
 /*
  * TTM backend functions.
  */
@@ -685,11 +660,6 @@ static struct ttm_bo_driver radeon_bo_driver = {
 	.evict_flags = &radeon_evict_flags,
 	.move = &radeon_bo_move,
 	.verify_access = &radeon_verify_access,
-	.sync_obj_signaled = &radeon_sync_obj_signaled,
-	.sync_obj_wait = &radeon_sync_obj_wait,
-	.sync_obj_flush = &radeon_sync_obj_flush,
-	.sync_obj_unref = &radeon_sync_obj_unref,
-	.sync_obj_ref = &radeon_sync_obj_ref,
 	.move_notify = &radeon_bo_move_notify,
 	.fault_reserve_notify = &radeon_bo_fault_reserve_notify,
 	.io_mem_reserve = &radeon_ttm_io_mem_reserve,
diff --git a/drivers/gpu/drm/radeon/radeon_uvd.c b/drivers/gpu/drm/radeon/radeon_uvd.c
index 67b2a367df40..b35655e2e35e 100644
--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -356,6 +356,7 @@ static int radeon_uvd_cs_msg(struct radeon_cs_parser *p, struct radeon_bo *bo,
 {
 	int32_t *msg, msg_type, handle;
 	unsigned img_size = 0;
+	struct fence *f;
 	void *ptr;
 
 	int i, r;
@@ -365,8 +366,9 @@ static int radeon_uvd_cs_msg(struct radeon_cs_parser *p, struct radeon_bo *bo,
 		return -EINVAL;
 	}
 
-	if (bo->tbo.sync_obj) {
-		r = radeon_fence_wait(bo->tbo.sync_obj, false);
+	f = reservation_object_get_excl(bo->tbo.resv);
+	if (f) {
+		r = radeon_fence_wait((struct radeon_fence *)f, false);
 		if (r) {
 			DRM_ERROR("Failed waiting for UVD message (%d)!\n", r);
 			return r;
@@ -649,7 +651,7 @@ static int radeon_uvd_send_msg(struct radeon_device *rdev,
 	r = radeon_ib_schedule(rdev, &ib, NULL);
 	if (r)
 		goto err;
-	ttm_eu_fence_buffer_objects(&ticket, &head, ib.fence);
+	ttm_eu_fence_buffer_objects(&ticket, &head, &ib.fence->base);
 
 	if (fence)
 		*fence = radeon_fence_ref(ib.fence);
diff --git a/drivers/gpu/drm/radeon/radeon_vm.c b/drivers/gpu/drm/radeon/radeon_vm.c
index 0a0d0291af0d..e353eacb63b1 100644
--- a/drivers/gpu/drm/radeon/radeon_vm.c
+++ b/drivers/gpu/drm/radeon/radeon_vm.c
@@ -389,7 +389,7 @@ static int radeon_vm_clear_bo(struct radeon_device *rdev,
 	if (r)
                 goto error;
 
-	ttm_eu_fence_buffer_objects(&ticket, &head, ib.fence);
+	ttm_eu_fence_buffer_objects(&ticket, &head, &ib.fence->base);
 	radeon_ib_free(rdev, &ib);
 
 	return 0;
@@ -658,7 +658,12 @@ int radeon_vm_update_page_directory(struct radeon_device *rdev,
 					incr, R600_PTE_VALID);
 
 	if (ib.length_dw != 0) {
-		radeon_semaphore_sync_to(ib.semaphore, pd->tbo.sync_obj);
+		struct fence *fence;
+
+		fence = reservation_object_get_excl(pd->tbo.resv);
+		radeon_semaphore_sync_to(ib.semaphore,
+					 (struct radeon_fence *)fence);
+
 		radeon_semaphore_sync_to(ib.semaphore, vm->last_id_use);
 		r = radeon_ib_schedule(rdev, &ib, NULL);
 		if (r) {
@@ -786,8 +791,11 @@ static void radeon_vm_update_ptes(struct radeon_device *rdev,
 		struct radeon_bo *pt = vm->page_tables[pt_idx].bo;
 		unsigned nptes;
 		uint64_t pte;
+		struct fence *fence;
 
-		radeon_semaphore_sync_to(ib->semaphore, pt->tbo.sync_obj);
+		fence = reservation_object_get_excl(pt->tbo.resv);
+		radeon_semaphore_sync_to(ib->semaphore,
+					 (struct radeon_fence *)fence);
 
 		if ((addr & ~mask) == (end & ~mask))
 			nptes = end - addr;
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index c441ac6d546b..9d36cffad3b7 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -40,6 +40,7 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/atomic.h>
+#include <linux/reservation.h>
 
 #define TTM_ASSERT_LOCKED(param)
 #define TTM_DEBUG(fmt, arg...)
@@ -141,7 +142,6 @@ static void ttm_bo_release_list(struct kref *list_kref)
 	BUG_ON(atomic_read(&bo->list_kref.refcount));
 	BUG_ON(atomic_read(&bo->kref.refcount));
 	BUG_ON(atomic_read(&bo->cpu_writers));
-	BUG_ON(bo->sync_obj != NULL);
 	BUG_ON(bo->mem.mm_node != NULL);
 	BUG_ON(!list_empty(&bo->lru));
 	BUG_ON(!list_empty(&bo->ddestroy));
@@ -402,12 +402,30 @@ static void ttm_bo_cleanup_memtype_use(struct ttm_buffer_object *bo)
 	ww_mutex_unlock (&bo->resv->lock);
 }
 
+static void ttm_bo_flush_all_fences(struct ttm_buffer_object *bo)
+{
+	struct reservation_object_list *fobj;
+	struct fence *fence;
+	int i;
+
+	fobj = reservation_object_get_list(bo->resv);
+	fence = reservation_object_get_excl(bo->resv);
+	if (fence && !fence->ops->signaled)
+		fence_enable_sw_signaling(fence);
+
+	for (i = 0; fobj && i < fobj->shared_count; ++i) {
+		fence = rcu_dereference_protected(fobj->shared[i],
+					reservation_object_held(bo->resv));
+
+		if (!fence->ops->signaled)
+			fence_enable_sw_signaling(fence);
+	}
+}
+
 static void ttm_bo_cleanup_refs_or_queue(struct ttm_buffer_object *bo)
 {
 	struct ttm_bo_device *bdev = bo->bdev;
 	struct ttm_bo_global *glob = bo->glob;
-	struct ttm_bo_driver *driver = bdev->driver;
-	void *sync_obj = NULL;
 	int put_count;
 	int ret;
 
@@ -415,9 +433,7 @@ static void ttm_bo_cleanup_refs_or_queue(struct ttm_buffer_object *bo)
 	ret = __ttm_bo_reserve(bo, false, true, false, NULL);
 
 	if (!ret) {
-		(void) ttm_bo_wait(bo, false, false, true);
-
-		if (!bo->sync_obj) {
+		if (!ttm_bo_wait(bo, false, false, true)) {
 			put_count = ttm_bo_del_from_lru(bo);
 
 			spin_unlock(&glob->lru_lock);
@@ -426,8 +442,8 @@ static void ttm_bo_cleanup_refs_or_queue(struct ttm_buffer_object *bo)
 			ttm_bo_list_ref_sub(bo, put_count, true);
 
 			return;
-		}
-		sync_obj = driver->sync_obj_ref(bo->sync_obj);
+		} else
+			ttm_bo_flush_all_fences(bo);
 
 		/*
 		 * Make NO_EVICT bos immediately available to
@@ -446,14 +462,70 @@ static void ttm_bo_cleanup_refs_or_queue(struct ttm_buffer_object *bo)
 	list_add_tail(&bo->ddestroy, &bdev->ddestroy);
 	spin_unlock(&glob->lru_lock);
 
-	if (sync_obj) {
-		driver->sync_obj_flush(sync_obj);
-		driver->sync_obj_unref(&sync_obj);
-	}
 	schedule_delayed_work(&bdev->wq,
 			      ((HZ / 100) < 1) ? 1 : HZ / 100);
 }
 
+static int ttm_bo_unreserve_and_wait(struct ttm_buffer_object *bo,
+				     bool interruptible)
+{
+	struct ttm_bo_global *glob = bo->glob;
+	struct reservation_object_list *fobj;
+	struct fence *excl = NULL;
+	struct fence **shared = NULL;
+	u32 shared_count = 0, i;
+	int ret = 0;
+
+	fobj = reservation_object_get_list(bo->resv);
+	if (fobj && fobj->shared_count) {
+		shared = kmalloc(sizeof(*shared) * fobj->shared_count,
+				 GFP_KERNEL);
+
+		if (!shared) {
+			ret = -ENOMEM;
+			__ttm_bo_unreserve(bo);
+			spin_unlock(&glob->lru_lock);
+			return ret;
+		}
+
+		for (i = 0; i < fobj->shared_count; ++i) {
+			if (!fence_is_signaled(fobj->shared[i])) {
+				fence_get(fobj->shared[i]);
+				shared[shared_count++] = fobj->shared[i];
+			}
+		}
+		if (!shared_count) {
+			kfree(shared);
+			shared = NULL;
+		}
+	}
+
+	excl = reservation_object_get_excl(bo->resv);
+	if (excl && !fence_is_signaled(excl))
+		fence_get(excl);
+	else
+		excl = NULL;
+
+	__ttm_bo_unreserve(bo);
+	spin_unlock(&glob->lru_lock);
+
+	if (excl) {
+		ret = fence_wait(excl, interruptible);
+		fence_put(excl);
+	}
+
+	if (shared_count > 0) {
+		for (i = 0; i < shared_count; ++i) {
+			if (!ret)
+				ret = fence_wait(shared[i], interruptible);
+			fence_put(shared[i]);
+		}
+		kfree(shared);
+	}
+
+	return ret;
+}
+
 /**
  * function ttm_bo_cleanup_refs_and_unlock
  * If bo idle, remove from delayed- and lru lists, and unref.
@@ -470,8 +542,6 @@ static int ttm_bo_cleanup_refs_and_unlock(struct ttm_buffer_object *bo,
 					  bool interruptible,
 					  bool no_wait_gpu)
 {
-	struct ttm_bo_device *bdev = bo->bdev;
-	struct ttm_bo_driver *driver = bdev->driver;
 	struct ttm_bo_global *glob = bo->glob;
 	int put_count;
 	int ret;
@@ -479,20 +549,7 @@ static int ttm_bo_cleanup_refs_and_unlock(struct ttm_buffer_object *bo,
 	ret = ttm_bo_wait(bo, false, false, true);
 
 	if (ret && !no_wait_gpu) {
-		void *sync_obj;
-
-		/*
-		 * Take a reference to the fence and unreserve,
-		 * at this point the buffer should be dead, so
-		 * no new sync objects can be attached.
-		 */
-		sync_obj = driver->sync_obj_ref(bo->sync_obj);
-
-		__ttm_bo_unreserve(bo);
-		spin_unlock(&glob->lru_lock);
-
-		ret = driver->sync_obj_wait(sync_obj, false, interruptible);
-		driver->sync_obj_unref(&sync_obj);
+		ret = ttm_bo_unreserve_and_wait(bo, interruptible);
 		if (ret)
 			return ret;
 
@@ -1513,41 +1570,51 @@ void ttm_bo_unmap_virtual(struct ttm_buffer_object *bo)
 
 EXPORT_SYMBOL(ttm_bo_unmap_virtual);
 
-
 int ttm_bo_wait(struct ttm_buffer_object *bo,
 		bool lazy, bool interruptible, bool no_wait)
 {
-	struct ttm_bo_driver *driver = bo->bdev->driver;
-	void *sync_obj;
-	int ret = 0;
-
-	lockdep_assert_held(&bo->resv->lock.base);
+	struct reservation_object_list *fobj;
+	struct reservation_object *resv;
+	struct fence *excl;
+	long timeout = 15 * HZ;
+	int i;
 
-	if (likely(bo->sync_obj == NULL))
-		return 0;
+	resv = bo->resv;
+	fobj = reservation_object_get_list(resv);
+	excl = reservation_object_get_excl(resv);
+	if (excl) {
+		if (!fence_is_signaled(excl)) {
+			if (no_wait)
+				return -EBUSY;
 
-	if (bo->sync_obj) {
-		if (driver->sync_obj_signaled(bo->sync_obj)) {
-			driver->sync_obj_unref(&bo->sync_obj);
-			clear_bit(TTM_BO_PRIV_FLAG_MOVING, &bo->priv_flags);
-			return 0;
+			timeout = fence_wait_timeout(excl,
+						     interruptible, timeout);
 		}
+	}
 
-		if (no_wait)
-			return -EBUSY;
+	for (i = 0; fobj && timeout > 0 && i < fobj->shared_count; ++i) {
+		struct fence *fence;
+		fence = rcu_dereference_protected(fobj->shared[i],
+						reservation_object_held(resv));
 
-		sync_obj = driver->sync_obj_ref(bo->sync_obj);
-		ret = driver->sync_obj_wait(sync_obj,
-					    lazy, interruptible);
+		if (!fence_is_signaled(fence)) {
+			if (no_wait)
+				return -EBUSY;
 
-		if (likely(ret == 0)) {
-			clear_bit(TTM_BO_PRIV_FLAG_MOVING,
-				  &bo->priv_flags);
-			driver->sync_obj_unref(&bo->sync_obj);
+			timeout = fence_wait_timeout(fence,
+						     interruptible, timeout);
 		}
-		driver->sync_obj_unref(&sync_obj);
 	}
-	return ret;
+
+	if (timeout < 0)
+		return timeout;
+
+	if (timeout == 0)
+		return -EBUSY;
+
+	reservation_object_add_excl_fence(resv, NULL);
+	clear_bit(TTM_BO_PRIV_FLAG_MOVING, &bo->priv_flags);
+	return 0;
 }
 EXPORT_SYMBOL(ttm_bo_wait);
 
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 495aebf0f9c3..824af90cbe31 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -37,6 +37,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
+#include <linux/reservation.h>
 
 void ttm_bo_free_old_node(struct ttm_buffer_object *bo)
 {
@@ -444,8 +445,6 @@ static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
 				      struct ttm_buffer_object **new_obj)
 {
 	struct ttm_buffer_object *fbo;
-	struct ttm_bo_device *bdev = bo->bdev;
-	struct ttm_bo_driver *driver = bdev->driver;
 	int ret;
 
 	fbo = kmalloc(sizeof(*fbo), GFP_KERNEL);
@@ -466,10 +465,6 @@ static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
 	drm_vma_node_reset(&fbo->vma_node);
 	atomic_set(&fbo->cpu_writers, 0);
 
-	if (bo->sync_obj)
-		fbo->sync_obj = driver->sync_obj_ref(bo->sync_obj);
-	else
-		fbo->sync_obj = NULL;
 	kref_init(&fbo->list_kref);
 	kref_init(&fbo->kref);
 	fbo->destroy = &ttm_transfered_destroy;
@@ -642,28 +637,20 @@ void ttm_bo_kunmap(struct ttm_bo_kmap_obj *map)
 EXPORT_SYMBOL(ttm_bo_kunmap);
 
 int ttm_bo_move_accel_cleanup(struct ttm_buffer_object *bo,
-			      void *sync_obj,
+			      struct fence *fence,
 			      bool evict,
 			      bool no_wait_gpu,
 			      struct ttm_mem_reg *new_mem)
 {
 	struct ttm_bo_device *bdev = bo->bdev;
-	struct ttm_bo_driver *driver = bdev->driver;
 	struct ttm_mem_type_manager *man = &bdev->man[new_mem->mem_type];
 	struct ttm_mem_reg *old_mem = &bo->mem;
 	int ret;
 	struct ttm_buffer_object *ghost_obj;
-	void *tmp_obj = NULL;
 
-	if (bo->sync_obj) {
-		tmp_obj = bo->sync_obj;
-		bo->sync_obj = NULL;
-	}
-	bo->sync_obj = driver->sync_obj_ref(sync_obj);
+	reservation_object_add_excl_fence(bo->resv, fence);
 	if (evict) {
 		ret = ttm_bo_wait(bo, false, false, false);
-		if (tmp_obj)
-			driver->sync_obj_unref(&tmp_obj);
 		if (ret)
 			return ret;
 
@@ -684,13 +671,13 @@ int ttm_bo_move_accel_cleanup(struct ttm_buffer_object *bo,
 		 */
 
 		set_bit(TTM_BO_PRIV_FLAG_MOVING, &bo->priv_flags);
-		if (tmp_obj)
-			driver->sync_obj_unref(&tmp_obj);
 
 		ret = ttm_buffer_object_transfer(bo, &ghost_obj);
 		if (ret)
 			return ret;
 
+		reservation_object_add_excl_fence(ghost_obj->resv, fence);
+
 		/**
 		 * If we're not moving to fixed memory, the TTM object
 		 * needs to stay alive. Otherwhise hang it on the ghost
diff --git a/drivers/gpu/drm/ttm/ttm_execbuf_util.c b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
index 108730e9147b..adafc0f8ec06 100644
--- a/drivers/gpu/drm/ttm/ttm_execbuf_util.c
+++ b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
@@ -163,7 +163,7 @@ int ttm_eu_reserve_buffers(struct ww_acquire_ctx *ticket,
 EXPORT_SYMBOL(ttm_eu_reserve_buffers);
 
 void ttm_eu_fence_buffer_objects(struct ww_acquire_ctx *ticket,
-				 struct list_head *list, void *sync_obj)
+				 struct list_head *list, struct fence *fence)
 {
 	struct ttm_validate_buffer *entry;
 	struct ttm_buffer_object *bo;
@@ -183,18 +183,12 @@ void ttm_eu_fence_buffer_objects(struct ww_acquire_ctx *ticket,
 
 	list_for_each_entry(entry, list, head) {
 		bo = entry->bo;
-		entry->old_sync_obj = bo->sync_obj;
-		bo->sync_obj = driver->sync_obj_ref(sync_obj);
+		reservation_object_add_excl_fence(bo->resv, fence);
 		ttm_bo_add_to_lru(bo);
 		__ttm_bo_unreserve(bo);
 	}
 	spin_unlock(&glob->lru_lock);
 	if (ticket)
 		ww_acquire_fini(ticket);
-
-	list_for_each_entry(entry, list, head) {
-		if (entry->old_sync_obj)
-			driver->sync_obj_unref(&entry->old_sync_obj);
-	}
 }
 EXPORT_SYMBOL(ttm_eu_fence_buffer_objects);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
index f15718cc631d..656c88485e14 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
@@ -768,41 +768,6 @@ static int vmw_ttm_fault_reserve_notify(struct ttm_buffer_object *bo)
 }
 
 /**
- * FIXME: We're using the old vmware polling method to sync.
- * Do this with fences instead.
- */
-
-static void *vmw_sync_obj_ref(void *sync_obj)
-{
-
-	return (void *)
-		vmw_fence_obj_reference((struct vmw_fence_obj *) sync_obj);
-}
-
-static void vmw_sync_obj_unref(void **sync_obj)
-{
-	vmw_fence_obj_unreference((struct vmw_fence_obj **) sync_obj);
-}
-
-static int vmw_sync_obj_flush(void *sync_obj)
-{
-	vmw_fence_obj_flush((struct vmw_fence_obj *) sync_obj);
-	return 0;
-}
-
-static bool vmw_sync_obj_signaled(void *sync_obj)
-{
-	return vmw_fence_obj_signaled((struct vmw_fence_obj *) sync_obj);
-}
-
-static int vmw_sync_obj_wait(void *sync_obj, bool lazy, bool interruptible)
-{
-	return vmw_fence_obj_wait((struct vmw_fence_obj *) sync_obj,
-				  lazy, interruptible,
-				  VMW_FENCE_WAIT_TIMEOUT);
-}
-
-/**
  * vmw_move_notify - TTM move_notify_callback
  *
  * @bo:             The TTM buffer object about to move.
@@ -839,11 +804,6 @@ struct ttm_bo_driver vmw_bo_driver = {
 	.evict_flags = vmw_evict_flags,
 	.move = NULL,
 	.verify_access = vmw_verify_access,
-	.sync_obj_signaled = vmw_sync_obj_signaled,
-	.sync_obj_wait = vmw_sync_obj_wait,
-	.sync_obj_flush = vmw_sync_obj_flush,
-	.sync_obj_unref = vmw_sync_obj_unref,
-	.sync_obj_ref = vmw_sync_obj_ref,
 	.move_notify = vmw_move_notify,
 	.swap_notify = vmw_swap_notify,
 	.fault_reserve_notify = &vmw_ttm_fault_reserve_notify,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index 294a0a3e48cb..f0a689ba9685 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -1419,22 +1419,16 @@ void vmw_fence_single_bo(struct ttm_buffer_object *bo,
 			 struct vmw_fence_obj *fence)
 {
 	struct ttm_bo_device *bdev = bo->bdev;
-	struct vmw_fence_obj *old_fence_obj;
+
 	struct vmw_private *dev_priv =
 		container_of(bdev, struct vmw_private, bdev);
 
 	if (fence == NULL) {
 		vmw_execbuf_fence_commands(NULL, dev_priv, &fence, NULL);
+		reservation_object_add_excl_fence(bo->resv, &fence->base);
+		fence_put(&fence->base);
 	} else
-		vmw_fence_obj_reference(fence);
-
-	reservation_object_add_excl_fence(bo->resv, &fence->base);
-
-	old_fence_obj = bo->sync_obj;
-	bo->sync_obj = fence;
-
-	if (old_fence_obj)
-		vmw_fence_obj_unreference(&old_fence_obj);
+		reservation_object_add_excl_fence(bo->resv, &fence->base);
 }
 
 /**
diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
index 67df9d7c06cc..3b630f3153d0 100644
--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -163,7 +163,6 @@ struct ttm_tt;
  * @lru: List head for the lru list.
  * @ddestroy: List head for the delayed destroy list.
  * @swap: List head for swap LRU list.
- * @sync_obj: Pointer to a synchronization object.
  * @priv_flags: Flags describing buffer object internal state.
  * @vma_node: Address space manager node.
  * @offset: The current GPU offset, which can have different meanings
@@ -230,7 +229,6 @@ struct ttm_buffer_object {
 	 * Members protected by a bo reservation.
 	 */
 
-	void *sync_obj;
 	unsigned long priv_flags;
 
 	struct drm_vma_offset_node vma_node;
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index ff725df48595..9792cd047b8c 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -311,11 +311,6 @@ struct ttm_mem_type_manager {
  * @move: Callback for a driver to hook in accelerated functions to
  * move a buffer.
  * If set to NULL, a potentially slow memcpy() move is used.
- * @sync_obj_signaled: See ttm_fence_api.h
- * @sync_obj_wait: See ttm_fence_api.h
- * @sync_obj_flush: See ttm_fence_api.h
- * @sync_obj_unref: See ttm_fence_api.h
- * @sync_obj_ref: See ttm_fence_api.h
  */
 
 struct ttm_bo_driver {
@@ -417,23 +412,6 @@ struct ttm_bo_driver {
 	int (*verify_access) (struct ttm_buffer_object *bo,
 			      struct file *filp);
 
-	/**
-	 * In case a driver writer dislikes the TTM fence objects,
-	 * the driver writer can replace those with sync objects of
-	 * his / her own. If it turns out that no driver writer is
-	 * using these. I suggest we remove these hooks and plug in
-	 * fences directly. The bo driver needs the following functionality:
-	 * See the corresponding functions in the fence object API
-	 * documentation.
-	 */
-
-	bool (*sync_obj_signaled) (void *sync_obj);
-	int (*sync_obj_wait) (void *sync_obj,
-			      bool lazy, bool interruptible);
-	int (*sync_obj_flush) (void *sync_obj);
-	void (*sync_obj_unref) (void **sync_obj);
-	void *(*sync_obj_ref) (void *sync_obj);
-
 	/* hook to notify driver about a driver move so it
 	 * can do tiling things */
 	void (*move_notify)(struct ttm_buffer_object *bo,
@@ -1021,7 +999,7 @@ extern void ttm_bo_free_old_node(struct ttm_buffer_object *bo);
  * ttm_bo_move_accel_cleanup.
  *
  * @bo: A pointer to a struct ttm_buffer_object.
- * @sync_obj: A sync object that signals when moving is complete.
+ * @fence: A fence object that signals when moving is complete.
  * @evict: This is an evict move. Don't return until the buffer is idle.
  * @no_wait_gpu: Return immediately if the GPU is busy.
  * @new_mem: struct ttm_mem_reg indicating where to move.
@@ -1035,7 +1013,7 @@ extern void ttm_bo_free_old_node(struct ttm_buffer_object *bo);
  */
 
 extern int ttm_bo_move_accel_cleanup(struct ttm_buffer_object *bo,
-				     void *sync_obj,
+				     struct fence *fence,
 				     bool evict, bool no_wait_gpu,
 				     struct ttm_mem_reg *new_mem);
 /**
diff --git a/include/drm/ttm/ttm_execbuf_util.h b/include/drm/ttm/ttm_execbuf_util.h
index 8490cb8ee0d8..ff11a424f752 100644
--- a/include/drm/ttm/ttm_execbuf_util.h
+++ b/include/drm/ttm/ttm_execbuf_util.h
@@ -39,16 +39,11 @@
  *
  * @head:           list head for thread-private list.
  * @bo:             refcounted buffer object pointer.
- * @reserved:       Indicates whether @bo has been reserved for validation.
- * @removed:        Indicates whether @bo has been removed from lru lists.
- * @put_count:      Number of outstanding references on bo::list_kref.
- * @old_sync_obj:   Pointer to a sync object about to be unreferenced
  */
 
 struct ttm_validate_buffer {
 	struct list_head head;
 	struct ttm_buffer_object *bo;
-	void *old_sync_obj;
 };
 
 /**
@@ -100,7 +95,7 @@ extern int ttm_eu_reserve_buffers(struct ww_acquire_ctx *ticket,
  *
  * @ticket:      ww_acquire_ctx from reserve call
  * @list:        thread private list of ttm_validate_buffer structs.
- * @sync_obj:    The new sync object for the buffers.
+ * @fence:       The new exclusive fence for the buffers.
  *
  * This function should be called when command submission is complete, and
  * it will add a new sync object to bos pointed to by entries on @list.
@@ -109,6 +104,7 @@ extern int ttm_eu_reserve_buffers(struct ww_acquire_ctx *ticket,
  */
 
 extern void ttm_eu_fence_buffer_objects(struct ww_acquire_ctx *ticket,
-					struct list_head *list, void *sync_obj);
+					struct list_head *list,
+					struct fence *fence);
 
 #endif

