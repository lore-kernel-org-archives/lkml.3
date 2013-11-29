Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3K2OD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:03:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34413 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3K2ODz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:03:55 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 2/5] ASoC: twl6040: Custom caching for sensitive DL1/2 path registers
Date: Fri, 29 Nov 2013 16:03:44 +0200
Message-ID: <1385733827-19831-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
References: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a small register cache for registers which needs special caching
to reduce pop noise:
TWL6040_REG_HSLCTL, TWL6040_REG_HSRCTL, TWL6040_REG_EARCTL, TWL6040_REG_HFLCTL
and TWL6040_REG_HFRCTL.
Switch over and use the new small cache for these registers instead of the
main reg_cache.
This is in preparation to remove the local ASoC reg_cache from the driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c | 51 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index ef13a50..fb8c65b 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -72,6 +72,7 @@ struct twl6040_data {
 	int hs_power_mode_locked;
 	bool dl1_unmuted;
 	bool dl2_unmuted;
+	u8 dl12_cache[TWL6040_REG_HFRCTL - TWL6040_REG_HSLCTL + 1];
 	unsigned int clk_in;
 	unsigned int sysclk;
 	struct twl6040_jack_data hs_jack;
@@ -174,18 +175,62 @@ static struct snd_pcm_hw_constraint_list sysclk_constraints[] = {
 	{ .count = ARRAY_SIZE(hp_rates), .list = hp_rates, },
 };
 
+static inline int twl6040_read_dl12_cache(struct snd_soc_codec *codec,
+					   u8 reg, u8 *value)
+{
+	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
+	int ret = 0;
+
+	switch (reg) {
+	case TWL6040_REG_HSLCTL:
+	case TWL6040_REG_HSRCTL:
+	case TWL6040_REG_EARCTL:
+	case TWL6040_REG_HFLCTL:
+	case TWL6040_REG_HFRCTL:
+		*value = priv->dl12_cache[reg - TWL6040_REG_HSLCTL];
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 /*
  * read twl6040 register cache
  */
 static inline unsigned int twl6040_read_reg_cache(struct snd_soc_codec *codec,
-						unsigned int reg)
+						  unsigned int reg)
 {
 	u8 *cache = codec->reg_cache;
+	u8 value;
 
 	if (reg >= TWL6040_CACHEREGNUM)
 		return -EIO;
 
-	return cache[reg];
+	if (twl6040_read_dl12_cache(codec, reg, &value))
+		value = cache[reg];
+
+	return value;
+}
+
+static inline void twl6040_update_dl12_cache(struct snd_soc_codec *codec,
+					     u8 reg, u8 value)
+{
+	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
+
+	switch (reg) {
+	case TWL6040_REG_HSLCTL:
+	case TWL6040_REG_HSRCTL:
+	case TWL6040_REG_EARCTL:
+	case TWL6040_REG_HFLCTL:
+	case TWL6040_REG_HFRCTL:
+		priv->dl12_cache[reg - TWL6040_REG_HSLCTL] = value;
+		break;
+	default:
+		break;
+	}
 }
 
 /*
@@ -199,6 +244,8 @@ static inline void twl6040_write_reg_cache(struct snd_soc_codec *codec,
 	if (reg >= TWL6040_CACHEREGNUM)
 		return;
 	cache[reg] = value;
+
+	twl6040_update_dl12_cache(codec, reg, value);
 }
 
 /*
-- 
1.8.4.2

