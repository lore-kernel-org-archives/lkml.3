Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679Ab3CMMiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 08:38:10 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4283 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029Ab3CMMf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 08:35:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 13 Mar 2013 05:29:08 -0700
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>
Subject: [PATCHv7 01/10] gpu: drm: Support CMA object preallocation
Date: Wed, 13 Mar 2013 14:36:17 +0200
Message-ID: <1363178186-2017-2-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363178186-2017-1-git-send-email-tbergstrom@nvidia.com>
References: <1363178186-2017-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arto Merilainen <amerilainen@nvidia.com>

This patch adds helper functions drm_gem_cma_init() and
drm_gem_cma_deinit() for handling CMA structures that already have
been allocated. This allows embedding the CMA structure inside other
structures.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/drm/drm_gem_cma_helper.c |   78 ++++++++++++++++++++++++----------
 include/drm/drm_gem_cma_helper.h     |    9 ++++
 2 files changed, 64 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_cma_helper.c b/drivers/gpu/drm/drm_gem_cma_helper.c
index 0a7e011..3b14280 100644
--- a/drivers/gpu/drm/drm_gem_cma_helper.c
+++ b/drivers/gpu/drm/drm_gem_cma_helper.c
@@ -2,6 +2,7 @@
  * drm gem CMA (contiguous memory allocator) helper functions
  *
  * Copyright (C) 2012 Sascha Hauer, Pengutronix
+ * Copyright (C) 2013 NVIDIA CORPORATION, All rights reserved.
  *
  * Based on Samsung Exynos code
  *
@@ -40,30 +41,25 @@ static void drm_gem_cma_buf_destroy(struct drm_device *drm,
 }
 
 /*
- * drm_gem_cma_create - allocate an object with the given size
+ * drm_gem_cma_object_init - allocate buffer and initialize given cma object
  *
- * returns a struct drm_gem_cma_object* on success or ERR_PTR values
- * on failure.
+ * this function allocates memory for a cma buffer and initializes the given
+ * cma object to use the allocated buffer.
  */
-struct drm_gem_cma_object *drm_gem_cma_create(struct drm_device *drm,
-		unsigned int size)
+
+int drm_gem_cma_object_init(struct drm_device *drm,
+		struct drm_gem_cma_object *cma_obj, unsigned int size)
 {
-	struct drm_gem_cma_object *cma_obj;
 	struct drm_gem_object *gem_obj;
 	int ret;
 
 	size = round_up(size, PAGE_SIZE);
 
-	cma_obj = kzalloc(sizeof(*cma_obj), GFP_KERNEL);
-	if (!cma_obj)
-		return ERR_PTR(-ENOMEM);
-
 	cma_obj->vaddr = dma_alloc_writecombine(drm->dev, size,
 			&cma_obj->paddr, GFP_KERNEL | __GFP_NOWARN);
 	if (!cma_obj->vaddr) {
 		dev_err(drm->dev, "failed to allocate buffer with size %d\n", size);
-		ret = -ENOMEM;
-		goto err_dma_alloc;
+		return -ENOMEM;
 	}
 
 	gem_obj = &cma_obj->base;
@@ -76,7 +72,7 @@ struct drm_gem_cma_object *drm_gem_cma_create(struct drm_device *drm,
 	if (ret)
 		goto err_create_mmap_offset;
 
-	return cma_obj;
+	return 0;
 
 err_create_mmap_offset:
 	drm_gem_object_release(gem_obj);
@@ -84,10 +80,36 @@ err_create_mmap_offset:
 err_obj_init:
 	drm_gem_cma_buf_destroy(drm, cma_obj);
 
-err_dma_alloc:
-	kfree(cma_obj);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(drm_gem_cma_object_init);
+
+/*
+ * drm_gem_cma_create - allocate an object with the given size
+ *
+ * returns a struct drm_gem_cma_object* on success or ERR_PTR values
+ * on failure.
+ */
+struct drm_gem_cma_object *drm_gem_cma_create(struct drm_device *drm,
+		unsigned int size)
+{
+	struct drm_gem_cma_object *cma_obj;
+	int ret;
+
+	size = round_up(size, PAGE_SIZE);
+
+	cma_obj = kzalloc(sizeof(*cma_obj), GFP_KERNEL);
+	if (!cma_obj)
+		return ERR_PTR(-ENOMEM);
+
+	ret = drm_gem_cma_object_init(drm, cma_obj, size);
+	if (ret) {
+		kfree(cma_obj);
+		return ERR_PTR(ret);
+	}
+
+	return cma_obj;
 
-	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(drm_gem_cma_create);
 
@@ -133,22 +155,32 @@ err_handle_create:
 }
 
 /*
- * drm_gem_cma_free_object - (struct drm_driver)->gem_free_object callback
- * function
+ * drm_gem_cma_deinit_object - deinitialize cma object
+ *
+ * this function deinitializes the given cma object without releasing the
+ * object memory. this function is a counterpart for the function
+ * drm_gem_cma_object_init().
  */
-void drm_gem_cma_free_object(struct drm_gem_object *gem_obj)
+void drm_gem_cma_object_deinit(struct drm_gem_object *gem_obj)
 {
-	struct drm_gem_cma_object *cma_obj;
+	struct drm_gem_cma_object *cma_obj = to_drm_gem_cma_obj(gem_obj);
 
 	if (gem_obj->map_list.map)
 		drm_gem_free_mmap_offset(gem_obj);
 
 	drm_gem_object_release(gem_obj);
-
-	cma_obj = to_drm_gem_cma_obj(gem_obj);
-
 	drm_gem_cma_buf_destroy(gem_obj->dev, cma_obj);
+}
+EXPORT_SYMBOL_GPL(drm_gem_cma_object_deinit);
 
+/*
+ * drm_gem_cma_free_object - (struct drm_driver)->gem_free_object callback
+ * function
+ */
+void drm_gem_cma_free_object(struct drm_gem_object *gem_obj)
+{
+	struct drm_gem_cma_object *cma_obj = to_drm_gem_cma_obj(gem_obj);
+	drm_gem_cma_object_deinit(gem_obj);
 	kfree(cma_obj);
 }
 EXPORT_SYMBOL_GPL(drm_gem_cma_free_object);
diff --git a/include/drm/drm_gem_cma_helper.h b/include/drm/drm_gem_cma_helper.h
index 63397ce..5fdccb3 100644
--- a/include/drm/drm_gem_cma_helper.h
+++ b/include/drm/drm_gem_cma_helper.h
@@ -13,6 +13,10 @@ to_drm_gem_cma_obj(struct drm_gem_object *gem_obj)
 	return container_of(gem_obj, struct drm_gem_cma_object, base);
 }
 
+/* deinitialize gem object and release the buffer. this variant does not
+ * release the cma object memory */
+void drm_gem_cma_object_deinit(struct drm_gem_object *gem_obj);
+
 /* free gem object. */
 void drm_gem_cma_free_object(struct drm_gem_object *gem_obj);
 
@@ -35,6 +39,11 @@ int drm_gem_cma_mmap(struct file *filp, struct vm_area_struct *vma);
 int drm_gem_cma_dumb_destroy(struct drm_file *file_priv,
 		struct drm_device *drm, unsigned int handle);
 
+/* allocate physical memory for a buffer and initialize already allocated
+ * to use the buffer */
+int drm_gem_cma_object_init(struct drm_device *drm,
+		struct drm_gem_cma_object *cma_obj, unsigned int size);
+
 /* allocate physical memory. */
 struct drm_gem_cma_object *drm_gem_cma_create(struct drm_device *drm,
 		unsigned int size);
-- 
1.7.9.5

