Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbaGWLVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:21:25 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:25915
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753068AbaGWLVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:21:22 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <b42378@freescale.com>,
        <b02247@freescale.com>
Subject: [PATCH 1/3] ASoC: fsl_sai: Reduce race condition during TE/RE enabling
Date: Wed, 23 Jul 2014 19:23:38 +0800
Message-ID: <3eb17601f37a686322db6fdf0a6749a592a751e8.1406113865.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1406113865.git.nicoleotsuka@gmail.com>
References: <cover.1406113865.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130505880798394454;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(55674003)(189002)(199002)(6806004)(44976005)(19580405001)(62966002)(26826002)(102836001)(19580395003)(83072002)(87286001)(89996001)(85852003)(97736001)(93916002)(86362001)(77982001)(74662001)(74502001)(68736004)(73972005)(79102001)(69596002)(20776003)(64706001)(61266001)(80022001)(47776003)(55446002)(92566001)(36756003)(92726001)(77156001)(87936001)(81342001)(81442001)(88136002)(110136001)(82202001)(81542001)(104016003)(99396002)(33646002)(48376002)(21056001)(50466002)(46102001)(84676001)(50986999)(87572001)(76176999)(73392001)(31966008)(4396001)(95666004)(104166001)(107046002)(2351001)(229853001)(105596002)(81156004)(50226001)(85306003)(106466001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB366;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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

For trigger start, we don't need to check if it's the first time to
enable TE/RE or second time. It doesn't hurt to enable them any way,
which in the meantime can reduce race condition for TE/RE enabling.

For trigger stop, we will definitely clear FRDE of current direction.
Thus the driver only needs to read the opposite one's.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_sai.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 1b6ee2c..a437899 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -327,7 +327,7 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
 	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
-	u32 tcsr, rcsr;
+	u32 xcsr;
 
 	/*
 	 * The transmitter bit clock and frame sync are to be
@@ -338,9 +338,6 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 	regmap_update_bits(sai->regmap, FSL_SAI_RCR2, FSL_SAI_CR2_SYNC,
 			   FSL_SAI_CR2_SYNC);
 
-	regmap_read(sai->regmap, FSL_SAI_TCSR, &tcsr);
-	regmap_read(sai->regmap, FSL_SAI_RCSR, &rcsr);
-
 	/*
 	 * It is recommended that the transmitter is the last enabled
 	 * and the first disabled.
@@ -349,12 +346,10 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		if (!(tcsr & FSL_SAI_CSR_FRDE || rcsr & FSL_SAI_CSR_FRDE)) {
-			regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
-					   FSL_SAI_CSR_TERE, FSL_SAI_CSR_TERE);
-			regmap_update_bits(sai->regmap, FSL_SAI_TCSR,
-					   FSL_SAI_CSR_TERE, FSL_SAI_CSR_TERE);
-		}
+		regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
+				   FSL_SAI_CSR_TERE, FSL_SAI_CSR_TERE);
+		regmap_update_bits(sai->regmap, FSL_SAI_TCSR,
+				   FSL_SAI_CSR_TERE, FSL_SAI_CSR_TERE);
 
 		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
 				   FSL_SAI_CSR_xIE_MASK, FSL_SAI_FLAGS);
@@ -370,7 +365,8 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 				   FSL_SAI_CSR_xIE_MASK, 0);
 
 		/* Check if the opposite FRDE is also disabled */
-		if (!(tx ? rcsr & FSL_SAI_CSR_FRDE : tcsr & FSL_SAI_CSR_FRDE)) {
+		regmap_read(sai->regmap, FSL_SAI_xCSR(!tx), &xcsr);
+		if (!(xcsr & FSL_SAI_CSR_FRDE)) {
 			/* Disable both directions and reset their FIFOs */
 			regmap_update_bits(sai->regmap, FSL_SAI_TCSR,
 					   FSL_SAI_CSR_TERE | FSL_SAI_CSR_FR,
-- 
1.8.4

