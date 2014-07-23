Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbaGWLV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:21:29 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:12626
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756924AbaGWLVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:21:25 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <b42378@freescale.com>,
        <b02247@freescale.com>
Subject: [PATCH 2/3] ASoC: fsl_sai: Don't reset FIFO until TE/RE bit is unset
Date: Wed, 23 Jul 2014 19:23:39 +0800
Message-ID: <739ffa508b41229dcfc5041df84b6ce331ae11ff.1406113865.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1406113865.git.nicoleotsuka@gmail.com>
References: <cover.1406113865.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130505880822926077;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(6806004)(44976005)(19580405001)(62966002)(26826002)(102836001)(19580395003)(83072002)(87286001)(89996001)(85852003)(97736001)(93916002)(86362001)(77982001)(74662001)(74502001)(68736004)(73972005)(79102001)(69596002)(20776003)(64706001)(61266001)(80022001)(47776003)(55446002)(92566001)(36756003)(92726001)(77156001)(87936001)(81342001)(81442001)(88136002)(110136001)(82202001)(81542001)(104016003)(99396002)(33646002)(48376002)(21056001)(50466002)(46102001)(84676001)(50986999)(87572001)(76176999)(73392001)(31966008)(4396001)(95666004)(104166001)(107046002)(2351001)(229853001)(105596002)(81156004)(50226001)(85306003)(106466001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB366;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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

TE/RE bit of T/RCSR will remain set untill the current frame is physically
finished. The FIFO reset operation should wait this bit's totally cleared
rather than ignoring its status which might cause TE/RE disabling failed.

This patch adds delay and timeout to wait for its completion before FIFO
reset.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_sai.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index a437899..a79a9b0 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -327,7 +327,7 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
 	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
-	u32 xcsr;
+	u32 xcsr, count = 100;
 
 	/*
 	 * The transmitter bit clock and frame sync are to be
@@ -369,11 +369,20 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 		if (!(xcsr & FSL_SAI_CSR_FRDE)) {
 			/* Disable both directions and reset their FIFOs */
 			regmap_update_bits(sai->regmap, FSL_SAI_TCSR,
-					   FSL_SAI_CSR_TERE | FSL_SAI_CSR_FR,
-					   FSL_SAI_CSR_FR);
+					   FSL_SAI_CSR_TERE, 0);
 			regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
-					   FSL_SAI_CSR_TERE | FSL_SAI_CSR_FR,
-					   FSL_SAI_CSR_FR);
+					   FSL_SAI_CSR_TERE, 0);
+
+			/* TERE will remain set till the end of current frame */
+			do {
+				udelay(10);
+				regmap_read(sai->regmap, FSL_SAI_xCSR(tx), &xcsr);
+			} while (--count && xcsr & FSL_SAI_CSR_TERE);
+
+			regmap_update_bits(sai->regmap, FSL_SAI_TCSR,
+					   FSL_SAI_CSR_FR, FSL_SAI_CSR_FR);
+			regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
+					   FSL_SAI_CSR_FR, FSL_SAI_CSR_FR);
 		}
 		break;
 	default:
-- 
1.8.4

