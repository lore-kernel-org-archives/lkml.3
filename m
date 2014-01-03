Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaACNa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:30:26 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53443 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaACN2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:28:18 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/11] ASoC: twl4030: Remove reset registers functionality
Date: Fri, 3 Jan 2014 15:27:51 +0200
Message-ID: <1388755676-16036-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The register states now tracked by the regmap implementation in the core which
makes the reset registers functionality 'redundant' since we know the state
of the registers now all the time.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/i2c/twl.h    |  1 -
 sound/soc/codecs/twl4030.c | 17 -----------------
 2 files changed, 18 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 2937a9472b94..ade1c06d4ceb 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -670,7 +670,6 @@ struct twl4030_codec_data {
 	unsigned int digimic_delay; /* in ms */
 	unsigned int ramp_delay_value;
 	unsigned int offset_cncl_path;
-	unsigned int reset_registers:1;
 	unsigned int hs_extmute:1;
 	int hs_extmute_gpio;
 };
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 7b732ab70d2c..ab2f22299db2 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -268,17 +268,6 @@ static void twl4030_codec_enable(struct snd_soc_codec *codec, int enable)
 	udelay(10);
 }
 
-static inline void twl4030_reset_registers(struct snd_soc_codec *codec)
-{
-	int i;
-
-	/* set all audio section registers to reasonable defaults */
-	for (i = TWL4030_REG_OPTION; i <= TWL4030_REG_MISC_SET_2; i++)
-		if (i != TWL4030_REG_APLL_CTL)
-			twl4030_write(codec, i, twl4030_reg[i]);
-
-}
-
 static void twl4030_setup_pdata_of(struct twl4030_codec_data *pdata,
 				   struct device_node *node)
 {
@@ -359,10 +348,6 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 		}
 	}
 
-	/* Reset registers, if no setup data or if instructed to do so */
-	if (!pdata || (pdata && pdata->reset_registers))
-		twl4030_reset_registers(codec);
-
 	/* Refresh APLL_CTL register from HW */
 	twl_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &byte,
 			    TWL4030_REG_APLL_CTL);
@@ -2293,8 +2278,6 @@ static int twl4030_soc_remove(struct snd_soc_codec *codec)
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
 	struct twl4030_codec_data *pdata = twl4030->pdata;
 
-	/* Reset registers to their chip default before leaving */
-	twl4030_reset_registers(codec);
 	twl4030_set_bias_level(codec, SND_SOC_BIAS_OFF);
 
 	if (pdata && pdata->hs_extmute && gpio_is_valid(pdata->hs_extmute_gpio))
-- 
1.8.5.2

