Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab3LaKck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 05:32:40 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:34543 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab3LaKch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 05:32:37 -0500
Date: Tue, 31 Dec 2013 11:31:38 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>
Cc: alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: generic: add generic compound card with DT support
Message-ID: <20131231113138.102044cf@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some audio cards are built from different hardware components.
When such compound cards don't need specific code, this driver creates
them with the required DAI links and routes from a DT.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
This code was first developped on the generic simple card, but its
recent DT extension cannot be easily extended again to support compound
cards as the one in the Cubox.
Note also that the example relies on a proposed patch of mine aiming to
render the codec name / OF node optional in DAI links
(http://mailman.alsa-project.org/pipermail/alsa-devel/2013-December/070082.html).
---
 .../devicetree/bindings/sound/compound-card.txt |  95 ++++++++++++
 sound/soc/generic/Kconfig                       |   6 +
 sound/soc/generic/Makefile                      |   2 +
 sound/soc/generic/compound-card.c               | 247 +++++++++++++++++++++++++
 4 file changed, 350 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/compound-card.txt b/Documentation/devicetree/bindings/sound/compound-card.txt
new file mode 100644
index 0000000..554a796
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/compound-card.txt
@@ -0,0 +1,95 @@
+Device-Tree bindings for compound audio card
+
+Compound audio card describes the links between the different parts
+of an audio card built from different hardware components.
+
+Required properties:
+  - compatible: should be "compound-audio-card"
+  - audio-controller: phandle of the audio controller
+
+Optional properties:
+  - routes: list of couple of strings (sink, source)
+
+Required subnodes:
+  - link: DAI link subnode
+	At least one link must be specified.
+
+Required link subnode properties:
+  - link-name: names of the DAI link and of the stream
+  - cpu-dai-name: name of the CPU or CODEC DAI
+		An empty string indicates that the CPU DAI is
+		the same as the audio controller.
+  - codec-dai-name: name of the CODEC DAI
+
+Optional link subnode properties:
+  - audio-codec or codec-name: phandle or name of the CODEC
+		in case the codec-dai-name is not unique
+  - format: DAI format. One of:
+		"i2s", "right_j", "left_j" , "dsp_a"
+		"dsp_b", "ac97", "pdm", "msb", "lsb"
+  - front-end or back-end: present if the DAI link describes resp.
+		a front-end CPU DAI or a back-end CODEC DAI
+  - playback or capture: present if the DAI link is used for
+		playback or capture only
+
+Example node:
+
+The audio subsystem found in the SolidRun Cubox is composed of:
+
+- an audio controller which outputs playback streams on either one or both
+  of I2S and S/PDIF,
+
+- a HDMI transmitter which can get its input from either I2S or S/PDIF,
+
+- an optical S/PDIF connector.
+
+	sound {
+		compatible = "compound-audio-card";
+		audio-controller = <&audio1>;
+		routes =
+			"I2S Playback",   "System Playback",
+			"SPDIF Playback", "System Playback",
+			"hdmi-out",	"I2S Playback",
+			"hdmi-out",	"SPDIF Playback",
+			"spdif-out",	"SPDIF Playback";
+		link@0 {
+			link-name = "System audio";
+			front-end;
+			cpu-dai-name = "mvebu-audio";
+			codec-dai-name = "snd-soc-dummy-dai";
+			format = "i2s";
+			playback;
+		};
+		link@1 {
+			link-name = "hdmi-i2s";
+			back-end;
+			cpu-dai-name = "i2s";
+			codec-dai-name = "i2s-hifi";
+			playback;
+		};
+		link@2 {
+			link-name = "hdmi-spdif";
+			back-end;
+			cpu-dai-name = "spdif";
+			codec-dai-name = "spdif-hifi";
+			playback;
+		};
+		link@3 {
+			link-name = "spdif";
+			back-end;
+			cpu-dai-name = "spdif";
+			codec-dai-name = "dit-hifi";
+			playback;
+		};
+	};
+
+	hdmi_codec: hdmi-codec {
+		compatible = "nxp,tda998x-codec";
+		audio-ports = <0x03>, <0x04>;
+	};
+
+	spdif_codec: spdif-codec {
+		compatible = "linux,spdif-dit";
+	};
+
+
diff --git a/sound/soc/generic/Kconfig b/sound/soc/generic/Kconfig
index 610f612..f2678ae 100644
--- a/sound/soc/generic/Kconfig
+++ b/sound/soc/generic/Kconfig
@@ -2,3 +2,9 @@ config SND_SIMPLE_CARD
 	tristate "ASoC Simple sound card support"
 	help
 	  This option enables generic simple sound card support
+
+config SND_COMPOUND_CARD
+	tristate "ASoC Compound sound card support"
+	depends on OF
+	help
+	  This option enables the generic compound sound card support.
diff --git a/sound/soc/generic/Makefile b/sound/soc/generic/Makefile
index 9c3b246..434cb79 100644
--- a/sound/soc/generic/Makefile
+++ b/sound/soc/generic/Makefile
@@ -1,3 +1,5 @@
 snd-soc-simple-card-objs	:= simple-card.o
+snd-soc-compound-card-objs	:= compound-card.o
 
 obj-$(CONFIG_SND_SIMPLE_CARD)	+= snd-soc-simple-card.o
+obj-$(CONFIG_SND_COMPOUND_CARD)	+= snd-soc-compound-card.o
diff --git a/sound/soc/generic/compound-card.c b/sound/soc/generic/compound-card.c
new file mode 100644
index 0000000..f57e159
--- /dev/null
+++ b/sound/soc/generic/compound-card.c
@@ -0,0 +1,247 @@
+/*
+ * ASoC compound sound card support
+ *
+ * Copyright (C) 2013 Jean-Francois Moine <moinejf@free.fr>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <sound/soc.h>
+
+// link types
+#define LINK_FE 0	/* front-end */
+#define LINK_BE 1	/* back-end */
+#define LINK_CC 2	/* (controller or codec) to codec */
+
+struct compound_card_data {
+	struct snd_soc_card snd_card;
+	struct snd_soc_dai_link *snd_links;
+};
+
+/* get a DAI link */
+static int get_link(struct compound_card_data *priv,
+			struct snd_soc_dai_link *link,
+			struct device_node *ctrl_np,
+			struct device_node *np)
+{
+	struct device_node *codec_np;
+	const char *cpu_dai_name;
+	int type, ret;
+
+	/* optional link-name */
+	of_property_read_string(np, "link-name", &link->name);
+	link->stream_name = link->name;
+
+	/* link type */
+	if (of_property_read_bool(np, "front-end"))
+		type = LINK_FE;
+	else if (of_property_read_bool(np, "back-end"))
+		type = LINK_BE;
+	else
+		type = LINK_CC;
+
+	/* cpu-dai-name */
+	ret = of_property_read_string(np, "cpu-dai-name",
+					&cpu_dai_name);
+	if (ret) {
+		dev_err(priv->snd_card.dev,
+			"No valid cpu-dai-name found\n");
+		return ret;
+	}
+
+	/* an empty cpu-dai-name forces the audio-controller */
+	if (cpu_dai_name[0] == '\0')
+		link->cpu_of_node = ctrl_np;
+	else
+		link->cpu_dai_name = cpu_dai_name;
+
+	/* the codec may be omitted or specified by name or phandle */
+	codec_np = of_parse_phandle(np, "audio-codec", 0);
+	if (codec_np)
+		link->codec_of_node = codec_np;
+	else
+		of_property_read_string(np, "codec-name",
+					&link->codec_name);
+
+	/* codec-dai-name */
+	ret = of_property_read_string(np, "codec-dai-name",
+					&link->codec_dai_name);
+	if (ret) {
+		dev_err(priv->snd_card.dev,
+			"Failed to parse codec-dai-name\n");
+		return ret;
+	}
+
+	if (type == LINK_BE) {
+		link->no_pcm = 1;
+		/* don't set the platform, otherwise, the platform functions
+		 * are called many times */
+	} else {
+		link->platform_of_node = ctrl_np;
+		if (type == LINK_FE)
+			link->dynamic = 1;
+	}
+
+	/* DAI format */
+	link->dai_fmt = snd_soc_of_parse_daifmt(np, NULL) &
+				SND_SOC_DAIFMT_FORMAT_MASK;
+
+	if (of_property_read_bool(np, "playback"))
+		link->playback_only = 1;
+	else if (of_property_read_bool(np, "capture"))
+		link->capture_only = 1;
+
+	return 0;
+}
+
+static int compound_card_dt_probe(struct platform_device *pdev,
+		struct compound_card_data *priv)
+{
+	struct device_node *np, *ctrl_np, *link_np;
+	struct snd_soc_dai_link *link;
+	int ret, num_links;
+
+	np = pdev->dev.of_node;
+
+	ctrl_np = of_parse_phandle(np, "audio-controller", 0);
+	if (!ctrl_np) {
+		dev_err(&pdev->dev, "No valid audio-controller phandle found\n");
+		return -EINVAL;
+	}
+
+	/* get the optional routes */
+	if (of_property_count_strings(np, "routes"))
+		snd_soc_of_parse_audio_routing(&priv->snd_card, "routes");
+
+	priv->snd_card.name = "ASoC compound sound card";
+
+	/* check the number of links */
+	num_links = 0;
+	for_each_child_of_node(np, link_np)
+		num_links++;
+
+	if (num_links == 0) {
+		dev_err(&pdev->dev, "No DAI link\n");
+		return -EINVAL;
+	}
+
+	link = devm_kzalloc(&pdev->dev,
+				sizeof(struct snd_soc_dai_link) * num_links,
+				GFP_KERNEL);
+	if (!link) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	priv->snd_links = link;
+	priv->snd_card.num_links = num_links;
+	for_each_child_of_node(np, link_np) {
+		ret = get_link(priv, link, ctrl_np, link_np);
+		if (ret)
+			goto err;
+		link++;
+	}
+
+	return 0;
+
+err:
+	if (link_np)
+		of_node_put(link_np);
+	if (ctrl_np)
+		of_node_put(ctrl_np);
+	for (num_links = 0, link = priv->snd_links;
+	     num_links < priv->snd_card.num_links;
+	     num_links++, link++) {
+		struct device_node *codec_np;
+
+		codec_np = (struct device_node *) link->codec_of_node;
+		if (!codec_np)
+			break;
+		of_node_put(codec_np);
+	}
+	return ret;
+}
+
+static int compound_card_dt_remove(struct platform_device *pdev,
+		struct compound_card_data *priv)
+{
+	struct device_node *codec_np;
+	struct snd_soc_dai_link *link;
+	int num_links;
+
+	if (!priv->snd_links)
+		return 0;
+	if (priv->snd_links->platform_of_node)
+		of_node_put((struct device_node *)
+				priv->snd_links->platform_of_node);
+	for (num_links = 0, link = priv->snd_links;
+	     num_links < priv->snd_card.num_links;
+	     num_links++, link++) {
+		codec_np = (struct device_node *) link->codec_of_node;
+		if (!codec_np)
+			break;
+		of_node_put(codec_np);
+	}
+	return 0;
+}
+
+static int compound_card_probe(struct platform_device *pdev)
+{
+	struct compound_card_data *priv;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof *priv, GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->snd_card.owner = THIS_MODULE;
+	priv->snd_card.dev = &pdev->dev;
+
+	ret = compound_card_dt_probe(pdev, priv);
+
+	if (ret)
+		return ret;
+
+	priv->snd_card.dai_link = priv->snd_links;
+
+	dev_set_drvdata(&pdev->dev, priv);
+
+	return snd_soc_register_card(&priv->snd_card);
+}
+
+static int compound_card_remove(struct platform_device *pdev)
+{
+	struct compound_card_data *priv = dev_get_drvdata(&pdev->dev);
+ 
+	snd_soc_unregister_card(&priv->snd_card);
+
+	compound_card_dt_remove(pdev, priv);
+
+	return 0;
+}
+
+static const struct of_device_id compound_card_of_dev_ids[] = {
+	{ .compatible = "compound-audio-card", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, compound_card_of_dev_ids);
+
+static struct platform_driver compound_card = {
+	.driver = {
+		.name	= "asoc-compound-card",
+		.owner = THIS_MODULE,
+		.of_match_table = compound_card_of_dev_ids,
+	},
+	.probe		= compound_card_probe,
+	.remove		= compound_card_remove,
+};
+
+module_platform_driver(compound_card);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ASoC Compound Sound Card");
+MODULE_AUTHOR("Jean-Francois Moine <moinejf@free.fr>");

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
