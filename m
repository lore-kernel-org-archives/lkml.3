Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbaGIM3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:29:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44646 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbaGIM3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:29:11 -0400
Subject: [PATCH 01/17] drm/ttm: add interruptible parameter to
 ttm_eu_reserve_buffers
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Wed, 09 Jul 2014 14:29:06 +0200
Message-ID: <20140709122906.11354.80450.stgit@patser>
In-Reply-To: <20140709093124.11354.3774.stgit@patser>
References: <20140709093124.11354.3774.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems some drivers really want this as a parameter,
like vmwgfx.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/qxl/qxl_release.c        |    2 +-
 drivers/gpu/drm/radeon/radeon_object.c   |    2 +-
 drivers/gpu/drm/radeon/radeon_uvd.c      |    2 +-
 drivers/gpu/drm/radeon/radeon_vm.c       |    2 +-
 drivers/gpu/drm/ttm/ttm_execbuf_util.c   |   22 +++++++++++++---------
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c  |    7 ++-----
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |    2 +-
 include/drm/ttm/ttm_execbuf_util.h       |    9 +++++----
 8 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_release.c b/drivers/gpu/drm/qxl/qxl_release.c
index 14e776f1d14e..2b43e5deb051 100644
--- a/drivers/gpu/drm/qxl/qxl_release.c
+++ b/drivers/gpu/drm/qxl/qxl_release.c
@@ -159,7 +159,7 @@ int qxl_release_reserve_list(struct qxl_release *release, bool no_intr)
 	if (list_is_singular(&release->bos))
 		return 0;
 
