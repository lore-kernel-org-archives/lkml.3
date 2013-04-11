Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935965Ab3DKVSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:18:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11236 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935495Ab3DKUs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:57 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=7yrsGbfGnIoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=RegD0mUTlvgA:10 a=VwQbUJbxAAAA:8 a=mnu9mTnb_5AE6RkuOYUA:9 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202609.444854139@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 141/171 ] drm/i915: Use the fixed pixel clock for eDP in intel_dp_set_m_n()
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0141-drm-i915-Use-the-fixed-pixel-clock-for-eDP-in-intel_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9d1a455b0ca1c2c956b4d9ab212864a8695270f1 ]

The eDP output on HP Z1 is still broken when X is started even after
fixing the infinite link-train loop.  The regression was introduced in
3.6 kernel for cleaning up the mode clock handling code in intel_dp.c
by the commit [71244653: drm/i915: adjusted_mode->clock in the dp
mode_fix].

In the past, the clock of the reference mode was modified in
intel_dp_mode_fixup() in the case of eDP fixed clock, and this clock was
used for calculating in intel_dp_set_m_n().  This override was removed,
thus the wrong mode clock is used for the calculation, resulting in a
psychedelic smoking output in the end.

This patch corrects the clock to be used in the place.

v1->v2: Use intel_edp_target_clock() for checking eDP fixed clock
instead of open code as in ironlake_set_m_n().

Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/intel_dp.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 82e5e0d..2e2bf3d 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -800,6 +800,7 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
 	int lane_count = 4;
 	struct intel_dp_m_n m_n;
 	int pipe = intel_crtc->pipe;
+	int target_clock;
 
 	/*
 	 * Find the lane count in the intel_encoder private
@@ -815,13 +816,22 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
 		}
 	}
 
+	target_clock = mode->clock;
+	for_each_encoder_on_crtc(dev, crtc, encoder) {
+		if (encoder->type == INTEL_OUTPUT_EDP) {
+			target_clock = intel_edp_target_clock(encoder,
+							      mode);
+			break;
+		}
+	}
+
 	/*
 	 * Compute the GMCH and Link ratios. The '3' here is
 	 * the number of bytes_per_pixel post-LUT, which we always
 	 * set up for 8-bits of R/G/B, or 3 bytes total.
 	 */
 	intel_dp_compute_m_n(intel_crtc->bpp, lane_count,
-			     mode->clock, adjusted_mode->clock, &m_n);
+			     target_clock, adjusted_mode->clock, &m_n);
 
 	if (HAS_PCH_SPLIT(dev)) {
 		I915_WRITE(TRANSDATA_M1(pipe),
-- 
1.7.10.4


