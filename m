Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab3GKQQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:16:42 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34249 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab3GKQQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:16:40 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH v5 2/7] sound: sam9x5_wm8731: machine driver for at91sam9x5 wm8731 boards
Date: Thu, 11 Jul 2013 18:15:54 +0200
Message-Id: <1373559359-31607-3-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373559359-31607-1-git-send-email-richard.genoud@gmail.com>
References: <1373559359-31607-1-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

Description of the Asoc machine driver for an at91sam9x5 based board
with a wm8731 audio DAC. Wm8731 is clocked by a crystal and used as a
master on the SSC/I2S interface. Its connections are a headphone jack
and an Line input jack.

[Richard: this is based on an old patch from Nicolas that I forward
ported and reworked to use only device tree]

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 .../bindings/sound/atmel-sam9x5-wm8731-audio.txt   |   41 ++++
 sound/soc/atmel/Kconfig                            |   10 +
 sound/soc/atmel/Makefile                           |    2 +
 sound/soc/atmel/sam9x5_wm8731.c                    |  207 ++++++++++++++++++++
 4 files changed, 260 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
 create mode 100644 sound/soc/atmel/sam9x5_wm8731.c

diff --git a/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt b/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
new file mode 100644
index 0000000..630ef8b
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
@@ -0,0 +1,41 @@
+* Atmel at91sam9x5ek wm8731 audio complex
+
+Required properties:
+  - compatible: "atmel,sam9x5-wm8731-audio"
+  - atmel,model: The user-visible name of this sound complex.
+  - atmel,ssc-controller: The phandle of the SSC controller
+  - atmel,audio-codec: The phandle of the WM8731 audio codec
+  - atmel,audio-routing: A list of the connections between audio components.
+    Each entry is a pair of strings, the first being the connection's sink,
+    the second being the connection's source.
+
+Available audio endpoints for the audio-routing table:
+
+Board connectors:
+ * Headphone Jack
+ * Line In Jack
+
+sam9x5 pins:
+ * LOUT
+ * ROUT
+ * LHPOUT
+ * RHPOUT
+ * LLINEIN
+ * RLINEIN
+ * MICIN
+
+Example:
+sound {
+	compatible = "atmel,sam9x5-wm8731-audio";
+
+	atmel,model = "wm8731 @ AT91SAM9X5EK";
+
+	atmel,audio-routing =
+		"Headphone Jack", "RHPOUT",
+		"Headphone Jack", "LHPOUT",
+		"LLINEIN", "Line In Jack",
+		"RLINEIN", "Line In Jack";
+
+	atmel,ssc-controller = <&ssc0>;
+	atmel,audio-codec = <&wm8731>;
+};
diff --git a/sound/soc/atmel/Kconfig b/sound/soc/atmel/Kconfig
index 1c0b185..9eb8c49 100644
--- a/sound/soc/atmel/Kconfig
+++ b/sound/soc/atmel/Kconfig
@@ -33,6 +33,16 @@ config SND_AT91_SOC_SAM9G20_WM8731
 	  Say Y if you want to add support for SoC audio on WM8731-based
 	  AT91sam9g20 evaluation board.
 
+config SND_AT91_SOC_SAM9X5_WM8731
+	tristate "SoC Audio support for WM8731-based at91sam9x5 board"
+	depends on ATMEL_SSC && SND_ATMEL_SOC && SOC_AT91SAM9X5
+	select SND_ATMEL_SOC_SSC
+	select SND_ATMEL_SOC_DMA
+	select SND_SOC_WM8731
+	help
+	  Say Y if you want to add support for audio SoC on an
+	  at91sam9x5 based board that is using WM8731 codec.
+
 config SND_AT91_SOC_AFEB9260
 	tristate "SoC Audio support for AFEB9260 board"
 	depends on ARCH_AT91 && ATMEL_SSC && ARCH_AT91 && MACH_AFEB9260 && SND_ATMEL_SOC
