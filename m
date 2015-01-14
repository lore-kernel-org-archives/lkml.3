Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbbANImr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:42:47 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:29158 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbbANImo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:42:44 -0500
From: Qais Yousef <qais.yousef@imgtec.com>
To: <alsa-devel@alsa-project.org>
CC: Qais Yousef <qais.yousef@imgtec.com>, Vinod Koul <vinod.koul@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] ALSA: ASoC: soc-compress.c: fix NULL dereference
Date: Wed, 14 Jan 2015 08:42:22 +0000
Message-ID: <1421224942-19083-1-git-send-email-qais.yousef@imgtec.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In soc_new_compress() when rtd->dai_link->daynamic is set, we create the pcm
substreams with this call:

   ret = snd_pcm_new_internal(rtd->card->snd_card, new_name, num,
                                   1, 0, &be_pcm);

which passes 0 as capture_count leading to

   be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream

being NULL, hence when trying to set rtd a few lines below we get an oops.

Fix by using rtd->dai_link->dpcm_playback and rtd->dai_link->dpcm_capture as
playback_count and capture_count to snd_pcm_new_internal().

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
---
v3->v2:
  - fix a typo s/dynmic/dynamic/ in commit message
  - use if else if because either dpcm_playback or dpcm_capture should be on
    for compressed devices

v2->v1:
   - use better way to fix it than just removing the line that caused the oops

 sound/soc/soc-compress.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index 590a82f01d0b..025c38fbe3c0 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -659,7 +659,8 @@ int soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
 			rtd->dai_link->stream_name);
 
 		ret = snd_pcm_new_internal(rtd->card->snd_card, new_name, num,
-				1, 0, &be_pcm);
+				rtd->dai_link->dpcm_playback,
+				rtd->dai_link->dpcm_capture, &be_pcm);
 		if (ret < 0) {
 			dev_err(rtd->card->dev, "ASoC: can't create compressed for %s\n",
 				rtd->dai_link->name);
@@ -668,8 +669,10 @@ int soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
 
 		rtd->pcm = be_pcm;
 		rtd->fe_compr = 1;
-		be_pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream->private_data = rtd;
-		be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream->private_data = rtd;
+		if (rtd->dai_link->dpcm_playback)
+			be_pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream->private_data = rtd;
+		else if (rtd->dai_link->dpcm_capture)
+			be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream->private_data = rtd;
 		memcpy(compr->ops, &soc_compr_dyn_ops, sizeof(soc_compr_dyn_ops));
 	} else
 		memcpy(compr->ops, &soc_compr_ops, sizeof(soc_compr_ops));
-- 
2.1.0

