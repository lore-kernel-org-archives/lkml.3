Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3GYJNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:13:10 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:48521 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab3GYJNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:13:06 -0400
Date: Thu, 25 Jul 2013 11:13:14 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 1/4] ASoc: kirkwood: change the pcm/dma stream data pointer
Message-ID: <20130725111314.66b811bc@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the kirkwood pcm/dma driver, the private stream related data pointer
was hold in the platform drvdata.
As this pointer may be used by other parts of the audio subsystem,
this patch uses the substream runtime private data pointer instead.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/kirkwood/kirkwood-dma.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index a9f1453..cef5277 100644
--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -127,10 +127,9 @@ static int kirkwood_dma_open(struct snd_pcm_substream *substream)
 	int err;
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct snd_soc_pcm_runtime *soc_runtime = substream->private_data;
-	struct snd_soc_platform *platform = soc_runtime->platform;
 	struct snd_soc_dai *cpu_dai = soc_runtime->cpu_dai;
 	struct kirkwood_dma_data *priv;
-	struct kirkwood_dma_priv *prdata = snd_soc_platform_get_drvdata(platform);
+	struct kirkwood_dma_priv *prdata = runtime->private_data;
 	const struct mbus_dram_target_info *dram;
 	unsigned long addr;
 
@@ -171,7 +170,7 @@ static int kirkwood_dma_open(struct snd_pcm_substream *substream)
 			return -EBUSY;
 		}
 
-		snd_soc_platform_set_drvdata(platform, prdata);
+		runtime->private_data = prdata;
 
 		/*
 		 * Enable Error interrupts. We're only ack'ing them but
@@ -199,8 +198,7 @@ static int kirkwood_dma_close(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *soc_runtime = substream->private_data;
 	struct snd_soc_dai *cpu_dai = soc_runtime->cpu_dai;
-	struct snd_soc_platform *platform = soc_runtime->platform;
-	struct kirkwood_dma_priv *prdata = snd_soc_platform_get_drvdata(platform);
+	struct kirkwood_dma_priv *prdata = substream->runtime->private_data;
 	struct kirkwood_dma_data *priv;
 
 	priv = snd_soc_dai_get_dma_data(cpu_dai, substream);
@@ -217,7 +215,7 @@ static int kirkwood_dma_close(struct snd_pcm_substream *substream)
 		writel(0, priv->io + KIRKWOOD_ERR_MASK);
 		free_irq(priv->irq, prdata);
 		kfree(prdata);
-		snd_soc_platform_set_drvdata(platform, NULL);
+		substream->runtime->private_data = NULL;
 	}
 
 	return 0;
-- 
1.8.3.2



-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
