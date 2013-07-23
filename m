Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934767Ab3GWWtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:49:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934584Ab3GWW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 036/103] ALSA: atiixp: Fix unlocked snd_pcm_stop() call
Date: Tue, 23 Jul 2013 15:25:47 -0700
Message-Id: <20130723220422.608646116@linuxfoundation.org>
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

commit cc7282b8d5abbd48c81d1465925d464d9e3eaa8f upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/atiixp.c       |    2 ++
 sound/pci/atiixp_modem.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -689,7 +689,9 @@ static void snd_atiixp_xrun_dma(struct a
 	if (! dma->substream || ! dma->running)
 		return;
 	snd_printdd("atiixp: XRUN detected (DMA %d)\n", dma->ops->type);
+	snd_pcm_stream_lock(dma->substream);
 	snd_pcm_stop(dma->substream, SNDRV_PCM_STATE_XRUN);
+	snd_pcm_stream_unlock(dma->substream);
 }
 
 /*
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -638,7 +638,9 @@ static void snd_atiixp_xrun_dma(struct a
 	if (! dma->substream || ! dma->running)
 		return;
 	snd_printdd("atiixp-modem: XRUN detected (DMA %d)\n", dma->ops->type);
+	snd_pcm_stream_lock(dma->substream);
 	snd_pcm_stop(dma->substream, SNDRV_PCM_STATE_XRUN);
+	snd_pcm_stream_unlock(dma->substream);
 }
 
 /*


