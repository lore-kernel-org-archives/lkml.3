Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab3G3Jyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:54:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53054 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758677Ab3G3Jcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 031/106] ASoC: s6000: Fix unlocked snd_pcm_stop() call
Date: Tue, 30 Jul 2013 10:30:50 +0100
Message-Id: <1375176725-5825-32-git-send-email-luis.henriques@canonical.com>
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

commit 61be2b9a18ec70f3cbe3deef7a5f77869c71b5ae upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Acked-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/s6000/s6000-pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/s6000/s6000-pcm.c b/sound/soc/s6000/s6000-pcm.c
index 716da86..17f9348 100644
--- a/sound/soc/s6000/s6000-pcm.c
+++ b/sound/soc/s6000/s6000-pcm.c
@@ -128,7 +128,9 @@ static irqreturn_t s6000_pcm_irq(int irq, void *data)
 		    substream->runtime &&
 		    snd_pcm_running(substream)) {
 			dev_dbg(pcm->dev, "xrun\n");
+			snd_pcm_stream_lock(substream);
 			snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
+			snd_pcm_stream_unlock(substream);
 			ret = IRQ_HANDLED;
 		}
 
-- 
1.8.3.2

