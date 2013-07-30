Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab3G3PTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:19:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55343 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab3G3PSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 06/75] Partially revert "drm/i915: unconditionally use mt forcewake on hsw/ivb"
Date: Tue, 30 Jul 2013 08:16:35 -0700
Message-Id: <1375197464-27962-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit c11e5f35ab490bd30591563816fbc83526521777 upstream.

This patch partially reverts commit 36ec8f877481449bdfa072e6adf2060869e2b970 for
IvyBridge CPUs.

The original commit results in repeated 'Timed out waiting for forcewake old
ack to clear' messages on a Supermicro C7H61 board (BIOS version 2.00 and 2.00b)
with i7-3770K CPU. It ultimately results in a hangup if the system is highly
loaded. Reverting the commit for IvyBridge CPUs fixes the issue.

Issue a warning if the CPU is IvyBridge and mt forcewake is disabled, since
this condition can result in secondary issues.

v2: Only revert patch for Ivybridge CPUs
    Issue info message if mt forcewake is disabled on Ivybridge

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=60541
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=66139
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 253bcf3..e8c7ade 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4411,9 +4411,38 @@ void intel_gt_init(struct drm_device *dev)
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
1.8.1.2

