Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161070AbaDKK3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:29:42 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:33666
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965201AbaDKK2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:28:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: fsl_sai: Use FSL_SAI_xXR() and regmap_update_bits() to simplify code
Date: Fri, 11 Apr 2014 18:30:09 +0800
Message-ID: <1397212209-7843-1-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By doing this, the driver can drop around 50 lines and become neater.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 101 ++++++++++++------------------------------------
 1 file changed, 25 insertions(+), 76 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 5fff2e1..9858d42 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -93,16 +93,8 @@ static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai *cpu_dai,
 		int clk_id, unsigned int freq, int fsl_dir)
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
-	u32 val_cr2, reg_cr2;
-
-	if (fsl_dir == FSL_FMT_TRANSMITTER)
-		reg_cr2 = FSL_SAI_TCR2;
-	else
-		reg_cr2 = FSL_SAI_RCR2;
-
-	regmap_read(sai->regmap, reg_cr2, &val_cr2);
-
-	val_cr2 &= ~FSL_SAI_CR2_MSEL_MASK;
+	bool tx = fsl_dir == FSL_FMT_TRANSMITTER;
+	u32 val_cr2 = 0;
 
 	switch (clk_id) {
 	case FSL_SAI_CLK_BUS:
@@ -121,7 +113,8 @@ static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai *cpu_dai,
 		return -EINVAL;
 	}
 
-	regmap_write(sai->regmap, reg_cr2, val_cr2);
+	regmap_update_bits(sai->regmap, FSL_SAI_xCR2(tx),
+			   FSL_SAI_CR2_MSEL_MASK, val_cr2);
 
 	return 0;
 }
@@ -153,22 +146,10 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 				unsigned int fmt, int fsl_dir)
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
-	u32 val_cr2, val_cr4, reg_cr2, reg_cr4;
-
-	if (fsl_dir == FSL_FMT_TRANSMITTER) {
-		reg_cr2 = FSL_SAI_TCR2;
-		reg_cr4 = FSL_SAI_TCR4;
-	} else {
-		reg_cr2 = FSL_SAI_RCR2;
-		reg_cr4 = FSL_SAI_RCR4;
-	}
+	bool tx = fsl_dir == FSL_FMT_TRANSMITTER;
+	u32 val_cr2 = 0, val_cr4 = 0;
 
-	regmap_read(sai->regmap, reg_cr2, &val_cr2);
-	regmap_read(sai->regmap, reg_cr4, &val_cr4);
-
-	if (sai->big_endian_data)
-		val_cr4 &= ~FSL_SAI_CR4_MF;
-	else
+	if (!sai->big_endian_data)
 		val_cr4 |= FSL_SAI_CR4_MF;
 
 	/* DAI mode */
@@ -189,7 +170,6 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		 * frame sync asserts with the first bit of the frame.
 		 */
 		val_cr2 |= FSL_SAI_CR2_BCP;
-		val_cr4 &= ~(FSL_SAI_CR4_FSE | FSL_SAI_CR4_FSP);
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
 		/*
@@ -199,7 +179,6 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		 * data word.
 		 */
 		val_cr2 |= FSL_SAI_CR2_BCP;
-		val_cr4 &= ~FSL_SAI_CR4_FSP;
 		val_cr4 |= FSL_SAI_CR4_FSE;
 		sai->is_dsp_mode = true;
 		break;
@@ -209,7 +188,6 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		 * frame sync asserts with the first bit of the frame.
 		 */
 		val_cr2 |= FSL_SAI_CR2_BCP;
-		val_cr4 &= ~(FSL_SAI_CR4_FSE | FSL_SAI_CR4_FSP);
 		sai->is_dsp_mode = true;
 		break;
 	case SND_SOC_DAIFMT_RIGHT_J:
@@ -247,23 +225,22 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		val_cr4 |= FSL_SAI_CR4_FSD_MSTR;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
-		val_cr2 &= ~FSL_SAI_CR2_BCD_MSTR;
-		val_cr4 &= ~FSL_SAI_CR4_FSD_MSTR;
 		break;
 	case SND_SOC_DAIFMT_CBS_CFM:
 		val_cr2 |= FSL_SAI_CR2_BCD_MSTR;
-		val_cr4 &= ~FSL_SAI_CR4_FSD_MSTR;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFS:
-		val_cr2 &= ~FSL_SAI_CR2_BCD_MSTR;
 		val_cr4 |= FSL_SAI_CR4_FSD_MSTR;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	regmap_write(sai->regmap, reg_cr2, val_cr2);
