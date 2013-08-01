Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab3HAWCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:02:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39789 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3HAWCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:02:39 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 28/51] DMA-API: sound: fix dma mask handling in a lot of
 drivers
Message-Id: <E1V50wk-0006sM-Bd@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:02:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code sequence is unsafe in modules:

static u64 mask = DMA_BIT_MASK(something);
...
	if (!dev->dma_mask)
		dev->dma_mask = &mask;

as if a module is reloaded, the mask will be pointing at the original
module's mask address, and this can lead to oopses.  Moreover, they
all follow this with:

	if (!dev->coherent_dma_mask)
		dev->coherent_dma_mask = mask;

where 'mask' is the same value as the statically defined mask, and this
bypasses the architecture's check on whether the DMA mask is possible.

Fix these issues by using the new dma_coerce_coherent_and_mask()
function.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 sound/arm/pxa2xx-pcm.c              |    9 +++------
 sound/soc/atmel/atmel-pcm.c         |   11 ++++-------
 sound/soc/blackfin/bf5xx-ac97-pcm.c |   11 ++++-------
 sound/soc/blackfin/bf5xx-i2s-pcm.c  |   10 ++++------
 sound/soc/davinci/davinci-pcm.c     |    9 +++------
 sound/soc/fsl/fsl_dma.c             |    9 +++------
 sound/soc/fsl/mpc5200_dma.c         |   10 ++++------
 sound/soc/jz4740/jz4740-pcm.c       |   12 ++++--------
 sound/soc/kirkwood/kirkwood-dma.c   |    9 +++------
 sound/soc/nuc900/nuc900-pcm.c       |    9 ++++-----
 sound/soc/omap/omap-pcm.c           |   11 ++++-------
 sound/soc/pxa/pxa2xx-pcm.c          |   11 ++++-------
 sound/soc/s6000/s6000-pcm.c         |    9 +++------
 sound/soc/samsung/dma.c             |   11 ++++-------
 sound/soc/samsung/idma.c            |   11 ++++-------
 15 files changed, 55 insertions(+), 97 deletions(-)

diff --git a/sound/arm/pxa2xx-pcm.c b/sound/arm/pxa2xx-pcm.c
index 26422a3..f199efb 100644
--- a/sound/arm/pxa2xx-pcm.c
+++ b/sound/arm/pxa2xx-pcm.c
@@ -80,8 +80,6 @@ static struct snd_pcm_ops pxa2xx_pcm_ops = {
 	.mmap		= pxa2xx_pcm_mmap,
 };
 
