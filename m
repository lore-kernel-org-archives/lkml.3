Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab3G3KdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:33:16 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41460 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab3G3Kcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 06:32:48 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH v6 8/8] ASoC: sam9x5: get codec MCLK via device tree
Date: Tue, 30 Jul 2013 12:32:09 +0200
Message-Id: <1375180329-4860-9-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of having the clock rate hard coded, and thus, only compatible
with one board, we can make it compatible with other implementations.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 .../bindings/sound/atmel-sam9x5-wm8731-audio.txt     |    4 ++++
 arch/arm/boot/dts/at91sam9x5ek.dtsi                  |    8 ++++++++
 sound/soc/atmel/sam9x5_wm8731.c                      |   18 ++++++++++++++----
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt b/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
index 0720857..114a4c5 100644
--- a/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
+++ b/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
@@ -8,6 +8,8 @@ Required properties:
   - atmel,audio-routing: A list of the connections between audio components.
     Each entry is a pair of strings, the first being the connection's sink,
     the second being the connection's source.
+  - clocks: Must contain an entry for the codec master clock.
+  - clock-names : Must be "mclk" (clock that feeds the codec master clock)
 
 Available audio endpoints for the audio-routing table:
 
@@ -32,4 +34,6 @@ sound {
 
 	atmel,ssc-controller = <&ssc0>;
 	atmel,audio-codec = <&wm8731>;
+	clocks = <&sound_crystal 0>;
+	clock-names = "mclk";
 };
diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index 9afe15b..b5ff17c 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -114,6 +114,12 @@
 		};
 	};
 
+	sound_crystal: osc@0 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency  = <12288000>;
+	};
+
 	sound {
 		compatible = "atmel,sam9x5-wm8731-audio";
 
@@ -127,5 +133,7 @@
 
 		atmel,ssc-controller = <&ssc0>;
 		atmel,audio-codec = <&wm8731>;
+		clocks = <&sound_crystal 0>;
+		clock-names = "mclk";
 	};
 };
diff --git a/sound/soc/atmel/sam9x5_wm8731.c b/sound/soc/atmel/sam9x5_wm8731.c
index 992ae38..f33c181 100644
--- a/sound/soc/atmel/sam9x5_wm8731.c
+++ b/sound/soc/atmel/sam9x5_wm8731.c
@@ -23,6 +23,8 @@
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
 #include <linux/device.h>
+#include <linux/err.h>
+#include <linux/clk.h>
 
 #include <sound/soc.h>
 #include <sound/soc-dai.h>
@@ -31,12 +33,10 @@
 #include "../codecs/wm8731.h"
 #include "atmel_ssc_dai.h"
 
-
-#define MCLK_RATE 12288000
-
 #define DRV_NAME "sam9x5-snd-wm8731"
 
 struct sam9x5_drvdata {
+	struct clk *mclk;
 	int ssc_id;
 };
 
@@ -46,6 +46,7 @@ struct sam9x5_drvdata {
 static int sam9x5_wm8731_init(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	struct sam9x5_drvdata *priv = snd_soc_card_get_drvdata(rtd->card);
 	struct device *dev = rtd->dev;
 	int ret;
 
@@ -53,7 +54,8 @@ static int sam9x5_wm8731_init(struct snd_soc_pcm_runtime *rtd)
 
 	/* set the codec system clock for DAC and ADC */
 	ret = snd_soc_dai_set_sysclk(codec_dai, WM8731_SYSCLK_XTAL,
-				     MCLK_RATE, SND_SOC_CLOCK_IN);
+				     clk_get_rate(priv->mclk),
+				     SND_SOC_CLOCK_IN);
 	if (ret < 0) {
 		dev_err(dev, "ASoC: Failed to set WM8731 SYSCLK: %d\n", ret);
 		return ret;
@@ -142,6 +144,13 @@ static int sam9x5_wm8731_driver_probe(struct platform_device *pdev)
 
 	priv->ssc_id = of_alias_get_id(cpu_np, "ssc");
 
+	priv->mclk = devm_clk_get(&pdev->dev, "mclk");
+	if (IS_ERR(priv->mclk)) {
+		ret = PTR_ERR(priv->mclk);
+		dev_err(&pdev->dev, "Failed to get MCLK: %d\n", ret);
+		goto out;
+	}
+
 	ret = atmel_ssc_set_audio(priv->ssc_id);
 	if (ret != 0) {
 		dev_err(&pdev->dev,
@@ -153,6 +162,7 @@ static int sam9x5_wm8731_driver_probe(struct platform_device *pdev)
 	of_node_put(codec_np);
 	of_node_put(cpu_np);
 
+	snd_soc_card_set_drvdata(card, priv);
 	platform_set_drvdata(pdev, card);
 
 	ret = snd_soc_register_card(card);
-- 
1.7.10.4

