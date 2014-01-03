Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaACN22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:28:28 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48569 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbaACN20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:28:26 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/11] ASoC: twl4030: Move the ctl cache update local to twl4030_write() function
Date: Fri, 3 Jan 2014 15:27:55 +0200
Message-ID: <1388755676-16036-11-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no other users of this functionality, the code can be moved inside
of twl4030_write.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl4030.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 7a5b91e70f98..c3c15f891270 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -86,25 +86,6 @@ static void tw4030_init_ctl_cache(struct twl4030_priv *twl4030)
 	}
 }
 
-static void twl4030_update_ctl_cache(struct snd_soc_codec *codec,
-				     unsigned int reg, unsigned int value)
-{
-	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
-
-	switch (reg) {
-	case TWL4030_REG_EAR_CTL:
-	case TWL4030_REG_PREDL_CTL:
-	case TWL4030_REG_PREDR_CTL:
-	case TWL4030_REG_PRECKL_CTL:
-	case TWL4030_REG_PRECKR_CTL:
-	case TWL4030_REG_HS_GAIN_SET:
-		twl4030->ctl_cache[reg - TWL4030_REG_EAR_CTL] = value;
-		break;
-	default:
-		break;
-	}
-}
-
 static unsigned int twl4030_read(struct snd_soc_codec *codec, unsigned int reg)
 {
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
@@ -174,7 +155,22 @@ static bool twl4030_can_write_to_chip(struct snd_soc_codec *codec,
 static int twl4030_write(struct snd_soc_codec *codec, unsigned int reg,
 			 unsigned int value)
 {
-	twl4030_update_ctl_cache(codec, reg, value);
+	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
+
+	/* Update the ctl cache */
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
+
 	if (twl4030_can_write_to_chip(codec, reg))
 		return twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE, value, reg);
 
-- 
1.8.5.2

