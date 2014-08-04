Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaHDER0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:17:26 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:22735
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751209AbaHDERX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:17:23 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>
Subject: [PATCH 2/2] ASoC: fsl_asrc: Don't access members of config before checking it
Date: Mon, 4 Aug 2014 12:19:49 +0800
Message-ID: <31ec001e493008c1d6e55f1d9d0787028112c4dc.1407125653.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1407125653.git.nicoleotsuka@gmail.com>
References: <cover.1407125653.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130515994409338463;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009002)(6009001)(199002)(189002)(87572001)(44976005)(73392001)(81342001)(73972005)(20776003)(33646002)(110136001)(19580395003)(80022001)(92726001)(19580405001)(50466002)(77156001)(88136002)(6806004)(77982001)(31966008)(89996001)(107046002)(64706001)(4396001)(46102001)(26826002)(93916002)(48376002)(104016003)(69596002)(2351001)(21056001)(99396002)(229853001)(79102001)(50226001)(47776003)(105596002)(104166001)(74502001)(55446002)(97736001)(83072002)(36756003)(92566001)(102836001)(106466001)(68736004)(81442001)(50986999)(74662001)(76176999)(86362001)(62966002)(85852003)(81542001)(61266001)(84676001)(82202001)(81156004)(95666004)(87286001)(85306004)(87936001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB353;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0293D40691
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/soc/fsl/fsl_asrc.c:250 fsl_asrc_config_pair()
	warn: variable dereferenced before check 'config' (see line 243)

git remote add next git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
git remote update next
git checkout 3117bb3109dc223e186302f5dc8ce9ed04adca90
vim +/config +250 sound/soc/fsl/fsl_asrc.c

  237   */
  238  static int fsl_asrc_config_pair(struct fsl_asrc_pair *pair)
  239  {
  240   struct asrc_config *config = pair->config;
  241   struct fsl_asrc *asrc_priv = pair->asrc_priv;
  242   enum asrc_pair_index index = pair->index;
 @243   u32 inrate = config->input_sample_rate, indiv;
  244   u32 outrate = config->output_sample_rate, outdiv;
  245   bool ideal = config->inclk == INCLK_NONE;
  246   u32 clk_index[2], div[2];
  247   int in, out, channels;
  248   struct clk *clk;
  249
 @250   if (!config) {
  251           pair_err("invalid pair config\n");
  252           return -EINVAL;
  253   }

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_asrc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index 06a96f3..86f45a1 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -240,12 +240,11 @@ static int fsl_asrc_config_pair(struct fsl_asrc_pair *pair)
 	struct asrc_config *config = pair->config;
 	struct fsl_asrc *asrc_priv = pair->asrc_priv;
 	enum asrc_pair_index index = pair->index;
-	u32 inrate = config->input_sample_rate, indiv;
-	u32 outrate = config->output_sample_rate, outdiv;
-	bool ideal = config->inclk == INCLK_NONE;
+	u32 inrate, outrate, indiv, outdiv;
 	u32 clk_index[2], div[2];
 	int in, out, channels;
 	struct clk *clk;
+	bool ideal;
 
 	if (!config) {
 		pair_err("invalid pair config\n");
@@ -264,6 +263,10 @@ static int fsl_asrc_config_pair(struct fsl_asrc_pair *pair)
 		return -EINVAL;
 	}
 
+	inrate = config->input_sample_rate;
+	outrate = config->output_sample_rate;
+	ideal = config->inclk == INCLK_NONE;
+
 	/* Validate input and output sample rates */
 	for (in = 0; in < ARRAY_SIZE(supported_input_rate); in++)
 		if (inrate == supported_input_rate[in])
-- 
1.8.4

