Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3LBSAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:00:32 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:33043 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab3LBSA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:00:29 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, broonie@kernel.org,
        Lee Jones <lee.jones@linaro.org>, alsa-devel@alsa-project.org
Subject: [PATCH 1/3] ASoC: ux500_pcm: Stop pretending that we support varying address widths
Date: Mon,  2 Dec 2013 18:00:20 +0000
Message-Id: <1386007222-10081-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Slave Config's addr_width attribute is populated by data_width of
dma_cfg, which in turn is derived from dma_params' data_size attribute
and that comes from the slot_width which is always 16 bits (2 Bytes).
We're cutting out the middle man here and just setting the DMA Slave
Config directly.

Cc: alsa-devel@alsa-project.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_pcm.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
index 6162f70..2f1bdb7 100644
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -104,26 +104,25 @@ static int ux500_pcm_prepare_slave_config(struct snd_pcm_substream *substream,
 		struct dma_slave_config *slave_config)
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct ux500_msp_dma_params *dma_params;
-	struct stedma40_chan_cfg *dma_cfg;
+	struct snd_dmaengine_dai_dma_data *dma_params;
 	int ret;
 
 	dma_params = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
-	dma_cfg = dma_params->dma_cfg;
 
 	ret = snd_hwparams_to_dma_slave_config(substream, params, slave_config);
 	if (ret)
 		return ret;
 
 	slave_config->dst_maxburst = 4;
-	slave_config->dst_addr_width = dma_cfg->dst_info.data_width;
 	slave_config->src_maxburst = 4;
-	slave_config->src_addr_width = dma_cfg->src_info.data_width;
+
+	slave_config->src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	slave_config->dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		slave_config->dst_addr = dma_params->tx_rx_addr;
+		slave_config->dst_addr = dma_params->addr;
 	else
-		slave_config->src_addr = dma_params->tx_rx_addr;
+		slave_config->src_addr = dma_params->addr;
 
 	return 0;
 }
-- 
1.8.3.2

