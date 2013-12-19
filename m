Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3LSPzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:55:40 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34684 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3LSPzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:55:37 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, broonie@kernel.org, alsa-devel@alsa-project.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/11] ASoC: ux500_pcm: Stop pretending that we support varying address widths
Date: Thu, 19 Dec 2013 15:55:02 +0000
Message-Id: <1387468508-12286-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Slave Config's addr_width attribute is populated by data_width of
dma_cfg, which in turn is derived from dma_params' data_size attribute
and that comes from the slot_width which is always 16 bits (2 Bytes).
We're cutting out the middle man here and just setting the DMA Slave
Config directly.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_pcm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
index ce554de..32d4572 100644
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -109,20 +109,19 @@ static int ux500_pcm_prepare_slave_config(struct snd_pcm_substream *substream,
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct ux500_msp_dma_params *dma_params;
-	struct stedma40_chan_cfg *dma_cfg;
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
 		slave_config->dst_addr = dma_params->tx_rx_addr;
-- 
1.8.3.2

