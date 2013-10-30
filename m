Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3J3XJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:09:45 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:44873 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3J3XJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:09:44 -0400
Date: Thu, 31 Oct 2013 07:09:17 +0800
From: Wang YanQing <udknight@gmail.com>
To: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] drm:drm_pci: fix resource leak in drm_get_pci_dev
Message-ID: <20131030230914.GA5697@udknight>
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
 drivers/gpu/drm/drm_pci.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index 14194b6..5f15805 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -345,16 +345,16 @@ int drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
 		pci_set_drvdata(pdev, dev);
 		ret = drm_get_minor(dev, &dev->control, DRM_MINOR_CONTROL);
 		if (ret)
-			goto err_g2;
+			goto err_g3;
 	}
 
 	if ((ret = drm_get_minor(dev, &dev->primary, DRM_MINOR_LEGACY)))
-		goto err_g3;
+		goto err_g4;
 
 	if (dev->driver->load) {
 		ret = dev->driver->load(dev, ent->driver_data);
 		if (ret)
-			goto err_g4;
+			goto err_g5;
 	}
 
 	/* setup the grouping for the legacy output */
@@ -362,7 +362,7 @@ int drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
 		ret = drm_mode_group_init_legacy_group(dev,
 						&dev->primary->mode_group);
 		if (ret)
-			goto err_g4;
+			goto err_g6;
 	}
 
 	list_add_tail(&dev->driver_item, &driver->device_list);
@@ -373,12 +373,16 @@ int drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
 
 	mutex_unlock(&drm_global_mutex);
 	return 0;
-
-err_g4:
+err_g6:
+	if (dev->driver->unload)
+		dev->driver->unload(dev);
+err_g5:
 	drm_put_minor(&dev->primary);
-err_g3:
+err_g4:
 	if (drm_core_check_feature(dev, DRIVER_MODESET))
 		drm_put_minor(&dev->control);
+err_g3:
+	drm_cleanup_in_dev(dev);
 err_g2:
 	pci_disable_device(pdev);
 err_g1:
-- 
1.7.12.4.dirty
