Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3G3PUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:20:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55363 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3G3PUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:20:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 27/75] ASoC: atmel: Fix unlocked snd_pcm_stop() call
Date: Tue, 30 Jul 2013 08:16:56 -0700
Message-Id: <1375197464-27962-28-git-send-email-kamal@canonical.com>
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

commit 571185717f8d7f2a088a7ac38d94a9ad5fd9da5c upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Acked-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/atmel/atmel-pcm-dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/atmel/atmel-pcm-dma.c b/sound/soc/atmel/atmel-pcm-dma.c
index 30184a4..ffc9ddf 100644
--- a/sound/soc/atmel/atmel-pcm-dma.c
+++ b/sound/soc/atmel/atmel-pcm-dma.c
@@ -80,7 +80,9 @@ static void atmel_pcm_dma_irq(u32 ssc_sr,
 
 		/* stop RX and capture: will be enabled again at restart */
 		ssc_writex(prtd->ssc->regs, SSC_CR, prtd->mask->ssc_disable);
+		snd_pcm_stream_lock(substream);
 		snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
+		snd_pcm_stream_unlock(substream);
 
 		/* now drain RHR and read status to remove xrun condition */
 		ssc_readx(prtd->ssc->regs, SSC_RHR);
-- 
1.8.1.2

