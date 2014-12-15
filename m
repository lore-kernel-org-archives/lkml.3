Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaLOPMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:12:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38301 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaLOO12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 030/168] drm/i915: Handle failure to kick out a conflicting fb driver
Date: Mon, 15 Dec 2014 14:24:44 +0000
Message-Id: <1418653622-21105-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit f96de58fc7e7d3d717c7c63975c3b896c906b5e3 upstream.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index d44344140627..0663fb4fa606 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1425,15 +1425,16 @@ void i915_master_destroy(struct drm_device *dev, struct drm_master *master)
 }
 
 #if IS_ENABLED(CONFIG_FB)
-static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
+static int i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
 {
 	struct apertures_struct *ap;
 	struct pci_dev *pdev = dev_priv->dev->pdev;
 	bool primary;
+	int ret;
 
 	ap = alloc_apertures(1);
 	if (!ap)
-		return;
+		return -ENOMEM;
 
 	ap->ranges[0].base = dev_priv->gtt.mappable_base;
 	ap->ranges[0].size = dev_priv->gtt.mappable_end;
@@ -1441,13 +1442,16 @@ static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
 	primary =
 		pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
 
-	remove_conflicting_framebuffers(ap, "inteldrmfb", primary);
+	ret = remove_conflicting_framebuffers(ap, "inteldrmfb", primary);
 
 	kfree(ap);
+
+	return ret;
 }
 #else
-static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
+static int i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
 {
+	return 0;
 }
 #endif
 
@@ -1664,7 +1668,11 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 			goto out_gtt;
 		}
 
-		i915_kick_out_firmware_fb(dev_priv);
+		ret = i915_kick_out_firmware_fb(dev_priv);
+		if (ret) {
+			DRM_ERROR("failed to remove conflicting framebuffer drivers\n");
+			goto out_gtt;
+		}
 	}
 
 	pci_set_master(dev->pdev);
-- 
2.1.3

