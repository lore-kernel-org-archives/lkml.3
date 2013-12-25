Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab3LYFdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 00:33:20 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:2076
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762Ab3LYFdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 00:33:18 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <shawn.guo@linaro.org>, <timur@tabi.org>, <lgirdwood@gmail.com>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <b47053@freescale.com>
Subject: [PATCH] ASoC: fsl_sai: Add disable operation for the corresponding data channel.
Date: Wed, 25 Dec 2013 12:40:04 +0800
Message-ID: <1387946404-24029-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enables/Disables the corresponding data channel for tx/rx operation.
A channel must be enabled before its FIFO is accessed, and then disable
it when tx/rx is stopped or idle.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 596aabb..af80246 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -124,20 +124,17 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 				unsigned int fmt, int fsl_dir)
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
-	u32 val_cr2, val_cr3, val_cr4, reg_cr2, reg_cr3, reg_cr4;
+	u32 val_cr2, val_cr4, reg_cr2, reg_cr4;
 
 	if (fsl_dir == FSL_FMT_TRANSMITTER) {
 		reg_cr2 = FSL_SAI_TCR2;
-		reg_cr3 = FSL_SAI_TCR3;
 		reg_cr4 = FSL_SAI_TCR4;
 	} else {
 		reg_cr2 = FSL_SAI_RCR2;
-		reg_cr3 = FSL_SAI_RCR3;
 		reg_cr4 = FSL_SAI_RCR4;
 	}
 
 	val_cr2 = sai_readl(sai, sai->base + reg_cr2);
-	val_cr3 = sai_readl(sai, sai->base + reg_cr3);
 	val_cr4 = sai_readl(sai, sai->base + reg_cr4);
 
 	if (sai->big_endian_data)
@@ -188,13 +185,10 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		return -EINVAL;
 	}
 
-	val_cr3 |= FSL_SAI_CR3_TRCE;
-
 	if (fsl_dir == FSL_FMT_RECEIVER)
 		val_cr2 |= FSL_SAI_CR2_SYNC;
 
 	sai_writel(sai, val_cr2, sai->base + reg_cr2);
-	sai_writel(sai, val_cr3, sai->base + reg_cr3);
 	sai_writel(sai, val_cr4, sai->base + reg_cr4);
 
 	return 0;
@@ -278,7 +272,7 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 		struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
-	unsigned int tcsr, rcsr;
+	u32 tcsr, rcsr, val_cr3, reg_cr3;
 
 	tcsr = sai_readl(sai, sai->base + FSL_SAI_TCSR);
 	rcsr = sai_readl(sai, sai->base + FSL_SAI_RCSR);
@@ -286,17 +280,24 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		tcsr |= FSL_SAI_CSR_FRDE;
 		rcsr &= ~FSL_SAI_CSR_FRDE;
+		reg_cr3 = FSL_SAI_TCR3;
 	} else {
 		rcsr |= FSL_SAI_CSR_FRDE;
 		tcsr &= ~FSL_SAI_CSR_FRDE;
+		reg_cr3 = FSL_SAI_RCR3;
 	}
 
+	val_cr3 = sai_readl(sai, sai->base + reg_cr3);
+
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
 		tcsr |= FSL_SAI_CSR_TERE;
 		rcsr |= FSL_SAI_CSR_TERE;
+		val_cr3 |= FSL_SAI_CR3_TRCE;
+
+		sai_writel(sai, val_cr3, sai->base + reg_cr3);
 		sai_writel(sai, rcsr, sai->base + FSL_SAI_RCSR);
 		sai_writel(sai, tcsr, sai->base + FSL_SAI_TCSR);
 		break;
@@ -308,8 +309,12 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 			tcsr &= ~FSL_SAI_CSR_TERE;
 			rcsr &= ~FSL_SAI_CSR_TERE;
 		}
+
+		val_cr3 &= ~FSL_SAI_CR3_TRCE;
+
 		sai_writel(sai, tcsr, sai->base + FSL_SAI_TCSR);
 		sai_writel(sai, rcsr, sai->base + FSL_SAI_RCSR);
+		sai_writel(sai, val_cr3, sai->base + reg_cr3);
 		break;
 	default:
 		return -EINVAL;
-- 
1.8.4


