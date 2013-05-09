Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab3EIXEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:04:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3EIW0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 37/73] drm/i915: set CPT FDI RX polarity bits based on VBT
Date: Thu,  9 May 2013 15:25:27 -0700
Message-Id: <20130509222530.234186874@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit 3f704fa2778d3fe45e6529825a5c7a8bcbc686f4 upstream.

Check the VBT to see if the machine has inverted FDI RX polarity on
CPT. Based on this bit, set the appropriate bit on the TRANS_CHICKEN2
registers.

This should fix some machines that were showing black screens on all
outputs.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=60029
Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.h   |    1 +
 drivers/gpu/drm/i915/i915_reg.h   |    2 +-
 drivers/gpu/drm/i915/intel_bios.c |    6 ++++--
 drivers/gpu/drm/i915/intel_bios.h |    4 +++-
 drivers/gpu/drm/i915/intel_pm.c   |    9 +++++++--
 5 files changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -941,6 +941,7 @@ typedef struct drm_i915_private {
 	unsigned int int_crt_support:1;
 	unsigned int lvds_use_ssc:1;
 	unsigned int display_clock_mode:1;
+	unsigned int fdi_rx_polarity_inverted:1;
 	int lvds_ssc_freq;
 	unsigned int bios_lvds_val; /* initial [PCH_]LVDS reg val in VBIOS */
 	struct {
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3827,7 +3827,7 @@
 #define _TRANSB_CHICKEN2	 0xf1064
 #define TRANS_CHICKEN2(pipe) _PIPE(pipe, _TRANSA_CHICKEN2, _TRANSB_CHICKEN2)
 #define  TRANS_CHICKEN2_TIMING_OVERRIDE		(1<<31)
-
+#define  TRANS_CHICKEN2_FDI_POLARITY_REVERSED	(1<<29)
 
 #define SOUTH_CHICKEN1		0xc2000
 #define  FDIA_PHASE_SYNC_SHIFT_OVR	19
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -351,12 +351,14 @@ parse_general_features(struct drm_i915_p
 		dev_priv->lvds_ssc_freq =
 			intel_bios_ssc_frequency(dev, general->ssc_freq);
 		dev_priv->display_clock_mode = general->display_clock_mode;
-		DRM_DEBUG_KMS("BDB_GENERAL_FEATURES int_tv_support %d int_crt_support %d lvds_use_ssc %d lvds_ssc_freq %d display_clock_mode %d\n",
+		dev_priv->fdi_rx_polarity_inverted = general->fdi_rx_polarity_inverted;
+		DRM_DEBUG_KMS("BDB_GENERAL_FEATURES int_tv_support %d int_crt_support %d lvds_use_ssc %d lvds_ssc_freq %d display_clock_mode %d fdi_rx_polarity_inverted %d\n",
 			      dev_priv->int_tv_support,
 			      dev_priv->int_crt_support,
 			      dev_priv->lvds_use_ssc,
 			      dev_priv->lvds_ssc_freq,
-			      dev_priv->display_clock_mode);
+			      dev_priv->display_clock_mode,
+			      dev_priv->fdi_rx_polarity_inverted);
 	}
 }
 
--- a/drivers/gpu/drm/i915/intel_bios.h
+++ b/drivers/gpu/drm/i915/intel_bios.h
@@ -127,7 +127,9 @@ struct bdb_general_features {
         /* bits 3 */
 	u8 disable_smooth_vision:1;
 	u8 single_dvi:1;
-	u8 rsvd9:6; /* finish byte */
+	u8 rsvd9:1;
+	u8 fdi_rx_polarity_inverted:1;
+	u8 rsvd10:4; /* finish byte */
 
         /* bits 4 */
 	u8 legacy_monitor_detect;
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3562,6 +3562,7 @@ static void cpt_init_clock_gating(struct
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int pipe;
+	uint32_t val;
 
 	/*
 	 * On Ibex Peak and Cougar Point, we need to disable clock
@@ -3574,8 +3575,12 @@ static void cpt_init_clock_gating(struct
 	/* The below fixes the weird display corruption, a few pixels shifted
 	 * downward, on (only) LVDS of some HP laptops with IVY.
 	 */
-	for_each_pipe(pipe)
-		I915_WRITE(TRANS_CHICKEN2(pipe), TRANS_CHICKEN2_TIMING_OVERRIDE);
+	for_each_pipe(pipe) {
+		val = TRANS_CHICKEN2_TIMING_OVERRIDE;
+		if (dev_priv->fdi_rx_polarity_inverted)
+			val |= TRANS_CHICKEN2_FDI_POLARITY_REVERSED;
+		I915_WRITE(TRANS_CHICKEN2(pipe), val);
+	}
 	/* WADP0ClockGatingDisable */
 	for_each_pipe(pipe) {
 		I915_WRITE(TRANS_CHICKEN1(pipe),


