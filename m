Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaHDERh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:17:37 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:5657
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751294AbaHDERf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:17:35 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>
Subject: [PATCH 1/2] ASoC: fsl_sarc_dma: Check pair before using it
Date: Mon, 4 Aug 2014 12:19:48 +0800
Message-ID: <5a5ffb6219ec5ade81511be9dfbdbeef311f1a16.1407125653.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1407125653.git.nicoleotsuka@gmail.com>
References: <cover.1407125653.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130515994383914693;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009002)(6009001)(189002)(199002)(77156001)(80022001)(55446002)(19580405001)(4396001)(93916002)(50226001)(81342001)(6806004)(31966008)(81442001)(19580395003)(77982001)(81156004)(105596002)(87936001)(79102001)(68736004)(61266001)(73972005)(46102001)(82202001)(74662001)(48376002)(50986999)(64706001)(87572001)(76176999)(92566001)(107046002)(21056001)(81542001)(229853001)(73392001)(102836001)(110136001)(36756003)(44976005)(89996001)(62966002)(26826002)(88136002)(92726001)(74502001)(99396002)(33646002)(106466001)(86362001)(69596002)(104166001)(20776003)(97736001)(2351001)(84676001)(47776003)(85306004)(95666004)(85852003)(50466002)(87286001)(104016003)(83072002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB357;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:UriScan:;
X-Forefront-PRVS: 0293D40691
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch 3117bb3109dc: "ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and
platform drivers" from Jul 29, 2014, leads to the following Smatch
complaint:

sound/soc/fsl/fsl_asrc_dma.c:304 fsl_asrc_dma_shutdown()
warn: variable dereferenced before check 'pair' (see line 302)

sound/soc/fsl/fsl_asrc_dma.c
301          struct fsl_asrc_pair *pair = runtime->private_data;
302          struct fsl_asrc *asrc_priv = pair->asrc_priv;
                                          ^^^^^^^^^^^^^^^
                                            Dereference.

303
304          if (pair && asrc_priv->pair[pair->index] == pair)
                 ^^^^
                Check.

305                  asrc_priv->pair[pair->index] = NULL;
306

So we just let the driver check pair before using it.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_asrc_dma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_asrc_dma.c b/sound/soc/fsl/fsl_asrc_dma.c
index 5b1e73e..ffc000b 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -299,9 +299,14 @@ static int fsl_asrc_dma_shutdown(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct fsl_asrc_pair *pair = runtime->private_data;
-	struct fsl_asrc *asrc_priv = pair->asrc_priv;
+	struct fsl_asrc *asrc_priv;
+
+	if (!pair)
+		return 0;
+
+	asrc_priv = pair->asrc_priv;
 
-	if (pair && asrc_priv->pair[pair->index] == pair)
+	if (asrc_priv->pair[pair->index] == pair)
 		asrc_priv->pair[pair->index] = NULL;
 
 	kfree(pair);
-- 
1.8.4

