Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaGBNae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:30:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38526 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbaGBN3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:29:53 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>, <lars@metafoo.de>,
        <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, <joelf@ti.com>, <nsekhar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH v2 3/5] ASoC: generic-dmaengine-pcm: Prepare formats mask for valid physical sample sizes
Date: Wed, 2 Jul 2014 16:29:21 +0300
Message-ID: <1404307763-30557-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404307763-30557-1-git-send-email-peter.ujfalusi@ti.com>
References: <1404307763-30557-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the dma_slave_caps's addr_widths queried from the dma driver
prepare the hw.formats mask to include only formats which is supported by
the DMA engine.
In case the dma driver does not implement the slave_caps the default
assumption is that it supports 1, 2 and 4 bytes widths.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/soc-generic-dmaengine-pcm.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index 5bace124ef43..c295e1754d1a 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -119,7 +119,10 @@ static int dmaengine_pcm_set_runtime_hwparams(struct snd_pcm_substream *substrea
 	struct snd_dmaengine_dai_dma_data *dma_data;
 	struct dma_slave_caps dma_caps;
 	struct snd_pcm_hardware hw;
-	int ret;
+	u32 addr_widths = BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |
+			  BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |
+			  BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	int i, ret;
 
 	if (pcm->config && pcm->config->pcm_hardware)
 		return snd_soc_set_runtime_hwparams(substream,
@@ -146,6 +149,27 @@ static int dmaengine_pcm_set_runtime_hwparams(struct snd_pcm_substream *substrea
 			hw.info |= SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME;
 		if (dma_caps.residue_granularity <= DMA_RESIDUE_GRANULARITY_SEGMENT)
 			hw.info |= SNDRV_PCM_INFO_BATCH;
+
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			addr_widths = dma_caps.dstn_addr_widths;
+		else
+			addr_widths = dma_caps.src_addr_widths;
+	}
+
+	/*
+	 * Prepare formats mask for valid/allowed sample types. If the dma does
+	 * not have support for the given physical word size, it needs to be
+	 * masked out so user space can not use the format which produces
+	 * corrupted audio.
+	 * In case the dma driver does not implement the slave_caps the default
+	 * assumption is that it supports 1, 2 and 4 bytes widths.
+	 */
+	for (i = 0; i <= SNDRV_PCM_FORMAT_LAST; i++) {
+		int bits = snd_pcm_format_physical_width(i);
+
+		/* Enable only samples with DMA supported physical widths */
+		if (addr_widths & BIT(bits / 8))
+			hw.formats |= (1LL << i);
 	}
 
 	return snd_soc_set_runtime_hwparams(substream, &hw);
-- 
2.0.0

