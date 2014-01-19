Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaASTCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:02:17 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:36241 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaASTCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:02:12 -0500
Date: Sun, 19 Jan 2014 19:58:43 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 14/24] drm/i2c: tda998x: add DT support
Message-ID: <20140119195843.1491091f@armhf>
In-Reply-To: <cover.1390153344.git.moinejf@free.fr>
References: <cover.1390153344.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT support to the tda998x.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
v3
    - remarks from Russell King
	- change the AUDIO_SAMPLE value to 48000 instead of 48
	- don't change the variable type of 'dpms'
	- don't set the clock when S/PDIF input
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index d3e2bb9..98142db 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1177,6 +1177,8 @@ tda998x_encoder_init(struct i2c_client *client,
 		    struct drm_encoder_slave *encoder_slave)
 {
 	struct tda998x_priv *priv;
+	struct device_node *np = client->dev.of_node;
+	u32 video;
 	int ret;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -1246,6 +1248,17 @@ tda998x_encoder_init(struct i2c_client *client,
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
@@ -1260,6 +1273,14 @@ fail:
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
@@ -1272,6 +1293,7 @@ static struct drm_i2c_encoder_driver tda998x_driver = {
 		.remove = tda998x_remove,
 		.driver = {
 			.name = "tda998x",
+			.of_match_table = of_match_ptr(tda998x_dt_ids),
 		},
 		.id_table = tda998x_ids,
 	},
-- 
1.8.5.3

