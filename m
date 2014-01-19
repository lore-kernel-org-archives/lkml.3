Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaASTEB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:04:01 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:56787 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbaASTDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:03:55 -0500
Date: Sun, 19 Jan 2014 19:58:47 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 23/24] drm/i2c: tda998x: code optimization
Message-ID: <20140119195847.25531457@armhf>
In-Reply-To: <cover.1390153344.git.moinejf@free.fr>
References: <cover.1390153344.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
index 2fcc432..0716a75 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -702,10 +702,8 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	}
 
 	reg_write(priv, REG_AIP_CLKSEL, clksel_aip);
-	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT);
-
-	/* Enable automatic CTS generation */
-	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_ACR_MAN);
+	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT |
+					AIP_CNTRL_0_ACR_MAN);	/* auto CTS */
 	reg_write(priv, REG_CTS_N, cts_n);
 	reg_write(priv, REG_ENA_ACLK, aclk);
 
@@ -953,10 +951,10 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
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
 
@@ -976,8 +974,6 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	/* set BIAS tmds value: */
 	reg_write(priv, REG_ANA_GENERAL, 0x09);
 
-	reg_write(priv, REG_TBG_CNTRL_0, 0);
-
 	/*
 	 * Sync on rising HSYNC/VSYNC
 	 */
-- 
1.8.5.3

