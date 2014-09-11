Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaIKFi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 01:38:58 -0400
Received: from mail-bn1bbn0106.outbound.protection.outlook.com ([157.56.111.106]:24530
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752653AbaIKFiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 01:38:55 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <timur@tabi.org>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] ASoC: fsl_ssi: refine ipg clock usage in this module
Date: Thu, 11 Sep 2014 13:38:29 +0800
Message-ID: <27584da8e3ab291ab8dbcbb411579613f8384a59.1410413734.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(54534003)(189002)(199003)(62966002)(102836001)(21056001)(104166001)(50466002)(33646002)(50986999)(36756003)(99396002)(105606002)(64706001)(92726001)(44976005)(4396001)(77982001)(47776003)(83322001)(229853001)(46102001)(88136002)(48376002)(50226001)(77156001)(80022001)(69596002)(97736003)(85306004)(6806004)(81342001)(19580395003)(104016003)(87286001)(2201001)(87936001)(74662001)(81156004)(90102001)(76482001)(81542001)(84676001)(83072002)(93916002)(106466001)(26826002)(74502001)(31966008)(95666004)(19580405001)(68736004)(92566001)(79102001)(118296001)(86362001)(20776003)(85852003)(107046002)(89996001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0612;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the ipg clock enable and disable operation to startup and shutdown,
that is only enable ipg clock when ssi is working. Keep clock is disabled
when ssi is in idle.
otherwise, _fsl_ssi_set_dai_fmt function need to be called in probe,
so add ipg clock control for it.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---

change log
v2: update patch according to maintainer's review comments.

 sound/soc/fsl/fsl_ssi.c |   39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 2fc3e66..4447f95 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -530,6 +530,11 @@ static int fsl_ssi_startup(struct snd_pcm_substream *substream,
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
@@ -544,6 +549,21 @@ static int fsl_ssi_startup(struct snd_pcm_substream *substream,
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
+	clk_disable_unprepare(ssi_private->clk);
+
+}
+
+/**
  * fsl_ssi_set_bclk - configure Digital Audio Interface bit clock
  *
  * Note: This function can be only called when using SSI as DAI master
@@ -771,6 +791,7 @@ static int _fsl_ssi_set_dai_fmt(struct fsl_ssi_private *ssi_private,
 	struct regmap *regs = ssi_private->regs;
 	u32 strcr = 0, stcr, srcr, scr, mask;
 	u8 wm;
+	int ret;
 
 	ssi_private->dai_fmt = fmt;
 
@@ -779,6 +800,10 @@ static int _fsl_ssi_set_dai_fmt(struct fsl_ssi_private *ssi_private,
 		return -EINVAL;
 	}
 
+	ret = clk_prepare_enable(ssi_private->clk);
+	if (ret)
+		return ret;
+
 	fsl_ssi_setup_reg_vals(ssi_private);
 
 	regmap_read(regs, CCSR_SSI_SCR, &scr);
@@ -811,6 +836,7 @@ static int _fsl_ssi_set_dai_fmt(struct fsl_ssi_private *ssi_private,
 			ssi_private->i2s_mode |= CCSR_SSI_SCR_I2S_MODE_SLAVE;
 			break;
 		default:
+			clk_disable_unprepare(ssi_private->clk);
 			return -EINVAL;
 		}
 
@@ -836,6 +862,7 @@ static int _fsl_ssi_set_dai_fmt(struct fsl_ssi_private *ssi_private,
 		ssi_private->i2s_mode |= CCSR_SSI_SCR_I2S_MODE_NORMAL;
 		break;
 	default:
+		clk_disable_unprepare(ssi_private->clk);
 		return -EINVAL;
 	}
 	scr |= ssi_private->i2s_mode;
@@ -859,6 +886,7 @@ static int _fsl_ssi_set_dai_fmt(struct fsl_ssi_private *ssi_private,
 		strcr ^= CCSR_SSI_STCR_TFSI;
 		break;
 	default:
+		clk_disable_unprepare(ssi_private->clk);
 		return -EINVAL;
 	}
 
@@ -877,6 +905,7 @@ static int _fsl_ssi_set_dai_fmt(struct fsl_ssi_private *ssi_private,
 		scr &= ~CCSR_SSI_SCR_SYS_CLK_EN;
 		break;
 	default:
+		clk_disable_unprepare(ssi_private->clk);
 		return -EINVAL;
 	}
 
@@ -925,6 +954,7 @@ static int _fsl_ssi_set_dai_fmt(struct fsl_ssi_private *ssi_private,
 	if (fmt & SND_SOC_DAIFMT_AC97)
 		fsl_ssi_setup_ac97(ssi_private);
 
+	clk_disable_unprepare(ssi_private->clk);
 	return 0;
 
 }
@@ -1043,6 +1073,7 @@ static int fsl_ssi_dai_probe(struct snd_soc_dai *dai)
 
 static const struct snd_soc_dai_ops fsl_ssi_dai_ops = {
 	.startup	= fsl_ssi_startup,
+	.shutdown       = fsl_ssi_shutdown,
 	.hw_params	= fsl_ssi_hw_params,
 	.hw_free	= fsl_ssi_hw_free,
 	.set_fmt	= fsl_ssi_set_dai_fmt,
@@ -1175,12 +1206,6 @@ static int fsl_ssi_imx_probe(struct platform_device *pdev,
 		return ret;
 	}
 
-	ret = clk_prepare_enable(ssi_private->clk);
-	if (ret) {
-		dev_err(&pdev->dev, "clk_prepare_enable failed: %d\n", ret);
-		return ret;
-	}
-
 	/* For those SLAVE implementations, we ingore non-baudclk cases
 	 * and, instead, abandon MASTER mode that needs baud clock.
 	 */
@@ -1236,7 +1261,6 @@ static int fsl_ssi_imx_probe(struct platform_device *pdev,
 	return 0;
 
 error_pcm:
-	clk_disable_unprepare(ssi_private->clk);
 
 	return ret;
 }
@@ -1246,7 +1270,6 @@ static void fsl_ssi_imx_clean(struct platform_device *pdev,
 {
 	if (!ssi_private->use_dma)
 		imx_pcm_fiq_exit(pdev);
-	clk_disable_unprepare(ssi_private->clk);
 }
 
 static int fsl_ssi_probe(struct platform_device *pdev)
-- 
1.7.9.5

