Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab3BFUNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:13:09 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43892 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080Ab3BFTta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:30 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 06/77] drm: don't use idr_remove_all()
Date: Wed,  6 Feb 2013 11:39:38 -0800
Message-Id: <1360179649-22465-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

* drm_ctxbitmap_cleanup() was calling idr_remove_all() but forgetting
  idr_destroy() thus leaking all buffered free idr_layers.  Replace it
  with idr_destroy().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/drm_context.c           | 2 +-
 drivers/gpu/drm/drm_crtc.c              | 1 -
 drivers/gpu/drm/drm_drv.c               | 1 -
 drivers/gpu/drm/drm_gem.c               | 2 --
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 4 ----
 drivers/gpu/drm/sis/sis_drv.c           | 1 -
 drivers/gpu/drm/via/via_map.c           | 1 -
 7 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_context.c b/drivers/gpu/drm/drm_context.c
index 45adf97..75f62c5 100644
--- a/drivers/gpu/drm/drm_context.c
+++ b/drivers/gpu/drm/drm_context.c
@@ -118,7 +118,7 @@ int drm_ctxbitmap_init(struct drm_device * dev)
 void drm_ctxbitmap_cleanup(struct drm_device * dev)
 {
 	mutex_lock(&dev->struct_mutex);
-	idr_remove_all(&dev->ctx_idr);
+	idr_destroy(&dev->ctx_idr);
 	mutex_unlock(&dev->struct_mutex);
 }
 
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 9c797f6..775102d 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1258,7 +1258,6 @@ void drm_mode_config_cleanup(struct drm_device *dev)
 		crtc->funcs->destroy(crtc);
 	}
 
-	idr_remove_all(&dev->mode_config.crtc_idr);
 	idr_destroy(&dev->mode_config.crtc_idr);
 }
 EXPORT_SYMBOL(drm_mode_config_cleanup);
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index be174ca..25f91cd 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -297,7 +297,6 @@ static void __exit drm_core_exit(void)
 
 	unregister_chrdev(DRM_MAJOR, "drm");
 
-	idr_remove_all(&drm_minors_idr);
 	idr_destroy(&drm_minors_idr);
 }
 
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 24efae4..e775859 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -561,8 +561,6 @@ drm_gem_release(struct drm_device *dev, struct drm_file *file_private)
 {
 	idr_for_each(&file_private->object_idr,
 		     &drm_gem_object_release_handle, file_private);
-
-	idr_remove_all(&file_private->object_idr);
 	idr_destroy(&file_private->object_idr);
 }
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 1a55635..90398df 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -1786,8 +1786,6 @@ err_iommu:
 			drm_iommu_detach_device(drm_dev, ippdrv->dev);
 
 err_idr:
-	idr_remove_all(&ctx->ipp_idr);
-	idr_remove_all(&ctx->prop_idr);
 	idr_destroy(&ctx->ipp_idr);
 	idr_destroy(&ctx->prop_idr);
 	return ret;
@@ -1965,8 +1963,6 @@ static int ipp_remove(struct platform_device *pdev)
 	exynos_drm_subdrv_unregister(&ctx->subdrv);
 
 	/* remove,destroy ipp idr */
-	idr_remove_all(&ctx->ipp_idr);
-	idr_remove_all(&ctx->prop_idr);
 	idr_destroy(&ctx->ipp_idr);
 	idr_destroy(&ctx->prop_idr);
 
diff --git a/drivers/gpu/drm/sis/sis_drv.c b/drivers/gpu/drm/sis/sis_drv.c
index 841065b..5a5325e 100644
--- a/drivers/gpu/drm/sis/sis_drv.c
+++ b/drivers/gpu/drm/sis/sis_drv.c
@@ -58,7 +58,6 @@ static int sis_driver_unload(struct drm_device *dev)
 {
 	drm_sis_private_t *dev_priv = dev->dev_private;
 
-	idr_remove_all(&dev_priv->object_idr);
 	idr_destroy(&dev_priv->object_idr);
 
 	kfree(dev_priv);
diff --git a/drivers/gpu/drm/via/via_map.c b/drivers/gpu/drm/via/via_map.c
index c0f1cc7..d0ab3fb 100644
--- a/drivers/gpu/drm/via/via_map.c
+++ b/drivers/gpu/drm/via/via_map.c
@@ -120,7 +120,6 @@ int via_driver_unload(struct drm_device *dev)
 {
 	drm_via_private_t *dev_priv = dev->dev_private;
 
-	idr_remove_all(&dev_priv->object_idr);
 	idr_destroy(&dev_priv->object_idr);
 
 	kfree(dev_priv);
-- 
1.8.1

