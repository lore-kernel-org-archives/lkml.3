Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaGaPeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:34:13 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56895 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaGaPeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:34:06 -0400
Subject: [PATCH 12/19] drm/qxl: rework to new fence interface
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Thu, 31 Jul 2014 17:34:01 +0200
Message-ID: <20140731153401.15061.24966.stgit@patser>
In-Reply-To: <20140731153245.15061.63023.stgit@patser>
References: <20140731153245.15061.63023.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Final driver! \o/

This is not a proper dma_fence because the hardware may never signal
anything, so don't use dma-buf with qxl, ever.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/qxl/Makefile      |    2 
 drivers/gpu/drm/qxl/qxl_cmd.c     |    5 -
 drivers/gpu/drm/qxl/qxl_debugfs.c |   12 ++-
 drivers/gpu/drm/qxl/qxl_drv.h     |   22 ++---
 drivers/gpu/drm/qxl/qxl_fence.c   |   87 -------------------
 drivers/gpu/drm/qxl/qxl_kms.c     |    2 
 drivers/gpu/drm/qxl/qxl_object.c  |    2 
 drivers/gpu/drm/qxl/qxl_release.c |  166 ++++++++++++++++++++++++++++++++-----
 drivers/gpu/drm/qxl/qxl_ttm.c     |   97 ++++++++++++----------
 9 files changed, 220 insertions(+), 175 deletions(-)
 delete mode 100644 drivers/gpu/drm/qxl/qxl_fence.c

diff --git a/drivers/gpu/drm/qxl/Makefile b/drivers/gpu/drm/qxl/Makefile
index ea046ba691d2..ac0d74852e11 100644
--- a/drivers/gpu/drm/qxl/Makefile
+++ b/drivers/gpu/drm/qxl/Makefile
@@ -4,6 +4,6 @@
 
 ccflags-y := -Iinclude/drm
 
-qxl-y := qxl_drv.o qxl_kms.o qxl_display.o qxl_ttm.o qxl_fb.o qxl_object.o qxl_gem.o qxl_cmd.o qxl_image.o qxl_draw.o qxl_debugfs.o qxl_irq.o qxl_dumb.o qxl_ioctl.o qxl_fence.o qxl_release.o
+qxl-y := qxl_drv.o qxl_kms.o qxl_display.o qxl_ttm.o qxl_fb.o qxl_object.o qxl_gem.o qxl_cmd.o qxl_image.o qxl_draw.o qxl_debugfs.o qxl_irq.o qxl_dumb.o qxl_ioctl.o qxl_release.o
 
 obj-$(CONFIG_DRM_QXL)+= qxl.o
diff --git a/drivers/gpu/drm/qxl/qxl_cmd.c b/drivers/gpu/drm/qxl/qxl_cmd.c
index 45fad7b45486..97823644d347 100644
--- a/drivers/gpu/drm/qxl/qxl_cmd.c
+++ b/drivers/gpu/drm/qxl/qxl_cmd.c
@@ -620,11 +620,6 @@ static int qxl_reap_surf(struct qxl_device *qdev, struct qxl_bo *surf, bool stal
 	if (ret == -EBUSY)
 		return -EBUSY;
 
-	if (surf->fence.num_active_releases > 0 && stall == false) {
-		qxl_bo_unreserve(surf);
-		return -EBUSY;
-	}
-
 	if (stall)
 		mutex_unlock(&qdev->surf_evict_mutex);
 
diff --git a/drivers/gpu/drm/qxl/qxl_debugfs.c b/drivers/gpu/drm/qxl/qxl_debugfs.c
index c3c2bbdc6674..0d144e0646d6 100644
--- a/drivers/gpu/drm/qxl/qxl_debugfs.c
+++ b/drivers/gpu/drm/qxl/qxl_debugfs.c
@@ -57,11 +57,21 @@ qxl_debugfs_buffers_info(struct seq_file *m, void *data)
 	struct qxl_device *qdev = node->minor->dev->dev_private;
 	struct qxl_bo *bo;
 
+	spin_lock(&qdev->release_lock);
 	list_for_each_entry(bo, &qdev->gem.objects, list) {
+		struct reservation_object_list *fobj;
+		int rel;
+
+		rcu_read_lock();
+		fobj = rcu_dereference(bo->tbo.resv->fence);
+		rel = fobj ? fobj->shared_count : 0;
+		rcu_read_unlock();
+
 		seq_printf(m, "size %ld, pc %d, sync obj %p, num releases %d\n",
 			   (unsigned long)bo->gem_base.size, bo->pin_count,
-			   bo->tbo.sync_obj, bo->fence.num_active_releases);
+			   bo->tbo.sync_obj, rel);
 	}
