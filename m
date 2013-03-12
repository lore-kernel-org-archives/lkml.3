Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab3CLPci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:32:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109Ab3CLPce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:32:34 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drm/i915: Use the fixed pixel clock for eDP in intel_dp_set_m_n()
Date: Tue, 12 Mar 2013 16:32:28 +0100
Message-Id: <1363102348-16337-3-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363102348-16337-1-git-send-email-tiwai@suse.de>
References: <1363102348-16337-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The eDP output on HP Z1 is still broken when X is started even after
fixing the infinite link-train loop.  The regression was introduced in
3.6 kernel for cleaning up the mode clock handling code in intel_dp.c.

In the past, the clock of the reference mode was modified in
intel_dp_mode_fixup() in the case of eDP fixed clock, and this clock was
used for calculating in intel_dp_set_m_n().  This override was removed,
thus the wrong mode clock is used for the calculation, resulting in a
psychedelic smoking output in the end.

This patch corrects the clock to be used in the place.

Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/gpu/drm/i915/intel_dp.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 7d250aa..ddbf50f 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -819,6 +819,7 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
 	struct intel_link_m_n m_n;
 	int pipe = intel_crtc->pipe;
 	enum transcoder cpu_transcoder = intel_crtc->cpu_transcoder;
+	int pixel_clock = mode->clock;
 
 	/*
 	 * Find the lane count in the intel_encoder private
@@ -826,6 +827,13 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
 	for_each_encoder_on_crtc(dev, crtc, intel_encoder) {
 		intel_dp = enc_to_intel_dp(&intel_encoder->base);
 
+		if (intel_encoder->type == INTEL_OUTPUT_EDP) {
+			struct drm_display_mode *fixed_mode =
+				intel_dp->attached_connector->panel.fixed_mode;
+			if (fixed_mode)
+				pixel_clock = fixed_mode->clock;
+		}
+
 		if (intel_encoder->type == INTEL_OUTPUT_DISPLAYPORT ||
 		    intel_encoder->type == INTEL_OUTPUT_EDP)
 		{
@@ -840,7 +848,7 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
 	 * set up for 8-bits of R/G/B, or 3 bytes total.
 	 */
 	intel_link_compute_m_n(intel_crtc->bpp, lane_count,
-			       mode->clock, adjusted_mode->clock, &m_n);
+			       pixel_clock, adjusted_mode->clock, &m_n);
 
 	if (IS_HASWELL(dev)) {
 		I915_WRITE(PIPE_DATA_M1(cpu_transcoder),
-- 
1.8.1.4

