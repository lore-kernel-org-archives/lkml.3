Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaETE1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 00:27:49 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37296 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaETE1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 00:27:47 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: lgirdwood@gmail.com, robh+dt@kernel.org, sbkim73@samsung.com,
        rdunlap@infradead.org, broonie@kernel.org, dianders@chromium.org,
        t.figa@samsung.com
Subject: [PATCH] ASoC: samsung: Add 'mclk' handling for Snow sound-card driver
Date: Tue, 20 May 2014 09:55:42 +0530
Message-Id: <1400559942-5666-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For audio to work on Snow board, we need the codec master clock 'mclk'
to be properly configured.

Currently XCLKOUT is configured as 'mclk' for codec chip and it is
required to be clocked at 24MHz for the codec to work properly.

Add appropriate clock handling within Snow sound-card driver to set
'mclk' to operate at 24MHz.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 Documentation/devicetree/bindings/sound/snow.txt |    7 ++++++
 sound/soc/samsung/snow.c                         |   26 +++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/snow.txt b/Documentation/devicetree/bindings/sound/snow.txt
index 678b191..94dd29c 100644
--- a/Documentation/devicetree/bindings/sound/snow.txt
+++ b/Documentation/devicetree/bindings/sound/snow.txt
@@ -7,6 +7,10 @@ Required properties:
 - samsung,i2s-controller: The phandle of the Samsung I2S controller
 - samsung,audio-codec: The phandle of the audio codec
 
+Optional properties:
+- clocks: The phandle of the master clock to audio codec
+- clock-names: Should be "mclk"
+
 Example:
 
 sound {
@@ -14,4 +18,7 @@ sound {
 
 		samsung,i2s-controller = <&i2s0>;
 		samsung,audio-codec = <&max98095>;
+
+		clocks = <&pmu_system_controller>;
+		clock-names = "mclk";
 };
diff --git a/sound/soc/samsung/snow.c b/sound/soc/samsung/snow.c
index 014c177..c910739 100644
--- a/sound/soc/samsung/snow.c
+++ b/sound/soc/samsung/snow.c
@@ -15,13 +15,18 @@
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/clk.h>
 
 #include <sound/soc.h>
 
 #include "i2s.h"
 
+/* Desired clock rate for codec mclk */
 #define FIN_PLL_RATE		24000000
 
+static struct clk *mclk;
+static unsigned long mclk_rate;
+
 static struct snd_soc_dai_link snow_dai[] = {
 	{
 		.name = "Primary",
@@ -41,7 +46,7 @@ static int snow_late_probe(struct snd_soc_card *card)
 
 	/* Set the MCLK rate for the codec */
 	ret = snd_soc_dai_set_sysclk(codec_dai, 0,
-					FIN_PLL_RATE, SND_SOC_CLOCK_IN);
+					mclk_rate, SND_SOC_CLOCK_IN);
 	if (ret < 0)
 		return ret;
 
@@ -68,6 +73,16 @@ static int snow_probe(struct platform_device *pdev)
 	struct device_node *i2s_node, *codec_node;
 	int i, ret;
 
+	/* The codec MCLK should be clocked at 24MHz */
+	mclk = devm_clk_get(&pdev->dev, "mclk");
+	if (!IS_ERR(mclk)) {
+		clk_prepare_enable(mclk);
+		clk_set_rate(mclk, FIN_PLL_RATE);
+		mclk_rate = clk_get_rate(mclk);
+	} else {
+		mclk_rate = FIN_PLL_RATE;
+	}
+
 	i2s_node = of_parse_phandle(pdev->dev.of_node,
 				    "samsung,i2s-controller", 0);
 	if (!i2s_node) {
@@ -101,6 +116,14 @@ static int snow_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static int snow_remove(struct platform_device *pdev)
+{
+	if (!IS_ERR(mclk))
+		clk_disable_unprepare(mclk);
+
+	return 0;
+}
+
 static const struct of_device_id snow_of_match[] = {
 	{ .compatible = "google,snow-audio-max98090", },
 	{ .compatible = "google,snow-audio-max98095", },
@@ -115,6 +138,7 @@ static struct platform_driver snow_driver = {
 		.of_match_table = snow_of_match,
 	},
 	.probe = snow_probe,
+	.remove = snow_remove,
 };
 
 module_platform_driver(snow_driver);
-- 
1.7.9.5

