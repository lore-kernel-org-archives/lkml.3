Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab3GaGS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:18:26 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:42944 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab3GaGSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:18:24 -0400
Date: Wed, 31 Jul 2013 08:18:58 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v3 4/4] ASoC: kirkwood: change kirkwood-i2s to
 mvebu-pcm-audio and DT doc
Message-ID: <20130731081858.53413597@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the kirkwood audio system may be used in other Marvell machines
(mvebu), this patch changes the name of the audio driver to
'mvebu-pcm-audio' and also contains the associated DT documentation.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 .../devicetree/bindings/sound/mvebu-pcm-audio.txt | 29 ++++++++++++++++++++++
 sound/soc/kirkwood/kirkwood-dma.c                 |  2 +-
 sound/soc/kirkwood/kirkwood-i2s.c                 |  6 +++---
 sound/soc/kirkwood/kirkwood-openrd.c              |  4 ++--
 sound/soc/kirkwood/kirkwood-t5325.c               |  4 ++--
 5 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/mvebu-pcm-audio.txt b/Documentation/devicetree/bindings/sound/mvebu-pcm-audio.txt
new file mode 100644
index 0000000..0995ebc
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/mvebu-pcm-audio.txt
@@ -0,0 +1,29 @@
+* mvebu (Kirkwood, Dove, Armada 370) i2s controller
+
+Required properties:
+
+- compatible: "marvell,mvebu-pcm-audio"
+
+- reg: physical base address of the controller and length of memory mapped
+  region.
+
+- interrupts: list of two irq numbers.
+  The first irq is used for data flow and the second one is used for errors.
+
+- clocks: one or two phandles.
+  The first one is mandatory and defines the internal clock.
+  The second one is optional and defines an external clock.
+
+- clock-names: names associated to the clocks:
+	"internal" for the internal clock
+	"extclk" for the external clock
+
+Example:
+
+i2s1: audio-controller@b4000 {
+	compatible = "marvell,mvebu-pcm-audio";
+	reg = <0xb4000 0x2210>;
+	interrupts = <21>, <22>;
+	clocks = <&gate_clk 13>;
+	clock-names = "internal";
+};
diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index f735501..e9802f1 100644
--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -165,7 +165,7 @@ static int kirkwood_dma_open(struct snd_pcm_substream *substream)
 		prdata->data = priv;
 
 		err = request_irq(priv->irq, kirkwood_dma_irq, IRQF_SHARED,
-				  "kirkwood-i2s", prdata);
+				  "mvebu-pcm-audio", prdata);
 		if (err) {
 			kfree(prdata);
 			return -EBUSY;
diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index 9844010..4f817a2 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -25,7 +25,7 @@
 
 #include "kirkwood.h"
 
-#define DRV_NAME	"kirkwood-i2s"
+#define DRV_NAME	"mvebu-pcm-audio"
 
 #define KIRKWOOD_I2S_FORMATS \
 	(SNDRV_PCM_FMTBIT_S16_LE | \
@@ -555,7 +555,7 @@ fail:
 
 #ifdef CONFIG_OF
 static struct of_device_id kirkwood_i2s_of_match[] = {
-	{ .compatible = "marvell,kirkwood-i2s" },
+	{ .compatible = "marvell,mvebu-pcm-audio" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, kirkwood_i2s_of_match);
@@ -577,4 +577,4 @@ module_platform_driver(kirkwood_i2s_driver);
 MODULE_AUTHOR("Arnaud Patard, <arnaud.patard@rtp-net.org>");
 MODULE_DESCRIPTION("Kirkwood I2S SoC Interface");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:kirkwood-i2s");
+MODULE_ALIAS("platform:mvebu-pcm-audio");
diff --git a/sound/soc/kirkwood/kirkwood-openrd.c b/sound/soc/kirkwood/kirkwood-openrd.c
index df565d2..532843a 100644
--- a/sound/soc/kirkwood/kirkwood-openrd.c
+++ b/sound/soc/kirkwood/kirkwood-openrd.c
@@ -52,8 +52,8 @@ static struct snd_soc_dai_link openrd_client_dai[] = {
 {
 	.name = "CS42L51",
 	.stream_name = "CS42L51 HiFi",
-	.cpu_dai_name = "kirkwood-i2s",
-	.platform_name = "kirkwood-i2s",
+	.cpu_dai_name = "mvebu-pcm-audio",
+	.platform_name = "mvebu-pcm-audio",
 	.codec_dai_name = "cs42l51-hifi",
 	.codec_name = "cs42l51-codec.0-004a",
 	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_CBS_CFS,
diff --git a/sound/soc/kirkwood/kirkwood-t5325.c b/sound/soc/kirkwood/kirkwood-t5325.c
index b4647ba..d31a0f1 100644
--- a/sound/soc/kirkwood/kirkwood-t5325.c
+++ b/sound/soc/kirkwood/kirkwood-t5325.c
@@ -68,8 +68,8 @@ static struct snd_soc_dai_link t5325_dai[] = {
 {
 	.name = "ALC5621",
 	.stream_name = "ALC5621 HiFi",
-	.cpu_dai_name = "kirkwood-i2s",
-	.platform_name = "kirkwood-i2s",
+	.cpu_dai_name = "mvebu-pcm-audio",
+	.platform_name = "mvebu-pcm-audio",
 	.codec_dai_name = "alc5621-hifi",
 	.codec_name = "alc562x-codec.0-001a",
 	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_CBS_CFS,


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
