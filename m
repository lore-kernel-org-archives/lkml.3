Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaLGVdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 16:33:33 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56672 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaLGVdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 16:33:32 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: i915: intel_dp.c:  Remove unused function
Date: Sun,  7 Dec 2014 22:36:10 +0100
Message-Id: <1417988170-17451-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function intel_dp_set_drrs_state() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/i915/intel_dp.c  |   89 --------------------------------------
 drivers/gpu/drm/i915/intel_drv.h |    1 -
 2 files changed, 90 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 5ad45bf..6df948b 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -4810,95 +4810,6 @@ intel_dp_init_panel_power_sequencer_registers(struct drm_device *dev,
 		      I915_READ(pp_div_reg));
 }
 
-void intel_dp_set_drrs_state(struct drm_device *dev, int refresh_rate)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct intel_encoder *encoder;
-	struct intel_dp *intel_dp = NULL;
-	struct intel_crtc_config *config = NULL;
-	struct intel_crtc *intel_crtc = NULL;
-	struct intel_connector *intel_connector = dev_priv->drrs.connector;
-	u32 reg, val;
-	enum edp_drrs_refresh_rate_type index = DRRS_HIGH_RR;
-
-	if (refresh_rate <= 0) {
-		DRM_DEBUG_KMS("Refresh rate should be positive non-zero.\n");
-		return;
-	}
-
-	if (intel_connector == NULL) {
-		DRM_DEBUG_KMS("DRRS supported for eDP only.\n");
-		return;
-	}
-
-	/*
-	 * FIXME: This needs proper synchronization with psr state. But really
-	 * hard to tell without seeing the user of this function of this code.
-	 * Check locking and ordering once that lands.
-	 */
-	if (INTEL_INFO(dev)->gen < 8 && intel_edp_is_psr_enabled(dev)) {
-		DRM_DEBUG_KMS("DRRS is disabled as PSR is enabled\n");
-		return;
-	}
-
-	encoder = intel_attached_encoder(&intel_connector->base);
-	intel_dp = enc_to_intel_dp(&encoder->base);
-	intel_crtc = encoder->new_crtc;
-
-	if (!intel_crtc) {
-		DRM_DEBUG_KMS("DRRS: intel_crtc not initialized\n");
-		return;
-	}
-
-	config = &intel_crtc->config;
-
-	if (intel_dp->drrs_state.type < SEAMLESS_DRRS_SUPPORT) {
-		DRM_DEBUG_KMS("Only Seamless DRRS supported.\n");
-		return;
-	}
-
-	if (intel_connector->panel.downclock_mode->vrefresh == refresh_rate)
-		index = DRRS_LOW_RR;
-
-	if (index == intel_dp->drrs_state.refresh_rate_type) {
-		DRM_DEBUG_KMS(
-			"DRRS requested for previously set RR...ignoring\n");
-		return;
-	}
-
-	if (!intel_crtc->active) {
-		DRM_DEBUG_KMS("eDP encoder disabled. CRTC not Active\n");
-		return;
-	}
-
-	if (INTEL_INFO(dev)->gen > 6 && INTEL_INFO(dev)->gen < 8) {
-		reg = PIPECONF(intel_crtc->config.cpu_transcoder);
-		val = I915_READ(reg);
-		if (index > DRRS_HIGH_RR) {
-			val |= PIPECONF_EDP_RR_MODE_SWITCH;
-			intel_dp_set_m_n(intel_crtc);
-		} else {
-			val &= ~PIPECONF_EDP_RR_MODE_SWITCH;
-		}
-		I915_WRITE(reg, val);
-	}
-
-	/*
-	 * mutex taken to ensure that there is no race between differnt
-	 * drrs calls trying to update refresh rate. This scenario may occur
-	 * in future when idleness detection based DRRS in kernel and
-	 * possible calls from user space to set differnt RR are made.
-	 */
-
-	mutex_lock(&intel_dp->drrs_state.mutex);
-
-	intel_dp->drrs_state.refresh_rate_type = index;
-
-	mutex_unlock(&intel_dp->drrs_state.mutex);
-
-	DRM_DEBUG_KMS("eDP Refresh Rate set to : %dHz\n", refresh_rate);
-}
-
 static struct drm_display_mode *
 intel_dp_drrs_init(struct intel_digital_port *intel_dig_port,
 			struct intel_connector *intel_connector,
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index ba71522..6ad239d 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -941,7 +941,6 @@ void intel_edp_panel_on(struct intel_dp *intel_dp);
 void intel_edp_panel_off(struct intel_dp *intel_dp);
 void intel_edp_psr_enable(struct intel_dp *intel_dp);
 void intel_edp_psr_disable(struct intel_dp *intel_dp);
-void intel_dp_set_drrs_state(struct drm_device *dev, int refresh_rate);
 void intel_edp_psr_invalidate(struct drm_device *dev,
 			      unsigned frontbuffer_bits);
 void intel_edp_psr_flush(struct drm_device *dev,
-- 
1.7.10.4

