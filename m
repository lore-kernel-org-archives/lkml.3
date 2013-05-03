Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415Ab3ECXBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 19:01:10 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:53726 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763588Ab3ECXBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 19:01:06 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 5/7] i915: Use drm_mtrr_{add,del}_wc
Date: Fri,  3 May 2013 16:00:33 -0700
Message-Id: <55ce0249bc74fc15af617349cfd5e68a159cf75b.1367621039.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1367621038.git.luto@amacapital.net>
References: <cover.1367621038.git.luto@amacapital.net>
In-Reply-To: <cover.1367621038.git.luto@amacapital.net>
References: <cover.1367621038.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i915 open-coded logic that was essentially equivalent to the new
drm_mtrr_{add,del}_wc.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/gpu/drm/i915/i915_dma.c | 43 ++++++-----------------------------------
 1 file changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 4fa6beb..0fc95ba 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1393,29 +1393,6 @@ void i915_master_destroy(struct drm_device *dev, struct drm_master *master)
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
@@ -1552,8 +1529,8 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 		goto out_rmmap;
 	}
 
-	i915_mtrr_setup(dev_priv, dev_priv->gtt.mappable_base,
-			aperture_size);
+	dev_priv->mm.gtt_mtrr = drm_mtrr_add_wc(dev_priv->gtt.mappable_base,
+						aperture_size);
 
 	/* The i915 workqueue is primarily used for batched retirement of
 	 * requests (and thus managing bo) once the task has been completed
@@ -1656,12 +1633,8 @@ out_gem_unload:
 	intel_teardown_mchbar(dev);
 	destroy_workqueue(dev_priv->wq);
 out_mtrrfree:
-	if (dev_priv->mm.gtt_mtrr >= 0) {
-		mtrr_del(dev_priv->mm.gtt_mtrr,
-			 dev_priv->gtt.mappable_base,
-			 aperture_size);
-		dev_priv->mm.gtt_mtrr = -1;
-	}
+	drm_mtrr_del_wc(dev_priv->mm.gtt_mtrr);
+	dev_priv->mm.gtt_mtrr = -1;
 	io_mapping_free(dev_priv->gtt.mappable);
 out_rmmap:
 	pci_iounmap(dev->pdev, dev_priv->regs);
@@ -1697,12 +1670,8 @@ int i915_driver_unload(struct drm_device *dev)
 	cancel_delayed_work_sync(&dev_priv->mm.retire_work);
 
 	io_mapping_free(dev_priv->gtt.mappable);
-	if (dev_priv->mm.gtt_mtrr >= 0) {
-		mtrr_del(dev_priv->mm.gtt_mtrr,
-			 dev_priv->gtt.mappable_base,
-			 dev_priv->gtt.mappable_end);
-		dev_priv->mm.gtt_mtrr = -1;
-	}
+	drm_mtrr_del_wc(dev_priv->mm.gtt_mtrr);
+	dev_priv->mm.gtt_mtrr = -1;
 
 	acpi_video_unregister();
 
-- 
1.8.1.4

