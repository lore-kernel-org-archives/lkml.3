Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab3KIG6f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:58:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758603Ab3KIGww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.11 86/94] drm/i915: Add support for pipe_bpp readout
Date: Fri,  8 Nov 2013 22:52:32 -0800
Message-Id: <20131109065210.309683057@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 4f56d12ebb28fceac4c6e60c8993fbfc122e1399 upstream.

On CTG+ read out the pipe bpp setting from hardware and fill it into
pipe config. Also check it appropriately.

v2: Don't do the pipe_bpp extraction inside the PCH only code block on
    ILK+.
    Avoid the PIPECONF read as we already have read it for the
    PIPECONF_EANBLE check.

Note: This is already in drm-intel-next-queued as
commit 42571aefafb1d330ef84eb29418832f72e7dfb4c
Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
Date:   Fri Sep 6 23:29:00 2013 +0300

    drm/i915: Add support for pipe_bpp readout

but is needed for the following bugfix.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_ddi.c     |   17 ++++++++++++++++
 drivers/gpu/drm/i915/intel_display.c |   36 +++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -1280,6 +1280,23 @@ void intel_ddi_get_config(struct intel_e
 		flags |= DRM_MODE_FLAG_NVSYNC;
 
 	pipe_config->adjusted_mode.flags |= flags;
+
+	switch (temp & TRANS_DDI_BPC_MASK) {
+	case TRANS_DDI_BPC_6:
+		pipe_config->pipe_bpp = 18;
+		break;
+	case TRANS_DDI_BPC_8:
+		pipe_config->pipe_bpp = 24;
+		break;
+	case TRANS_DDI_BPC_10:
+		pipe_config->pipe_bpp = 30;
+		break;
+	case TRANS_DDI_BPC_12:
+		pipe_config->pipe_bpp = 36;
+		break;
+	default:
+		break;
+	}
 }
 
 static void intel_ddi_destroy(struct drm_encoder *encoder)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4943,6 +4943,22 @@ static bool i9xx_get_pipe_config(struct
 	if (!(tmp & PIPECONF_ENABLE))
 		return false;
 
+	if (IS_G4X(dev) || IS_VALLEYVIEW(dev)) {
+		switch (tmp & PIPECONF_BPC_MASK) {
+		case PIPECONF_6BPC:
+			pipe_config->pipe_bpp = 18;
+			break;
+		case PIPECONF_8BPC:
+			pipe_config->pipe_bpp = 24;
+			break;
+		case PIPECONF_10BPC:
+			pipe_config->pipe_bpp = 30;
+			break;
+		default:
+			break;
+		}
+	}
+
 	intel_get_pipe_timings(crtc, pipe_config);
 
 	i9xx_get_pfit_config(crtc, pipe_config);
@@ -5821,6 +5837,23 @@ static bool ironlake_get_pipe_config(str
 	if (!(tmp & PIPECONF_ENABLE))
 		return false;
 
+	switch (tmp & PIPECONF_BPC_MASK) {
+	case PIPECONF_6BPC:
+		pipe_config->pipe_bpp = 18;
+		break;
+	case PIPECONF_8BPC:
+		pipe_config->pipe_bpp = 24;
+		break;
+	case PIPECONF_10BPC:
+		pipe_config->pipe_bpp = 30;
+		break;
+	case PIPECONF_12BPC:
+		pipe_config->pipe_bpp = 36;
+		break;
+	default:
+		break;
+	}
+
 	if (I915_READ(PCH_TRANSCONF(crtc->pipe)) & TRANS_ENABLE) {
 		struct intel_shared_dpll *pll;
 
@@ -8147,6 +8180,9 @@ intel_pipe_config_compare(struct drm_dev
 	PIPE_CONF_CHECK_X(dpll_hw_state.fp0);
 	PIPE_CONF_CHECK_X(dpll_hw_state.fp1);
 
+	if (IS_G4X(dev) || INTEL_INFO(dev)->gen >= 5)
+		PIPE_CONF_CHECK_I(pipe_bpp);
+
 #undef PIPE_CONF_CHECK_X
 #undef PIPE_CONF_CHECK_I
 #undef PIPE_CONF_CHECK_FLAGS


