Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab3DWP4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:56:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51152 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3DWPyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:54:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] ASoC: don't call of_dma_request_slave_channel directly
Date: Tue, 23 Apr 2013 17:54:33 +0200
Message-Id: <1366732475-479886-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366732475-479886-1-git-send-email-arnd@arndb.de>
References: <1366732475-479886-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:qXvgaZqJ7+4H+hs7UJNsdz9ltFd22wa/iumv+5jQ+uN
 9ROxaHacgfKeUyNQ+1gXSoH65jhDtcFxiQWX8Lmnkws79KeJVV
 jm1lmfg4pYxOrUuEGfC7rl/8jyO0CG8I9L22gpHkaphmrO+zOm
 fcxUGI7JthB3JT2RFww3vtghYExMLR/RPT4TVRf9YLN5LtBnh6
 hEJYKFb16Pj3jdyXuADc2IMducWRZyzbZUuj+gPlGPg0914t9U
 uUYiJU+XHNa9CE2sfR7zx8u0KBltB+PHfI/Mcv5Wi+Dqf4RifZ
 FSNCKf2B9mqtlFxK5AxBH+OJPAHs4nJIdgtFmumqrZOQ2y/qeY
 lJHBnUeHUFbQh4zzr4oOdXajh4QhUceMzsDDODpcd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exported interface for device drivers is dma_request_slave_channel,
not of_dma_request_slave_channel. The former does not depend on device
tree but also works with ACPI and other interfaces providing an
abstraction for DMA channels.

This fixes link errors when building ALSA as a loadable module.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: alsa-devel@alsa-project.org
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/soc/soc-generic-dmaengine-pcm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index 5fd5ed4..8ee9859 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -219,19 +219,20 @@ static const char * const dmaengine_pcm_dma_channel_names[] = {
 };
 
 static void dmaengine_pcm_request_chan_of(struct dmaengine_pcm *pcm,
-	struct device_node *of_node)
+	struct device *dev)
 {
 	unsigned int i;
+	struct device_node *of_node = dev->of_node;
 
 	if ((pcm->flags & SND_DMAENGINE_PCM_FLAG_NO_DT) || !of_node)
 		return;
 
 	if (pcm->flags & SND_DMAENGINE_PCM_FLAG_HALF_DUPLEX) {
-		pcm->chan[0] = of_dma_request_slave_channel(of_node, "tx_rx");
+		pcm->chan[0] = dma_request_slave_channel(dev, "tx_rx");
 		pcm->chan[1] = pcm->chan[0];
 	} else {
 		for (i = SNDRV_PCM_STREAM_PLAYBACK; i <= SNDRV_PCM_STREAM_CAPTURE; i++) {
-			pcm->chan[i] = of_dma_request_slave_channel(of_node,
+			pcm->chan[i] = dma_request_slave_channel(dev,
 					dmaengine_pcm_dma_channel_names[i]);
 		}
 	}
@@ -255,7 +256,7 @@ int snd_dmaengine_pcm_register(struct device *dev,
 	pcm->config = config;
 	pcm->flags = flags;
 
-	dmaengine_pcm_request_chan_of(pcm, dev->of_node);
+	dmaengine_pcm_request_chan_of(pcm, dev);
 
 	if (flags & SND_DMAENGINE_PCM_FLAG_NO_RESIDUE)
 		return snd_soc_add_platform(dev, &pcm->platform,
-- 
1.8.1.2

