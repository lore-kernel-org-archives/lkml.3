Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934488Ab3ECXC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 19:02:28 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:54010 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763818Ab3ECXA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 19:00:57 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/7] drm (ast,cirrus,mgag200,nouveau,savage,vmwgfx): Rework drm_mtrr_{add,del}
Date: Fri,  3 May 2013 16:00:30 -0700
Message-Id: <4615b8566e9530e2169a36a5870f1b2eb7e621cd.1367621039.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1367621038.git.luto@amacapital.net>
References: <cover.1367621038.git.luto@amacapital.net>
In-Reply-To: <cover.1367621038.git.luto@amacapital.net>
References: <cover.1367621038.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces drm_mtrr_{add,del} with drm_mtrr_{add,del}_wc.  The
interface is simplified (because the base and size parameters to
drm_mtrr_del never did anything) and it uses
mtrr_{add,del}_wc_if_needed to avoid allocating MTRRs on systems
that don't need them.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/gpu/drm/ast/ast_ttm.c         | 14 ++++--------
 drivers/gpu/drm/cirrus/cirrus_ttm.c   | 15 ++++---------
 drivers/gpu/drm/mgag200/mgag200_ttm.c | 14 ++++--------
 drivers/gpu/drm/nouveau/nouveau_ttm.c | 13 ++++-------
 drivers/gpu/drm/savage/savage_bci.c   | 42 +++++++++++++----------------------
 drivers/gpu/drm/savage/savage_drv.h   |  5 +----
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c   | 10 ++++-----
 include/drm/drmP.h                    | 23 ++++++++-----------
 8 files changed, 45 insertions(+), 91 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_ttm.c b/drivers/gpu/drm/ast/ast_ttm.c
index 3602731..5286c96 100644
--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -271,26 +271,20 @@ int ast_mm_init(struct ast_private *ast)
 		return ret;
 	}
 
-	ast->fb_mtrr = drm_mtrr_add(pci_resource_start(dev->pdev, 0),
-				    pci_resource_len(dev->pdev, 0),
-				    DRM_MTRR_WC);
+	ast->fb_mtrr = drm_mtrr_add_wc(pci_resource_start(dev->pdev, 0),
+				       pci_resource_len(dev->pdev, 0));
 
 	return 0;
 }
 
 void ast_mm_fini(struct ast_private *ast)
 {
-	struct drm_device *dev = ast->dev;
 	ttm_bo_device_release(&ast->ttm.bdev);
 
 	ast_ttm_global_release(ast);
 
-	if (ast->fb_mtrr >= 0) {
-		drm_mtrr_del(ast->fb_mtrr,
-			     pci_resource_start(dev->pdev, 0),
-			     pci_resource_len(dev->pdev, 0), DRM_MTRR_WC);
-		ast->fb_mtrr = -1;
-	}
+	drm_mtrr_del_wc(ast->fb_mtrr);
+	ast->fb_mtrr = -1;
 }
 
 void ast_ttm_placement(struct ast_bo *bo, int domain)
diff --git a/drivers/gpu/drm/cirrus/cirrus_ttm.c b/drivers/gpu/drm/cirrus/cirrus_ttm.c
index 1413a26..95e87ee 100644
--- a/drivers/gpu/drm/cirrus/cirrus_ttm.c
+++ b/drivers/gpu/drm/cirrus/cirrus_ttm.c
@@ -271,9 +271,8 @@ int cirrus_mm_init(struct cirrus_device *cirrus)
 		return ret;
 	}
 
-	cirrus->fb_mtrr = drm_mtrr_add(pci_resource_start(dev->pdev, 0),
-				    pci_resource_len(dev->pdev, 0),
-				    DRM_MTRR_WC);
+	cirrus->fb_mtrr = drm_mtrr_add_wc(pci_resource_start(dev->pdev, 0),
+					  pci_resource_len(dev->pdev, 0));
 
 	cirrus->mm_inited = true;
 	return 0;
