Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbaKRPRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:17:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894AbaKROJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        Mengdong Lin <mengdong.lin@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 005/206] drm/i915: provide interface for audio driver to query cdclk
Date: Tue, 18 Nov 2014 15:06:00 +0100
Message-Id: <e48c442a046d006ff87cd67a686a27a5f64dedbb.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_pm.c | 20 ++++++++++++++++++++
 include/drm/i915_powerwell.h    |  1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index aa99bb61778c..a7daa2a3ac82 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5378,6 +5378,26 @@ int i915_release_power_well(void)
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
+				power_well);
+
+	return intel_ddi_get_cdclk_freq(dev_priv);
+}
+EXPORT_SYMBOL_GPL(i915_get_cdclk_freq);
+
 int i915_init_power_well(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
diff --git a/include/drm/i915_powerwell.h b/include/drm/i915_powerwell.h
index 2baba9996094..baa6f11b1837 100644
--- a/include/drm/i915_powerwell.h
+++ b/include/drm/i915_powerwell.h
@@ -32,5 +32,6 @@
 /* For use by hda_i915 driver */
 extern int i915_request_power_well(void);
 extern int i915_release_power_well(void);
+extern int i915_get_cdclk_freq(void);
 
 #endif				/* _I915_POWERWELL_H_ */
-- 
2.1.3

