Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaLAP5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:57:54 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:48305 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbaLAP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:57:53 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <alsa-devel@alsa-project.org>
CC: <pebolle@tiscali.nl>, <slapin@ossfans.org>, Bo Shen <voice.shen@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ASoC: snd-soc-afeb9260: delete driver as board has just been removed
Date: Mon, 1 Dec 2014 16:57:52 +0100
Message-ID: <1417449472-13498-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the removal of all AT91 !DT boards, we removed the AFEB9260. This driver
is !DT and was only used by this board, so we delete it as well.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 sound/soc/atmel/Makefile           |   1 -
 sound/soc/atmel/snd-soc-afeb9260.c | 151 -------------------------------------
 2 files changed, 152 deletions(-)
 delete mode 100644 sound/soc/atmel/snd-soc-afeb9260.c

diff --git a/sound/soc/atmel/Makefile b/sound/soc/atmel/Makefile
index 5baabc8bde3a..466a821da98c 100644
--- a/sound/soc/atmel/Makefile
+++ b/sound/soc/atmel/Makefile
@@ -17,4 +17,3 @@ snd-soc-sam9x5-wm8731-objs := sam9x5_wm8731.o
 obj-$(CONFIG_SND_AT91_SOC_SAM9G20_WM8731) += snd-soc-sam9g20-wm8731.o
 obj-$(CONFIG_SND_ATMEL_SOC_WM8904) += snd-atmel-soc-wm8904.o
 obj-$(CONFIG_SND_AT91_SOC_SAM9X5_WM8731) += snd-soc-sam9x5-wm8731.o
-obj-$(CONFIG_SND_AT91_SOC_AFEB9260) += snd-soc-afeb9260.o
diff --git a/sound/soc/atmel/snd-soc-afeb9260.c b/sound/soc/atmel/snd-soc-afeb9260.c
deleted file mode 100644
index 9579799ace54..000000000000
--- a/sound/soc/atmel/snd-soc-afeb9260.c
+++ /dev/null
@@ -1,151 +0,0 @@
-/*
- * afeb9260.c  --  SoC audio for AFEB9260
- *
- * Copyright (C) 2009 Sergey Lapin <slapin@ossfans.org>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/kernel.h>
-#include <linux/clk.h>
-#include <linux/platform_device.h>
-
-#include <linux/atmel-ssc.h>
-#include <sound/core.h>
-#include <sound/pcm.h>
-#include <sound/pcm_params.h>
-#include <sound/soc.h>
-
-#include <asm/mach-types.h>
-#include <mach/hardware.h>
-#include <linux/gpio.h>
-
-#include "../codecs/tlv320aic23.h"
-#include "atmel-pcm.h"
-#include "atmel_ssc_dai.h"
-
-#define CODEC_CLOCK 	12000000
-
-static int afeb9260_hw_params(struct snd_pcm_substream *substream,
-			 struct snd_pcm_hw_params *params)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *codec_dai = rtd->codec_dai;
-	int err;
-
-	/* Set the codec system clock for DAC and ADC */
-	err =
-	    snd_soc_dai_set_sysclk(codec_dai, 0, CODEC_CLOCK, SND_SOC_CLOCK_IN);
-
-	if (err < 0) {
-		printk(KERN_ERR "can't set codec system clock\n");
-		return err;
-	}
-
-	return err;
-}
-
-static struct snd_soc_ops afeb9260_ops = {
-	.hw_params = afeb9260_hw_params,
-};
-
-static const struct snd_soc_dapm_widget tlv320aic23_dapm_widgets[] = {
-	SND_SOC_DAPM_HP("Headphone Jack", NULL),
-	SND_SOC_DAPM_LINE("Line In", NULL),
-	SND_SOC_DAPM_MIC("Mic Jack", NULL),
-};
-
-static const struct snd_soc_dapm_route afeb9260_audio_map[] = {
-	{"Headphone Jack", NULL, "LHPOUT"},
-	{"Headphone Jack", NULL, "RHPOUT"},
-
-	{"LLINEIN", NULL, "Line In"},
-	{"RLINEIN", NULL, "Line In"},
-
-	{"MICIN", NULL, "Mic Jack"},
-};
-
-
-/* Digital audio interface glue - connects codec <--> CPU */
-static struct snd_soc_dai_link afeb9260_dai = {
-	.name = "TLV320AIC23",
-	.stream_name = "AIC23",
-	.cpu_dai_name = "atmel-ssc-dai.0",
-	.codec_dai_name = "tlv320aic23-hifi",
-	.platform_name = "atmel_pcm-audio",
-	.codec_name = "tlv320aic23-codec.0-001a",
-	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_IF |
-		   SND_SOC_DAIFMT_CBM_CFM,
-	.ops = &afeb9260_ops,
-};
-
-/* Audio machine driver */
-static struct snd_soc_card snd_soc_machine_afeb9260 = {
-	.name = "AFEB9260",
-	.owner = THIS_MODULE,
-	.dai_link = &afeb9260_dai,
-	.num_links = 1,
-
-	.dapm_widgets = tlv320aic23_dapm_widgets,
-	.num_dapm_widgets = ARRAY_SIZE(tlv320aic23_dapm_widgets),
-	.dapm_routes = afeb9260_audio_map,
-	.num_dapm_routes = ARRAY_SIZE(afeb9260_audio_map),
-};
-
-static struct platform_device *afeb9260_snd_device;
-
-static int __init afeb9260_soc_init(void)
-{
-	int err;
-	struct device *dev;
-
-	if (!(machine_is_afeb9260()))
-		return -ENODEV;
-
-
-	afeb9260_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!afeb9260_snd_device) {
-		printk(KERN_ERR "ASoC: Platform device allocation failed\n");
-		return -ENOMEM;
-	}
-
-	platform_set_drvdata(afeb9260_snd_device, &snd_soc_machine_afeb9260);
-	err = platform_device_add(afeb9260_snd_device);
-	if (err)
-		goto err1;
-
-	dev = &afeb9260_snd_device->dev;
-
-	return 0;
-err1:
-	platform_device_put(afeb9260_snd_device);
-	return err;
-}
-
-static void __exit afeb9260_soc_exit(void)
-{
-	platform_device_unregister(afeb9260_snd_device);
-}
-
-module_init(afeb9260_soc_init);
-module_exit(afeb9260_soc_exit);
-
-MODULE_AUTHOR("Sergey Lapin <slapin@ossfans.org>");
-MODULE_DESCRIPTION("ALSA SoC for AFEB9260");
-MODULE_LICENSE("GPL");
-
-- 
2.1.3

