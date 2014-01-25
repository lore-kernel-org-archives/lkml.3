Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaA2JYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:24:16 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:33398 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaA2JYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:24:12 -0500
X-Mailbox-Line: From 5269e596e16dfe40253dce38ceb0dc4a617384c1 Mon Sep 17 00:00:00 2001
Message-Id: <5269e596e16dfe40253dce38ceb0dc4a617384c1.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:42 +0100
Subject: [PATCH v5 09/23] drm/i2c: tda998x: don't read write-only registers
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch takes care of the write-only registers of the tda998x.

The registers SOFTRESET, TBG_CNTRL_0 and TBG_CNTRL_1 have all bits
cleared after reset, so, they may be fully re-written.

The register MAT_CONTRL is set to
	MAT_CONTRL_MAT_BP | MAT_CONTRL_MAT_SC(1)
after reset, so, it may be fully set again to this value.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 46 ++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index bb0c6ac..d6d0e80 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -495,9 +495,9 @@ static void
 tda998x_reset(struct tda998x_priv *priv)
 {
 	/* reset audio and i2c master: */
-	reg_set(priv, REG_SOFTRESET, SOFTRESET_AUDIO | SOFTRESET_I2C_MASTER);
+	reg_write(priv, REG_SOFTRESET, SOFTRESET_AUDIO | SOFTRESET_I2C_MASTER);
 	msleep(50);
-	reg_clear(priv, REG_SOFTRESET, SOFTRESET_AUDIO | SOFTRESET_I2C_MASTER);
+	reg_write(priv, REG_SOFTRESET, 0);
 	msleep(50);
 
 	/* reset transmitter: */
@@ -852,7 +852,7 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	reg_set(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_FIFO);
 
 	/* set HDMI HDCP mode off: */
-	reg_set(priv, REG_TBG_CNTRL_1, TBG_CNTRL_1_DWIN_DIS);
+	reg_write(priv, REG_TBG_CNTRL_1, TBG_CNTRL_1_DWIN_DIS);
 	reg_clear(priv, REG_TX33, TX33_HDMI);
 	reg_write(priv, REG_ENC_CNTRL, ENC_CNTRL_CTL_CODE(0));
 
@@ -879,38 +879,28 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 			PLL_SERIAL_2_SRL_PR(rep));
 
 	/* set color matrix bypass flag: */
-	reg_set(priv, REG_MAT_CONTRL, MAT_CONTRL_MAT_BP);
+	reg_write(priv, REG_MAT_CONTRL, MAT_CONTRL_MAT_BP |
+				MAT_CONTRL_MAT_SC(1));
 
 	/* set BIAS tmds value: */
 	reg_write(priv, REG_ANA_GENERAL, 0x09);
 
-	reg_clear(priv, REG_TBG_CNTRL_0, TBG_CNTRL_0_SYNC_MTHD);
+	reg_write(priv, REG_TBG_CNTRL_0, 0);
 
 	/*
 	 * Sync on rising HSYNC/VSYNC
 	 */
-	reg_write(priv, REG_VIP_CNTRL_3, 0);
-	reg_set(priv, REG_VIP_CNTRL_3, VIP_CNTRL_3_SYNC_HS);
+	reg = VIP_CNTRL_3_SYNC_HS;
 
 	/*
 	 * TDA19988 requires high-active sync at input stage,
 	 * so invert low-active sync provided by master encoder here
 	 */
 	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
-		reg_set(priv, REG_VIP_CNTRL_3, VIP_CNTRL_3_H_TGL);
+		reg |= VIP_CNTRL_3_H_TGL;
 	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
-		reg_set(priv, REG_VIP_CNTRL_3, VIP_CNTRL_3_V_TGL);
-
-	/*
-	 * Always generate sync polarity relative to input sync and
-	 * revert input stage toggled sync at output stage
-	 */
-	reg = TBG_CNTRL_1_TGL_EN;
-	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
-		reg |= TBG_CNTRL_1_H_TGL;
-	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
-		reg |= TBG_CNTRL_1_V_TGL;
-	reg_write(priv, REG_TBG_CNTRL_1, reg);
+		reg |= VIP_CNTRL_3_V_TGL;
+	reg_write(priv, REG_VIP_CNTRL_3, reg);
 
 	reg_write(priv, REG_VIDFORMAT, 0x00);
 	reg_write16(priv, REG_REFPIX_MSB, ref_pix);
@@ -939,13 +929,25 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 		reg_write(priv, REG_ENABLE_SPACE, 0x01);
 	}
 
+	/*
+	 * Always generate sync polarity relative to input sync and
+	 * revert input stage toggled sync at output stage
+	 */
+	reg = TBG_CNTRL_1_DWIN_DIS | TBG_CNTRL_1_TGL_EN;
+	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
+		reg |= TBG_CNTRL_1_H_TGL;
+	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
+		reg |= TBG_CNTRL_1_V_TGL;
+	reg_write(priv, REG_TBG_CNTRL_1, reg);
+
 	/* must be last register set: */
-	reg_clear(priv, REG_TBG_CNTRL_0, TBG_CNTRL_0_SYNC_ONCE);
+	reg_write(priv, REG_TBG_CNTRL_0, 0);
 
 	/* Only setup the info frames if the sink is HDMI */
 	if (priv->is_hdmi_sink) {
 		/* We need to turn HDMI HDCP stuff on to get audio through */
-		reg_clear(priv, REG_TBG_CNTRL_1, TBG_CNTRL_1_DWIN_DIS);
+		reg &= ~TBG_CNTRL_1_DWIN_DIS;
+		reg_write(priv, REG_TBG_CNTRL_1, reg);
 		reg_write(priv, REG_ENC_CNTRL, ENC_CNTRL_CTL_CODE(1));
 		reg_set(priv, REG_TX33, TX33_HDMI);
 
-- 
1.9.rc1

