Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbbAGLwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:52:51 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:7462 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbbAGLws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:52:48 -0500
X-Mailbox-Line: From 3b99496107b6653ef27b86d8cdf516a4815910cf Mon Sep 17 00:00:00 2001
Message-Id: <3b99496107b6653ef27b86d8cdf516a4815910cf.1420628786.git.moinejf@free.fr>
In-Reply-To: <cover.1420628786.git.moinejf@free.fr>
References: <cover.1420628786.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Wed, 7 Jan 2015 12:01:23 +0100
Subject: [PATCH v9 4/4] drm/i2c: tda998x: set cts_n according to the sample
 width
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With I2S input, the CTS_N predivider depends on the sample width.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index a26a516..8af84cd 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -50,6 +50,7 @@ struct tda998x_priv {
 	wait_queue_head_t wq_edid;
 	volatile int wq_edid_wait;
 	struct drm_encoder *encoder;
 
+	int audio_sample_format;
 	u8 audio_ports[2];
 #ifdef WITH_CODEC
@@ -671,7 +672,17 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		reg_write(priv, REG_MUX_AP, MUX_AP_SELECT_I2S);
 		clksel_aip = AIP_CLKSEL_AIP_I2S;
 		clksel_fs = AIP_CLKSEL_FS_ACLK;
-		cts_n = CTS_N_M(3) | CTS_N_K(3);
+
+		/* with I2S input, the CTS_N predivider depends on
+		 * the sample width */
+		switch (priv->audio_sample_format) {
+		case SNDRV_PCM_FORMAT_S16_LE:
+			cts_n = CTS_N_M(3) | CTS_N_K(1);
+			break;
+		default:
+			cts_n = CTS_N_M(3) | CTS_N_K(3);
+			break;
+		}
 		break;
 
 	default:
@@ -778,7 +789,8 @@ static int tda998x_set_audio_input(struct device *dev,
 
 	/* if same audio parameters, just enable the audio port */
 	if (p->audio_cfg == priv->audio_ports[port_index] &&
-	    p->audio_sample_rate == sample_rate) {
+	    p->audio_sample_rate == sample_rate &&
+	    priv->audio_sample_format == sample_format) {
 		reg_write(priv, REG_ENA_AP, p->audio_cfg);
 		return 0;
 	}
@@ -787,6 +799,7 @@ static int tda998x_set_audio_input(struct device *dev,
 	p->audio_clk_cfg = port_index == PORT_SPDIF ? 0 : 1;
 	p->audio_cfg = priv->audio_ports[port_index];
 	p->audio_sample_rate = sample_rate;
+	priv->audio_sample_format = sample_format;
 	tda998x_configure_audio(priv, &priv->encoder->crtc->hwmode, p);
 	return 0;
 }
@@ -1388,6 +1401,7 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 
 	priv->params.audio_frame[1] = 1;		/* channels - 1 */
 	priv->params.audio_sample_rate = 48000;		/* 48kHz */
+	priv->audio_sample_format = SNDRV_PCM_FORMAT_S24_LE;
 
 	priv->current_page = 0xff;
 	priv->hdmi = client;
-- 
2.1.4

