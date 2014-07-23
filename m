Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbaGWLVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:21:38 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:29960
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757120AbaGWLV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:21:28 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <b42378@freescale.com>,
        <b02247@freescale.com>
Subject: [PATCH 3/3] ASoC: fsl_sai: Improve enable flow in fsl_sai_trigger()
Date: Wed, 23 Jul 2014 19:23:40 +0800
Message-ID: <b567391b537690c473414304078d9090ee94954f.1406113865.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1406113865.git.nicoleotsuka@gmail.com>
References: <cover.1406113865.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130505880860621954;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(50986999)(21056001)(76176999)(81156004)(83072002)(31966008)(68736004)(88136002)(87286001)(104016003)(77156001)(87936001)(19580405001)(93916002)(62966002)(19580395003)(84676001)(82202001)(85306003)(4396001)(50226001)(86362001)(69596002)(85852003)(44976005)(87572001)(73972005)(6806004)(33646002)(74502001)(81342001)(99396002)(95666004)(77982001)(74662001)(61266001)(20776003)(80022001)(105596002)(107046002)(97736001)(50466002)(81442001)(81542001)(102836001)(79102001)(229853001)(104166001)(46102001)(106466001)(92726001)(55446002)(89996001)(48376002)(47776003)(64706001)(2351001)(26826002)(36756003)(92566001)(73392001)(110136001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB358;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolin Chen <Guangyu.Chen@freescale.com>

The previous enable flow:
1, Enable TE&RE (SAI starts to consume tx FIFO and feed rx FIFO)
2, Mask IRQ of Tx/Rx to enable its interrupt.
3, Enable DMA request of Tx/Rx.

As this flow would enable DMA request later than TERE, the Tx FIFO
would be easily emptied into underrun while Rx FIFO would be easily
stuffed into overrun due to the delayed DMA transfering.

This issue happened merely occational before the patch 'ASoC: fsl_sai:
Reset FIFOs after disabling TE/RE' because there were useless data
remaining in the FIFO for the gap. However, it manifested after FIFO
reset's implemented.

After this patch, the new flow:
1, Enable DMA request of Tx/Rx.
2, Enable TE&RE (SAI starts to consume tx FIFO and feed rx FIFO)
3, Mask IRQ of Tx/Rx to enable its interrupt.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_sai.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index a79a9b0..364410b 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -346,6 +346,9 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
+				   FSL_SAI_CSR_FRDE, FSL_SAI_CSR_FRDE);
+
 		regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
 				   FSL_SAI_CSR_TERE, FSL_SAI_CSR_TERE);
 		regmap_update_bits(sai->regmap, FSL_SAI_TCSR,
@@ -353,8 +356,6 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 
 		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
 				   FSL_SAI_CSR_xIE_MASK, FSL_SAI_FLAGS);
-		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
-				   FSL_SAI_CSR_FRDE, FSL_SAI_CSR_FRDE);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
-- 
1.8.4

