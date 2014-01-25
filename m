Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaA2J02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:26:28 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:43609 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaA2J0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:26:25 -0500
X-Mailbox-Line: From 2319417ac19b48af325e4203b16f0c8490a24ab0 Mon Sep 17 00:00:00 2001
Message-Id: <2319417ac19b48af325e4203b16f0c8490a24ab0.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:39 +0100
Subject: [PATCH v5 22/23] drm/i2c: tda998x: code optimization
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reduces the number of I2C exchanges by setting many bits in
one write and removing a useless write.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index dedeb22..4f1a047 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -669,10 +669,8 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	}
 
 	reg_write(priv, REG_AIP_CLKSEL, clksel_aip);
-	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT);
-
-	/* Enable automatic CTS generation */
-	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_ACR_MAN);
+	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT |
+					AIP_CNTRL_0_ACR_MAN);	/* auto CTS */
 	reg_write(priv, REG_CTS_N, cts_n);
 
 	/*
@@ -908,10 +906,10 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	reg_write(priv, REG_VIP_CNTRL_5, VIP_CNTRL_5_SP_CNT(0));
 	reg_write(priv, REG_VIP_CNTRL_4, VIP_CNTRL_4_BLANKIT(0) |
 			VIP_CNTRL_4_BLC(0));
-	reg_clear(priv, REG_PLL_SERIAL_3, PLL_SERIAL_3_SRL_CCIR);
 
 	reg_clear(priv, REG_PLL_SERIAL_1, PLL_SERIAL_1_SRL_MAN_IZ);
-	reg_clear(priv, REG_PLL_SERIAL_3, PLL_SERIAL_3_SRL_DE);
+	reg_clear(priv, REG_PLL_SERIAL_3, PLL_SERIAL_3_SRL_CCIR |
+					  PLL_SERIAL_3_SRL_DE);
 	reg_write(priv, REG_SERIALIZER, 0);
 	reg_write(priv, REG_HVF_CNTRL_1, HVF_CNTRL_1_VQR(0));
 
@@ -931,8 +929,6 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	/* set BIAS tmds value: */
 	reg_write(priv, REG_ANA_GENERAL, 0x09);
 
-	reg_write(priv, REG_TBG_CNTRL_0, 0);
-
 	/*
 	 * Sync on rising HSYNC/VSYNC
 	 */
-- 
1.9.rc1

