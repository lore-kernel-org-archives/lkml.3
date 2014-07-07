Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbaGHBId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:08:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaGGXx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Damien Lespiau <damien.lespiau@intel.com>,
        Mengdong Lin <mengdong.lin@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.15 049/122] drm/i915: provide interface for audio driver to query cdclk
Date: Mon,  7 Jul 2014 16:56:51 -0700
Message-Id: <20140707235735.754267314@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_pm.c |   21 +++++++++++++++++++++
 include/drm/i915_powerwell.h    |    1 +
 2 files changed, 22 insertions(+)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5734,6 +5734,27 @@ int i915_release_power_well(void)
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
+
 #define POWER_DOMAIN_MASK (BIT(POWER_DOMAIN_NUM) - 1)
 
 #define HSW_ALWAYS_ON_POWER_DOMAINS (			\
--- a/include/drm/i915_powerwell.h
+++ b/include/drm/i915_powerwell.h
@@ -32,5 +32,6 @@
 /* For use by hda_i915 driver */
 extern int i915_request_power_well(void);
 extern int i915_release_power_well(void);
+extern int i915_get_cdclk_freq(void);
 
 #endif				/* _I915_POWERWELL_H_ */


