Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbaGIM3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:29:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44661 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbaGIM3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:29:17 -0400
Subject: [PATCH 02/17] drm/ttm: kill off some members to ttm_validate_buffer
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Wed, 09 Jul 2014 14:29:12 +0200
Message-ID: <20140709122912.11354.9897.stgit@patser>
In-Reply-To: <20140709093124.11354.3774.stgit@patser>
References: <20140709093124.11354.3774.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reorders the list to keep track of what buffers are reserved,
so previous members are always unreserved.

This gets rid of some bookkeeping that's no longer needed,
while simplifying the code some.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/qxl/qxl_release.c       |    1 
 drivers/gpu/drm/ttm/ttm_execbuf_util.c  |  142 +++++++++++--------------------
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    1 
 include/drm/ttm/ttm_execbuf_util.h      |    3 -
 4 files changed, 50 insertions(+), 97 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_release.c b/drivers/gpu/drm/qxl/qxl_release.c
index 2b43e5deb051..e85c4d274dc0 100644
--- a/drivers/gpu/drm/qxl/qxl_release.c
+++ b/drivers/gpu/drm/qxl/qxl_release.c
@@ -350,7 +350,6 @@ void qxl_release_fence_buffer_objects(struct qxl_release *release)
 
 		ttm_bo_add_to_lru(bo);
 		__ttm_bo_unreserve(bo);
-		entry->reserved = false;
 	}
 	spin_unlock(&bdev->fence_lock);
 	spin_unlock(&glob->lru_lock);
diff --git a/drivers/gpu/drm/ttm/ttm_execbuf_util.c b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
index 39a11bbd2bac..6db47a72667e 100644
--- a/drivers/gpu/drm/ttm/ttm_execbuf_util.c
+++ b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
@@ -32,20 +32,12 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 
-static void ttm_eu_backoff_reservation_locked(struct list_head *list)
+static void ttm_eu_backoff_reservation_reverse(struct list_head *list,
+					      struct ttm_validate_buffer *entry)
 {
-	struct ttm_validate_buffer *entry;
-
-	list_for_each_entry(entry, list, head) {
+	list_for_each_entry_continue_reverse(entry, list, head) {
 		struct ttm_buffer_object *bo = entry->bo;
-		if (!entry->reserved)
-			continue;
 
-		entry->reserved = false;
-		if (entry->removed) {
-			ttm_bo_add_to_lru(bo);
-			entry->removed = false;
-		}
 		__ttm_bo_unreserve(bo);
 	}
 }
@@ -56,27 +48,9 @@ static void ttm_eu_del_from_lru_locked(struct list_head *list)
 
 	list_for_each_entry(entry, list, head) {
 		struct ttm_buffer_object *bo = entry->bo;
-		if (!entry->reserved)
-			continue;
+		unsigned put_count = ttm_bo_del_from_lru(bo);
 
-		if (!entry->removed) {
-			entry->put_count = ttm_bo_del_from_lru(bo);
-			entry->removed = true;
-		}
-	}
-}
-
-static void ttm_eu_list_ref_sub(struct list_head *list)
-{
-	struct ttm_validate_buffer *entry;
-
-	list_for_each_entry(entry, list, head) {
-		struct ttm_buffer_object *bo = entry->bo;
-
-		if (entry->put_count) {
-			ttm_bo_list_ref_sub(bo, entry->put_count, true);
-			entry->put_count = 0;
-		}
+		ttm_bo_list_ref_sub(bo, put_count, true);
 	}
 }
 
@@ -91,11 +65,18 @@ void ttm_eu_backoff_reservation(struct ww_acquire_ctx *ticket,
 
 	entry = list_first_entry(list, struct ttm_validate_buffer, head);
 	glob = entry->bo->glob;
+
 	spin_lock(&glob->lru_lock);
-	ttm_eu_backoff_reservation_locked(list);
+	list_for_each_entry(entry, list, head) {
+		struct ttm_buffer_object *bo = entry->bo;
+
+		ttm_bo_add_to_lru(bo);
+		__ttm_bo_unreserve(bo);
+	}
+	spin_unlock(&glob->lru_lock);
+
 	if (ticket)
 		ww_acquire_fini(ticket);
-	spin_unlock(&glob->lru_lock);
 }
 EXPORT_SYMBOL(ttm_eu_backoff_reservation);
 
