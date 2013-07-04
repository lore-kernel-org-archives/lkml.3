Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3GDM3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:29:51 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64712 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3GDM0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:51 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v2 14/14] drm/radeon: use new drm_kick_out_firmware()
Date: Thu,  4 Jul 2013 14:25:14 +0200
Message-Id: <1372940714-12470-15-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kick out firmware DRM and fbdev drivers via the new
drm_kick_out_firmware() before loading radeon.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/radeon/radeon_drv.c | 28 ----------------------------
 drivers/gpu/drm/radeon/radeon_kms.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 094e7e5..8ed3ab3 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -308,37 +308,9 @@ static struct drm_driver driver_old = {
 
 static struct drm_driver kms_driver;
 
-static int radeon_kick_out_firmware_fb(struct pci_dev *pdev)
-{
-	struct apertures_struct *ap;
-	bool primary = false;
-
-	ap = alloc_apertures(1);
-	if (!ap)
-		return -ENOMEM;
-
-	ap->ranges[0].base = pci_resource_start(pdev, 0);
-	ap->ranges[0].size = pci_resource_len(pdev, 0);
-
-#ifdef CONFIG_X86
-	primary = pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
-#endif
-	remove_conflicting_framebuffers(ap, "radeondrmfb", primary);
-	kfree(ap);
-
-	return 0;
-}
-
 static int radeon_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *ent)
 {
-	int ret;
-
-	/* Get rid of things like offb */
-	ret = radeon_kick_out_firmware_fb(pdev);
-	if (ret)
-		return ret;
-
 	return drm_get_pci_dev(pdev, ent, &kms_driver);
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 4f2d4f4..f199b3c 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -62,6 +62,30 @@ done_free:
 	return 0;
 }
 
+static int radeon_kick_out_firmware(struct drm_device *dev)
+{
+	struct pci_dev *pdev = dev->pdev;
+	struct apertures_struct *ap;
+	bool primary = false;
+
+	ap = alloc_apertures(1);
+	if (!ap)
+		return -ENOMEM;
+
+	ap->ranges[0].base = pci_resource_start(pdev, 0);
+	ap->ranges[0].size = pci_resource_len(pdev, 0);
+
+#ifdef CONFIG_X86
+	primary = pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
+#endif
+
+	drm_kick_out_firmware(ap, primary);
+	dev->apertures = ap;
+	dev->apert_boot = primary;
+
+	return 0;
+}
+
 /**
  * radeon_driver_load_kms - Main load function for KMS.
  *
@@ -86,6 +110,12 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
 	}
 	dev->dev_private = (void *)rdev;
 
+	r = radeon_kick_out_firmware(dev);
+	if (r) {
+		kfree(rdev);
+		return r;
+	}
+
 	/* update BUS flag */
 	if (drm_pci_device_is_agp(dev)) {
 		flags |= RADEON_IS_AGP;
-- 
1.8.3.2

