Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbaCHBQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:16:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbaCHBHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 81/99] ALSA: atiixp: Fix unlocked snd_pcm_stop() call
Date: Fri,  7 Mar 2014 17:08:17 -0800
Message-Id: <20140308010614.187026227@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit cc7282b8d5abbd48c81d1465925d464d9e3eaa8f upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/atiixp.c       |    2 ++
 sound/pci/atiixp_modem.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -688,7 +688,9 @@ static void snd_atiixp_xrun_dma(struct a
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


