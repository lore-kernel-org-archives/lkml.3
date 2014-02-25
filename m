Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaBYLO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:14:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbaBYLO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:14:56 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drm: bochs: add power management support
Date: Tue, 25 Feb 2014 12:14:48 +0100
Message-Id: <1393326888-28295-1-git-send-email-kraxel@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bochs kms driver lacks power management support, thus
the vga display doesn't work any more after S3 resume.

Fix this by adding suspend and resume functions.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/bochs/bochs.h     |  1 +
 drivers/gpu/drm/bochs/bochs_drv.c | 44 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/gpu/drm/bochs/bochs.h b/drivers/gpu/drm/bochs/bochs.h
index 741965c..4608205 100644
--- a/drivers/gpu/drm/bochs/bochs.h
+++ b/drivers/gpu/drm/bochs/bochs.h
@@ -1,5 +1,6 @@
 #include <linux/io.h>
 #include <linux/fb.h>
+#include <linux/console.h>
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
diff --git a/drivers/gpu/drm/bochs/bochs_drv.c b/drivers/gpu/drm/bochs/bochs_drv.c
index 395bba2..9c13df2 100644
--- a/drivers/gpu/drm/bochs/bochs_drv.c
+++ b/drivers/gpu/drm/bochs/bochs_drv.c
@@ -95,6 +95,49 @@ static struct drm_driver bochs_driver = {
 };
 
 /* ---------------------------------------------------------------------- */
+/* pm interface                                                           */
+
+static int bochs_pm_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct drm_device *drm_dev = pci_get_drvdata(pdev);
+	struct bochs_device *bochs = drm_dev->dev_private;
+
+	drm_kms_helper_poll_disable(drm_dev);
+
+	if (bochs->fb.initialized) {
+		console_lock();
+		fb_set_suspend(bochs->fb.helper.fbdev, 1);
+		console_unlock();
+	}
+
+	return 0;
+}
+
+static int bochs_pm_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct drm_device *drm_dev = pci_get_drvdata(pdev);
+	struct bochs_device *bochs = drm_dev->dev_private;
+
+	drm_helper_resume_force_mode(drm_dev);
+
+	if (bochs->fb.initialized) {
+		console_lock();
+		fb_set_suspend(bochs->fb.helper.fbdev, 0);
+		console_unlock();
+	}
+
+	drm_kms_helper_poll_enable(drm_dev);
+	return 0;
+}
+
+static const struct dev_pm_ops bochs_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(bochs_pm_suspend,
+				bochs_pm_resume)
+};
+
+/* ---------------------------------------------------------------------- */
 /* pci interface                                                          */
 
 static int bochs_kick_out_firmware_fb(struct pci_dev *pdev)
@@ -155,6 +198,7 @@ static struct pci_driver bochs_pci_driver = {
 	.id_table =	bochs_pci_tbl,
 	.probe =	bochs_pci_probe,
 	.remove =	bochs_pci_remove,
+	.driver.pm =    &bochs_pm_ops,
 };
 
 /* ---------------------------------------------------------------------- */
-- 
1.8.3.1

