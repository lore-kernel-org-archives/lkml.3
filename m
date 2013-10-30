Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3J3XKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:10:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47381 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3J3XKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:10:51 -0400
Date: Thu, 31 Oct 2013 07:10:24 +0800
From: Wang YanQing <udknight@gmail.com>
To: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] drm:drm_platform: fix resource leak in
 drm_get_platform_dev
Message-ID: <20131030231023.GA5719@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, airlied@linux.ie,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should call drm_cleanup_in_dev in error handle
code path after drm_fill_in_dev had been called,
or it will cause resource leak heavily, vmalloc
leak etc.

This patch also add call to dev->unload in error
handle code path.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/gpu/drm/drm_platform.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_platform.c b/drivers/gpu/drm/drm_platform.c
index b8a282e..1198fa4 100644
--- a/drivers/gpu/drm/drm_platform.c
+++ b/drivers/gpu/drm/drm_platform.c
@@ -66,17 +66,17 @@ int drm_get_platform_dev(struct platform_device *platdev,
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 		ret = drm_get_minor(dev, &dev->control, DRM_MINOR_CONTROL);
 		if (ret)
-			goto err_g1;
+			goto err_g2;
 	}
 
 	ret = drm_get_minor(dev, &dev->primary, DRM_MINOR_LEGACY);
 	if (ret)
-		goto err_g2;
+		goto err_g3;
 
 	if (dev->driver->load) {
 		ret = dev->driver->load(dev, 0);
 		if (ret)
-			goto err_g3;
+			goto err_g4;
 	}
 
 	/* setup the grouping for the legacy output */
@@ -84,7 +84,7 @@ int drm_get_platform_dev(struct platform_device *platdev,
 		ret = drm_mode_group_init_legacy_group(dev,
 				&dev->primary->mode_group);
 		if (ret)
-			goto err_g3;
+			goto err_g5;
 	}
 
 	list_add_tail(&dev->driver_item, &driver->device_list);
@@ -96,12 +96,16 @@ int drm_get_platform_dev(struct platform_device *platdev,
 		 driver->date, dev->primary->index);
 
 	return 0;
-
-err_g3:
+err_g5:
+	if (dev->driver->unload)
+		dev->driver->unload(dev);
+err_g4:
 	drm_put_minor(&dev->primary);
-err_g2:
+err_g3:
 	if (drm_core_check_feature(dev, DRIVER_MODESET))
 		drm_put_minor(&dev->control);
+err_g2:
+	drm_cleanup_in_dev(dev);
 err_g1:
 	kfree(dev);
 	mutex_unlock(&drm_global_mutex);
-- 
1.7.12.4.dirty
