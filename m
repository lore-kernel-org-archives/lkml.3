Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaHDHFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 03:05:11 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:37972
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751043AbaHDHFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 03:05:09 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: fsl_sai: Set SYNC bit of TCR2 to Asynchronous Mode
Date: Mon, 4 Aug 2014 15:07:25 +0800
Message-ID: <1407136045-8940-1-git-send-email-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130516094954605069;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009002)(6009001)(189002)(199002)(80022001)(77156001)(55446002)(19580405001)(4396001)(93916002)(50226001)(6806004)(31966008)(81342001)(81442001)(77982001)(19580395003)(105596002)(81156004)(87936001)(79102001)(68736004)(61266001)(73972005)(46102001)(82202001)(74662001)(50986999)(64706001)(87572001)(92566001)(107046002)(21056001)(81542001)(229853001)(73392001)(102836001)(110136001)(36756003)(44976005)(89996001)(62966002)(26826002)(88136002)(92726001)(74502001)(99396002)(33646002)(106466001)(86362001)(97736001)(69596002)(104166001)(20776003)(48376002)(84676001)(2351001)(47776003)(85306004)(95666004)(85852003)(104016003)(87286001)(83072002)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB357;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0293D40691
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolin Chen <Guangyu.Chen@freescale.com>

There is one design rule according to SAI's reference manual:
If the transmitter bit clock and frame sync are to be used by both transmitter
and receiver, the transmitter must be configured for asynchronous operation
and the receiver for synchronous operation.

And SYNC of TCR2 is a 2-width control bit:
00 Asynchronous mode.
01 Synchronous with receiver.
10 Synchronous with another SAI transmitter.
11 Synchronous with another SAI receiver.

So the driver should have set SYNC bit of TCR2 to 0x0, and meanwhile set SYNC
bit of RCR2 to 0x1 (Synchronous with transmitter).

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---

@Mark
Sir, I don't see your last patch in your branch. So I guess we can still use
this better fix which does not have the 64bit compiling issue either. 

 sound/soc/fsl/fsl_sai.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index faa0497..9f10575 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -333,8 +333,7 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 	 * The transmitter bit clock and frame sync are to be
 	 * used by both the transmitter and receiver.
 	 */
-	regmap_update_bits(sai->regmap, FSL_SAI_TCR2, FSL_SAI_CR2_SYNC,
-			   ~FSL_SAI_CR2_SYNC);
+	regmap_update_bits(sai->regmap, FSL_SAI_TCR2, FSL_SAI_CR2_SYNC, 0);
 	regmap_update_bits(sai->regmap, FSL_SAI_RCR2, FSL_SAI_CR2_SYNC,
 			   FSL_SAI_CR2_SYNC);
 
-- 
1.8.4

