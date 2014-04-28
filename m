Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaD1EqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 00:46:03 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48595 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaD1EqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 00:46:00 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        sbkim73@samsung.com, rdunlap@infradead.org, dianders@chromium.org
Subject: [PATCH V3] ASoC: samsung: Add sound card driver for Snow board
Date: Mon, 28 Apr 2014 10:14:39 +0530
Message-Id: <1398660279-25168-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added machine driver to instantiate I2S based sound card on Snow
board. It has MAX98095 audio codec on board.

There are some other variants for Snow board which have MAX98090
audio codec. Hence support for MAX98090 is also added to this
driver.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
Changes for V3:
1. Updated documentation (I2S0 -> I2S)
2. Removed 'Capture' DAI and renamed 'Playback' DAI as 'Primary'.
3. Updated patch subject to match sub-system naming style.

Changes for V2:
Addressed various comments from Mark Brown.
1. Moved DAIFMT flags to dai_link. Removed snd_soc_dai_set_fmt calls.
2. Removed BCLK settings.
3. Moved sysclk settings to late_probe.
4. Removed now empty snow_hw_params.
5. Removed snow_init
6. Used devm_snd_soc_register_card. Also removed empty remove function.
7. Removed non-DT handling as the driver is DT only.

Additional nits:
1. Renamed snow_driver_probe to snow_probe
2. Removed unused pm_ops.
3. Updated clock settings for I2S block (Earlier it was I2S_CDCLK,
   whereas it should be I2S_RCLKSRC_0).
4. Removed 'card-name' DT property as it was not used in earlier
   sound-card driver DT bindings. Will be added later.

 Documentation/devicetree/bindings/sound/snow.txt |   17 +++
 sound/soc/samsung/Kconfig                        |   10 ++
 sound/soc/samsung/Makefile                       |    2 +
 sound/soc/samsung/snow.c                         |  122 ++++++++++++++++++++++
 4 files changed, 151 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/snow.txt
 create mode 100644 sound/soc/samsung/snow.c

diff --git a/Documentation/devicetree/bindings/sound/snow.txt b/Documentation/devicetree/bindings/sound/snow.txt
new file mode 100644
index 0000000..678b191
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/snow.txt
@@ -0,0 +1,17 @@
+Audio Binding for Snow boards
+
+Required properties:
+- compatible : Can be one of the following,
+			"google,snow-audio-max98090" or
+			"google,snow-audio-max98095"
+- samsung,i2s-controller: The phandle of the Samsung I2S controller
+- samsung,audio-codec: The phandle of the audio codec
+
+Example:
+
+sound {
+		compatible = "google,snow-audio-max98095";
+
+		samsung,i2s-controller = <&i2s0>;
+		samsung,audio-codec = <&max98095>;
+};
diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index f2e2891..50aa289 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -231,3 +231,13 @@ config SND_SOC_LITTLEMILL
 	select SND_SAMSUNG_I2S
 	select MFD_WM8994
 	select SND_SOC_WM8994
+
+config SND_SOC_SNOW
+	tristate "Audio support for Google Snow boards"
+	depends on SND_SOC_SAMSUNG
+	select SND_SOC_MAX98090
+	select SND_SOC_MAX98095
+	select SND_SAMSUNG_I2S
+	help
+	  Say Y if you want to add audio support for various Snow
+	  boards based on Exynos5 series of SoCs.
diff --git a/sound/soc/samsung/Makefile b/sound/soc/samsung/Makefile
index 86715d8..6d0212b 100644
--- a/sound/soc/samsung/Makefile
+++ b/sound/soc/samsung/Makefile
@@ -34,6 +34,7 @@ snd-soc-h1940-uda1380-objs := h1940_uda1380.o
 snd-soc-rx1950-uda1380-objs := rx1950_uda1380.o
 snd-soc-smdk-wm8580-objs := smdk_wm8580.o
 snd-soc-smdk-wm8994-objs := smdk_wm8994.o
+snd-soc-snow-objs := snow.o
 snd-soc-smdk-wm9713-objs := smdk_wm9713.o
 snd-soc-s3c64xx-smartq-wm8987-objs := smartq_wm8987.o
 snd-soc-goni-wm8994-objs := goni_wm8994.o
