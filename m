Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaCMJVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:21:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57663 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbaCMJUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:20:21 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <nsekhar@ti.com>,
        Jyri Sarha <jsarha@ti.com>, <mporter@linaro.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Subject: [PATCH 16/18] ASoC: davinci-mcasp: Provide correct filter_data for dmaengine for non-DT boot
Date: Thu, 13 Mar 2014 11:18:38 +0200
Message-ID: <1394702320-21743-17-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we boot with non-DT mode the damengine will need the channel number and
a filter function in order to get the channel.
The filter_data is filled in the DAI driver while the filter_function will
be provided by the edma-pcm driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/davinci/davinci-mcasp.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 604aa982f5c4..5428615413e2 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -1029,6 +1029,7 @@ nodata:
 static int davinci_mcasp_probe(struct platform_device *pdev)
 {
 	struct davinci_pcm_dma_params *dma_params;
+	struct snd_dmaengine_dai_dma_data *dma_data;
 	struct resource *mem, *ioarea, *res, *dat;
 	struct davinci_mcasp_pdata *pdata;
 	struct davinci_mcasp *mcasp;
@@ -1098,6 +1099,7 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 		mcasp->dat_port = true;
 
 	dma_params = &mcasp->dma_params[SNDRV_PCM_STREAM_PLAYBACK];
+	dma_data = &mcasp->dma_data[SNDRV_PCM_STREAM_PLAYBACK];
 	dma_params->asp_chan_q = pdata->asp_chan_q;
 	dma_params->ram_chan_q = pdata->ram_chan_q;
 	dma_params->sram_pool = pdata->sram_pool;
@@ -1108,7 +1110,7 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 		dma_params->dma_addr = mem->start + pdata->tx_dma_offset;
 
 	/* Unconditional dmaengine stuff */
-	mcasp->dma_data[SNDRV_PCM_STREAM_PLAYBACK].addr = dma_params->dma_addr;
+	dma_data->addr = dma_params->dma_addr;
 
 	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 	if (res)
@@ -1116,7 +1118,14 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	else
 		dma_params->channel = pdata->tx_dma_channel;
 
+	/* dmaengine filter data for DT and non-DT boot */
+	if (pdev->dev.of_node)
+		dma_data->filter_data = "tx";
+	else
+		dma_data->filter_data = &dma_params->channel;
+
 	dma_params = &mcasp->dma_params[SNDRV_PCM_STREAM_CAPTURE];
+	dma_data = &mcasp->dma_data[SNDRV_PCM_STREAM_CAPTURE];
 	dma_params->asp_chan_q = pdata->asp_chan_q;
 	dma_params->ram_chan_q = pdata->ram_chan_q;
 	dma_params->sram_pool = pdata->sram_pool;
@@ -1127,7 +1136,7 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 		dma_params->dma_addr = mem->start + pdata->rx_dma_offset;
 
 	/* Unconditional dmaengine stuff */
-	mcasp->dma_data[SNDRV_PCM_STREAM_CAPTURE].addr = dma_params->dma_addr;
+	dma_data->addr = dma_params->dma_addr;
 
 	if (mcasp->version < MCASP_VERSION_3) {
 		mcasp->fifo_base = DAVINCI_MCASP_V2_AFIFO_BASE;
@@ -1143,9 +1152,11 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	else
 		dma_params->channel = pdata->rx_dma_channel;
 
-	/* Unconditional dmaengine stuff */
-	mcasp->dma_data[SNDRV_PCM_STREAM_PLAYBACK].filter_data = "tx";
-	mcasp->dma_data[SNDRV_PCM_STREAM_CAPTURE].filter_data = "rx";
+	/* dmaengine filter data for DT and non-DT boot */
+	if (pdev->dev.of_node)
+		dma_data->filter_data = "rx";
+	else
+		dma_data->filter_data = &dma_params->channel;
 
 	dev_set_drvdata(&pdev->dev, mcasp);
 
-- 
1.9.0

