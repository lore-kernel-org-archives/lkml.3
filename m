Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab3GOQlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:41:39 -0400
Received: from smtp-out-191.synserver.de ([212.40.185.191]:1106 "EHLO
	smtp-out-191.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933394Ab3GOQlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:41:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 24125
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [RFC 1/2] ASoC: dmaengine-pcm: Add support for querying DMA capabilities
Date: Mon, 15 Jul 2013 18:42:10 +0200
Message-Id: <1373906531-6938-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently each platform making use the the generic dmaengine PCM driver still
needs to provide a custom snd_pcm_hardware struct which specifies the
capabilities of the DMA controller, e.g. the maximum period size that can be
supported. This patch adds code which uses the newly introduced
dma_get_slave_caps() API to query this information from the dmaengine driver.
The new code path will only be taken if the 'pcm_hardware' field of the
snd_dmaengine_pcm_config struct is NULL.

The patch also introduces a new 'fifo_size' field to the
snd_dmaengine_dai_dma_data struct which is used to initialize the
snd_pcm_hardware 'fifo_size' field and needs to be set by the DAI driver.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
For review only for now. The dma_get_slave_caps() API has not been merged yet,
the patch adding support for it can be found here:
http://permalink.gmane.org/gmane.linux.kernel/1524880
---
 include/sound/dmaengine_pcm.h         |  2 ++
 sound/soc/soc-generic-dmaengine-pcm.c | 46 +++++++++++++++++++++++++++++++++--
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/sound/dmaengine_pcm.h b/include/sound/dmaengine_pcm.h
index f11c35c..83b2c3e 100644
--- a/include/sound/dmaengine_pcm.h
+++ b/include/sound/dmaengine_pcm.h
@@ -61,6 +61,7 @@ struct dma_chan *snd_dmaengine_pcm_get_chan(struct snd_pcm_substream *substream)
  * @slave_id: Slave requester id for the DMA channel.
  * @filter_data: Custom DMA channel filter data, this will usually be used when
  * requesting the DMA channel.
+ * @fifo_size: FIFO size of the DAI controller in bytes
  */
 struct snd_dmaengine_dai_dma_data {
 	dma_addr_t addr;
@@ -68,6 +69,7 @@ struct snd_dmaengine_dai_dma_data {
 	u32 maxburst;
 	unsigned int slave_id;
 	void *filter_data;
+	unsigned int fifo_size;
 };
 
 void snd_dmaengine_pcm_set_config_from_dai_data(
diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index e29ec3c..98044a7 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -92,6 +92,43 @@ static int dmaengine_pcm_hw_params(struct snd_pcm_substream *substream,
 	return snd_pcm_lib_malloc_pages(substream, params_buffer_bytes(params));
 }
 
+static int dmaengine_pcm_set_runtime_hwparams(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct dmaengine_pcm *pcm = soc_platform_to_pcm(rtd->platform);
+	struct dma_chan *chan = pcm->chan[substream->stream];
+	struct snd_dmaengine_dai_dma_data *dma_data;
+	struct snd_pcm_hardware hw;
+	struct dma_slave_caps dma_caps;
+	int ret;
+
+	dma_data = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
+
+	ret = dma_get_slave_caps(chan, &dma_caps);
+	if (ret)
+		return ret;
+
+	memset(&hw, 0, sizeof(hw));
+	hw.info = SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_MMAP_VALID |
+			SNDRV_PCM_INFO_INTERLEAVED;
+	hw.periods_min = 2;
+	hw.periods_max = dma_caps.max_sg_nr;
+	hw.period_bytes_min = 16;
+	hw.period_bytes_max = dma_caps.max_sg_len;
+	hw.buffer_bytes_max = SIZE_MAX;
+	hw.fifo_size = dma_data->fifo_size;
+
+	if (hw.periods_max == 0)
+		hw.periods_max = UINT_MAX;
+	if (hw.period_bytes_max == 0)
+		hw.period_bytes_max = SIZE_MAX;
+
+	if (dma_caps.cmd_pause)
+		hw.info |= SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME;
+
+	return snd_soc_set_runtime_hwparams(substream, &hw);
+}
+
 static int dmaengine_pcm_open(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
@@ -99,8 +136,13 @@ static int dmaengine_pcm_open(struct snd_pcm_substream *substream)
 	struct dma_chan *chan = pcm->chan[substream->stream];
 	int ret;
 
-	ret = snd_soc_set_runtime_hwparams(substream,
-				pcm->config->pcm_hardware);
+	if (pcm->config->pcm_hardware) {
+		ret = snd_soc_set_runtime_hwparams(substream,
+					pcm->config->pcm_hardware);
+	} else {
+		ret = dmaengine_pcm_set_runtime_hwparams(substream);
+	}
+
 	if (ret)
 		return ret;
 
-- 
1.8.0

