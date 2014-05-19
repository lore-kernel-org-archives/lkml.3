Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaESJZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:25:58 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:56700 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaESJZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:25:56 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Cc: tiwai@suse.de, perex@perex.cz, lars@metafoo.de
Subject: [PATCH] ALSA: pcm_dmaengine: Add check during device suspend
Date: Mon, 19 May 2014 14:53:53 +0530
Message-Id: <1400491433-16860-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently snd_dmaengine_pcm_trigger() calls dmaengine_pause()
unconditinally during device suspend. In case where DMA controller
doesn't support PAUSE/RESUME functionality, this call is not able
to stop the DMA controller. In this scenario, audio playback doesn't
resume after device resume.

Calling dmaengine_pause/dmaengine_terminate_all conditionally fixes
the issue.

It has been tested with audio playback on Samsung platform having
PL330 DMA controller which doesn't support PAUSE/RESUME.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 sound/core/pcm_dmaengine.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/core/pcm_dmaengine.c b/sound/core/pcm_dmaengine.c
index 94d0873..76cbb9e 100644
--- a/sound/core/pcm_dmaengine.c
+++ b/sound/core/pcm_dmaengine.c
@@ -182,6 +182,7 @@ static int dmaengine_pcm_prepare_and_submit(struct snd_pcm_substream *substream)
 int snd_dmaengine_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 {
 	struct dmaengine_pcm_runtime_data *prtd = substream_to_prtd(substream);
+	struct snd_pcm_runtime *runtime = substream->runtime;
 	int ret;
 
 	switch (cmd) {
@@ -196,6 +197,11 @@ int snd_dmaengine_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 		dmaengine_resume(prtd->dma_chan);
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
+		if (runtime->info & SNDRV_PCM_INFO_PAUSE)
+			dmaengine_pause(prtd->dma_chan);
+		else
+			dmaengine_terminate_all(prtd->dma_chan);
+		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		dmaengine_pause(prtd->dma_chan);
 		break;
-- 
1.7.9.5

