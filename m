Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaCMJU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:20:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33208 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbaCMJUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:20:22 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <nsekhar@ti.com>,
        Jyri Sarha <jsarha@ti.com>, <mporter@linaro.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Subject: [PATCH 18/18] ASoC: davinci-mcasp: Place constraint on the period size based on FIFO config
Date: Thu, 13 Mar 2014 11:18:40 +0200
Message-ID: <1394702320-21743-19-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to place constraint on the period size (and indirectly to buffer
size) if the read or write AFIFO is enabled and it is configured for more
than one word otherwise the DMA will fail in buffer configuration where
the sizes are not aligned with the requested FIFO configuration.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/davinci/davinci-mcasp.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 958933614ca4..17d1112bce24 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -717,7 +717,27 @@ static int davinci_mcasp_trigger(struct snd_pcm_substream *substream,
 	return ret;
 }
 
+static int davinci_mcasp_startup(struct snd_pcm_substream *substream,
+				 struct snd_soc_dai *cpu_dai)
+{
+	struct davinci_mcasp *mcasp = snd_soc_dai_get_drvdata(cpu_dai);
+	int afifo_numevt;
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		afifo_numevt = mcasp->txnumevt;
+	else
+		afifo_numevt = mcasp->rxnumevt;
+
+	if (afifo_numevt > 1)
+		snd_pcm_hw_constraint_step(substream->runtime, 0,
+					   SNDRV_PCM_HW_PARAM_PERIOD_SIZE,
+					   afifo_numevt);
+
+	return 0;
+}
+
 static const struct snd_soc_dai_ops davinci_mcasp_dai_ops = {
+	.startup	= davinci_mcasp_startup,
 	.trigger	= davinci_mcasp_trigger,
 	.hw_params	= davinci_mcasp_hw_params,
 	.set_fmt	= davinci_mcasp_set_dai_fmt,
-- 
1.9.0

