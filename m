Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3J3XGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:06:08 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59782 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3J3XGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:06:06 -0400
Date: Thu, 31 Oct 2013 07:05:40 +0800
From: Wang YanQing <udknight@gmail.com>
To: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] drm:drm_stub: add new function drm_cleanup_in_dev
Message-ID: <20131030230540.GA5553@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, airlied@linux.ie,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new function, drm_cleanup_in_dev,
we could use it to release resources allocated
by drm_fill_in_dev in the error handle code path
after drm_fill_in_dev have been called.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/gpu/drm/drm_stub.c | 62 ++++++++++++++++++++++++----------------------
 include/drm/drmP.h         |  1 +
 2 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 16f3ec5..3f3b167 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -250,6 +250,37 @@ int drm_dropmaster_ioctl(struct drm_device *dev, void *data,
 	return 0;
 }
 
+void drm_cleanup_in_dev(struct drm_device *dev)
+{
+	struct drm_driver *driver;
+	struct drm_map_list *r_list, *list_temp;
+
+	driver = dev->driver;
+	if (drm_core_has_MTRR(dev) && drm_core_has_AGP(dev) &&
+		dev->agp && dev->agp->agp_mtrr >= 0) {
+		int retval;
+		retval = mtrr_del(dev->agp->agp_mtrr,
+				dev->agp->agp_info.aper_base,
+				dev->agp->agp_info.aper_size * 1024 * 1024);
+		DRM_DEBUG("mtrr_del=%d\n", retval);
+	}
+
+	if (drm_core_has_AGP(dev) && dev->agp) {
+		kfree(dev->agp);
+		dev->agp = NULL;
+	}
+
+	list_for_each_entry_safe(r_list, list_temp, &dev->maplist, head)
+		drm_rmmap(dev, r_list->map);
+	drm_ht_remove(&dev->map_hash);
+
+	drm_ctxbitmap_cleanup(dev);
+
+	if (dev->driver->driver_features & DRIVER_GEM)
+		drm_gem_destroy(dev);
+}
+EXPORT_SYMBOL(drm_cleanup_in_dev);
+
 int drm_fill_in_dev(struct drm_device *dev,
 			   const struct pci_device_id *ent,
 			   struct drm_driver *driver)
@@ -438,52 +469,23 @@ static void drm_unplug_minor(struct drm_minor *minor)
  */
 void drm_put_dev(struct drm_device *dev)
 {
-	struct drm_driver *driver;
-	struct drm_map_list *r_list, *list_temp;
-
 	DRM_DEBUG("\n");
-
 	if (!dev) {
 		DRM_ERROR("cleanup called no dev\n");
 		return;
 	}
-	driver = dev->driver;
 
 	drm_lastclose(dev);
 
-	if (drm_core_has_MTRR(dev) && drm_core_has_AGP(dev) &&
-	    dev->agp && dev->agp->agp_mtrr >= 0) {
-		int retval;
-		retval = mtrr_del(dev->agp->agp_mtrr,
-				  dev->agp->agp_info.aper_base,
-				  dev->agp->agp_info.aper_size * 1024 * 1024);
-		DRM_DEBUG("mtrr_del=%d\n", retval);
-	}
-
 	if (dev->driver->unload)
 		dev->driver->unload(dev);
 
-	if (drm_core_has_AGP(dev) && dev->agp) {
-		kfree(dev->agp);
-		dev->agp = NULL;
-	}
-
 	drm_vblank_cleanup(dev);
-
-	list_for_each_entry_safe(r_list, list_temp, &dev->maplist, head)
-		drm_rmmap(dev, r_list->map);
-	drm_ht_remove(&dev->map_hash);
-
-	drm_ctxbitmap_cleanup(dev);
+	drm_cleanup_in_dev(dev);
 
 	if (drm_core_check_feature(dev, DRIVER_MODESET))
 		drm_put_minor(&dev->control);
-
-	if (driver->driver_features & DRIVER_GEM)
-		drm_gem_destroy(dev);
-
 	drm_put_minor(&dev->primary);
-
 	list_del(&dev->driver_item);
 	kfree(dev->devname);
 	kfree(dev);
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 63d17ee..2dcf83a 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1761,6 +1761,7 @@ static __inline__ void drm_core_dropmap(struct drm_local_map *map)
 
 #include <drm/drm_mem_util.h>
 
+extern void drm_cleanup_in_dev(struct drm_device *dev);
 extern int drm_fill_in_dev(struct drm_device *dev,
 			   const struct pci_device_id *ent,
 			   struct drm_driver *driver);
-- 
1.7.12.4.dirty
