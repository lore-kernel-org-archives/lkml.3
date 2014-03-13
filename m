Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaCMJUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:20:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52023 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757AbaCMJUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:20:19 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <nsekhar@ti.com>,
        Jyri Sarha <jsarha@ti.com>, <mporter@linaro.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Subject: [PATCH 17/18] ASoC: davinci-mcasp: Assign the dma_data earlier in dai_probe callback
Date: Thu, 13 Mar 2014 11:18:39 +0200
Message-ID: <1394702320-21743-18-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the dai startup callback and do the dma_data setup for dmaengine
in the dai_probe function.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/davinci/davinci-mcasp.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 5428615413e2..958933614ca4 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -717,31 +717,33 @@ static int davinci_mcasp_trigger(struct snd_pcm_substream *substream,
 	return ret;
 }
 
-static int davinci_mcasp_startup(struct snd_pcm_substream *substream,
-				 struct snd_soc_dai *dai)
+static const struct snd_soc_dai_ops davinci_mcasp_dai_ops = {
+	.trigger	= davinci_mcasp_trigger,
+	.hw_params	= davinci_mcasp_hw_params,
+	.set_fmt	= davinci_mcasp_set_dai_fmt,
+	.set_clkdiv	= davinci_mcasp_set_clkdiv,
+	.set_sysclk	= davinci_mcasp_set_sysclk,
+};
+
+static int davinci_mcasp_dai_probe(struct snd_soc_dai *dai)
 {
 	struct davinci_mcasp *mcasp = snd_soc_dai_get_drvdata(dai);
 
-	if (mcasp->version >= MCASP_VERSION_3)
+	if (mcasp->version >= MCASP_VERSION_3) {
 		/* Using dmaengine PCM */
-		snd_soc_dai_set_dma_data(dai, substream,
-					&mcasp->dma_data[substream->stream]);
-	else
+		dai->playback_dma_data =
+				&mcasp->dma_data[SNDRV_PCM_STREAM_PLAYBACK];
+		dai->capture_dma_data =
+				&mcasp->dma_data[SNDRV_PCM_STREAM_CAPTURE];
+	} else {
 		/* Using davinci-pcm */
-		snd_soc_dai_set_dma_data(dai, substream, mcasp->dma_params);
+		dai->playback_dma_data = mcasp->dma_params;
+		dai->capture_dma_data = mcasp->dma_params;
+	}
 
 	return 0;
 }
 
-static const struct snd_soc_dai_ops davinci_mcasp_dai_ops = {
-	.startup	= davinci_mcasp_startup,
-	.trigger	= davinci_mcasp_trigger,
-	.hw_params	= davinci_mcasp_hw_params,
-	.set_fmt	= davinci_mcasp_set_dai_fmt,
-	.set_clkdiv	= davinci_mcasp_set_clkdiv,
-	.set_sysclk	= davinci_mcasp_set_sysclk,
-};
-
 #ifdef CONFIG_PM_SLEEP
 static int davinci_mcasp_suspend(struct snd_soc_dai *dai)
 {
@@ -795,6 +797,7 @@ static int davinci_mcasp_resume(struct snd_soc_dai *dai)
 static struct snd_soc_dai_driver davinci_mcasp_dai[] = {
 	{
 		.name		= "davinci-mcasp.0",
+		.probe		= davinci_mcasp_dai_probe,
 		.suspend	= davinci_mcasp_suspend,
 		.resume		= davinci_mcasp_resume,
 		.playback	= {
-- 
1.9.0

