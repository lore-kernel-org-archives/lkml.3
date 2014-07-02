Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaGBLaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:30:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46298 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbaGBL34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:29:56 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>, <lars@metafoo.de>,
        <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, <joelf@ti.com>, <nsekhar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH 4/4] ALSA: pcm_dmaengine: Correct support for 3 physical bytes samples
Date: Wed, 2 Jul 2014 14:29:30 +0300
Message-ID: <1404300570-14082-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404300570-14082-1-git-send-email-peter.ujfalusi@ti.com>
References: <1404300570-14082-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of _3LE/_3BE formats the samples are stored in 3 consecutive bytes
without padding it to 4 bytes. This means that the DMA needs to be able to
support 3 bytes word length in order to read/write the samples from memory
correctly. Originally the code treated 24 bits physical length samples as
they were 32 bits which leads to corruption when playing or recording audio.

In snd_dmaengine_pcm_open() we should check the slave_caps of the dma if it
supports DMA_SLAVE_BUSWIDTH_3_BYTES. Based on this information we initialize
the runtime->hw.formats: if DMA_SLAVE_BUSWIDTH_3_BYTES is not supported or
the slave_caps is not provided by the driver we mask out the 24 bits
physical width sample formats so they will be not available for user space
to pick. If the DMA_SLAVE_BUSWIDTH_3_BYTES is supported _3LE/_3BE formats
will not be masked so later on they can be valid if both CPU and codec dai
supports them.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/core/pcm_dmaengine.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/sound/core/pcm_dmaengine.c b/sound/core/pcm_dmaengine.c
index d5611ec80381..519b500c5669 100644
--- a/sound/core/pcm_dmaengine.c
+++ b/sound/core/pcm_dmaengine.c
@@ -72,6 +72,8 @@ int snd_hwparams_to_dma_slave_config(const struct snd_pcm_substream *substream,
 		buswidth = DMA_SLAVE_BUSWIDTH_1_BYTE;
 	else if (bits == 16)
 		buswidth = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	else if (bits == 24)
+		buswidth = DMA_SLAVE_BUSWIDTH_3_BYTES;
 	else if (bits <= 32)
 		buswidth = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	else
@@ -292,8 +294,12 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_request_channel);
 int snd_dmaengine_pcm_open(struct snd_pcm_substream *substream,
 	struct dma_chan *chan)
 {
+	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct dmaengine_pcm_runtime_data *prtd;
-	int ret;
+	struct dma_slave_caps dma_caps;
+	bool dma_3bytes_supported = false;
+	u64 fmt_mask = 0;
+	int i, ret;
 
 	if (!chan)
 		return -ENXIO;
@@ -311,6 +317,37 @@ int snd_dmaengine_pcm_open(struct snd_pcm_substream *substream,
 
 	substream->runtime->private_data = prtd;
 
+	/*
+	 * Prepare formats mask for valid/allowed sample types. If the dma does
+	 * not support 3bytes word size, it needs to be masked out so user space
+	 * can not use the format which produces corrupted audio.
+	 * If the dma driver does not implement get_slave_caps callback, treat
+	 * it as no 3bytes word support.
+	 */
+	if (!dma_get_slave_caps(prtd->dma_chan, &dma_caps)) {
+		u32 addr_widths;
+
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			addr_widths = dma_caps.dstn_addr_widths;
+		else
+			addr_widths = dma_caps.src_addr_widths;
+
+		if (addr_widths & BIT(DMA_SLAVE_BUSWIDTH_3_BYTES))
+			dma_3bytes_supported = true;
+	}
+
+	for (i = 0; i <= SNDRV_PCM_FORMAT_LAST; i++) {
+		int bits = snd_pcm_format_physical_width(i);
+
+		if (bits == 24 && !dma_3bytes_supported)
+			fmt_mask |= (1LL << i);
+	}
+
+	if (runtime->hw.formats)
+		runtime->hw.formats &= ~fmt_mask;
+	else
+		runtime->hw.formats = ~fmt_mask;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_open);
-- 
2.0.0

