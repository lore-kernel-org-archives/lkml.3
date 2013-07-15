Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446Ab3GOQlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:41:52 -0400
Received: from smtp-out-191.synserver.de ([212.40.185.191]:1056 "EHLO
	smtp-out-191.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413Ab3GOQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:41:38 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 24125
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [RFC 2/2] ASoC: dmaengine-pcm: Provide default config
Date: Mon, 15 Jul 2013 18:42:11 +0200
Message-Id: <1373906531-6938-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1373906531-6938-1-git-send-email-lars@metafoo.de>
References: <1373906531-6938-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some default settings for the generic dmaengine PCM driver for
the case that no config has been supplied. The following defaults are used:
	* Use snd_dmaengine_pcm_prepare_slave_config for preparing the DMA slave
	  config.
	* 256kB for the prealloc buffer size. This value has been chosen based on
	  'feels about right' and is not backed up by any scientific facts. We
	  may need to come up with something smarter in the future but it should
	  work fine for now.
	* Query the DMA driver for its maximum period size, etc.

With this infrastructure in place we can finally write DAI drivers which are
independent of the DMA controller they are connected to. This is e.g. useful if
the DAI IP core is reused across different SoCs, but the SoCs uses different DMA
controllers.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/soc-generic-dmaengine-pcm.c | 52 +++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index 98044a7..947365de 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -75,12 +75,19 @@ static int dmaengine_pcm_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct dmaengine_pcm *pcm = soc_platform_to_pcm(rtd->platform);
 	struct dma_chan *chan = snd_dmaengine_pcm_get_chan(substream);
+	int (*prepare_slave_config)(struct snd_pcm_substream *substream,
+			struct snd_pcm_hw_params *params,
+			struct dma_slave_config *slave_config);
 	struct dma_slave_config slave_config;
 	int ret;
 
-	if (pcm->config->prepare_slave_config) {
-		ret = pcm->config->prepare_slave_config(substream, params,
-				&slave_config);
+	if (!pcm->config)
+		prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config;
+	else
+		prepare_slave_config = pcm->config->prepare_slave_config;
+
+	if (prepare_slave_config) {
+		ret = prepare_slave_config(substream, params, &slave_config);
 		if (ret)
 			return ret;
 
@@ -136,7 +143,7 @@ static int dmaengine_pcm_open(struct snd_pcm_substream *substream)
 	struct dma_chan *chan = pcm->chan[substream->stream];
 	int ret;
 
-	if (pcm->config->pcm_hardware) {
+	if (pcm->config && pcm->config->pcm_hardware) {
 		ret = snd_soc_set_runtime_hwparams(substream,
 					pcm->config->pcm_hardware);
 	} else {
@@ -179,14 +186,39 @@ static struct dma_chan *dmaengine_pcm_compat_request_channel(
 		snd_soc_dai_get_dma_data(rtd->cpu_dai, substream));
 }
 
+static size_t dmaengine_pcm_get_max_buffer_size(struct dma_chan *chan)
+{
+	struct dma_slave_caps dma_caps;
+	int ret;
+
+	ret = dma_get_slave_caps(chan, &dma_caps);
+	if (ret)
+		return 0;
+
+	if (dma_caps.max_sg_nr == 0 || dma_caps.max_sg_len == 0)
+		return SIZE_MAX;
+
+	if (SIZE_MAX / dma_caps.max_sg_nr > dma_caps.max_sg_len)
+		return SIZE_MAX;
+
+	return dma_caps.max_sg_nr * dma_caps.max_sg_len;
+}
+
 static int dmaengine_pcm_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct dmaengine_pcm *pcm = soc_platform_to_pcm(rtd->platform);
 	const struct snd_dmaengine_pcm_config *config = pcm->config;
 	struct snd_pcm_substream *substream;
+	size_t prealloc_buffer_size;
+	size_t max_buffer_size;
 	unsigned int i;
 	int ret;
 
+	if (config && config->prealloc_buffer_size)
+		prealloc_buffer_size = config->prealloc_buffer_size;
+	else
+		prealloc_buffer_size = 256 * 1024;
+
 	for (i = SNDRV_PCM_STREAM_PLAYBACK; i <= SNDRV_PCM_STREAM_CAPTURE; i++) {
 		substream = rtd->pcm->streams[i].substream;
 		if (!substream)
@@ -204,11 +236,19 @@ static int dmaengine_pcm_new(struct snd_soc_pcm_runtime *rtd)
 			goto err_free;
 		}
 
+		if (config && config->pcm_hardware)
+			max_buffer_size = config->pcm_hardware->buffer_bytes_max;
+		else
+			max_buffer_size = dmaengine_pcm_get_max_buffer_size(pcm->chan[i]);
+
+		if (max_buffer_size == 0)
+			max_buffer_size = prealloc_buffer_size;
+
 		ret = snd_pcm_lib_preallocate_pages(substream,
 				SNDRV_DMA_TYPE_DEV,
 				dmaengine_dma_dev(pcm, substream),
-				config->prealloc_buffer_size,
-				config->pcm_hardware->buffer_bytes_max);
+				prealloc_buffer_size,
+				max_buffer_size);
 		if (ret)
 			goto err_free;
 	}
-- 
1.8.0

