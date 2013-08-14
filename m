Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320Ab3HNTns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:43:48 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:49679 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760283Ab3HNTnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:43:43 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Darren Etheridge <detheridge@ti.com>, David Airlie <airlied@linux.ie>,
        Rob Clark <robdclark@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/8] drm/tilcdc fixup mode to workaround sync for tda998x
Date: Wed, 14 Aug 2013 21:43:33 +0200
Message-Id: <1376509413-1462-9-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Etheridge <detheridge@ti.com>

Add a fixup function that will flip the hsync priority and
add a hskew value that is used to shift the tda998x to the
right by a variable number of pixels depending on the mode.
This works around an issue with the sync timings that tilcdc
is outputing.

Signed-off-by: Darren Etheridge <detheridge@ti.com>
Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- fix typo in commit line (s/workaound/workaround)

Cc: David Airlie <airlied@linux.ie>
Cc: Darren Etheridge <detheridge@ti.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c  |    7 ++++++-
 drivers/gpu/drm/tilcdc/tilcdc_slave.c |   27 ++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
index 7418dcd..6d05240 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
@@ -379,7 +379,12 @@ static int tilcdc_crtc_mode_set(struct drm_crtc *crtc,
 	else
 		tilcdc_clear(dev, LCDC_RASTER_TIMING_2_REG, LCDC_SYNC_EDGE);
 
-	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
+	/*
+	 * use value from adjusted_mode here as this might have been
+	 * changed as part of the fixup for slave encoders to solve the
+	 * issue where tilcdc timings are not VESA compliant
+	 */
+	if (adjusted_mode->flags & DRM_MODE_FLAG_NHSYNC)
 		tilcdc_set(dev, LCDC_RASTER_TIMING_2_REG, LCDC_INVERT_HSYNC);
 	else
 		tilcdc_clear(dev, LCDC_RASTER_TIMING_2_REG, LCDC_INVERT_HSYNC);
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_slave.c b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
index 0bf5999..f6e9c26 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_slave.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
@@ -73,13 +73,38 @@ static void slave_encoder_prepare(struct drm_encoder *encoder)
 	tilcdc_crtc_set_panel_info(encoder->crtc, &slave_info);
 }
 
+static bool slave_encoder_fixup(struct drm_encoder *encoder,
+		const struct drm_display_mode *mode,
+		struct drm_display_mode *adjusted_mode)
+{
+	/*
+	 * tilcdc does not generate VESA-complient sync but aligns
+	 * VS on the second edge of HS instead of first edge.
+	 * We use adjusted_mode, to fixup sync by aligning both rising
+	 * edges and add HSKEW offset to let the slave encoder fix it up.
+	 */
+	adjusted_mode->hskew = mode->hsync_end - mode->hsync_start;
+	adjusted_mode->flags |= DRM_MODE_FLAG_HSKEW;
+
+	if (mode->flags & DRM_MODE_FLAG_NHSYNC) {
+		adjusted_mode->flags |= DRM_MODE_FLAG_PHSYNC;
+		adjusted_mode->flags &= ~DRM_MODE_FLAG_NHSYNC;
+	} else {
+		adjusted_mode->flags |= DRM_MODE_FLAG_NHSYNC;
+		adjusted_mode->flags &= ~DRM_MODE_FLAG_PHSYNC;
+	}
+
+	return drm_i2c_encoder_mode_fixup(encoder, mode, adjusted_mode);
+}
+
+
 static const struct drm_encoder_funcs slave_encoder_funcs = {
 		.destroy        = slave_encoder_destroy,
 };
 
 static const struct drm_encoder_helper_funcs slave_encoder_helper_funcs = {
 		.dpms           = drm_i2c_encoder_dpms,
-		.mode_fixup     = drm_i2c_encoder_mode_fixup,
+		.mode_fixup     = slave_encoder_fixup,
 		.prepare        = slave_encoder_prepare,
 		.commit         = drm_i2c_encoder_commit,
 		.mode_set       = drm_i2c_encoder_mode_set,
-- 
1.7.10.4

