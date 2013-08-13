Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab3HMRnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:43:22 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:52414 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225Ab3HMRnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:43:18 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH v2 3/4] drm: init TTM dev_mapping in ttm_bo_device_init()
Date: Tue, 13 Aug 2013 19:42:18 +0200
Message-Id: <1376415739-11685-4-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1376415739-11685-1-git-send-email-dh.herrmann@gmail.com>
References: <1373499930-5055-1-git-send-email-dh.herrmann@gmail.com>
 <1376415739-11685-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With dev->anon_inode we have a global address_space ready for operation
right from the beginning. Therefore, there is no need to do a delayed
setup with TTM. Instead, set dev_mapping during initialization in
ttm_bo_device_init() and remove any if (dev_mapping) conditions.

Cc: Dave Airlie <airlied@redhat.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Alex Deucher <alexdeucher@gmail.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/ast/ast_ttm.c          | 4 +++-
 drivers/gpu/drm/cirrus/cirrus_ttm.c    | 4 +++-
 drivers/gpu/drm/mgag200/mgag200_ttm.c  | 4 +++-
 drivers/gpu/drm/nouveau/nouveau_gem.c  | 2 --
 drivers/gpu/drm/nouveau/nouveau_ttm.c  | 4 +++-
 drivers/gpu/drm/qxl/qxl_object.c       | 2 --
 drivers/gpu/drm/qxl/qxl_ttm.c          | 6 +++---
 drivers/gpu/drm/radeon/radeon_object.c | 1 -
 drivers/gpu/drm/radeon/radeon_ttm.c    | 5 +++--
 drivers/gpu/drm/ttm/ttm_bo.c           | 3 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c    | 5 +++--
 include/drm/drm_vma_manager.h          | 6 +++---
 include/drm/ttm/ttm_bo_driver.h        | 2 ++
 13 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_ttm.c b/drivers/gpu/drm/ast/ast_ttm.c
