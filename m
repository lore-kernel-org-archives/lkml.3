Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaACN2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:28:16 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33607 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaACN2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:28:15 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/11] ASoC: twl4030: Separate write condition checking from I/O function
Date: Fri, 3 Jan 2014 15:27:49 +0200
Message-ID: <1388755676-16036-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplifies the code a bit and prepares it to the removal of local caching.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl4030.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index dfc51bb425da..419108ae31de 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -181,50 +181,56 @@ static inline void twl4030_write_reg_cache(struct snd_soc_codec *codec,
 	cache[reg] = value;
 }
 
-/*
- * write to the twl4030 register space
- */
-static int twl4030_write(struct snd_soc_codec *codec,
-			unsigned int reg, unsigned int value)
+static bool twl4030_can_write_to_chip(struct snd_soc_codec *codec,
+				      unsigned int reg)
 {
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
-	int write_to_reg = 0;
+	bool write_to_reg = false;
 
-	twl4030_write_reg_cache(codec, reg, value);
 	/* Decide if the given register can be written */
 	switch (reg) {
 	case TWL4030_REG_EAR_CTL:
 		if (twl4030->earpiece_enabled)
-			write_to_reg = 1;
+			write_to_reg = true;
 		break;
 	case TWL4030_REG_PREDL_CTL:
 		if (twl4030->predrivel_enabled)
-			write_to_reg = 1;
+			write_to_reg = true;
 		break;
 	case TWL4030_REG_PREDR_CTL:
 		if (twl4030->predriver_enabled)
-			write_to_reg = 1;
+			write_to_reg = true;
 		break;
 	case TWL4030_REG_PRECKL_CTL:
 		if (twl4030->carkitl_enabled)
-			write_to_reg = 1;
+			write_to_reg = true;
 		break;
 	case TWL4030_REG_PRECKR_CTL:
 		if (twl4030->carkitr_enabled)
-			write_to_reg = 1;
+			write_to_reg = true;
 		break;
 	case TWL4030_REG_HS_GAIN_SET:
 		if (twl4030->hsl_enabled || twl4030->hsr_enabled)
-			write_to_reg = 1;
+			write_to_reg = true;
 		break;
 	default:
 		/* All other register can be written */
-		write_to_reg = 1;
+		write_to_reg = true;
 		break;
 	}
-	if (write_to_reg)
-		return twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
-					    value, reg);
+
+	return write_to_reg;
+}
+
+/*
+ * write to the twl4030 register space
+ */
+static int twl4030_write(struct snd_soc_codec *codec,
+			 unsigned int reg, unsigned int value)
+{
+	twl4030_write_reg_cache(codec, reg, value);
+	if (twl4030_can_write_to_chip(codec, reg))
+		return twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE, value, reg);
 
 	return 0;
 }
-- 
1.8.5.2

