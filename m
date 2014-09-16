Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaIPCNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:13:41 -0400
Received: from mail-bl2on0128.outbound.protection.outlook.com ([65.55.169.128]:1632
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754767AbaIPCNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:13:39 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <timur@tabi.org>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>, <mpa@pengutronix.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V4] ASoC: fsl_ssi: refine ipg clock usage in this module
Date: Tue, 16 Sep 2014 10:13:16 +0800
Message-ID: <5dc0f13cdb62904ae0f104f9112faec672adea6f.1410833402.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(54534003)(199003)(189002)(77156001)(62966002)(105606002)(50466002)(87286001)(50226001)(85852003)(88136002)(93916002)(33646002)(104016003)(50986999)(92726001)(76482001)(102836001)(46102003)(77982003)(74502003)(80022003)(79102003)(81542003)(81342003)(74662003)(64706001)(21056001)(92566001)(2201001)(84676001)(44976005)(87936001)(6806004)(90102001)(104166001)(85306004)(106466001)(20776003)(47776003)(4396001)(48376002)(68736004)(107046002)(95666004)(89996001)(86362001)(83072002)(26826002)(97736003)(118296001)(81156004)(31966008)(99396002)(36756003)(69596002)(19580405001)(19580395003)(83322001)(229853001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0623;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check if ipg clock is in clock-names property, then we can move the
ipg clock enable and disable operation to startup and shutdown, that
is only enable ipg clock when ssi is working and keep clock is disabled
when ssi is in idle.
But when the checking is failed, remain the clock control as before.

Tested-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
v4 change log:
fix the code indent issue.

 sound/soc/fsl/fsl_ssi.c |   53 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 8 deletions(-)

diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 2fc3e66..16a1361 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -169,6 +169,7 @@ struct fsl_ssi_private {
 	u8 i2s_mode;
 	bool use_dma;
 	bool use_dual_fifo;
+	bool has_ipg_clk_name;
 	unsigned int fifo_depth;
 	struct fsl_ssi_rxtx_reg_val rxtx_reg_val;
 
@@ -530,6 +531,11 @@ static int fsl_ssi_startup(struct snd_pcm_substream *substream,
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct fsl_ssi_private *ssi_private =
 		snd_soc_dai_get_drvdata(rtd->cpu_dai);
+	int ret;
+
+	ret = clk_prepare_enable(ssi_private->clk);
+	if (ret)
+		return ret;
 
 	/* When using dual fifo mode, it is safer to ensure an even period
 	 * size. If appearing to an odd number while DMA always starts its
@@ -544,6 +550,21 @@ static int fsl_ssi_startup(struct snd_pcm_substream *substream,
 }
 
 /**
+ * fsl_ssi_shutdown: shutdown the SSI
+ *
+ */
+static void fsl_ssi_shutdown(struct snd_pcm_substream *substream,
+				struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct fsl_ssi_private *ssi_private =
+		snd_soc_dai_get_drvdata(rtd->cpu_dai);
+
+	clk_disable_unprepare(ssi_private->clk);
+
+}
+
+/**
  * fsl_ssi_set_bclk - configure Digital Audio Interface bit clock
  *
  * Note: This function can be only called when using SSI as DAI master
@@ -1043,6 +1064,7 @@ static int fsl_ssi_dai_probe(struct snd_soc_dai *dai)
 
 static const struct snd_soc_dai_ops fsl_ssi_dai_ops = {
 	.startup	= fsl_ssi_startup,
+	.shutdown       = fsl_ssi_shutdown,
 	.hw_params	= fsl_ssi_hw_params,
 	.hw_free	= fsl_ssi_hw_free,
 	.set_fmt	= fsl_ssi_set_dai_fmt,
@@ -1168,17 +1190,22 @@ static int fsl_ssi_imx_probe(struct platform_device *pdev,
 	u32 dmas[4];
 	int ret;
 
-	ssi_private->clk = devm_clk_get(&pdev->dev, NULL);
+	if (ssi_private->has_ipg_clk_name)
+		ssi_private->clk = devm_clk_get(&pdev->dev, "ipg");
+	else
+		ssi_private->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(ssi_private->clk)) {
 		ret = PTR_ERR(ssi_private->clk);
 		dev_err(&pdev->dev, "could not get clock: %d\n", ret);
 		return ret;
 	}
 
-	ret = clk_prepare_enable(ssi_private->clk);
-	if (ret) {
-		dev_err(&pdev->dev, "clk_prepare_enable failed: %d\n", ret);
-		return ret;
+	if (!ssi_private->has_ipg_clk_name) {
+		ret = clk_prepare_enable(ssi_private->clk);
+		if (ret) {
+			dev_err(&pdev->dev, "clk_prepare_enable failed: %d\n", ret);
+			return ret;
+		}
 	}
 
 	/* For those SLAVE implementations, we ingore non-baudclk cases
@@ -1236,8 +1263,9 @@ static int fsl_ssi_imx_probe(struct platform_device *pdev,
 	return 0;
 
 error_pcm:
-	clk_disable_unprepare(ssi_private->clk);
 
+	if (!ssi_private->has_ipg_clk_name)
+		clk_disable_unprepare(ssi_private->clk);
 	return ret;
 }
 
@@ -1246,7 +1274,8 @@ static void fsl_ssi_imx_clean(struct platform_device *pdev,
 {
 	if (!ssi_private->use_dma)
 		imx_pcm_fiq_exit(pdev);
-	clk_disable_unprepare(ssi_private->clk);
+	if (!ssi_private->has_ipg_clk_name)
+		clk_disable_unprepare(ssi_private->clk);
 }
 
 static int fsl_ssi_probe(struct platform_device *pdev)
@@ -1321,8 +1350,16 @@ static int fsl_ssi_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,
+	ret = of_property_match_string(np, "clock-names", "ipg");
+	if (ret < 0) {
+		ssi_private->has_ipg_clk_name = false;
+		ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,
 			&fsl_ssi_regconfig);
+	} else {
+		ssi_private->has_ipg_clk_name = true;
+		ssi_private->regs = devm_regmap_init_mmio_clk(&pdev->dev,
+			"ipg", iomem, &fsl_ssi_regconfig);
+	}
 	if (IS_ERR(ssi_private->regs)) {
 		dev_err(&pdev->dev, "Failed to init register map\n");
 		return PTR_ERR(ssi_private->regs);
-- 
1.7.9.5

