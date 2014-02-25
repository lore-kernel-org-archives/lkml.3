Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaBYLAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:00:11 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:57735
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbaBYLAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:00:09 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: fsl-sai: fix Freescale SAI DAI format setting.
Date: Tue, 25 Feb 2014 17:54:51 +0800
Message-ID: <1393322091-24427-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Fix some bugs of fsl_sai_set_dai_fmt_tr().
o Add SND_SOC_DAIFMT_LEFT_J support.
o Add SND_SOC_DAIFMT_CBS_CFM support.
o Add SND_SOC_DAIFMT_CBM_CFS support.
o And SND_SOC_DAIFMT_RIGHT_J need to be done in the future.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index faa65af..26d9f5e 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -105,35 +105,47 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 	else
 		val_cr4 |= FSL_SAI_CR4_MF;
 
+	/* DAI mode */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-		val_cr4 |= FSL_SAI_CR4_FSE;
+		/* Data on rising edge of bclk, frame low, 1clk before data */
+		val_cr2 &= ~FSL_SAI_CR2_BCP;
+		val_cr4 |= FSL_SAI_CR4_FSE | FSL_SAI_CR4_FSP;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		/* Data on rising edge of bclk, frame high, 0clk before data */
+		val_cr2 &= ~FSL_SAI_CR2_BCP;
+		val_cr4 &= ~(FSL_SAI_CR4_FSE | FSL_SAI_CR4_FSP);
 		break;
+	case SND_SOC_DAIFMT_RIGHT_J:
+		/* To be done */
 	default:
 		return -EINVAL;
 	}
 
+	/* DAI clock inversion */
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
 	case SND_SOC_DAIFMT_IB_IF:
-		val_cr4 |= FSL_SAI_CR4_FSP;
-		val_cr2 &= ~FSL_SAI_CR2_BCP;
+		/* Invert both clocks */
+		val_cr2 ^= FSL_SAI_CR2_BCP;
+		val_cr4 ^= FSL_SAI_CR4_FSP;
 		break;
 	case SND_SOC_DAIFMT_IB_NF:
-		val_cr4 &= ~FSL_SAI_CR4_FSP;
-		val_cr2 &= ~FSL_SAI_CR2_BCP;
+		/* Invert bit clock */
+		val_cr2 ^= FSL_SAI_CR2_BCP;
 		break;
 	case SND_SOC_DAIFMT_NB_IF:
-		val_cr4 |= FSL_SAI_CR4_FSP;
-		val_cr2 |= FSL_SAI_CR2_BCP;
+		/* Invert frame clock */
+		val_cr4 ^= FSL_SAI_CR4_FSP;
 		break;
 	case SND_SOC_DAIFMT_NB_NF:
-		val_cr4 &= ~FSL_SAI_CR4_FSP;
-		val_cr2 |= FSL_SAI_CR2_BCP;
+		/* Nothing to do for both normal cases */
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	/* DAI clock master masks */
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
 		val_cr2 |= FSL_SAI_CR2_BCD_MSTR;
@@ -143,6 +155,14 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		val_cr2 &= ~FSL_SAI_CR2_BCD_MSTR;
 		val_cr4 &= ~FSL_SAI_CR4_FSD_MSTR;
 		break;
+	case SND_SOC_DAIFMT_CBS_CFM:
+		val_cr2 |= FSL_SAI_CR2_BCD_MSTR;
+		val_cr4 &= ~FSL_SAI_CR4_FSD_MSTR;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFS:
+		val_cr2 &= ~FSL_SAI_CR2_BCD_MSTR;
+		val_cr4 |= FSL_SAI_CR4_FSD_MSTR;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
1.8.4


