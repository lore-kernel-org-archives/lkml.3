Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3JBLZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:25:30 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:55383 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3JBLZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:25:07 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 2/2] DRM: use anon_inode instead of delayed inode init
Date: Wed,  2 Oct 2013 13:24:26 +0200
Message-Id: <1380713066-32519-2-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380713066-32519-1-git-send-email-dh.herrmann@gmail.com>
References: <1380713066-32519-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of delaying inode initialization until first ->open(), we can use
an anonymous inode. This avoids modifying FS internal inode fields and
provides us a private address_space right during initialization.

Delayed TTM dev_mapping initialization is currently left untouched to keep
this simple. But we could now safely provide the address_space during
ttm_bo_device_init() instead of delaying until first buffer ->mmap().

Note that this also fixes several bugs:
 - We currently call iput(container_of(..dev_mapping..)) before
   drm_lastclose(), but we reset dev_mapping to zero at the end of
   drm_lastclose(). This fails if dev_mapping points to an address_space
   other than the current inode and the char-dev got already removed.
 - We also drop dev_mapping during any drm_lastclose() call. So if
   user-space still has VMAs to our buffers, we will be unable to unmap
   them if the next ->firstopen() is on another inode. dev_mapping will
   then point to a new address_space and we leak mappings that we no
   longer control.
 - We ignore inode->i_mapping completely. It is unlikely that a FS uses it
   to overwrite inode->i_data for char-devs, but it definitely doesn't
   look very nice to ignore it silently.

