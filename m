Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaA2JcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:32:14 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:36010 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbaA2JYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:24:43 -0500
X-Mailbox-Line: From 00c290bee957202e291810e295755efc3fecec0f Mon Sep 17 00:00:00 2001
Message-Id: <00c290bee957202e291810e295755efc3fecec0f.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:41 +0100
Subject: [PATCH v5 12/23] drm/i2c: tda998x: add DT support
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT support to the tda998x.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 351da92..d4074e0 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1164,6 +1164,8 @@ tda998x_encoder_init(struct i2c_client *client,
 		    struct drm_encoder_slave *encoder_slave)
 {
 	struct tda998x_priv *priv;
+	struct device_node *np = client->dev.of_node;
+	u32 video;
 	int ret;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -1232,6 +1234,17 @@ tda998x_encoder_init(struct i2c_client *client,
 	cec_write(priv, REG_CEC_FRO_IM_CLK_CTRL,
 			CEC_FRO_IM_CLK_CTRL_GHOST_DIS | CEC_FRO_IM_CLK_CTRL_IMCLK_SEL);
 
+	if (!np)
+		return 0;		/* non-DT */
+
+	/* get the optional video properties */
+	ret = of_property_read_u32(np, "video-ports", &video);
+	if (ret == 0) {
+		priv->vip_cntrl_0 = video >> 16;
+		priv->vip_cntrl_1 = video >> 8;
+		priv->vip_cntrl_2 = video;
+	}
+
 	return 0;
 
 fail:
@@ -1246,6 +1259,14 @@ fail:
 	return -ENXIO;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id tda998x_dt_ids[] = {
+	{ .compatible = "nxp,tda998x", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, tda998x_dt_ids);
+#endif
+
 static struct i2c_device_id tda998x_ids[] = {
 	{ "tda998x", 0 },
 	{ }
@@ -1258,6 +1279,7 @@ static struct drm_i2c_encoder_driver tda998x_driver = {
 		.remove = tda998x_remove,
 		.driver = {
 			.name = "tda998x",
+			.of_match_table = of_match_ptr(tda998x_dt_ids),
 		},
 		.id_table = tda998x_ids,
 	},
-- 
1.9.rc1