@@ -281,8 +280,6 @@ int cirrus_mm_init(struct cirrus_device *cirrus)
 
 void cirrus_mm_fini(struct cirrus_device *cirrus)
 {
-	struct drm_device *dev = cirrus->dev;
-
 	if (!cirrus->mm_inited)
 		return;
 
@@ -290,12 +287,8 @@ void cirrus_mm_fini(struct cirrus_device *cirrus)
 
 	cirrus_ttm_global_release(cirrus);
 
-	if (cirrus->fb_mtrr >= 0) {
-		drm_mtrr_del(cirrus->fb_mtrr,
-			     pci_resource_start(dev->pdev, 0),
-			     pci_resource_len(dev->pdev, 0), DRM_MTRR_WC);
-		cirrus->fb_mtrr = -1;
-	}
+	drm_mtrr_del_wc(cirrus->fb_mtrr);
+	cirrus->fb_mtrr = -1;
 }
 
 void cirrus_ttm_placement(struct cirrus_bo *bo, int domain)
diff --git a/drivers/gpu/drm/mgag200/mgag200_ttm.c b/drivers/gpu/drm/mgag200/mgag200_ttm.c
index 8fc9d92..62245b4 100644
--- a/drivers/gpu/drm/mgag200/mgag200_ttm.c
+++ b/drivers/gpu/drm/mgag200/mgag200_ttm.c
@@ -270,26 +270,20 @@ int mgag200_mm_init(struct mga_device *mdev)
 		return ret;
 	}
 
-	mdev->fb_mtrr = drm_mtrr_add(pci_resource_start(dev->pdev, 0),
-				    pci_resource_len(dev->pdev, 0),
-				    DRM_MTRR_WC);
+	mdev->fb_mtrr = drm_mtrr_add_wc(pci_resource_start(dev->pdev, 0),
+					pci_resource_len(dev->pdev, 0));
 
 	return 0;
 }
 
 void mgag200_mm_fini(struct mga_device *mdev)
 {
-	struct drm_device *dev = mdev->dev;
 	ttm_bo_device_release(&mdev->ttm.bdev);
 
 	mgag200_ttm_global_release(mdev);
 
-	if (mdev->fb_mtrr >= 0) {
-		drm_mtrr_del(mdev->fb_mtrr,
-			     pci_resource_start(dev->pdev, 0),
-			     pci_resource_len(dev->pdev, 0), DRM_MTRR_WC);
-		mdev->fb_mtrr = -1;
-	}
+	drm_mtrr_del_wc(mdev->fb_mtrr);
+	mdev->fb_mtrr = -1;
 }
 
 void mgag200_ttm_placement(struct mgag200_bo *bo, int domain)
diff --git a/drivers/gpu/drm/nouveau/nouveau_ttm.c b/drivers/gpu/drm/nouveau/nouveau_ttm.c
index 9be9cb5..1506d78 100644
--- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
@@ -377,9 +377,8 @@ nouveau_ttm_init(struct nouveau_drm *drm)
 		return ret;
 	}
 
-	drm->ttm.mtrr = drm_mtrr_add(pci_resource_start(dev->pdev, 1),
-				     pci_resource_len(dev->pdev, 1),
-				     DRM_MTRR_WC);
+	drm->ttm.mtrr = drm_mtrr_add_wc(pci_resource_start(dev->pdev, 1),
+					pci_resource_len(dev->pdev, 1));
 
 	/* GART init */
 	if (drm->agp.stat != ENABLED) {
@@ -414,10 +413,6 @@ nouveau_ttm_fini(struct nouveau_drm *drm)
 
 	nouveau_ttm_global_release(drm);
 
-	if (drm->ttm.mtrr >= 0) {
-		drm_mtrr_del(drm->ttm.mtrr,
-			     pci_resource_start(drm->dev->pdev, 1),
-			     pci_resource_len(drm->dev->pdev, 1), DRM_MTRR_WC);
-		drm->ttm.mtrr = -1;
-	}
+	drm_mtrr_del_wc(drm->ttm.mtrr);
+	drm->ttm.mtrr = -1;
 }
