Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab3EITrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:47:13 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:47681 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3EITrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:47:01 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC/PATCH v2 5/8] i915: Use arch_phys_wc_{add,del}
Date: Thu,  9 May 2013 12:46:24 -0700
Message-Id: <2d9af02b508eaf182c72b6e60a63070de265a759.1368128020.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1368128020.git.luto@amacapital.net>
References: <cover.1368128020.git.luto@amacapital.net>
In-Reply-To: <cover.1368128020.git.luto@amacapital.net>
References: <cover.1368128020.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i915 open-coded logic that was essentially equivalent to the new API.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Changes from v1: More cleanup

 drivers/gpu/drm/i915/i915_dma.c | 44 ++++++-----------------------------------
 1 file changed, 6 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 4fa6beb..cfdfb45 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -42,7 +42,6 @@
 #include <linux/vga_switcheroo.h>
 #include <linux/slab.h>
 #include <acpi/video.h>
-#include <asm/pat.h>
 
 #define LP_RING(d) (&((struct drm_i915_private *)(d))->ring[RCS])
 
@@ -1393,29 +1392,6 @@ void i915_master_destroy(struct drm_device *dev, struct drm_master *master)
 	master->driver_priv = NULL;
 }
 
-static void
-i915_mtrr_setup(struct drm_i915_private *dev_priv, unsigned long base,
-		unsigned long size)
-{
-	dev_priv->mm.gtt_mtrr = -1;
-
-#if defined(CONFIG_X86_PAT)
-	if (cpu_has_pat)
-		return;
-#endif
-
-	/* Set up a WC MTRR for non-PAT systems.  This is more common than
-	 * one would think, because the kernel disables PAT on first
-	 * generation Core chips because WC PAT gets overridden by a UC
-	 * MTRR if present.  Even if a UC MTRR isn't present.
-	 */
-	dev_priv->mm.gtt_mtrr = mtrr_add(base, size, MTRR_TYPE_WRCOMB, 1);
-	if (dev_priv->mm.gtt_mtrr < 0) {
-		DRM_INFO("MTRR allocation failed.  Graphics "
-			 "performance may suffer.\n");
-	}
-}
-
 static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
 {
 	struct apertures_struct *ap;
@@ -1552,8 +1528,8 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 		goto out_rmmap;
 	}
 
-	i915_mtrr_setup(dev_priv, dev_priv->gtt.mappable_base,
-			aperture_size);
+	dev_priv->mm.gtt_mtrr = arch_phys_wc_add(dev_priv->gtt.mappable_base,
+						 aperture_size);
 
 	/* The i915 workqueue is primarily used for batched retirement of
 	 * requests (and thus managing bo) once the task has been completed
@@ -1656,12 +1632,8 @@ out_gem_unload:
 	intel_teardown_mchbar(dev);
 	destroy_workqueue(dev_priv->wq);
 out_mtrrfree:
-	if (dev_priv->mm.gtt_mtrr >= 0) {
-		mtrr_del(dev_priv->mm.gtt_mtrr,
-			 dev_priv->gtt.mappable_base,
-			 aperture_size);
-		dev_priv->mm.gtt_mtrr = -1;
-	}
+	arch_phys_wc_del(dev_priv->mm.gtt_mtrr);
+	dev_priv->mm.gtt_mtrr = 0;
 	io_mapping_free(dev_priv->gtt.mappable);
 out_rmmap:
 	pci_iounmap(dev->pdev, dev_priv->regs);
@@ -1697,12 +1669,8 @@ int i915_driver_unload(struct drm_device *dev)
 	cancel_delayed_work_sync(&dev_priv->mm.retire_work);
 
 	io_mapping_free(dev_priv->gtt.mappable);
-	if (dev_priv->mm.gtt_mtrr >= 0) {
-		mtrr_del(dev_priv->mm.gtt_mtrr,
-			 dev_priv->gtt.mappable_base,
-			 dev_priv->gtt.mappable_end);
-		dev_priv->mm.gtt_mtrr = -1;
-	}
+	arch_phys_wc_del(dev_priv->mm.gtt_mtrr);
+	dev_priv->mm.gtt_mtrr = 0;
 
 	acpi_video_unregister();
 
-- 
1.8.1.4

