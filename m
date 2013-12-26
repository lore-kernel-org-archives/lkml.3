Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3LZDuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 22:50:44 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:52320
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477Ab3LZDun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 22:50:43 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <shawn.guo@linaro.org>, <timur@tabi.org>, <lgirdwood@gmail.com>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <b47053@freescale.com>
Subject: [PATCH] ASoC: fsl_sai: Fix one bug for hardware limitation.
Date: Thu, 26 Dec 2013 10:57:22 +0800
Message-ID: <1388026642-1464-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is maybe one bug or a limitation of the hardware that the {T,R}CR2's
Synchronous Mode bits must be set as late as possible, or the SAI device
maybe hanged up, and there has not any explaination about this limitation
in the SAI Data Sheet.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index af80246..59228a10 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -62,6 +62,7 @@ static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai *cpu_dai,
 		reg_cr2 = FSL_SAI_RCR2;
 
 	val_cr2 = sai_readl(sai, sai->base + reg_cr2);
+
 	switch (clk_id) {
 	case FSL_SAI_CLK_BUS:
 		val_cr2 &= ~FSL_SAI_CR2_MSEL_MASK;
@@ -82,6 +83,7 @@ static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai *cpu_dai,
 	default:
 		return -EINVAL;
 	}
+
 	sai_writel(sai, val_cr2, sai->base + reg_cr2);
 
 	return 0;
@@ -138,14 +140,13 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 	val_cr4 = sai_readl(sai, sai->base + reg_cr4);
 
 	if (sai->big_endian_data)
-		val_cr4 |= FSL_SAI_CR4_MF;
-	else
 		val_cr4 &= ~FSL_SAI_CR4_MF;
+	else
+		val_cr4 |= FSL_SAI_CR4_MF;
 
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
 		val_cr4 |= FSL_SAI_CR4_FSE;
-		val_cr4 |= FSL_SAI_CR4_FSP;
 		break;
 	default:
 		return -EINVAL;
@@ -185,9 +186,6 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		return -EINVAL;
 	}
 
-	if (fsl_dir == FSL_FMT_RECEIVER)
-		val_cr2 |= FSL_SAI_CR2_SYNC;
-
 	sai_writel(sai, val_cr2, sai->base + reg_cr2);
 	sai_writel(sai, val_cr4, sai->base + reg_cr4);
 
@@ -253,10 +251,11 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 	val_cr5 |= FSL_SAI_CR5_WNW(word_width);
 	val_cr5 |= FSL_SAI_CR5_W0W(word_width);
 
+	val_cr5 &= ~FSL_SAI_CR5_FBT_MASK;
 	if (sai->big_endian_data)
-		val_cr5 |= FSL_SAI_CR5_FBT(word_width - 1);
-	else
 		val_cr5 |= FSL_SAI_CR5_FBT(0);
+	else
+		val_cr5 |= FSL_SAI_CR5_FBT(word_width - 1);
 
 	val_cr4 |= FSL_SAI_CR4_FRSZ(channels);
 	val_mr = ~0UL - ((1 << channels) - 1);
@@ -327,8 +326,22 @@ static int fsl_sai_startup(struct snd_pcm_substream *substream,
 		struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+	u32 val_cr2;
+	int ret;
+
+	ret = clk_prepare_enable(sai->clk);
+	if (ret)
+		return ret;
+
+	val_cr2 = sai_readl(sai, sai->base + FSL_SAI_TCR2);
+	val_cr2 &= ~FSL_SAI_CR2_SYNC;
+	sai_writel(sai, val_cr2, sai->base + FSL_SAI_TCR2);
 
-	return clk_prepare_enable(sai->clk);
+	val_cr2 = sai_readl(sai, sai->base + FSL_SAI_RCR2);
+	val_cr2 |= FSL_SAI_CR2_SYNC;
+	sai_writel(sai, val_cr2, sai->base + FSL_SAI_RCR2);
+
+	return 0;
 }
 
 static void fsl_sai_shutdown(struct snd_pcm_substream *substream,
-- 
1.8.4


