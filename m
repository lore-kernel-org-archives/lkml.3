Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3J3XMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:12:01 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39519 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3J3XMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:12:00 -0400
Date: Thu, 31 Oct 2013 07:11:35 +0800
From: Wang YanQing <udknight@gmail.com>
To: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] drm:drm_usb: fix resource leak in drm_get_usb_dev
Message-ID: <20131030231135.GB5719@udknight>
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
 drivers/gpu/drm/drm_usb.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_usb.c b/drivers/gpu/drm/drm_usb.c
index 34a156f..7e4de60 100644
--- a/drivers/gpu/drm/drm_usb.c
+++ b/drivers/gpu/drm/drm_usb.c
@@ -31,23 +31,23 @@ int drm_get_usb_dev(struct usb_interface *interface,
 	usb_set_intfdata(interface, dev);
 	ret = drm_get_minor(dev, &dev->control, DRM_MINOR_CONTROL);
 	if (ret)
-		goto err_g1;
+		goto err_g2;
 
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
 	ret = drm_mode_group_init_legacy_group(dev,
 					       &dev->primary->mode_group);
 	if (ret)
-		goto err_g3;
+		goto err_g5;
 
 	list_add_tail(&dev->driver_item, &driver->device_list);
 
@@ -58,11 +58,15 @@ int drm_get_usb_dev(struct usb_interface *interface,
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
 	drm_put_minor(&dev->control);
+err_g2:
+	drm_cleanup_in_dev(dev);
 err_g1:
 	kfree(dev);
 	mutex_unlock(&drm_global_mutex);
-- 
1.7.12.4.dirty
