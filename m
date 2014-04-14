Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaDNJfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:35:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbaDNJfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:35:01 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org
Cc: Gerd Hoffmann <kraxel@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/3] drm: bochs: add power management support
Date: Mon, 14 Apr 2014 11:34:49 +0200
Message-Id: <1397468090-25941-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1397468090-25941-1-git-send-email-kraxel@redhat.com>
References: <1397468090-25941-1-git-send-email-kraxel@redhat.com>
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

