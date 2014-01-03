Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaACN20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:28:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48560 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbaACN2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:28:23 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/11] ASoC: twl4030: Remove local reg cache
Date: Fri, 3 Jan 2014 15:27:53 +0200
Message-ID: <1388755676-16036-9-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depend on the regmap reg cache implementation for register caching done in
the twl-core driver.
The local register cache can be removed and we can keep only shadow copies
of certain ctl registers for pop noise reduction.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl4030.c | 207 ++++++++++++++-------------------------------
 1 file changed, 63 insertions(+), 144 deletions(-)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index f88207712d3d..dda53e8c51e5 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -48,86 +48,6 @@
 
 #define TWL4030_CACHEREGNUM	(TWL4030_REG_MISC_SET_2 + 1)
 
-/*
- * twl4030 register cache & default register settings
- */
-static const u8 twl4030_reg[TWL4030_CACHEREGNUM] = {
-	0x00, /* this register not used		*/
-	0x00, /* REG_CODEC_MODE		(0x1)	*/
-	0x00, /* REG_OPTION		(0x2)	*/
-	0x00, /* REG_UNKNOWN		(0x3)	*/
-	0x00, /* REG_MICBIAS_CTL	(0x4)	*/
-	0x00, /* REG_ANAMICL		(0x5)	*/
-	0x00, /* REG_ANAMICR		(0x6)	*/
-	0x00, /* REG_AVADC_CTL		(0x7)	*/
-	0x00, /* REG_ADCMICSEL		(0x8)	*/
-	0x00, /* REG_DIGMIXING		(0x9)	*/
-	0x0f, /* REG_ATXL1PGA		(0xA)	*/
-	0x0f, /* REG_ATXR1PGA		(0xB)	*/
-	0x0f, /* REG_AVTXL2PGA		(0xC)	*/
-	0x0f, /* REG_AVTXR2PGA		(0xD)	*/
-	0x00, /* REG_AUDIO_IF		(0xE)	*/
-	0x00, /* REG_VOICE_IF		(0xF)	*/
-	0x3f, /* REG_ARXR1PGA		(0x10)	*/
-	0x3f, /* REG_ARXL1PGA		(0x11)	*/
-	0x3f, /* REG_ARXR2PGA		(0x12)	*/
-	0x3f, /* REG_ARXL2PGA		(0x13)	*/
-	0x25, /* REG_VRXPGA		(0x14)	*/
-	0x00, /* REG_VSTPGA		(0x15)	*/
-	0x00, /* REG_VRX2ARXPGA		(0x16)	*/
-	0x00, /* REG_AVDAC_CTL		(0x17)	*/
-	0x00, /* REG_ARX2VTXPGA		(0x18)	*/
-	0x32, /* REG_ARXL1_APGA_CTL	(0x19)	*/
-	0x32, /* REG_ARXR1_APGA_CTL	(0x1A)	*/
-	0x32, /* REG_ARXL2_APGA_CTL	(0x1B)	*/
-	0x32, /* REG_ARXR2_APGA_CTL	(0x1C)	*/
-	0x00, /* REG_ATX2ARXPGA		(0x1D)	*/
-	0x00, /* REG_BT_IF		(0x1E)	*/
-	0x55, /* REG_BTPGA		(0x1F)	*/
-	0x00, /* REG_BTSTPGA		(0x20)	*/
-	0x00, /* REG_EAR_CTL		(0x21)	*/
-	0x00, /* REG_HS_SEL		(0x22)	*/
-	0x00, /* REG_HS_GAIN_SET	(0x23)	*/
-	0x00, /* REG_HS_POPN_SET	(0x24)	*/
-	0x00, /* REG_PREDL_CTL		(0x25)	*/
-	0x00, /* REG_PREDR_CTL		(0x26)	*/
-	0x00, /* REG_PRECKL_CTL		(0x27)	*/
-	0x00, /* REG_PRECKR_CTL		(0x28)	*/
-	0x00, /* REG_HFL_CTL		(0x29)	*/
-	0x00, /* REG_HFR_CTL		(0x2A)	*/
-	0x05, /* REG_ALC_CTL		(0x2B)	*/
-	0x00, /* REG_ALC_SET1		(0x2C)	*/
-	0x00, /* REG_ALC_SET2		(0x2D)	*/
-	0x00, /* REG_BOOST_CTL		(0x2E)	*/
-	0x00, /* REG_SOFTVOL_CTL	(0x2F)	*/
-	0x13, /* REG_DTMF_FREQSEL	(0x30)	*/
-	0x00, /* REG_DTMF_TONEXT1H	(0x31)	*/
-	0x00, /* REG_DTMF_TONEXT1L	(0x32)	*/
-	0x00, /* REG_DTMF_TONEXT2H	(0x33)	*/
-	0x00, /* REG_DTMF_TONEXT2L	(0x34)	*/
-	0x79, /* REG_DTMF_TONOFF	(0x35)	*/
-	0x11, /* REG_DTMF_WANONOFF	(0x36)	*/
-	0x00, /* REG_I2S_RX_SCRAMBLE_H	(0x37)	*/
-	0x00, /* REG_I2S_RX_SCRAMBLE_M	(0x38)	*/
-	0x00, /* REG_I2S_RX_SCRAMBLE_L	(0x39)	*/
-	0x06, /* REG_APLL_CTL		(0x3A)	*/
-	0x00, /* REG_DTMF_CTL		(0x3B)	*/
-	0x44, /* REG_DTMF_PGA_CTL2	(0x3C)	*/
-	0x69, /* REG_DTMF_PGA_CTL1	(0x3D)	*/
-	0x00, /* REG_MISC_SET_1		(0x3E)	*/
-	0x00, /* REG_PCMBTMUX		(0x3F)	*/
-	0x00, /* not used		(0x40)	*/
-	0x00, /* not used		(0x41)	*/
-	0x00, /* not used		(0x42)	*/
-	0x00, /* REG_RX_PATH_SEL	(0x43)	*/
-	0x32, /* REG_VDL_APGA_CTL	(0x44)	*/
-	0x00, /* REG_VIBRA_CTL		(0x45)	*/
-	0x00, /* REG_VIBRA_SET		(0x46)	*/
-	0x00, /* REG_VIBRA_PWM_SET	(0x47)	*/
-	0x00, /* REG_ANAMIC_GAIN	(0x48)	*/
-	0x00, /* REG_MISC_SET_2		(0x49)	*/
-};
-
 /* codec private data */
 struct twl4030_priv {
 	unsigned int codec_powered;
@@ -166,31 +86,48 @@ static void tw4030_init_ctl_cache(struct twl4030_priv *twl4030)
 	}
 }
 
