Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3GIUOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 16:14:23 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57499 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3GIUOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 16:14:21 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Guenter Roeck <linux@roeck-us.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Mika Kuoppala <mika.kuoppala@intel.com>
Subject: [PATCH] Revert "drm/i915: unconditionally use mt forcewake on hsw/ivb"
Date: Tue,  9 Jul 2013 13:14:09 -0700
Message-Id: <1373400849-30351-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 36ec8f877481449bdfa072e6adf2060869e2b970.

The commit results in repeated 'Timed out waiting for forcewake old ack
to clear' messages on a Supermicro C7H61 board (BIOS version 2.00 and 2.00b)
with i7-3770K CPU. It ultimately results in a hangup if the system is highly
loaded. Reverting the commit fixes the issue.

While I understand that this should be fixed in the BIOS, a more recent BIOS
is not available fron the vendor. If/since no better solution is not available,
reverting the patch seems to be the way to go (otherwise me and others with
the same problem won't be able to run the upstream kernel on affected boards).

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/gpu/drm/i915/intel_pm.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index aa01128..5bae9ba 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4510,12 +4510,35 @@ void intel_gt_init(struct drm_device *dev)
 	if (IS_VALLEYVIEW(dev)) {
 		dev_priv->gt.force_wake_get = vlv_force_wake_get;
 		dev_priv->gt.force_wake_put = vlv_force_wake_put;
-	} else if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev)) {
-		dev_priv->gt.force_wake_get = __gen6_gt_force_wake_mt_get;
-		dev_priv->gt.force_wake_put = __gen6_gt_force_wake_mt_put;
-	} else if (IS_GEN6(dev)) {
+	} else if (INTEL_INFO(dev)->gen >= 6) {
 		dev_priv->gt.force_wake_get = __gen6_gt_force_wake_get;
 		dev_priv->gt.force_wake_put = __gen6_gt_force_wake_put;
+
+		/* IVB configs may use multi-threaded forcewake */
+		if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev)) {
+			u32 ecobus;
+
+			/* A small trick here - if the bios hasn't configured
+			 * MT forcewake, and if the device is in RC6, then
+			 * force_wake_mt_get will not wake the device and the
+			 * ECOBUS read will return zero. Which will be
+			 * (correctly) interpreted by the test below as MT
+			 * forcewake being disabled.
+			 */
+			mutex_lock(&dev->struct_mutex);
+			__gen6_gt_force_wake_mt_get(dev_priv);
+			ecobus = I915_READ_NOTRACE(ECOBUS);
+			__gen6_gt_force_wake_mt_put(dev_priv);
+			mutex_unlock(&dev->struct_mutex);
+
+			if (ecobus & FORCEWAKE_MT_ENABLE) {
+				DRM_DEBUG_KMS("Using MT version of forcewake\n");
+				dev_priv->gt.force_wake_get =
+					__gen6_gt_force_wake_mt_get;
+				dev_priv->gt.force_wake_put =
+					__gen6_gt_force_wake_mt_put;
+			}
+		}
 	}
 	INIT_DELAYED_WORK(&dev_priv->rps.delayed_resume_work,
 			  intel_gen6_powersave_work);
-- 
1.7.9.7

