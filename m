Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3LSP6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:58:54 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:47309 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3LSPzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:55:39 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, broonie@kernel.org, alsa-devel@alsa-project.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/11] ASoC: ux500_pcm: Expect different saved DMA data when obtaining from DAI store
Date: Thu, 19 Dec 2013 15:55:03 +0000
Message-Id: <1387468508-12286-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for full Device Tree enablement we must differentiate
between the two varying ways DMA data can be held in the DAI store. If
we're booting with Device Tree the provided 'snd_dmaengine_dai_dma_data'
data structure shall be used, whereas in order to avoid breaking legacy
platform data we also need to be able to translate DMA data stored using
the UX500 specific 'ux500_msp_dma_params' method.

Once we move over to solely use Device Tree, we can enforce the use of
'snd_dmaengine_dai_dma_data' and this code can be removed altogether.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_pcm.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
index 32d4572..8b53f22 100644
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -108,10 +108,21 @@ static int ux500_pcm_prepare_slave_config(struct snd_pcm_substream *substream,
 		struct dma_slave_config *slave_config)
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct ux500_msp_dma_params *dma_params;
+	struct msp_i2s_platform_data *pdata = rtd->cpu_dai->dev->platform_data;
+	struct snd_dmaengine_dai_dma_data *snd_dma_params;
+	struct ux500_msp_dma_params *ste_dma_params;
+	dma_addr_t dma_addr;
 	int ret;
 
-	dma_params = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
+	if (pdata) {
+		ste_dma_params =
+			snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
+		dma_addr = ste_dma_params->tx_rx_addr;
+	} else {
+		snd_dma_params =
+			snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
+		dma_addr = snd_dma_params->addr;
+	}
 
 	ret = snd_hwparams_to_dma_slave_config(substream, params, slave_config);
 	if (ret)
@@ -124,9 +135,9 @@ static int ux500_pcm_prepare_slave_config(struct snd_pcm_substream *substream,
 	slave_config->dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		slave_config->dst_addr = dma_params->tx_rx_addr;
+		slave_config->dst_addr = dma_addr;
 	else
-		slave_config->src_addr = dma_params->tx_rx_addr;
+		slave_config->src_addr = dma_addr;
 
 	return 0;
 }
-- 
1.8.3.2