-static u64 pxa2xx_pcm_dmamask = 0xffffffff;
-
 int pxa2xx_pcm_new(struct snd_card *card, struct pxa2xx_pcm_client *client,
 		   struct snd_pcm **rpcm)
 {
@@ -97,10 +95,9 @@ int pxa2xx_pcm_new(struct snd_card *card, struct pxa2xx_pcm_client *client,
 	pcm->private_data = client;
 	pcm->private_free = pxa2xx_pcm_free_dma_buffers;
 
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &pxa2xx_pcm_dmamask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = 0xffffffff;
+	ret = dma_coerce_mask_and_coherent_mask(card->dev, DMA_BIT_MASK(32));
+	if (ret)
+		goto out;
 
 	if (play) {
 		int stream = SNDRV_PCM_STREAM_PLAYBACK;
diff --git a/sound/soc/atmel/atmel-pcm.c b/sound/soc/atmel/atmel-pcm.c
index 3109db7..fbb87e3 100644
--- a/sound/soc/atmel/atmel-pcm.c
+++ b/sound/soc/atmel/atmel-pcm.c
@@ -68,18 +68,15 @@ int atmel_pcm_mmap(struct snd_pcm_substream *substream,
 }
 EXPORT_SYMBOL_GPL(atmel_pcm_mmap);
 
-static u64 atmel_pcm_dmamask = DMA_BIT_MASK(32);
-
 int atmel_pcm_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
 	struct snd_pcm *pcm = rtd->pcm;
-	int ret = 0;
+	int ret;
 
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &atmel_pcm_dmamask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	if (pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream) {
 		pr_debug("atmel-pcm: allocating PCM playback DMA buffer\n");
diff --git a/sound/soc/blackfin/bf5xx-ac97-pcm.c b/sound/soc/blackfin/bf5xx-ac97-pcm.c
index 53f8408..1d4c676 100644
--- a/sound/soc/blackfin/bf5xx-ac97-pcm.c
+++ b/sound/soc/blackfin/bf5xx-ac97-pcm.c
@@ -415,19 +415,16 @@ static void bf5xx_pcm_free_dma_buffers(struct snd_pcm *pcm)
 	}
 }
 
-static u64 bf5xx_pcm_dmamask = DMA_BIT_MASK(32);
-
 static int bf5xx_pcm_ac97_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
 	struct snd_pcm *pcm = rtd->pcm;
-	int ret = 0;
+	int ret;
 
 	pr_debug("%s enter\n", __func__);
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &bf5xx_pcm_dmamask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	if (pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream) {
 		ret = bf5xx_pcm_preallocate_dma_buffer(pcm,
diff --git a/sound/soc/blackfin/bf5xx-i2s-pcm.c b/sound/soc/blackfin/bf5xx-i2s-pcm.c
index 9cb4a80..2a5b434 100644
--- a/sound/soc/blackfin/bf5xx-i2s-pcm.c
+++ b/sound/soc/blackfin/bf5xx-i2s-pcm.c
@@ -323,18 +323,16 @@ static struct snd_pcm_ops bf5xx_pcm_i2s_ops = {
 	.silence	= bf5xx_pcm_silence,
 };
 
-static u64 bf5xx_pcm_dmamask = DMA_BIT_MASK(32);
-
 static int bf5xx_pcm_i2s_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
 	size_t size = bf5xx_pcm_hardware.buffer_bytes_max;
+	int ret;
 
 	pr_debug("%s enter\n", __func__);
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &bf5xx_pcm_dmamask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	return snd_pcm_lib_preallocate_pages_for_all(rtd->pcm,
 				SNDRV_DMA_TYPE_DEV, card->dev, size, size);
diff --git a/sound/soc/davinci/davinci-pcm.c b/sound/soc/davinci/davinci-pcm.c
index 8460edc..84a63c6 100644
--- a/sound/soc/davinci/davinci-pcm.c
+++ b/sound/soc/davinci/davinci-pcm.c
@@ -844,18 +844,15 @@ static void davinci_pcm_free(struct snd_pcm *pcm)
 	}
 }
 
-static u64 davinci_pcm_dmamask = DMA_BIT_MASK(32);
-
 static int davinci_pcm_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
 	struct snd_pcm *pcm = rtd->pcm;
 	int ret;
 
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &davinci_pcm_dmamask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	if (pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream) {
 		ret = davinci_pcm_preallocate_dma_buffer(pcm,
diff --git a/sound/soc/fsl/fsl_dma.c b/sound/soc/fsl/fsl_dma.c
index 9cc5c1f..f73c7ef 100644
--- a/sound/soc/fsl/fsl_dma.c
+++ b/sound/soc/fsl/fsl_dma.c
@@ -298,14 +298,11 @@ static int fsl_dma_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
 	struct snd_pcm *pcm = rtd->pcm;
-	static u64 fsl_dma_dmamask = DMA_BIT_MASK(36);
 	int ret;
 
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &fsl_dma_dmamask;
-
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = fsl_dma_dmamask;
+	ret = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(36));
+	if (ret)
+		return ret;
 
 	/* Some codecs have separate DAIs for playback and capture, so we
 	 * should allocate a DMA buffer only for the streams that are valid.
diff --git a/sound/soc/fsl/mpc5200_dma.c b/sound/soc/fsl/mpc5200_dma.c
index 2a847ca..8fcf224 100644
--- a/sound/soc/fsl/mpc5200_dma.c
+++ b/sound/soc/fsl/mpc5200_dma.c
@@ -299,7 +299,6 @@ static struct snd_pcm_ops psc_dma_ops = {
 	.hw_params	= psc_dma_hw_params,
 };
 
-static u64 psc_dma_dmamask = DMA_BIT_MASK(32);
 static int psc_dma_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
@@ -307,15 +306,14 @@ static int psc_dma_new(struct snd_soc_pcm_runtime *rtd)
 	struct snd_pcm *pcm = rtd->pcm;
 	struct psc_dma *psc_dma = snd_soc_dai_get_drvdata(rtd->cpu_dai);
 	size_t size = psc_dma_hardware.buffer_bytes_max;
-	int rc = 0;
+	int rc;
 
 	dev_dbg(rtd->platform->dev, "psc_dma_new(card=%p, dai=%p, pcm=%p)\n",
 		card, dai, pcm);
 
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &psc_dma_dmamask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	rc = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(32));
+	if (rc)
+		return rc;
 
 	if (pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream) {
 		rc = snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV, pcm->card->dev,
diff --git a/sound/soc/jz4740/jz4740-pcm.c b/sound/soc/jz4740/jz4740-pcm.c
index 7100592..1d7ef28 100644
--- a/sound/soc/jz4740/jz4740-pcm.c
+++ b/sound/soc/jz4740/jz4740-pcm.c
@@ -297,19 +297,15 @@ static void jz4740_pcm_free(struct snd_pcm *pcm)
 	}
 }
 
-static u64 jz4740_pcm_dmamask = DMA_BIT_MASK(32);
-
 static int jz4740_pcm_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
 	struct snd_pcm *pcm = rtd->pcm;
-	int ret = 0;
-
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &jz4740_pcm_dmamask;
+	int ret;
 
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	if (pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream) {
 		ret = jz4740_pcm_preallocate_dma_buffer(pcm,
diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index a9f1453..2467a54 100644
--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -59,8 +59,6 @@ static struct snd_pcm_hardware kirkwood_dma_snd_hw = {
 	.fifo_size		= 0,
 };
 
-static u64 kirkwood_dma_dmamask = DMA_BIT_MASK(32);
-
 static irqreturn_t kirkwood_dma_irq(int irq, void *dev_id)
 {
 	struct kirkwood_dma_priv *prdata = dev_id;
@@ -324,10 +322,9 @@ static int kirkwood_dma_new(struct snd_soc_pcm_runtime *rtd)
 	struct snd_pcm *pcm = rtd->pcm;
 	int ret;
 
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &kirkwood_dma_dmamask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	if (pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream) {
 		ret = kirkwood_dma_preallocate_dma_buffer(pcm,
diff --git a/sound/soc/nuc900/nuc900-pcm.c b/sound/soc/nuc900/nuc900-pcm.c
index c894ff0..f588ee4 100644
--- a/sound/soc/nuc900/nuc900-pcm.c
+++ b/sound/soc/nuc900/nuc900-pcm.c
@@ -314,16 +314,15 @@ static void nuc900_dma_free_dma_buffers(struct snd_pcm *pcm)
 	snd_pcm_lib_preallocate_free_for_all(pcm);
 }
 
-static u64 nuc900_pcm_dmamask = DMA_BIT_MASK(32);
 static int nuc900_dma_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
 	struct snd_pcm *pcm = rtd->pcm;
+	int ret;
 
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &nuc900_pcm_dmamask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
 		card->dev, 4 * 1024, (4 * 1024) - 1);
diff --git a/sound/soc/omap/omap-pcm.c b/sound/soc/omap/omap-pcm.c
index a11405d..b8fa986 100644
--- a/sound/soc/omap/omap-pcm.c
+++ b/sound/soc/omap/omap-pcm.c
@@ -156,8 +156,6 @@ static struct snd_pcm_ops omap_pcm_ops = {
 	.mmap		= omap_pcm_mmap,
 };
 
-static u64 omap_pcm_dmamask = DMA_BIT_MASK(64);
-
 static int omap_pcm_preallocate_dma_buffer(struct snd_pcm *pcm,
 	int stream)
 {
@@ -202,12 +200,11 @@ static int omap_pcm_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
 	struct snd_pcm *pcm = rtd->pcm;
-	int ret = 0;
+	int ret;
 
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &omap_pcm_dmamask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(64);
+	ret = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(64));
+	if (ret)
+		return ret;
 
 	if (pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream) {
 		ret = omap_pcm_preallocate_dma_buffer(pcm,
diff --git a/sound/soc/pxa/pxa2xx-pcm.c b/sound/soc/pxa/pxa2xx-pcm.c
index ecff116..7e10a0f 100644
--- a/sound/soc/pxa/pxa2xx-pcm.c
+++ b/sound/soc/pxa/pxa2xx-pcm.c
@@ -84,18 +84,15 @@ static struct snd_pcm_ops pxa2xx_pcm_ops = {
 	.mmap		= pxa2xx_pcm_mmap,
 };
 
-static u64 pxa2xx_pcm_dmamask = DMA_BIT_MASK(32);
-
 static int pxa2xx_soc_pcm_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
 	struct snd_pcm *pcm = rtd->pcm;
-	int ret = 0;
+	int ret;
 
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &pxa2xx_pcm_dmamask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	if (pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream) {
 		ret = pxa2xx_pcm_preallocate_dma_buffer(pcm,
diff --git a/sound/soc/s6000/s6000-pcm.c b/sound/soc/s6000/s6000-pcm.c
index d0740a7..283620a 100644
--- a/sound/soc/s6000/s6000-pcm.c
+++ b/sound/soc/s6000/s6000-pcm.c
@@ -444,8 +444,6 @@ static void s6000_pcm_free(struct snd_pcm *pcm)
 	snd_pcm_lib_preallocate_free_for_all(pcm);
 }
 
-static u64 s6000_pcm_dmamask = DMA_BIT_MASK(32);
-
 static int s6000_pcm_new(struct snd_soc_pcm_runtime *runtime)
 {
 	struct snd_card *card = runtime->card->snd_card;
@@ -456,10 +454,9 @@ static int s6000_pcm_new(struct snd_soc_pcm_runtime *runtime)
 	params = snd_soc_dai_get_dma_data(runtime->cpu_dai,
 			pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream);
 
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &s6000_pcm_dmamask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	res = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(32));
+	if (res)
+		return res;
 
 	if (params->dma_in) {
 		s6dmac_disable_chan(DMA_MASK_DMAC(params->dma_in),
diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
index 21b7926..0d72dff 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -395,20 +395,17 @@ static void dma_free_dma_buffers(struct snd_pcm *pcm)
 	}
 }
 
-static u64 dma_mask = DMA_BIT_MASK(32);
-
 static int dma_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
 	struct snd_pcm *pcm = rtd->pcm;
-	int ret = 0;
+	int ret;
 
 	pr_debug("Entered %s\n", __func__);
 
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &dma_mask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	if (pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream) {
 		ret = preallocate_dma_buffer(pcm,
diff --git a/sound/soc/samsung/idma.c b/sound/soc/samsung/idma.c
index ce1e1e1..e4f318f 100644
--- a/sound/soc/samsung/idma.c
+++ b/sound/soc/samsung/idma.c
@@ -383,18 +383,15 @@ static int preallocate_idma_buffer(struct snd_pcm *pcm, int stream)
 	return 0;
 }
 
-static u64 idma_mask = DMA_BIT_MASK(32);
-
 static int idma_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
 	struct snd_pcm *pcm = rtd->pcm;
-	int ret = 0;
+	int ret;
 
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &idma_mask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_coerce_mask_and_coherent(card->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	if (pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream) {
 		ret = preallocate_idma_buffer(pcm,
-- 
1.7.4.4

