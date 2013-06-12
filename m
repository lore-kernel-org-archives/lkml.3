Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3FLH60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:58:26 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:35005 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3FLH6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:58:22 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 3/3] ASoC: ux500: Add DMA slave config prepare routine
Date: Wed, 12 Jun 2013 09:57:59 +0200
Message-Id: <1371023879-21884-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1371023879-21884-1-git-send-email-fabio.baltieri@linaro.org>
References: <1371023879-21884-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a DMA slave config prepare routine, as until now the MSP
driver depended on the DMA controller completing the channel
configuration on its own, but this is not the case anymore since the
recent DMA driver updates.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/ux500/ux500_pcm.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
index b6e5ae2..5f01c19 100644
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -103,10 +103,40 @@ static struct dma_chan *ux500_pcm_request_chan(struct snd_soc_pcm_runtime *rtd,
 	return snd_dmaengine_pcm_request_channel(stedma40_filter, dma_cfg);
 }
 
+static int ux500_pcm_prepare_slave_config(struct snd_pcm_substream *substream,
+		struct snd_pcm_hw_params *params,
+		struct dma_slave_config *slave_config)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct ux500_msp_dma_params *dma_params;
+	struct stedma40_chan_cfg *dma_cfg;
+	int ret;
+
+	dma_params = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
+	dma_cfg = dma_params->dma_cfg;
+
+	ret = snd_hwparams_to_dma_slave_config(substream, params, slave_config);
+	if (ret)
+		return ret;
+
+	slave_config->dst_maxburst = 4;
+	slave_config->dst_addr_width = dma_cfg->dst_info.data_width;
+	slave_config->src_maxburst = 4;
+	slave_config->src_addr_width = dma_cfg->src_info.data_width;
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		slave_config->dst_addr = dma_params->tx_rx_addr;
+	else
+		slave_config->src_addr = dma_params->tx_rx_addr;
+
+	return 0;
+}
+
 static const struct snd_dmaengine_pcm_config ux500_dmaengine_pcm_config = {
 	.pcm_hardware = &ux500_pcm_hw,
 	.compat_request_channel = ux500_pcm_request_chan,
 	.prealloc_buffer_size = 128 * 1024,
+	.prepare_slave_config = ux500_pcm_prepare_slave_config,
 };
 
 int ux500_pcm_register_platform(struct platform_device *pdev)
-- 
1.8.2