@@ -58,6 +59,7 @@ obj-$(CONFIG_SND_SOC_SAMSUNG_H1940_UDA1380) += snd-soc-h1940-uda1380.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_RX1950_UDA1380) += snd-soc-rx1950-uda1380.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_SMDK_WM8580) += snd-soc-smdk-wm8580.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_SMDK_WM8994) += snd-soc-smdk-wm8994.o
+obj-$(CONFIG_SND_SOC_SNOW) += snd-soc-snow.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_SMDK_WM9713) += snd-soc-smdk-wm9713.o
 obj-$(CONFIG_SND_SOC_SMARTQ) += snd-soc-s3c64xx-smartq-wm8987.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_SMDK_SPDIF) += snd-soc-smdk-spdif.o
diff --git a/sound/soc/samsung/snow.c b/sound/soc/samsung/snow.c
new file mode 100644
index 0000000..0fa89a4
--- /dev/null
+++ b/sound/soc/samsung/snow.c
@@ -0,0 +1,122 @@
+/*
+ * ASoC machine driver for Snow boards
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+
+#include <sound/soc.h>
+
+#include "i2s.h"
+
+#define FIN_PLL_RATE		24000000
+
+static struct snd_soc_dai_link snow_dai[] = {
+	{
+		.name = "Primary",
+		.stream_name = "Primary",
+		.codec_dai_name = "HiFi",
+		.dai_fmt = SND_SOC_DAIFMT_I2S |
+				SND_SOC_DAIFMT_NB_NF |
+				SND_SOC_DAIFMT_CBS_CFS,
+	},
+};
+
+static int snow_late_probe(struct snd_soc_card *card)
+{
+	struct snd_soc_dai *codec_dai = card->rtd[0].codec_dai;
+	struct snd_soc_dai *cpu_dai = card->rtd[0].cpu_dai;
+	int ret;
+
+	/* Set the MCLK rate for the codec */
+	ret = snd_soc_dai_set_sysclk(codec_dai, 0,
+					FIN_PLL_RATE, SND_SOC_CLOCK_IN);
+	if (ret < 0)
+		return ret;
+
+	/* Select I2S Bus clock to set RCLK and BCLK */
+	ret = snd_soc_dai_set_sysclk(cpu_dai, SAMSUNG_I2S_RCLKSRC_0,
+					0, SND_SOC_CLOCK_IN);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static struct snd_soc_card snow_snd = {
+	.name = "Snow-I2S",
+	.dai_link = snow_dai,
+	.num_links = ARRAY_SIZE(snow_dai),
+
+	.late_probe = snow_late_probe,
+};
+
+static int snow_probe(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = &snow_snd;
+	struct device_node *i2s_node, *codec_node;
+	int i, ret;
+
+	i2s_node = of_parse_phandle(pdev->dev.of_node,
+				    "samsung,i2s-controller", 0);
+	if (!i2s_node) {
+		dev_err(&pdev->dev,
+			"Property 'i2s-controller' missing or invalid\n");
+		return -EINVAL;
+	}
+
+	codec_node = of_parse_phandle(pdev->dev.of_node,
+				      "samsung,audio-codec", 0);
+	if (!codec_node) {
+		dev_err(&pdev->dev,
+			"Property 'audio-codec' missing or invalid\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(snow_dai); i++) {
+		snow_dai[i].codec_of_node = codec_node;
+		snow_dai[i].cpu_of_node = i2s_node;
+		snow_dai[i].platform_of_node = i2s_node;
+	}
+
+	card->dev = &pdev->dev;
+
+	ret = devm_snd_soc_register_card(&pdev->dev, card);
+	if (ret) {
+		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static const struct of_device_id snow_of_match[] = {
+	{ .compatible = "google,snow-audio-max98090", },
+	{ .compatible = "google,snow-audio-max98095", },
+	{},
+};
+
+static struct platform_driver snow_driver = {
+	.driver = {
+		.name = "snow-audio",
+		.owner = THIS_MODULE,
+		.of_match_table = snow_of_match,
+	},
+	.probe = snow_probe,
+};
+
+module_platform_driver(snow_driver);
+
+MODULE_DESCRIPTION("ALSA SoC Audio machine driver for Snow");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

