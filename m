Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaASTAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:00:51 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:59351 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbaASTAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:00:48 -0500
Date: Sun, 19 Jan 2014 19:58:40 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 07/24] drm/i2c: tda998x: set the video mode from the
 adjusted value
Message-ID: <20140119195840.1ecab03b@armhf>
In-Reply-To: <cover.1390153344.git.moinejf@free.fr>
References: <cover.1390153344.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses always the adjusted video mode instead of a mix of
original and adjusted mode.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 66 +++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index b688801..5d82301 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -773,7 +773,7 @@ tda998x_encoder_mode_valid(struct drm_encoder *encoder,
 static void
 tda998x_encoder_mode_set(struct drm_encoder *encoder,
 			struct drm_display_mode *mode,
-			struct drm_display_mode *adjusted_mode)
+			struct drm_display_mode *adj_mode)
 {
 	struct tda998x_priv *priv = to_tda998x_priv(encoder);
 	uint16_t ref_pix, ref_line, n_pix, n_line;
@@ -802,13 +802,13 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	 * So we add +1 to all horizontal and vertical register values,
 	 * plus an additional +3 for REFPIX as we are using RGB input only.
 	 */
-	n_pix        = mode->htotal;
-	n_line       = mode->vtotal;
+	n_pix        = adj_mode->htotal;
+	n_line       = adj_mode->vtotal;
 
-	hs_pix_e     = mode->hsync_end - mode->hdisplay;
-	hs_pix_s     = mode->hsync_start - mode->hdisplay;
-	de_pix_e     = mode->htotal;
-	de_pix_s     = mode->htotal - mode->hdisplay;
+	hs_pix_e     = adj_mode->hsync_end - adj_mode->hdisplay;
+	hs_pix_s     = adj_mode->hsync_start - adj_mode->hdisplay;
+	de_pix_e     = adj_mode->htotal;
+	de_pix_s     = adj_mode->htotal - adj_mode->hdisplay;
 	ref_pix      = 3 + hs_pix_s;
 
 	/*
@@ -816,37 +816,38 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	 * those to adjust the position of the rising VS edge by adding
 	 * HSKEW to ref_pix.
 	 */
-	if (adjusted_mode->flags & DRM_MODE_FLAG_HSKEW)
-		ref_pix += adjusted_mode->hskew;
+	if (adj_mode->flags & DRM_MODE_FLAG_HSKEW)
+		ref_pix += adj_mode->hskew;
 
-	if ((mode->flags & DRM_MODE_FLAG_INTERLACE) == 0) {
-		ref_line     = 1 + mode->vsync_start - mode->vdisplay;
-		vwin1_line_s = mode->vtotal - mode->vdisplay - 1;
-		vwin1_line_e = vwin1_line_s + mode->vdisplay;
+	if ((adj_mode->flags & DRM_MODE_FLAG_INTERLACE) == 0) {
+		ref_line     = 1 + adj_mode->vsync_start - adj_mode->vdisplay;
+		vwin1_line_s = adj_mode->vtotal - adj_mode->vdisplay - 1;
+		vwin1_line_e = vwin1_line_s + adj_mode->vdisplay;
 		vs1_pix_s    = vs1_pix_e = hs_pix_s;
-		vs1_line_s   = mode->vsync_start - mode->vdisplay;
+		vs1_line_s   = adj_mode->vsync_start - adj_mode->vdisplay;
 		vs1_line_e   = vs1_line_s +
-			       mode->vsync_end - mode->vsync_start;
+			       adj_mode->vsync_end - adj_mode->vsync_start;
 		vwin2_line_s = vwin2_line_e = 0;
 		vs2_pix_s    = vs2_pix_e  = 0;
 		vs2_line_s   = vs2_line_e = 0;
 	} else {
-		ref_line     = 1 + (mode->vsync_start - mode->vdisplay)/2;
-		vwin1_line_s = (mode->vtotal - mode->vdisplay)/2;
-		vwin1_line_e = vwin1_line_s + mode->vdisplay/2;
+		ref_line     = 1 + (adj_mode->vsync_start -
+						adj_mode->vdisplay)/2;
+		vwin1_line_s = (adj_mode->vtotal - adj_mode->vdisplay)/2;
+		vwin1_line_e = vwin1_line_s + adj_mode->vdisplay/2;
 		vs1_pix_s    = vs1_pix_e = hs_pix_s;
-		vs1_line_s   = (mode->vsync_start - mode->vdisplay)/2;
+		vs1_line_s   = (adj_mode->vsync_start - adj_mode->vdisplay)/2;
 		vs1_line_e   = vs1_line_s +
-			       (mode->vsync_end - mode->vsync_start)/2;
-		vwin2_line_s = vwin1_line_s + mode->vtotal/2;
-		vwin2_line_e = vwin2_line_s + mode->vdisplay/2;
-		vs2_pix_s    = vs2_pix_e = hs_pix_s + mode->htotal/2;
-		vs2_line_s   = vs1_line_s + mode->vtotal/2 ;
+			       (adj_mode->vsync_end - adj_mode->vsync_start)/2;
+		vwin2_line_s = vwin1_line_s + adj_mode->vtotal/2;
+		vwin2_line_e = vwin2_line_s + adj_mode->vdisplay/2;
+		vs2_pix_s    = vs2_pix_e = hs_pix_s + adj_mode->htotal/2;
+		vs2_line_s   = vs1_line_s + adj_mode->vtotal/2 ;
 		vs2_line_e   = vs2_line_s +
-			       (mode->vsync_end - mode->vsync_start)/2;
+			       (adj_mode->vsync_end - adj_mode->vsync_start)/2;
 	}
 
-	div = 148500 / mode->clock;
+	div = 148500 / adj_mode->clock;
 
 	/* mute the audio FIFO: */
 	reg_set(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_FIFO);
@@ -896,9 +897,9 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	 * TDA19988 requires high-active sync at input stage,
 	 * so invert low-active sync provided by master encoder here
 	 */
-	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
+	if (adj_mode->flags & DRM_MODE_FLAG_NHSYNC)
 		reg_set(priv, REG_VIP_CNTRL_3, VIP_CNTRL_3_H_TGL);
-	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
+	if (adj_mode->flags & DRM_MODE_FLAG_NVSYNC)
 		reg_set(priv, REG_VIP_CNTRL_3, VIP_CNTRL_3_V_TGL);
 
 	/*
@@ -906,9 +907,9 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	 * revert input stage toggled sync at output stage
 	 */
 	reg = TBG_CNTRL_1_TGL_EN;
-	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
+	if (adj_mode->flags & DRM_MODE_FLAG_NHSYNC)
 		reg |= TBG_CNTRL_1_H_TGL;
-	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
+	if (adj_mode->flags & DRM_MODE_FLAG_NVSYNC)
 		reg |= TBG_CNTRL_1_V_TGL;
 	reg_write(priv, REG_TBG_CNTRL_1, reg);
 
@@ -949,11 +950,10 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 		reg_write(priv, REG_ENC_CNTRL, ENC_CNTRL_CTL_CODE(1));
 		reg_set(priv, REG_TX33, TX33_HDMI);
 
-		tda998x_write_avi(priv, adjusted_mode);
+		tda998x_write_avi(priv, adj_mode);
 
 		if (priv->params.audio_cfg)
-			tda998x_configure_audio(priv, adjusted_mode,
-						&priv->params);
+			tda998x_configure_audio(priv, adj_mode, &priv->params);
 	}
 }
 
-- 
1.8.5.3

