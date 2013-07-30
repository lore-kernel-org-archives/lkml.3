Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab3G3SqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:46:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56564 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973Ab3G3Spg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:45:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 41/75] drm/i915: fix up gt init sequence fallout
Date: Tue, 30 Jul 2013 11:44:45 -0700
Message-Id: <1375209919-1768-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 181d1b9e31c668259d3798c521672afb8edd355c upstream.

The regression fix for gen6+ rps fallout

commit 7dcd2677ea912573d9ed4bcd629b0023b2d11505
Author: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date:   Wed Jul 17 10:22:58 2013 +0400

    drm/i915: fix long-standing SNB regression in power consumption after resume

unintentionally also changed the init sequence ordering between
gt_init and gt_reset - we need to reset BIOS damage like leftover
forcewake references before we run our own code. Otherwise we can get
nasty dmesg noise like

[drm:__gen6_gt_force_wake_mt_get] *ERROR* Timed out waiting for forcewake old ack to clear.

again. Since _reset suggests that we first need to have stuff
initialized (which isn't the case here) call it sanitze instead.

While at it also block out the rps disable introduced by the above
commit on ilk: We don't have any knowledge of ilk rps being broken in
similar ways. And the disable functions uses the default hw state
which is only read out when we're enabling rps. So essentially we've
been writing random grabage into that register.

Reported-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Tested-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c | 2 +-
 drivers/gpu/drm/i915/i915_drv.c | 4 ++--
 drivers/gpu/drm/i915/i915_drv.h | 2 +-
 drivers/gpu/drm/i915/intel_pm.c | 5 +++--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index c1a8b6a..38254c0 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1560,8 +1560,8 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	intel_detect_pch(dev);
 
 	intel_irq_init(dev);
+	intel_gt_sanitize(dev);
 	intel_gt_init(dev);
-	intel_gt_reset(dev);
 
 	/* Try to make sure MCHBAR is enabled before poking at it */
 	intel_setup_mchbar(dev);
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 5e50875..be9ddec 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -617,7 +617,7 @@ static int i915_drm_thaw(struct drm_device *dev)
 {
 	int error = 0;
 
-	intel_gt_reset(dev);
+	intel_gt_sanitize(dev);
 
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 		mutex_lock(&dev->struct_mutex);
@@ -643,7 +643,7 @@ int i915_resume(struct drm_device *dev)
 
 	pci_set_master(dev->pdev);
 
-	intel_gt_reset(dev);
+	intel_gt_sanitize(dev);
 
 	/*
 	 * Platforms with opregion should have sane BIOS, older ones (gen3 and
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 09d99c4..8c661512 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1329,7 +1329,7 @@ void i915_handle_error(struct drm_device *dev, bool wedged);
 
 extern void intel_irq_init(struct drm_device *dev);
 extern void intel_gt_init(struct drm_device *dev);
-extern void intel_gt_reset(struct drm_device *dev);
+extern void intel_gt_sanitize(struct drm_device *dev);
 
 void i915_error_state_free(struct kref *error_ref);
 
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index e9f93ee..7af828c 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4387,7 +4387,7 @@ static void vlv_force_wake_put(struct drm_i915_private *dev_priv)
 	gen6_gt_check_fifodbg(dev_priv);
 }
 
-void intel_gt_reset(struct drm_device *dev)
+void intel_gt_sanitize(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
@@ -4400,7 +4400,8 @@ void intel_gt_reset(struct drm_device *dev)
 	}
 
 	/* BIOS often leaves RC6 enabled, but disable it for hw init */
-	intel_disable_gt_powersave(dev);
+	if (INTEL_INFO(dev)->gen >= 6)
+		intel_disable_gt_powersave(dev);
 }
 
 void intel_gt_init(struct drm_device *dev)
-- 
1.8.1.2

