Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3GIXAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 19:00:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64073 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3GIXAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 19:00:36 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2] Partially revert "drm/i915: unconditionally use mt forcewake on hsw/ivb"
Date: Tue,  9 Jul 2013 16:00:31 -0700
Message-Id: <1373410831-1347-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch partially reverts commit 36ec8f877481449bdfa072e6adf2060869e2b970 for
IvyBridge CPUs.

The original commit results in repeated 'Timed out waiting for forcewake old
ack to clear' messages on a Supermicro C7H61 board (BIOS version 2.00 and 2.00b)
with i7-3770K CPU. It ultimately results in a hangup if the system is highly
loaded. Reverting the commit for IvyBridge CPUs fixes the issue.

Issue a warning if the CPU is IvyBridge and mt forcewake is disabled, since
this condition can result in secondary issues.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=60541
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Only revert patch for Ivybridge CPUs
    Issue info message if mt forcewake is disabled on Ivybridge

 drivers/gpu/drm/i915/intel_pm.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index aa01128..0392c28 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4510,9 +4510,38 @@ void intel_gt_init(struct drm_device *dev)
 	if (IS_VALLEYVIEW(dev)) {
 		dev_priv->gt.force_wake_get = vlv_force_wake_get;
 		dev_priv->gt.force_wake_put = vlv_force_wake_put;
-	} else if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev)) {
+	} else if (IS_HASWELL(dev)) {
 		dev_priv->gt.force_wake_get = __gen6_gt_force_wake_mt_get;
 		dev_priv->gt.force_wake_put = __gen6_gt_force_wake_mt_put;
+	} else if (IS_IVYBRIDGE(dev)) {
+		u32 ecobus;
+
+		/* IVB configs may use multi-threaded forcewake */
+
+		/* A small trick here - if the bios hasn't configured
+		 * MT forcewake, and if the device is in RC6, then
+		 * force_wake_mt_get will not wake the device and the
+		 * ECOBUS read will return zero. Which will be
+		 * (correctly) interpreted by the test below as MT
+		 * forcewake being disabled.
+		 */
+		mutex_lock(&dev->struct_mutex);
+		__gen6_gt_force_wake_mt_get(dev_priv);
+		ecobus = I915_READ_NOTRACE(ECOBUS);
+		__gen6_gt_force_wake_mt_put(dev_priv);
+		mutex_unlock(&dev->struct_mutex);
+
+		if (ecobus & FORCEWAKE_MT_ENABLE) {
+			dev_priv->gt.force_wake_get =
+						__gen6_gt_force_wake_mt_get;
+			dev_priv->gt.force_wake_put =
+						__gen6_gt_force_wake_mt_put;
+		} else {
+			DRM_INFO("No MT forcewake available on Ivybridge, this can result in issues\n");
+			DRM_INFO("when using vblank-synced partial screen updates.\n");
+			dev_priv->gt.force_wake_get = __gen6_gt_force_wake_get;
+			dev_priv->gt.force_wake_put = __gen6_gt_force_wake_put;
+		}
 	} else if (IS_GEN6(dev)) {
 		dev_priv->gt.force_wake_get = __gen6_gt_force_wake_get;
 		dev_priv->gt.force_wake_put = __gen6_gt_force_wake_put;
-- 
1.7.9.7

