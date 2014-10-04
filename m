Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbaJDAQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:16:42 -0400
Received: from mout.perfora.net ([74.208.4.196]:65287 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099AbaJDAQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 20:16:39 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch, Marcel Ziswiler <marcel@ziswiler.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3 1/3] ASoC: tegra: add tegra sgtl5000 machine driver
Date: Sat,  4 Oct 2014 02:15:43 +0200
Message-Id: <74ea4fe20e653d2da555c8d7dd1478746bccd529.1412381377.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1412381377.git.marcel@ziswiler.com>
References: <cover.1412381377.git.marcel@ziswiler.com>
X-Provags-ID: V02:K0:UscxbsXHdSTFk0zaYWsxEs3LCX5E/MIh3A4IBFMdO8g
 4Er4US6S3pEKrxyeqLoO7YzAl6FKQtCf8DmZ/RnZyKxwQPePuk
 02Ya4/WC4Ml6KDlj6FT8s6g1WINSg3F4QPz7q0Co0w3QYoOf0v
 JSguJBc5FsnN/ya1OK1TNpQdUuQL2Bs7J/r4mJ89HWMi8DmYib
 sv5MSrw1uv2Toq2xyHKPJFunn7fJAOSfmZ0JwuDMBlslidHRwI
 vyJwafdiSX6F0O4hcRZFbjo0Ull/U0D4AdsjoNTpYSCSzE7Jth
 7VfWfIax4jRkYOfL4GggeQUqacra/RuWXwOYsbPsV4f5XmUQfk
 B4j611NvXxunfukXR89W5eeUpG/UDYns3CYJ/qwyFCobk12MMn
 7CgUVQLG4aVn5h1y7CvUBgTHtlW90oQK47TyIzVom2KSrZzHhY
 UIFO9
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This binding and driver describe/support playback to headphones, and
capture from line-in and microphone.

This driver is useful for the Toradex Apalis T30 and Colibri T30 modules.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
Changes in v3:
- Revert to not using simple-audio-card being incompatible with tegra.
- Rebased to for-next.

Changes in v2:
- Using simple-audio-card as suggested by Fabio.

 .../bindings/sound/nvidia,tegra-audio-sgtl5000.txt |  45 +++++
 sound/soc/tegra/Kconfig                            |  10 +
 sound/soc/tegra/Makefile                           |   2 +
 sound/soc/tegra/tegra_sgtl5000.c                   | 216 +++++++++++++++++++++
 4 files changed, 273 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/nvidia,tegra-audio-sgtl5000.txt
 create mode 100644 sound/soc/tegra/tegra_sgtl5000.c

