Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab3GBJHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:07:46 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:64162 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3GBJHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:07:09 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, richard.genoud@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 2/2] ASoC: atmel-pcm: use generic dmaengine framework
Date: Tue,  2 Jul 2013 17:04:09 +0800
Message-Id: <1372755849-19546-3-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372755849-19546-1-git-send-email-voice.shen@atmel.com>
References: <1372755849-19546-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align atmel pcm to use ASoC generic dmaengine framework

Signed-off-by: Bo Shen <voice.shen@atmel.com>

---
 sound/soc/atmel/atmel-pcm-dma.c |  118 ++++++---------------------------------
 1 file changed, 16 insertions(+), 102 deletions(-)

diff --git a/sound/soc/atmel/atmel-pcm-dma.c b/sound/soc/atmel/atmel-pcm-dma.c
index 1d38fd0..0f6c701 100644
--- a/sound/soc/atmel/atmel-pcm-dma.c
+++ b/sound/soc/atmel/atmel-pcm-dma.c
@@ -89,138 +89,52 @@ static void atmel_pcm_dma_irq(u32 ssc_sr,
 	}
 }
 
-/*--------------------------------------------------------------------------*\
- * DMAENGINE operations
-\*--------------------------------------------------------------------------*/
-static bool filter(struct dma_chan *chan, void *slave)
-{
-	struct at_dma_slave *sl = slave;
-
-	if (sl->dma_dev == chan->device->dev) {
-		chan->private = sl;
-		return true;
-	} else {
-		return false;
-	}
-}
-
 static int atmel_pcm_configure_dma(struct snd_pcm_substream *substream,
-	struct snd_pcm_hw_params *params, struct atmel_pcm_dma_params *prtd)
+	struct snd_pcm_hw_params *params, struct dma_slave_config *slave_config)
 {
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct atmel_pcm_dma_params *prtd;
 	struct ssc_device *ssc;
-	struct dma_chan *dma_chan;
-	struct dma_slave_config slave_config;
 	int ret;
 
+	prtd = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
 	ssc = prtd->ssc;
 
-	ret = snd_hwparams_to_dma_slave_config(substream, params,
-			&slave_config);
+	ret = snd_hwparams_to_dma_slave_config(substream, params, slave_config);
 	if (ret) {
 		pr_err("atmel-pcm: hwparams to dma slave configure failed\n");
 		return ret;
 	}
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		slave_config.dst_addr = (dma_addr_t)ssc->phybase + SSC_THR;
-		slave_config.dst_maxburst = 1;
+		slave_config->dst_addr = (dma_addr_t)ssc->phybase + SSC_THR;
+		slave_config->dst_maxburst = 1;
 	} else {
-		slave_config.src_addr = (dma_addr_t)ssc->phybase + SSC_RHR;
-		slave_config.src_maxburst = 1;
-	}
-
-	dma_chan = snd_dmaengine_pcm_get_chan(substream);
-	if (dmaengine_slave_config(dma_chan, &slave_config)) {
-		pr_err("atmel-pcm: failed to configure dma channel\n");
-		ret = -EBUSY;
-		return ret;
-	}
-
-	return 0;
-}
-
-static int atmel_pcm_hw_params(struct snd_pcm_substream *substream,
-	struct snd_pcm_hw_params *params)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct atmel_pcm_dma_params *prtd;
-	struct ssc_device *ssc;
-	struct at_dma_slave *sdata = NULL;
-	int ret;
-
-	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
-
-	prtd = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
-	ssc = prtd->ssc;
-	if (ssc->pdev)
-		sdata = ssc->pdev->dev.platform_data;
-
-	ret = snd_dmaengine_pcm_open_request_chan(substream, filter, sdata);
-	if (ret) {
-		pr_err("atmel-pcm: dmaengine pcm open failed\n");
-		return -EINVAL;
-	}
-
-	ret = atmel_pcm_configure_dma(substream, params, prtd);
-	if (ret) {
-		pr_err("atmel-pcm: failed to configure dmai\n");
-		goto err;
+		slave_config->src_addr = (dma_addr_t)ssc->phybase + SSC_RHR;
+		slave_config->src_maxburst = 1;
 	}
 
 	prtd->dma_intr_handler = atmel_pcm_dma_irq;
 
 	return 0;
-err:
-	snd_dmaengine_pcm_close_release_chan(substream);
-	return ret;
 }
 
-static int atmel_pcm_dma_prepare(struct snd_pcm_substream *substream)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct atmel_pcm_dma_params *prtd;
-
-	prtd = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
-
-	ssc_writex(prtd->ssc->regs, SSC_IER, prtd->mask->ssc_error);
-	ssc_writex(prtd->ssc->regs, SSC_CR, prtd->mask->ssc_enable);
-
-	return 0;
-}
-
-static int atmel_pcm_open(struct snd_pcm_substream *substream)
-{
-	snd_soc_set_runtime_hwparams(substream, &atmel_pcm_dma_hardware);
-
-	return 0;
-}
-
-static struct snd_pcm_ops atmel_pcm_ops = {
-	.open		= atmel_pcm_open,
-	.close		= snd_dmaengine_pcm_close_release_chan,
-	.ioctl		= snd_pcm_lib_ioctl,
-	.hw_params	= atmel_pcm_hw_params,
-	.prepare	= atmel_pcm_dma_prepare,
-	.trigger	= snd_dmaengine_pcm_trigger,
-	.pointer	= snd_dmaengine_pcm_pointer_no_residue,
-	.mmap		= atmel_pcm_mmap,
-};
-
-static struct snd_soc_platform_driver atmel_soc_platform = {
-	.ops		= &atmel_pcm_ops,
-	.pcm_new	= atmel_pcm_new,
-	.pcm_free	= atmel_pcm_free,
+static const struct snd_dmaengine_pcm_config atmel_dmaengine_pcm_config = {
+	.prepare_slave_config = atmel_pcm_configure_dma,
+	.pcm_hardware = &atmel_pcm_dma_hardware,
+	.prealloc_buffer_size = ATMEL_SSC_DMABUF_SIZE,
 };
 
 int atmel_pcm_dma_platform_register(struct device *dev)
 {
-	return snd_soc_register_platform(dev, &atmel_soc_platform);
+	return snd_dmaengine_pcm_register(dev, &atmel_dmaengine_pcm_config,
+			SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);
 }
 EXPORT_SYMBOL(atmel_pcm_dma_platform_register);
 
 void atmel_pcm_dma_platform_unregister(struct device *dev)
 {
-	snd_soc_unregister_platform(dev);
+	snd_dmaengine_pcm_unregister(dev);
 }
 EXPORT_SYMBOL(atmel_pcm_dma_platform_unregister);
 
-- 
1.7.9.5

