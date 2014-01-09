Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaAILLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:11:09 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:34502 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbaAILK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:10:56 -0500
Date: Thu, 9 Jan 2014 12:03:24 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 12/28] drm/i2c: tda998x: add DT support
Message-ID: <20140109120324.4e2c8aca@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT support to the tda998x.

As a side effect, now, the audio sample rate is always 48kHz and the
audio clock is always set.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 .../devicetree/bindings/drm/i2c/tda998x.txt | 16 ++++++
 drivers/gpu/drm/i2c/tda998x_drv.c           | 66 ++++++++++++++++------
 2 file changed, 66 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
new file mode 100644
index 0000000..f07339e1
--- /dev/null
+++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
@@ -0,0 +1,16 @@
+Device-Tree bindings for the NXP TDA998x HDMI transmitter
+
+Required properties;
+  - compatible: must be "nxp,tda998x"
+
+Optional properties:
+  - video-ports: 24 bits value - default: <0x230145>
+
+Example:
+
+	tda998x: hdmi-encoder {
+		compatible = "nxp,tda998x";
+		reg = <0x70>;
+		pinctrl-0 = <&pmx_camera>;
+		pinctrl-names = "default";
+	};
diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 2ba0355..b87802f 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -28,17 +28,22 @@
 
 #define DBG(fmt, ...) DRM_DEBUG(fmt"\n", ##__VA_ARGS__)
 
+#define AUDIO_SAMPLE 48		/* 48 kHz */
+
 struct tda998x_priv {
 	struct i2c_client *cec;
 	struct i2c_client *hdmi;
 	uint16_t rev;
 	uint8_t current_page;
-	int dpms;
+	u8 dpms;
 	bool is_hdmi_sink;
 	u8 vip_cntrl_0;
 	u8 vip_cntrl_1;
 	u8 vip_cntrl_2;
-	struct tda998x_encoder_params params;
+
+	u8 audio_type;		/* audio type */
+	u8 audio_frame[6];
+	u32 audio_port;
 };
 
 #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
@@ -539,7 +544,7 @@ tda998x_write_if(struct tda998x_priv *priv, uint8_t bit, uint16_t addr,
 }
 
 static void
-tda998x_write_aif(struct tda998x_priv *priv, struct tda998x_encoder_params *p)
+tda998x_write_aif(struct tda998x_priv *priv)
 {
 	u8 buf[PB(HDMI_AUDIO_INFOFRAME_SIZE) + 1];
 
@@ -547,10 +552,10 @@ tda998x_write_aif(struct tda998x_priv *priv, struct tda998x_encoder_params *p)
 	buf[HB(0)] = HDMI_INFOFRAME_TYPE_AUDIO;
 	buf[HB(1)] = 0x01;
 	buf[HB(2)] = HDMI_AUDIO_INFOFRAME_SIZE;
-	buf[PB(1)] = p->audio_frame[1] & 0x07; /* CC */
-	buf[PB(2)] = p->audio_frame[2] & 0x1c; /* SF */
-	buf[PB(4)] = p->audio_frame[4];
-	buf[PB(5)] = p->audio_frame[5] & 0xf8; /* DM_INH + LSV */
+	buf[PB(1)] = priv->audio_frame[1] & 0x07; /* CC */
+	buf[PB(2)] = priv->audio_frame[2] & 0x1c; /* SF */
+	buf[PB(4)] = priv->audio_frame[4];
+	buf[PB(5)] = priv->audio_frame[5] & 0xf8; /* DM_INH + LSV */
 
 	tda998x_write_if(priv, DIP_IF_FLAGS_IF4, REG_IF4_HB0, buf,
 			 sizeof(buf));
@@ -586,17 +591,17 @@ static void tda998x_audio_mute(struct tda998x_priv *priv, bool on)
 
 static void
 tda998x_configure_audio(struct tda998x_priv *priv,
-		struct drm_display_mode *mode, struct tda998x_encoder_params *p)
+		struct drm_display_mode *mode)
 {
 	uint8_t buf[6], clksel_aip, clksel_fs, ca_i2s, cts_n, adiv;
 	uint32_t n;
 
 	/* Enable audio ports */
-	reg_write(priv, REG_ENA_AP, p->audio_cfg);
-	reg_write(priv, REG_ENA_ACLK, p->audio_clk_cfg);
+	reg_write(priv, REG_ENA_AP, priv->audio_port);
+	reg_write(priv, REG_ENA_ACLK, 0x01);	/* enable clock */
 
 	/* Set audio input source */
-	switch (p->audio_format) {
+	switch (priv->audio_type) {
 	case AFMT_SPDIF:
 		reg_write(priv, REG_MUX_AP, 0x40);
 		clksel_aip = AIP_CLKSEL_AIP(0);
@@ -644,7 +649,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	 * This is the approximate value of N, which happens to be
 	 * the recommended values for non-coherent clocks.
 	 */
-	n = 128 * p->audio_sample_rate / 1000;
+	n = 128 * AUDIO_SAMPLE;		/* acr_n = 128 * sample_rate / 1000 */
 
 	/* Write the CTS and N values */
 	buf[0] = 0x44;
@@ -674,7 +679,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	tda998x_audio_mute(priv, false);
 
 	/* Write the audio information packet */
-	tda998x_write_aif(priv, p);
+	tda998x_write_aif(priv);
 }
 
 /* DRM encoder functions */
@@ -698,7 +703,13 @@ tda998x_encoder_set_config(struct drm_encoder *encoder, void *params)
 			    VIP_CNTRL_2_SWAP_F(p->swap_f) |
 			    (p->mirr_f ? VIP_CNTRL_2_MIRR_F : 0);
 
-	priv->params = *p;
+	memcpy(priv->audio_frame, p->audio_frame,
+			sizeof priv->audio_frame);
+
+	if (p->audio_cfg) {
+		priv->audio_port = p->audio_cfg;
+		priv->audio_type = p->audio_format;
+	}
 }
 
 static void
@@ -947,8 +958,8 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 
 		tda998x_write_avi(priv, mode);
 
-		if (priv->params.audio_cfg)
-			tda998x_configure_audio(priv, mode, &priv->params);
+		if (priv->audio_type)
+			tda998x_configure_audio(priv, mode);
 	}
 }
 
@@ -1157,6 +1168,8 @@ tda998x_encoder_init(struct i2c_client *client,
 		    struct drm_encoder_slave *encoder_slave)
 {
 	struct tda998x_priv *priv;
+	struct device_node *np = client->dev.of_node;
+	u32 video;
 	int ret;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -1166,6 +1179,7 @@ tda998x_encoder_init(struct i2c_client *client,
 	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(2) | VIP_CNTRL_0_SWAP_B(3);
 	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
 	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5);
+	priv->audio_frame[1] = 1;		/* channels - 1 */
 
 	priv->current_page = 0xff;
 	priv->hdmi = client;
@@ -1225,6 +1239,17 @@ tda998x_encoder_init(struct i2c_client *client,
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
@@ -1239,6 +1264,14 @@ fail:
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
@@ -1251,6 +1284,7 @@ static struct drm_i2c_encoder_driver tda998x_driver = {
 		.remove = tda998x_remove,
 		.driver = {
 			.name = "tda998x",
+			.of_match_table = of_match_ptr(tda998x_dt_ids),
 		},
 		.id_table = tda998x_ids,
 	},
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
