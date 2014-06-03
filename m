Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbaFCMQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:16:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbaFCLks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gerd Hoffmann <kraxel@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 038/138] drm: cirrus: add power management support
Date: Tue,  3 Jun 2014 12:38:04 +0100
Message-Id: <1401795584-22664-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerd Hoffmann <kraxel@redhat.com>

commit 2f1e800799bf478494cec3573cd63eb34ca89c9d upstream.

cirrus kms driver lacks power management support, thus
the vga display doesn't work any more after S3 resume.

Fix this by adding suspend and resume functions.
Also make the mode_set function unblank the screen.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/cirrus/cirrus_drv.c  | 42 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/cirrus/cirrus_mode.c |  3 +++
 2 files changed, 45 insertions(+)

diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.c b/drivers/gpu/drm/cirrus/cirrus_drv.c
index 8ecb601152ef..64bfc235021a 100644
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
@@ -105,11 +141,17 @@ static struct drm_driver driver = {
 	.dumb_destroy = cirrus_dumb_destroy,
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
index 379a47ea99f6..b86f68d8b726 100644
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
1.9.1

