Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab3KPHwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 02:52:35 -0500
Received: from skyrme.org ([193.175.80.135]:55989 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab3KPHw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 02:52:29 -0500
Date: 16 Nov 2013 07:52:25 +0000
Message-Id: <1384588345-22276-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Liam Girdwood" <lgirdwood@gmail.com>
Cc: "Fabio Estevam" <fabio.estevam@freescale.com>,
        "Mark Brown" <broonie@kernel.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCHv2] ASoC: fsl: imx-ssi: omit ssi counter to avoid harm in unbalanced situation
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1384533863-14288-1-git-send-email-oskar@scara.com>
References: <1384533863-14288-1-git-send-email-oskar@scara.com>
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

As the information on whether to enable the SSI or not is contained
in the two bits for TE/RE, we save all the software mirroring of
hardware state here and simply use the hardware register itself
to keep the state of whether someone is currently playing or capturing.

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
v2: drop all software flag handling in favour of hardware registers

 sound/soc/fsl/imx-ssi.c |    5 ++---
 sound/soc/fsl/imx-ssi.h |    1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/imx-ssi.c b/sound/soc/fsl/imx-ssi.c
index f5f248c..2eb2691 100644
--- a/sound/soc/fsl/imx-ssi.c
+++ b/sound/soc/fsl/imx-ssi.c
@@ -304,8 +304,7 @@ static int imx_ssi_trigger(struct snd_pcm_substream *substream, int cmd,
 			scr |= SSI_SCR_RE;
 		sier |= sier_bits;
 
-		if (++ssi->enabled == 1)
-			scr |= SSI_SCR_SSIEN;
+		scr |= SSI_SCR_SSIEN;
 
 		break;
 
@@ -318,7 +317,7 @@ static int imx_ssi_trigger(struct snd_pcm_substream *substream, int cmd,
 			scr &= ~SSI_SCR_RE;
 		sier &= ~sier_bits;
 
-		if (--ssi->enabled == 0)
+		if (!(scr & (SSI_SCR_TE | SSI_SCR_RE)))
 			scr &= ~SSI_SCR_SSIEN;
 
 		break;
diff --git a/sound/soc/fsl/imx-ssi.h b/sound/soc/fsl/imx-ssi.h
index 560c40f..be65623 100644
--- a/sound/soc/fsl/imx-ssi.h
+++ b/sound/soc/fsl/imx-ssi.h
@@ -213,7 +213,6 @@ struct imx_ssi {
 
 	int fiq_init;
 	int dma_init;
-	int enabled;
 };
 
 #endif /* _IMX_SSI_H */
-- 
1.7.9.5

