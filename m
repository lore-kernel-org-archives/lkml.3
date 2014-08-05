Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbaHEJSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:18:12 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:2967
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932792AbaHEJSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:18:10 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: fsl_sai: Initialize with software reset
Date: Tue, 5 Aug 2014 17:20:21 +0800
Message-ID: <1407230421-20953-1-git-send-email-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130517038745717825;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009002)(6009001)(199002)(189002)(48376002)(50466002)(31966008)(92566001)(20776003)(92726001)(99396002)(36756003)(79102001)(21056001)(84676001)(74662001)(74502001)(64706001)(61266001)(69596002)(68736004)(83072002)(47776003)(87936001)(87286001)(81542001)(81342001)(81442001)(85852003)(82202001)(50226001)(4396001)(88136002)(77156001)(89996001)(85306004)(46102001)(55446002)(80022001)(73392001)(77982001)(86362001)(33646002)(93916002)(50986999)(107046002)(102836001)(229853001)(2351001)(104166001)(110136001)(62966002)(104016003)(105596002)(97736001)(81156004)(106466001)(26826002)(6806004)(95666004)(73972005)(19580395003)(19580405001)(87572001)(44976005);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB358;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds software reset code in dai_probe() so as to make a true init
by clearing SAI's internal logic, including the bit clock generation, status
flags, and FIFO pointers.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_sai.c | 9 +++++++--
 sound/soc/fsl/fsl_sai.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index dc84f98..ef7c758 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -438,8 +438,13 @@ static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = dev_get_drvdata(cpu_dai->dev);
 
-	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, 0x0);
-	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, 0x0);
+	/* Software Reset for both Tx and Rx */
+	regmap_write(sai->regmap, FSL_SAI_TCSR, FSL_SAI_CSR_SR);
+	regmap_write(sai->regmap, FSL_SAI_RCSR, FSL_SAI_CSR_SR);
+	/* Clear SR bit to finish the reset */
+	regmap_write(sai->regmap, FSL_SAI_TCSR, 0);
+	regmap_write(sai->regmap, FSL_SAI_RCSR, 0);
+
 	regmap_update_bits(sai->regmap, FSL_SAI_TCR1, FSL_SAI_CR1_RFW_MASK,
 			   FSL_SAI_MAXBURST_TX * 2);
 	regmap_update_bits(sai->regmap, FSL_SAI_RCR1, FSL_SAI_CR1_RFW_MASK,
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index c24d3fd..b3d8864 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -48,6 +48,7 @@
 /* SAI Transmit/Recieve Control Register */
 #define FSL_SAI_CSR_TERE	BIT(31)
 #define FSL_SAI_CSR_FR		BIT(25)
+#define FSL_SAI_CSR_SR		BIT(24)
 #define FSL_SAI_CSR_xF_SHIFT	16
 #define FSL_SAI_CSR_xF_W_SHIFT	18
 #define FSL_SAI_CSR_xF_MASK	(0x1f << FSL_SAI_CSR_xF_SHIFT)
-- 
1.8.4