Tested with nouveau on x86_64.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/ast/ast_ttm.c          |  2 +-
 drivers/gpu/drm/cirrus/cirrus_ttm.c    |  2 +-
 drivers/gpu/drm/drm_drv.c              |  1 -
 drivers/gpu/drm/drm_fops.c             | 24 +++---------------------
 drivers/gpu/drm/drm_stub.c             | 12 +++++++++++-
 drivers/gpu/drm/i915/i915_gem.c        |  3 ++-
 drivers/gpu/drm/mgag200/mgag200_ttm.c  |  2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c  |  2 +-
 drivers/gpu/drm/omapdrm/omap_gem.c     |  7 ++++---
 drivers/gpu/drm/qxl/qxl_object.c       |  2 +-
 drivers/gpu/drm/qxl/qxl_ttm.c          |  2 +-
 drivers/gpu/drm/radeon/radeon_object.c |  2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c    |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c    |  2 +-
 include/drm/drmP.h                     |  2 +-
 15 files changed, 30 insertions(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_ttm.c b/drivers/gpu/drm/ast/ast_ttm.c
index 32aecb3..74eed74 100644
--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -324,7 +324,7 @@ int ast_bo_create(struct drm_device *dev, int size, int align,
 	}
 
 	astbo->bo.bdev = &ast->ttm.bdev;
-	astbo->bo.bdev->dev_mapping = dev->dev_mapping;
+	astbo->bo.bdev->dev_mapping = dev->anon_inode->i_mapping;
 
 	ast_ttm_placement(astbo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
diff --git a/drivers/gpu/drm/cirrus/cirrus_ttm.c b/drivers/gpu/drm/cirrus/cirrus_ttm.c
index 75becde..abd401d 100644
--- a/drivers/gpu/drm/cirrus/cirrus_ttm.c
+++ b/drivers/gpu/drm/cirrus/cirrus_ttm.c
@@ -329,7 +329,7 @@ int cirrus_bo_create(struct drm_device *dev, int size, int align,
 	}
 
 	cirrusbo->bo.bdev = &cirrus->ttm.bdev;
-	cirrusbo->bo.bdev->dev_mapping = dev->dev_mapping;
+	cirrusbo->bo.bdev->dev_mapping = dev->anon_inode->i_mapping;
 
 	cirrus_ttm_placement(cirrusbo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index e572dd2..7d91ddb 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -231,7 +231,6 @@ int drm_lastclose(struct drm_device * dev)
 
 	drm_legacy_dma_takedown(dev);
 
-	dev->dev_mapping = NULL;
 	mutex_unlock(&dev->struct_mutex);
 
 	drm_legacy_dev_reinit(dev);
diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 3f84277..41a57c8 100644
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
+	/* set address_space for shared mappings */
+	filp->f_mapping = dev->anon_inode->i_mapping;
 
 	retcode = drm_open_helper(inode, filp, dev);
 	if (retcode)
@@ -122,12 +113,6 @@ int drm_open(struct inode *inode, struct file *filp)
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
@@ -492,9 +477,6 @@ int drm_release(struct inode *inode, struct file *filp)
 		}
 	}
 
-	BUG_ON(dev->dev_mapping == NULL);
-	iput(container_of(dev->dev_mapping, struct inode, i_data));
-
 	/* drop the reference held my the file priv */
 	if (file_priv->master)
 		drm_master_put(&file_priv->master);
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 39d8645..0d9efa2 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -31,6 +31,7 @@
  * DEALINGS IN THE SOFTWARE.
  */
 
+#include <linux/anon_inodes.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
@@ -271,8 +272,14 @@ int drm_fill_in_dev(struct drm_device *dev,
 	mutex_init(&dev->struct_mutex);
 	mutex_init(&dev->ctxlist_mutex);
 
+	/* create private address_space on anon inode */
+	dev->anon_inode = anon_inode_new();
+	if (IS_ERR(dev->anon_inode))
+		return PTR_ERR(dev->anon_inode);
+
 	if (drm_ht_create(&dev->map_hash, 12)) {
-		return -ENOMEM;
+		retcode = -ENOMEM;
+		goto err_inode;
 	}
 
 	/* the DRM has 6 basic counters */
@@ -313,6 +320,8 @@ int drm_fill_in_dev(struct drm_device *dev,
 
       error_out_unreg:
 	drm_lastclose(dev);
+err_inode:
+	iput(dev->anon_inode);
 	return retcode;
 }
 EXPORT_SYMBOL(drm_fill_in_dev);
@@ -465,6 +474,7 @@ void drm_put_dev(struct drm_device *dev)
 
 	drm_put_minor(&dev->primary);
 
+	iput(dev->anon_inode);
 	list_del(&dev->driver_item);
 	kfree(dev->devname);
 	kfree(dev);
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 36c4ad9..fc571cc 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1435,7 +1435,8 @@ i915_gem_release_mmap(struct drm_i915_gem_object *obj)
 	if (!obj->fault_mappable)
 		return;
 
-	drm_vma_node_unmap(&obj->base.vma_node, obj->base.dev->dev_mapping);
+	drm_vma_node_unmap(&obj->base.vma_node,
+			   obj->base.dev->anon_inode->i_mapping);
 	obj->fault_mappable = false;
 }
 
diff --git a/drivers/gpu/drm/mgag200/mgag200_ttm.c b/drivers/gpu/drm/mgag200/mgag200_ttm.c
index 07b192f..bb2a1cb 100644
--- a/drivers/gpu/drm/mgag200/mgag200_ttm.c
+++ b/drivers/gpu/drm/mgag200/mgag200_ttm.c
@@ -324,7 +324,7 @@ int mgag200_bo_create(struct drm_device *dev, int size, int align,
 	}
 
 	mgabo->bo.bdev = &mdev->ttm.bdev;
-	mgabo->bo.bdev->dev_mapping = dev->dev_mapping;
+	mgabo->bo.bdev->dev_mapping = dev->anon_inode->i_mapping;
 
 	mgag200_ttm_placement(mgabo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index f32b712..4572758 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -237,7 +237,7 @@ nouveau_gem_ioctl_new(struct drm_device *dev, void *data,
 	struct nouveau_bo *nvbo = NULL;
 	int ret = 0;
 
-	drm->ttm.bdev.dev_mapping = drm->dev->dev_mapping;
+	drm->ttm.bdev.dev_mapping = drm->dev->anon_inode->i_mapping;
 
 	if (!pfb->memtype_valid(pfb, req->info.tile_flags)) {
 		NV_ERROR(cli, "bad page flags: 0x%08x\n", req->info.tile_flags);
diff --git a/drivers/gpu/drm/omapdrm/omap_gem.c b/drivers/gpu/drm/omapdrm/omap_gem.c
index 533f6eb..7115c23 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -153,7 +153,7 @@ static struct {
 static void evict_entry(struct drm_gem_object *obj,
 		enum tiler_fmt fmt, struct usergart_entry *entry)
 {
-	if (obj->dev->dev_mapping) {
+	if (obj->dev->anon_inode->i_mapping) {
 		struct omap_gem_object *omap_obj = to_omap_bo(obj);
 		int n = usergart[fmt].height;
 		size_t size = PAGE_SIZE * n;
@@ -164,12 +164,13 @@ static void evict_entry(struct drm_gem_object *obj,
 			int i;
 			/* if stride > than PAGE_SIZE then sparse mapping: */
 			for (i = n; i > 0; i--) {
-				unmap_mapping_range(obj->dev->dev_mapping,
+				unmap_mapping_range(obj->dev->anon_inode->i_mapping,
 						off, PAGE_SIZE, 1);
 				off += PAGE_SIZE * m;
 			}
 		} else {
-			unmap_mapping_range(obj->dev->dev_mapping, off, size, 1);
+			unmap_mapping_range(obj->dev->anon_inode->i_mapping,
+					    off, size, 1);
 		}
 	}
 
diff --git a/drivers/gpu/drm/qxl/qxl_object.c b/drivers/gpu/drm/qxl/qxl_object.c
index 8691c76..f3204c9 100644
--- a/drivers/gpu/drm/qxl/qxl_object.c
+++ b/drivers/gpu/drm/qxl/qxl_object.c
@@ -83,7 +83,7 @@ int qxl_bo_create(struct qxl_device *qdev,
 	int r;
 
 	if (unlikely(qdev->mman.bdev.dev_mapping == NULL))
-		qdev->mman.bdev.dev_mapping = qdev->ddev->dev_mapping;
+		qdev->mman.bdev.dev_mapping = qdev->ddev->anon_inode->i_mapping;
 	if (kernel)
 		type = ttm_bo_type_kernel;
 	else
diff --git a/drivers/gpu/drm/qxl/qxl_ttm.c b/drivers/gpu/drm/qxl/qxl_ttm.c
index 037786d..7d7ff7a 100644
--- a/drivers/gpu/drm/qxl/qxl_ttm.c
+++ b/drivers/gpu/drm/qxl/qxl_ttm.c
@@ -517,7 +517,7 @@ int qxl_ttm_init(struct qxl_device *qdev)
 	DRM_INFO("qxl: %luM of IO pages memory ready (VRAM domain)\n",
 		 ((unsigned)num_io_pages * PAGE_SIZE) / (1024 * 1024));
 	if (unlikely(qdev->mman.bdev.dev_mapping == NULL))
-		qdev->mman.bdev.dev_mapping = qdev->ddev->dev_mapping;
+		qdev->mman.bdev.dev_mapping = qdev->ddev->anon_inode->i_mapping;
 	r = qxl_ttm_debugfs_init(qdev);
 	if (r) {
 		DRM_ERROR("Failed to init debugfs\n");
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index c0fa4aa..0900b36 100644
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
index 71245d6..ab1b8ff 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -737,7 +737,7 @@ int radeon_ttm_init(struct radeon_device *rdev)
 	}
 	DRM_INFO("radeon: %uM of GTT memory ready.\n",
 		 (unsigned)(rdev->mc.gtt_size / (1024 * 1024)));
-	rdev->mman.bdev.dev_mapping = rdev->ddev->dev_mapping;
+	rdev->mman.bdev.dev_mapping = rdev->ddev->anon_inode->i_mapping;
 
 	r = radeon_ttm_debugfs_init(rdev);
 	if (r) {
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 1a90f0a..d5a20c4 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -762,7 +762,7 @@ static int vmw_driver_open(struct drm_device *dev, struct drm_file *file_priv)
 		goto out_no_tfile;
 
 	file_priv->driver_priv = vmw_fp;
-	dev_priv->bdev.dev_mapping = dev->dev_mapping;
+	dev_priv->bdev.dev_mapping = dev->anon_inode->i_mapping;
 
 	return 0;
 
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index b46fb45..073772a 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1197,7 +1197,7 @@ struct drm_device {
 	unsigned int num_crtcs;                  /**< Number of CRTCs on this device */
 	void *dev_private;		/**< device private data */
 	void *mm_private;
-	struct address_space *dev_mapping;
+	struct inode *anon_inode;
 	struct drm_sigdata sigdata;	   /**< For block_all_signals */
 	sigset_t sigmask;
 
-- 
1.8.4

