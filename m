Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab3E1VZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:25:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59693 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3E1VY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:24:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 77/78] drm/i915: add HAS_DDI check
Date: Tue, 28 May 2013 14:20:26 -0700
Message-Id: <1369776027-17859-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit affa935440733a79c5a9eb0e5357e2564ca4b355 upstream.

And use it whenever we call code that uses the DDIs. We already have
intel_ddi.c and prefix every function with intel_ddi_something instead of
haswell_something, so I think replacing the checks with HAS_DDI makes more
sense. Just a cosmetical change, yes I know, but I have this OCD...

Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.h      |  2 ++
 drivers/gpu/drm/i915/intel_crt.c     |  2 +-
 drivers/gpu/drm/i915/intel_ddi.c     |  2 +-
 drivers/gpu/drm/i915/intel_display.c | 19 +++++++++----------
 drivers/gpu/drm/i915/intel_dp.c      |  8 ++++----
 drivers/gpu/drm/i915/intel_hdmi.c    |  4 ++--
 6 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index e78419f..5f1fad3 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1229,6 +1229,8 @@ struct drm_i915_file_private {
 
 #define HAS_PIPE_CONTROL(dev) (INTEL_INFO(dev)->gen >= 5)
 
+#define HAS_DDI(dev)		(IS_HASWELL(dev))
+
 #define INTEL_PCH_DEVICE_ID_MASK		0xff00
 #define INTEL_PCH_IBX_DEVICE_ID_TYPE		0x3b00
 #define INTEL_PCH_CPT_DEVICE_ID_TYPE		0x1c00
diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index 625b091..8ed7c30 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -770,7 +770,7 @@ void intel_crt_init(struct drm_device *dev)
 
 	crt->base.disable = intel_disable_crt;
 	crt->base.enable = intel_enable_crt;
-	if (IS_HASWELL(dev))
+	if (HAS_DDI(dev))
 		crt->base.get_hw_state = intel_ddi_get_hw_state;
 	else
 		crt->base.get_hw_state = intel_crt_get_hw_state;
diff --git a/drivers/gpu/drm/i915/intel_ddi.c b/drivers/gpu/drm/i915/intel_ddi.c
index 59b778d..debf25f 100644
--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -114,7 +114,7 @@ void intel_prepare_ddi(struct drm_device *dev)
 {
 	int port;
 
-	if (IS_HASWELL(dev)) {
+	if (HAS_DDI(dev)) {
 		for (port = PORT_A; port < PORT_E; port++)
 			intel_prepare_ddi_buffers(dev, port, false);
 
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index faeaebc..e05d0ba 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1125,8 +1125,8 @@ static void assert_fdi_tx(struct drm_i915_private *dev_priv,
 	enum transcoder cpu_transcoder = intel_pipe_to_cpu_transcoder(dev_priv,
 								      pipe);
 
-	if (IS_HASWELL(dev_priv->dev)) {
-		/* On Haswell, DDI is used instead of FDI_TX_CTL */
+	if (HAS_DDI(dev_priv->dev)) {
+		/* DDI does not have a specific FDI_TX register */
 		reg = TRANS_DDI_FUNC_CTL(cpu_transcoder);
 		val = I915_READ(reg);
 		cur_state = !!(val & TRANS_DDI_FUNC_ENABLE);
@@ -1170,7 +1170,7 @@ static void assert_fdi_tx_pll_enabled(struct drm_i915_private *dev_priv,
 		return;
 
 	/* On Haswell, DDI ports are responsible for the FDI PLL setup */
-	if (IS_HASWELL(dev_priv->dev))
+	if (HAS_DDI(dev_priv->dev))
 		return;
 
 	reg = FDI_TX_CTL(pipe);
@@ -8316,7 +8316,7 @@ static const struct drm_crtc_funcs intel_crtc_funcs = {
 
 static void intel_cpu_pll_init(struct drm_device *dev)
 {
-	if (IS_HASWELL(dev))
+	if (HAS_DDI(dev))
 		intel_ddi_pll_init(dev);
 }
 
@@ -8452,11 +8452,10 @@ static void intel_setup_outputs(struct drm_device *dev)
 		I915_WRITE(PFIT_CONTROL, 0);
 	}
 
-	if (!(IS_HASWELL(dev) &&
-	      (I915_READ(DDI_BUF_CTL(PORT_A)) & DDI_A_4_LANES)))
+	if (!(HAS_DDI(dev) && (I915_READ(DDI_BUF_CTL(PORT_A)) & DDI_A_4_LANES)))
 		intel_crt_init(dev);
 
-	if (IS_HASWELL(dev)) {
+	if (HAS_DDI(dev)) {
 		int found;
 
 		/* Haswell uses DDI functions to detect digital outputs */
@@ -8716,7 +8715,7 @@ static void intel_init_display(struct drm_device *dev)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
 	/* We always want a DPMS function */
-	if (IS_HASWELL(dev)) {
+	if (HAS_DDI(dev)) {
 		dev_priv->display.crtc_mode_set = haswell_crtc_mode_set;
 		dev_priv->display.crtc_enable = haswell_crtc_enable;
 		dev_priv->display.crtc_disable = haswell_crtc_disable;
@@ -9234,7 +9233,7 @@ void intel_modeset_setup_hw_state(struct drm_device *dev,
 	struct intel_encoder *encoder;
 	struct intel_connector *connector;
 
-	if (IS_HASWELL(dev)) {
+	if (HAS_DDI(dev)) {
 		tmp = I915_READ(TRANS_DDI_FUNC_CTL(TRANSCODER_EDP));
 
 		if (tmp & TRANS_DDI_FUNC_ENABLE) {
@@ -9275,7 +9274,7 @@ void intel_modeset_setup_hw_state(struct drm_device *dev,
 			      crtc->active ? "enabled" : "disabled");
 	}
 
-	if (IS_HASWELL(dev))
+	if (HAS_DDI(dev))
 		intel_ddi_setup_hw_pll_state(dev);
 
 	list_for_each_entry(encoder, &dev->mode_config.encoder_list,
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index cbe1ec3..616aaea 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -379,7 +379,7 @@ intel_dp_aux_ch(struct intel_dp *intel_dp,
 	 * clock divider.
 	 */
 	if (is_cpu_edp(intel_dp)) {
-		if (IS_HASWELL(dev))
+		if (HAS_DDI(dev))
 			aux_clock_divider = intel_ddi_get_cdclk_freq(dev_priv) >> 1;
 		else if (IS_VALLEYVIEW(dev))
 			aux_clock_divider = 100;
@@ -1801,7 +1801,7 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 	int voltage_tries, loop_tries;
 	uint32_t DP = intel_dp->DP;
 
-	if (IS_HASWELL(dev))
+	if (HAS_DDI(dev))
 		intel_ddi_prepare_link_retrain(encoder);
 
 	/* Write the link configuration data */
@@ -1991,7 +1991,7 @@ intel_dp_link_down(struct intel_dp *intel_dp)
 	 *   intel_ddi_prepare_link_retrain will take care of redoing the link
 	 *   train.
 	 */
-	if (IS_HASWELL(dev))
+	if (HAS_DDI(dev))
 		return;
 
 	if (WARN_ON((I915_READ(intel_dp->output_reg) & DP_PORT_EN) == 0))
@@ -2762,7 +2762,7 @@ intel_dp_init_connector(struct intel_digital_port *intel_dig_port,
 	intel_connector_attach_encoder(intel_connector, intel_encoder);
 	drm_sysfs_connector_add(connector);
 
-	if (IS_HASWELL(dev))
+	if (HAS_DDI(dev))
 		intel_connector->get_hw_state = intel_ddi_connector_get_hw_state;
 	else
 		intel_connector->get_hw_state = intel_connector_get_hw_state;
diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index 8246706..dccd859 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -48,7 +48,7 @@ assert_hdmi_port_disabled(struct intel_hdmi *intel_hdmi)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	uint32_t enabled_bits;
 
-	enabled_bits = IS_HASWELL(dev) ? DDI_BUF_CTL_ENABLE : SDVO_ENABLE;
+	enabled_bits = HAS_DDI(dev) ? DDI_BUF_CTL_ENABLE : SDVO_ENABLE;
 
 	WARN(I915_READ(intel_hdmi->sdvox_reg) & enabled_bits,
 	     "HDMI port enabled, expecting disabled\n");
@@ -989,7 +989,7 @@ void intel_hdmi_init_connector(struct intel_digital_port *intel_dig_port,
 		intel_hdmi->set_infoframes = cpt_set_infoframes;
 	}
 
-	if (IS_HASWELL(dev))
+	if (HAS_DDI(dev))
 		intel_connector->get_hw_state = intel_ddi_connector_get_hw_state;
 	else
 		intel_connector->get_hw_state = intel_connector_get_hw_state;
-- 
1.8.1.2

