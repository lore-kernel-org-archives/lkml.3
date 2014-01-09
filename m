Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbaAILLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:11:30 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:36476 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaAILL0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:11:26 -0500
Date: Thu, 9 Jan 2014 12:04:48 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 15/28] drm/i2c: tda998x: use the tda998x video format
 when cea mode
Message-ID: <20140109120448.24d89eba@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the tda998x video format tied to the CEA mode.
This reduces the number of i2c exchanges.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c   | 143 +++++++++++++++++----
 1 file changed, 118 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 0cae820..91bd4e8 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -344,6 +344,85 @@ struct tda998x_priv {
 #define TDA19989N2                0x0202
 #define TDA19988                  0x0301
 
+/* REG_VIDFORMAT values */
+enum e_vfmt {				/* cea mode */
+	E_VFMT_INVALID = 0xff,
+	E_VFMT_640x480p_60Hz = 0,	/* 1 */
+	E_VFMT_720x480p_60Hz,		/* 2/3 */
+	E_VFMT_1280x720p_60Hz,		/* 4 */
+	E_VFMT_1920x1080i_60Hz,		/* 5 */
+	E_VFMT_720x480i_60Hz,		/* 6/7 */
+	E_VFMT_720x240p_60Hz,		/*NT 8/9 */
+	E_VFMT_1920x1080p_60Hz,		/* 16 */
+	E_VFMT_720x576p_50Hz,		/* 17/18 */
+	E_VFMT_1280x720p_50Hz,		/* 19 */
+	E_VFMT_1920x1080i_50Hz,		/* 20 */
+	E_VFMT_720x576i_50Hz,		/* 21/22 */
+	E_VFMT_720x288p_50Hz,		/* 23/24 */
+	E_VFMT_1920x1080p_50Hz,		/* 31 */
+	E_VFMT_1920x1080p_24Hz,		/* 32 */
+	E_VFMT_1440x576p_50Hz,		/* 29/30 */
+	E_VFMT_1440x480p_60Hz,		/* 14/15 */
+	E_VFMT_2880x480p_60Hz,		/* 35/36 */
+	E_VFMT_2880x576p_50Hz,		/* 37/38 */
+	E_VFMT_2880x480i_60Hz,		/* 10/11*/
+	E_VFMT_2880x480i_60Hz_PR2,	/* 10/11*/
+	E_VFMT_2880x480i_60Hz_PR4,	/* 10/11*/
+	E_VFMT_2880x576i_50Hz,		/* 25/26 */
+	E_VFMT_2880x576i_50Hz_PR2,	/* 25/26 */
+	E_VFMT_720x480p_60Hz_FP,	/* 2/3 FP */
+	E_VFMT_1280x720p_60Hz_FP,	/* 4 FP */
+	E_VFMT_720x576p_50Hz_FP,	/* 17/18 FP */
+	E_VFMT_1280x720p_50Hz_FP,	/* 19 FP */
+	E_VFMT_1920x1080p_24Hz_FP,	/* 32 FP */
+	E_VFMT_1920x1080p_25Hz_FP,	/* 33 FP */
+	E_VFMT_1920x1080p_30Hz_FP,	/* 34 FP */
+	E_VFMT_1920x1080i_60Hz_FP,	/* 5 FP */
+	E_VFMT_1920x1080i_50Hz_FP,	/* 20 FP */
+};
+/* cea mode to VIDFORMAT register */
+static u8 cea2vid[] = {
+	E_VFMT_INVALID,		/* 00 */
+	E_VFMT_640x480p_60Hz,	/* 01_640x480p_60Hz */
+	E_VFMT_720x480p_60Hz,	/* 02_720x480p_60Hz */
+	E_VFMT_720x480p_60Hz,	/* 03_720x480p_60Hz */
+	E_VFMT_1280x720p_60Hz,	/* 04_1280x720p_60Hz */
+	E_VFMT_1920x1080i_60Hz,	/* 05_1920x1080i_60Hz */
+	E_VFMT_720x480i_60Hz,	/* 06_720x480i_60Hz */
+	E_VFMT_720x480i_60Hz,	/* 07_720x480i_60Hz */
+	E_VFMT_720x240p_60Hz,	/* 08_720x240p_60Hz */
+	E_VFMT_720x240p_60Hz,	/* 09_720x240p_60Hz */
+	E_VFMT_2880x480i_60Hz_PR4, /* 10_720x480i_60Hz */
+	E_VFMT_2880x480i_60Hz_PR4, /* 11_720x480i_60Hz */
+	E_VFMT_INVALID,		/* 12 */
+	E_VFMT_INVALID,		/* 13 */
+	E_VFMT_1440x480p_60Hz,	/* 14_1440x480p_60Hz */
+	E_VFMT_1440x480p_60Hz,	/* 15_1440x480p_60Hz */
+	E_VFMT_1920x1080p_60Hz,	/* 16_1920x1080p_60Hz */
+	E_VFMT_720x576p_50Hz,	/* 17_720x576p_50Hz */
+	E_VFMT_720x576p_50Hz,	/* 18_720x576p_50Hz */
+	E_VFMT_1280x720p_50Hz,	/* 19_1280x720p_50Hz */
+	E_VFMT_1920x1080i_50Hz,	/* 20_1920x1080i_50Hz */
+	E_VFMT_720x576i_50Hz,	/* 21_720x576i_50Hz */
+	E_VFMT_720x576i_50Hz,	/* 22_720x576i_50Hz */
+	E_VFMT_720x288p_50Hz,	/* 23_720x288p_50Hz */
+	E_VFMT_720x288p_50Hz,	/* 24_720x288p_50Hz */
+	E_VFMT_2880x576i_50Hz,	/* 25_720x576i_50Hz */
+	E_VFMT_2880x576i_50Hz,	/* 26_720x576i_50Hz */
+	E_VFMT_INVALID,		/* 27 */
+	E_VFMT_INVALID,		/* 28 */
+	E_VFMT_1440x576p_50Hz,	/* 29_1440x576p_50Hz */
+	E_VFMT_1440x576p_50Hz,	/* 30_1440x576p_50Hz */
+	E_VFMT_1920x1080p_50Hz,	/* 31_1920x1080p_50Hz */
+	E_VFMT_1920x1080p_24Hz,	/* 32_1920x1080p_24Hz */
+	E_VFMT_INVALID,		/* 33_1920x1080p_25Hz */
+	E_VFMT_INVALID,		/* 34_1920x1080p_30Hz */
+	E_VFMT_2880x480p_60Hz,	/* 35_2880x480p_60Hz */
+	E_VFMT_2880x480p_60Hz,	/* 36_2880x480p_60Hz */
+	E_VFMT_720x576p_50Hz,	/* 37_2880x576p_50Hz */
+	E_VFMT_720x576p_50Hz,	/* 38_2880x576p_50Hz */
+};
+
 static void
 cec_write(struct tda998x_priv *priv, uint16_t addr, uint8_t val)
 {
@@ -723,6 +802,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 
 /* DRM encoder functions */
 
+/* this function is not called when no info->platform (DT support) */
 static void
 tda998x_encoder_set_config(struct drm_encoder *encoder, void *params)
 {
@@ -826,6 +906,7 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	uint16_t vwin2_line_s, vwin2_line_e;
 	uint16_t de_pix_s, de_pix_e;
 	uint8_t reg, div, rep;
+	u8 cea_mode;
 
 	mode = adjusted_mode;
 
@@ -946,31 +1027,43 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 		reg |= VIP_CNTRL_3_V_TGL;
 	reg_write(priv, REG_VIP_CNTRL_3, reg);
 
-	reg_write(priv, REG_VIDFORMAT, 0x00);
-	reg_write16(priv, REG_REFPIX_MSB, ref_pix);
-	reg_write16(priv, REG_REFLINE_MSB, ref_line);
-	reg_write16(priv, REG_NPIX_MSB, n_pix);
-	reg_write16(priv, REG_NLINE_MSB, n_line);
-	reg_write16(priv, REG_VS_LINE_STRT_1_MSB, vs1_line_s);
-	reg_write16(priv, REG_VS_PIX_STRT_1_MSB, vs1_pix_s);
-	reg_write16(priv, REG_VS_LINE_END_1_MSB, vs1_line_e);
-	reg_write16(priv, REG_VS_PIX_END_1_MSB, vs1_pix_e);
-	reg_write16(priv, REG_VS_LINE_STRT_2_MSB, vs2_line_s);
-	reg_write16(priv, REG_VS_PIX_STRT_2_MSB, vs2_pix_s);
-	reg_write16(priv, REG_VS_LINE_END_2_MSB, vs2_line_e);
-	reg_write16(priv, REG_VS_PIX_END_2_MSB, vs2_pix_e);
-	reg_write16(priv, REG_HS_PIX_START_MSB, hs_pix_s);
-	reg_write16(priv, REG_HS_PIX_STOP_MSB, hs_pix_e);
-	reg_write16(priv, REG_VWIN_START_1_MSB, vwin1_line_s);
-	reg_write16(priv, REG_VWIN_END_1_MSB, vwin1_line_e);
-	reg_write16(priv, REG_VWIN_START_2_MSB, vwin2_line_s);
-	reg_write16(priv, REG_VWIN_END_2_MSB, vwin2_line_e);
-	reg_write16(priv, REG_DE_START_MSB, de_pix_s);
-	reg_write16(priv, REG_DE_STOP_MSB, de_pix_e);
-
-	if (priv->rev == TDA19988) {
-		/* let incoming pixels fill the active space (if any) */
-		reg_write(priv, REG_ENABLE_SPACE, 0x01);
+	/*
+	 * if one of the cea modes, set the video format
+	 * otherwise, set all values
+	 */
+	cea_mode = drm_match_cea_mode(mode);
+	if (cea_mode >= ARRAY_SIZE(cea2vid))
+		cea_mode = 0;
+	if (cea2vid[cea_mode] != E_VFMT_INVALID) {
+		reg_write(priv, REG_VIDFORMAT, cea2vid[cea_mode]);
+	} else {
+		reg_write(priv, REG_VIDFORMAT, 0x00);
+		reg_write16(priv, REG_REFPIX_MSB, ref_pix);
+		reg_write16(priv, REG_REFLINE_MSB, ref_line);
+		reg_write16(priv, REG_NPIX_MSB, n_pix);
+		reg_write16(priv, REG_NLINE_MSB, n_line);
+		reg_write16(priv, REG_VS_LINE_STRT_1_MSB, vs1_line_s);
+		reg_write16(priv, REG_VS_PIX_STRT_1_MSB, vs1_pix_s);
+		reg_write16(priv, REG_VS_LINE_END_1_MSB, vs1_line_e);
+		reg_write16(priv, REG_VS_PIX_END_1_MSB, vs1_pix_e);
+		reg_write16(priv, REG_VS_LINE_STRT_2_MSB, vs2_line_s);
+		reg_write16(priv, REG_VS_PIX_STRT_2_MSB, vs2_pix_s);
+		reg_write16(priv, REG_VS_LINE_END_2_MSB, vs2_line_e);
+		reg_write16(priv, REG_VS_PIX_END_2_MSB, vs2_pix_e);
+		reg_write16(priv, REG_HS_PIX_START_MSB, hs_pix_s);
+		reg_write16(priv, REG_HS_PIX_STOP_MSB, hs_pix_e);
+		reg_write16(priv, REG_VWIN_START_1_MSB, vwin1_line_s);
+		reg_write16(priv, REG_VWIN_END_1_MSB, vwin1_line_e);
+		reg_write16(priv, REG_VWIN_START_2_MSB, vwin2_line_s);
+		reg_write16(priv, REG_VWIN_END_2_MSB, vwin2_line_e);
+		reg_write16(priv, REG_DE_START_MSB, de_pix_s);
+		reg_write16(priv, REG_DE_STOP_MSB, de_pix_e);
+
+
+		if (priv->rev == TDA19988) {
+			/* let incoming pixels fill the active space (if any) */
+			reg_write(priv, REG_ENABLE_SPACE, 0x01);
+		}
 	}
 
 	/* must be last register set: */
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
