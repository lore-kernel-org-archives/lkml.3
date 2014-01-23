Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaAWMjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 07:39:09 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:52938 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaAWMjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 07:39:06 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v3 2/3] drm: use anon-inode instead of relying on cdevs
Date: Thu, 23 Jan 2014 13:38:38 +0100
Message-Id: <1390480719-434-2-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390480719-434-1-git-send-email-dh.herrmann@gmail.com>
References: <1390480719-434-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRM drivers share a common address_space across all character-devices of a
single DRM device. This allows simple buffer eviction and mapping-control.
However, DRM core currently waits for the first ->open() on any char-dev
to mark the underlying inode as backing inode of the device. This delayed
initialization causes ugly conditions all over the place:
  if (dev->dev_mapping)
    do_sth();

To avoid delayed initialization and to stop reusing the inode of the
char-dev, we allocate an anonymous inode for each DRM device and reset
filp->f_mapping to it on ->open().

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/ast/ast_ttm.c          |  2 +-
 drivers/gpu/drm/cirrus/cirrus_ttm.c    |  2 +-
 drivers/gpu/drm/drm_fops.c             | 25 +++----------------------
 drivers/gpu/drm/drm_stub.c             | 12 +++++++++++-
 drivers/gpu/drm/i915/i915_gem.c        |  3 ++-
 drivers/gpu/drm/mgag200/mgag200_ttm.c  |  2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c  |  2 +-
 drivers/gpu/drm/omapdrm/omap_gem.c     | 34 +++++++++++++++++-----------------
 drivers/gpu/drm/qxl/qxl_object.c       |  3 +--
 drivers/gpu/drm/qxl/qxl_ttm.c          |  3 +--
 drivers/gpu/drm/radeon/radeon_object.c |  2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c    |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c    |  2 +-
 include/drm/drmP.h                     |  2 +-
 14 files changed, 43 insertions(+), 53 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_ttm.c b/drivers/gpu/drm/ast/ast_ttm.c
index 4ea9b17..2b49153 100644
--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -324,7 +324,7 @@ int ast_bo_create(struct drm_device *dev, int size, int align,
 	}
 
 	astbo->bo.bdev = &ast->ttm.bdev;
-	astbo->bo.bdev->dev_mapping = dev->dev_mapping;
+	astbo->bo.bdev->dev_mapping = dev->anon_inode->i_mapping;
 
 	ast_ttm_placement(astbo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
diff --git a/drivers/gpu/drm/cirrus/cirrus_ttm.c b/drivers/gpu/drm/cirrus/cirrus_ttm.c
index 8b37c25..efcbd70 100644
--- a/drivers/gpu/drm/cirrus/cirrus_ttm.c
+++ b/drivers/gpu/drm/cirrus/cirrus_ttm.c
@@ -329,7 +329,7 @@ int cirrus_bo_create(struct drm_device *dev, int size, int align,
 	}
 
 	cirrusbo->bo.bdev = &cirrus->ttm.bdev;
-	cirrusbo->bo.bdev->dev_mapping = dev->dev_mapping;
+	cirrusbo->bo.bdev->dev_mapping = dev->anon_inode->i_mapping;
 
 	cirrus_ttm_placement(cirrusbo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 7f2af9a..147a84d 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -84,8 +84,6 @@ int drm_open(struct inode *inode, struct file *filp)
 	struct drm_minor *minor;
 	int retcode = 0;
 	int need_setup = 0;
-	struct address_space *old_mapping;
-	struct address_space *old_imapping;
 
 	minor = idr_find(&drm_minors_idr, minor_id);
 	if (!minor)
@@ -99,16 +97,9 @@ int drm_open(struct inode *inode, struct file *filp)
 
 	if (!dev->open_count++)
 		need_setup = 1;
-	mutex_lock(&dev->struct_mutex);
-	old_imapping = inode->i_mapping;
-	old_mapping = dev->dev_mapping;
-	if (old_mapping == NULL)
-		dev->dev_mapping = &inode->i_data;
-	/* ihold ensures nobody can remove inode with our i_data */
-	ihold(container_of(dev->dev_mapping, struct inode, i_data));
-	inode->i_mapping = dev->dev_mapping;
-	filp->f_mapping = dev->dev_mapping;
-	mutex_unlock(&dev->struct_mutex);
+
+	/* share address_space across all char-devs of a single device */
+	filp->f_mapping = dev->anon_inode->i_mapping;
 
 	retcode = drm_open_helper(inode, filp, dev);
 	if (retcode)
@@ -121,12 +112,6 @@ int drm_open(struct inode *inode, struct file *filp)
 	return 0;
 
 err_undo:
-	mutex_lock(&dev->struct_mutex);
-	filp->f_mapping = old_imapping;
-	inode->i_mapping = old_imapping;
-	iput(container_of(dev->dev_mapping, struct inode, i_data));
-	dev->dev_mapping = old_mapping;
-	mutex_unlock(&dev->struct_mutex);
 	dev->open_count--;
 	return retcode;
 }
@@ -434,7 +419,6 @@ int drm_lastclose(struct drm_device * dev)
 
 	drm_legacy_dma_takedown(dev);
 
-	dev->dev_mapping = NULL;
 	mutex_unlock(&dev->struct_mutex);
 
 	drm_legacy_dev_reinit(dev);
@@ -549,9 +533,6 @@ int drm_release(struct inode *inode, struct file *filp)
 		}
 	}
 
