Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415Ab3HNTpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:45:47 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:34357 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760185Ab3HNTnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:43:41 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/8] drm/i2c: tda998x: prepare for video input configuration
Date: Wed, 14 Aug 2013 21:43:29 +0200
Message-Id: <1376509413-1462-5-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

The video-input-port (VIP) is highly configurable. This prepares
current driver to allow to configure VIP configuration, as some
boards connect lcd controller and TDA998x "pin-swapped" and depend
on VIP to swap the pins by register configuration.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Darren Etheridge <detheridge@ti.com>
Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: David Airlie <airlied@linux.ie>
Cc: Darren Etheridge <detheridge@ti.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpu/drm/i2c/tda998x_drv.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index a701411..527d11b 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -32,6 +32,9 @@ struct tda998x_priv {
 	uint16_t rev;
 	uint8_t current_page;
 	int dpms;
+	u8 vip_cntrl_0;
+	u8 vip_cntrl_1;
+	u8 vip_cntrl_2;
 };
 
 #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
@@ -448,12 +451,9 @@ tda998x_encoder_dpms(struct drm_encoder *encoder, int mode)
 		reg_write(encoder, REG_ENA_VP_1, 0xff);
 		reg_write(encoder, REG_ENA_VP_2, 0xff);
 		/* set muxing after enabling ports: */
-		reg_write(encoder, REG_VIP_CNTRL_0,
-				VIP_CNTRL_0_SWAP_A(2) | VIP_CNTRL_0_SWAP_B(3));
-		reg_write(encoder, REG_VIP_CNTRL_1,
-				VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1));
-		reg_write(encoder, REG_VIP_CNTRL_2,
-				VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5));
+		reg_write(encoder, REG_VIP_CNTRL_0, priv->vip_cntrl_0);
+		reg_write(encoder, REG_VIP_CNTRL_1, priv->vip_cntrl_1);
+		reg_write(encoder, REG_VIP_CNTRL_2, priv->vip_cntrl_2);
 		break;
 	case DRM_MODE_DPMS_OFF:
 		/* disable audio and video ports */
@@ -823,6 +823,10 @@ tda998x_encoder_init(struct i2c_client *client,
 	if (!priv)
 		return -ENOMEM;
 
+	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(2) | VIP_CNTRL_0_SWAP_B(3);
+	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
+	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5);
+
 	priv->current_page = 0;
 	priv->cec = i2c_new_dummy(client->adapter, 0x34);
 	priv->dpms = DRM_MODE_DPMS_OFF;
-- 
1.7.10.4

