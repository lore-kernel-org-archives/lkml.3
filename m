Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab3G3J4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:56:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53033 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab3G3Jcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 026/106] ALSA: atiixp: Fix unlocked snd_pcm_stop() call
Date: Tue, 30 Jul 2013 10:30:45 +0100
Message-Id: <1375176725-5825-27-git-send-email-luis.henriques@canonical.com>
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

commit cc7282b8d5abbd48c81d1465925d464d9e3eaa8f upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/atiixp.c       | 2 ++
 sound/pci/atiixp_modem.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 156a94f..e0ed83a 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -688,7 +688,9 @@ static void snd_atiixp_xrun_dma(struct atiixp *chip, struct atiixp_dma *dma)
 	if (! dma->substream || ! dma->running)
 		return;
 	snd_printdd("atiixp: XRUN detected (DMA %d)\n", dma->ops->type);
+	snd_pcm_stream_lock(dma->substream);
 	snd_pcm_stop(dma->substream, SNDRV_PCM_STATE_XRUN);
+	snd_pcm_stream_unlock(dma->substream);
 }
 
 /*
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index 30a4fd9..f68704c 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -638,7 +638,9 @@ static void snd_atiixp_xrun_dma(struct atiixp_modem *chip,
 	if (! dma->substream || ! dma->running)
 		return;
 	snd_printdd("atiixp-modem: XRUN detected (DMA %d)\n", dma->ops->type);
+	snd_pcm_stream_lock(dma->substream);
 	snd_pcm_stop(dma->substream, SNDRV_PCM_STATE_XRUN);
+	snd_pcm_stream_unlock(dma->substream);
 }
 
 /*
-- 
1.8.3.2

