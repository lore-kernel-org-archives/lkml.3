Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412Ab3HNTpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:45:13 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:34659 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760140Ab3HNTnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:43:43 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/8] drm/i2c: tda998x: add video and audio input configuration
Date: Wed, 14 Aug 2013 21:43:30 +0200
Message-Id: <1376509413-1462-6-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

This patch adds tda998x specific parameters to allow it to be configured
for different boards using it. Also, this implements rudimentary audio
support for S/PDIF attached controllers.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Darren Etheridge <detheridge@ti.com>
---
Changelog:
for v1:
- set AUDIO_DIV to SERCLK/16 for modes with pixclk >100MHz
- also calculate CTS
v1->v2:
- Remove CTS calculation as it isn't used in current TDA998x setup
  (Reported by Russell King)
- Remove debug left-over (Reported by Russell King)
- Use correct tda998x include (Reported by Russell King)

Cc: David Airlie <airlied@linux.ie>
Cc: Darren Etheridge <detheridge@ti.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpu/drm/i2c/tda998x_drv.c |  268 +++++++++++++++++++++++++++++++++++--
 include/drm/i2c/tda998x.h         |   30 +++++
 2 files changed, 290 insertions(+), 8 deletions(-)
 create mode 100644 include/drm/i2c/tda998x.h

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 527d11b..2b64dfa 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -23,7 +23,7 @@
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_encoder_slave.h>
 #include <drm/drm_edid.h>
-
+#include <drm/i2c/tda998x.h>
 
 #define DBG(fmt, ...) DRM_DEBUG(fmt"\n", ##__VA_ARGS__)
 
@@ -32,9 +32,11 @@ struct tda998x_priv {
 	uint16_t rev;
 	uint8_t current_page;
 	int dpms;
+	bool is_hdmi_sink;
 	u8 vip_cntrl_0;
 	u8 vip_cntrl_1;
 	u8 vip_cntrl_2;
+	struct tda998x_encoder_params params;
 };
 
 #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
