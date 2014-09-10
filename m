Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaIJOUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:20:38 -0400
Received: from s250.sam-solutions.net ([217.21.49.219]:35915 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaIJOUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:20:34 -0400
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <perex@perex.cz>, <tiwai@suse.de>,
        <timur@tabi.org>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <grant.likely@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <alsa-devel@alsa-project.org>,
        Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Subject: [PATCH 2/5] ASoC: fsl: add imx-tlv320aic3x machine driver
Date: Wed, 10 Sep 2014 16:46:46 +0300
Message-ID: <1410356809-26179-3-git-send-email-d.lavnikevich@sam-solutions.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>
References: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is driver for i.MX6 boards with tlv320aic3x audio codecs.

Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
---
 .../bindings/sound/fsl,imx-audio-tlv320aic3x.txt   |  27 ++++
 sound/soc/fsl/Kconfig                              |  13 ++
 sound/soc/fsl/Makefile                             |   2 +
 sound/soc/fsl/imx-tlv320aic3x.c                    | 177 +++++++++++++++++++++
 4 files changed, 219 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/fsl,imx-audio-tlv320aic3x.txt
 create mode 100644 sound/soc/fsl/imx-tlv320aic3x.c

diff --git a/Documentation/devicetree/bindings/sound/fsl,imx-audio-tlv320aic3x.txt b/Documentation/devicetree/bindings/sound/fsl,imx-audio-tlv320aic3x.txt
new file mode 100644
index 000000000000..9e6c4443f40f
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/fsl,imx-audio-tlv320aic3x.txt
@@ -0,0 +1,27 @@
+Audio complex for i.MX6 boards with tlv320aic3x audio codecs.
+
+Required properties:
+- compatible : "fsl,imx-audio-tlv320aic3x"
+- model : The user-visible name of this sound complex.
+- ssi-controller : The phandle of the SSI controller.
+- mux-int-port : The internal port of the i.MX audio muxer (AUDMUX).
+- mux-ext-port : The external port of the i.MX audio muxer.
+
+Note: The AUDMUX port numbering should start at 1, which is consistent with
+hardware manual.
+
+Example:
+
+sound {
+	compatible = "fsl,imx-audio-tlv320aic3x";
+	model = "imx6q-phyflex-tlv320aic3007";
+	ssi-controller = <&ssi2>;
+	audio-codec = <&codec>;
+	audio-routing =
+		"Line Out", "LLOUT",
+		"Line Out", "RLOUT",
+		"Headphone Jack", "HPLOUT",
+		"Headphone Jack", "HPROUT";
+	mux-int-port = <2>;
+	mux-ext-port = <5>;
+};
diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index f3012b645b51..b40884c244bd 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -268,6 +268,19 @@ config SND_SOC_IMX_MC13783
 	select SND_SOC_MC13783
 	select SND_SOC_IMX_PCM_DMA
 
+config SND_SOC_IMX_TLV320AIC3X
+	tristate "SoC Audio support for i.MX6 boards with tlv320aic3x audio codec"
+	depends on OF && I2C
+	select SND_SOC_TLV320AIC3X
+	select SND_SOC_IMX_PCM_DMA
+	select SND_SOC_IMX_AUDMUX
+	select SND_SOC_FSL_SSI
+	help
+	  SoC audio for i.MX6 boards with codec TLV320AIC3x attached over
+	  SSI interface.
+	  Say Y if you want to add support for SoC audio on phyFLEX-i.MX6
+	  boards.
+
 endif # SND_IMX_SOC
 
 endmenu
diff --git a/sound/soc/fsl/Makefile b/sound/soc/fsl/Makefile
index 9ff59267eac9..83882bcefb0b 100644
--- a/sound/soc/fsl/Makefile
+++ b/sound/soc/fsl/Makefile
@@ -54,6 +54,7 @@ snd-soc-imx-sgtl5000-objs := imx-sgtl5000.o
 snd-soc-imx-wm8962-objs := imx-wm8962.o
 snd-soc-imx-spdif-objs := imx-spdif.o
 snd-soc-imx-mc13783-objs := imx-mc13783.o
+snd-soc-imx-tlv320aic3x-objs := imx-tlv320aic3x.o
 
 obj-$(CONFIG_SND_SOC_EUKREA_TLV320) += snd-soc-eukrea-tlv320.o
 obj-$(CONFIG_SND_SOC_PHYCORE_AC97) += snd-soc-phycore-ac97.o
@@ -63,3 +64,4 @@ obj-$(CONFIG_SND_SOC_IMX_SGTL5000) += snd-soc-imx-sgtl5000.o
 obj-$(CONFIG_SND_SOC_IMX_WM8962) += snd-soc-imx-wm8962.o
 obj-$(CONFIG_SND_SOC_IMX_SPDIF) += snd-soc-imx-spdif.o
 obj-$(CONFIG_SND_SOC_IMX_MC13783) += snd-soc-imx-mc13783.o
+obj-$(CONFIG_SND_SOC_IMX_TLV320AIC3X) += snd-soc-imx-tlv320aic3x.o
diff --git a/sound/soc/fsl/imx-tlv320aic3x.c b/sound/soc/fsl/imx-tlv320aic3x.c
new file mode 100644
index 000000000000..f38c68911953
--- /dev/null
+++ b/sound/soc/fsl/imx-tlv320aic3x.c
@@ -0,0 +1,177 @@
+/*
+ * Copyright 2014 Dmitry Lavnikevich,
+ * SaM Solutions <d.lavnikevich@sam-solutions.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+
+#include "../codecs/tlv320aic3x.h"
+#include "imx-audmux.h"
+#include "imx-ssi.h"
+
+#define CODEC_CLOCK 19200000
+
+
+/* machine dapm widgets */
+static const struct snd_soc_dapm_widget aic3x_dapm_widgets[] = {
+	SND_SOC_DAPM_LINE("Line Out", NULL),
+	SND_SOC_DAPM_LINE("Speaker", NULL),
+	SND_SOC_DAPM_HP("Headphone Jack", NULL),
+	SND_SOC_DAPM_MIC("Mic Jack", NULL),
+	SND_SOC_DAPM_LINE("Line In", NULL),
+};
+
+static int imx_audmux_config(int int_port, int ext_port)
+{
+	unsigned int ptcr, pdcr;
+
+	int_port--;
+	ext_port--;
+	ptcr = IMX_AUDMUX_V2_PTCR_TFSDIR |
+		IMX_AUDMUX_V2_PTCR_TFSEL(ext_port) |
+		IMX_AUDMUX_V2_PTCR_TCLKDIR |
+		IMX_AUDMUX_V2_PTCR_TCSEL(ext_port);
+	pdcr = IMX_AUDMUX_V2_PDCR_RXDSEL(ext_port);
+	imx_audmux_v2_configure_port(int_port, ptcr, pdcr);
+
+	ptcr = 0;
+	pdcr = IMX_AUDMUX_V2_PDCR_RXDSEL(int_port);
+	imx_audmux_v2_configure_port(ext_port, ptcr, pdcr);
+
+	return 0;
+}
+
+/* Logic for a aic3x as connected on a imx */
+static int imx_aic3x_init(struct snd_soc_pcm_runtime *rtd)
+{
+	int ret;
+
+	ret = snd_soc_dai_set_sysclk(rtd->codec_dai, 0, CODEC_CLOCK,
+		SND_SOC_CLOCK_IN);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static struct snd_soc_dai_link imx_tlv320_dai = {
+	.name = "HiFi",
+	.stream_name = "HiFi",
+	.codec_dai_name = "tlv320aic3x-hifi",
+	.init = &imx_aic3x_init,
+	.dai_fmt = SND_SOC_DAIFMT_I2S |
+		SND_SOC_DAIFMT_NB_NF |
+		SND_SOC_DAIFMT_CBM_CFM,
+};
+
+static struct snd_soc_card imx_tlv320_card = {
+	.num_links = 1,
+	.owner = THIS_MODULE,
+	.dai_link = &imx_tlv320_dai,
+	.dapm_widgets = aic3x_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(aic3x_dapm_widgets),
+};
+
+static int imx_tlv320_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device_node *ssi_np, *codec_np;
+	struct platform_device *ssi_pdev;
+	struct i2c_client *codec_dev;
+	int int_port, ext_port;
+	int ret = 0;
+
+	ret = of_property_read_u32(np, "mux-int-port", &int_port);
+	if (ret) {
+		dev_err(&pdev->dev, "mux-int-port missing or invalid\n");
+		return ret;
+	}
+	ret = of_property_read_u32(np, "mux-ext-port", &ext_port);
+	if (ret) {
+		dev_err(&pdev->dev, "mux-ext-port missing or invalid\n");
+		return ret;
+	}
+
+	imx_audmux_config(int_port, ext_port);
+
+	ssi_np = of_parse_phandle(pdev->dev.of_node, "ssi-controller", 0);
+	codec_np = of_parse_phandle(pdev->dev.of_node, "audio-codec", 0);
+	if (!ssi_np || !codec_np) {
+		dev_err(&pdev->dev, "phandle missing or invalid\n");
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	ssi_pdev = of_find_device_by_node(ssi_np);
+	if (!ssi_pdev) {
+		dev_err(&pdev->dev, "failed to find SSI platform device\n");
+		ret = -EPROBE_DEFER;
+		goto fail;
+	}
+	codec_dev = of_find_i2c_device_by_node(codec_np);
+	if (!codec_dev) {
+		dev_err(&pdev->dev, "failed to find codec platform device\n");
+		return -EPROBE_DEFER;
+	}
+
+	imx_tlv320_dai.codec_of_node = codec_np;
+	imx_tlv320_dai.cpu_of_node = ssi_np;
+	imx_tlv320_dai.platform_of_node = ssi_np;
+
+	imx_tlv320_card.dev = &pdev->dev;
+	ret = snd_soc_of_parse_card_name(&imx_tlv320_card, "model");
+	if (ret)
+		goto fail;
+	ret = snd_soc_of_parse_audio_routing(&imx_tlv320_card, "audio-routing");
+	if (ret)
+		goto fail;
+
+	platform_set_drvdata(pdev, &imx_tlv320_card);
+
+	ret = devm_snd_soc_register_card(&pdev->dev, &imx_tlv320_card);
+	if (ret) {
+		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", ret);
+		goto fail;
+	}
+
+	of_node_put(ssi_np);
+	of_node_put(codec_np);
+
+	return 0;
+
+fail:
+	if (ssi_np)
+		of_node_put(ssi_np);
+	if (codec_np)
+		of_node_put(codec_np);
+
+	return ret;
+}
+
+static const struct of_device_id imx_tlv320_dt_ids[] = {
+	{ .compatible = "fsl,imx-audio-tlv320aic3x", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, imx_tlv320_dt_ids);
+
+static struct platform_driver imx_tlv320_driver = {
+	.driver = {
+		.name = "tlv320aic3x",
+		.owner = THIS_MODULE,
+		.pm = &snd_soc_pm_ops,
+		.of_match_table = imx_tlv320_dt_ids,
+	},
+	.probe = imx_tlv320_probe,
+};
+module_platform_driver(imx_tlv320_driver);
+
+MODULE_AUTHOR("Lavnikevich Dmitry");
+MODULE_DESCRIPTION("TLV320AIC3X i.MX6 ASoC driver");
+MODULE_LICENSE("GPL");
-- 
2.1.0

