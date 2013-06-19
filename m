Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3FSNQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:16:13 -0400
Received: from skyrme.org ([193.175.80.135]:45887 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468Ab3FSNQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:16:11 -0400
Date: 19 Jun 2013 13:16:06 +0000
Message-Id: <1371647766-4900-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Fabio Estevam" <fabio.estevam@freescale.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "Zeng Zhaoming" <zengzm.kernel@gmail.com>, alsa-devel@alsa-project.org,
        "Liam Girdwood" <lgirdwood@gmail.com>, "Takashi Iwai" <tiwai@suse.de>,
        "Jaroslav Kysela" <perex@perex.cz>,
        "Wolfram Sang" <w.sang@pengutronix.de>, broonie@kernel.org,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH v3] sound/sgtl5000: fix codec register initial values and handling
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <51B749F5.3010907@freescale.com>
References: <51B749F5.3010907@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to documentation bit 3:2 in register SSS_CTRL are
reserved and zero, so initially setting the register to 0x0008
does not make much sense. Instead, bit 4 should be marked set,
as this is the power up default.

Further, mask computation in declarative part is obviously wrong:
Fix FRAC DIVISOR to provide an 11 bit mask correctly.

Next, powering down PLL before switching to a mode that
does not use it, is a bad idea. So first set the mode control,
then power down PLL.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 sound/soc/codecs/sgtl5000.c |   11 +++++++----
 sound/soc/codecs/sgtl5000.h |    2 +-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 92bbfec..6162e19 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -38,7 +38,7 @@
 static const struct reg_default sgtl5000_reg_defaults[] = {
 	{ SGTL5000_CHIP_CLK_CTRL,		0x0008 },
 	{ SGTL5000_CHIP_I2S_CTRL,		0x0010 },
-	{ SGTL5000_CHIP_SSS_CTRL,		0x0008 },
+	{ SGTL5000_CHIP_SSS_CTRL,		0x0010 },
 	{ SGTL5000_CHIP_DAC_VOL,		0x3c3c },
 	{ SGTL5000_CHIP_PAD_STRENGTH,		0x015f },
 	{ SGTL5000_CHIP_ANA_HP_CTRL,		0x1818 },
@@ -644,16 +644,19 @@ static int sgtl5000_set_clock(struct snd_soc_codec *codec, int frame_rate)
 		snd_soc_update_bits(codec, SGTL5000_CHIP_ANA_POWER,
 			SGTL5000_PLL_POWERUP | SGTL5000_VCOAMP_POWERUP,
 			SGTL5000_PLL_POWERUP | SGTL5000_VCOAMP_POWERUP);
+
+		/* if using pll, clk_ctrl must be set after pll power up */
+		snd_soc_write(codec, SGTL5000_CHIP_CLK_CTRL, clk_ctl);
 	} else {
+		/* otherwise, clk_ctrl must be set before pll power down */
+		snd_soc_write(codec, SGTL5000_CHIP_CLK_CTRL, clk_ctl);
+
 		/* power down pll */
 		snd_soc_update_bits(codec, SGTL5000_CHIP_ANA_POWER,
 			SGTL5000_PLL_POWERUP | SGTL5000_VCOAMP_POWERUP,
 			0);
 	}
 
-	/* if using pll, clk_ctrl must be set after pll power up */
-	snd_soc_write(codec, SGTL5000_CHIP_CLK_CTRL, clk_ctl);
-
 	return 0;
 }
 
diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
index 8a9f435..d3a68bb 100644
--- a/sound/soc/codecs/sgtl5000.h
+++ b/sound/soc/codecs/sgtl5000.h
@@ -347,7 +347,7 @@
 #define SGTL5000_PLL_INT_DIV_MASK		0xf800
 #define SGTL5000_PLL_INT_DIV_SHIFT		11
 #define SGTL5000_PLL_INT_DIV_WIDTH		5
-#define SGTL5000_PLL_FRAC_DIV_MASK		0x0700
+#define SGTL5000_PLL_FRAC_DIV_MASK		0x07ff
 #define SGTL5000_PLL_FRAC_DIV_SHIFT		0
 #define SGTL5000_PLL_FRAC_DIV_WIDTH		11
 
-- 
1.7.9.5

