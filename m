Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaJKQQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:16:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:4935 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbaJKQP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:15:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="398750344"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] ASoC: txx9: use dmaengine_terminate_all() API
Date: Sat, 11 Oct 2014 21:10:39 +0530
Message-Id: <1413042040-28222-11-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers should use dmaengine_terminate_all() API instead of
accessing the device_control which will be deprecated soon

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 sound/soc/txx9/txx9aclc.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/txx9/txx9aclc.c b/sound/soc/txx9/txx9aclc.c
index f0829de..3b122cd 100644
--- a/sound/soc/txx9/txx9aclc.c
+++ b/sound/soc/txx9/txx9aclc.c
@@ -160,7 +160,7 @@ static void txx9aclc_dma_tasklet(unsigned long data)
 		void __iomem *base = drvdata->base;
 
 		spin_unlock_irqrestore(&dmadata->dma_lock, flags);
-		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+		dmaengine_terminate_all(chan);
 		/* first time */
 		for (i = 0; i < NR_DMA_CHAIN; i++) {
 			desc = txx9aclc_dma_submit(dmadata,
@@ -266,7 +266,7 @@ static int txx9aclc_pcm_close(struct snd_pcm_substream *substream)
 	struct dma_chan *chan = dmadata->dma_chan;
 
 	dmadata->frag_count = -1;
-	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+	dmaengine_terminate_all(chan);
 	return 0;
 }
 
@@ -398,8 +398,7 @@ static int txx9aclc_pcm_remove(struct snd_soc_platform *platform)
 		struct dma_chan *chan = dmadata->dma_chan;
 		if (chan) {
 			dmadata->frag_count = -1;
-			chan->device->device_control(chan,
-						     DMA_TERMINATE_ALL, 0);
+			dmaengine_terminate_all(chan);
 			dma_release_channel(chan);
 		}
 		dev->dmadata[i].dma_chan = NULL;
-- 
1.7.0.4

