Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbbATTnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:43:19 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:20982 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbbATTnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:43:15 -0500
X-Mailbox-Line: From c8943506a056073292ef525a85e9ed89b6e90eb0 Mon Sep 17 00:00:00 2001
Message-Id: <c8943506a056073292ef525a85e9ed89b6e90eb0.1421782532.git.moinejf@free.fr>
In-Reply-To: <cover.1421782532.git.moinejf@free.fr>
References: <cover.1421782532.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Mon, 19 Jan 2015 18:15:31 +0100
Subject: [PATCH v10 1/9] ASoC: kirkwood: dynamically build the DAI array
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares the driver to the creation of the DAIs from a graph
of ports.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/kirkwood/kirkwood-i2s.c | 108 ++++++++++++++------------------------
 sound/soc/kirkwood/kirkwood.h     |   1 +
 2 files changed, 40 insertions(+), 69 deletions(-)

diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index def7d82..62d9c12 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -438,49 +438,8 @@ static const struct snd_soc_dai_ops kirkwood_i2s_dai_ops = {
 	.set_fmt        = kirkwood_i2s_set_fmt,
 };
 
-static struct snd_soc_dai_driver kirkwood_i2s_dai[2] = {
-    {
-	.name = "i2s",
-	.id = 0,
-	.playback = {
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000 |
-				SNDRV_PCM_RATE_96000,
-		.formats = KIRKWOOD_I2S_FORMATS,
-	},
-	.capture = {
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000 |
-				SNDRV_PCM_RATE_96000,
-		.formats = KIRKWOOD_I2S_FORMATS,
-	},
-	.ops = &kirkwood_i2s_dai_ops,
-    },
-    {
-	.name = "spdif",
-	.id = 1,
-	.playback = {
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000 |
-				SNDRV_PCM_RATE_96000,
-		.formats = KIRKWOOD_SPDIF_FORMATS,
-	},
-	.capture = {
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000 |
-				SNDRV_PCM_RATE_96000,
-		.formats = KIRKWOOD_SPDIF_FORMATS,
-	},
-	.ops = &kirkwood_i2s_dai_ops,
-    },
-};
-
-static struct snd_soc_dai_driver kirkwood_i2s_dai_extclk[2] = {
-    {
+/* DAI sample for I2S and external clock */
+static struct snd_soc_dai_driver kirkwood_i2s_dai_i2s_ext = {
 	.name = "i2s",
 	.id = 0,
 	.playback = {
@@ -500,42 +459,52 @@ static struct snd_soc_dai_driver kirkwood_i2s_dai_extclk[2] = {
 		.formats = KIRKWOOD_I2S_FORMATS,
 	},
 	.ops = &kirkwood_i2s_dai_ops,
-    },
-    {
-	.name = "spdif",
-	.id = 1,
-	.playback = {
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = SNDRV_PCM_RATE_CONTINUOUS,
-		.rate_min = 5512,
-		.rate_max = 192000,
-		.formats = KIRKWOOD_SPDIF_FORMATS,
-	},
-	.capture = {
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = SNDRV_PCM_RATE_CONTINUOUS,
-		.rate_min = 5512,
-		.rate_max = 192000,
-		.formats = KIRKWOOD_SPDIF_FORMATS,
-	},
-	.ops = &kirkwood_i2s_dai_ops,
-    },
 };
 
 static const struct snd_soc_component_driver kirkwood_i2s_component = {
 	.name		= DRV_NAME,
 };
 
+/* create the DAIs */
+static int kirkwood_i2s_create_dais(struct kirkwood_dma_data *priv)
+{
+	int i, ndai, dai[2];
+
+	ndai = 2;
+	dai[0] = 0;		/* i2s(0) - spdif(1) */
+	dai[1] = 1;
+	for (i = 0; i < ndai; i++) {
+		memcpy(&priv->dais[i], &kirkwood_i2s_dai_i2s_ext,
+				sizeof(priv->dais[0]));
+		priv->dais[i].id = i;
+		if (dai[i] == 1) {
+			priv->dais[i].name = "spdif";
+			priv->dais[i].playback.formats =
+						KIRKWOOD_SPDIF_FORMATS;
+			priv->dais[i].capture.formats =
+						KIRKWOOD_SPDIF_FORMATS;
+		}
+		if (IS_ERR(priv->extclk)) {
+			priv->dais[i].playback.rates =
+						SNDRV_PCM_RATE_44100 |
+						SNDRV_PCM_RATE_48000 |
+						SNDRV_PCM_RATE_96000;
+			priv->dais[i].capture.rates =
+						SNDRV_PCM_RATE_44100 |
+						SNDRV_PCM_RATE_48000 |
+						SNDRV_PCM_RATE_96000;
+		}
+	}
+	return ndai;
+}
+
 static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 {
 	struct kirkwood_asoc_platform_data *data = pdev->dev.platform_data;
-	struct snd_soc_dai_driver *soc_dai = kirkwood_i2s_dai;
 	struct kirkwood_dma_data *priv;
 	struct resource *mem;
 	struct device_node *np = pdev->dev.of_node;
-	int err;
+	int err, ndais;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
@@ -585,7 +554,6 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 		} else {
 			dev_info(&pdev->dev, "found external clock\n");
 			clk_prepare_enable(priv->extclk);
-			soc_dai = kirkwood_i2s_dai_extclk;
 		}
 	}
 
@@ -602,8 +570,10 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 		priv->ctl_rec |= KIRKWOOD_RECCTL_BURST_128;
 	}
 
+	ndais = kirkwood_i2s_create_dais(priv);
+
 	err = snd_soc_register_component(&pdev->dev, &kirkwood_i2s_component,
-					 soc_dai, 2);
+					 priv->dais, ndais);
 	if (err) {
 		dev_err(&pdev->dev, "snd_soc_register_component failed\n");
 		goto err_component;
diff --git a/sound/soc/kirkwood/kirkwood.h b/sound/soc/kirkwood/kirkwood.h
index 90e32a7..a24d2c2 100644
--- a/sound/soc/kirkwood/kirkwood.h
+++ b/sound/soc/kirkwood/kirkwood.h
@@ -135,6 +135,7 @@ struct kirkwood_dma_data {
 	void __iomem *io;
 	struct clk *clk;
 	struct clk *extclk;
+	struct snd_soc_dai_driver dais[2];
 	uint32_t ctl_play;
 	uint32_t ctl_rec;
 	struct snd_pcm_substream *substream_play;
-- 
2.1.4