-	ret = ttm_eu_reserve_buffers(&release->ticket, &release->bos);
+	ret = ttm_eu_reserve_buffers(&release->ticket, &release->bos, !no_intr);
 	if (ret)
 		return ret;
 
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index 6c717b257d6d..a3ed725ea641 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -438,7 +438,7 @@ int radeon_bo_list_validate(struct radeon_device *rdev,
 	u64 bytes_moved = 0, initial_bytes_moved;
 	u64 bytes_moved_threshold = radeon_bo_get_threshold_for_moves(rdev);
 
-	r = ttm_eu_reserve_buffers(ticket, head);
+	r = ttm_eu_reserve_buffers(ticket, head, true);
 	if (unlikely(r != 0)) {
 		return r;
 	}
diff --git a/drivers/gpu/drm/radeon/radeon_uvd.c b/drivers/gpu/drm/radeon/radeon_uvd.c
index a4ad270e8261..67b2a367df40 100644
--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -620,7 +620,7 @@ static int radeon_uvd_send_msg(struct radeon_device *rdev,
 	INIT_LIST_HEAD(&head);
 	list_add(&tv.head, &head);
 
-	r = ttm_eu_reserve_buffers(&ticket, &head);
+	r = ttm_eu_reserve_buffers(&ticket, &head, true);
 	if (r)
 		return r;
 
diff --git a/drivers/gpu/drm/radeon/radeon_vm.c b/drivers/gpu/drm/radeon/radeon_vm.c
index eecff6bbd341..4c68852c3e72 100644
--- a/drivers/gpu/drm/radeon/radeon_vm.c
+++ b/drivers/gpu/drm/radeon/radeon_vm.c
@@ -364,7 +364,7 @@ static int radeon_vm_clear_bo(struct radeon_device *rdev,
         INIT_LIST_HEAD(&head);
         list_add(&tv.head, &head);
 
-        r = ttm_eu_reserve_buffers(&ticket, &head);
+        r = ttm_eu_reserve_buffers(&ticket, &head, true);
         if (r)
 		return r;
 
diff --git a/drivers/gpu/drm/ttm/ttm_execbuf_util.c b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
index e8dac8758528..39a11bbd2bac 100644
--- a/drivers/gpu/drm/ttm/ttm_execbuf_util.c
+++ b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
@@ -112,7 +112,7 @@ EXPORT_SYMBOL(ttm_eu_backoff_reservation);
  */
 
 int ttm_eu_reserve_buffers(struct ww_acquire_ctx *ticket,
-			   struct list_head *list)
+			   struct list_head *list, bool intr)
 {
 	struct ttm_bo_global *glob;
 	struct ttm_validate_buffer *entry;
@@ -140,7 +140,7 @@ retry:
 		if (entry->reserved)
 			continue;
 
-		ret = __ttm_bo_reserve(bo, true, (ticket == NULL), true,
+		ret = __ttm_bo_reserve(bo, intr, (ticket == NULL), true,
 				       ticket);
 
 		if (ret == -EDEADLK) {
@@ -153,13 +153,17 @@ retry:
 			ttm_eu_backoff_reservation_locked(list);
 			spin_unlock(&glob->lru_lock);
 			ttm_eu_list_ref_sub(list);
-			ret = ww_mutex_lock_slow_interruptible(&bo->resv->lock,
-							       ticket);
-			if (unlikely(ret != 0)) {
-				if (ret == -EINTR)
-					ret = -ERESTARTSYS;
-				goto err_fini;
-			}
+
+			if (intr) {
+				ret = ww_mutex_lock_slow_interruptible(&bo->resv->lock,
+								       ticket);
+				if (unlikely(ret != 0)) {
+					if (ret == -EINTR)
+						ret = -ERESTARTSYS;
+					goto err_fini;
+				}
+			} else
+				ww_mutex_lock_slow(&bo->resv->lock, ticket);
 
 			entry->reserved = true;
 			if (unlikely(atomic_read(&bo->cpu_writers) > 0)) {
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 87df0b3674fd..5d7d2e00296b 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2465,7 +2465,7 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 	if (unlikely(ret != 0))
 		goto out_err_nores;
 
-	ret = ttm_eu_reserve_buffers(&ticket, &sw_context->validate_nodes);
+	ret = ttm_eu_reserve_buffers(&ticket, &sw_context->validate_nodes, true);
 	if (unlikely(ret != 0))
 		goto out_err;
 
@@ -2655,10 +2655,7 @@ void __vmw_execbuf_release_pinned_bo(struct vmw_private *dev_priv,
 	query_val.bo = ttm_bo_reference(dev_priv->dummy_query_bo);
 	list_add_tail(&query_val.head, &validate_list);
 
-	do {
-		ret = ttm_eu_reserve_buffers(&ticket, &validate_list);
-	} while (ret == -ERESTARTSYS);
-
+	ret = ttm_eu_reserve_buffers(&ticket, &validate_list, false);
 	if (unlikely(ret != 0)) {
 		vmw_execbuf_unpin_panic(dev_priv);
 		goto out_no_reserve;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index 01d68f0a69dc..873613a16f72 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -1215,7 +1215,7 @@ vmw_resource_check_buffer(struct vmw_resource *res,
 	INIT_LIST_HEAD(&val_list);
 	val_buf->bo = ttm_bo_reference(&res->backup->base);
 	list_add_tail(&val_buf->head, &val_list);
-	ret = ttm_eu_reserve_buffers(NULL, &val_list);
+	ret = ttm_eu_reserve_buffers(NULL, &val_list, interruptible);
 	if (unlikely(ret != 0))
 		goto out_no_reserve;
 
diff --git a/include/drm/ttm/ttm_execbuf_util.h b/include/drm/ttm/ttm_execbuf_util.h
index 16db7d01a336..fd95fd569ca3 100644
--- a/include/drm/ttm/ttm_execbuf_util.h
+++ b/include/drm/ttm/ttm_execbuf_util.h
@@ -73,6 +73,7 @@ extern void ttm_eu_backoff_reservation(struct ww_acquire_ctx *ticket,
  * @ticket:  [out] ww_acquire_ctx filled in by call, or NULL if only
  *           non-blocking reserves should be tried.
  * @list:    thread private list of ttm_validate_buffer structs.
+ * @intr:    should the wait be interruptible
  *
  * Tries to reserve bos pointed to by the list entries for validation.
  * If the function returns 0, all buffers are marked as "unfenced",
@@ -84,9 +85,9 @@ extern void ttm_eu_backoff_reservation(struct ww_acquire_ctx *ticket,
  * CPU write reservations to be cleared, and for other threads to
  * unreserve their buffers.
  *
- * This function may return -ERESTART or -EAGAIN if the calling process
- * receives a signal while waiting. In that case, no buffers on the list
- * will be reserved upon return.
+ * If intr is set to true, this function may return -ERESTARTSYS if the
+ * calling process receives a signal while waiting. In that case, no
+ * buffers on the list will be reserved upon return.
  *
  * Buffers reserved by this function should be unreserved by
  * a call to either ttm_eu_backoff_reservation() or
@@ -95,7 +96,7 @@ extern void ttm_eu_backoff_reservation(struct ww_acquire_ctx *ticket,
  */
 
 extern int ttm_eu_reserve_buffers(struct ww_acquire_ctx *ticket,
-				  struct list_head *list);
+				  struct list_head *list, bool intr);
 
 /**
  * function ttm_eu_fence_buffer_objects.

