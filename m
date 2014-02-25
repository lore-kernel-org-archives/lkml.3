Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaBYLOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:14:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaBYLOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:14:39 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drm: cirrus: add power management support
Date: Tue, 25 Feb 2014 12:14:19 +0100
Message-Id: <1393326860-28235-1-git-send-email-kraxel@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cirrus kms driver lacks power management support, thus
the vga display doesn't work any more after S3 resume.

Fix this by adding suspend and resume functions.
Also make the mode_set function unblank the screen.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/cirrus/cirrus_drv.c  | 42 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/cirrus/cirrus_mode.c |  3 +++
 2 files changed, 45 insertions(+)

diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.c b/drivers/gpu/drm/cirrus/cirrus_drv.c
index 953fc8a..08ce520 100644
--- a/drivers/gpu/drm/cirrus/cirrus_drv.c
+++ b/drivers/gpu/drm/cirrus/cirrus_drv.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/console.h>
 #include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
 
 #include "cirrus_drv.h"
 
@@ -75,6 +76,41 @@ static void cirrus_pci_remove(struct pci_dev *pdev)
 	drm_put_dev(dev);
 }
 
+static int cirrus_pm_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct drm_device *drm_dev = pci_get_drvdata(pdev);
+	struct cirrus_device *cdev = drm_dev->dev_private;
+
+	drm_kms_helper_poll_disable(drm_dev);
+
+	if (cdev->mode_info.gfbdev) {
+		console_lock();
+		fb_set_suspend(cdev->mode_info.gfbdev->helper.fbdev, 1);
+		console_unlock();
+	}
+
+	return 0;
+}
+
+static int cirrus_pm_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct drm_device *drm_dev = pci_get_drvdata(pdev);
+	struct cirrus_device *cdev = drm_dev->dev_private;
+
+	drm_helper_resume_force_mode(drm_dev);
+
+	if (cdev->mode_info.gfbdev) {
+		console_lock();
+		fb_set_suspend(cdev->mode_info.gfbdev->helper.fbdev, 0);
+		console_unlock();
+	}
+
+	drm_kms_helper_poll_enable(drm_dev);
+	return 0;
+}
+
 static const struct file_operations cirrus_driver_fops = {
 	.owner = THIS_MODULE,
 	.open = drm_open,
@@ -103,11 +139,17 @@ static struct drm_driver driver = {
 	.dumb_destroy = drm_gem_dumb_destroy,
 };
 
+static const struct dev_pm_ops cirrus_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(cirrus_pm_suspend,
+				cirrus_pm_resume)
+};
+
 static struct pci_driver cirrus_pci_driver = {
 	.name = DRIVER_NAME,
 	.id_table = pciidlist,
 	.probe = cirrus_pci_probe,
 	.remove = cirrus_pci_remove,
+	.driver.pm = &cirrus_pm_ops,
 };
 
 static int __init cirrus_init(void)
diff --git a/drivers/gpu/drm/cirrus/cirrus_mode.c b/drivers/gpu/drm/cirrus/cirrus_mode.c
index 530f78f..e9c89df 100644
--- a/drivers/gpu/drm/cirrus/cirrus_mode.c
+++ b/drivers/gpu/drm/cirrus/cirrus_mode.c
@@ -308,6 +308,9 @@ static int cirrus_crtc_mode_set(struct drm_crtc *crtc,
 
 	WREG_HDR(hdr);
 	cirrus_crtc_do_set_base(crtc, old_fb, x, y, 0);
+
+	/* Unblank (needed on S3 resume, vgabios doesn't do it then) */
+	outb(0x20, 0x3c0);
 	return 0;
 }
 
-- 
1.8.3.1

