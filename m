Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaBRKIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:08:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:4334 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082AbaBRKIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:08:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,501,1389772800"; 
   d="scan'208";a="485105972"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: Sagar Kamble <sagar.a.kamble@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, "G, Pallavi" <pallavi.g@intel.com>
Subject: [PATCH 1/1] drm/i915: Enabling 128x128 and 256x256 ARGB Cursor Support
Date: Tue, 18 Feb 2014 15:39:46 +0530
Message-Id: <1392718186-12453-1-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagar Kamble <sagar.a.kamble@intel.com>

With this patch we allow larger cursor planes of sizes 128x128
and 256x256. Planning to extend kms_cursor_crc test for verifying
these larger planes.

Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: G, Pallavi <pallavi.g@intel.com>
Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h      |  4 ++++
 drivers/gpu/drm/i915/intel_display.c | 25 ++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 2f564ce..2fee3a2 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3522,7 +3522,11 @@
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
index f19e6ea..00b51f3 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7411,10 +7411,18 @@ static void i9xx_update_cursor(struct drm_crtc *crtc, u32 base)
 	bool visible = base != 0;
 
 	if (intel_crtc->cursor_visible != visible) {
+		int16_t width = intel_crtc->cursor_width;
 		uint32_t cntl = I915_READ(CURCNTR(pipe));
 		if (base) {
 			cntl &= ~(CURSOR_MODE | MCURSOR_PIPE_SELECT);
-			cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
+
+			if (width == 64)
+				cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
+			else if (width == 128)
+				cntl |= CURSOR_MODE_128_ARGB_AX | MCURSOR_GAMMA_ENABLE;
+			else if (width == 256)
+				cntl |= CURSOR_MODE_256_ARGB_AX | MCURSOR_GAMMA_ENABLE;
+
 			cntl |= pipe << 28; /* Connect to correct pipe */
 		} else {
 			cntl &= ~(CURSOR_MODE | MCURSOR_GAMMA_ENABLE);
@@ -7439,10 +7447,17 @@ static void ivb_update_cursor(struct drm_crtc *crtc, u32 base)
 	bool visible = base != 0;
 
 	if (intel_crtc->cursor_visible != visible) {
+		int16_t width = intel_crtc->cursor_width;
 		uint32_t cntl = I915_READ(CURCNTR_IVB(pipe));
 		if (base) {
 			cntl &= ~CURSOR_MODE;
-			cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
+
+			if (width == 64)
+				cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
+			else if (width == 128)
+				cntl |= CURSOR_MODE_128_ARGB_AX | MCURSOR_GAMMA_ENABLE;
+			else if (width == 256)
+				cntl |= CURSOR_MODE_256_ARGB_AX | MCURSOR_GAMMA_ENABLE;
 		} else {
 			cntl &= ~(CURSOR_MODE | MCURSOR_GAMMA_ENABLE);
 			cntl |= CURSOR_MODE_DISABLE;
@@ -7538,9 +7553,9 @@ static int intel_crtc_cursor_set(struct drm_crtc *crtc,
 		goto finish;
 	}
 
-	/* Currently we only support 64x64 cursors */
-	if (width != 64 || height != 64) {
-		DRM_ERROR("we currently only support 64x64 cursors\n");
+	/* Check for which cursor types we support */
+	if (width > 256 || height > 256) {
+		DRM_ERROR("We currently only support 64x64, 128x128, 256x256 cursors\n");
 		return -EINVAL;
 	}
 
-- 
1.8.5

