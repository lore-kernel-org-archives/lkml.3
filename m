Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207AbaLBT7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:59:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46486 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaLBTUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:20:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>, Mengdong Lin <mengdong.lin@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 006/121] drm/i915: provide interface for audio driver to query cdclk
Date: Tue,  2 Dec 2014 11:18:05 -0800
Message-Id: <1417548000-1794-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit c149dcb5c60bfea8871f16dfcc0690255eeb825f upstream.

For Haswell and Broadwell, if the display power well has been disabled,
the display audio controller divider values EM4 M VALUE and EM5 N VALUE
will have been lost. The CDCLK frequency is required for reprogramming them
to generate 24MHz HD-A link BCLK. So provide a private interface for the
audio driver to query CDCLK.

This is a stopgap solution until a more generic interface between audio
and display drivers has been implemented.

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>
Signed-off-by: Mengdong Lin <mengdong.lin@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 20 ++++++++++++++++++++
 include/drm/i915_powerwell.h    |  1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 839e581..ba51112 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5884,6 +5884,26 @@ int i915_release_power_well(void)
 }
 EXPORT_SYMBOL_GPL(i915_release_power_well);
 
+/*
+ * Private interface for the audio driver to get CDCLK in kHz.
+ *
+ * Caller must request power well using i915_request_power_well() prior to
+ * making the call.
+ */
+int i915_get_cdclk_freq(void)
+{
+	struct drm_i915_private *dev_priv;
+
+	if (!hsw_pwr)
+		return -ENODEV;
+
+	dev_priv = container_of(hsw_pwr, struct drm_i915_private,
+				power_domains);
+
+	return intel_ddi_get_cdclk_freq(dev_priv);
+}
+EXPORT_SYMBOL_GPL(i915_get_cdclk_freq);
+
 int intel_power_domains_init(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
diff --git a/include/drm/i915_powerwell.h b/include/drm/i915_powerwell.h
index 2baba99..baa6f11 100644
--- a/include/drm/i915_powerwell.h
+++ b/include/drm/i915_powerwell.h
@@ -32,5 +32,6 @@
 /* For use by hda_i915 driver */
 extern int i915_request_power_well(void);
 extern int i915_release_power_well(void);
+extern int i915_get_cdclk_freq(void);
 
 #endif				/* _I915_POWERWELL_H_ */
-- 
1.9.1

