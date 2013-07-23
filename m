Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654Ab3GWWqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:46:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934626Ab3GWW12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Brown <broonie@linaro.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ 047/103] ASoC: atmel: Fix unlocked snd_pcm_stop() call
Date: Tue, 23 Jul 2013 15:25:58 -0700
Message-Id: <20130723220423.816958744@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 571185717f8d7f2a088a7ac38d94a9ad5fd9da5c upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Acked-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/atmel/atmel-pcm-dma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/atmel/atmel-pcm-dma.c
+++ b/sound/soc/atmel/atmel-pcm-dma.c
@@ -81,7 +81,9 @@ static void atmel_pcm_dma_irq(u32 ssc_sr
 
 		/* stop RX and capture: will be enabled again at restart */
 		ssc_writex(prtd->ssc->regs, SSC_CR, prtd->mask->ssc_disable);
+		snd_pcm_stream_lock(substream);
 		snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
+		snd_pcm_stream_unlock(substream);
 
 		/* now drain RHR and read status to remove xrun condition */
 		ssc_readx(prtd->ssc->regs, SSC_RHR);


