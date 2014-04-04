Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaDDHIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:08:40 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:56364 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbaDDHIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:08:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <broonie@kernel.org>, <Li.Xiubo@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>
Subject: [PATCH] ASoC: fsl_sai: Fix Bit Clock Polarity configurations
Date: Fri, 4 Apr 2014 15:09:47 +0800
Message-ID: <1396595387-4371-1-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BCP bit in TCR4/RCR4 register rules as followings:
  0 Bit clock is active high with drive outputs on rising edge
    and sample inputs on falling edge.
  1 Bit clock is active low with drive outputs on falling edge
    and sample inputs on rising edge.

For all formats currently supported in the fsl_sai driver, they're exactly
sending data on the falling edge and sampling on the rising edge.

However, the driver clears this BCP bit for all of them which results click
noise when working with SGTL5000 and big noise with WM8962.

Thus this patch corrects the BCP settings for all the formats here to fix
the nosie issue.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 99051c7..9bbebea 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -180,7 +180,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		 * that is, together with the last bit of the previous
 		 * data word.
 		 */
-		val_cr2 &= ~FSL_SAI_CR2_BCP;
+		val_cr2 |= FSL_SAI_CR2_BCP;
 		val_cr4 |= FSL_SAI_CR4_FSE | FSL_SAI_CR4_FSP;
 		break;
 	case SND_SOC_DAIFMT_LEFT_J:
@@ -188,7 +188,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		 * Frame high, one word length for frame sync,
 		 * frame sync asserts with the first bit of the frame.
 		 */
-		val_cr2 &= ~FSL_SAI_CR2_BCP;
+		val_cr2 |= FSL_SAI_CR2_BCP;
 		val_cr4 &= ~(FSL_SAI_CR4_FSE | FSL_SAI_CR4_FSP);
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
@@ -198,7 +198,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		 * that is, together with the last bit of the previous
 		 * data word.
 		 */
-		val_cr2 &= ~FSL_SAI_CR2_BCP;
+		val_cr2 |= FSL_SAI_CR2_BCP;
 		val_cr4 &= ~FSL_SAI_CR4_FSP;
 		val_cr4 |= FSL_SAI_CR4_FSE;
 		sai->is_dsp_mode = true;
@@ -208,7 +208,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		 * Frame high, one bit for frame sync,
 		 * frame sync asserts with the first bit of the frame.
 		 */
-		val_cr2 &= ~FSL_SAI_CR2_BCP;
+		val_cr2 |= FSL_SAI_CR2_BCP;
 		val_cr4 &= ~(FSL_SAI_CR4_FSE | FSL_SAI_CR4_FSP);
 		sai->is_dsp_mode = true;
 		break;
-- 
1.8.4


