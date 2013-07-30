Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3G3PZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:25:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55325 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3G3PSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 11/75] drm/i915: rename sdvox_reg to hdmi_reg on HDMI context
Date: Tue, 30 Jul 2013 08:16:40 -0700
Message-Id: <1375197464-27962-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit b242b7f745650832f445dca3e19efc3dd2d65a66 upstream.

Some (but not all) of the HDMI registers can be used to control sDVO,
so those registers have two names. IMHO, when we're talking about
HDMI, we really should call the HDMI control register "hdmi_reg"
instead of "sdvox_reg", otherwise we'll just confuse people reading
our code (we now have platforms with HDMI but without SDVO). So now
"struct intel_hdmi" has a member called "hdmi_reg" instead of
"sdvox_reg".

Also, don't worry: "struct intel_sdvo" still has a member called
"sdvo_reg".

v2: Rebase (v1 was sent in May 2012).

Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.8.y-stable as prereq for:
  bcf53de4 "drm/i915: Preserve the DDI_A_4_LANES bit from the bios" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_ddi.c  |  4 +--
 drivers/gpu/drm/i915/intel_drv.h  |  4 +--
 drivers/gpu/drm/i915/intel_hdmi.c | 76 +++++++++++++++++++--------------------
 3 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ddi.c b/drivers/gpu/drm/i915/intel_ddi.c
index debf25f..0724662 100644
--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -1509,9 +1509,7 @@ void intel_ddi_init(struct drm_device *dev, enum port port)
 	intel_dig_port->port_reversal = I915_READ(DDI_BUF_CTL(port)) &
 					DDI_BUF_PORT_REVERSAL;
 	if (hdmi_connector)
-		intel_dig_port->hdmi.sdvox_reg = DDI_BUF_CTL(port);
-	else
-		intel_dig_port->hdmi.sdvox_reg = 0;
+		intel_dig_port->hdmi.hdmi_reg = DDI_BUF_CTL(port);
 	intel_dig_port->dp.output_reg = DDI_BUF_CTL(port);
 
 	intel_encoder->type = INTEL_OUTPUT_UNKNOWN;
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 1c1840f..a803234 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -334,7 +334,7 @@ struct dip_infoframe {
 } __attribute__((packed));
 
 struct intel_hdmi {
-	u32 sdvox_reg;
+	u32 hdmi_reg;
 	int ddc_bus;
 	uint32_t color_range;
 	bool has_hdmi_sink;
@@ -427,7 +427,7 @@ extern void intel_attach_broadcast_rgb_property(struct drm_connector *connector)
 
 extern void intel_crt_init(struct drm_device *dev);
 extern void intel_hdmi_init(struct drm_device *dev,
-			    int sdvox_reg, enum port port);
+			    int hdmi_reg, enum port port);
 extern void intel_hdmi_init_connector(struct intel_digital_port *intel_dig_port,
 				      struct intel_connector *intel_connector);
 extern struct intel_hdmi *enc_to_intel_hdmi(struct drm_encoder *encoder);
diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index dccd859..8d7a334 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -50,7 +50,7 @@ assert_hdmi_port_disabled(struct intel_hdmi *intel_hdmi)
 
 	enabled_bits = HAS_DDI(dev) ? DDI_BUF_CTL_ENABLE : SDVO_ENABLE;
 
-	WARN(I915_READ(intel_hdmi->sdvox_reg) & enabled_bits,
+	WARN(I915_READ(intel_hdmi->hdmi_reg) & enabled_bits,
 	     "HDMI port enabled, expecting disabled\n");
 }
 
@@ -391,7 +391,7 @@ static void g4x_set_infoframes(struct drm_encoder *encoder,
 		return;
 	}
 