-/*
- * read twl4030 register cache
- */
-static inline unsigned int twl4030_read_reg_cache(struct snd_soc_codec *codec,
-	unsigned int reg)
+static void twl4030_update_ctl_cache(struct snd_soc_codec *codec,
+				     unsigned int reg, unsigned int value)
 {
-	u8 *cache = codec->reg_cache;
-
-	if (reg >= TWL4030_CACHEREGNUM)
-		return -EIO;
+	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
 
-	return cache[reg];
+	switch (reg) {
+	case TWL4030_REG_EAR_CTL:
+	case TWL4030_REG_PREDL_CTL:
+	case TWL4030_REG_PREDR_CTL:
+	case TWL4030_REG_PRECKL_CTL:
+	case TWL4030_REG_PRECKR_CTL:
+	case TWL4030_REG_HS_GAIN_SET:
+		twl4030->ctl_cache[reg - TWL4030_REG_EAR_CTL] = value;
+		break;
+	default:
+		break;
+	}
 }
 
-/*
- * write twl4030 register cache
- */
-static inline void twl4030_write_reg_cache(struct snd_soc_codec *codec,
-						u8 reg, u8 value)
+static unsigned int twl4030_read(struct snd_soc_codec *codec, unsigned int reg)
 {
-	u8 *cache = codec->reg_cache;
+	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
+	u8 value = 0;
 
 	if (reg >= TWL4030_CACHEREGNUM)
-		return;
-	cache[reg] = value;
+		return -EIO;
+
+	switch (reg) {
+	case TWL4030_REG_EAR_CTL:
+	case TWL4030_REG_PREDL_CTL:
+	case TWL4030_REG_PREDR_CTL:
+	case TWL4030_REG_PRECKL_CTL:
+	case TWL4030_REG_PRECKR_CTL:
+	case TWL4030_REG_HS_GAIN_SET:
+		value = twl4030->ctl_cache[reg - TWL4030_REG_EAR_CTL];
+		break;
+	default:
+		twl_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &value, reg);
+		break;
+	}
+
+	return value;
 }
 
 static bool twl4030_can_write_to_chip(struct snd_soc_codec *codec,
@@ -234,13 +171,10 @@ static bool twl4030_can_write_to_chip(struct snd_soc_codec *codec,
 	return write_to_reg;
 }
 
-/*
- * write to the twl4030 register space
- */
 static int twl4030_write(struct snd_soc_codec *codec,
 			 unsigned int reg, unsigned int value)
 {
-	twl4030_write_reg_cache(codec, reg, value);
+	twl4030_update_ctl_cache(codec, reg, value);
 	if (twl4030_can_write_to_chip(codec, reg))
 		return twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE, value, reg);
 
@@ -270,10 +204,8 @@ static void twl4030_codec_enable(struct snd_soc_codec *codec, int enable)
 	else
 		mode = twl4030_audio_disable_resource(TWL4030_AUDIO_RES_POWER);
 
-	if (mode >= 0) {
-		twl4030_write_reg_cache(codec, TWL4030_REG_CODEC_MODE, mode);
+	if (mode >= 0)
 		twl4030->codec_powered = enable;
-	}
 
 	/* REVISIT: this delay is present in TI sample drivers */
 	/* but there seems to be no TRM requirement for it     */
@@ -363,13 +295,8 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 	/* Initialize the local ctl register cache */
 	tw4030_init_ctl_cache(twl4030);
 
-	/* Refresh APLL_CTL register from HW */
-	twl_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &byte,
-			    TWL4030_REG_APLL_CTL);
-	twl4030_write_reg_cache(codec, TWL4030_REG_APLL_CTL, byte);
-
 	/* anti-pop when changing analog gain */
