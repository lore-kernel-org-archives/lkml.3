Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3GQGXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 02:23:09 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:62185 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3GQGXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 02:23:07 -0400
Subject: [PATCH v2] drm/i915: fix long-standing SNB regression in power
 consumption after resume
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: rockorequin@hotmail.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, alexkaltsas@gmail.com,
        dri-devel@lists.freedesktop.org
Date: Wed, 17 Jul 2013 10:22:58 +0400
Message-ID: <20130717062258.5467.69414.stgit@zurg>
In-Reply-To: <20130714163009.22374.22100.stgit@zurg>
References: <20130714163009.22374.22100.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes regression in power consumtion of sandy bridge gpu, which
exists since v3.6 Sometimes after resuming from s2ram gpu starts thinking that
it's extremely busy. After that it never reaches rc6 state.

Bug exists since kernel v3.6, commit b4ae3f22d238617ca11610b29fde16cf8c0bc6e0
("drm/i915: load boot context at driver init time").

For some reason RC6 is already enabled at the beginning of resuming process.
Following initliaztion breaks some internal state and confuses RPS engine.
This patch disables RC6 at the beginnig of resume and initialization.

I've rearranged initialization sequence, because intel_disable_gt_powersave()
needs initialized force_wake_get/put and some locks from the dev_priv.

References: https://bugs.freedesktop.org/show_bug.cgi?id=54089
References: https://bugzilla.kernel.org/show_bug.cgi?id=58971
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/i915_dma.c |   16 ++++++++--------
 drivers/gpu/drm/i915/intel_pm.c |    5 +++--
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 3b315ba..d1ee611 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1511,6 +1511,13 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	dev_priv->dev = dev;
 	dev_priv->info = info;
 
+	spin_lock_init(&dev_priv->irq_lock);
+	spin_lock_init(&dev_priv->gpu_error.lock);
+	spin_lock_init(&dev_priv->rps.lock);
+	mutex_init(&dev_priv->dpio_lock);
+	mutex_init(&dev_priv->rps.hw_lock);
+	mutex_init(&dev_priv->modeset_restore_lock);
+
 	i915_dump_device_info(dev_priv);
 
 	if (i915_get_bridge_dev(dev)) {
@@ -1602,6 +1609,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 
 	intel_irq_init(dev);
 	intel_gt_init(dev);
+	intel_gt_reset(dev);
 
 	/* Try to make sure MCHBAR is enabled before poking at it */
 	intel_setup_mchbar(dev);
@@ -1626,14 +1634,6 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	if (!IS_I945G(dev) && !IS_I945GM(dev))
 		pci_enable_msi(dev->pdev);
 
-	spin_lock_init(&dev_priv->irq_lock);
-	spin_lock_init(&dev_priv->gpu_error.lock);
-	spin_lock_init(&dev_priv->rps.lock);
-	mutex_init(&dev_priv->dpio_lock);
-
-	mutex_init(&dev_priv->rps.hw_lock);
-	mutex_init(&dev_priv->modeset_restore_lock);
-
 	dev_priv->num_plane = 1;
 	if (IS_VALLEYVIEW(dev))
 		dev_priv->num_plane = 2;
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index aa01128..b86db1e 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4497,6 +4497,9 @@ void intel_gt_reset(struct drm_device *dev)
 		if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev))
 			__gen6_gt_force_wake_mt_reset(dev_priv);
 	}
+
+	/* BIOS often leaves RC6 enabled, but disable it for hw init */
+	intel_disable_gt_powersave(dev);
 }
 
 void intel_gt_init(struct drm_device *dev)
@@ -4505,8 +4508,6 @@ void intel_gt_init(struct drm_device *dev)
 
 	spin_lock_init(&dev_priv->gt_lock);
 
-	intel_gt_reset(dev);
-
 	if (IS_VALLEYVIEW(dev)) {
 		dev_priv->gt.force_wake_get = vlv_force_wake_get;
 		dev_priv->gt.force_wake_put = vlv_force_wake_put;