diff --git a/sound/soc/atmel/Makefile b/sound/soc/atmel/Makefile
index 41967cc..7784c09 100644
--- a/sound/soc/atmel/Makefile
+++ b/sound/soc/atmel/Makefile
@@ -11,6 +11,8 @@ obj-$(CONFIG_SND_ATMEL_SOC_SSC) += snd-soc-atmel_ssc_dai.o
 
 # AT91 Machine Support
 snd-soc-sam9g20-wm8731-objs := sam9g20_wm8731.o
+snd-soc-sam9x5-wm8731-objs := sam9x5_wm8731.o
 
 obj-$(CONFIG_SND_AT91_SOC_SAM9G20_WM8731) += snd-soc-sam9g20-wm8731.o
+obj-$(CONFIG_SND_AT91_SOC_SAM9X5_WM8731) += snd-soc-sam9x5-wm8731.o
 obj-$(CONFIG_SND_AT91_SOC_AFEB9260) += snd-soc-afeb9260.o
diff --git a/sound/soc/atmel/sam9x5_wm8731.c b/sound/soc/atmel/sam9x5_wm8731.c
new file mode 100644
index 0000000..8ecf29f
--- /dev/null
+++ b/sound/soc/atmel/sam9x5_wm8731.c
@@ -0,0 +1,207 @@
+/*
+ * sam9x5_wm8731   --	SoC audio for AT91SAM9X5-based boards
+ *			that are using WM8731 as codec.
+ *
+ *  Copyright (C) 2011 Atmel,
+ *		  Nicolas Ferre <nicolas.ferre@atmel.com>
+ *
+ *  Copyright (C) 2013 Paratronic,
+ *		  Richard Genoud <richard.genoud@gmail.com>
+ *
+ * Based on sam9g20_wm8731.c by:
+ * Sedji Gaouaou <sedji.gaouaou@atmel.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+#include <linux/of.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/platform_device.h>
+#include <linux/device.h>
+
+#include <sound/soc.h>
+#include <sound/soc-dai.h>
+#include <sound/soc-dapm.h>
+
+#include "../codecs/wm8731.h"
+#include "atmel_ssc_dai.h"
+
+
+#define MCLK_RATE 12288000
+
+#define DRV_NAME "sam9x5-snd-wm8731"
+
+struct sam9x5_drvdata {
+	int ssc_id;
+};
+
+/*
+ * Logic for a wm8731 as connected on a at91sam9x5ek based board.
+ */
+static int sam9x5_wm8731_init(struct snd_soc_pcm_runtime *rtd)
+{
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	struct device *dev = rtd->dev;
+	int ret;
+
+	dev_dbg(dev, "ASoC: %s called\n", __func__);
+
+	/* set the codec system clock for DAC and ADC */
+	ret = snd_soc_dai_set_sysclk(codec_dai, WM8731_SYSCLK_XTAL,
+				     MCLK_RATE, SND_SOC_CLOCK_IN);
+	if (ret < 0) {
+		dev_err(dev, "ASoC: Failed to set WM8731 SYSCLK: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Audio paths on at91sam9x5ek board:
+ *
+ *  |A| ------------> |      | ---R----> Headphone Jack
+ *  |T| <----\        |  WM  | ---L--/
+ *  |9| ---> CLK <--> | 8731 | <--R----- Line In Jack
+ *  |1| <------------ |      | <--L--/
+ */
+static const struct snd_soc_dapm_widget sam9x5_dapm_widgets[] = {
+	SND_SOC_DAPM_HP("Headphone Jack", NULL),
+	SND_SOC_DAPM_LINE("Line In Jack", NULL),
+};
+
+static struct snd_soc_dai_link sam9x5_dai = {
+	.name = "WM8731",
+	.stream_name = "WM8731 PCM",
+	.codec_dai_name = "wm8731-hifi",
+	.init = sam9x5_wm8731_init,
+	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF
+		| SND_SOC_DAIFMT_CBM_CFM,
+};
+
+static struct sam9x5_drvdata sam9x5_priv;
+
+static struct snd_soc_card snd_soc_sam9x5 = {
+	.owner = THIS_MODULE,
+	.dai_link = &sam9x5_dai,
+	.num_links = 1,
+	.dapm_widgets = sam9x5_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(sam9x5_dapm_widgets),
+	.drvdata = &sam9x5_priv,
+};
+
+static int sam9x5_wm8731_driver_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device_node *codec_np, *cpu_np;
+	int ret;
+
+	if (!np) {
+		dev_err(&pdev->dev, "No device node supplied\n");
+		return -EINVAL;
+	}
+
+	snd_soc_sam9x5.dev = &pdev->dev;
+
+	ret = snd_soc_of_parse_card_name(&snd_soc_sam9x5, "atmel,model");
+	if (ret) {
+		dev_err(&pdev->dev, "atmel,model node missing\n");
+		goto out;
+	}
+
+	ret = snd_soc_of_parse_audio_routing(&snd_soc_sam9x5,
+					     "atmel,audio-routing");
+	if (ret) {
+		dev_err(&pdev->dev, "atmel,audio-routing node missing\n");
+		goto out;
+	}
+
+	codec_np = of_parse_phandle(np, "atmel,audio-codec", 0);
+	if (!codec_np) {
+		dev_err(&pdev->dev, "atmel,audio-codec node missing\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	sam9x5_dai.codec_of_node = codec_np;
+
+	cpu_np = of_parse_phandle(np, "atmel,ssc-controller", 0);
+	if (!cpu_np) {
+		dev_err(&pdev->dev, "atmel,ssc-controller node missing\n");
+		ret = -EINVAL;
+		goto out;
+	}
+	sam9x5_dai.cpu_of_node = cpu_np;
+	sam9x5_dai.platform_of_node = cpu_np;
+
+	sam9x5_priv.ssc_id = of_alias_get_id(cpu_np, "ssc");
+
+	ret = atmel_ssc_set_audio(sam9x5_priv.ssc_id);
+	if (ret != 0) {
+		dev_err(&pdev->dev,
+			"ASoC: Failed to set SSC %d for audio: %d\n",
+			ret, sam9x5_priv.ssc_id);
+		goto out;
+	}
+
+	of_node_put(codec_np);
+	of_node_put(cpu_np);
+
+	ret = snd_soc_register_card(&snd_soc_sam9x5);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"ASoC: Platform device allocation failed\n");
+		goto out_put_audio;
+	}
+
+	platform_set_drvdata(pdev, &snd_soc_sam9x5);
+
+	dev_dbg(&pdev->dev, "ASoC: %s ok\n", __func__);
+
+	return ret;
+
+out_put_audio:
+	atmel_ssc_put_audio(sam9x5_priv.ssc_id);
+out:
+	return ret;
+}
+
+static int sam9x5_wm8731_driver_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+	struct sam9x5_drvdata *sam9x5_priv = card->drvdata;
+
+	snd_soc_unregister_card(card);
+	atmel_ssc_put_audio(sam9x5_priv->ssc_id);
+
+	return 0;
+}
+
+static const struct of_device_id sam9x5_wm8731_of_match[] = {
+	{ .compatible = "atmel,sam9x5-wm8731-audio", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, sam9x5_wm8731_of_match);
+
+static struct platform_driver sam9x5_wm8731_driver = {
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(sam9x5_wm8731_of_match),
+	},
+	.probe = sam9x5_wm8731_driver_probe,
+	.remove = sam9x5_wm8731_driver_remove,
+};
+module_platform_driver(sam9x5_wm8731_driver);
+
+/* Module information */
+MODULE_AUTHOR("Nicolas Ferre <nicolas.ferre@atmel.com>");
+MODULE_AUTHOR("Richard Genoud <richard.genoud@gmail.com>");
+MODULE_DESCRIPTION("ALSA SoC machine driver for AT91SAM9x5 - WM8731");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.7.10.4