diff --git a/drivers/gpu/drm/savage/savage_bci.c b/drivers/gpu/drm/savage/savage_bci.c
index b55c1d6..5b15215 100644
--- a/drivers/gpu/drm/savage/savage_bci.c
+++ b/drivers/gpu/drm/savage/savage_bci.c
@@ -570,9 +570,9 @@ int savage_driver_firstopen(struct drm_device *dev)
 	unsigned int fb_rsrc, aper_rsrc;
 	int ret = 0;
 
-	dev_priv->mtrr[0].handle = -1;
-	dev_priv->mtrr[1].handle = -1;
-	dev_priv->mtrr[2].handle = -1;
+	dev_priv->mtrr_handles[0] = -1;
+	dev_priv->mtrr_handles[1] = -1;
+	dev_priv->mtrr_handles[2] = -1;
 	if (S3_SAVAGE3D_SERIES(dev_priv->chipset)) {
 		fb_rsrc = 0;
 		fb_base = pci_resource_start(dev->pdev, 0);
@@ -584,21 +584,14 @@ int savage_driver_firstopen(struct drm_device *dev)
 		if (pci_resource_len(dev->pdev, 0) == 0x08000000) {
 			/* Don't make MMIO write-cobining! We need 3
 			 * MTRRs. */
-			dev_priv->mtrr[0].base = fb_base;
-			dev_priv->mtrr[0].size = 0x01000000;
-			dev_priv->mtrr[0].handle =
-			    drm_mtrr_add(dev_priv->mtrr[0].base,
-				         dev_priv->mtrr[0].size, DRM_MTRR_WC);
-			dev_priv->mtrr[1].base = fb_base + 0x02000000;
-			dev_priv->mtrr[1].size = 0x02000000;
-			dev_priv->mtrr[1].handle =
-			    drm_mtrr_add(dev_priv->mtrr[1].base,
-					 dev_priv->mtrr[1].size, DRM_MTRR_WC);
-			dev_priv->mtrr[2].base = fb_base + 0x04000000;
-			dev_priv->mtrr[2].size = 0x04000000;
-			dev_priv->mtrr[2].handle =
-			    drm_mtrr_add(dev_priv->mtrr[2].base,
-					 dev_priv->mtrr[2].size, DRM_MTRR_WC);
+			dev_priv->mtrr_handles[0] =
+				drm_mtrr_add_wc(fb_base, 0x01000000);
+			dev_priv->mtrr_handles[1] =
+				drm_mtrr_add_wc(fb_base + 0x02000000,
+						0x02000000);
+			dev_priv->mtrr_handles[2] =
+				drm_mtrr_add_wc(fb_base + 0x04000000,
+						0x04000000);
 		} else {
 			DRM_ERROR("strange pci_resource_len %08llx\n",
 				  (unsigned long long)
@@ -616,11 +609,9 @@ int savage_driver_firstopen(struct drm_device *dev)
 		if (pci_resource_len(dev->pdev, 1) == 0x08000000) {
 			/* Can use one MTRR to cover both fb and
 			 * aperture. */
-			dev_priv->mtrr[0].base = fb_base;
-			dev_priv->mtrr[0].size = 0x08000000;
-			dev_priv->mtrr[0].handle =
-			    drm_mtrr_add(dev_priv->mtrr[0].base,
-					 dev_priv->mtrr[0].size, DRM_MTRR_WC);
+			dev_priv->mtrr_handles[0] =
+				drm_mtrr_add_wc(fb_base,
+						0x08000000);
 		} else {
 			DRM_ERROR("strange pci_resource_len %08llx\n",
 				  (unsigned long long)
@@ -661,10 +652,7 @@ void savage_driver_lastclose(struct drm_device *dev)
 	int i;
 
 	for (i = 0; i < 3; ++i)
-		if (dev_priv->mtrr[i].handle >= 0)
-			drm_mtrr_del(dev_priv->mtrr[i].handle,
-				 dev_priv->mtrr[i].base,
-				 dev_priv->mtrr[i].size, DRM_MTRR_WC);
+		drm_mtrr_del_wc(dev_priv->mtrr_handles[i]);
 }
 
 int savage_driver_unload(struct drm_device *dev)
diff --git a/drivers/gpu/drm/savage/savage_drv.h b/drivers/gpu/drm/savage/savage_drv.h
index df2aac6..c05082a 100644
--- a/drivers/gpu/drm/savage/savage_drv.h
+++ b/drivers/gpu/drm/savage/savage_drv.h
@@ -160,10 +160,7 @@ typedef struct drm_savage_private {
 	drm_local_map_t *cmd_dma;
 	drm_local_map_t fake_dma;
 
-	struct {
-		int handle;
-		unsigned long base, size;
-	} mtrr[3];
+	int mtrr_handles[3];
 
 	/* BCI and status-related stuff */
 	volatile uint32_t *status_ptr, *bci_ptr;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 07dfd82..c104ae4 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -565,8 +565,8 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
 		dev_priv->has_gmr = false;
 	}
 
-	dev_priv->mmio_mtrr = drm_mtrr_add(dev_priv->mmio_start,
-					   dev_priv->mmio_size, DRM_MTRR_WC);
+	dev_priv->mmio_mtrr = drm_mtrr_add_wc(dev_priv->mmio_start,
+					      dev_priv->mmio_size);
 
 	dev_priv->mmio_virt = ioremap_wc(dev_priv->mmio_start,
 					 dev_priv->mmio_size);
@@ -664,8 +664,7 @@ out_no_device:
 out_err4:
 	iounmap(dev_priv->mmio_virt);
 out_err3:
-	drm_mtrr_del(dev_priv->mmio_mtrr, dev_priv->mmio_start,
-		     dev_priv->mmio_size, DRM_MTRR_WC);
+	drm_mtrr_del_wc(dev_priv->mmio_mtrr);
 	if (dev_priv->has_gmr)
 		(void) ttm_bo_clean_mm(&dev_priv->bdev, VMW_PL_GMR);
 	(void)ttm_bo_clean_mm(&dev_priv->bdev, TTM_PL_VRAM);
@@ -709,8 +708,7 @@ static int vmw_driver_unload(struct drm_device *dev)
 
 	ttm_object_device_release(&dev_priv->tdev);
 	iounmap(dev_priv->mmio_virt);
-	drm_mtrr_del(dev_priv->mmio_mtrr, dev_priv->mmio_start,
-		     dev_priv->mmio_size, DRM_MTRR_WC);
+	drm_mtrr_del_wc(dev_priv->mmio_mtrr);
 	if (dev_priv->has_gmr)
 		(void)ttm_bo_clean_mm(&dev_priv->bdev, VMW_PL_GMR);
 	(void)ttm_bo_clean_mm(&dev_priv->bdev, TTM_PL_VRAM);
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 2d94d74..2a3e1fd 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1250,18 +1250,15 @@ static inline int drm_core_has_MTRR(struct drm_device *dev)
 	return drm_core_check_feature(dev, DRIVER_USE_MTRR);
 }
 
-#define DRM_MTRR_WC		MTRR_TYPE_WRCOMB
-
-static inline int drm_mtrr_add(unsigned long offset, unsigned long size,
-			       unsigned int flags)
+static inline int __must_check drm_mtrr_add_wc(unsigned long offset,
+					       unsigned long size)
 {
-	return mtrr_add(offset, size, flags, 1);
+	return mtrr_add_wc_if_needed(offset, size);
 }
 
-static inline int drm_mtrr_del(int handle, unsigned long offset,
-			       unsigned long size, unsigned int flags)
+static inline void drm_mtrr_del_wc(int handle)
 {
-	return mtrr_del(handle, offset, size);
+	mtrr_del_wc_if_needed(handle);
 }
 
 #else
@@ -1269,16 +1266,14 @@ static inline int drm_mtrr_del(int handle, unsigned long offset,
 
 #define DRM_MTRR_WC		0
 
-static inline int drm_mtrr_add(unsigned long offset, unsigned long size,
-			       unsigned int flags)
+static inline int __must_check drm_mtrr_add_wc(unsigned long offset,
+					       unsigned long size)
 {
-	return 0;
+	return -1;
 }
 
-static inline int drm_mtrr_del(int handle, unsigned long offset,
-			       unsigned long size, unsigned int flags)
+static inline void drm_mtrr_del_wc(int handle)
 {
-	return 0;
 }
 #endif
 
-- 
1.8.1.4

