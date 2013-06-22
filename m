Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab3FVUL4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 16:11:56 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:48322 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046Ab3FVULj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 16:11:39 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com, gregkh@linuxfoundation.org,
        airlied@linux.ie
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        shuahkhan@gmail.com
Subject: [PATCH 2/2] drm: Convert drm class driver from legacy pm ops to dev_pm_ops
Date: Sat, 22 Jun 2013 14:11:35 -0600
Message-Id: <1371931895-3283-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert drivers/gpu/drm class to use dev_pm_ops for power management and
remove Legacy PM ops hooks. With this change, drm class registers
suspend/resume callbacks via class->pm (dev_pm_ops) instead of Legacy
class->suspend/resume. When __device_suspend() runs call-backs, it will
find class->pm ops for the drm class.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/gpu/drm/drm_sysfs.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 0229665..8d94778 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -37,7 +37,7 @@ static struct device_type drm_sysfs_device_minor = {
  * Just figures out what the actual struct drm_device associated with
  * @dev is and calls its suspend hook, if present.
  */
-static int drm_class_suspend(struct device *dev, pm_message_t state)
+static int drm_class_suspend(struct device *dev)
 {
 	if (dev->type == &drm_sysfs_device_minor) {
 		struct drm_minor *drm_minor = to_drm_minor(dev);
@@ -46,7 +46,8 @@ static int drm_class_suspend(struct device *dev, pm_message_t state)
 		if (drm_minor->type == DRM_MINOR_LEGACY &&
 		    !drm_core_check_feature(drm_dev, DRIVER_MODESET) &&
 		    drm_dev->driver->suspend)
-			return drm_dev->driver->suspend(drm_dev, state);
+			return drm_dev->driver->suspend(drm_dev,
+							get_pm_transition());
 	}
 	return 0;
 }
@@ -72,6 +73,11 @@ static int drm_class_resume(struct device *dev)
 	return 0;
 }
 
+static const struct dev_pm_ops drm_class_dev_pm_ops = {
+	.suspend	= drm_class_suspend,
+	.resume		= drm_class_resume,
+};
+
 static char *drm_devnode(struct device *dev, umode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "dri/%s", dev_name(dev));
@@ -106,8 +112,7 @@ struct class *drm_sysfs_create(struct module *owner, char *name)
 		goto err_out;
 	}
 
-	class->suspend = drm_class_suspend;
-	class->resume = drm_class_resume;
+	class->pm = &drm_class_dev_pm_ops;
 
 	err = class_create_file(class, &class_attr_version.attr);
 	if (err)
-- 
1.7.10.4

