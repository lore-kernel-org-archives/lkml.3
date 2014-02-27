Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaB0Bvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:51:36 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:11595 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbaB0Bve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:51:34 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <timur@tabi.org>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: fsl-sai: Add SND_SOC_DAIFMT_DSP_A/B support.
Date: Thu, 27 Feb 2014 08:45:01 +0800
Message-ID: <1393461901-23844-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Add SND_SOC_DAIFMT_DSP_A support.
o Add SND_SOC_DAIFMT_DSP_B support.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 sound/soc/fsl/fsl_sai.h |  1 +
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 26d9f5e..c4a4231 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -108,15 +108,44 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 	/* DAI mode */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-		/* Data on rising edge of bclk, frame low, 1clk before data */
+		/*
+		 * Frame low, 1clk before data, one word length for frame sync,
+		 * frame sync starts one serial clock cycle earlier,
+		 * that is, together with the last bit of the previous
+		 * data word.
+		 */
 		val_cr2 &= ~FSL_SAI_CR2_BCP;
 		val_cr4 |= FSL_SAI_CR4_FSE | FSL_SAI_CR4_FSP;
 		break;
 	case SND_SOC_DAIFMT_LEFT_J:
-		/* Data on rising edge of bclk, frame high, 0clk before data */
+		/*
+		 * Frame high, one word length for frame sync,
+		 * frame sync asserts with the first bit of the frame.
+		 */
 		val_cr2 &= ~FSL_SAI_CR2_BCP;
 		val_cr4 &= ~(FSL_SAI_CR4_FSE | FSL_SAI_CR4_FSP);
 		break;
+	case SND_SOC_DAIFMT_DSP_A:
+		/*
+		 * Frame high, 1clk before data, one bit for frame sync,
+		 * frame sync starts one serial clock cycle earlier,
+		 * that is, together with the last bit of the previous
+		 * data word.
+		 */
+		val_cr2 &= ~FSL_SAI_CR2_BCP;
+		val_cr4 &= ~FSL_SAI_CR4_FSP;
+		val_cr4 |= FSL_SAI_CR4_FSE;
+		sai->is_dsp_mode = true;
+		break;
+	case SND_SOC_DAIFMT_DSP_B:
+		/*
+		 * Frame high, one bit for frame sync,
+		 * frame sync asserts with the first bit of the frame.
+		 */
+		val_cr2 &= ~FSL_SAI_CR2_BCP;
+		val_cr4 &= ~(FSL_SAI_CR4_FSE | FSL_SAI_CR4_FSP);
+		sai->is_dsp_mode = true;
+		break;
 	case SND_SOC_DAIFMT_RIGHT_J:
 		/* To be done */
 	default:
@@ -219,7 +248,9 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 	val_cr5 &= ~FSL_SAI_CR5_W0W_MASK;
 	val_cr5 &= ~FSL_SAI_CR5_FBT_MASK;
 
-	val_cr4 |= FSL_SAI_CR4_SYWD(word_width);
+	if (!sai->is_dsp_mode)
+		val_cr4 |= FSL_SAI_CR4_SYWD(word_width);
+
 	val_cr5 |= FSL_SAI_CR5_WNW(word_width);
 	val_cr5 |= FSL_SAI_CR5_W0W(word_width);
 
@@ -245,6 +276,10 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
 	u32 tcsr, rcsr;
 
+	/*
+	 * The transmitter bit clock and frame sync are to be
+	 * used by both the transmitter and receiver.
+	 */
 	regmap_update_bits(sai->regmap, FSL_SAI_TCR2, FSL_SAI_CR2_SYNC,
 			   ~FSL_SAI_CR2_SYNC);
 	regmap_update_bits(sai->regmap, FSL_SAI_RCR2, FSL_SAI_CR2_SYNC,
@@ -261,6 +296,10 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 		tcsr &= ~FSL_SAI_CSR_FRDE;
 	}
 
+	/*
+	 * It is recommended that the transmitter is the last enabled
+	 * and the first disabled.
+	 */
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index 1571459..e432260 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -103,6 +103,7 @@ struct fsl_sai {
 
 	bool big_endian_regs;
 	bool big_endian_data;
+	bool is_dsp_mode;
 
 	struct snd_dmaengine_dai_dma_data dma_params_rx;
 	struct snd_dmaengine_dai_dma_data dma_params_tx;
-- 
1.8.4