index 98d6708..2ba6a53 100644
--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -257,7 +257,9 @@ int ast_mm_init(struct ast_private *ast)
 
 	ret = ttm_bo_device_init(&ast->ttm.bdev,
 				 ast->ttm.bo_global_ref.ref.object,
-				 &ast_bo_driver, DRM_FILE_PAGE_OFFSET,
+				 &ast_bo_driver,
+				 dev->anon_inode->i_mapping,
+				 DRM_FILE_PAGE_OFFSET,
 				 true);
 	if (ret) {
 		DRM_ERROR("Error initialising bo driver; %d\n", ret);
diff --git a/drivers/gpu/drm/cirrus/cirrus_ttm.c b/drivers/gpu/drm/cirrus/cirrus_ttm.c
index 0047012..9acfc77 100644
--- a/drivers/gpu/drm/cirrus/cirrus_ttm.c
+++ b/drivers/gpu/drm/cirrus/cirrus_ttm.c
@@ -257,7 +257,9 @@ int cirrus_mm_init(struct cirrus_device *cirrus)
 
 	ret = ttm_bo_device_init(&cirrus->ttm.bdev,
 				 cirrus->ttm.bo_global_ref.ref.object,
-				 &cirrus_bo_driver, DRM_FILE_PAGE_OFFSET,
+				 &cirrus_bo_driver,
+				 dev->anon_inode->i_mapping,
+				 DRM_FILE_PAGE_OFFSET,
 				 true);
 	if (ret) {
 		DRM_ERROR("Error initialising bo driver; %d\n", ret);
diff --git a/drivers/gpu/drm/mgag200/mgag200_ttm.c b/drivers/gpu/drm/mgag200/mgag200_ttm.c
index 3acb2b0..90a5833 100644
--- a/drivers/gpu/drm/mgag200/mgag200_ttm.c
+++ b/drivers/gpu/drm/mgag200/mgag200_ttm.c
@@ -257,7 +257,9 @@ int mgag200_mm_init(struct mga_device *mdev)
 
 	ret = ttm_bo_device_init(&mdev->ttm.bdev,
 				 mdev->ttm.bo_global_ref.ref.object,
-				 &mgag200_bo_driver, DRM_FILE_PAGE_OFFSET,
+				 &mgag200_bo_driver,
+				 dev->anon_inode->i_mapping,
+				 DRM_FILE_PAGE_OFFSET,
 				 true);
 	if (ret) {
 		DRM_ERROR("Error initialising bo driver; %d\n", ret);
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 220c406..605099f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -237,8 +237,6 @@ nouveau_gem_ioctl_new(struct drm_device *dev, void *data,
 	struct nouveau_bo *nvbo = NULL;
 	int ret = 0;
 
-	drm->ttm.bdev.dev_mapping = drm->dev->anon_inode->i_mapping;
-
 	if (!pfb->memtype_valid(pfb, req->info.tile_flags)) {
 		NV_ERROR(cli, "bad page flags: 0x%08x\n", req->info.tile_flags);
 		return -EINVAL;
diff --git a/drivers/gpu/drm/nouveau/nouveau_ttm.c b/drivers/gpu/drm/nouveau/nouveau_ttm.c
index 19e3757..d486f25 100644
--- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
@@ -375,7 +375,9 @@ nouveau_ttm_init(struct nouveau_drm *drm)
 
 	ret = ttm_bo_device_init(&drm->ttm.bdev,
 				  drm->ttm.bo_global_ref.ref.object,
-				  &nouveau_bo_driver, DRM_FILE_PAGE_OFFSET,
+				  &nouveau_bo_driver,
+				  dev->anon_inode->i_mapping,
+				  DRM_FILE_PAGE_OFFSET,
 				  bits <= 32 ? true : false);
 	if (ret) {
 		NV_ERROR(drm, "error initialising bo driver, %d\n", ret);
diff --git a/drivers/gpu/drm/qxl/qxl_object.c b/drivers/gpu/drm/qxl/qxl_object.c
index df2f03a..e9b4af8 100644
--- a/drivers/gpu/drm/qxl/qxl_object.c
+++ b/drivers/gpu/drm/qxl/qxl_object.c
@@ -81,8 +81,6 @@ int qxl_bo_create(struct qxl_device *qdev,
 	enum ttm_bo_type type;
 	int r;
 
-	if (unlikely(qdev->mman.bdev.dev_mapping == NULL))
-		qdev->mman.bdev.dev_mapping = qdev->ddev->anon_inode->i_mapping;
 	if (kernel)
 		type = ttm_bo_type_kernel;
 	else
diff --git a/drivers/gpu/drm/qxl/qxl_ttm.c b/drivers/gpu/drm/qxl/qxl_ttm.c
index 0f62d35..1a69a33 100644
--- a/drivers/gpu/drm/qxl/qxl_ttm.c
+++ b/drivers/gpu/drm/qxl/qxl_ttm.c
@@ -491,7 +491,9 @@ int qxl_ttm_init(struct qxl_device *qdev)
 	/* No others user of address space so set it to 0 */
 	r = ttm_bo_device_init(&qdev->mman.bdev,
 			       qdev->mman.bo_global_ref.ref.object,
-			       &qxl_bo_driver, DRM_FILE_PAGE_OFFSET, 0);
+			       &qxl_bo_driver,
+			       qdev->ddev->anon_inode->i_mapping,
+			       DRM_FILE_PAGE_OFFSET, 0);
 	if (r) {
 		DRM_ERROR("failed initializing buffer object driver(%d).\n", r);
 		return r;
@@ -514,8 +516,6 @@ int qxl_ttm_init(struct qxl_device *qdev)
 		 (unsigned)qdev->vram_size / (1024 * 1024));
 	DRM_INFO("qxl: %luM of IO pages memory ready (VRAM domain)\n",
 		 ((unsigned)num_io_pages * PAGE_SIZE) / (1024 * 1024));
-	if (unlikely(qdev->mman.bdev.dev_mapping == NULL))
-		qdev->mman.bdev.dev_mapping = qdev->ddev->anon_inode->i_mapping;
 	r = qxl_ttm_debugfs_init(qdev);
 	if (r) {
 		DRM_ERROR("Failed to init debugfs\n");
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index d535092..d96b47b 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -120,7 +120,6 @@ int radeon_bo_create(struct radeon_device *rdev,
 
 	size = ALIGN(size, PAGE_SIZE);
 
-	rdev->mman.bdev.dev_mapping = rdev->ddev->anon_inode->i_mapping;
 	if (kernel) {
 		type = ttm_bo_type_kernel;
 	} else if (sg) {
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 6071ecb..200cb54 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -697,7 +697,9 @@ int radeon_ttm_init(struct radeon_device *rdev)
 	/* No others user of address space so set it to 0 */
 	r = ttm_bo_device_init(&rdev->mman.bdev,
 			       rdev->mman.bo_global_ref.ref.object,
-			       &radeon_bo_driver, DRM_FILE_PAGE_OFFSET,
+			       &radeon_bo_driver,
+			       rdev->ddev->anon_inode->i_mapping,
+			       DRM_FILE_PAGE_OFFSET,
 			       rdev->need_dma32);
 	if (r) {
 		DRM_ERROR("failed initializing buffer object driver(%d).\n", r);
@@ -735,7 +737,6 @@ int radeon_ttm_init(struct radeon_device *rdev)
 	}
 	DRM_INFO("radeon: %uM of GTT memory ready.\n",
 		 (unsigned)(rdev->mc.gtt_size / (1024 * 1024)));
-	rdev->mman.bdev.dev_mapping = rdev->ddev->anon_inode->i_mapping;
 
 	r = radeon_ttm_debugfs_init(rdev);
 	if (r) {
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index f1a857e..0652043 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1428,6 +1428,7 @@ EXPORT_SYMBOL(ttm_bo_device_release);
 int ttm_bo_device_init(struct ttm_bo_device *bdev,
 		       struct ttm_bo_global *glob,
 		       struct ttm_bo_driver *driver,
+		       struct address_space *mapping,
 		       uint64_t file_page_offset,
 		       bool need_dma32)
 {
@@ -1449,7 +1450,7 @@ int ttm_bo_device_init(struct ttm_bo_device *bdev,
 				    0x10000000);
 	INIT_DELAYED_WORK(&bdev->wq, ttm_bo_delayed_workqueue);
 	INIT_LIST_HEAD(&bdev->ddestroy);
-	bdev->dev_mapping = NULL;
+	bdev->dev_mapping = mapping;
 	bdev->glob = glob;
 	bdev->need_dma32 = need_dma32;
 	bdev->val_seq = 0;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 375110d..17d1ba2 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -543,7 +543,9 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
 
 	ret = ttm_bo_device_init(&dev_priv->bdev,
 				 dev_priv->bo_global_ref.ref.object,
-				 &vmw_bo_driver, VMWGFX_FILE_PAGE_OFFSET,
+				 &vmw_bo_driver,
+				 dev->anon_inode->i_mapping,
+				 VMWGFX_FILE_PAGE_OFFSET,
 				 false);
 	if (unlikely(ret != 0)) {
 		DRM_ERROR("Failed initializing TTM buffer object driver.\n");
@@ -760,7 +762,6 @@ static int vmw_driver_open(struct drm_device *dev, struct drm_file *file_priv)
 		goto out_no_tfile;
 
 	file_priv->driver_priv = vmw_fp;
-	dev_priv->bdev.dev_mapping = dev->anon_inode->i_mapping;
 
 	return 0;
 
diff --git a/include/drm/drm_vma_manager.h b/include/drm/drm_vma_manager.h
index 22eedac..f0e96cb 100644
--- a/include/drm/drm_vma_manager.h
+++ b/include/drm/drm_vma_manager.h
@@ -206,8 +206,8 @@ static inline __u64 drm_vma_node_offset_addr(struct drm_vma_offset_node *node)
  * @file_mapping: Address space to unmap @node from
  *
  * Unmap all userspace mappings for a given offset node. The mappings must be
- * associated with the @file_mapping address-space. If no offset exists or
- * the address-space is invalid, nothing is done.
+ * associated with the @file_mapping address-space. If no offset exists
+ * nothing is done.
  *
  * This call is unlocked. The caller must guarantee that drm_vma_offset_remove()
  * is not called on this node concurrently.
@@ -215,7 +215,7 @@ static inline __u64 drm_vma_node_offset_addr(struct drm_vma_offset_node *node)
 static inline void drm_vma_node_unmap(struct drm_vma_offset_node *node,
 				      struct address_space *file_mapping)
 {
-	if (file_mapping && drm_vma_node_has_offset(node))
+	if (drm_vma_node_has_offset(node))
 		unmap_mapping_range(file_mapping,
 				    drm_vma_node_offset_addr(node),
 				    drm_vma_node_size(node) << PAGE_SHIFT, 1);
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 8639c85..9261e42 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -738,6 +738,7 @@ extern int ttm_bo_device_release(struct ttm_bo_device *bdev);
  * @bdev: A pointer to a struct ttm_bo_device to initialize.
  * @glob: A pointer to an initialized struct ttm_bo_global.
  * @driver: A pointer to a struct ttm_bo_driver set up by the caller.
+ * @mapping: The address space to use for this bo.
  * @file_page_offset: Offset into the device address space that is available
  * for buffer data. This ensures compatibility with other users of the
  * address space.
@@ -749,6 +750,7 @@ extern int ttm_bo_device_release(struct ttm_bo_device *bdev);
 extern int ttm_bo_device_init(struct ttm_bo_device *bdev,
 			      struct ttm_bo_global *glob,
 			      struct ttm_bo_driver *driver,
+			      struct address_space *mapping,
 			      uint64_t file_page_offset, bool need_dma32);
 
 /**
-- 
1.8.3.4