-	switch (intel_hdmi->sdvox_reg) {
+	switch (intel_hdmi->hdmi_reg) {
 	case SDVOB:
 		port = VIDEO_DIP_PORT_B;
 		break;
@@ -447,7 +447,7 @@ static void ibx_set_infoframes(struct drm_encoder *encoder,
 		return;
 	}
 
-	switch (intel_hdmi->sdvox_reg) {
+	switch (intel_hdmi->hdmi_reg) {
 	case HDMIB:
 		port = VIDEO_DIP_PORT_B;
 		break;
@@ -587,40 +587,40 @@ static void intel_hdmi_mode_set(struct drm_encoder *encoder,
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_crtc *intel_crtc = to_intel_crtc(encoder->crtc);
 	struct intel_hdmi *intel_hdmi = enc_to_intel_hdmi(encoder);
-	u32 sdvox;
+	u32 hdmi_val;
 
-	sdvox = SDVO_ENCODING_HDMI;
+	hdmi_val = SDVO_ENCODING_HDMI;
 	if (!HAS_PCH_SPLIT(dev))
-		sdvox |= intel_hdmi->color_range;
+		hdmi_val |= intel_hdmi->color_range;
 	if (adjusted_mode->flags & DRM_MODE_FLAG_PVSYNC)
-		sdvox |= SDVO_VSYNC_ACTIVE_HIGH;
+		hdmi_val |= SDVO_VSYNC_ACTIVE_HIGH;
 	if (adjusted_mode->flags & DRM_MODE_FLAG_PHSYNC)
-		sdvox |= SDVO_HSYNC_ACTIVE_HIGH;
+		hdmi_val |= SDVO_HSYNC_ACTIVE_HIGH;
 
 	if (intel_crtc->bpp > 24)
-		sdvox |= COLOR_FORMAT_12bpc;
+		hdmi_val |= COLOR_FORMAT_12bpc;
 	else
-		sdvox |= COLOR_FORMAT_8bpc;
+		hdmi_val |= COLOR_FORMAT_8bpc;
 
 	/* Required on CPT */
 	if (intel_hdmi->has_hdmi_sink && HAS_PCH_CPT(dev))
-		sdvox |= HDMI_MODE_SELECT;
+		hdmi_val |= HDMI_MODE_SELECT;
 
 	if (intel_hdmi->has_audio) {
 		DRM_DEBUG_DRIVER("Enabling HDMI audio on pipe %c\n",
 				 pipe_name(intel_crtc->pipe));
-		sdvox |= SDVO_AUDIO_ENABLE;
-		sdvox |= SDVO_NULL_PACKETS_DURING_VSYNC;
+		hdmi_val |= SDVO_AUDIO_ENABLE;
+		hdmi_val |= SDVO_NULL_PACKETS_DURING_VSYNC;
 		intel_write_eld(encoder, adjusted_mode);
 	}
 
 	if (HAS_PCH_CPT(dev))
-		sdvox |= PORT_TRANS_SEL_CPT(intel_crtc->pipe);
+		hdmi_val |= PORT_TRANS_SEL_CPT(intel_crtc->pipe);
 	else if (intel_crtc->pipe == PIPE_B)
-		sdvox |= SDVO_PIPE_B_SELECT;
+		hdmi_val |= SDVO_PIPE_B_SELECT;
 
-	I915_WRITE(intel_hdmi->sdvox_reg, sdvox);
-	POSTING_READ(intel_hdmi->sdvox_reg);
+	I915_WRITE(intel_hdmi->hdmi_reg, hdmi_val);
+	POSTING_READ(intel_hdmi->hdmi_reg);
 
 	intel_hdmi->set_infoframes(encoder, adjusted_mode);
 }
@@ -633,7 +633,7 @@ static bool intel_hdmi_get_hw_state(struct intel_encoder *encoder,
 	struct intel_hdmi *intel_hdmi = enc_to_intel_hdmi(&encoder->base);
 	u32 tmp;
 
-	tmp = I915_READ(intel_hdmi->sdvox_reg);
+	tmp = I915_READ(intel_hdmi->hdmi_reg);
 
 	if (!(tmp & SDVO_ENABLE))
 		return false;
@@ -657,7 +657,7 @@ static void intel_enable_hdmi(struct intel_encoder *encoder)
 	if (intel_hdmi->has_audio)
 		enable_bits |= SDVO_AUDIO_ENABLE;
 
-	temp = I915_READ(intel_hdmi->sdvox_reg);
+	temp = I915_READ(intel_hdmi->hdmi_reg);
 
 	/* HW workaround for IBX, we need to move the port to transcoder A
 	 * before disabling it. */
@@ -674,21 +674,21 @@ static void intel_enable_hdmi(struct intel_encoder *encoder)
 	 * we do this anyway which shows more stable in testing.
 	 */
 	if (HAS_PCH_SPLIT(dev)) {
-		I915_WRITE(intel_hdmi->sdvox_reg, temp & ~SDVO_ENABLE);
-		POSTING_READ(intel_hdmi->sdvox_reg);
+		I915_WRITE(intel_hdmi->hdmi_reg, temp & ~SDVO_ENABLE);
+		POSTING_READ(intel_hdmi->hdmi_reg);
 	}
 
 	temp |= enable_bits;
 
-	I915_WRITE(intel_hdmi->sdvox_reg, temp);
-	POSTING_READ(intel_hdmi->sdvox_reg);
+	I915_WRITE(intel_hdmi->hdmi_reg, temp);
+	POSTING_READ(intel_hdmi->hdmi_reg);
 
 	/* HW workaround, need to write this twice for issue that may result
 	 * in first write getting masked.
 	 */
 	if (HAS_PCH_SPLIT(dev)) {
-		I915_WRITE(intel_hdmi->sdvox_reg, temp);
-		POSTING_READ(intel_hdmi->sdvox_reg);
+		I915_WRITE(intel_hdmi->hdmi_reg, temp);
+		POSTING_READ(intel_hdmi->hdmi_reg);
 	}
 }
 
@@ -700,7 +700,7 @@ static void intel_disable_hdmi(struct intel_encoder *encoder)
 	u32 temp;
 	u32 enable_bits = SDVO_ENABLE | SDVO_AUDIO_ENABLE;
 
-	temp = I915_READ(intel_hdmi->sdvox_reg);
+	temp = I915_READ(intel_hdmi->hdmi_reg);
 
 	/* HW workaround for IBX, we need to move the port to transcoder A
 	 * before disabling it. */
@@ -710,12 +710,12 @@ static void intel_disable_hdmi(struct intel_encoder *encoder)
 
 		if (temp & SDVO_PIPE_B_SELECT) {
 			temp &= ~SDVO_PIPE_B_SELECT;
-			I915_WRITE(intel_hdmi->sdvox_reg, temp);
-			POSTING_READ(intel_hdmi->sdvox_reg);
+			I915_WRITE(intel_hdmi->hdmi_reg, temp);
+			POSTING_READ(intel_hdmi->hdmi_reg);
 
 			/* Again we need to write this twice. */
-			I915_WRITE(intel_hdmi->sdvox_reg, temp);
-			POSTING_READ(intel_hdmi->sdvox_reg);
+			I915_WRITE(intel_hdmi->hdmi_reg, temp);
+			POSTING_READ(intel_hdmi->hdmi_reg);
 
 			/* Transcoder selection bits only update
 			 * effectively on vblank. */
@@ -730,21 +730,21 @@ static void intel_disable_hdmi(struct intel_encoder *encoder)
 	 * we do this anyway which shows more stable in testing.
 	 */
 	if (HAS_PCH_SPLIT(dev)) {
-		I915_WRITE(intel_hdmi->sdvox_reg, temp & ~SDVO_ENABLE);
-		POSTING_READ(intel_hdmi->sdvox_reg);
+		I915_WRITE(intel_hdmi->hdmi_reg, temp & ~SDVO_ENABLE);
+		POSTING_READ(intel_hdmi->hdmi_reg);
 	}
 
 	temp &= ~enable_bits;
 
-	I915_WRITE(intel_hdmi->sdvox_reg, temp);
-	POSTING_READ(intel_hdmi->sdvox_reg);
+	I915_WRITE(intel_hdmi->hdmi_reg, temp);
+	POSTING_READ(intel_hdmi->hdmi_reg);
 
 	/* HW workaround, need to write this twice for issue that may result
 	 * in first write getting masked.
 	 */
 	if (HAS_PCH_SPLIT(dev)) {
-		I915_WRITE(intel_hdmi->sdvox_reg, temp);
-		POSTING_READ(intel_hdmi->sdvox_reg);
+		I915_WRITE(intel_hdmi->hdmi_reg, temp);
+		POSTING_READ(intel_hdmi->hdmi_reg);
 	}
 }
 
@@ -1009,7 +1009,7 @@ void intel_hdmi_init_connector(struct intel_digital_port *intel_dig_port,
 	}
 }
 
-void intel_hdmi_init(struct drm_device *dev, int sdvox_reg, enum port port)
+void intel_hdmi_init(struct drm_device *dev, int hdmi_reg, enum port port)
 {
 	struct intel_digital_port *intel_dig_port;
 	struct intel_encoder *intel_encoder;
@@ -1042,7 +1042,7 @@ void intel_hdmi_init(struct drm_device *dev, int sdvox_reg, enum port port)
 	intel_encoder->cloneable = false;
 
 	intel_dig_port->port = port;
-	intel_dig_port->hdmi.sdvox_reg = sdvox_reg;
+	intel_dig_port->hdmi.hdmi_reg = hdmi_reg;
 	intel_dig_port->dp.output_reg = 0;
 
 	intel_hdmi_init_connector(intel_dig_port, intel_connector);
-- 
1.8.1.2