-	regmap_write(sai->regmap, reg_cr4, val_cr4);
+	regmap_update_bits(sai->regmap, FSL_SAI_xCR2(tx),
+			   FSL_SAI_CR2_BCP | FSL_SAI_CR2_BCD_MSTR, val_cr2);
+	regmap_update_bits(sai->regmap, FSL_SAI_xCR4(tx),
+			   FSL_SAI_CR4_MF | FSL_SAI_CR4_FSE |
+			   FSL_SAI_CR4_FSP | FSL_SAI_CR4_FSD_MSTR, val_cr4);
 
 	return 0;
 }
@@ -290,29 +267,10 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 		struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
-	u32 val_cr4, val_cr5, val_mr, reg_cr4, reg_cr5, reg_mr;
+	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
 	unsigned int channels = params_channels(params);
 	u32 word_width = snd_pcm_format_width(params_format(params));
-
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		reg_cr4 = FSL_SAI_TCR4;
-		reg_cr5 = FSL_SAI_TCR5;
-		reg_mr = FSL_SAI_TMR;
-	} else {
-		reg_cr4 = FSL_SAI_RCR4;
-		reg_cr5 = FSL_SAI_RCR5;
-		reg_mr = FSL_SAI_RMR;
-	}
-
-	regmap_read(sai->regmap, reg_cr4, &val_cr4);
-	regmap_read(sai->regmap, reg_cr4, &val_cr5);
-
-	val_cr4 &= ~FSL_SAI_CR4_SYWD_MASK;
-	val_cr4 &= ~FSL_SAI_CR4_FRSZ_MASK;
-
-	val_cr5 &= ~FSL_SAI_CR5_WNW_MASK;
-	val_cr5 &= ~FSL_SAI_CR5_W0W_MASK;
-	val_cr5 &= ~FSL_SAI_CR5_FBT_MASK;
+	u32 val_cr4 = 0, val_cr5 = 0;
 
 	if (!sai->is_dsp_mode)
 		val_cr4 |= FSL_SAI_CR4_SYWD(word_width);
@@ -320,18 +278,20 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 	val_cr5 |= FSL_SAI_CR5_WNW(word_width);
 	val_cr5 |= FSL_SAI_CR5_W0W(word_width);
 
-	val_cr5 &= ~FSL_SAI_CR5_FBT_MASK;
 	if (sai->big_endian_data)
 		val_cr5 |= FSL_SAI_CR5_FBT(0);
 	else
 		val_cr5 |= FSL_SAI_CR5_FBT(word_width - 1);
 
 	val_cr4 |= FSL_SAI_CR4_FRSZ(channels);
-	val_mr = ~0UL - ((1 << channels) - 1);
 
-	regmap_write(sai->regmap, reg_cr4, val_cr4);
-	regmap_write(sai->regmap, reg_cr5, val_cr5);
-	regmap_write(sai->regmap, reg_mr, val_mr);
+	regmap_update_bits(sai->regmap, FSL_SAI_xCR4(tx),
+			   FSL_SAI_CR4_SYWD_MASK | FSL_SAI_CR4_FRSZ_MASK,
+			   val_cr4);
+	regmap_update_bits(sai->regmap, FSL_SAI_xCR5(tx),
+			   FSL_SAI_CR5_WNW_MASK | FSL_SAI_CR5_W0W_MASK |
+			   FSL_SAI_CR5_FBT_MASK, val_cr5);
+	regmap_write(sai->regmap, FSL_SAI_xMR(tx), ~0UL - ((1 << channels) - 1));
 
 	return 0;
 }
@@ -401,8 +361,8 @@ static int fsl_sai_startup(struct snd_pcm_substream *substream,
 		struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
 	struct device *dev = &sai->pdev->dev;
-	u32 reg;
 	int ret;
 
 	ret = clk_prepare_enable(sai->bus_clk);
@@ -411,12 +371,7 @@ static int fsl_sai_startup(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		reg = FSL_SAI_TCR3;
-	else
-		reg = FSL_SAI_RCR3;
-
-	regmap_update_bits(sai->regmap, reg, FSL_SAI_CR3_TRCE,
+	regmap_update_bits(sai->regmap, FSL_SAI_xCR3(tx), FSL_SAI_CR3_TRCE,
 			   FSL_SAI_CR3_TRCE);
 
 	return 0;
@@ -426,15 +381,9 @@ static void fsl_sai_shutdown(struct snd_pcm_substream *substream,
 		struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
-	u32 reg;
-
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		reg = FSL_SAI_TCR3;
-	else
-		reg = FSL_SAI_RCR3;
+	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
 
-	regmap_update_bits(sai->regmap, reg, FSL_SAI_CR3_TRCE,
-			   ~FSL_SAI_CR3_TRCE);
+	regmap_update_bits(sai->regmap, FSL_SAI_xCR3(tx), FSL_SAI_CR3_TRCE, 0);
 
 	clk_disable_unprepare(sai->bus_clk);
 }
-- 
1.8.4


