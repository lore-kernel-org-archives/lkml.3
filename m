Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab3HAVSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:18:06 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:43863 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3HAVSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:18:04 -0400
From: Furquan Shaikh <furquan@google.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Josh Triplett <josh.triplett@intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Ronald Minnich <rminnich@google.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Furquan Shaikh <furquan@google.com>
Subject: [PATCH] drm/i915: add fast boot support for Haswell
Date: Thu,  1 Aug 2013 14:12:22 -0700
Message-Id: <1375391542-21936-1-git-send-email-furquan@google.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enables getting correct mode clock when reading pipe config

Signed-off-by: Furquan Shaikh <furquan@google.com>
---
 drivers/gpu/drm/i915/intel_ddi.c     | 8 ++++++++
 drivers/gpu/drm/i915/intel_display.c | 9 ++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_ddi.c b/drivers/gpu/drm/i915/intel_ddi.c
index 931b4bb..fa0af9b 100644
--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -1269,6 +1269,7 @@ static void intel_ddi_get_config(struct intel_encoder *encoder,
 	struct drm_i915_private *dev_priv = encoder->base.dev->dev_private;
 	struct intel_crtc *intel_crtc = to_intel_crtc(encoder->base.crtc);
 	enum transcoder cpu_transcoder = intel_crtc->config.cpu_transcoder;
+	int port = intel_ddi_get_encoder_port(encoder);
 	u32 temp, flags = 0;
 
 	temp = I915_READ(TRANS_DDI_FUNC_CTL(cpu_transcoder));
@@ -1282,6 +1283,13 @@ static void intel_ddi_get_config(struct intel_encoder *encoder,
 		flags |= DRM_MODE_FLAG_NVSYNC;
 
 	pipe_config->adjusted_mode.flags |= flags;
+
+	if (port == PORT_A) {
+		if ((I915_READ(DP_A) & DP_PLL_FREQ_MASK) == DP_PLL_FREQ_160MHZ)
+			pipe_config->port_clock = 162000;
+		else
+			pipe_config->port_clock = 270000;
+	}
 }
 
 static void intel_ddi_destroy(struct drm_encoder *encoder)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 3e66f05..681c99a 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7176,6 +7176,8 @@ static void i9xx_crtc_clock_get(struct intel_crtc *crtc,
 		pipe_config->pixel_multiplier;
 }
 
+#define div_ceil(A, B) ((A)/(B) + ((A)%(B) ? 1 : 0))
+
 static void ironlake_crtc_clock_get(struct intel_crtc *crtc,
 				    struct intel_crtc_config *pipe_config)
 {
@@ -7218,7 +7220,11 @@ static void ironlake_crtc_clock_get(struct intel_crtc *crtc,
 		return;
 
 	clock = ((u64)link_m * (u64)link_freq * (u64)repeat);
-	do_div(clock, link_n);
+	/* This is required because the value comes out to be in fraction
+	   (eg. 70699.54). Need to round it up since values are compared in
+	   drm_mode_equal
+	*/
+	clock = div_ceil(clock, link_n);
 
 	pipe_config->adjusted_mode.clock = clock;
 }
@@ -9588,6 +9594,7 @@ static void intel_init_display(struct drm_device *dev)
 
 	if (HAS_DDI(dev)) {
 		dev_priv->display.get_pipe_config = haswell_get_pipe_config;
+		dev_priv->display.get_clock = ironlake_crtc_clock_get;
 		dev_priv->display.crtc_mode_set = haswell_crtc_mode_set;
 		dev_priv->display.crtc_enable = haswell_crtc_enable;
 		dev_priv->display.crtc_disable = haswell_crtc_disable;
-- 
1.8.3