-	BUG_ON(dev->dev_mapping == NULL);
-	iput(container_of(dev->dev_mapping, struct inode, i_data));
-
 	/* drop the reference held my the file priv */
 	if (file_priv->master)
 		drm_master_put(&file_priv->master);
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index f2903d7..04c25ce 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -526,8 +526,15 @@ struct drm_device *drm_dev_alloc(struct drm_driver *driver,
 	mutex_init(&dev->struct_mutex);
 	mutex_init(&dev->ctxlist_mutex);
 
-	if (drm_ht_create(&dev->map_hash, 12))
+	dev->anon_inode = drm_fs_inode_new();
+	if (IS_ERR(dev->anon_inode)) {
+		ret = PTR_ERR(dev->anon_inode);
+		DRM_ERROR("Cannot allocate anonymous inode: %d\n", ret);
 		goto err_free;
+	}
+
+	if (drm_ht_create(&dev->map_hash, 12))
+		goto err_inode;
 
 	ret = drm_ctxbitmap_init(dev);
 	if (ret) {
@@ -549,6 +556,8 @@ err_ctxbitmap:
 	drm_ctxbitmap_cleanup(dev);
 err_ht:
 	drm_ht_remove(&dev->map_hash);
+err_inode:
+	drm_fs_inode_free(dev->anon_inode);
 err_free:
 	kfree(dev);
 	return NULL;
@@ -576,6 +585,7 @@ void drm_dev_free(struct drm_device *dev)
 
 	drm_ctxbitmap_cleanup(dev);
 	drm_ht_remove(&dev->map_hash);
+	drm_fs_inode_free(dev->anon_inode);
 
 	kfree(dev->devname);
 	kfree(dev);
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 32636a4..365e248 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1501,7 +1501,8 @@ i915_gem_release_mmap(struct drm_i915_gem_object *obj)
 	if (!obj->fault_mappable)
 		return;
 
-	drm_vma_node_unmap(&obj->base.vma_node, obj->base.dev->dev_mapping);
+	drm_vma_node_unmap(&obj->base.vma_node,
+			   obj->base.dev->anon_inode->i_mapping);
 	obj->fault_mappable = false;
 }
 
diff --git a/drivers/gpu/drm/mgag200/mgag200_ttm.c b/drivers/gpu/drm/mgag200/mgag200_ttm.c
index adb5166..c1c2cb6 100644
--- a/drivers/gpu/drm/mgag200/mgag200_ttm.c
+++ b/drivers/gpu/drm/mgag200/mgag200_ttm.c
@@ -324,7 +324,7 @@ int mgag200_bo_create(struct drm_device *dev, int size, int align,
 	}
 
 	mgabo->bo.bdev = &mdev->ttm.bdev;
-	mgabo->bo.bdev->dev_mapping = dev->dev_mapping;
+	mgabo->bo.bdev->dev_mapping = dev->anon_inode->i_mapping;
 
 	mgag200_ttm_placement(mgabo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 27c3fd8..5b193b8 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -228,7 +228,7 @@ nouveau_gem_ioctl_new(struct drm_device *dev, void *data,
 	struct nouveau_bo *nvbo = NULL;
 	int ret = 0;
 
-	drm->ttm.bdev.dev_mapping = drm->dev->dev_mapping;
+	drm->ttm.bdev.dev_mapping = drm->dev->anon_inode->i_mapping;
 
 	if (!pfb->memtype_valid(pfb, req->info.tile_flags)) {
 		NV_ERROR(cli, "bad page flags: 0x%08x\n", req->info.tile_flags);
diff --git a/drivers/gpu/drm/omapdrm/omap_gem.c b/drivers/gpu/drm/omapdrm/omap_gem.c
index 5aec3e8..c8d9727 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -153,24 +153,24 @@ static struct {
 static void evict_entry(struct drm_gem_object *obj,
 		enum tiler_fmt fmt, struct usergart_entry *entry)
 {
-	if (obj->dev->dev_mapping) {
-		struct omap_gem_object *omap_obj = to_omap_bo(obj);
-		int n = usergart[fmt].height;
-		size_t size = PAGE_SIZE * n;
-		loff_t off = mmap_offset(obj) +
-				(entry->obj_pgoff << PAGE_SHIFT);
-		const int m = 1 + ((omap_obj->width << fmt) / PAGE_SIZE);
-		if (m > 1) {
-			int i;
-			/* if stride > than PAGE_SIZE then sparse mapping: */
-			for (i = n; i > 0; i--) {
-				unmap_mapping_range(obj->dev->dev_mapping,
-						off, PAGE_SIZE, 1);
-				off += PAGE_SIZE * m;
-			}
-		} else {
-			unmap_mapping_range(obj->dev->dev_mapping, off, size, 1);
+	struct omap_gem_object *omap_obj = to_omap_bo(obj);
+	int n = usergart[fmt].height;
+	size_t size = PAGE_SIZE * n;
+	loff_t off = mmap_offset(obj) +
+			(entry->obj_pgoff << PAGE_SHIFT);
+	const int m = 1 + ((omap_obj->width << fmt) / PAGE_SIZE);
+
+	if (m > 1) {
+		int i;
+		/* if stride > than PAGE_SIZE then sparse mapping: */
+		for (i = n; i > 0; i--) {
+			unmap_mapping_range(obj->dev->anon_inode->i_mapping,
+					    off, PAGE_SIZE, 1);
+			off += PAGE_SIZE * m;
 		}
+	} else {
+		unmap_mapping_range(obj->dev->anon_inode->i_mapping,
+				    off, size, 1);
 	}
 
 	entry->obj = NULL;
diff --git a/drivers/gpu/drm/qxl/qxl_object.c b/drivers/gpu/drm/qxl/qxl_object.c
index 8691c76..7e20c21 100644
--- a/drivers/gpu/drm/qxl/qxl_object.c
+++ b/drivers/gpu/drm/qxl/qxl_object.c
@@ -82,8 +82,7 @@ int qxl_bo_create(struct qxl_device *qdev,
 	enum ttm_bo_type type;
 	int r;
 
-	if (unlikely(qdev->mman.bdev.dev_mapping == NULL))
-		qdev->mman.bdev.dev_mapping = qdev->ddev->dev_mapping;
+	qdev->mman.bdev.dev_mapping = qdev->ddev->anon_inode->i_mapping;
 	if (kernel)
 		type = ttm_bo_type_kernel;
 	else
diff --git a/drivers/gpu/drm/qxl/qxl_ttm.c b/drivers/gpu/drm/qxl/qxl_ttm.c
index c7e7e65..78cbc40 100644
--- a/drivers/gpu/drm/qxl/qxl_ttm.c
+++ b/drivers/gpu/drm/qxl/qxl_ttm.c
@@ -518,8 +518,7 @@ int qxl_ttm_init(struct qxl_device *qdev)
 		 ((unsigned)num_io_pages * PAGE_SIZE) / (1024 * 1024));
 	DRM_INFO("qxl: %uM of Surface memory size\n",
 		 (unsigned)qdev->surfaceram_size / (1024 * 1024));
-	if (unlikely(qdev->mman.bdev.dev_mapping == NULL))
-		qdev->mman.bdev.dev_mapping = qdev->ddev->dev_mapping;
+	qdev->mman.bdev.dev_mapping = qdev->ddev->anon_inode->i_mapping;
 	r = qxl_ttm_debugfs_init(qdev);
 	if (r) {
 		DRM_ERROR("Failed to init debugfs\n");
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index 08595cf..92406ce 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -120,7 +120,7 @@ int radeon_bo_create(struct radeon_device *rdev,
 
 	size = ALIGN(size, PAGE_SIZE);
 
-	rdev->mman.bdev.dev_mapping = rdev->ddev->dev_mapping;
+	rdev->mman.bdev.dev_mapping = rdev->ddev->anon_inode->i_mapping;
 	if (kernel) {
 		type = ttm_bo_type_kernel;
 	} else if (sg) {
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 77f5b0c..9409575 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -739,7 +739,7 @@ int radeon_ttm_init(struct radeon_device *rdev)
 	}
 	DRM_INFO("radeon: %uM of GTT memory ready.\n",
 		 (unsigned)(rdev->mc.gtt_size / (1024 * 1024)));
-	rdev->mman.bdev.dev_mapping = rdev->ddev->dev_mapping;
+	rdev->mman.bdev.dev_mapping = rdev->ddev->anon_inode->i_mapping;
 
 	r = radeon_ttm_debugfs_init(rdev);
 	if (r) {
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 9893328..417d542 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -961,7 +961,7 @@ static int vmw_driver_open(struct drm_device *dev, struct drm_file *file_priv)
 		goto out_no_tfile;
 
 	file_priv->driver_priv = vmw_fp;
-	dev_priv->bdev.dev_mapping = dev->dev_mapping;
+	dev_priv->bdev.dev_mapping = dev->anon_inode->i_mapping;
 
 	return 0;
 
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 04086c5..1aa312a 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1180,7 +1180,7 @@ struct drm_device {
 	struct drm_sg_mem *sg;	/**< Scatter gather memory */
 	unsigned int num_crtcs;                  /**< Number of CRTCs on this device */
 	void *dev_private;		/**< device private data */
-	struct address_space *dev_mapping;
+	struct inode *anon_inode;
 	struct drm_sigdata sigdata;	   /**< For block_all_signals */
 	sigset_t sigmask;
 
-- 
1.8.5.3

