Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab3G3Jyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:54:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53050 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab3G3Jco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 030/106] ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call
Date: Tue, 30 Jul 2013 10:30:49 +0100
Message-Id: <1375176725-5825-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 46f6c1aaf790be9ea3c8ddfc8f235a5f677d08e2 upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Acked-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/arm/pxa2xx-pcm-lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/arm/pxa2xx-pcm-lib.c b/sound/arm/pxa2xx-pcm-lib.c
index 76e0d56..823359e 100644
--- a/sound/arm/pxa2xx-pcm-lib.c
+++ b/sound/arm/pxa2xx-pcm-lib.c
@@ -166,7 +166,9 @@ void pxa2xx_pcm_dma_irq(int dma_ch, void *dev_id)
 	} else {
 		printk(KERN_ERR "%s: DMA error on channel %d (DCSR=%#x)\n",
 			rtd->params->name, dma_ch, dcsr);
+		snd_pcm_stream_lock(substream);
 		snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
+		snd_pcm_stream_unlock(substream);
 	}
 }
 EXPORT_SYMBOL(pxa2xx_pcm_dma_irq);
-- 
1.8.3.2

