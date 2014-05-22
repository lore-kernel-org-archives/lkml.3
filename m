Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaEVJT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:19:28 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:58345 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbaEVJT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:19:26 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, dianders@chromium.org,
        jerry.wong@maximintegrated.com
Subject: [PATCH 1/2] ASoC: max98090: Add master clock handling
Date: Thu, 22 May 2014 14:47:07 +0530
Message-Id: <1400750228-13750-2-git-send-email-tushar.behera@linaro.org>
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
 .../devicetree/bindings/sound/max98090.txt         |    6 ++++++
 sound/soc/codecs/max98090.c                        |   13 +++++++++++++
 sound/soc/codecs/max98090.h                        |    1 +
 3 files changed, 20 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/max98090.txt b/Documentation/devicetree/bindings/sound/max98090.txt
index e4c8b36..a5e63fa 100644
--- a/Documentation/devicetree/bindings/sound/max98090.txt
+++ b/Documentation/devicetree/bindings/sound/max98090.txt
@@ -10,6 +10,12 @@ Required properties:
 
 - interrupts : The CODEC's interrupt output.
 
+Optional properties:
+
+- clocks: The phandle of the master clock to the CODEC
+
+- clock-names: Should be "mclk"
+
 Pins on the device (for linking into audio routes):
 
   * MIC1
diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 9b76f5a..41c61eb 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -17,6 +17,7 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/clk.h>
 #include <sound/jack.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -1929,6 +1930,11 @@ static int max98090_dai_set_sysclk(struct snd_soc_dai *dai,
 	if (freq == max98090->sysclk)
 		return 0;
 
+	if (!IS_ERR(max98090->mclk)) {
+		freq = clk_round_rate(max98090->mclk, freq);
+		clk_set_rate(max98090->mclk, freq);
+	}
+
 	/* Setup clocks for slave mode, and using the PLL
 	 * PSCLK = 0x01 (when master clk is 10MHz to 20MHz)
 	 *		 0x02 (when master clk is 20MHz to 40MHz)..
@@ -2213,6 +2219,10 @@ static int max98090_probe(struct snd_soc_codec *codec)
 
 	dev_dbg(codec->dev, "max98090_probe\n");
 
+	max98090->mclk = devm_clk_get(codec->dev, "mclk");
+	if (!IS_ERR(max98090->mclk))
+		clk_prepare_enable(max98090->mclk);
+
 	max98090->codec = codec;
 
 	/* Reset the codec, the DSP core, and disable all interrupts */
@@ -2308,6 +2318,9 @@ static int max98090_remove(struct snd_soc_codec *codec)
 
 	cancel_delayed_work_sync(&max98090->jack_work);
 
+	if (!IS_ERR(max98090->mclk))
+		clk_disable_unprepare(max98090->mclk);
+
 	return 0;
 }
 
diff --git a/sound/soc/codecs/max98090.h b/sound/soc/codecs/max98090.h
index 5a3c8d0..cf1b606 100644
--- a/sound/soc/codecs/max98090.h
+++ b/sound/soc/codecs/max98090.h
@@ -1524,6 +1524,7 @@ struct max98090_priv {
 	struct snd_soc_codec *codec;
 	enum max98090_type devtype;
 	struct max98090_pdata *pdata;
+	struct clk *mclk;
 	unsigned int sysclk;
 	unsigned int bclk;
 	unsigned int lrclk;
-- 
1.7.9.5

