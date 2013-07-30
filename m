Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3G3SmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:42:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56448 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab3G3SmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:42:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 33/75] drm/i915: fix long-standing SNB regression in power consumption after resume v2
Date: Tue, 30 Jul 2013 11:42:01 -0700
Message-Id: <1375209721-1594-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

commit 7dcd2677ea912573d9ed4bcd629b0023b2d11505 upstream.

This patch fixes regression in power consumtion of sandy bridge gpu, which
exists since v3.6 Sometimes after resuming from s2ram gpu starts thinking that
it's extremely busy. After that it never reaches rc6 state.

Bug exists since kernel v3.6:

commit b4ae3f22d238617ca11610b29fde16cf8c0bc6e0
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Jun 14 11:04:48 2012 -0700

    drm/i915: load boot context at driver init time

For some reason RC6 is already enabled at the beginning of resuming process.
Following initliaztion breaks some internal state and confuses RPS engine.
This patch disables RC6 at the beginnig of resume and initialization.

I've rearranged initialization sequence, because intel_disable_gt_powersave()
needs initialized force_wake_get/put and some locks from the dev_priv.

Note: The culprit in the initialization sequence seems to be the write
to MBCTL added in the above mentioned commit. The first version of
this patch just held a forcewake reference across the clock gating
init functions, which seems to have been enought to gather quite a few
positive test reports. But since that smelled a bit like ad-hoc
duct-tape v2 now just disables rps/rc6 across the entire hw setup.

References: https://bugs.freedesktop.org/show_bug.cgi?id=54089
References: https://bugzilla.kernel.org/show_bug.cgi?id=58971
References: https://patchwork.kernel.org/patch/2827634/ (patch v1)
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
[danvet: Add note about v1 vs. v2 of this patch and use standard
layout for the commit citation. Also add the tested-bys from v1 and a
cc stable.]
Tested-by: Alexander Kaltsas <alexkaltsas@gmail.com> (v1)
Tested-by: rocko <rockorequin@hotmail.com> (v1)
Tested-by: JohnMB <johnmbryant@sky.com> (v1)
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c | 14 +++++++-------
 drivers/gpu/drm/i915/intel_pm.c |  5 +++--
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 99daa89..c1a8b6a 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1465,6 +1465,12 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	dev_priv->dev = dev;
 	dev_priv->info = info;
 
+	spin_lock_init(&dev_priv->irq_lock);
+	spin_lock_init(&dev_priv->error_lock);
+	spin_lock_init(&dev_priv->rps.lock);
+	spin_lock_init(&dev_priv->dpio_lock);
+	mutex_init(&dev_priv->rps.hw_lock);
+
 	i915_dump_device_info(dev_priv);
 
 	if (i915_get_bridge_dev(dev)) {
@@ -1555,6 +1561,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 
 	intel_irq_init(dev);
 	intel_gt_init(dev);
+	intel_gt_reset(dev);
 
 	/* Try to make sure MCHBAR is enabled before poking at it */
 	intel_setup_mchbar(dev);
@@ -1579,13 +1586,6 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	if (!IS_I945G(dev) && !IS_I945GM(dev))
 		pci_enable_msi(dev->pdev);
 
-	spin_lock_init(&dev_priv->irq_lock);
-	spin_lock_init(&dev_priv->error_lock);
-	spin_lock_init(&dev_priv->rps.lock);
-	spin_lock_init(&dev_priv->dpio_lock);
-
-	mutex_init(&dev_priv->rps.hw_lock);
-
 	if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev))
 		dev_priv->num_pipe = 3;
 	else if (IS_MOBILE(dev) || !IS_GEN2(dev))
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index e8c7ade..e9f93ee 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4398,6 +4398,9 @@ void intel_gt_reset(struct drm_device *dev)
 		if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev))
 			__gen6_gt_force_wake_mt_reset(dev_priv);
 	}
+
+	/* BIOS often leaves RC6 enabled, but disable it for hw init */
+	intel_disable_gt_powersave(dev);
 }
 
 void intel_gt_init(struct drm_device *dev)
@@ -4406,8 +4409,6 @@ void intel_gt_init(struct drm_device *dev)
 
 	spin_lock_init(&dev_priv->gt_lock);
 
-	intel_gt_reset(dev);
-
 	if (IS_VALLEYVIEW(dev)) {
 		dev_priv->gt.force_wake_get = vlv_force_wake_get;
 		dev_priv->gt.force_wake_put = vlv_force_wake_put;
-- 
1.8.1.2

