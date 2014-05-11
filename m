Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036AbaEKT0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:26:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934015AbaEKT03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:26:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gerd Hoffmann <kraxel@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.14 82/83] drm: bochs: add power management support
Date: Sun, 11 May 2014 21:20:23 +0200
Message-Id: <20140511191917.628292204@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerd Hoffmann <kraxel@redhat.com>

commit b8ccd70f1363f7d4e49219dbc46ec973a14f49cd upstream.

bochs kms driver lacks power management support, thus
the vga display doesn't work any more after S3 resume.

Fix this by adding suspend and resume functions.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/bochs/bochs.h     |    1 
 drivers/gpu/drm/bochs/bochs_drv.c |   44 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

--- a/drivers/gpu/drm/bochs/bochs.h
+++ b/drivers/gpu/drm/bochs/bochs.h
@@ -1,5 +1,6 @@
 #include <linux/io.h>
 #include <linux/fb.h>
+#include <linux/console.h>
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
--- a/drivers/gpu/drm/bochs/bochs_drv.c
+++ b/drivers/gpu/drm/bochs/bochs_drv.c
@@ -95,6 +95,49 @@ static struct drm_driver bochs_driver =
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
@@ -155,6 +198,7 @@ static struct pci_driver bochs_pci_drive
 	.id_table =	bochs_pci_tbl,
 	.probe =	bochs_pci_probe,
 	.remove =	bochs_pci_remove,
+	.driver.pm =    &bochs_pm_ops,
 };
 
 /* ---------------------------------------------------------------------- */


