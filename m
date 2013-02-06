Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab3BFTuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:50:23 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:44017 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab3BFTuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:15 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 31/77] drm: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:03 -0800
Message-Id: <1360179649-22465-32-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

* drm_ctxbitmap_next() error handling in drm_addctx() seems broken.
  drm_ctxbitmap_next() return -errno on failure not -1.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_context.c | 17 +++--------------
 drivers/gpu/drm/drm_crtc.c    | 19 ++++---------------
 drivers/gpu/drm/drm_gem.c     | 35 +++++++++++++----------------------
 drivers/gpu/drm/drm_stub.c    | 19 ++-----------------
 4 files changed, 22 insertions(+), 68 deletions(-)

diff --git a/drivers/gpu/drm/drm_context.c b/drivers/gpu/drm/drm_context.c
index 75f62c5..725968d 100644
--- a/drivers/gpu/drm/drm_context.c
+++ b/drivers/gpu/drm/drm_context.c
@@ -74,24 +74,13 @@ void drm_ctxbitmap_free(struct drm_device * dev, int ctx_handle)
  */
 static int drm_ctxbitmap_next(struct drm_device * dev)
 {
-	int new_id;
 	int ret;
 
-again:
-	if (idr_pre_get(&dev->ctx_idr, GFP_KERNEL) == 0) {
-		DRM_ERROR("Out of memory expanding drawable idr\n");
-		return -ENOMEM;
-	}
 	mutex_lock(&dev->struct_mutex);
-	ret = idr_get_new_above(&dev->ctx_idr, NULL,
-				DRM_RESERVED_CONTEXTS, &new_id);
+	ret = idr_alloc(&dev->ctx_idr, NULL, DRM_RESERVED_CONTEXTS, 0,
+			GFP_KERNEL);
 	mutex_unlock(&dev->struct_mutex);
-	if (ret == -EAGAIN)
-		goto again;
-	else if (ret)
-		return ret;
-
-	return new_id;
+	return ret;
 }
 
 /**
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 775102d..838c9b6 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -252,32 +252,21 @@ char *drm_get_connector_status_name(enum drm_connector_status status)
 static int drm_mode_object_get(struct drm_device *dev,
 			       struct drm_mode_object *obj, uint32_t obj_type)
 {
-	int new_id = 0;
 	int ret;
 
-again:
-	if (idr_pre_get(&dev->mode_config.crtc_idr, GFP_KERNEL) == 0) {
-		DRM_ERROR("Ran out memory getting a mode number\n");
-		return -ENOMEM;
-	}
-
 	mutex_lock(&dev->mode_config.idr_mutex);
-	ret = idr_get_new_above(&dev->mode_config.crtc_idr, obj, 1, &new_id);
-
-	if (!ret) {
+	ret = idr_alloc(&dev->mode_config.crtc_idr, obj, 1, 0, GFP_KERNEL);
+	if (ret >= 0) {
 		/*
 		 * Set up the object linking under the protection of the idr
 		 * lock so that other users can't see inconsistent state.
 		 */
-		obj->id = new_id;
+		obj->id = ret;
 		obj->type = obj_type;
 	}
 	mutex_unlock(&dev->mode_config.idr_mutex);
 
-	if (ret == -EAGAIN)
-		goto again;
-
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 /**
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index e775859..6577514 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -270,21 +270,19 @@ drm_gem_handle_create(struct drm_file *file_priv,
 	int ret;
 
 	/*
-	 * Get the user-visible handle using idr.
+	 * Get the user-visible handle using idr.  Preload and perform
+	 * allocation under our spinlock.
 	 */
-again:
-	/* ensure there is space available to allocate a handle */
-	if (idr_pre_get(&file_priv->object_idr, GFP_KERNEL) == 0)
-		return -ENOMEM;
-
-	/* do the allocation under our spinlock */
+	idr_preload(GFP_KERNEL);
 	spin_lock(&file_priv->table_lock);
-	ret = idr_get_new_above(&file_priv->object_idr, obj, 1, (int *)handlep);
+
+	ret = idr_alloc(&file_priv->object_idr, obj, 1, 0, GFP_NOWAIT);
+
 	spin_unlock(&file_priv->table_lock);
-	if (ret == -EAGAIN)
-		goto again;
-	else if (ret)
+	idr_preload_end();
+	if (ret < 0)
 		return ret;
+	*handlep = ret;
 
 	drm_gem_object_handle_reference(obj);
 
@@ -451,22 +449,15 @@ drm_gem_flink_ioctl(struct drm_device *dev, void *data,
 	if (obj == NULL)
 		return -ENOENT;
 
-again:
-	if (idr_pre_get(&dev->object_name_idr, GFP_KERNEL) == 0) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
+	idr_preload(GFP_KERNEL);
 	spin_lock(&dev->object_name_lock);
 	if (!obj->name) {
-		ret = idr_get_new_above(&dev->object_name_idr, obj, 1,
-					&obj->name);
+		ret = idr_alloc(&dev->object_name_idr, obj, 1, 0, GFP_NOWAIT);
+		obj->name = ret;
 		args->name = (uint64_t) obj->name;
 		spin_unlock(&dev->object_name_lock);
 
-		if (ret == -EAGAIN)
-			goto again;
-		else if (ret)
+		if (ret < 0)
 			goto err;
 
 		/* Allocate a reference for the name table.  */
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 200e104..7d30802 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -109,7 +109,6 @@ EXPORT_SYMBOL(drm_ut_debug_printk);
 
 static int drm_minor_get_id(struct drm_device *dev, int type)
 {
-	int new_id;
 	int ret;
 	int base = 0, limit = 63;
 
@@ -121,25 +120,11 @@ static int drm_minor_get_id(struct drm_device *dev, int type)
                 limit = base + 255;
         }
 
-again:
-	if (idr_pre_get(&drm_minors_idr, GFP_KERNEL) == 0) {
-		DRM_ERROR("Out of memory expanding drawable idr\n");
-		return -ENOMEM;
-	}
 	mutex_lock(&dev->struct_mutex);
-	ret = idr_get_new_above(&drm_minors_idr, NULL,
-				base, &new_id);
+	ret = idr_alloc(&drm_minors_idr, NULL, base, limit, GFP_KERNEL);
 	mutex_unlock(&dev->struct_mutex);
-	if (ret == -EAGAIN)
-		goto again;
-	else if (ret)
-		return ret;
 
-	if (new_id >= limit) {
-		idr_remove(&drm_minors_idr, new_id);
-		return -EINVAL;
-	}
-	return new_id;
+	return ret == -ENOSPC ? -EINVAL : ret;
 }
 
 struct drm_master *drm_master_create(struct drm_minor *minor)
-- 
1.8.1

