Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbbA2KQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:16:59 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:60305 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033AbbA2KQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:16:53 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: alsa-devel@alsa-project.org
Cc: Peter Rosin <peda@axentia.se>, Bo Shen <voice.shen@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: atmel_ssc_dai: Support SND_SOC_DAIFMT_CBM_CFS on I2S
Date: Thu, 29 Jan 2015 11:16:29 +0100
Message-Id: <1422526589-9451-1-git-send-email-peda@lysator.liu.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 sound/soc/atmel/atmel_ssc_dai.c |   48 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index 3cd70597d109..f55f3aab8bdd 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -485,6 +485,54 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 			| SSC_BF(TFMR_DATLEN, (bits - 1));
 		break;
 
+	case SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_CBM_CFS:
+		/* I2S format, CODEC supplies BCLK, SSC supplies LRCLK. */
+		if (bits > 16 && !ssc->pdata->has_fslen_ext) {
+			dev_err(dai->dev,
+				"sample size %d is too large for SSC device\n",
+				bits);
+			return -EINVAL;
+		}
+
+		fslen_ext = (bits - 1) / 16;
+		fslen = (bits - 1) % 16;
+
+		rcmr =	  SSC_BF(RCMR_PERIOD, ssc_p->rcmr_period)
+			| SSC_BF(RCMR_STTDLY, START_DELAY)
+			| SSC_BF(RCMR_START, SSC_START_FALLING_RF)
+			| SSC_BF(RCMR_CKI, SSC_CKI_RISING)
+			| SSC_BF(RCMR_CKO, SSC_CKO_NONE)
+			| SSC_BF(RCMR_CKS, ssc->clk_from_rk_pin ?
+					   SSC_CKS_PIN : SSC_CKS_CLOCK);
+
+		rfmr =    SSC_BF(RFMR_FSLEN_EXT, fslen_ext)
+			| SSC_BF(RFMR_FSEDGE, SSC_FSEDGE_POSITIVE)
+			| SSC_BF(RFMR_FSOS, SSC_FSOS_NEGATIVE)
+			| SSC_BF(RFMR_FSLEN, fslen)
+			| SSC_BF(RFMR_DATNB, (channels - 1))
+			| SSC_BIT(RFMR_MSBF)
+			| SSC_BF(RFMR_LOOP, 0)
+			| SSC_BF(RFMR_DATLEN, (bits - 1));
+
+		tcmr =	  SSC_BF(TCMR_PERIOD, ssc_p->tcmr_period)
+			| SSC_BF(TCMR_STTDLY, START_DELAY)
+			| SSC_BF(TCMR_START, SSC_START_FALLING_RF)
+			| SSC_BF(TCMR_CKI, SSC_CKI_FALLING)
+			| SSC_BF(TCMR_CKO, SSC_CKO_NONE)
+			| SSC_BF(TCMR_CKS, ssc->clk_from_rk_pin ?
+					   SSC_CKS_CLOCK : SSC_CKS_PIN);
+
+		tfmr =    SSC_BF(TFMR_FSLEN_EXT, fslen_ext)
+			| SSC_BF(TFMR_FSEDGE, SSC_FSEDGE_NEGATIVE)
+			| SSC_BF(TFMR_FSDEN, 0)
+			| SSC_BF(TFMR_FSOS, SSC_FSOS_NEGATIVE)
+			| SSC_BF(TFMR_FSLEN, fslen)
+			| SSC_BF(TFMR_DATNB, (channels - 1))
+			| SSC_BIT(TFMR_MSBF)
+			| SSC_BF(TFMR_DATDEF, 0)
+			| SSC_BF(TFMR_DATLEN, (bits - 1));
+		break;
+
 	case SND_SOC_DAIFMT_DSP_A | SND_SOC_DAIFMT_CBS_CFS:
 		/*
 		 * DSP/PCM Mode A format, SSC provides BCLK and LRC clocks.
-- 
1.7.10.4

