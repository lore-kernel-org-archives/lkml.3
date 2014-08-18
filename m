Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaHRIjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:39:24 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:12481
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752238AbaHRIjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:39:22 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <shc_work@mail.ru>, <fabio.estevam@freescale.com>,
        <shengjiu.wang@freescale.com>, <xobs@kosagi.com>, <arnd@arndb.de>,
        <sfr@canb.auug.org.au>, <timur@tabi.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH V1 2/3] ASoC: fsl-asoc-card: Fix build warning for maybe-uninitialized
Date: Mon, 18 Aug 2014 16:38:39 +0800
Message-ID: <b1711ff2c73f3b6acd6af000bc8294d930bbf16b.1408350626.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1408350626.git.shengjiu.wang@freescale.com>
References: <cover.1408350626.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019005)(6009001)(199003)(189002)(87286001)(76176999)(92726001)(2201001)(104166001)(50986999)(92566001)(68736004)(99396002)(83072002)(97736001)(85852003)(26826002)(74502001)(74662001)(62966002)(46102001)(31966008)(81542001)(81342001)(76482001)(50226001)(47776003)(230783001)(77982001)(95666004)(107046002)(36756003)(105606002)(4396001)(80022001)(84676001)(85306004)(77156001)(79102001)(89996001)(87936001)(48376002)(33646002)(6806004)(88136002)(50466002)(102836001)(64706001)(93916002)(20776003)(86362001)(229853001)(106466001)(104016003)(19580395003)(19580405001)(44976005)(21056001)(83322001)(1121002)(921003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03077579FF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When build fsl-asoc-card as module, there is following error:

sound/soc/fsl/fsl-asoc-card.c: In function 'fsl_asoc_card_probe':
>> sound/soc/fsl/fsl-asoc-card.c:547:13: warning: 'asrc_np' may be used uninitialized in this function [-Wmaybe-uninitialized]
     of_node_put(asrc_np);
                ^

vim +/asrc_np +547 sound/soc/fsl/fsl-asoc-card.c

   531                  if (width == 24)
   532                          priv->asrc_format = SNDRV_PCM_FORMAT_S24_LE;
   533                  else
   534                          priv->asrc_format = SNDRV_PCM_FORMAT_S16_LE;
   535          }
   536
   537          /* Finish card registering */
   538          platform_set_drvdata(pdev, priv);
   539          snd_soc_card_set_drvdata(&priv->card, priv);
   540
   541          ret = devm_snd_soc_register_card(&pdev->dev, &priv->card);
   542          if (ret)
   543                  dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", ret);
   544
   545  fail:
   546          of_node_put(codec_np);
 > 547          of_node_put(asrc_np);
   548          of_node_put(cpu_np);
   549
   550          return ret;
   551  }
   552
   553  static const struct of_device_id fsl_asoc_card_dt_ids[] = {
   554          { .compatible = "fsl,imx-audio-cs42888", },
   555          { .compatible = "fsl,imx-audio-sgtl5000", },

Add 'asrc_fail' branch for error jump after asrc_np initialized.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 sound/soc/fsl/fsl-asoc-card.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index cf3f1f4..007c772 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -469,7 +469,7 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 		ret = fsl_asoc_card_audmux_init(np, priv);
 		if (ret) {
 			dev_err(&pdev->dev, "failed to init audmux\n");
-			goto fail;
+			goto asrc_fail;
 		}
 	} else if (strstr(cpu_np->name, "esai")) {
 		priv->cpu_priv.sysclk_id[1] = ESAI_HCKT_EXTAL;
@@ -518,14 +518,14 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(&pdev->dev, "failed to get output rate\n");
 			ret = -EINVAL;
-			goto fail;
+			goto asrc_fail;
 		}
 
 		ret = of_property_read_u32(asrc_np, "fsl,asrc-width", &width);
 		if (ret) {
 			dev_err(&pdev->dev, "failed to get output rate\n");
 			ret = -EINVAL;
-			goto fail;
+			goto asrc_fail;
 		}
 
 		if (width == 24)
@@ -542,9 +542,10 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	if (ret)
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", ret);
 
+asrc_fail:
+	of_node_put(asrc_np);
 fail:
 	of_node_put(codec_np);
-	of_node_put(asrc_np);
 	of_node_put(cpu_np);
 
 	return ret;
-- 
1.7.9.5