-	reg = twl4030_read_reg_cache(codec, TWL4030_REG_MISC_SET_1);
+	reg = twl4030_read(codec, TWL4030_REG_MISC_SET_1);
 	twl4030_write(codec, TWL4030_REG_MISC_SET_1,
 		reg | TWL4030_SMOOTH_ANAVOL_EN);
 
@@ -386,15 +313,15 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 
 	twl4030->pdata = pdata;
 
-	reg = twl4030_read_reg_cache(codec, TWL4030_REG_HS_POPN_SET);
+	reg = twl4030_read(codec, TWL4030_REG_HS_POPN_SET);
 	reg &= ~TWL4030_RAMP_DELAY;
 	reg |= (pdata->ramp_delay_value << 2);
-	twl4030_write_reg_cache(codec, TWL4030_REG_HS_POPN_SET, reg);
+	twl4030_write(codec, TWL4030_REG_HS_POPN_SET, reg);
 
 	/* initiate offset cancellation */
 	twl4030_codec_enable(codec, 1);
 
-	reg = twl4030_read_reg_cache(codec, TWL4030_REG_ANAMICL);
+	reg = twl4030_read(codec, TWL4030_REG_ANAMICL);
 	reg &= ~TWL4030_OFFSET_CNCL_SEL;
 	reg |= pdata->offset_cncl_path;
 	twl4030_write(codec, TWL4030_REG_ANAMICL,
@@ -408,15 +335,14 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 	msleep(20);
 	do {
 		usleep_range(1000, 2000);
+		twl_set_regcache_bypass(TWL4030_MODULE_AUDIO_VOICE, true);
 		twl_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &byte,
 				    TWL4030_REG_ANAMICL);
+		twl_set_regcache_bypass(TWL4030_MODULE_AUDIO_VOICE, false);
 	} while ((i++ < 100) &&
 		 ((byte & TWL4030_CNCL_OFFSET_START) ==
 		  TWL4030_CNCL_OFFSET_START));
 
-	/* Make sure that the reg_cache has the same value as the HW */
-	twl4030_write_reg_cache(codec, TWL4030_REG_ANAMICL, byte);
-
 	twl4030_codec_enable(codec, 0);
 }
 
@@ -436,9 +362,6 @@ static void twl4030_apll_enable(struct snd_soc_codec *codec, int enable)
 			status = twl4030_audio_disable_resource(
 							TWL4030_AUDIO_RES_APLL);
 	}
-
-	if (status >= 0)
-		twl4030_write_reg_cache(codec, TWL4030_REG_APLL_CTL, status);
 }
 
 /* Earpiece */