diff --git a/Documentation/devicetree/bindings/sound/nvidia,tegra-audio-sgtl5000.txt b/Documentation/devicetree/bindings/sound/nvidia,tegra-audio-sgtl5000.txt
new file mode 100644
index 0000000..22f8499
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/nvidia,tegra-audio-sgtl5000.txt
@@ -0,0 +1,45 @@
+NVIDIA Tegra audio complex, with SGTL5000 CODEC
+
+Required properties:
+- compatible : "nvidia,tegra-audio-sgtl5000"
+- clocks : Must contain an entry for each entry in clock-names.
+  See ../clocks/clock-bindings.txt for details.
+- clock-names : Must include the following entries:
+  - pll_a
+  - pll_a_out0
+  - mclk (The Tegra cdev1/extern1 clock, which feeds the CODEC's mclk)
+- nvidia,model : The user-visible name of this sound complex.
+- nvidia,audio-routing : A list of the connections between audio components.
+  Each entry is a pair of strings, the first being the connection's sink,
+  the second being the connection's source. Valid names for sources and
+  sinks are the SGTL5000's pins (as documented in its binding), and the jacks
+  on the board:
+
+  * Headphones
+  * Line-in Jack
+  * Mic Jack
+
+- nvidia,i2s-controller : The phandle of the Tegra I2S controller that's
+  connected to the CODEC.
+- nvidia,audio-codec : The phandle of the SGTL5000 audio codec.
+
+Example:
+
+sound {
+	compatible = "toradex,tegra-audio-sgtl5000-apalis_t30",
+		     "nvidia,tegra-audio-sgtl5000";
+	nvidia,model = "Toradex Apalis T30";
+
+	nvidia,audio-routing =
+		"Headphone Jack", "HP_OUT",
+		"LINE_IN", "Line In Jack",
+		"MIC_IN", "Mic Jack";
+
+	nvidia,i2s-controller = <&tegra_i2s2>;
+	nvidia,audio-codec = <&sgtl5000>;
+
+	clocks = <&tegra_car TEGRA30_CLK_PLL_A>,
+		 <&tegra_car TEGRA30_CLK_PLL_A_OUT0>,
+		 <&tegra_car TEGRA30_CLK_EXTERN1>;
+	clock-names = "pll_a", "pll_a_out0", "mclk";
+};
diff --git a/sound/soc/tegra/Kconfig b/sound/soc/tegra/Kconfig
index 31198cf7..001dec8 100644
--- a/sound/soc/tegra/Kconfig
+++ b/sound/soc/tegra/Kconfig
@@ -128,3 +128,13 @@ config SND_SOC_TEGRA_MAX98090
 	help
 	  Say Y or M here if you want to add support for SoC audio on Tegra
 	  boards using the MAX98090 codec, such as Venice2.
+
+config SND_SOC_TEGRA_SGTL5000
+	tristate "SoC Audio support for Tegra boards using a SGTL5000 codec"
+	depends on SND_SOC_TEGRA && I2C && GPIOLIB
+	select SND_SOC_TEGRA20_I2S if ARCH_TEGRA_2x_SOC
+	select SND_SOC_TEGRA30_I2S if ARCH_TEGRA_3x_SOC
+	select SND_SOC_SGTL5000
+	help
+	  Say Y or M here if you want to add support for SoC audio on Tegra
+	  boards using the SGTL5000 codec, such as Apalis/Colibri T30.
diff --git a/sound/soc/tegra/Makefile b/sound/soc/tegra/Makefile
index 5ae588c..a0c70f8 100644
--- a/sound/soc/tegra/Makefile
+++ b/sound/soc/tegra/Makefile
@@ -25,6 +25,7 @@ snd-soc-tegra-wm9712-objs := tegra_wm9712.o
 snd-soc-tegra-trimslice-objs := trimslice.o
 snd-soc-tegra-alc5632-objs := tegra_alc5632.o
 snd-soc-tegra-max98090-objs := tegra_max98090.o
+snd-soc-tegra-sgtl5000-objs := tegra_sgtl5000.o
 
 obj-$(CONFIG_SND_SOC_TEGRA_RT5640) += snd-soc-tegra-rt5640.o
 obj-$(CONFIG_SND_SOC_TEGRA_WM8753) += snd-soc-tegra-wm8753.o
@@ -33,3 +34,4 @@ obj-$(CONFIG_SND_SOC_TEGRA_WM9712) += snd-soc-tegra-wm9712.o
 obj-$(CONFIG_SND_SOC_TEGRA_TRIMSLICE) += snd-soc-tegra-trimslice.o
 obj-$(CONFIG_SND_SOC_TEGRA_ALC5632) += snd-soc-tegra-alc5632.o
 obj-$(CONFIG_SND_SOC_TEGRA_MAX98090) += snd-soc-tegra-max98090.o
+obj-$(CONFIG_SND_SOC_TEGRA_SGTL5000) += snd-soc-tegra-sgtl5000.o
diff --git a/sound/soc/tegra/tegra_sgtl5000.c b/sound/soc/tegra/tegra_sgtl5000.c
new file mode 100644
index 0000000..881c299
--- /dev/null
+++ b/sound/soc/tegra/tegra_sgtl5000.c
@@ -0,0 +1,216 @@
+/*
+ * tegra_sgtl5000.c - Tegra machine ASoC driver for boards using SGTL5000 codec
+ *
+ * Author: Marcel Ziswiler <marcel@ziswiler.com>
+ *
+ * Based on code copyright/by:
+ *
+ * Copyright (C) 2010-2012 - NVIDIA, Inc.
+ * (c) 2009, 2010 Nvidia Graphics Pvt. Ltd.
+ * Copyright 2007 Wolfson Microelectronics PLC.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+
+#include <sound/core.h>
+#include <sound/jack.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+
+#include "../codecs/sgtl5000.h"
+
+#include "tegra_asoc_utils.h"
+
+#define DRV_NAME "tegra-snd-sgtl5000"
+
+struct tegra_sgtl5000 {
+	struct tegra_asoc_utils_data util_data;
+};
+
+static int tegra_sgtl5000_hw_params(struct snd_pcm_substream *substream,
+					struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	struct snd_soc_card *card = rtd->card;
+	struct tegra_sgtl5000 *machine = snd_soc_card_get_drvdata(card);
+	int srate, mclk;
+	int err;
+
+	srate = params_rate(params);
+	switch (srate) {
+	case 11025:
+	case 22050:
+	case 44100:
+	case 88200:
+		mclk = 11289600;
+		break;
+	default:
+		mclk = 12288000;
+		break;
+	}
+
+	err = tegra_asoc_utils_set_rate(&machine->util_data, srate, mclk);
+	if (err < 0) {
+		dev_err(card->dev, "Can't configure clocks\n");
+		return err;
+	}
+
+	err = snd_soc_dai_set_sysclk(codec_dai, SGTL5000_SYSCLK, mclk,
+				     SND_SOC_CLOCK_IN);
+	if (err < 0) {
+		dev_err(card->dev, "codec_dai clock not set\n");
+		return err;
+	}
+
+	return 0;
+}
+
+static struct snd_soc_ops tegra_sgtl5000_ops = {
+	.hw_params = tegra_sgtl5000_hw_params,
+};
+
+static const struct snd_soc_dapm_widget tegra_sgtl5000_dapm_widgets[] = {
+	SND_SOC_DAPM_HP("Headphone Jack", NULL),
+	SND_SOC_DAPM_LINE("Line In Jack", NULL),
+	SND_SOC_DAPM_MIC("Mic Jack", NULL),
+};
+
+static struct snd_soc_dai_link tegra_sgtl5000_dai = {
+	.name = "sgtl5000",
+	.stream_name = "HiFi",
+	.codec_dai_name = "sgtl5000",
+	.ops = &tegra_sgtl5000_ops,
+	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
+			SND_SOC_DAIFMT_CBS_CFS,
+};
+
+static struct snd_soc_card snd_soc_tegra_sgtl5000 = {
+	.name = "tegra-sgtl5000",
+	.owner = THIS_MODULE,
+	.dai_link = &tegra_sgtl5000_dai,
+	.num_links = 1,
+	.dapm_widgets = tegra_sgtl5000_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(tegra_sgtl5000_dapm_widgets),
+	.fully_routed = true,
+};
+
+static int tegra_sgtl5000_driver_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct snd_soc_card *card = &snd_soc_tegra_sgtl5000;
+	struct tegra_sgtl5000 *machine;
+	int ret;
+
+	machine = devm_kzalloc(&pdev->dev, sizeof(struct tegra_sgtl5000),
+			       GFP_KERNEL);
+	if (!machine) {
+		dev_err(&pdev->dev, "Can't allocate tegra_sgtl5000 struct\n");
+		return -ENOMEM;
+	}
+
+	card->dev = &pdev->dev;
+	platform_set_drvdata(pdev, card);
+	snd_soc_card_set_drvdata(card, machine);
+
+	ret = snd_soc_of_parse_card_name(card, "nvidia,model");
+	if (ret)
+		goto err;
+
+	ret = snd_soc_of_parse_audio_routing(card, "nvidia,audio-routing");
+	if (ret)
+		goto err;
+
+	tegra_sgtl5000_dai.codec_of_node = of_parse_phandle(np,
+			"nvidia,audio-codec", 0);
+	if (!tegra_sgtl5000_dai.codec_of_node) {
+		dev_err(&pdev->dev,
+			"Property 'nvidia,audio-codec' missing or invalid\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	tegra_sgtl5000_dai.cpu_of_node = of_parse_phandle(np,
+			"nvidia,i2s-controller", 0);
+	if (!tegra_sgtl5000_dai.cpu_of_node) {
+		dev_err(&pdev->dev,
+			"Property 'nvidia,i2s-controller' missing/invalid\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	tegra_sgtl5000_dai.platform_of_node = tegra_sgtl5000_dai.cpu_of_node;
+
+	ret = tegra_asoc_utils_init(&machine->util_data, &pdev->dev);
+	if (ret)
+		goto err;
+
+	ret = snd_soc_register_card(card);
+	if (ret) {
+		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n",
+			ret);
+		goto err_fini_utils;
+	}
+
+	return 0;
+
+err_fini_utils:
+	tegra_asoc_utils_fini(&machine->util_data);
+err:
+	return ret;
+}
+
+static int tegra_sgtl5000_driver_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+	struct tegra_sgtl5000 *machine = snd_soc_card_get_drvdata(card);
+
+	snd_soc_unregister_card(card);
+
+	tegra_asoc_utils_fini(&machine->util_data);
+
+	return 0;
+}
+
+static const struct of_device_id tegra_sgtl5000_of_match[] = {
+	{ .compatible = "nvidia,tegra-audio-sgtl5000", },
+	{ /* sentinel */ },
+};
+
+static struct platform_driver tegra_sgtl5000_driver = {
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.pm = &snd_soc_pm_ops,
+		.of_match_table = tegra_sgtl5000_of_match,
+	},
+	.probe = tegra_sgtl5000_driver_probe,
+	.remove = tegra_sgtl5000_driver_remove,
+};
+module_platform_driver(tegra_sgtl5000_driver);
+
+MODULE_AUTHOR("Marcel Ziswiler <marcel@ziswiler.com>");
+MODULE_DESCRIPTION("Tegra SGTL5000 machine ASoC driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRV_NAME);
+MODULE_DEVICE_TABLE(of, tegra_sgtl5000_of_match);
-- 
1.9.3