@@ -71,10 +73,13 @@ struct tda998x_priv {
 # define I2C_MASTER_DIS_MM        (1 << 0)
 # define I2C_MASTER_DIS_FILT      (1 << 1)
 # define I2C_MASTER_APP_STRT_LAT  (1 << 2)
+#define REG_FEAT_POWERDOWN        REG(0x00, 0x0e)     /* read/write */
+# define FEAT_POWERDOWN_SPDIF     (1 << 3)
 #define REG_INT_FLAGS_0           REG(0x00, 0x0f)     /* read/write */
 #define REG_INT_FLAGS_1           REG(0x00, 0x10)     /* read/write */
 #define REG_INT_FLAGS_2           REG(0x00, 0x11)     /* read/write */
 # define INT_FLAGS_2_EDID_BLK_RD  (1 << 1)
+#define REG_ENA_ACLK              REG(0x00, 0x16)     /* read/write */
 #define REG_ENA_VP_0              REG(0x00, 0x18)     /* read/write */
 #define REG_ENA_VP_1              REG(0x00, 0x19)     /* read/write */
 #define REG_ENA_VP_2              REG(0x00, 0x1a)     /* read/write */
@@ -113,6 +118,7 @@ struct tda998x_priv {
 #define REG_VIP_CNTRL_5           REG(0x00, 0x25)     /* write */
 # define VIP_CNTRL_5_CKCASE       (1 << 0)
 # define VIP_CNTRL_5_SP_CNT(x)    (((x) & 3) << 1)
+#define REG_MUX_AP                REG(0x00, 0x26)     /* read/write */
 #define REG_MUX_VP_VIP_OUT        REG(0x00, 0x27)     /* read/write */
 #define REG_MAT_CONTRL            REG(0x00, 0x80)     /* write */
 # define MAT_CONTRL_MAT_SC(x)     (((x) & 3) << 0)
@@ -175,6 +181,12 @@ struct tda998x_priv {
 # define HVF_CNTRL_1_PAD(x)       (((x) & 3) << 4)
 # define HVF_CNTRL_1_SEMI_PLANAR  (1 << 6)
 #define REG_RPT_CNTRL             REG(0x00, 0xf0)     /* write */
+#define REG_I2S_FORMAT            REG(0x00, 0xfc)     /* read/write */
+# define I2S_FORMAT(x)            (((x) & 3) << 0)
+#define REG_AIP_CLKSEL            REG(0x00, 0xfd)     /* write */
+# define AIP_CLKSEL_FS(x)         (((x) & 3) << 0)
+# define AIP_CLKSEL_CLK_POL(x)    (((x) & 1) << 2)
+# define AIP_CLKSEL_AIP(x)        (((x) & 7) << 3)
 
 
 /* Page 02h: PLL settings */
@@ -198,6 +210,12 @@ struct tda998x_priv {
 #define REG_PLL_SCGR1             REG(0x02, 0x09)     /* read/write */
 #define REG_PLL_SCGR2             REG(0x02, 0x0a)     /* read/write */
 #define REG_AUDIO_DIV             REG(0x02, 0x0e)     /* read/write */
+# define AUDIO_DIV_SERCLK_1       0
+# define AUDIO_DIV_SERCLK_2       1
+# define AUDIO_DIV_SERCLK_4       2
+# define AUDIO_DIV_SERCLK_8       3
+# define AUDIO_DIV_SERCLK_16      4
+# define AUDIO_DIV_SERCLK_32      5
 #define REG_SEL_CLK               REG(0x02, 0x11)     /* read/write */
 # define SEL_CLK_SEL_CLK1         (1 << 0)
 # define SEL_CLK_SEL_VRF_CLK(x)   (((x) & 3) << 1)
@@ -216,6 +234,11 @@ struct tda998x_priv {
 
 
 /* Page 10h: information frames and packets */
+#define REG_IF1_HB0               REG(0x10, 0x20)     /* read/write */
+#define REG_IF2_HB0               REG(0x10, 0x40)     /* read/write */
+#define REG_IF3_HB0               REG(0x10, 0x60)     /* read/write */
+#define REG_IF4_HB0               REG(0x10, 0x80)     /* read/write */
+#define REG_IF5_HB0               REG(0x10, 0xa0)     /* read/write */
 
 
 /* Page 11h: audio settings and content info packets */
@@ -225,10 +248,33 @@ struct tda998x_priv {
 # define AIP_CNTRL_0_LAYOUT       (1 << 2)
 # define AIP_CNTRL_0_ACR_MAN      (1 << 5)
 # define AIP_CNTRL_0_RST_CTS      (1 << 6)
+#define REG_CA_I2S                REG(0x11, 0x01)     /* read/write */
+# define CA_I2S_CA_I2S(x)         (((x) & 31) << 0)
+# define CA_I2S_HBR_CHSTAT        (1 << 6)
+#define REG_LATENCY_RD            REG(0x11, 0x04)     /* read/write */
+#define REG_ACR_CTS_0             REG(0x11, 0x05)     /* read/write */
+#define REG_ACR_CTS_1             REG(0x11, 0x06)     /* read/write */
+#define REG_ACR_CTS_2             REG(0x11, 0x07)     /* read/write */
+#define REG_ACR_N_0               REG(0x11, 0x08)     /* read/write */
+#define REG_ACR_N_1               REG(0x11, 0x09)     /* read/write */
+#define REG_ACR_N_2               REG(0x11, 0x0a)     /* read/write */
+#define REG_CTS_N                 REG(0x11, 0x0c)     /* read/write */
+# define CTS_N_K(x)               (((x) & 7) << 0)
+# define CTS_N_M(x)               (((x) & 3) << 4)
 #define REG_ENC_CNTRL             REG(0x11, 0x0d)     /* read/write */
 # define ENC_CNTRL_RST_ENC        (1 << 0)
 # define ENC_CNTRL_RST_SEL        (1 << 1)
 # define ENC_CNTRL_CTL_CODE(x)    (((x) & 3) << 2)
+#define REG_DIP_FLAGS             REG(0x11, 0x0e)     /* read/write */
+# define DIP_FLAGS_ACR            (1 << 0)
+# define DIP_FLAGS_GC             (1 << 1)
+#define REG_DIP_IF_FLAGS          REG(0x11, 0x0f)     /* read/write */
+# define DIP_IF_FLAGS_IF1         (1 << 1)
+# define DIP_IF_FLAGS_IF2         (1 << 2)
+# define DIP_IF_FLAGS_IF3         (1 << 3)
+# define DIP_IF_FLAGS_IF4         (1 << 4)
+# define DIP_IF_FLAGS_IF5         (1 << 5)
+#define REG_CH_STAT_B(x)          REG(0x11, 0x14 + (x)) /* read/write */
 
 
 /* Page 12h: HDCP and OTP */
@@ -344,6 +390,23 @@ fail:
 	return ret;
 }
 
+static void
+reg_write_range(struct drm_encoder *encoder, uint16_t reg, uint8_t *p, int cnt)
+{
+	struct i2c_client *client = drm_i2c_encoder_get_client(encoder);
+	uint8_t buf[cnt+1];
+	int ret;
+
+	buf[0] = REG2ADDR(reg);
+	memcpy(&buf[1], p, cnt);
+
+	set_page(encoder, reg);
+
+	ret = i2c_master_send(client, buf, cnt + 1);
+	if (ret < 0)
+		dev_err(&client->dev, "Error %d writing to 0x%x\n", ret, reg);
+}
+
 static uint8_t
 reg_read(struct drm_encoder *encoder, uint16_t reg)
 {
@@ -412,7 +475,7 @@ tda998x_reset(struct drm_encoder *encoder)
 	reg_write(encoder, REG_SERIALIZER,   0x00);
 	reg_write(encoder, REG_BUFFER_OUT,   0x00);
 	reg_write(encoder, REG_PLL_SCG1,     0x00);
-	reg_write(encoder, REG_AUDIO_DIV,    0x03);
+	reg_write(encoder, REG_AUDIO_DIV,    AUDIO_DIV_SERCLK_8);
 	reg_write(encoder, REG_SEL_CLK,      SEL_CLK_SEL_CLK1 | SEL_CLK_ENA_SC_CLK);
 	reg_write(encoder, REG_PLL_SCGN1,    0xfa);
 	reg_write(encoder, REG_PLL_SCGN2,    0x00);
@@ -424,11 +487,184 @@ tda998x_reset(struct drm_encoder *encoder)
 	reg_write(encoder, REG_MUX_VP_VIP_OUT, 0x24);
 }
 
+static uint8_t tda998x_cksum(uint8_t *buf, size_t bytes)
+{
+	uint8_t sum = 0;
+
+	while (bytes--)
+		sum += *buf++;
+	return (255 - sum) + 1;
+}
+
+#define HB(x) (x)
+#define PB(x) (HB(2) + 1 + (x))
+
+static void
+tda998x_write_if(struct drm_encoder *encoder, uint8_t bit, uint16_t addr,
+		 uint8_t *buf, size_t size)
+{
+	buf[PB(0)] = tda998x_cksum(buf, size);
+
+	reg_clear(encoder, REG_DIP_IF_FLAGS, bit);
+	reg_write_range(encoder, addr, buf, size);
+	reg_set(encoder, REG_DIP_IF_FLAGS, bit);
+}
+
+static void
+tda998x_write_aif(struct drm_encoder *encoder, struct tda998x_encoder_params *p)
+{
+	uint8_t buf[PB(5) + 1];
+
+	buf[HB(0)] = 0x84;
+	buf[HB(1)] = 0x01;
+	buf[HB(2)] = 10;
+	buf[PB(0)] = 0;
+	buf[PB(1)] = p->audio_frame[1] & 0x07; /* CC */
+	buf[PB(2)] = p->audio_frame[2] & 0x1c; /* SF */
+	buf[PB(4)] = p->audio_frame[4];
+	buf[PB(5)] = p->audio_frame[5] & 0xf8; /* DM_INH + LSV */
+
+	tda998x_write_if(encoder, DIP_IF_FLAGS_IF4, REG_IF4_HB0, buf,
+			 sizeof(buf));
+}
+
+static void
+tda998x_write_avi(struct drm_encoder *encoder, struct drm_display_mode *mode)
+{
+	uint8_t buf[PB(13) + 1];
+
+	memset(buf, 0, sizeof(buf));
+	buf[HB(0)] = 0x82;
+	buf[HB(1)] = 0x02;
+	buf[HB(2)] = 13;
+	buf[PB(4)] = drm_match_cea_mode(mode);
+
+	tda998x_write_if(encoder, DIP_IF_FLAGS_IF2, REG_IF2_HB0, buf,
+			 sizeof(buf));
+}
+
+static void tda998x_audio_mute(struct drm_encoder *encoder, bool on)
+{
+	if (on) {
+		reg_set(encoder, REG_SOFTRESET, SOFTRESET_AUDIO);
+		reg_clear(encoder, REG_SOFTRESET, SOFTRESET_AUDIO);
+		reg_set(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_FIFO);
+	} else {
+		reg_clear(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_FIFO);
+	}
+}
+
+static void
+tda998x_configure_audio(struct drm_encoder *encoder,
+		struct drm_display_mode *mode, struct tda998x_encoder_params *p)
+{
+	uint8_t buf[6], clksel_aip, clksel_fs, ca_i2s, cts_n, adiv;
+	uint32_t n;
+
+	/* Enable audio ports */
+	reg_write(encoder, REG_ENA_AP, p->audio_cfg);
+	reg_write(encoder, REG_ENA_ACLK, p->audio_clk_cfg);
+
+	/* Set audio input source */
+	switch (p->audio_format) {
+	case AFMT_SPDIF:
+		reg_write(encoder, REG_MUX_AP, 0x40);
+		clksel_aip = AIP_CLKSEL_AIP(0);
+		/* FS64SPDIF */
+		clksel_fs = AIP_CLKSEL_FS(2);
+		cts_n = CTS_N_M(3) | CTS_N_K(3);
+		ca_i2s = 0;
+		break;
+
+	case AFMT_I2S:
+		reg_write(encoder, REG_MUX_AP, 0x64);
+		clksel_aip = AIP_CLKSEL_AIP(1);
+		/* ACLK */
+		clksel_fs = AIP_CLKSEL_FS(0);
+		cts_n = CTS_N_M(3) | CTS_N_K(3);
+		ca_i2s = CA_I2S_CA_I2S(0);
+		break;
+	}
+
+	reg_write(encoder, REG_AIP_CLKSEL, clksel_aip);
+	reg_clear(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT);
+
+	/* Enable automatic CTS generation */
+	reg_clear(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_ACR_MAN);
+	reg_write(encoder, REG_CTS_N, cts_n);
+
+	/*
+	 * Audio input somehow depends on HDMI line rate which is
+	 * related to pixclk. Testing showed that modes with pixclk
+	 * >100MHz need a larger divider while <40MHz need the default.
+	 * There is no detailed info in the datasheet, so we just
+	 * assume 100MHz requires larger divider.
+	 */
+	if (mode->clock > 100000)
+		adiv = AUDIO_DIV_SERCLK_16;
+	else
+		adiv = AUDIO_DIV_SERCLK_8;
+	reg_write(encoder, REG_AUDIO_DIV, adiv);
+
+	/*
+	 * This is the approximate value of N, which happens to be
+	 * the recommended values for non-coherent clocks.
+	 */
+	n = 128 * p->audio_sample_rate / 1000;
+
+	/* Write the CTS and N values */
+	buf[0] = 0x44;
+	buf[1] = 0x42;
+	buf[2] = 0x01;
+	buf[3] = n;
+	buf[4] = n >> 8;
+	buf[5] = n >> 16;
+	reg_write_range(encoder, REG_ACR_CTS_0, buf, 6);
+
+	/* Set CTS clock reference */
+	reg_write(encoder, REG_AIP_CLKSEL, clksel_aip | clksel_fs);
+
+	/* Reset CTS generator */
+	reg_set(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_CTS);
+	reg_clear(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_CTS);
+
+	/* Write the channel status */
+	buf[0] = 0x04;
+	buf[1] = 0x00;
+	buf[2] = 0x00;
+	buf[3] = 0xf1;
+	reg_write_range(encoder, REG_CH_STAT_B(0), buf, 4);
+
+	tda998x_audio_mute(encoder, true);
+	mdelay(20);
+	tda998x_audio_mute(encoder, false);
+
+	/* Write the audio information packet */
+	tda998x_write_aif(encoder, p);
+}
+
 /* DRM encoder functions */
 
 static void
 tda998x_encoder_set_config(struct drm_encoder *encoder, void *params)
 {
+	struct tda998x_priv *priv = to_tda998x_priv(encoder);
+	struct tda998x_encoder_params *p = params;
+
+	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(p->swap_a) |
+			    (p->mirr_a ? VIP_CNTRL_0_MIRR_A : 0) |
+			    VIP_CNTRL_0_SWAP_B(p->swap_b) |
+			    (p->mirr_b ? VIP_CNTRL_0_MIRR_B : 0);
+	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(p->swap_c) |
+			    (p->mirr_c ? VIP_CNTRL_1_MIRR_C : 0) |
+			    VIP_CNTRL_1_SWAP_D(p->swap_d) |
+			    (p->mirr_d ? VIP_CNTRL_1_MIRR_D : 0);
+	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(p->swap_e) |
+			    (p->mirr_e ? VIP_CNTRL_2_MIRR_E : 0) |
+			    VIP_CNTRL_2_SWAP_F(p->swap_f) |
+			    (p->mirr_f ? VIP_CNTRL_2_MIRR_F : 0);
+
+	priv->params = *p;
 }
 
 static void
@@ -445,8 +681,7 @@ tda998x_encoder_dpms(struct drm_encoder *encoder, int mode)
 
 	switch (mode) {
 	case DRM_MODE_DPMS_ON:
-		/* enable audio and video ports */
-		reg_write(encoder, REG_ENA_AP, 0xff);
+		/* enable video ports, audio will be enabled later */
 		reg_write(encoder, REG_ENA_VP_0, 0xff);
 		reg_write(encoder, REG_ENA_VP_1, 0xff);
 		reg_write(encoder, REG_ENA_VP_2, 0xff);
@@ -608,17 +843,32 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	reg_write16(encoder, REG_REFPIX_MSB, ref_pix);
 	reg_write16(encoder, REG_REFLINE_MSB, ref_line);
 
-	reg = TBG_CNTRL_1_VHX_EXT_DE |
-			TBG_CNTRL_1_VHX_EXT_HS |
-			TBG_CNTRL_1_VHX_EXT_VS |
-			TBG_CNTRL_1_DWIN_DIS | /* HDCP off */
+	reg = TBG_CNTRL_1_DWIN_DIS | /* HDCP off */
 			TBG_CNTRL_1_VH_TGL_2;
+	/*
+	 * It is questionable whether this is correct - the nxp driver
+	 * does not set VH_TGL_2 and the below for all display modes.
+	 */
 	if (mode->flags & (DRM_MODE_FLAG_NVSYNC | DRM_MODE_FLAG_NHSYNC))
 		reg |= TBG_CNTRL_1_VH_TGL_0;
 	reg_set(encoder, REG_TBG_CNTRL_1, reg);
 
 	/* must be last register set: */
 	reg_clear(encoder, REG_TBG_CNTRL_0, TBG_CNTRL_0_SYNC_ONCE);
+
+	/* Only setup the info frames if the sink is HDMI */
+	if (priv->is_hdmi_sink) {
+		/* We need to turn HDMI HDCP stuff on to get audio through */
+		reg_clear(encoder, REG_TBG_CNTRL_1, TBG_CNTRL_1_DWIN_DIS);
+		reg_write(encoder, REG_ENC_CNTRL, ENC_CNTRL_CTL_CODE(1));
+		reg_set(encoder, REG_TX33, TX33_HDMI);
+
+		tda998x_write_avi(encoder, adjusted_mode);
+
+		if (priv->params.audio_cfg)
+			tda998x_configure_audio(encoder, adjusted_mode,
+						&priv->params);
+	}
 }
 
 static enum drm_connector_status
@@ -744,12 +994,14 @@ static int
 tda998x_encoder_get_modes(struct drm_encoder *encoder,
 			 struct drm_connector *connector)
 {
+	struct tda998x_priv *priv = to_tda998x_priv(encoder);
 	struct edid *edid = (struct edid *)do_get_edid(encoder);
 	int n = 0;
 
 	if (edid) {
 		drm_mode_connector_update_edid_property(connector, edid);
 		n = drm_add_edid_modes(connector, edid);
+		priv->is_hdmi_sink = drm_detect_hdmi_monitor(edid);
 		kfree(edid);
 	}
 
diff --git a/include/drm/i2c/tda998x.h b/include/drm/i2c/tda998x.h
new file mode 100644
index 0000000..3e419d9
--- /dev/null
+++ b/include/drm/i2c/tda998x.h
@@ -0,0 +1,30 @@
+#ifndef __DRM_I2C_TDA998X_H__
+#define __DRM_I2C_TDA998X_H__
+
+struct tda998x_encoder_params {
+	u8 swap_b:3;
+	u8 mirr_b:1;
+	u8 swap_a:3;
+	u8 mirr_a:1;
+	u8 swap_d:3;
+	u8 mirr_d:1;
+	u8 swap_c:3;
+	u8 mirr_c:1;
+	u8 swap_f:3;
+	u8 mirr_f:1;
+	u8 swap_e:3;
+	u8 mirr_e:1;
+
+	u8 audio_cfg;
+	u8 audio_clk_cfg;
+	u8 audio_frame[6];
+
+	enum {
+		AFMT_SPDIF,
+		AFMT_I2S
+	} audio_format;
+
+	unsigned audio_sample_rate;
+};
+
+#endif
-- 
1.7.10.4

