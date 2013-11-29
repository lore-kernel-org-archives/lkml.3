Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab3K2OEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:04:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34424 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab3K2OEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:04:02 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 5/5] ASoC: twl6040: Remove self managed local reg_cache support
Date: Fri, 29 Nov 2013 16:03:47 +0200
Message-ID: <1385733827-19831-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
References: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can rely on mfd driver to manage the register caching via regmap. The
driver still need to cache some registers associated with DL1/2 routes.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c | 211 +++++++++++----------------------------------
 1 file changed, 49 insertions(+), 162 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index b07839b..0afe8be 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -80,59 +80,6 @@ struct twl6040_data {
 	struct mutex mutex;
 };
 
-/*
- * twl6040 register cache & default register settings
- */
-static const u8 twl6040_reg[TWL6040_CACHEREGNUM] = {
-	0x00, /* not used	0x00	*/
-	0x4B, /* REG_ASICID	0x01 (ro) */
-	0x00, /* REG_ASICREV	0x02 (ro) */
-	0x00, /* REG_INTID	0x03	*/
-	0x00, /* REG_INTMR	0x04	*/
-	0x00, /* REG_NCPCTRL	0x05	*/
-	0x00, /* REG_LDOCTL	0x06	*/
-	0x60, /* REG_HPPLLCTL	0x07	*/
-	0x00, /* REG_LPPLLCTL	0x08	*/
-	0x4A, /* REG_LPPLLDIV	0x09	*/
-	0x00, /* REG_AMICBCTL	0x0A	*/
-	0x00, /* REG_DMICBCTL	0x0B	*/
-	0x00, /* REG_MICLCTL	0x0C	*/
-	0x00, /* REG_MICRCTL	0x0D	*/
-	0x00, /* REG_MICGAIN	0x0E	*/
-	0x1B, /* REG_LINEGAIN	0x0F	*/
-	0x00, /* REG_HSLCTL	0x10	*/
-	0x00, /* REG_HSRCTL	0x11	*/
-	0x00, /* REG_HSGAIN	0x12	*/
-	0x00, /* REG_EARCTL	0x13	*/
-	0x00, /* REG_HFLCTL	0x14	*/
-	0x00, /* REG_HFLGAIN	0x15	*/
-	0x00, /* REG_HFRCTL	0x16	*/
-	0x00, /* REG_HFRGAIN	0x17	*/
-	0x00, /* REG_VIBCTLL	0x18	*/
-	0x00, /* REG_VIBDATL	0x19	*/
-	0x00, /* REG_VIBCTLR	0x1A	*/
-	0x00, /* REG_VIBDATR	0x1B	*/
-	0x00, /* REG_HKCTL1	0x1C	*/
-	0x00, /* REG_HKCTL2	0x1D	*/
-	0x00, /* REG_GPOCTL	0x1E	*/
-	0x00, /* REG_ALB	0x1F	*/
-	0x00, /* REG_DLB	0x20	*/
-	0x00, /* not used	0x21	*/
-	0x00, /* not used	0x22	*/
-	0x00, /* not used	0x23	*/
-	0x00, /* not used	0x24	*/
-	0x00, /* not used	0x25	*/
-	0x00, /* not used	0x26	*/
-	0x00, /* not used	0x27	*/
-	0x00, /* REG_TRIM1	0x28	*/
-	0x00, /* REG_TRIM2	0x29	*/
-	0x00, /* REG_TRIM3	0x2A	*/
-	0x00, /* REG_HSOTRIM	0x2B	*/
-	0x00, /* REG_HFOTRIM	0x2C	*/
-	0x09, /* REG_ACCCTL	0x2D	*/
-	0x00, /* REG_STATUS	0x2E (ro) */
-};
-
 /* set of rates for each pll: low-power and high-performance */
 static unsigned int lp_rates[] = {
 	8000,
@@ -159,11 +106,14 @@ static struct snd_pcm_hw_constraint_list sysclk_constraints[] = {
 	{ .count = ARRAY_SIZE(hp_rates), .list = hp_rates, },
 };
 
-static inline int twl6040_read_dl12_cache(struct snd_soc_codec *codec,
-					   u8 reg, u8 *value)
+static unsigned int twl6040_read(struct snd_soc_codec *codec, unsigned int reg)
 {
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
-	int ret = 0;
+	struct twl6040 *twl6040 = codec->control_data;
+	u8 value;
+
+	if (reg >= TWL6040_CACHEREGNUM)
+		return -EIO;
 
 	switch (reg) {
 	case TWL6040_REG_HSLCTL:
@@ -171,36 +121,18 @@ static inline int twl6040_read_dl12_cache(struct snd_soc_codec *codec,
 	case TWL6040_REG_EARCTL:
 	case TWL6040_REG_HFLCTL:
 	case TWL6040_REG_HFRCTL:
-		*value = priv->dl12_cache[reg - TWL6040_REG_HSLCTL];
+		value = priv->dl12_cache[reg - TWL6040_REG_HSLCTL];
 		break;
 	default:
-		ret = -EINVAL;
+		value = twl6040_reg_read(twl6040, reg);
 		break;
 	}
 
-	return ret;
-}
-
-/*
- * read twl6040 register cache
- */
-static inline unsigned int twl6040_read_reg_cache(struct snd_soc_codec *codec,
-						  unsigned int reg)
-{
-	u8 *cache = codec->reg_cache;
-	u8 value;
-
-	if (reg >= TWL6040_CACHEREGNUM)
-		return -EIO;
-
-	if (twl6040_read_dl12_cache(codec, reg, &value))
-		value = cache[reg];
-
 	return value;
 }
 
-static inline void twl6040_update_dl12_cache(struct snd_soc_codec *codec,
-					     u8 reg, u8 value)
+static bool twl6040_can_write_to_chip(struct snd_soc_codec *codec,
+				  unsigned int reg)
 {
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
 
@@ -208,50 +140,18 @@ static inline void twl6040_update_dl12_cache(struct snd_soc_codec *codec,
 	case TWL6040_REG_HSLCTL:
 	case TWL6040_REG_HSRCTL:
 	case TWL6040_REG_EARCTL:
+		/* DL1 path */
+		return priv->dl1_unmuted;
 	case TWL6040_REG_HFLCTL:
 	case TWL6040_REG_HFRCTL:
-		priv->dl12_cache[reg - TWL6040_REG_HSLCTL] = value;
-		break;
+		return priv->dl2_unmuted;
 	default:
-		break;
+		return 1;
 	}
 }
 
-/*
- * write twl6040 register cache
- */
-static inline void twl6040_write_reg_cache(struct snd_soc_codec *codec,
-						u8 reg, u8 value)
-{
-	u8 *cache = codec->reg_cache;
-
-	if (reg >= TWL6040_CACHEREGNUM)
-		return;
-	cache[reg] = value;
-
-	twl6040_update_dl12_cache(codec, reg, value);
-}
-
-/*
- * read from twl6040 hardware register
- */
-static int twl6040_read_reg_volatile(struct snd_soc_codec *codec,
-			unsigned int reg)
-{
-	struct twl6040 *twl6040 = codec->control_data;
-	u8 value;
-
-	if (reg >= TWL6040_CACHEREGNUM)
-		return -EIO;
-
-	value = twl6040_reg_read(twl6040, reg);
-	twl6040_write_reg_cache(codec, reg, value);
-
-	return value;
-}
-
-static bool twl6040_can_write_to_chip(struct snd_soc_codec *codec,
-				  unsigned int reg)
+static inline void twl6040_update_dl12_cache(struct snd_soc_codec *codec,
+					     u8 reg, u8 value)
 {
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
 
@@ -259,19 +159,15 @@ static bool twl6040_can_write_to_chip(struct snd_soc_codec *codec,
 	case TWL6040_REG_HSLCTL:
 	case TWL6040_REG_HSRCTL:
 	case TWL6040_REG_EARCTL:
-		/* DL1 path */
-		return priv->dl1_unmuted;
 	case TWL6040_REG_HFLCTL:
 	case TWL6040_REG_HFRCTL:
-		return priv->dl2_unmuted;
+		priv->dl12_cache[reg - TWL6040_REG_HSLCTL] = value;
+		break;
 	default:
-		return 1;
+		break;
 	}
 }
 
-/*
- * write to the twl6040 register space
- */
 static int twl6040_write(struct snd_soc_codec *codec,
 			unsigned int reg, unsigned int value)
 {
@@ -280,7 +176,7 @@ static int twl6040_write(struct snd_soc_codec *codec,
 	if (reg >= TWL6040_CACHEREGNUM)
 		return -EIO;
 
-	twl6040_write_reg_cache(codec, reg, value);
+	twl6040_update_dl12_cache(codec, reg, value);
 	if (twl6040_can_write_to_chip(codec, reg))
 		return twl6040_reg_write(twl6040, reg, value);
 	else
@@ -289,34 +185,27 @@ static int twl6040_write(struct snd_soc_codec *codec,
 
 static void twl6040_init_chip(struct snd_soc_codec *codec)
 {
-	struct twl6040 *twl6040 = codec->control_data;
-	u8 val;
-
-	/* Update reg_cache: ASICREV, and TRIM values */
-	val = twl6040_get_revid(twl6040);
-	twl6040_write_reg_cache(codec, TWL6040_REG_ASICREV, val);
-
-	twl6040_read_reg_volatile(codec, TWL6040_REG_TRIM1);
-	twl6040_read_reg_volatile(codec, TWL6040_REG_TRIM2);
-	twl6040_read_reg_volatile(codec, TWL6040_REG_TRIM3);
-	twl6040_read_reg_volatile(codec, TWL6040_REG_HSOTRIM);
-	twl6040_read_reg_volatile(codec, TWL6040_REG_HFOTRIM);
+	twl6040_read(codec, TWL6040_REG_TRIM1);
+	twl6040_read(codec, TWL6040_REG_TRIM2);
+	twl6040_read(codec, TWL6040_REG_TRIM3);
+	twl6040_read(codec, TWL6040_REG_HSOTRIM);
+	twl6040_read(codec, TWL6040_REG_HFOTRIM);
 
 	/* Change chip defaults */
 	/* No imput selected for microphone amplifiers */
-	twl6040_write_reg_cache(codec, TWL6040_REG_MICLCTL, 0x18);
-	twl6040_write_reg_cache(codec, TWL6040_REG_MICRCTL, 0x18);
+	twl6040_write(codec, TWL6040_REG_MICLCTL, 0x18);
+	twl6040_write(codec, TWL6040_REG_MICRCTL, 0x18);
 
 	/*
 	 * We need to lower the default gain values, so the ramp code
 	 * can work correctly for the first playback.
 	 * This reduces the pop noise heard at the first playback.
 	 */
-	twl6040_write_reg_cache(codec, TWL6040_REG_HSGAIN, 0xff);
-	twl6040_write_reg_cache(codec, TWL6040_REG_EARCTL, 0x1e);
-	twl6040_write_reg_cache(codec, TWL6040_REG_HFLGAIN, 0x1d);
-	twl6040_write_reg_cache(codec, TWL6040_REG_HFRGAIN, 0x1d);
-	twl6040_write_reg_cache(codec, TWL6040_REG_LINEGAIN, 0);
+	twl6040_write(codec, TWL6040_REG_HSGAIN, 0xff);
+	twl6040_write(codec, TWL6040_REG_EARCTL, 0x1e);
+	twl6040_write(codec, TWL6040_REG_HFLGAIN, 0x1d);
+	twl6040_write(codec, TWL6040_REG_HFRGAIN, 0x1d);
+	twl6040_write(codec, TWL6040_REG_LINEGAIN, 0);
 }
 
 /* set headset dac and driver power mode */
@@ -325,8 +214,8 @@ static int headset_power_mode(struct snd_soc_codec *codec, int high_perf)
 	int hslctl, hsrctl;
 	int mask = TWL6040_HSDRVMODE | TWL6040_HSDACMODE;
 
-	hslctl = twl6040_read_reg_cache(codec, TWL6040_REG_HSLCTL);
-	hsrctl = twl6040_read_reg_cache(codec, TWL6040_REG_HSRCTL);
+	hslctl = twl6040_read(codec, TWL6040_REG_HSLCTL);
+	hsrctl = twl6040_read(codec, TWL6040_REG_HSRCTL);
 
 	if (high_perf) {
 		hslctl &= ~mask;
@@ -353,8 +242,8 @@ static int twl6040_hs_dac_event(struct snd_soc_dapm_widget *w,
 	 * Both HS DAC need to be turned on (before the HS driver) and off at
 	 * the same time.
 	 */
-	hslctl = twl6040_read_reg_cache(codec, TWL6040_REG_HSLCTL);
-	hsrctl = twl6040_read_reg_cache(codec, TWL6040_REG_HSRCTL);
+	hslctl = twl6040_read(codec, TWL6040_REG_HSLCTL);
+	hsrctl = twl6040_read(codec, TWL6040_REG_HSRCTL);
 	if (SND_SOC_DAPM_EVENT_ON(event)) {
 		hslctl |= TWL6040_HSDACENA;
 		hsrctl |= TWL6040_HSDACENA;
@@ -399,7 +288,7 @@ static void twl6040_hs_jack_report(struct snd_soc_codec *codec,
 	mutex_lock(&priv->mutex);
 
 	/* Sync status */
-	status = twl6040_read_reg_volatile(codec, TWL6040_REG_STATUS);
+	status = twl6040_read(codec, TWL6040_REG_STATUS);
 	if (status & TWL6040_PLUGCOMP)
 		snd_soc_jack_report(jack, report, report);
 	else
@@ -451,7 +340,7 @@ static int twl6040_soc_dapm_put_vibra_enum(struct snd_kcontrol *kcontrol,
 	unsigned int val;
 
 	/* Do not allow changes while Input/FF efect is running */
-	val = twl6040_read_reg_volatile(codec, e->reg);
+	val = twl6040_read(codec, e->reg);
 	if (val & TWL6040_VIBENA && !(val & TWL6040_VIBSEL))
 		return -EBUSY;
 
@@ -676,7 +565,7 @@ int twl6040_get_trim_value(struct snd_soc_codec *codec, enum twl6040_trim trim)
 	if (unlikely(trim >= TWL6040_TRIM_INVAL))
 		return -EINVAL;
 
-	return twl6040_read_reg_cache(codec, TWL6040_REG_TRIM1 + trim);
+	return twl6040_read(codec, TWL6040_REG_TRIM1 + trim);
 }
 EXPORT_SYMBOL_GPL(twl6040_get_trim_value);
 
@@ -1071,9 +960,9 @@ static void twl6040_mute_path(struct snd_soc_codec *codec, enum twl6040_dai_id i
 
 	switch (id) {
 	case TWL6040_DAI_DL1:
-		hslctl = twl6040_read_reg_cache(codec, TWL6040_REG_HSLCTL);
-		hsrctl = twl6040_read_reg_cache(codec, TWL6040_REG_HSRCTL);
-		earctl = twl6040_read_reg_cache(codec, TWL6040_REG_EARCTL);
+		hslctl = twl6040_read(codec, TWL6040_REG_HSLCTL);
+		hsrctl = twl6040_read(codec, TWL6040_REG_HSRCTL);
+		earctl = twl6040_read(codec, TWL6040_REG_EARCTL);
 
 		if (mute) {
 			/* Power down drivers and DACs */
@@ -1089,8 +978,8 @@ static void twl6040_mute_path(struct snd_soc_codec *codec, enum twl6040_dai_id i
 		priv->dl1_unmuted = !mute;
 		break;
 	case TWL6040_DAI_DL2:
-		hflctl = twl6040_read_reg_cache(codec, TWL6040_REG_HFLCTL);
-		hfrctl = twl6040_read_reg_cache(codec, TWL6040_REG_HFRCTL);
+		hflctl = twl6040_read(codec, TWL6040_REG_HFLCTL);
+		hfrctl = twl6040_read(codec, TWL6040_REG_HFRCTL);
 
 		if (mute) {
 			/* Power down drivers and DACs */
@@ -1227,6 +1116,7 @@ static int twl6040_resume(struct snd_soc_codec *codec)
 static int twl6040_probe(struct snd_soc_codec *codec)
 {
 	struct twl6040_data *priv;
+	struct twl6040 *twl6040 = dev_get_drvdata(codec->dev->parent);
 	struct platform_device *pdev = container_of(codec->dev,
 						   struct platform_device, dev);
 	int ret = 0;
@@ -1238,7 +1128,7 @@ static int twl6040_probe(struct snd_soc_codec *codec)
 	snd_soc_codec_set_drvdata(codec, priv);
 
 	priv->codec = codec;
-	codec->control_data = dev_get_drvdata(codec->dev->parent);
+	codec->control_data = twl6040;
 
 	priv->plug_irq = platform_get_irq(pdev, 0);
 	if (priv->plug_irq < 0) {
@@ -1258,10 +1148,10 @@ static int twl6040_probe(struct snd_soc_codec *codec)
 		return ret;
 	}
 
+	twl6040_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 	twl6040_init_chip(codec);
 
-	/* power on device */
-	return twl6040_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+	return 0;
 }
 
 static int twl6040_remove(struct snd_soc_codec *codec)
@@ -1279,12 +1169,9 @@ static struct snd_soc_codec_driver soc_codec_dev_twl6040 = {
 	.remove = twl6040_remove,
 	.suspend = twl6040_suspend,
 	.resume = twl6040_resume,
-	.read = twl6040_read_reg_cache,
+	.read = twl6040_read,
 	.write = twl6040_write,
 	.set_bias_level = twl6040_set_bias_level,
-	.reg_cache_size = ARRAY_SIZE(twl6040_reg),
-	.reg_word_size = sizeof(u8),
-	.reg_cache_default = twl6040_reg,
 	.ignore_pmdown_time = true,
 
 	.controls = twl6040_snd_controls,
-- 
1.8.4.2

