Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3GIO0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:26:08 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39083 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab3GIOZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:25:59 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH v4 1/7] sound: sam9x5_wm8731: machine driver for at91sam9x5 wm8731 boards
Date: Tue,  9 Jul 2013 16:25:27 +0200
Message-Id: <1373379933-32749-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373379933-32749-1-git-send-email-richard.genoud@gmail.com>
References: <1373372929-17800-1-git-send-email-richard.genoud@gmail.com>
 <1373379933-32749-1-git-send-email-richard.genoud@gmail.com>
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
 sound/soc/atmel/Kconfig         |   10 ++
 sound/soc/atmel/Makefile        |    2 +
 sound/soc/atmel/sam9x5_wm8731.c |  238 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 250 insertions(+)
 create mode 100644 sound/soc/atmel/sam9x5_wm8731.c

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
index 0000000..c56e36b
--- /dev/null
+++ b/sound/soc/atmel/sam9x5_wm8731.c
@@ -0,0 +1,238 @@
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
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/timer.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+
+#include <linux/atmel-ssc.h>
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+
+#include <asm/mach-types.h>
+#include <mach/hardware.h>
+#include <mach/gpio.h>
+
+#include "../codecs/wm8731.h"
+#include "atmel-pcm.h"
+#include "atmel_ssc_dai.h"
+
+#define MCLK_RATE 12288000
+
+#define DRV_NAME "sam9x5-snd-wm8731"
+
+/*
+ * Authorized rates are:
+ * Rate = MCLK_RATE / (n * 2)
+ * Where n is in [1..4095]
+ * (cf register SSC_CMR)
+ */
+static unsigned int rates[] = {
+	8000,
+	16000,
+	32000,
+	48000,
+	64000,
+	96000,
+};
+
+static struct snd_pcm_hw_constraint_list hw_rates = {
+	.count = ARRAY_SIZE(rates),
+	.list = rates,
+};
+
+/*
+ * Logic for a wm8731 as connected on a at91sam9x5 based board.
+ */
+static int at91sam9x5ek_wm8731_init(struct snd_soc_pcm_runtime *rtd)
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
+static int sam9x5ek_wm8731_startup(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+
+	runtime->hw.rate_min = hw_rates.list[0];
+	runtime->hw.rate_max = hw_rates.list[hw_rates.count - 1];
+	runtime->hw.rates = SNDRV_PCM_RATE_KNOT;
+
+	return snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_RATE,
+					  &hw_rates);
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
+static const struct snd_soc_dapm_widget at91sam9x5ek_dapm_widgets[] = {
+	SND_SOC_DAPM_HP("Headphone Jack", NULL),
+	SND_SOC_DAPM_LINE("Line In Jack", NULL),
+};
+
+static struct snd_soc_ops sam9x5ek_wm8731_ops = {
+	.startup = sam9x5ek_wm8731_startup,
+};
+
+static struct snd_soc_dai_link at91sam9x5ek_dai = {
+	.name = "WM8731",
+	.stream_name = "WM8731 PCM",
+	.codec_dai_name = "wm8731-hifi",
+	.init = at91sam9x5ek_wm8731_init,
+	.ops = &sam9x5ek_wm8731_ops,
+};
+
+static struct snd_soc_card snd_soc_at91sam9x5ek = {
+	.owner = THIS_MODULE,
+	.dai_link = &at91sam9x5ek_dai,
+	.num_links = 1,
+	.dapm_widgets = at91sam9x5ek_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(at91sam9x5ek_dapm_widgets),
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
+	ret = atmel_ssc_set_audio(0);
+	if (ret != 0) {
+		dev_err(&pdev->dev,
+			"ASoC: Failed to set SSC 0 for audio: %d\n", ret);
+		return ret;
+	}
+
+	snd_soc_at91sam9x5ek.dev = &pdev->dev;
+
+	ret = snd_soc_of_parse_card_name(&snd_soc_at91sam9x5ek, "atmel,model");
+	if (ret)
+		goto out;
+
+	ret = snd_soc_of_parse_audio_routing(&snd_soc_at91sam9x5ek,
+					     "atmel,audio-routing");
+	if (ret)
+		goto out;
+
+	codec_np = of_parse_phandle(np, "atmel,audio-codec", 0);
+	if (!codec_np) {
+		dev_err(&pdev->dev, "codec info missing\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	at91sam9x5ek_dai.codec_of_node = codec_np;
+
+	cpu_np = of_parse_phandle(np, "atmel,ssc-controller", 0);
+	if (!cpu_np) {
+		dev_err(&pdev->dev, "ssc controller node missing\n");
+		ret = -EINVAL;
+		goto out;
+	}
+	at91sam9x5ek_dai.cpu_of_node = cpu_np;
+	at91sam9x5ek_dai.platform_of_node = cpu_np;
+
+	of_node_put(codec_np);
+	of_node_put(cpu_np);
+
+	at91sam9x5ek_dai.dai_fmt = snd_soc_of_parse_daifmt(np, "atmel,");
+
+	ret = snd_soc_register_card(&snd_soc_at91sam9x5ek);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"ASoC: Platform device allocation failed\n");
+		goto out;
+	}
+
+	platform_set_drvdata(pdev, &snd_soc_at91sam9x5ek);
+
+	dev_dbg(&pdev->dev, "ASoC: %s ok\n", __func__);
+
+	return ret;
+
+out:
+	atmel_ssc_put_audio(0);
+	return ret;
+}
+
+static int sam9x5_wm8731_driver_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
+	atmel_ssc_put_audio(0);
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

