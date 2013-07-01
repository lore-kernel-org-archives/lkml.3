Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3GAWGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:06:12 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:52962 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873Ab3GAWGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:06:11 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: airlied@linux.ie, rjw@sisk.pl
Cc: Shuah Khan <shuah.kh@samsung.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH] drm: Convert drm class driver from legacy pm ops to dev_pm_ops
Date: Mon,  1 Jul 2013 16:06:02 -0600
Message-Id: <1372716363-16524-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert drivers/gpu/drm class to use dev_pm_ops for power management and
remove Legacy PM ops hooks. With this change, drm class registers
suspend/resume callbacks via class->pm (dev_pm_ops) instead of Legacy
class->suspend/resume. When __device_suspend() runs call-backs, it will
find class->pm ops for the drm class.

drm_class_suspend() hook calls driver legacy ops with the state information.
e.g: drm_class_suspend() calls into driver suspend routines
via drm_dev->driver->suspend(drm_dev, state).

Once drm_class_suspend() is converted to dev_pm_ops, it will no longer
have access to pm_transition which it has to pass into driver legacy
suspend calls. A new freeze and suspend hooks are added to address the not
having access to the state information. The new freeze and suspend hooks
simply call __drm_class_suspend() with the appropriate pm state information.
__drm_class_suspend() is the original suspend hook with a new name.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/gpu/drm/drm_sysfs.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 0229665..2290b3b 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -30,14 +30,14 @@ static struct device_type drm_sysfs_device_minor = {
 };
 
 /**
- * drm_class_suspend - DRM class suspend hook
+ * __drm_class_suspend - internal DRM class suspend routine
  * @dev: Linux device to suspend
  * @state: power state to enter
  *
  * Just figures out what the actual struct drm_device associated with
  * @dev is and calls its suspend hook, if present.
  */
-static int drm_class_suspend(struct device *dev, pm_message_t state)
+static int __drm_class_suspend(struct device *dev, pm_message_t state)
 {
 	if (dev->type == &drm_sysfs_device_minor) {
 		struct drm_minor *drm_minor = to_drm_minor(dev);
@@ -52,6 +52,26 @@ static int drm_class_suspend(struct device *dev, pm_message_t state)
 }
 
 /**
+ * drm_class_suspend - internal DRM class suspend hook. Simply calls
+ * __drm_class_suspend() with the correct pm state.
+ * @dev: Linux device to suspend
+ */
+static int drm_class_suspend(struct device *dev)
+{
+	return __drm_class_suspend(dev, PMSG_SUSPEND);
+}
+
+/**
+ * drm_class_freeze - internal DRM class freeze hook. Simply calls
+ * __drm_class_suspend() with the correct pm state.
+ * @dev: Linux device to freeze
+ */
+static int drm_class_freeze(struct device *dev)
+{
+	return __drm_class_suspend(dev, PMSG_FREEZE);
+}
+
+/**
  * drm_class_resume - DRM class resume hook
  * @dev: Linux device to resume
  *
@@ -72,6 +92,12 @@ static int drm_class_resume(struct device *dev)
 	return 0;
 }
 
+static const struct dev_pm_ops drm_class_dev_pm_ops = {
+	.suspend	= drm_class_suspend,
+	.resume		= drm_class_resume,
+	.freeze		= drm_class_freeze,
+};
+
 static char *drm_devnode(struct device *dev, umode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "dri/%s", dev_name(dev));
@@ -106,8 +132,7 @@ struct class *drm_sysfs_create(struct module *owner, char *name)
 		goto err_out;
 	}
 
-	class->suspend = drm_class_suspend;
-	class->resume = drm_class_resume;
+	class->pm = &drm_class_dev_pm_ops;
 
 	err = class_create_file(class, &class_attr_version.attr);
 	if (err)
-- 
1.7.10.4

