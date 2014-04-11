Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbaDKOIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:08:44 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:15122
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758924AbaDKOIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:08:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: fsl_sai: Fix incorrect condition check in trigger()
Date: Fri, 11 Apr 2014 22:10:00 +0800
Message-ID: <1397225400-2769-1-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch ASoC: fsl_sai: Fix buggy configurations in trigger() doesn't entirely
fix the condition: FRDE of the current substream direction is being cleared
while the code is still using the non-updated one.

Thus this patch fixes this issue by checking the opposite one's FRDE alone
since the current one's is absolutely disabled.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 9858d42..1716a41 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -343,7 +343,8 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
 				   FSL_SAI_CSR_xIE_MASK, 0);
 
-		if (!(tcsr & FSL_SAI_CSR_FRDE || rcsr & FSL_SAI_CSR_FRDE)) {
+		/* Check if the opposite FRDE is also disabled */
+		if (!(tx ? rcsr & FSL_SAI_CSR_FRDE : tcsr & FSL_SAI_CSR_FRDE)) {
 			regmap_update_bits(sai->regmap, FSL_SAI_TCSR,
 					   FSL_SAI_CSR_TERE, 0);
 			regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
-- 
1.8.4


