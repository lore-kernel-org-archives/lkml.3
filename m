Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab3ERDOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:14:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758677Ab3ERDAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:15 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=pbIpPbkYVeEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=DJBzg06Il1wA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=e5mUnYsNAAAA:8 a=3hlnfNmnuLRZW7lqLqAA:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021659.965773013@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>, Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 114/136 ] drm/i915: set CPT FDI RX polarity bits based on VBT
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0114-drm-i915-set-CPT-FDI-RX-polarity-bits-based-on-VBT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

[ Upstream commit 3f704fa2778d3fe45e6529825a5c7a8bcbc686f4 ]

Check the VBT to see if the machine has inverted FDI RX polarity on
CPT. Based on this bit, set the appropriate bit on the TRANS_CHICKEN2
registers.

This should fix some machines that were showing black screens on all
outputs.

Cc: stable@vger.kernel.org
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=60029
Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/i915_drv.h   |    1 +
 drivers/gpu/drm/i915/i915_reg.h   |    1 +
 drivers/gpu/drm/i915/intel_bios.c |    6 ++++--
 drivers/gpu/drm/i915/intel_bios.h |    4 +++-
 drivers/gpu/drm/i915/intel_pm.c   |    9 +++++++--
 5 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index ae85929..ec7cc29 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -464,6 +464,7 @@ typedef struct drm_i915_private {
 	unsigned int int_crt_support:1;
 	unsigned int lvds_use_ssc:1;
 	unsigned int display_clock_mode:1;
+	unsigned int fdi_rx_polarity_inverted:1;
 	int lvds_ssc_freq;
 	unsigned int bios_lvds_val; /* initial [PCH_]LVDS reg val in VBIOS */
 	unsigned int lvds_val; /* used for checking LVDS channel mode */
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index f02cfad..3814aa3 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3758,6 +3758,7 @@
 #define _TRANSB_CHICKEN2	 0xf1064
 #define TRANS_CHICKEN2(pipe) _PIPE(pipe, _TRANSA_CHICKEN2, _TRANSB_CHICKEN2)
 #define   TRANS_AUTOTRAIN_GEN_STALL_DIS	(1<<31)
+#define  TRANS_CHICKEN2_FDI_POLARITY_REVERSED	(1<<29)
 
 #define SOUTH_CHICKEN1		0xc2000
 #define  FDIA_PHASE_SYNC_SHIFT_OVR	19
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index d0df62a..d10cf1d 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -352,12 +352,14 @@ parse_general_features(struct drm_i915_private *dev_priv,
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
 
diff --git a/drivers/gpu/drm/i915/intel_bios.h b/drivers/gpu/drm/i915/intel_bios.h
index 31c2107..e0af201 100644
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
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index c23c9ea..e782b76 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3712,6 +3712,7 @@ static void cpt_init_clock_gating(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int pipe;
+	uint32_t val;
 
 	/*
 	 * On Ibex Peak and Cougar Point, we need to disable clock
@@ -3722,8 +3723,12 @@ static void cpt_init_clock_gating(struct drm_device *dev)
 	I915_WRITE(SOUTH_CHICKEN2, I915_READ(SOUTH_CHICKEN2) |
 		   DPLS_EDP_PPS_FIX_DIS);
 	/* Without this, mode sets may fail silently on FDI */
-	for_each_pipe(pipe)
-		I915_WRITE(TRANS_CHICKEN2(pipe), TRANS_AUTOTRAIN_GEN_STALL_DIS);
+	for_each_pipe(pipe) {
+		val = TRANS_AUTOTRAIN_GEN_STALL_DIS;
+		if (dev_priv->fdi_rx_polarity_inverted)
+			val |= TRANS_CHICKEN2_FDI_POLARITY_REVERSED;
+		I915_WRITE(TRANS_CHICKEN2(pipe), val);
+	}
 }
 
 void intel_init_clock_gating(struct drm_device *dev)
-- 
1.7.10.4


