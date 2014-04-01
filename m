Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaDADRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:17:42 -0400
Received: from [216.32.180.16] ([216.32.180.16]:29013 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbaDADRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:17:41 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>
Subject: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts for Tx and Rx streams
Date: Tue, 1 Apr 2014 11:17:07 +0800
Message-ID: <1396322227-482-3-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1396322227-482-1-git-send-email-Guangyu.Chen@freescale.com>
References: <1396322227-482-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only enable one side interrupt for each stream since over/underrun
on the opposite stream would be resulted from what we previously did,
enabling TERE but remaining FRDE disabled, even though the xrun on the
opposite direction will not break the current stream.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
Acked-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 8 ++++++--
 sound/soc/fsl/fsl_sai.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index bdfd497..d64c33f 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -397,4 +397,6 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 
 		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
+				   FSL_SAI_CSR_xIE_MASK, FSL_SAI_FLAGS);
+		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
 				   FSL_SAI_CSR_FRDE, FSL_SAI_CSR_FRDE);
 		break;
@@ -404,4 +406,6 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
 				   FSL_SAI_CSR_FRDE, 0);
+		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
+				   FSL_SAI_CSR_xIE_MASK, 0);
 
 		if (!(tcsr & FSL_SAI_CSR_FRDE || rcsr & FSL_SAI_CSR_FRDE)) {
@@ -464,6 +468,6 @@ static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
 	struct fsl_sai *sai = dev_get_drvdata(cpu_dai->dev);
 
-	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, FSL_SAI_FLAGS);
-	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, FSL_SAI_FLAGS);
+	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, 0x0);
+	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, 0x0);
 	regmap_update_bits(sai->regmap, FSL_SAI_TCR1, FSL_SAI_CR1_RFW_MASK,
 			   FSL_SAI_MAXBURST_TX * 2);
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index 64b6fe7..be26d46 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -59,4 +59,5 @@
 #define FSL_SAI_CSR_FRF		BIT(16)
 #define FSL_SAI_CSR_xIE_SHIFT	8
+#define FSL_SAI_CSR_xIE_MASK	(0x1f << FSL_SAI_CSR_xIE_SHIFT)
 #define FSL_SAI_CSR_WSIE	BIT(12)
 #define FSL_SAI_CSR_SEIE	BIT(11)
-- 
1.8.4


