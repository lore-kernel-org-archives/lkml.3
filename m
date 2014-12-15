Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaLOCOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:14:38 -0500
Received: from regular2.263xmail.com ([211.157.152.3]:57941 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaLOCO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:14:28 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: ykk@rock-chips.com
X-SENDER-IP: 104.167.231.7
X-LOGIN-NAME: ykk@rock-chips.com
X-UNIQUE-TAG: <5d49df41fe2e2dea888133f0f1dd3213>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Yakir Yang <ykk@rock-chips.com>
To: Yakir Yang <ykk@rock-chips.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Daniel Kurtz <djkurtz@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Xu Jianqun <jay.xu@rock-chips.com>,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Brian Austin <brian.austin@cirrus.com>,
        Bard Liao <bardliao@realtek.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org
Subject: [PATCH 4/6] ASoC: rockchip-hdmi-audio: add sound driver for hdmi audio
Date: Mon, 15 Dec 2014 10:11:32 +0800
Message-Id: <1418609494-15820-5-git-send-email-ykk@rock-chips.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a sound driver that combines rockchip-i2s cpu_dai and dw-hdmi-codec
as codec_dai to provide hdmi audio output on rk3288 platforms.

Signed-off-by: Yakir Yang <ykk@rock-chips.com>
---

 sound/soc/rockchip/Kconfig               |   9 ++
 sound/soc/rockchip/Makefile              |   2 +
 sound/soc/rockchip/rockchip_hdmi_audio.c | 208 +++++++++++++++++++++++++++++++
 3 files changed, 219 insertions(+)
 create mode 100644 sound/soc/rockchip/rockchip_hdmi_audio.c

diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
index e181826..ed2b7f0 100644
--- a/sound/soc/rockchip/Kconfig
+++ b/sound/soc/rockchip/Kconfig
@@ -14,3 +14,12 @@ config SND_SOC_ROCKCHIP_I2S
 	  Say Y or M if you want to add support for I2S driver for
 	  Rockchip I2S device. The device supports upto maximum of
 	  8 channels each for play and record.
+
+config SND_SOC_ROCKCHIP_HDMI_AUDIO
+	tristate "ASoC support for Rockchip HDMI audio"
+	depends on SND_SOC_ROCKCHIP
+	select SND_SOC_ROCKCHIP_I2S
+	select SND_SOC_DW_HDMI_AUDIO
+	help
+	  Say Y or M here if you want to add support for SoC audio on Rockchip
+	  HDMI, such as rk3288 hdmi.
diff --git a/sound/soc/rockchip/Makefile b/sound/soc/rockchip/Makefile
index b921909..b9185b3 100644
--- a/sound/soc/rockchip/Makefile
+++ b/sound/soc/rockchip/Makefile
@@ -1,4 +1,6 @@
 # ROCKCHIP Platform Support
 snd-soc-i2s-objs := rockchip_i2s.o
+snd-soc-rockchip-hdmi-audio-objs := rockchip_hdmi_audio.o
 
 obj-$(CONFIG_SND_SOC_ROCKCHIP_I2S) += snd-soc-i2s.o
+obj-$(CONFIG_SND_SOC_ROCKCHIP_HDMI_AUDIO) += snd-soc-rockchip-hdmi-audio.o
diff --git a/sound/soc/rockchip/rockchip_hdmi_audio.c b/sound/soc/rockchip/rockchip_hdmi_audio.c
new file mode 100644
index 0000000..a1a9c75
--- /dev/null
+++ b/sound/soc/rockchip/rockchip_hdmi_audio.c
@@ -0,0 +1,208 @@
+/*
+ * rockchip-hdmi-card.c
+ *
+ * ROCKCHIP ALSA SoC DAI driver for HDMI audio on rockchip processors.
+ * Copyright (c) 2014, ROCKCHIP CORPORATION. All rights reserved.
+ * Authors: Yakir Yang <ykk@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.*
+ *
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <sound/soc.h>
+#include <sound/pcm.h>
+#include <sound/jack.h>
+#include <sound/core.h>
+#include <sound/pcm_params.h>
+
+#include "rockchip_i2s.h"
+#include "../codecs/dw-hdmi-audio.h"
+
+#define DRV_NAME "rockchip-hdmi-audio"
+
+struct hdmi_audio_private {
+	struct snd_soc_jack hdmi_jack;
+};
+
+static int rockchip_hdmi_audio_hw_params(struct snd_pcm_substream *substream,
+					struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
+	unsigned int dai_fmt = rtd->dai_link->dai_fmt;
+	int mclk, ret;
+
+	switch (params_rate(params)) {
+	case 8000:
+	case 16000:
+	case 24000:
+	case 32000:
+	case 48000:
+	case 64000:
+	case 96000:
+		mclk = 12288000;
+		break;
+	case 11025:
+	case 22050:
+	case 44100:
+	case 88200:
+		mclk = 11289600;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = snd_soc_dai_set_fmt(cpu_dai, dai_fmt);
+	if (ret < 0) {
+		dev_err(cpu_dai->dev, "failed to set cpu_dai fmt.\n");
+		return ret;
+	}
+
+	ret = snd_soc_dai_set_sysclk(cpu_dai, 0, mclk, SND_SOC_CLOCK_OUT);
+	if (ret < 0) {
+		dev_err(cpu_dai->dev, "failed to set cpu_dai sysclk.\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int hdmi_audio_dai_init(struct snd_soc_pcm_runtime *runtime)
+{
+	struct snd_soc_codec *codec = runtime->codec;
+	struct snd_soc_card *card = runtime->card;
+	struct hdmi_audio_private *drv = snd_soc_card_get_drvdata(card);
+
+	/* Enable headphone jack detection */
+	snd_soc_jack_new(codec, "HDMI Jack", SND_JACK_LINEOUT,
+			 &drv->hdmi_jack);
+
+	return dw_hdmi_jack_detect(codec, &drv->hdmi_jack);
+}
+
+static struct snd_soc_ops hdmi_audio_dai_ops = {
+	.hw_params = rockchip_hdmi_audio_hw_params,
+};
+
+static struct snd_soc_dai_link hdmi_audio_dai = {
+	.name = "RockchipHDMI",
+	.stream_name = "RockchipHDMI",
+	.init = hdmi_audio_dai_init,
+	.ops = &hdmi_audio_dai_ops,
+	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
+		   SND_SOC_DAIFMT_CBS_CFS,
+};
+
+static struct snd_soc_card rockchip_hdmi_audio_card = {
+	.name = "RockchipHDMI",
+	.owner = THIS_MODULE,
+	.dai_link = &hdmi_audio_dai,
+	.num_links = 1,
+};
+
+static int rockchip_hdmi_audio_probe(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = &rockchip_hdmi_audio_card;
+	struct device_node *np = pdev->dev.of_node;
+	struct hdmi_audio_private *drv;
+	int ret;
+
+	drv = devm_kzalloc(&pdev->dev, sizeof(*drv), GFP_KERNEL);
+	if (!drv)
+		return -ENOMEM;
+
+	card->dev = &pdev->dev;
+	platform_set_drvdata(pdev, &card);
+	snd_soc_card_set_drvdata(card, drv);
+
+	of_property_read_string(np, "codec-name", &hdmi_audio_dai.codec_name);
+	if (!hdmi_audio_dai.codec_name) {
+		dev_err(&pdev->dev, "Property 'codec-name' missing !\n");
+		goto free_priv_data;
+	}
+
+	of_property_read_string(np, "codec-dai-name",
+				&hdmi_audio_dai.codec_dai_name);
+	if (!hdmi_audio_dai.codec_dai_name) {
+		dev_err(&pdev->dev, "Property 'codec-dai-name' missing !\n");
+		goto free_codec_name;
+	}
+
+	hdmi_audio_dai.cpu_of_node = of_parse_phandle(np, "cpu-of-node", 0);
+	if (!hdmi_audio_dai.cpu_of_node) {
+		dev_err(&pdev->dev, "Property 'cpu-of-node' missing !\n");
+		goto free_codec_dai_name;
+	}
+
+	hdmi_audio_dai.platform_of_node = hdmi_audio_dai.cpu_of_node;
+
+	ret = snd_soc_register_card(card);
+	if (ret) {
+		dev_err(&pdev->dev, "register card failed (%d)\n", ret);
+		card->dev = NULL;
+		goto free_cpu_of_node;
+	}
+
+	dev_info(&pdev->dev, "hdmi audio init success.\n");
+
+	return 0;
+
+free_cpu_of_node:
+	hdmi_audio_dai.cpu_of_node = NULL;
+	hdmi_audio_dai.platform_of_node = NULL;
+free_codec_dai_name:
+	hdmi_audio_dai.codec_dai_name = NULL;
+free_codec_name:
+	hdmi_audio_dai.codec_name = NULL;
+free_priv_data:
+	platform_set_drvdata(pdev, NULL);
+	devm_kfree(&pdev->dev, drv);
+	card->dev = NULL;
+
+	return ret;
+}
+
+static int rockchip_hdmi_audio_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
+	platform_set_drvdata(pdev, NULL);
+	card->dev = NULL;
+
+	return 0;
+}
+
+static const struct of_device_id rockchip_hdmi_audio_of_match[] = {
+	{ .compatible = "rockchip,rk3288-hdmi-audio", },
+	{},
+};
+
+static struct platform_driver rockchip_hdmi_audio_driver = {
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = rockchip_hdmi_audio_of_match,
+	},
+	.probe = rockchip_hdmi_audio_probe,
+	.remove = rockchip_hdmi_audio_remove,
+};
+module_platform_driver(rockchip_hdmi_audio_driver);
+
+MODULE_AUTHOR("Yakir Yang <ykk@rock-chips.com>");
+MODULE_DESCRIPTION("Rockchip HDMI Audio ASoC Interface");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
+MODULE_DEVICE_TABLE(of, rockchip_hdmi_audio_of_match);
-- 
2.1.2