@@ -121,64 +102,55 @@ int ttm_eu_reserve_buffers(struct ww_acquire_ctx *ticket,
 	if (list_empty(list))
 		return 0;
 
-	list_for_each_entry(entry, list, head) {
-		entry->reserved = false;
-		entry->put_count = 0;
-		entry->removed = false;
-	}
-
 	entry = list_first_entry(list, struct ttm_validate_buffer, head);
 	glob = entry->bo->glob;
 
 	if (ticket)
 		ww_acquire_init(ticket, &reservation_ww_class);
-retry:
+
 	list_for_each_entry(entry, list, head) {
 		struct ttm_buffer_object *bo = entry->bo;
 
-		/* already slowpath reserved? */
-		if (entry->reserved)
-			continue;
-
 		ret = __ttm_bo_reserve(bo, intr, (ticket == NULL), true,
 				       ticket);
+		if (!ret && unlikely(atomic_read(&bo->cpu_writers) > 0)) {
+			__ttm_bo_unreserve(bo);
 
-		if (ret == -EDEADLK) {
-			/* uh oh, we lost out, drop every reservation and try
-			 * to only reserve this buffer, then start over if
-			 * this succeeds.
-			 */
-			BUG_ON(ticket == NULL);
-			spin_lock(&glob->lru_lock);
-			ttm_eu_backoff_reservation_locked(list);
-			spin_unlock(&glob->lru_lock);
-			ttm_eu_list_ref_sub(list);
-
-			if (intr) {
-				ret = ww_mutex_lock_slow_interruptible(&bo->resv->lock,
-								       ticket);
-				if (unlikely(ret != 0)) {
-					if (ret == -EINTR)
-						ret = -ERESTARTSYS;
-					goto err_fini;
-				}
-			} else
-				ww_mutex_lock_slow(&bo->resv->lock, ticket);
-
-			entry->reserved = true;
-			if (unlikely(atomic_read(&bo->cpu_writers) > 0)) {
-				ret = -EBUSY;
-				goto err;
-			}
-			goto retry;
-		} else if (ret)
-			goto err;
-
-		entry->reserved = true;
-		if (unlikely(atomic_read(&bo->cpu_writers) > 0)) {
 			ret = -EBUSY;
-			goto err;
 		}
+
+		if (!ret)
+			continue;
+
+		/* uh oh, we lost out, drop every reservation and try
+		 * to only reserve this buffer, then start over if
+		 * this succeeds.
+		 */
+		ttm_eu_backoff_reservation_reverse(list, entry);
+
+		if (ret == -EDEADLK && intr) {
+			ret = ww_mutex_lock_slow_interruptible(&bo->resv->lock,
+							       ticket);
+		} else if (ret == -EDEADLK) {
+			ww_mutex_lock_slow(&bo->resv->lock, ticket);
+			ret = 0;
+		}
+
+		if (unlikely(ret != 0)) {
+			if (ret == -EINTR)
+				ret = -ERESTARTSYS;
+			if (ticket) {
+				ww_acquire_done(ticket);
+				ww_acquire_fini(ticket);
+			}
+			return ret;
+		}
+
+		/* move this item to the front of the list,
+		 * forces correct iteration of the loop without keeping track
+		 */
+		list_del(&entry->head);
+		list_add(&entry->head, list);
 	}
 
 	if (ticket)
@@ -186,20 +158,7 @@ retry:
 	spin_lock(&glob->lru_lock);
 	ttm_eu_del_from_lru_locked(list);
 	spin_unlock(&glob->lru_lock);
-	ttm_eu_list_ref_sub(list);
 	return 0;
-
-err:
-	spin_lock(&glob->lru_lock);
-	ttm_eu_backoff_reservation_locked(list);
-	spin_unlock(&glob->lru_lock);
-	ttm_eu_list_ref_sub(list);
-err_fini:
-	if (ticket) {
-		ww_acquire_done(ticket);
-		ww_acquire_fini(ticket);
-	}
-	return ret;
 }
 EXPORT_SYMBOL(ttm_eu_reserve_buffers);
 
@@ -229,7 +188,6 @@ void ttm_eu_fence_buffer_objects(struct ww_acquire_ctx *ticket,
 		bo->sync_obj = driver->sync_obj_ref(sync_obj);
 		ttm_bo_add_to_lru(bo);
 		__ttm_bo_unreserve(bo);
-		entry->reserved = false;
 	}
 	spin_unlock(&bdev->fence_lock);
 	spin_unlock(&glob->lru_lock);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 5d7d2e00296b..f8b25bc4e634 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -346,7 +346,6 @@ static int vmw_bo_to_validate_list(struct vmw_sw_context *sw_context,
 		++sw_context->cur_val_buf;
 		val_buf = &vval_buf->base;
 		val_buf->bo = ttm_bo_reference(bo);
-		val_buf->reserved = false;
 		list_add_tail(&val_buf->head, &sw_context->validate_nodes);
 		vval_buf->validate_as_mob = validate_as_mob;
 	}
diff --git a/include/drm/ttm/ttm_execbuf_util.h b/include/drm/ttm/ttm_execbuf_util.h
index fd95fd569ca3..8490cb8ee0d8 100644
--- a/include/drm/ttm/ttm_execbuf_util.h
+++ b/include/drm/ttm/ttm_execbuf_util.h
@@ -48,9 +48,6 @@
 struct ttm_validate_buffer {
 	struct list_head head;
 	struct ttm_buffer_object *bo;
-	bool reserved;
-	bool removed;
-	int put_count;
 	void *old_sync_obj;
 };
 

