Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaCJLfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 07:35:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:12862 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbaCJLf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 07:35:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,623,1389772800"; 
   d="scan'208";a="495404360"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: Sagar Kamble <sagar.a.kamble@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, "G, Pallavi" <pallavi.g@intel.com>
Subject: [PATCH v4 1/1] drm/i915: Enabling 128x128 and 256x256 ARGB Cursor Support
Date: Mon, 10 Mar 2014 17:06:23 +0530
Message-Id: <1394451383-27133-1-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <20140310100321.GA30571@phenom.ffwll.local>
References: <20140310100321.GA30571@phenom.ffwll.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagar Kamble <sagar.a.kamble@intel.com>

With this patch we allow larger cursor planes of sizes 128x128
and 256x256.

v2: Added more precise check on size while setting cursor plane.

v3: Changes related to restructuring cursor size restrictions
and DRM_DEBUG usage.

v4: Indentation related changes for setting cursor control and
implementing DRM_CAP_CURSOR_WIDTH and DRM_CAP_CURSOR_HEIGHT

Testcase: igt/kms_cursor_crc
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: G, Pallavi <pallavi.g@intel.com>
Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h      |  4 +++
 drivers/gpu/drm/i915/intel_display.c | 53 ++++++++++++++++++++++++++++++++----
 drivers/gpu/drm/i915/intel_drv.h     |  7 +++++
 3 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 146609a..aee8258 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3551,7 +3551,11 @@ enum punit_power_well {
 /* New style CUR*CNTR flags */
 #define   CURSOR_MODE		0x27
 #define   CURSOR_MODE_DISABLE   0x00
+#define   CURSOR_MODE_128_32B_AX 0x02
+#define   CURSOR_MODE_256_32B_AX 0x03
 #define   CURSOR_MODE_64_32B_AX 0x07
+#define   CURSOR_MODE_128_ARGB_AX ((1 << 5) | CURSOR_MODE_128_32B_AX)
+#define   CURSOR_MODE_256_ARGB_AX ((1 << 5) | CURSOR_MODE_256_32B_AX)
 #define   CURSOR_MODE_64_ARGB_AX ((1 << 5) | CURSOR_MODE_64_32B_AX)
 #define   MCURSOR_PIPE_SELECT	(1 << 28)
 #define   MCURSOR_PIPE_A	0x00
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 0868afb..ec6a073 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7440,10 +7440,26 @@ static void i9xx_update_cursor(struct drm_crtc *crtc, u32 base)
 	bool visible = base != 0;
 
 	if (intel_crtc->cursor_visible != visible) {
+		int16_t width = intel_crtc->cursor_width;
 		uint32_t cntl = I915_READ(CURCNTR(pipe));
 		if (base) {
 			cntl &= ~(CURSOR_MODE | MCURSOR_PIPE_SELECT);
-			cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
+			cntl |= MCURSOR_GAMMA_ENABLE;
+
+			switch (width) {
+			case 64:
+				cntl |= CURSOR_MODE_64_ARGB_AX;
+				break;
+			case 128:
+				cntl |= CURSOR_MODE_128_ARGB_AX;
+				break;
+			case 256:
+				cntl |= CURSOR_MODE_256_ARGB_AX;
+				break;
+			default:
+				WARN_ON(1);
+				return;
+			}
 			cntl |= pipe << 28; /* Connect to correct pipe */
 		} else {
 			cntl &= ~(CURSOR_MODE | MCURSOR_GAMMA_ENABLE);
@@ -7468,10 +7484,25 @@ static void ivb_update_cursor(struct drm_crtc *crtc, u32 base)
 	bool visible = base != 0;
 
 	if (intel_crtc->cursor_visible != visible) {
+		int16_t width = intel_crtc->cursor_width;
 		uint32_t cntl = I915_READ(CURCNTR_IVB(pipe));
 		if (base) {
 			cntl &= ~CURSOR_MODE;
-			cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
+			cntl |= MCURSOR_GAMMA_ENABLE;
+			switch (width) {
+			case 64:
+				cntl |= CURSOR_MODE_64_ARGB_AX;
+				break;
+			case 128:
+				cntl |= CURSOR_MODE_128_ARGB_AX;
+				break;
+			case 256:
+				cntl |= CURSOR_MODE_256_ARGB_AX;
+				break;
+			default:
+				WARN_ON(1);
+				return;
+			}
 		} else {
 			cntl &= ~(CURSOR_MODE | MCURSOR_GAMMA_ENABLE);
 			cntl |= CURSOR_MODE_DISABLE;
@@ -7567,9 +7598,11 @@ static int intel_crtc_cursor_set(struct drm_crtc *crtc,
 		goto finish;
 	}
 
-	/* Currently we only support 64x64 cursors */
-	if (width != 64 || height != 64) {
-		DRM_ERROR("we currently only support 64x64 cursors\n");
+	/* Check for which cursor types we support */
+	if (!((width == 64 && height == 64) ||
+			(width == 128 && height == 128 && !IS_GEN2(dev)) ||
+			(width == 256 && height == 256 && !IS_GEN2(dev)))) {
+		DRM_DEBUG("Cursor dimension not supported\n");
 		return -EINVAL;
 	}
 
@@ -10331,6 +10364,16 @@ static void intel_crtc_init(struct drm_device *dev, int pipe)
 
 	drm_crtc_init(dev, &intel_crtc->base, &intel_crtc_funcs);
 
+	if (IS_GEN2(dev)) {
+		intel_crtc->max_cursor_width = GEN2_CURSOR_WIDTH;
+		intel_crtc->max_cursor_height = GEN2_CURSOR_HEIGHT;
+	} else {
+		intel_crtc->max_cursor_width = CURSOR_WIDTH;
+		intel_crtc->max_cursor_height = CURSOR_HEIGHT;
+	}
+	dev->mode_config.cursor_width = intel_crtc->max_cursor_width;
+	dev->mode_config.cursor_height = intel_crtc->max_cursor_height;
+
 	drm_mode_crtc_set_gamma_size(&intel_crtc->base, 256);
 	for (i = 0; i < 256; i++) {
 		intel_crtc->lut_r[i] = i;
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 9c70905..eca4a0a 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -78,6 +78,12 @@
 #define MAX_OUTPUTS 6
 /* maximum connectors per crtcs in the mode set */
 
+/* Maximum cursor sizes */
+#define GEN2_CURSOR_WIDTH 64
+#define GEN2_CURSOR_HEIGHT 64
+#define CURSOR_WIDTH 256
+#define CURSOR_HEIGHT 256
+
 #define INTEL_I2C_BUS_DVO 1
 #define INTEL_I2C_BUS_SDVO 2
 
@@ -364,6 +370,7 @@ struct intel_crtc {
 	uint32_t cursor_addr;
 	int16_t cursor_x, cursor_y;
 	int16_t cursor_width, cursor_height;
+	int16_t max_cursor_width, max_cursor_height;
 	bool cursor_visible;
 
 	struct intel_crtc_config config;
-- 
1.8.5

