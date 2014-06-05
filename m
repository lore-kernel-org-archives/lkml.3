Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaFEO7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:59:38 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:49264 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaFEO7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:59:36 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4/5] drm/i915: Fixup global gtt cleanup
Date: Thu,  5 Jun 2014 16:58:27 +0200
Message-Id: <1401980308-5116-4-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The global gtt is setup up in 2 parts, so we need to be careful
with the cleanup. For consistency shovel it all into the ->cleanup
callback, like with ppgtt.

Noticed because it blew up in the out_gtt: cleanup code while
fiddling with the vgacon code.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_dma.c     | 4 ----
 drivers/gpu/drm/i915/i915_gem_gtt.c | 9 ++++++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index b9159ade5e85..27fe65ac5940 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1386,7 +1386,6 @@ cleanup_gem:
 	i915_gem_context_fini(dev);
 	mutex_unlock(&dev->struct_mutex);
 	WARN_ON(dev_priv->mm.aliasing_ppgtt);
-	drm_mm_takedown(&dev_priv->gtt.base.mm);
 cleanup_irq:
 	drm_irq_uninstall(dev);
 cleanup_gem_stolen:
@@ -1756,8 +1755,6 @@ out_mtrrfree:
 	arch_phys_wc_del(dev_priv->gtt.mtrr);
 	io_mapping_free(dev_priv->gtt.mappable);
 out_gtt:
-	list_del(&dev_priv->gtt.base.global_link);
-	drm_mm_takedown(&dev_priv->gtt.base.mm);
 	dev_priv->gtt.base.cleanup(&dev_priv->gtt.base);
 out_regs:
 	intel_uncore_fini(dev);
@@ -1846,7 +1843,6 @@ int i915_driver_unload(struct drm_device *dev)
 			i915_free_hws(dev);
 	}
 
-	list_del(&dev_priv->gtt.base.global_link);
 	WARN_ON(!list_empty(&dev_priv->vm_list));
 
 	drm_vblank_cleanup(dev);
diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index 931b906f292a..41e864ec5632 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -1985,7 +1985,10 @@ static void gen6_gmch_remove(struct i915_address_space *vm)
 
 	struct i915_gtt *gtt = container_of(vm, struct i915_gtt, base);
 
-	drm_mm_takedown(&vm->mm);
+	if (drm_mm_initialized(&vm->mm)) {
+		drm_mm_takedown(&vm->mm);
+		list_del(&vm->global_link);
+	}
 	iounmap(gtt->gsm);
 	teardown_scratch_page(vm->dev);
 }
@@ -2018,6 +2021,10 @@ static int i915_gmch_probe(struct drm_device *dev,
 
 static void i915_gmch_remove(struct i915_address_space *vm)
 {
+	if (drm_mm_initialized(&vm->mm)) {
+		drm_mm_takedown(&vm->mm);
+		list_del(&vm->global_link);
+	}
 	intel_gmch_remove();
 }
 
-- 
1.8.1.4

