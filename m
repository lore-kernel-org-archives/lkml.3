Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3DBWpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:45:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385Ab3DBWMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Lingzhu Xiang <lxiang@redhat.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 088/124] drm/i915: Use the fixed pixel clock for eDP in intel_dp_set_m_n()
Date: Tue,  2 Apr 2013 15:11:10 -0700
Message-Id: <20130402221114.315691770@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 9d1a455b0ca1c2c956b4d9ab212864a8695270f1 upstream.

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

Backported for 3.8-stable. Reverted refactoring in e69d0bc1.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -788,6 +788,7 @@ intel_dp_set_m_n(struct drm_crtc *crtc,
 	struct intel_dp_m_n m_n;
 	int pipe = intel_crtc->pipe;
 	enum transcoder cpu_transcoder = intel_crtc->cpu_transcoder;
+	int target_clock;
 
 	/*
 	 * Find the lane count in the intel_encoder private
@@ -803,13 +804,22 @@ intel_dp_set_m_n(struct drm_crtc *crtc,
 		}
 	}
 
+	target_clock = mode->clock;
+	for_each_encoder_on_crtc(dev, crtc, intel_encoder) {
+		if (intel_encoder->type == INTEL_OUTPUT_EDP) {
+			target_clock = intel_edp_target_clock(intel_encoder,
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
 
 	if (IS_HASWELL(dev)) {
 		I915_WRITE(PIPE_DATA_M1(cpu_transcoder),


