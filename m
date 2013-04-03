Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763107Ab3DCJYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:24:04 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5604 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762946Ab3DCJYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:24:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 03 Apr 2013 02:22:12 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <swarren@wwwdotorg.org>
CC: <lars@metafoo.de>, <alsa-devel@alsa-project.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tiwai@suse.de>, <perex@perex.cz>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] sound: soc: tegra: do not provide PAUSE/RESUME in hardware info
Date: Wed, 3 Apr 2013 14:49:41 +0530
Message-ID: <1364980781-2204-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra PCM driver uses the dmaengine based DMA driver and Tegra DMA
driver does not support the pause/resume functionality as hardware
does not support it.

ALSA driver support the sw based pause/resume functionality if hardware
does not support it and in this case, hw driver should not provide
the hardware info with PAUSE/RESUME bit enable.

Remmoving the SNDRV_PCM_INFO_PAUSE and SNDRV_PCM_INFO_RESUME from hardware
info and using the snd_dmaengine_pcm_trigger() for pcm_trigger callback.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Lars reported that if driver/chip dma driver does not support the pause/resume
then need not to export this info through the hw capability and leave this
implementation to alsa driver.

Making the change accordingly.

 sound/soc/tegra/tegra_pcm.c |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/sound/soc/tegra/tegra_pcm.c b/sound/soc/tegra/tegra_pcm.c
index e67af0b..117cccc 100644
--- a/sound/soc/tegra/tegra_pcm.c
+++ b/sound/soc/tegra/tegra_pcm.c
@@ -43,8 +43,6 @@
 static const struct snd_pcm_hardware tegra_pcm_hardware = {
 	.info			= SNDRV_PCM_INFO_MMAP |
 				  SNDRV_PCM_INFO_MMAP_VALID |
-				  SNDRV_PCM_INFO_PAUSE |
-				  SNDRV_PCM_INFO_RESUME |
 				  SNDRV_PCM_INFO_INTERLEAVED,
 	.formats		= SNDRV_PCM_FMTBIT_S16_LE,
 	.channels_min		= 2,
@@ -121,26 +119,6 @@ static int tegra_pcm_hw_free(struct snd_pcm_substream *substream)
 	return 0;
 }
 
-static int tegra_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
-{
-	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_START:
-	case SNDRV_PCM_TRIGGER_RESUME:
-	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		return snd_dmaengine_pcm_trigger(substream,
-					SNDRV_PCM_TRIGGER_START);
-
-	case SNDRV_PCM_TRIGGER_STOP:
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		return snd_dmaengine_pcm_trigger(substream,
-					SNDRV_PCM_TRIGGER_STOP);
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
 static int tegra_pcm_mmap(struct snd_pcm_substream *substream,
 				struct vm_area_struct *vma)
 {
@@ -158,7 +136,7 @@ static struct snd_pcm_ops tegra_pcm_ops = {
 	.ioctl		= snd_pcm_lib_ioctl,
 	.hw_params	= tegra_pcm_hw_params,
 	.hw_free	= tegra_pcm_hw_free,
-	.trigger	= tegra_pcm_trigger,
+	.trigger	= snd_dmaengine_pcm_trigger,
 	.pointer	= snd_dmaengine_pcm_pointer,
 	.mmap		= tegra_pcm_mmap,
 };
-- 
1.7.1.1

