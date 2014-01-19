Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaASS7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 13:59:45 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:54690 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbaASS7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 13:59:39 -0500
Date: Sun, 19 Jan 2014 19:58:37 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 01/24] drm/i2c: tda998x: simplify the i2c read/write
 functions
Message-ID: <20140119195837.1bf879f6@armhf>
In-Reply-To: <cover.1390153344.git.moinejf@free.fr>
References: <cover.1390153344.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies the i2c read/write functions and permits them to
be easily called in more contexts.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 322 +++++++++++++++++++-------------------
 1 file changed, 162 insertions(+), 160 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 400b0c4..26dd299 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -30,6 +30,7 @@
 
 struct tda998x_priv {
 	struct i2c_client *cec;
+	struct i2c_client *hdmi;
 	uint16_t rev;
 	uint8_t current_page;
 	int dpms;
@@ -328,9 +329,9 @@ struct tda998x_priv {
 #define TDA19988                  0x0301
 
 static void
-cec_write(struct drm_encoder *encoder, uint16_t addr, uint8_t val)
+cec_write(struct tda998x_priv *priv, uint16_t addr, uint8_t val)
 {
-	struct i2c_client *client = to_tda998x_priv(encoder)->cec;
+	struct i2c_client *client = priv->cec;
 	uint8_t buf[] = {addr, val};
 	int ret;
 
@@ -340,9 +341,9 @@ cec_write(struct drm_encoder *encoder, uint16_t addr, uint8_t val)
 }
 
 static uint8_t
-cec_read(struct drm_encoder *encoder, uint8_t addr)
+cec_read(struct tda998x_priv *priv, uint8_t addr)
 {
-	struct i2c_client *client = to_tda998x_priv(encoder)->cec;
+	struct i2c_client *client = priv->cec;
 	uint8_t val;
 	int ret;
 
@@ -362,12 +363,10 @@ fail:
 }
 
 static void
-set_page(struct drm_encoder *encoder, uint16_t reg)
+set_page(struct tda998x_priv *priv, uint16_t reg)
 {
-	struct tda998x_priv *priv = to_tda998x_priv(encoder);
-
 	if (REG2PAGE(reg) != priv->current_page) {
-		struct i2c_client *client = drm_i2c_encoder_get_client(encoder);
+		struct i2c_client *client = priv->hdmi;
 		uint8_t buf[] = {
 				REG_CURPAGE, REG2PAGE(reg)
 		};
@@ -380,13 +379,13 @@ set_page(struct drm_encoder *encoder, uint16_t reg)
 }
 
 static int
-reg_read_range(struct drm_encoder *encoder, uint16_t reg, char *buf, int cnt)
+reg_read_range(struct tda998x_priv *priv, uint16_t reg, char *buf, int cnt)
 {
-	struct i2c_client *client = drm_i2c_encoder_get_client(encoder);
+	struct i2c_client *client = priv->hdmi;
 	uint8_t addr = REG2ADDR(reg);
 	int ret;
 
-	set_page(encoder, reg);
+	set_page(priv, reg);
 
 	ret = i2c_master_send(client, &addr, sizeof(addr));
 	if (ret < 0)
@@ -404,16 +403,16 @@ fail:
 }
 
 static void
-reg_write_range(struct drm_encoder *encoder, uint16_t reg, uint8_t *p, int cnt)
+reg_write_range(struct tda998x_priv *priv, uint16_t reg, uint8_t *p, int cnt)
 {
-	struct i2c_client *client = drm_i2c_encoder_get_client(encoder);
+	struct i2c_client *client = priv->hdmi;
 	uint8_t buf[cnt+1];
 	int ret;
 
 	buf[0] = REG2ADDR(reg);
 	memcpy(&buf[1], p, cnt);
 
-	set_page(encoder, reg);
+	set_page(priv, reg);
 
 	ret = i2c_master_send(client, buf, cnt + 1);
 	if (ret < 0)
@@ -421,21 +420,21 @@ reg_write_range(struct drm_encoder *encoder, uint16_t reg, uint8_t *p, int cnt)
 }
 
 static uint8_t
-reg_read(struct drm_encoder *encoder, uint16_t reg)
+reg_read(struct tda998x_priv *priv, uint16_t reg)
 {
 	uint8_t val = 0;
-	reg_read_range(encoder, reg, &val, sizeof(val));
+	reg_read_range(priv, reg, &val, sizeof(val));
 	return val;
 }
 
 static void
-reg_write(struct drm_encoder *encoder, uint16_t reg, uint8_t val)
+reg_write(struct tda998x_priv *priv, uint16_t reg, uint8_t val)
 {
-	struct i2c_client *client = drm_i2c_encoder_get_client(encoder);
+	struct i2c_client *client = priv->hdmi;
 	uint8_t buf[] = {REG2ADDR(reg), val};
 	int ret;
 
-	set_page(encoder, reg);
+	set_page(priv, reg);
 
 	ret = i2c_master_send(client, buf, ARRAY_SIZE(buf));
 	if (ret < 0)
@@ -443,13 +442,13 @@ reg_write(struct drm_encoder *encoder, uint16_t reg, uint8_t val)
 }
 
 static void
-reg_write16(struct drm_encoder *encoder, uint16_t reg, uint16_t val)
+reg_write16(struct tda998x_priv *priv, uint16_t reg, uint16_t val)
 {
-	struct i2c_client *client = drm_i2c_encoder_get_client(encoder);
+	struct i2c_client *client = priv->hdmi;
 	uint8_t buf[] = {REG2ADDR(reg), val >> 8, val};
 	int ret;
 
-	set_page(encoder, reg);
+	set_page(priv, reg);
 
 	ret = i2c_master_send(client, buf, ARRAY_SIZE(buf));
 	if (ret < 0)
@@ -457,47 +456,47 @@ reg_write16(struct drm_encoder *encoder, uint16_t reg, uint16_t val)
 }
 
 static void
-reg_set(struct drm_encoder *encoder, uint16_t reg, uint8_t val)
+reg_set(struct tda998x_priv *priv, uint16_t reg, uint8_t val)
 {
-	reg_write(encoder, reg, reg_read(encoder, reg) | val);
+	reg_write(priv, reg, reg_read(priv, reg) | val);
 }
 
 static void
-reg_clear(struct drm_encoder *encoder, uint16_t reg, uint8_t val)
+reg_clear(struct tda998x_priv *priv, uint16_t reg, uint8_t val)
 {
-	reg_write(encoder, reg, reg_read(encoder, reg) & ~val);
+	reg_write(priv, reg, reg_read(priv, reg) & ~val);
 }
 
 static void
-tda998x_reset(struct drm_encoder *encoder)
+tda998x_reset(struct tda998x_priv *priv)
 {
 	/* reset audio and i2c master: */
-	reg_set(encoder, REG_SOFTRESET, SOFTRESET_AUDIO | SOFTRESET_I2C_MASTER);
+	reg_set(priv, REG_SOFTRESET, SOFTRESET_AUDIO | SOFTRESET_I2C_MASTER);
 	msleep(50);
-	reg_clear(encoder, REG_SOFTRESET, SOFTRESET_AUDIO | SOFTRESET_I2C_MASTER);
+	reg_clear(priv, REG_SOFTRESET, SOFTRESET_AUDIO | SOFTRESET_I2C_MASTER);
 	msleep(50);
 
 	/* reset transmitter: */
-	reg_set(encoder, REG_MAIN_CNTRL0, MAIN_CNTRL0_SR);
-	reg_clear(encoder, REG_MAIN_CNTRL0, MAIN_CNTRL0_SR);
+	reg_set(priv, REG_MAIN_CNTRL0, MAIN_CNTRL0_SR);
+	reg_clear(priv, REG_MAIN_CNTRL0, MAIN_CNTRL0_SR);
 
 	/* PLL registers common configuration */
-	reg_write(encoder, REG_PLL_SERIAL_1, 0x00);
-	reg_write(encoder, REG_PLL_SERIAL_2, PLL_SERIAL_2_SRL_NOSC(1));
-	reg_write(encoder, REG_PLL_SERIAL_3, 0x00);
-	reg_write(encoder, REG_SERIALIZER,   0x00);
-	reg_write(encoder, REG_BUFFER_OUT,   0x00);
-	reg_write(encoder, REG_PLL_SCG1,     0x00);
-	reg_write(encoder, REG_AUDIO_DIV,    AUDIO_DIV_SERCLK_8);
-	reg_write(encoder, REG_SEL_CLK,      SEL_CLK_SEL_CLK1 | SEL_CLK_ENA_SC_CLK);
-	reg_write(encoder, REG_PLL_SCGN1,    0xfa);
-	reg_write(encoder, REG_PLL_SCGN2,    0x00);
-	reg_write(encoder, REG_PLL_SCGR1,    0x5b);
-	reg_write(encoder, REG_PLL_SCGR2,    0x00);
-	reg_write(encoder, REG_PLL_SCG2,     0x10);
+	reg_write(priv, REG_PLL_SERIAL_1, 0x00);
+	reg_write(priv, REG_PLL_SERIAL_2, PLL_SERIAL_2_SRL_NOSC(1));
+	reg_write(priv, REG_PLL_SERIAL_3, 0x00);
+	reg_write(priv, REG_SERIALIZER,   0x00);
+	reg_write(priv, REG_BUFFER_OUT,   0x00);
+	reg_write(priv, REG_PLL_SCG1,     0x00);
+	reg_write(priv, REG_AUDIO_DIV,    AUDIO_DIV_SERCLK_8);
+	reg_write(priv, REG_SEL_CLK,      SEL_CLK_SEL_CLK1 | SEL_CLK_ENA_SC_CLK);
+	reg_write(priv, REG_PLL_SCGN1,    0xfa);
+	reg_write(priv, REG_PLL_SCGN2,    0x00);
+	reg_write(priv, REG_PLL_SCGR1,    0x5b);
+	reg_write(priv, REG_PLL_SCGR2,    0x00);
+	reg_write(priv, REG_PLL_SCG2,     0x10);
 
 	/* Write the default value MUX register */
-	reg_write(encoder, REG_MUX_VP_VIP_OUT, 0x24);
+	reg_write(priv, REG_MUX_VP_VIP_OUT, 0x24);
 }
 
 static uint8_t tda998x_cksum(uint8_t *buf, size_t bytes)
@@ -513,18 +512,18 @@ static uint8_t tda998x_cksum(uint8_t *buf, size_t bytes)
 #define PB(x) (HB(2) + 1 + (x))
 
 static void
-tda998x_write_if(struct drm_encoder *encoder, uint8_t bit, uint16_t addr,
+tda998x_write_if(struct tda998x_priv *priv, uint8_t bit, uint16_t addr,
 		 uint8_t *buf, size_t size)
 {
 	buf[PB(0)] = tda998x_cksum(buf, size);
 
-	reg_clear(encoder, REG_DIP_IF_FLAGS, bit);
-	reg_write_range(encoder, addr, buf, size);
-	reg_set(encoder, REG_DIP_IF_FLAGS, bit);
+	reg_clear(priv, REG_DIP_IF_FLAGS, bit);
+	reg_write_range(priv, addr, buf, size);
+	reg_set(priv, REG_DIP_IF_FLAGS, bit);
 }
 
 static void
-tda998x_write_aif(struct drm_encoder *encoder, struct tda998x_encoder_params *p)
+tda998x_write_aif(struct tda998x_priv *priv, struct tda998x_encoder_params *p)
 {
 	uint8_t buf[PB(5) + 1];
 
@@ -537,12 +536,12 @@ tda998x_write_aif(struct drm_encoder *encoder, struct tda998x_encoder_params *p)
 	buf[PB(4)] = p->audio_frame[4];
 	buf[PB(5)] = p->audio_frame[5] & 0xf8; /* DM_INH + LSV */
 
-	tda998x_write_if(encoder, DIP_IF_FLAGS_IF4, REG_IF4_HB0, buf,
+	tda998x_write_if(priv, DIP_IF_FLAGS_IF4, REG_IF4_HB0, buf,
 			 sizeof(buf));
 }
 
 static void
-tda998x_write_avi(struct drm_encoder *encoder, struct drm_display_mode *mode)
+tda998x_write_avi(struct tda998x_priv *priv, struct drm_display_mode *mode)
 {
 	uint8_t buf[PB(13) + 1];
 
@@ -554,36 +553,36 @@ tda998x_write_avi(struct drm_encoder *encoder, struct drm_display_mode *mode)
 	buf[PB(3)] = HDMI_QUANTIZATION_RANGE_FULL << 2;
 	buf[PB(4)] = drm_match_cea_mode(mode);
 
-	tda998x_write_if(encoder, DIP_IF_FLAGS_IF2, REG_IF2_HB0, buf,
+	tda998x_write_if(priv, DIP_IF_FLAGS_IF2, REG_IF2_HB0, buf,
 			 sizeof(buf));
 }
 
-static void tda998x_audio_mute(struct drm_encoder *encoder, bool on)
+static void tda998x_audio_mute(struct tda998x_priv *priv, bool on)
 {
 	if (on) {
-		reg_set(encoder, REG_SOFTRESET, SOFTRESET_AUDIO);
-		reg_clear(encoder, REG_SOFTRESET, SOFTRESET_AUDIO);
-		reg_set(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_FIFO);
+		reg_set(priv, REG_SOFTRESET, SOFTRESET_AUDIO);
+		reg_clear(priv, REG_SOFTRESET, SOFTRESET_AUDIO);
+		reg_set(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_FIFO);
 	} else {
-		reg_clear(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_FIFO);
+		reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_FIFO);
 	}
 }
 
 static void
-tda998x_configure_audio(struct drm_encoder *encoder,
+tda998x_configure_audio(struct tda998x_priv *priv,
 		struct drm_display_mode *mode, struct tda998x_encoder_params *p)
 {
 	uint8_t buf[6], clksel_aip, clksel_fs, ca_i2s, cts_n, adiv;
 	uint32_t n;
 
 	/* Enable audio ports */
-	reg_write(encoder, REG_ENA_AP, p->audio_cfg);
-	reg_write(encoder, REG_ENA_ACLK, p->audio_clk_cfg);
+	reg_write(priv, REG_ENA_AP, p->audio_cfg);
+	reg_write(priv, REG_ENA_ACLK, p->audio_clk_cfg);
 
 	/* Set audio input source */
 	switch (p->audio_format) {
 	case AFMT_SPDIF:
-		reg_write(encoder, REG_MUX_AP, 0x40);
+		reg_write(priv, REG_MUX_AP, 0x40);
 		clksel_aip = AIP_CLKSEL_AIP(0);
 		/* FS64SPDIF */
 		clksel_fs = AIP_CLKSEL_FS(2);
@@ -592,7 +591,7 @@ tda998x_configure_audio(struct drm_encoder *encoder,
 		break;
 
 	case AFMT_I2S:
-		reg_write(encoder, REG_MUX_AP, 0x64);
+		reg_write(priv, REG_MUX_AP, 0x64);
 		clksel_aip = AIP_CLKSEL_AIP(1);
 		/* ACLK */
 		clksel_fs = AIP_CLKSEL_FS(0);
@@ -605,12 +604,12 @@ tda998x_configure_audio(struct drm_encoder *encoder,
 		return;
 	}
 
-	reg_write(encoder, REG_AIP_CLKSEL, clksel_aip);
-	reg_clear(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT);
+	reg_write(priv, REG_AIP_CLKSEL, clksel_aip);
+	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT);
 
 	/* Enable automatic CTS generation */
-	reg_clear(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_ACR_MAN);
-	reg_write(encoder, REG_CTS_N, cts_n);
+	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_ACR_MAN);
+	reg_write(priv, REG_CTS_N, cts_n);
 
 	/*
 	 * Audio input somehow depends on HDMI line rate which is
@@ -623,7 +622,7 @@ tda998x_configure_audio(struct drm_encoder *encoder,
 		adiv = AUDIO_DIV_SERCLK_16;
 	else
 		adiv = AUDIO_DIV_SERCLK_8;
-	reg_write(encoder, REG_AUDIO_DIV, adiv);
+	reg_write(priv, REG_AUDIO_DIV, adiv);
 
 	/*
 	 * This is the approximate value of N, which happens to be
@@ -638,28 +637,28 @@ tda998x_configure_audio(struct drm_encoder *encoder,
 	buf[3] = n;
 	buf[4] = n >> 8;
 	buf[5] = n >> 16;
-	reg_write_range(encoder, REG_ACR_CTS_0, buf, 6);
+	reg_write_range(priv, REG_ACR_CTS_0, buf, 6);
 
 	/* Set CTS clock reference */
-	reg_write(encoder, REG_AIP_CLKSEL, clksel_aip | clksel_fs);
+	reg_write(priv, REG_AIP_CLKSEL, clksel_aip | clksel_fs);
 
 	/* Reset CTS generator */
-	reg_set(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_CTS);
-	reg_clear(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_CTS);
+	reg_set(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_CTS);
+	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_CTS);
 
 	/* Write the channel status */
 	buf[0] = 0x04;
 	buf[1] = 0x00;
 	buf[2] = 0x00;
 	buf[3] = 0xf1;
-	reg_write_range(encoder, REG_CH_STAT_B(0), buf, 4);
+	reg_write_range(priv, REG_CH_STAT_B(0), buf, 4);
 
-	tda998x_audio_mute(encoder, true);
+	tda998x_audio_mute(priv, true);
 	mdelay(20);
-	tda998x_audio_mute(encoder, false);
+	tda998x_audio_mute(priv, false);
 
 	/* Write the audio information packet */
-	tda998x_write_aif(encoder, p);
+	tda998x_write_aif(priv, p);
 }
 
 /* DRM encoder functions */
@@ -701,19 +700,19 @@ tda998x_encoder_dpms(struct drm_encoder *encoder, int mode)
 	switch (mode) {
 	case DRM_MODE_DPMS_ON:
 		/* enable video ports, audio will be enabled later */
-		reg_write(encoder, REG_ENA_VP_0, 0xff);
-		reg_write(encoder, REG_ENA_VP_1, 0xff);
-		reg_write(encoder, REG_ENA_VP_2, 0xff);
+		reg_write(priv, REG_ENA_VP_0, 0xff);
+		reg_write(priv, REG_ENA_VP_1, 0xff);
+		reg_write(priv, REG_ENA_VP_2, 0xff);
 		/* set muxing after enabling ports: */
-		reg_write(encoder, REG_VIP_CNTRL_0, priv->vip_cntrl_0);
-		reg_write(encoder, REG_VIP_CNTRL_1, priv->vip_cntrl_1);
-		reg_write(encoder, REG_VIP_CNTRL_2, priv->vip_cntrl_2);
+		reg_write(priv, REG_VIP_CNTRL_0, priv->vip_cntrl_0);
+		reg_write(priv, REG_VIP_CNTRL_1, priv->vip_cntrl_1);
+		reg_write(priv, REG_VIP_CNTRL_2, priv->vip_cntrl_2);
 		break;
 	case DRM_MODE_DPMS_OFF:
 		/* disable video ports */
-		reg_write(encoder, REG_ENA_VP_0, 0x00);
-		reg_write(encoder, REG_ENA_VP_1, 0x00);
-		reg_write(encoder, REG_ENA_VP_2, 0x00);
+		reg_write(priv, REG_ENA_VP_0, 0x00);
+		reg_write(priv, REG_ENA_VP_1, 0x00);
+		reg_write(priv, REG_ENA_VP_2, 0x00);
 		break;
 	}
 
@@ -826,57 +825,57 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	div = 148500 / mode->clock;
 
 	/* mute the audio FIFO: */
-	reg_set(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_FIFO);
+	reg_set(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_FIFO);
 
 	/* set HDMI HDCP mode off: */
-	reg_set(encoder, REG_TBG_CNTRL_1, TBG_CNTRL_1_DWIN_DIS);
-	reg_clear(encoder, REG_TX33, TX33_HDMI);
+	reg_set(priv, REG_TBG_CNTRL_1, TBG_CNTRL_1_DWIN_DIS);
+	reg_clear(priv, REG_TX33, TX33_HDMI);
+	reg_write(priv, REG_ENC_CNTRL, ENC_CNTRL_CTL_CODE(0));
 
-	reg_write(encoder, REG_ENC_CNTRL, ENC_CNTRL_CTL_CODE(0));
 	/* no pre-filter or interpolator: */
-	reg_write(encoder, REG_HVF_CNTRL_0, HVF_CNTRL_0_PREFIL(0) |
+	reg_write(priv, REG_HVF_CNTRL_0, HVF_CNTRL_0_PREFIL(0) |
 			HVF_CNTRL_0_INTPOL(0));
-	reg_write(encoder, REG_VIP_CNTRL_5, VIP_CNTRL_5_SP_CNT(0));
-	reg_write(encoder, REG_VIP_CNTRL_4, VIP_CNTRL_4_BLANKIT(0) |
+	reg_write(priv, REG_VIP_CNTRL_5, VIP_CNTRL_5_SP_CNT(0));
+	reg_write(priv, REG_VIP_CNTRL_4, VIP_CNTRL_4_BLANKIT(0) |
 			VIP_CNTRL_4_BLC(0));
-	reg_clear(encoder, REG_PLL_SERIAL_3, PLL_SERIAL_3_SRL_CCIR);
+	reg_clear(priv, REG_PLL_SERIAL_3, PLL_SERIAL_3_SRL_CCIR);
 
-	reg_clear(encoder, REG_PLL_SERIAL_1, PLL_SERIAL_1_SRL_MAN_IZ);
-	reg_clear(encoder, REG_PLL_SERIAL_3, PLL_SERIAL_3_SRL_DE);
-	reg_write(encoder, REG_SERIALIZER, 0);
-	reg_write(encoder, REG_HVF_CNTRL_1, HVF_CNTRL_1_VQR(0));
+	reg_clear(priv, REG_PLL_SERIAL_1, PLL_SERIAL_1_SRL_MAN_IZ);
+	reg_clear(priv, REG_PLL_SERIAL_3, PLL_SERIAL_3_SRL_DE);
+	reg_write(priv, REG_SERIALIZER, 0);
+	reg_write(priv, REG_HVF_CNTRL_1, HVF_CNTRL_1_VQR(0));
 
 	/* TODO enable pixel repeat for pixel rates less than 25Msamp/s */
 	rep = 0;
-	reg_write(encoder, REG_RPT_CNTRL, 0);
-	reg_write(encoder, REG_SEL_CLK, SEL_CLK_SEL_VRF_CLK(0) |
+	reg_write(priv, REG_RPT_CNTRL, 0);
+	reg_write(priv, REG_SEL_CLK, SEL_CLK_SEL_VRF_CLK(0) |
 			SEL_CLK_SEL_CLK1 | SEL_CLK_ENA_SC_CLK);
 
-	reg_write(encoder, REG_PLL_SERIAL_2, PLL_SERIAL_2_SRL_NOSC(div) |
+	reg_write(priv, REG_PLL_SERIAL_2, PLL_SERIAL_2_SRL_NOSC(div) |
 			PLL_SERIAL_2_SRL_PR(rep));
 
 	/* set color matrix bypass flag: */
-	reg_set(encoder, REG_MAT_CONTRL, MAT_CONTRL_MAT_BP);
+	reg_set(priv, REG_MAT_CONTRL, MAT_CONTRL_MAT_BP);
 
 	/* set BIAS tmds value: */
-	reg_write(encoder, REG_ANA_GENERAL, 0x09);
+	reg_write(priv, REG_ANA_GENERAL, 0x09);
 
-	reg_clear(encoder, REG_TBG_CNTRL_0, TBG_CNTRL_0_SYNC_MTHD);
+	reg_clear(priv, REG_TBG_CNTRL_0, TBG_CNTRL_0_SYNC_MTHD);
 
 	/*
 	 * Sync on rising HSYNC/VSYNC
 	 */
-	reg_write(encoder, REG_VIP_CNTRL_3, 0);
-	reg_set(encoder, REG_VIP_CNTRL_3, VIP_CNTRL_3_SYNC_HS);
+	reg_write(priv, REG_VIP_CNTRL_3, 0);
+	reg_set(priv, REG_VIP_CNTRL_3, VIP_CNTRL_3_SYNC_HS);
 
 	/*
 	 * TDA19988 requires high-active sync at input stage,
 	 * so invert low-active sync provided by master encoder here
 	 */
 	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
-		reg_set(encoder, REG_VIP_CNTRL_3, VIP_CNTRL_3_H_TGL);
+		reg_set(priv, REG_VIP_CNTRL_3, VIP_CNTRL_3_H_TGL);
 	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
-		reg_set(encoder, REG_VIP_CNTRL_3, VIP_CNTRL_3_V_TGL);
+		reg_set(priv, REG_VIP_CNTRL_3, VIP_CNTRL_3_V_TGL);
 
 	/*
 	 * Always generate sync polarity relative to input sync and
@@ -887,49 +886,49 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 		reg |= TBG_CNTRL_1_H_TGL;
 	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
 		reg |= TBG_CNTRL_1_V_TGL;
-	reg_write(encoder, REG_TBG_CNTRL_1, reg);
-
-	reg_write(encoder, REG_VIDFORMAT, 0x00);
-	reg_write16(encoder, REG_REFPIX_MSB, ref_pix);
-	reg_write16(encoder, REG_REFLINE_MSB, ref_line);
-	reg_write16(encoder, REG_NPIX_MSB, n_pix);
-	reg_write16(encoder, REG_NLINE_MSB, n_line);
-	reg_write16(encoder, REG_VS_LINE_STRT_1_MSB, vs1_line_s);
-	reg_write16(encoder, REG_VS_PIX_STRT_1_MSB, vs1_pix_s);
-	reg_write16(encoder, REG_VS_LINE_END_1_MSB, vs1_line_e);
-	reg_write16(encoder, REG_VS_PIX_END_1_MSB, vs1_pix_e);
-	reg_write16(encoder, REG_VS_LINE_STRT_2_MSB, vs2_line_s);
-	reg_write16(encoder, REG_VS_PIX_STRT_2_MSB, vs2_pix_s);
-	reg_write16(encoder, REG_VS_LINE_END_2_MSB, vs2_line_e);
-	reg_write16(encoder, REG_VS_PIX_END_2_MSB, vs2_pix_e);
-	reg_write16(encoder, REG_HS_PIX_START_MSB, hs_pix_s);
-	reg_write16(encoder, REG_HS_PIX_STOP_MSB, hs_pix_e);
-	reg_write16(encoder, REG_VWIN_START_1_MSB, vwin1_line_s);
-	reg_write16(encoder, REG_VWIN_END_1_MSB, vwin1_line_e);
-	reg_write16(encoder, REG_VWIN_START_2_MSB, vwin2_line_s);
-	reg_write16(encoder, REG_VWIN_END_2_MSB, vwin2_line_e);
-	reg_write16(encoder, REG_DE_START_MSB, de_pix_s);
-	reg_write16(encoder, REG_DE_STOP_MSB, de_pix_e);
+	reg_write(priv, REG_TBG_CNTRL_1, reg);
+
+	reg_write(priv, REG_VIDFORMAT, 0x00);
+	reg_write16(priv, REG_REFPIX_MSB, ref_pix);
+	reg_write16(priv, REG_REFLINE_MSB, ref_line);
+	reg_write16(priv, REG_NPIX_MSB, n_pix);
+	reg_write16(priv, REG_NLINE_MSB, n_line);
+	reg_write16(priv, REG_VS_LINE_STRT_1_MSB, vs1_line_s);
+	reg_write16(priv, REG_VS_PIX_STRT_1_MSB, vs1_pix_s);
+	reg_write16(priv, REG_VS_LINE_END_1_MSB, vs1_line_e);
+	reg_write16(priv, REG_VS_PIX_END_1_MSB, vs1_pix_e);
+	reg_write16(priv, REG_VS_LINE_STRT_2_MSB, vs2_line_s);
+	reg_write16(priv, REG_VS_PIX_STRT_2_MSB, vs2_pix_s);
+	reg_write16(priv, REG_VS_LINE_END_2_MSB, vs2_line_e);
+	reg_write16(priv, REG_VS_PIX_END_2_MSB, vs2_pix_e);
+	reg_write16(priv, REG_HS_PIX_START_MSB, hs_pix_s);
+	reg_write16(priv, REG_HS_PIX_STOP_MSB, hs_pix_e);
+	reg_write16(priv, REG_VWIN_START_1_MSB, vwin1_line_s);
+	reg_write16(priv, REG_VWIN_END_1_MSB, vwin1_line_e);
+	reg_write16(priv, REG_VWIN_START_2_MSB, vwin2_line_s);
+	reg_write16(priv, REG_VWIN_END_2_MSB, vwin2_line_e);
+	reg_write16(priv, REG_DE_START_MSB, de_pix_s);
+	reg_write16(priv, REG_DE_STOP_MSB, de_pix_e);
 
 	if (priv->rev == TDA19988) {
 		/* let incoming pixels fill the active space (if any) */
-		reg_write(encoder, REG_ENABLE_SPACE, 0x01);
+		reg_write(priv, REG_ENABLE_SPACE, 0x01);
 	}
 
 	/* must be last register set: */
-	reg_clear(encoder, REG_TBG_CNTRL_0, TBG_CNTRL_0_SYNC_ONCE);
+	reg_clear(priv, REG_TBG_CNTRL_0, TBG_CNTRL_0_SYNC_ONCE);
 
 	/* Only setup the info frames if the sink is HDMI */
 	if (priv->is_hdmi_sink) {
 		/* We need to turn HDMI HDCP stuff on to get audio through */
-		reg_clear(encoder, REG_TBG_CNTRL_1, TBG_CNTRL_1_DWIN_DIS);
-		reg_write(encoder, REG_ENC_CNTRL, ENC_CNTRL_CTL_CODE(1));
-		reg_set(encoder, REG_TX33, TX33_HDMI);
+		reg_clear(priv, REG_TBG_CNTRL_1, TBG_CNTRL_1_DWIN_DIS);
+		reg_write(priv, REG_ENC_CNTRL, ENC_CNTRL_CTL_CODE(1));
+		reg_set(priv, REG_TX33, TX33_HDMI);
 
-		tda998x_write_avi(encoder, adjusted_mode);
+		tda998x_write_avi(priv, adjusted_mode);
 
 		if (priv->params.audio_cfg)
-			tda998x_configure_audio(encoder, adjusted_mode,
+			tda998x_configure_audio(priv, adjusted_mode,
 						&priv->params);
 	}
 }
@@ -938,7 +937,9 @@ static enum drm_connector_status
 tda998x_encoder_detect(struct drm_encoder *encoder,
 		      struct drm_connector *connector)
 {
-	uint8_t val = cec_read(encoder, REG_CEC_RXSHPDLEV);
+	struct tda998x_priv *priv = to_tda998x_priv(encoder);
+	uint8_t val = cec_read(priv, REG_CEC_RXSHPDLEV);
+
 	return (val & CEC_RXSHPDLEV_HPD) ? connector_status_connected :
 			connector_status_disconnected;
 }
@@ -946,29 +947,30 @@ tda998x_encoder_detect(struct drm_encoder *encoder,
 static int
 read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 {
+	struct tda998x_priv *priv = to_tda998x_priv(encoder);
 	uint8_t offset, segptr;
 	int ret, i;
 
 	/* enable EDID read irq: */
-	reg_set(encoder, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
+	reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
 
 	offset = (blk & 1) ? 128 : 0;
 	segptr = blk / 2;
 
-	reg_write(encoder, REG_DDC_ADDR, 0xa0);
-	reg_write(encoder, REG_DDC_OFFS, offset);
-	reg_write(encoder, REG_DDC_SEGM_ADDR, 0x60);
-	reg_write(encoder, REG_DDC_SEGM, segptr);
+	reg_write(priv, REG_DDC_ADDR, 0xa0);
+	reg_write(priv, REG_DDC_OFFS, offset);
+	reg_write(priv, REG_DDC_SEGM_ADDR, 0x60);
+	reg_write(priv, REG_DDC_SEGM, segptr);
 
 	/* enable reading EDID: */
-	reg_write(encoder, REG_EDID_CTRL, 0x1);
+	reg_write(priv, REG_EDID_CTRL, 0x1);
 
 	/* flag must be cleared by sw: */
-	reg_write(encoder, REG_EDID_CTRL, 0x0);
+	reg_write(priv, REG_EDID_CTRL, 0x0);
 
 	/* wait for block read to complete: */
 	for (i = 100; i > 0; i--) {
-		uint8_t val = reg_read(encoder, REG_INT_FLAGS_2);
+		uint8_t val = reg_read(priv, REG_INT_FLAGS_2);
 		if (val & INT_FLAGS_2_EDID_BLK_RD)
 			break;
 		msleep(1);
@@ -977,14 +979,14 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 	if (i == 0)
 		return -ETIMEDOUT;
 
-	ret = reg_read_range(encoder, REG_EDID_DATA_0, buf, EDID_LENGTH);
+	ret = reg_read_range(priv, REG_EDID_DATA_0, buf, EDID_LENGTH);
 	if (ret != EDID_LENGTH) {
 		dev_err(encoder->dev->dev, "failed to read edid block %d: %d",
 				blk, ret);
 		return ret;
 	}
 
-	reg_clear(encoder, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
+	reg_clear(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
 
 	return 0;
 }
@@ -1001,7 +1003,7 @@ do_get_edid(struct drm_encoder *encoder)
 		return NULL;
 
 	if (priv->rev == TDA19988)
-		reg_clear(encoder, REG_TX4, TX4_PD_RAM);
+		reg_clear(priv, REG_TX4, TX4_PD_RAM);
 
 	/* base block fetch */
 	if (read_edid_block(encoder, block, 0))
@@ -1041,13 +1043,13 @@ do_get_edid(struct drm_encoder *encoder)
 
 done:
 	if (priv->rev == TDA19988)
-		reg_set(encoder, REG_TX4, TX4_PD_RAM);
+		reg_set(priv, REG_TX4, TX4_PD_RAM);
 
 	return block;
 
 fail:
 	if (priv->rev == TDA19988)
-		reg_set(encoder, REG_TX4, TX4_PD_RAM);
+		reg_set(priv, REG_TX4, TX4_PD_RAM);
 	dev_warn(encoder->dev->dev, "failed to read EDID\n");
 	kfree(block);
 	return NULL;
@@ -1131,7 +1133,6 @@ tda998x_encoder_init(struct i2c_client *client,
 		    struct drm_device *dev,
 		    struct drm_encoder_slave *encoder_slave)
 {
-	struct drm_encoder *encoder = &encoder_slave->base;
 	struct tda998x_priv *priv;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -1143,6 +1144,7 @@ tda998x_encoder_init(struct i2c_client *client,
 	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5);
 
 	priv->current_page = 0;
+	priv->hdmi = client;
 	priv->cec = i2c_new_dummy(client->adapter, 0x34);
 	priv->dpms = DRM_MODE_DPMS_OFF;
 
@@ -1150,14 +1152,14 @@ tda998x_encoder_init(struct i2c_client *client,
 	encoder_slave->slave_funcs = &tda998x_encoder_funcs;
 
 	/* wake up the device: */
-	cec_write(encoder, REG_CEC_ENAMODS,
+	cec_write(priv, REG_CEC_ENAMODS,
 			CEC_ENAMODS_EN_RXSENS | CEC_ENAMODS_EN_HDMI);
 
-	tda998x_reset(encoder);
+	tda998x_reset(priv);
 
 	/* read version: */
-	priv->rev = reg_read(encoder, REG_VERSION_LSB) |
-			reg_read(encoder, REG_VERSION_MSB) << 8;
+	priv->rev = reg_read(priv, REG_VERSION_LSB) |
+			reg_read(priv, REG_VERSION_MSB) << 8;
 
 	/* mask off feature bits: */
 	priv->rev &= ~0x30; /* not-hdcp and not-scalar bit */
@@ -1173,16 +1175,16 @@ tda998x_encoder_init(struct i2c_client *client,
 	}
 
 	/* after reset, enable DDC: */
-	reg_write(encoder, REG_DDC_DISABLE, 0x00);
+	reg_write(priv, REG_DDC_DISABLE, 0x00);
 
 	/* set clock on DDC channel: */
-	reg_write(encoder, REG_TX3, 39);
+	reg_write(priv, REG_TX3, 39);
 
 	/* if necessary, disable multi-master: */
 	if (priv->rev == TDA19989)
-		reg_set(encoder, REG_I2C_MASTER, I2C_MASTER_DIS_MM);
+		reg_set(priv, REG_I2C_MASTER, I2C_MASTER_DIS_MM);
 
-	cec_write(encoder, REG_CEC_FRO_IM_CLK_CTRL,
+	cec_write(priv, REG_CEC_FRO_IM_CLK_CTRL,
 			CEC_FRO_IM_CLK_CTRL_GHOST_DIS | CEC_FRO_IM_CLK_CTRL_IMCLK_SEL);
 
 	return 0;
-- 
1.8.5.3

