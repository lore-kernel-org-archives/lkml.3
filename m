Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3J3XM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:12:57 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62719 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3J3XMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:12:55 -0400
Date: Thu, 31 Oct 2013 07:12:31 +0800
From: Wang YanQing <udknight@gmail.com>
To: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] drm:drm_stub: rewrite error handle code for
 drm_fill_in_dev
Message-ID: <20131030231228.GC5719@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, airlied@linux.ie,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite error handle code in a more rational and
normal way, it bring us benefit that we could drop
call to drm_lastclose which do "too much" cleanup work
for drm_fill_in_dev.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/gpu/drm/drm_stub.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 3f3b167..6c5f65f 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -316,7 +316,7 @@ int drm_fill_in_dev(struct drm_device *dev,
 	if (dev->driver->bus->agp_init) {
 		retcode = dev->driver->bus->agp_init(dev);
 		if (retcode)
-			goto error_out_unreg;
+			goto err_g1;
 	}
 
 
@@ -324,7 +324,7 @@ int drm_fill_in_dev(struct drm_device *dev,
 	retcode = drm_ctxbitmap_init(dev);
 	if (retcode) {
 		DRM_ERROR("Cannot allocate memory for context bitmap.\n");
-		goto error_out_unreg;
+		goto err_g2;
 	}
 
 	if (driver->driver_features & DRIVER_GEM) {
@@ -332,14 +332,30 @@ int drm_fill_in_dev(struct drm_device *dev,
 		if (retcode) {
 			DRM_ERROR("Cannot initialize graphics execution "
 				  "manager (GEM)\n");
-			goto error_out_unreg;
+			goto err_g3;
 		}
 	}
 
 	return 0;
 
-      error_out_unreg:
-	drm_lastclose(dev);
+err_g3:
+	drm_ctxbitmap_cleanup(dev);
+err_g2:
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
+err_g1:
+	drm_ht_remove(&dev->map_hash);
 	return retcode;
 }
 EXPORT_SYMBOL(drm_fill_in_dev);
-- 
1.7.12.4.dirty
