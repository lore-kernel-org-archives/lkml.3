Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaEVJTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:19:36 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53047 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbaEVJTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:19:32 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, dianders@chromium.org,
        jerry.wong@maximintegrated.com
Subject: [PATCH 2/2] ASoC: max98095: Add master clock handling
Date: Thu, 22 May 2014 14:47:08 +0530
Message-Id: <1400750228-13750-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400750228-13750-1-git-send-email-tushar.behera@linaro.org>
References: <1400750228-13750-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If master clock is provided through device tree, then update
the master clock frequency during set_sysclk.

Documentation has been updated to reflect the change.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 .../devicetree/bindings/sound/max98095.txt         |    6 ++++++
 sound/soc/codecs/max98095.c                        |   14 ++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/max98095.txt b/Documentation/devicetree/bindings/sound/max98095.txt
index bacbeaa..318a4c8 100644
--- a/Documentation/devicetree/bindings/sound/max98095.txt
+++ b/Documentation/devicetree/bindings/sound/max98095.txt
@@ -8,6 +8,12 @@ Required properties:
 
 - reg : The I2C address of the device.
 
+Optional properties:
+
+- clocks: The phandle of the master clock to the CODEC
+
+- clock-names: Should be "mclk"
+
 Example:
 
 max98095: codec@11 {
diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index d6c1e4c..4d66b95 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
+#include <linux/clk.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -42,6 +43,7 @@ struct max98095_priv {
 	struct regmap *regmap;
 	enum max98095_type devtype;
 	struct max98095_pdata *pdata;
+	struct clk *mclk;
 	unsigned int sysclk;
 	struct max98095_cdata dai[3];
 	const char **eq_texts;
@@ -1395,6 +1397,11 @@ static int max98095_dai_set_sysclk(struct snd_soc_dai *dai,
 	if (freq == max98095->sysclk)
 		return 0;
 
+	if (!IS_ERR(max98095->mclk)) {
+		freq = clk_round_rate(max98095->mclk, freq);
+		clk_set_rate(max98095->mclk, freq);
+	}
+
 	/* Setup clocks for slave mode, and using the PLL
 	 * PSCLK = 0x01 (when master clk is 10MHz to 20MHz)
 	 *         0x02 (when master clk is 20MHz to 40MHz)..
@@ -2238,6 +2245,10 @@ static int max98095_probe(struct snd_soc_codec *codec)
 	struct i2c_client *client;
 	int ret = 0;
 
+	max98095->mclk = devm_clk_get(codec->dev, "mclk");
+	if (!IS_ERR(max98095->mclk))
+		clk_prepare_enable(max98095->mclk);
+
 	/* reset the codec, the DSP core, and disable all interrupts */
 	max98095_reset(codec);
 
@@ -2340,6 +2351,9 @@ static int max98095_remove(struct snd_soc_codec *codec)
 	if (max98095->headphone_jack || max98095->mic_jack)
 		max98095_jack_detect_disable(codec);
 
+	if (!IS_ERR(max98095->mclk))
+		clk_disable_unprepare(max98095->mclk);
+
 	if (client->irq)
 		free_irq(client->irq, codec);
 
-- 
1.7.9.5