+	spin_unlock(&qdev->release_lock);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/qxl/qxl_drv.h b/drivers/gpu/drm/qxl/qxl_drv.h
index 36ed40ba773f..d547cbdebeb4 100644
--- a/drivers/gpu/drm/qxl/qxl_drv.h
+++ b/drivers/gpu/drm/qxl/qxl_drv.h
@@ -31,6 +31,7 @@
  * Definitions taken from spice-protocol, plus kernel driver specific bits.
  */
 
+#include <linux/fence.h>
 #include <linux/workqueue.h>
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
@@ -95,13 +96,6 @@ enum {
 	QXL_INTERRUPT_IO_CMD |\
 	QXL_INTERRUPT_CLIENT_MONITORS_CONFIG)
 
-struct qxl_fence {
-	struct qxl_device *qdev;
-	uint32_t num_active_releases;
-	uint32_t *release_ids;
-	struct radix_tree_root tree;
-};
-
 struct qxl_bo {
 	/* Protected by gem.mutex */
 	struct list_head		list;
@@ -113,13 +107,13 @@ struct qxl_bo {
 	unsigned			pin_count;
 	void				*kptr;
 	int                             type;
+
 	/* Constant after initialization */
 	struct drm_gem_object		gem_base;
 	bool is_primary; /* is this now a primary surface */
 	bool hw_surf_alloc;
 	struct qxl_surface surf;
 	uint32_t surface_id;
-	struct qxl_fence fence; /* per bo fence  - list of releases */
 	struct qxl_release *surf_create;
 };
 #define gem_to_qxl_bo(gobj) container_of((gobj), struct qxl_bo, gem_base)
@@ -191,6 +185,8 @@ enum {
  * spice-protocol/qxl_dev.h */
 #define QXL_MAX_RES 96
 struct qxl_release {
+	struct fence base;
+
 	int id;
 	int type;
 	uint32_t release_offset;
@@ -284,7 +280,11 @@ struct qxl_device {
 	uint8_t		slot_gen_bits;
 	uint64_t	va_slot_mask;
 
+	/* XXX: when rcu becomes available, release_lock can be killed */
+	spinlock_t	release_lock;
+	spinlock_t	fence_lock;
 	struct idr	release_idr;
+	uint32_t	release_seqno;
 	spinlock_t release_idr_lock;
 	struct mutex	async_io_mutex;
 	unsigned int last_sent_io_cmd;
@@ -561,10 +561,4 @@ qxl_surface_lookup(struct drm_device *dev, int surface_id);
 void qxl_surface_evict(struct qxl_device *qdev, struct qxl_bo *surf, bool freeing);
 int qxl_update_surface(struct qxl_device *qdev, struct qxl_bo *surf);
 
-/* qxl_fence.c */
-void qxl_fence_add_release_locked(struct qxl_fence *qfence, uint32_t rel_id);
-int qxl_fence_remove_release(struct qxl_fence *qfence, uint32_t rel_id);
-int qxl_fence_init(struct qxl_device *qdev, struct qxl_fence *qfence);
-void qxl_fence_fini(struct qxl_fence *qfence);
-
 #endif
diff --git a/drivers/gpu/drm/qxl/qxl_fence.c b/drivers/gpu/drm/qxl/qxl_fence.c
deleted file mode 100644
index c7248418117d..000000000000
--- a/drivers/gpu/drm/qxl/qxl_fence.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- * Copyright 2013 Red Hat Inc.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
- * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
- * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
- * OTHER DEALINGS IN THE SOFTWARE.
- *
- * Authors: Dave Airlie
- *          Alon Levy
- */
-
-
-#include "qxl_drv.h"
-
-/* QXL fencing-
-
-   When we submit operations to the GPU we pass a release reference to the GPU
-   with them, the release reference is then added to the release ring when
-   the GPU is finished with that particular operation and has removed it from
-   its tree.
-
-   So we have can have multiple outstanding non linear fences per object.
-
-   From a TTM POV we only care if the object has any outstanding releases on
-   it.
-
-   we wait until all outstanding releases are processeed.
-
-   sync object is just a list of release ids that represent that fence on
-   that buffer.
-
-   we just add new releases onto the sync object attached to the object.
-
-   This currently uses a radix tree to store the list of release ids.
-
-   For some reason every so often qxl hw fails to release, things go wrong.
-*/
-/* must be called with the fence lock held */
-void qxl_fence_add_release_locked(struct qxl_fence *qfence, uint32_t rel_id)
-{
-	radix_tree_insert(&qfence->tree, rel_id, qfence);
-	qfence->num_active_releases++;
-}
-
-int qxl_fence_remove_release(struct qxl_fence *qfence, uint32_t rel_id)
-{
-	void *ret;
-	int retval = 0;
-
-	ret = radix_tree_delete(&qfence->tree, rel_id);
-	if (ret == qfence)
-		qfence->num_active_releases--;
-	else {
-		DRM_DEBUG("didn't find fence in radix tree for %d\n", rel_id);
-		retval = -ENOENT;
-	}
-	return retval;
-}
-
-
-int qxl_fence_init(struct qxl_device *qdev, struct qxl_fence *qfence)
-{
-	qfence->qdev = qdev;
-	qfence->num_active_releases = 0;
-	INIT_RADIX_TREE(&qfence->tree, GFP_ATOMIC);
-	return 0;
-}
-
-void qxl_fence_fini(struct qxl_fence *qfence)
-{
-	kfree(qfence->release_ids);
-	qfence->num_active_releases = 0;
-}
diff --git a/drivers/gpu/drm/qxl/qxl_kms.c b/drivers/gpu/drm/qxl/qxl_kms.c
index fd88eb4a3f79..a9e7c30e92c5 100644
--- a/drivers/gpu/drm/qxl/qxl_kms.c
+++ b/drivers/gpu/drm/qxl/qxl_kms.c
@@ -223,6 +223,8 @@ static int qxl_device_init(struct qxl_device *qdev,
 
 	idr_init(&qdev->release_idr);
 	spin_lock_init(&qdev->release_idr_lock);
+	spin_lock_init(&qdev->release_lock);
+	spin_lock_init(&qdev->fence_lock);
 
 	idr_init(&qdev->surf_id_idr);
 	spin_lock_init(&qdev->surf_id_idr_lock);
diff --git a/drivers/gpu/drm/qxl/qxl_object.c b/drivers/gpu/drm/qxl/qxl_object.c
index b95f144f0b49..9981962451d7 100644
--- a/drivers/gpu/drm/qxl/qxl_object.c
+++ b/drivers/gpu/drm/qxl/qxl_object.c
@@ -36,7 +36,6 @@ static void qxl_ttm_bo_destroy(struct ttm_buffer_object *tbo)
 	qdev = (struct qxl_device *)bo->gem_base.dev->dev_private;
 
 	qxl_surface_evict(qdev, bo, false);
-	qxl_fence_fini(&bo->fence);
 	mutex_lock(&qdev->gem.mutex);
 	list_del_init(&bo->list);
 	mutex_unlock(&qdev->gem.mutex);
@@ -99,7 +98,6 @@ int qxl_bo_create(struct qxl_device *qdev,
 	bo->type = domain;
 	bo->pin_count = pinned ? 1 : 0;
 	bo->surface_id = 0;
-	qxl_fence_init(qdev, &bo->fence);
 	INIT_LIST_HEAD(&bo->list);
 
 	if (surf)
diff --git a/drivers/gpu/drm/qxl/qxl_release.c b/drivers/gpu/drm/qxl/qxl_release.c
index 4045ba873ab8..9731d2540a40 100644
--- a/drivers/gpu/drm/qxl/qxl_release.c
+++ b/drivers/gpu/drm/qxl/qxl_release.c
@@ -21,6 +21,7 @@
  */
 #include "qxl_drv.h"
 #include "qxl_object.h"
+#include <trace/events/fence.h>
 
 /*
  * drawable cmd cache - allocate a bunch of VRAM pages, suballocate
@@ -39,6 +40,88 @@
 static const int release_size_per_bo[] = { RELEASE_SIZE, SURFACE_RELEASE_SIZE, RELEASE_SIZE };
 static const int releases_per_bo[] = { RELEASES_PER_BO, SURFACE_RELEASES_PER_BO, RELEASES_PER_BO };
 
+static const char *qxl_get_driver_name(struct fence *fence)
+{
+	return "qxl";
+}
+
+static const char *qxl_get_timeline_name(struct fence *fence)
+{
+	return "release";
+}
+
+static bool qxl_nop_signaling(struct fence *fence)
+{
+	/* fences are always automatically signaled, so just pretend we did this.. */
+	return true;
+}
+
+static long qxl_fence_wait(struct fence *fence, bool intr, signed long timeout)
+{
+	struct qxl_device *qdev;
+	struct qxl_release *release;
+	int count = 0, sc = 0;
+	bool have_drawable_releases;
+	unsigned long cur, end = jiffies + timeout;
+
+	qdev = container_of(fence->lock, struct qxl_device, release_lock);
+	release = container_of(fence, struct qxl_release, base);
+	have_drawable_releases = release->type == QXL_RELEASE_DRAWABLE;
+
+retry:
+	sc++;
+
+	if (fence_is_signaled_locked(fence))
+		goto signaled;
+
+	qxl_io_notify_oom(qdev);
+
+	for (count = 0; count < 11; count++) {
+		if (!qxl_queue_garbage_collect(qdev, true))
+			break;
+
+		if (fence_is_signaled_locked(fence))
+			goto signaled;
+	}
+
+	if (fence_is_signaled_locked(fence))
+		goto signaled;
+
+	if (have_drawable_releases || sc < 4) {
+		if (sc > 2)
+			/* back off */
+			usleep_range(500, 1000);
+
+		if (time_after(jiffies, end))
+			return 0;
+
+		if (have_drawable_releases && sc > 300) {
+			FENCE_WARN(fence, "failed to wait on release %d "
+					  "after spincount %d\n",
+					  fence->context & ~0xf0000000, sc);
+			goto signaled;
+		}
+		goto retry;
+	}
+	/*
+	 * yeah, original sync_obj_wait gave up after 3 spins when
+	 * have_drawable_releases is not set.
+	 */
+
+signaled:
+	cur = jiffies;
+	if (time_after(cur, end))
+		return 0;
+	return end - cur;
+}
+
+static const struct fence_ops qxl_fence_ops = {
+	.get_driver_name = qxl_get_driver_name,
+	.get_timeline_name = qxl_get_timeline_name,
+	.enable_signaling = qxl_nop_signaling,
+	.wait = qxl_fence_wait,
+};
+
 static uint64_t
 qxl_release_alloc(struct qxl_device *qdev, int type,
 		  struct qxl_release **ret)
@@ -46,13 +129,13 @@ qxl_release_alloc(struct qxl_device *qdev, int type,
 	struct qxl_release *release;
 	int handle;
 	size_t size = sizeof(*release);
-	int idr_ret;
 
 	release = kmalloc(size, GFP_KERNEL);
 	if (!release) {
 		DRM_ERROR("Out of memory\n");
 		return 0;
 	}
+	release->base.ops = NULL;
 	release->type = type;
 	release->release_offset = 0;
 	release->surface_release_id = 0;
@@ -60,44 +143,59 @@ qxl_release_alloc(struct qxl_device *qdev, int type,
 
 	idr_preload(GFP_KERNEL);
 	spin_lock(&qdev->release_idr_lock);
-	idr_ret = idr_alloc(&qdev->release_idr, release, 1, 0, GFP_NOWAIT);
+	handle = idr_alloc(&qdev->release_idr, release, 1, 0, GFP_NOWAIT);
+	release->base.seqno = ++qdev->release_seqno;
 	spin_unlock(&qdev->release_idr_lock);
 	idr_preload_end();
-	handle = idr_ret;
-	if (idr_ret < 0)
-		goto release_fail;
+	if (handle < 0) {
+		kfree(release);
+		*ret = NULL;
+		return handle;
+	}
 	*ret = release;
 	QXL_INFO(qdev, "allocated release %lld\n", handle);
 	release->id = handle;
-release_fail:
-
 	return handle;
 }
 
+static void
+qxl_release_free_list(struct qxl_release *release)
+{
+	while (!list_empty(&release->bos)) {
+		struct ttm_validate_buffer *entry;
+
+		entry = container_of(release->bos.next,
+				     struct ttm_validate_buffer, head);
+
+		list_del(&entry->head);
+		kfree(entry);
+	}
+}
+
 void
 qxl_release_free(struct qxl_device *qdev,
 		 struct qxl_release *release)
 {
-	struct qxl_bo_list *entry, *tmp;
 	QXL_INFO(qdev, "release %d, type %d\n", release->id,
 		 release->type);
 
 	if (release->surface_release_id)
 		qxl_surface_id_dealloc(qdev, release->surface_release_id);
 
-	list_for_each_entry_safe(entry, tmp, &release->bos, tv.head) {
-		struct qxl_bo *bo = to_qxl_bo(entry->tv.bo);
-		QXL_INFO(qdev, "release %llx\n",
-			drm_vma_node_offset_addr(&entry->tv.bo->vma_node)
-						- DRM_FILE_OFFSET);
-		qxl_fence_remove_release(&bo->fence, release->id);
-		qxl_bo_unref(&bo);
-		kfree(entry);
-	}
 	spin_lock(&qdev->release_idr_lock);
 	idr_remove(&qdev->release_idr, release->id);
 	spin_unlock(&qdev->release_idr_lock);
-	kfree(release);
+
+	if (release->base.ops) {
+		WARN_ON(list_empty(&release->bos));
+		qxl_release_free_list(release);
+
+		fence_signal(&release->base);
+		fence_put(&release->base);
+	} else {
+		qxl_release_free_list(release);
+		kfree(release);
+	}
 }
 
 static int qxl_release_bo_alloc(struct qxl_device *qdev,
@@ -142,6 +240,10 @@ static int qxl_release_validate_bo(struct qxl_bo *bo)
 			return ret;
 	}
 
+	ret = reservation_object_reserve_shared(bo->tbo.resv);
+	if (ret)
+		return ret;
+
 	/* allocate a surface for reserved + validated buffers */
 	ret = qxl_bo_check_id(bo->gem_base.dev->dev_private, bo);
 	if (ret)
@@ -199,6 +301,8 @@ int qxl_alloc_surface_release_reserved(struct qxl_device *qdev,
 
 		/* stash the release after the create command */
 		idr_ret = qxl_release_alloc(qdev, QXL_RELEASE_SURFACE_CMD, release);
+		if (idr_ret < 0)
+			return idr_ret;
 		bo = qxl_bo_ref(to_qxl_bo(entry->tv.bo));
 
 		(*release)->release_offset = create_rel->release_offset + 64;
@@ -239,6 +343,11 @@ int qxl_alloc_release_reserved(struct qxl_device *qdev, unsigned long size,
 	}
 
 	idr_ret = qxl_release_alloc(qdev, type, release);
+	if (idr_ret < 0) {
+		if (rbo)
+			*rbo = NULL;
+		return idr_ret;
+	}
 
 	mutex_lock(&qdev->release_mutex);
 	if (qdev->current_release_bo_offset[cur_idx] + 1 >= releases_per_bo[cur_idx]) {
@@ -319,12 +428,13 @@ void qxl_release_unmap(struct qxl_device *qdev,
 
 void qxl_release_fence_buffer_objects(struct qxl_release *release)
 {
-	struct ttm_validate_buffer *entry;
 	struct ttm_buffer_object *bo;
 	struct ttm_bo_global *glob;
 	struct ttm_bo_device *bdev;
 	struct ttm_bo_driver *driver;
 	struct qxl_bo *qbo;
+	struct ttm_validate_buffer *entry;
+	struct qxl_device *qdev;
 
 	/* if only one object on the release its the release itself
 	   since these objects are pinned no need to reserve */
@@ -333,23 +443,35 @@ void qxl_release_fence_buffer_objects(struct qxl_release *release)
 
 	bo = list_first_entry(&release->bos, struct ttm_validate_buffer, head)->bo;
 	bdev = bo->bdev;
+	qdev = container_of(bdev, struct qxl_device, mman.bdev);
+
+	/*
+	 * Since we never really allocated a context and we don't want to conflict,
+	 * set the highest bits. This will break if we really allow exporting of dma-bufs.
+	 */
+	fence_init(&release->base, &qxl_fence_ops, &qdev->release_lock,
+		   release->id | 0xf0000000, release->base.seqno);
+	trace_fence_emit(&release->base);
+
 	driver = bdev->driver;
 	glob = bo->glob;
 
 	spin_lock(&glob->lru_lock);
+	/* acquire release_lock to protect bo->resv->fence and its contents */
+	spin_lock(&qdev->release_lock);
 
 	list_for_each_entry(entry, &release->bos, head) {
 		bo = entry->bo;
 		qbo = to_qxl_bo(bo);
 
 		if (!entry->bo->sync_obj)
-			entry->bo->sync_obj = &qbo->fence;
-
-		qxl_fence_add_release_locked(&qbo->fence, release->id);
+			entry->bo->sync_obj = qbo;
 
+		reservation_object_add_shared_fence(bo->resv, &release->base);
 		ttm_bo_add_to_lru(bo);
 		__ttm_bo_unreserve(bo);
 	}
+	spin_unlock(&qdev->release_lock);
 	spin_unlock(&glob->lru_lock);
 	ww_acquire_fini(&release->ticket);
 }
diff --git a/drivers/gpu/drm/qxl/qxl_ttm.c b/drivers/gpu/drm/qxl/qxl_ttm.c
index 71a1baeac14e..6230251fa5b0 100644
--- a/drivers/gpu/drm/qxl/qxl_ttm.c
+++ b/drivers/gpu/drm/qxl/qxl_ttm.c
@@ -355,67 +355,67 @@ static int qxl_bo_move(struct ttm_buffer_object *bo,
 	return ttm_bo_move_memcpy(bo, evict, no_wait_gpu, new_mem);
 }
 
+static bool qxl_sync_obj_signaled(void *sync_obj);
 
 static int qxl_sync_obj_wait(void *sync_obj,
 			     bool lazy, bool interruptible)
 {
-	struct qxl_fence *qfence = (struct qxl_fence *)sync_obj;
-	int count = 0, sc = 0;
-	struct qxl_bo *bo = container_of(qfence, struct qxl_bo, fence);
-
-	if (qfence->num_active_releases == 0)
-		return 0;
+	struct qxl_bo *bo = (struct qxl_bo *)sync_obj;
+	struct qxl_device *qdev = bo->gem_base.dev->dev_private;
+	struct reservation_object_list *fobj;
+	int count = 0, sc = 0, num_release = 0;
+	bool have_drawable_releases;
 
 retry:
 	if (sc == 0) {
 		if (bo->type == QXL_GEM_DOMAIN_SURFACE)
-			qxl_update_surface(qfence->qdev, bo);
+			qxl_update_surface(qdev, bo);
 	} else if (sc >= 1) {
-		qxl_io_notify_oom(qfence->qdev);
+		qxl_io_notify_oom(qdev);
 	}
 
 	sc++;
 
 	for (count = 0; count < 10; count++) {
-		bool ret;
-		ret = qxl_queue_garbage_collect(qfence->qdev, true);
-		if (ret == false)
-			break;
-
-		if (qfence->num_active_releases == 0)
+		if (qxl_sync_obj_signaled(sync_obj))
 			return 0;
+
+		if (!qxl_queue_garbage_collect(qdev, true))
+			break;
 	}
 
-	if (qfence->num_active_releases) {
-		bool have_drawable_releases = false;
-		void **slot;
-		struct radix_tree_iter iter;
-		int release_id;
+	have_drawable_releases = false;
+	num_release = 0;
 
-		radix_tree_for_each_slot(slot, &qfence->tree, &iter, 0) {
-			struct qxl_release *release;
+	spin_lock(&qdev->release_lock);
+	fobj = bo->tbo.resv->fence;
+	for (count = 0; fobj && count < fobj->shared_count; count++) {
+		struct qxl_release *release;
 
-			release_id = iter.index;
-			release = qxl_release_from_id_locked(qfence->qdev, release_id);
-			if (release == NULL)
-				continue;
+		release = container_of(fobj->shared[count],
+				       struct qxl_release, base);
 
-			if (release->type == QXL_RELEASE_DRAWABLE)
-				have_drawable_releases = true;
-		}
+		if (fence_is_signaled(&release->base))
+			continue;
+
+		num_release++;
+
+		if (release->type == QXL_RELEASE_DRAWABLE)
+			have_drawable_releases = true;
+	}
+	spin_unlock(&qdev->release_lock);
+
+	qxl_queue_garbage_collect(qdev, true);
 
-		qxl_queue_garbage_collect(qfence->qdev, true);
-
-		if (have_drawable_releases || sc < 4) {
-			if (sc > 2)
-				/* back off */
-				usleep_range(500, 1000);
-			if (have_drawable_releases && sc > 300) {
-				WARN(1, "sync obj %d still has outstanding releases %d %d %d %ld %d\n", sc, bo->surface_id, bo->is_primary, bo->pin_count, (unsigned long)bo->gem_base.size, qfence->num_active_releases);
-				return -EBUSY;
-			}
-			goto retry;
+	if (have_drawable_releases || sc < 4) {
+		if (sc > 2)
+			/* back off */
+			usleep_range(500, 1000);
+		if (have_drawable_releases && sc > 300) {
+			WARN(1, "sync obj %d still has outstanding releases %d %d %d %ld %d\n", sc, bo->surface_id, bo->is_primary, bo->pin_count, (unsigned long)bo->gem_base.size, num_release);
+			return -EBUSY;
 		}
+		goto retry;
 	}
 	return 0;
 }
@@ -437,8 +437,21 @@ static void *qxl_sync_obj_ref(void *sync_obj)
 
 static bool qxl_sync_obj_signaled(void *sync_obj)
 {
-	struct qxl_fence *qfence = (struct qxl_fence *)sync_obj;
-	return (qfence->num_active_releases == 0);
+	struct qxl_bo *qbo = (struct qxl_bo *)sync_obj;
+	struct qxl_device *qdev = qbo->gem_base.dev->dev_private;
+	struct reservation_object_list *fobj;
+	bool ret = true;
+	unsigned i;
+
+	spin_lock(&qdev->release_lock);
+	fobj = qbo->tbo.resv->fence;
+	for (i = 0; fobj && i < fobj->shared_count; ++i) {
+		ret = fence_is_signaled(fobj->shared[i]);
+		if (!ret)
+			break;
+	}
+	spin_unlock(&qdev->release_lock);
+	return ret;
 }
 
 static void qxl_bo_move_notify(struct ttm_buffer_object *bo,
@@ -475,8 +488,6 @@ static struct ttm_bo_driver qxl_bo_driver = {
 	.move_notify = &qxl_bo_move_notify,
 };
 
-
-
 int qxl_ttm_init(struct qxl_device *qdev)
 {
 	int r;