@@ -661,8 +584,7 @@ static int pin_name##pga_event(struct snd_soc_dapm_widget *w,		\
 	switch (event) {						\
 	case SND_SOC_DAPM_POST_PMU:					\
 		twl4030->pin_name##_enabled = 1;			\
-		twl4030_write(w->codec, reg,				\
-			twl4030_read_reg_cache(w->codec, reg));		\
+		twl4030_write(w->codec, reg, twl4030_read(w->codec, reg)); \
 		break;							\
 	case SND_SOC_DAPM_POST_PMD:					\
 		twl4030->pin_name##_enabled = 0;			\
@@ -683,7 +605,7 @@ static void handsfree_ramp(struct snd_soc_codec *codec, int reg, int ramp)
 {
 	unsigned char hs_ctl;
 
-	hs_ctl = twl4030_read_reg_cache(codec, reg);
+	hs_ctl = twl4030_read(codec, reg);
 
 	if (ramp) {
 		/* HF ramp-up */
@@ -763,7 +685,7 @@ static int aif_event(struct snd_soc_dapm_widget *w,
 {
 	u8 audio_if;
 
-	audio_if = twl4030_read_reg_cache(w->codec, TWL4030_REG_AUDIO_IF);
+	audio_if = twl4030_read(w->codec, TWL4030_REG_AUDIO_IF);
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
 		/* Enable AIF */
@@ -793,8 +715,8 @@ static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 				    8388608, 16777216, 33554432, 67108864};
 	unsigned int delay;
 
-	hs_gain = twl4030_read_reg_cache(codec, TWL4030_REG_HS_GAIN_SET);
-	hs_pop = twl4030_read_reg_cache(codec, TWL4030_REG_HS_POPN_SET);
+	hs_gain = twl4030_read(codec, TWL4030_REG_HS_GAIN_SET);
+	hs_pop = twl4030_read(codec, TWL4030_REG_HS_POPN_SET);
 	delay = (ramp_base[(hs_pop & TWL4030_RAMP_DELAY) >> 2] /
 		twl4030->sysclk) + 1;
 
@@ -1738,7 +1660,7 @@ static void twl4030_tdm_enable(struct snd_soc_codec *codec, int direction,
 {
 	u8 reg, mask;
 
-	reg = twl4030_read_reg_cache(codec, TWL4030_REG_OPTION);
+	reg = twl4030_read(codec, TWL4030_REG_OPTION);
 
 	if (direction == SNDRV_PCM_STREAM_PLAYBACK)
 		mask = TWL4030_ARXL1_VRX_EN | TWL4030_ARXR1_EN;
@@ -1767,7 +1689,7 @@ static int twl4030_startup(struct snd_pcm_substream *substream,
 		if (twl4030->configured)
 			twl4030_constraints(twl4030, twl4030->master_substream);
 	} else {
-		if (!(twl4030_read_reg_cache(codec, TWL4030_REG_CODEC_MODE) &
+		if (!(twl4030_read(codec, TWL4030_REG_CODEC_MODE) &
 			TWL4030_OPTION_1)) {
 			/* In option2 4 channel is not supported, set the
 			 * constraint for the first stream for channels, the
@@ -1815,8 +1737,8 @@ static int twl4030_hw_params(struct snd_pcm_substream *substream,
 
 	 /* If the substream has 4 channel, do the necessary setup */
 	if (params_channels(params) == 4) {
-		format = twl4030_read_reg_cache(codec, TWL4030_REG_AUDIO_IF);
-		mode = twl4030_read_reg_cache(codec, TWL4030_REG_CODEC_MODE);
+		format = twl4030_read(codec, TWL4030_REG_AUDIO_IF);
+		mode = twl4030_read(codec, TWL4030_REG_CODEC_MODE);
 
 		/* Safety check: are we in the correct operating mode and
 		 * the interface is in TDM mode? */
@@ -1832,8 +1754,8 @@ static int twl4030_hw_params(struct snd_pcm_substream *substream,
 		return 0;
 
 	/* bit rate */
-	old_mode = twl4030_read_reg_cache(codec,
-			TWL4030_REG_CODEC_MODE) & ~TWL4030_CODECPDZ;
+	old_mode = twl4030_read(codec,
+				TWL4030_REG_CODEC_MODE) & ~TWL4030_CODECPDZ;
 	mode = old_mode & ~TWL4030_APLL_RATE;
 
 	switch (params_rate(params)) {
@@ -1874,7 +1796,7 @@ static int twl4030_hw_params(struct snd_pcm_substream *substream,
 	}
 
 	/* sample size */
-	old_format = twl4030_read_reg_cache(codec, TWL4030_REG_AUDIO_IF);
+	old_format = twl4030_read(codec, TWL4030_REG_AUDIO_IF);
 	format = old_format;
 	format &= ~TWL4030_DATA_WIDTH;
 	switch (params_format(params)) {
@@ -1957,7 +1879,7 @@ static int twl4030_set_dai_fmt(struct snd_soc_dai *codec_dai,
 	u8 old_format, format;
 
 	/* get format */
-	old_format = twl4030_read_reg_cache(codec, TWL4030_REG_AUDIO_IF);
+	old_format = twl4030_read(codec, TWL4030_REG_AUDIO_IF);
 	format = old_format;
 
 	/* set master/slave audio interface */
@@ -2007,7 +1929,7 @@ static int twl4030_set_dai_fmt(struct snd_soc_dai *codec_dai,
 static int twl4030_set_tristate(struct snd_soc_dai *dai, int tristate)
 {
 	struct snd_soc_codec *codec = dai->codec;
-	u8 reg = twl4030_read_reg_cache(codec, TWL4030_REG_AUDIO_IF);
+	u8 reg = twl4030_read(codec, TWL4030_REG_AUDIO_IF);
 
 	if (tristate)
 		reg |= TWL4030_AIF_TRI_EN;
@@ -2024,7 +1946,7 @@ static void twl4030_voice_enable(struct snd_soc_codec *codec, int direction,
 {
 	u8 reg, mask;
 
-	reg = twl4030_read_reg_cache(codec, TWL4030_REG_OPTION);
+	reg = twl4030_read(codec, TWL4030_REG_OPTION);
 
 	if (direction == SNDRV_PCM_STREAM_PLAYBACK)
 		mask = TWL4030_ARXL1_VRX_EN;
@@ -2059,7 +1981,7 @@ static int twl4030_voice_startup(struct snd_pcm_substream *substream,
 	/* If the codec mode is not option2, the voice PCM interface is not
 	 * available.
 	 */
-	mode = twl4030_read_reg_cache(codec, TWL4030_REG_CODEC_MODE)
+	mode = twl4030_read(codec, TWL4030_REG_CODEC_MODE)
 		& TWL4030_OPT_MODE;
 
 	if (mode != TWL4030_OPTION_2) {
@@ -2091,7 +2013,7 @@ static int twl4030_voice_hw_params(struct snd_pcm_substream *substream,
 	twl4030_voice_enable(codec, substream->stream, 1);
 
 	/* bit rate */
-	old_mode = twl4030_read_reg_cache(codec, TWL4030_REG_CODEC_MODE)
+	old_mode = twl4030_read(codec, TWL4030_REG_CODEC_MODE)
 		& ~(TWL4030_CODECPDZ);
 	mode = old_mode;
 
@@ -2154,7 +2076,7 @@ static int twl4030_voice_set_dai_fmt(struct snd_soc_dai *codec_dai,
 	u8 old_format, format;
 
 	/* get format */
-	old_format = twl4030_read_reg_cache(codec, TWL4030_REG_VOICE_IF);
+	old_format = twl4030_read(codec, TWL4030_REG_VOICE_IF);
 	format = old_format;
 
 	/* set master/slave audio interface */
@@ -2201,7 +2123,7 @@ static int twl4030_voice_set_dai_fmt(struct snd_soc_dai *codec_dai,
 static int twl4030_voice_set_tristate(struct snd_soc_dai *dai, int tristate)
 {
 	struct snd_soc_codec *codec = dai->codec;
-	u8 reg = twl4030_read_reg_cache(codec, TWL4030_REG_VOICE_IF);
+	u8 reg = twl4030_read(codec, TWL4030_REG_VOICE_IF);
 
 	if (tristate)
 		reg |= TWL4030_VIF_TRI_EN;
@@ -2304,13 +2226,10 @@ static int twl4030_soc_remove(struct snd_soc_codec *codec)
 static struct snd_soc_codec_driver soc_codec_dev_twl4030 = {
 	.probe = twl4030_soc_probe,
 	.remove = twl4030_soc_remove,
-	.read = twl4030_read_reg_cache,
+	.read = twl4030_read,
 	.write = twl4030_write,
 	.set_bias_level = twl4030_set_bias_level,
 	.idle_bias_off = true,
-	.reg_cache_size = sizeof(twl4030_reg),
-	.reg_word_size = sizeof(u8),
-	.reg_cache_default = twl4030_reg,
 
 	.controls = twl4030_snd_controls,
 	.num_controls = ARRAY_SIZE(twl4030_snd_controls),
-- 
1.8.5.2

