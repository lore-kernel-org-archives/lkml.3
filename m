Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3GTR0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:26:36 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:47863 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3GTR0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:26:34 -0400
Date: Sat, 20 Jul 2013 19:25:54 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH] ASoC: generic: add simple card with devicetree support
Message-ID: <20130720192554.79b7061b@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This generic simple card driver uses DT values to instanciate an audio
system in which the real work is done by the subdrivers (audio
controller, audio codec and pcm/dma controller).

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 Documentation/devicetree/bindings/sound/simple-dt-card.txt |  18 ++++
 sound/soc/generic/Kconfig                                 |   7 ++
 sound/soc/generic/Makefile                                |   2 +
 sound/soc/generic/simple-dt-card.c                        | 137 ++++++++++++++++++++++++
 4 files changed, 163 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/simple-dt-card.txt b/Documentation/devicetree/bindings/sound/simple-dt-card.txt
new file mode 100644
index 0000000..45f41cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/simple-dt-card.txt
@@ -0,0 +1,18 @@
+Device-Tree bindings for simple DT audio card
+
+Required properties:
+  - compatible: should be "linux,simple-dt-audio".
+  - audio-controller: phandle of the audio controller
+  - audio-codec: phandle of the audio codec
+  - platform-pcm-dma: phandle of the PCM/DMA controller
+  - codec-dai-name: name of the codec dai
+
+Example node:
+
+	sound {
+		compatible = "linux,simple-dt-audio";
+		audio-controller = <&i2s1>;
+		audio-codec = <&spdif>;
+		platform-pcm-dma = <&pcm>;
+		codec-dai-name = "dit-hifi";
+	};
diff --git a/sound/soc/generic/Kconfig b/sound/soc/generic/Kconfig
index 610f612..e593224 100644
--- a/sound/soc/generic/Kconfig
+++ b/sound/soc/generic/Kconfig
@@ -2,3 +2,10 @@ config SND_SIMPLE_CARD
 	tristate "ASoC Simple sound card support"
 	help
 	  This option enables generic simple sound card support
+
+config SND_SIMPLE_DT_CARD
+	tristate "ASoC Simple sound card support (Flattened Device Tree)"
+	depends on OF
+	help
+	  This option enables generic simple sound card support
+	  using flattened device tree.
diff --git a/sound/soc/generic/Makefile b/sound/soc/generic/Makefile
index 9c3b246..65ddd3e 100644
--- a/sound/soc/generic/Makefile
+++ b/sound/soc/generic/Makefile
@@ -1,3 +1,5 @@
 snd-soc-simple-card-objs	:= simple-card.o
+snd-soc-simple-dt-card-objs	:= simple-dt-card.o
 
 obj-$(CONFIG_SND_SIMPLE_CARD)	+= snd-soc-simple-card.o
+obj-$(CONFIG_SND_SIMPLE_DT_CARD) += snd-soc-simple-dt-card.o
diff --git a/sound/soc/generic/simple-dt-card.c b/sound/soc/generic/simple-dt-card.c
new file mode 100644
index 0000000..d373d68
--- /dev/null
+++ b/sound/soc/generic/simple-dt-card.c
@@ -0,0 +1,137 @@
+/*
+ * Simple DT defined sound card support
+ *
+ * Copyright (C) 2013 Jean-Francois Moine <moinejf@free.fr>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <sound/soc.h>
+#include <linux/of.h>
+
+static int simple_dt_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+	struct snd_soc_dai_link *link;
+
+	snd_soc_unregister_card(card);
+	link = card->dai_link;
+	if (link) {
+		of_node_put((struct device_node *) link->platform_of_node);
+		of_node_put((struct device_node *) link->codec_of_node);
+		of_node_put((struct device_node *) link->cpu_of_node);
+		kfree(link);
+	}
+	kfree(card);
+	return 0;
+}
+
+static int simple_dt_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct snd_soc_card *card;
+	struct snd_soc_dai_link *link;
+	int ret;
+
+	if (!np) {
+		dev_err(dev, "no device-tree\n");
+		return -ENXIO;
+	}
+
+	card = kzalloc(sizeof *card, GFP_KERNEL);
+	if (!card) {
+		dev_err(dev, "unable to allocate soc card\n");
+		return -ENOMEM;
+	}
+	card->name = "Simple DT audio card";
+	card->owner = THIS_MODULE;
+	card->dev = dev;
+	platform_set_drvdata(pdev, card);
+
+	link = kzalloc(sizeof *link, GFP_KERNEL);
+	if (!link) {
+		dev_err(dev, "unable to allocate soc link\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+	card->dai_link = link;
+	card->num_links = 1;
+
+	link->name = "Simple audio";
+	link->stream_name = "Playback";
+
+	link->cpu_of_node = of_parse_phandle(np, "audio-controller", 0);
+	if (!link->cpu_of_node) {
+		dev_err(dev, "no 'audio-controller' in DT\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	link->codec_of_node = of_parse_phandle(np, "audio-codec", 0);
+	if (!link->codec_of_node) {
+		dev_err(dev, "no 'audio-codec' in DT\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	link->platform_of_node = of_parse_phandle(np, "platform-pcm-dma", 0);
+	if (!link->platform_of_node) {
+		dev_err(dev, "no 'platform-pcm-dma' in DT\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = of_property_read_string(np, "codec-dai-name",
+					 &link->codec_dai_name);
+	if (ret) {
+		dev_err(dev, "no 'codec-dai-name' in DT\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = snd_soc_register_card(card);
+	if (ret) {
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "register card err %d\n", ret);
+		goto err;
+	}
+	return 0;
+
+err:
+	simple_dt_remove(pdev);
+	return ret;
+}
+
+static struct of_device_id simple_dt_of_match[] = {
+	{ .compatible = "linux,simple-dt-audio" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, simple_dt_of_match);
+
+static struct platform_driver simple_dt_driver = {
+	.driver		= {
+		.name	= "simple-dt-audio",
+		.owner	= THIS_MODULE,
+		.of_match_table = simple_dt_of_match,
+	},
+	.probe		= simple_dt_probe,
+	.remove		= simple_dt_remove,
+};
+module_platform_driver(simple_dt_driver);
+
+MODULE_AUTHOR("Jean-Francois Moine <moinejf@free.fr>");
+MODULE_DESCRIPTION("ALSA SoC simple DT driver");
+MODULE_LICENSE("GPL");

