Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaA2JZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:25:49 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:40797 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbaA2JZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:25:45 -0500
X-Mailbox-Line: From 7dca56216f9df5495b77d463e52a0a67bac69fe7 Mon Sep 17 00:00:00 2001
Message-Id: <7dca56216f9df5495b77d463e52a0a67bac69fe7.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:40 +0100
Subject: [PATCH v5 18/23] drm/i2c: tda998x: make the audio code more readable
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a definition of the values of the MUX_AP register and
simplifies the macro's defining the fields of the AIP_CLKSEL register.
This makes the format specific audio init sequence more readable.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 873e1e9..3e56302 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -126,6 +126,8 @@ struct tda998x_priv {
 # define VIP_CNTRL_5_CKCASE       (1 << 0)
 # define VIP_CNTRL_5_SP_CNT(x)    (((x) & 3) << 1)
 #define REG_MUX_AP                REG(0x00, 0x26)     /* read/write */
+# define MUX_AP_SELECT_I2S	  0x64
+# define MUX_AP_SELECT_SPDIF	  0x40
 #define REG_MUX_VP_VIP_OUT        REG(0x00, 0x27)     /* read/write */
 #define REG_MAT_CONTRL            REG(0x00, 0x80)     /* write */
 # define MAT_CONTRL_MAT_SC(x)     (((x) & 3) << 0)
@@ -203,10 +205,11 @@ struct tda998x_priv {
 #define REG_I2S_FORMAT            REG(0x00, 0xfc)     /* read/write */
 # define I2S_FORMAT(x)            (((x) & 3) << 0)
 #define REG_AIP_CLKSEL            REG(0x00, 0xfd)     /* write */
-# define AIP_CLKSEL_FS(x)         (((x) & 3) << 0)
-# define AIP_CLKSEL_CLK_POL(x)    (((x) & 1) << 2)
-# define AIP_CLKSEL_AIP(x)        (((x) & 7) << 3)
-
+# define AIP_CLKSEL_AIP_SPDIF	  (0 << 3)
+# define AIP_CLKSEL_AIP_I2S	  (1 << 3)
+# define AIP_CLKSEL_FS_ACLK	  (0 << 0)
+# define AIP_CLKSEL_FS_MCLK	  (1 << 0)
+# define AIP_CLKSEL_FS_FS64SPDIF  (2 << 0)
 
 /* Page 02h: PLL settings */
 #define REG_PLL_SERIAL_1          REG(0x02, 0x00)     /* read/write */
@@ -645,19 +648,17 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	/* Set audio input source */
 	switch (p->audio_format) {
 	case AFMT_SPDIF:
-		reg_write(priv, REG_MUX_AP, 0x40);
-		clksel_aip = AIP_CLKSEL_AIP(0);
-		/* FS64SPDIF */
-		clksel_fs = AIP_CLKSEL_FS(2);
+		reg_write(priv, REG_MUX_AP, MUX_AP_SELECT_SPDIF);
+		clksel_aip = AIP_CLKSEL_AIP_SPDIF;
+		clksel_fs = AIP_CLKSEL_FS_FS64SPDIF;
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
 		ca_i2s = 0;
 		break;
 
 	case AFMT_I2S:
-		reg_write(priv, REG_MUX_AP, 0x64);
-		clksel_aip = AIP_CLKSEL_AIP(1);
-		/* ACLK */
-		clksel_fs = AIP_CLKSEL_FS(0);
+		reg_write(priv, REG_MUX_AP, MUX_AP_SELECT_I2S);
+		clksel_aip = AIP_CLKSEL_AIP_I2S;
+		clksel_fs = AIP_CLKSEL_FS_ACLK;
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
 		ca_i2s = CA_I2S_CA_I2S(0);
 		break;
-- 
1.9.rc1

