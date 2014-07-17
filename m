Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbaGQNTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:19:40 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:57192
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932877AbaGQNTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:19:38 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <b02247@freescale.com>,
        <b42378@freescale.com>
Subject: [PATCH 1/2] ASoC: fsl_sai: Reset FIFOs after disabling TE/RE
Date: Thu, 17 Jul 2014 21:21:37 +0800
Message-ID: <9ef07dc9cc98b19e3f81f8374617605bf0d9faeb.1405603108.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1405603108.git.nicoleotsuka@gmail.com>
References: <cover.1405603108.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130500767647401574;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(43544003)(199002)(189002)(102836001)(50466002)(79102001)(74502001)(84676001)(19580405001)(20776003)(19580395003)(87286001)(87936001)(88136002)(80022001)(107046002)(82202001)(229853001)(33646002)(73392001)(64706001)(61266001)(69596002)(110136001)(81542001)(47776003)(575784001)(48376002)(85306003)(68736004)(4396001)(74662001)(106466001)(44976005)(97736001)(81156004)(46102001)(99396002)(50986999)(89996001)(105596002)(93916002)(62966002)(87572001)(73972005)(26826002)(81442001)(2351001)(86362001)(55446002)(92566001)(81342001)(77156001)(104016003)(83072002)(104166001)(21056001)(6806004)(50226001)(95666004)(76176999)(92726001)(31966008)(77982001)(36756003)(85852003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB358;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SAI will not clear their FIFOs after disabling TE/RE. Therfore, the driver
should take care the task so as not to let useless data remain in the FIFO.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_sai.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index c5a0e8a..b10dbd8 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -371,10 +371,13 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 
 		/* Check if the opposite FRDE is also disabled */
 		if (!(tx ? rcsr & FSL_SAI_CSR_FRDE : tcsr & FSL_SAI_CSR_FRDE)) {
+			/* Disable both directions and reset their FIFOs */
 			regmap_update_bits(sai->regmap, FSL_SAI_TCSR,
-					   FSL_SAI_CSR_TERE, 0);
+					   FSL_SAI_CSR_TERE | FSL_SAI_CSR_FR,
+					   FSL_SAI_CSR_FR);
 			regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
-					   FSL_SAI_CSR_TERE, 0);
+					   FSL_SAI_CSR_TERE | FSL_SAI_CSR_FR,
+					   FSL_SAI_CSR_FR);
 		}
 		break;
 	default:
-- 
1.8.4

