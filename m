Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3KOQoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:44:34 -0500
Received: from skyrme.org ([193.175.80.135]:41332 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab3KOQo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:44:28 -0500
Date: 15 Nov 2013 16:44:23 +0000
Message-Id: <1384533863-14288-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Liam Girdwood" <lgirdwood@gmail.com>
Cc: "Fabio Estevam" <fabio.estevam@freescale.com>,
        "Mark Brown" <broonie@kernel.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH] ASoC: fsl: imx-ssi: omit ssi counter to avoid harm in unbalanced situation
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unbalanced calls to imx_ssi_trigger() may result in endless
SSI activity and thus provoke eternal sound. While on the first glance,
the switch statement looks pretty symmetric, the SUSPEND/RESUME
pair is not: the suspend case comes along snd_pcm_suspend_all(),
which for fsl/imx-pcm-fiq is called only at snd_soc_suspend(),
but the resume case originates straight from the SNDRV_PCM_IOCTL_RESUME.
This way userland may provoke an unbalanced resume, which might cause
the ssi->enabled counter to increase and never return to zero again,
so eventually SSI_SCR_SSIEN is never disabled.

Simply removing the ssi->enabled will solve the problem, as long as
one never goes play and capture game simultaneously, but beware
trying both at once, the early TRIGGER_STOP will cut off the other
activity prematurely. So now playing and capturing is scrutinized
separately, instead of by counting.

This is essentially the same stuff as in sound/soc/fsl/imx-pcm-fiq.c
which I send a patch for three days ago. Astonishing enough this
highly fragile scheme is used twice in parallel to serve the very
same control function, synchronously: Once out of sync you are lost
until reboot.

Note, that these fixes wont prevent state machine distortion on alsa
level to cut sound or the like. It just makes sure we have a chance
to synchronise again later on.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 sound/soc/fsl/imx-ssi.c |   19 ++++++++++++-------
 sound/soc/fsl/imx-ssi.h |    3 ++-
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/sound/soc/fsl/imx-ssi.c b/sound/soc/fsl/imx-ssi.c
index f5f248c..c68499b 100644
--- a/sound/soc/fsl/imx-ssi.c
+++ b/sound/soc/fsl/imx-ssi.c
@@ -298,27 +298,32 @@ static int imx_ssi_trigger(struct snd_pcm_substream *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 			scr |= SSI_SCR_TE;
-		else
+			ssi->playing = 1;
+		} else {
 			scr |= SSI_SCR_RE;
+			ssi->capturing = 1;
+		}
 		sier |= sier_bits;
 
-		if (++ssi->enabled == 1)
-			scr |= SSI_SCR_SSIEN;
+		scr |= SSI_SCR_SSIEN;
 
 		break;
 
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 			scr &= ~SSI_SCR_TE;
-		else
+			ssi->playing = 0;
+		} else {
 			scr &= ~SSI_SCR_RE;
+			ssi->capturing = 0;
+		}
 		sier &= ~sier_bits;
 
-		if (--ssi->enabled == 0)
+		if (!ssi->playing && !ssi->capturing)
 			scr &= ~SSI_SCR_SSIEN;
 
 		break;
diff --git a/sound/soc/fsl/imx-ssi.h b/sound/soc/fsl/imx-ssi.h
index 560c40f..a3c90d5 100644
--- a/sound/soc/fsl/imx-ssi.h
+++ b/sound/soc/fsl/imx-ssi.h
@@ -213,7 +213,8 @@ struct imx_ssi {
 
 	int fiq_init;
 	int dma_init;
-	int enabled;
+	int playing;
+	int capturing;
 };
 
 #endif /* _IMX_SSI_H */
-- 
1.7.9.5

