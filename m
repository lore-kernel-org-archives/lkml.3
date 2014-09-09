Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbaIIJdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:33:47 -0400
Received: from mail-bl2on0122.outbound.protection.outlook.com ([65.55.169.122]:65312
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756055AbaIIJdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:33:45 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <timur@tabi.org>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Date: Tue, 9 Sep 2014 17:18:07 +0800
Message-ID: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019018)(6009001)(189002)(199003)(83072002)(102836001)(26826002)(85852003)(84676001)(77156001)(87936001)(50226001)(104166001)(229853001)(62966002)(21056001)(77982001)(88136002)(85306004)(33646002)(118296001)(4396001)(90102001)(89996001)(79102001)(104016003)(87286001)(46102001)(93916002)(575784001)(86362001)(99396002)(50986999)(95666004)(105606002)(92726001)(92566001)(106466001)(19580395003)(19580405001)(44976005)(83322001)(68736004)(6806004)(74502001)(76482001)(74662001)(107046002)(36756003)(2201001)(31966008)(64706001)(20776003)(50466002)(47776003)(81542001)(97736003)(81342001)(48376002)(80022001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0623;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0329B15C8A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the ipg clock enable and disable operation to startup and shutdown,
that is only enable ipg clock when ssi is working. we don't need to enable
ipg clock in probe.
Another register accessing need the ipg clock, so use devm_regmap_init_mmio_clk
instead of devm_regmap_init_mmio.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 sound/soc/fsl/fsl_ssi.c |   38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 2fc3e66..d32d0f5 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -531,6 +531,9 @@ static int fsl_ssi_startup(struct snd_pcm_substream *substream,
 	struct fsl_ssi_private *ssi_private =
 		snd_soc_dai_get_drvdata(rtd->cpu_dai);
 
+	if (ssi_private->soc->imx)
+		clk_prepare_enable(ssi_private->clk);
+
 	/* When using dual fifo mode, it is safer to ensure an even period
 	 * size. If appearing to an odd number while DMA always starts its
 	 * task from fifo0, fifo1 would be neglected at the end of each
@@ -544,6 +547,22 @@ static int fsl_ssi_startup(struct snd_pcm_substream *substream,
 }
 
 /**
+ * fsl_ssi_shutdown: shutdown the SSI
+ *
+ */
+static void fsl_ssi_shutdown(struct snd_pcm_substream *substream,
+                             struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct fsl_ssi_private *ssi_private =
+		snd_soc_dai_get_drvdata(rtd->cpu_dai);
+
+	if (ssi_private->soc->imx)
+		clk_disable_unprepare(ssi_private->clk);
+
+}
+
+/**
  * fsl_ssi_set_bclk - configure Digital Audio Interface bit clock
  *
  * Note: This function can be only called when using SSI as DAI master
@@ -1043,6 +1062,7 @@ static int fsl_ssi_dai_probe(struct snd_soc_dai *dai)
 
 static const struct snd_soc_dai_ops fsl_ssi_dai_ops = {
 	.startup	= fsl_ssi_startup,
+	.shutdown       = fsl_ssi_shutdown,
 	.hw_params	= fsl_ssi_hw_params,
 	.hw_free	= fsl_ssi_hw_free,
 	.set_fmt	= fsl_ssi_set_dai_fmt,
@@ -1168,16 +1188,10 @@ static int fsl_ssi_imx_probe(struct platform_device *pdev,
 	u32 dmas[4];
 	int ret;
 
-	ssi_private->clk = devm_clk_get(&pdev->dev, NULL);
+	ssi_private->clk = devm_clk_get(&pdev->dev, "ipg");
 	if (IS_ERR(ssi_private->clk)) {
 		ret = PTR_ERR(ssi_private->clk);
-		dev_err(&pdev->dev, "could not get clock: %d\n", ret);
-		return ret;
-	}
-
-	ret = clk_prepare_enable(ssi_private->clk);
-	if (ret) {
-		dev_err(&pdev->dev, "clk_prepare_enable failed: %d\n", ret);
+		dev_err(&pdev->dev, "could not get ipg clock: %d\n", ret);
 		return ret;
 	}
 
@@ -1236,7 +1250,6 @@ static int fsl_ssi_imx_probe(struct platform_device *pdev,
 	return 0;
 
 error_pcm:
-	clk_disable_unprepare(ssi_private->clk);
 
 	return ret;
 }
@@ -1246,7 +1259,6 @@ static void fsl_ssi_imx_clean(struct platform_device *pdev,
 {
 	if (!ssi_private->use_dma)
 		imx_pcm_fiq_exit(pdev);
-	clk_disable_unprepare(ssi_private->clk);
 }
 
 static int fsl_ssi_probe(struct platform_device *pdev)
@@ -1321,7 +1333,11 @@ static int fsl_ssi_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,
+	if (ssi_private->soc->imx)
+		ssi_private->regs = devm_regmap_init_mmio_clk(&pdev->dev,
+			"ipg", iomem, &fsl_ssi_regconfig);
+	else
+		ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,
 			&fsl_ssi_regconfig);
 	if (IS_ERR(ssi_private->regs)) {
 		dev_err(&pdev->dev, "Failed to init register map\n");
-- 
1.7.9.5

