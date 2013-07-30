Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab3G3PVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:21:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab3G3PUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:20:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 26/75] ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call
Date: Tue, 30 Jul 2013 08:16:55 -0700
Message-Id: <1375197464-27962-27-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 46f6c1aaf790be9ea3c8ddfc8f235a5f677d08e2 upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Acked-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.1.2

