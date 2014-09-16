Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaIPLrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:47:00 -0400
Received: from mail-bn1bon0137.outbound.protection.outlook.com ([157.56.111.137]:54592
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752824AbaIPLq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:46:59 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <timur@tabi.org>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: fsl_spdif: don't change the root clock rate of spdif in driver
Date: Tue, 16 Sep 2014 19:46:34 +0800
Message-ID: <1410867994-32138-1-git-send-email-shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(84676001)(48376002)(6806004)(33646002)(68736004)(93916002)(90102001)(104166001)(4396001)(87936001)(104016003)(77982003)(79102003)(19580395003)(2201001)(81342003)(64706001)(80022003)(21056001)(74502003)(74662003)(77156001)(46102003)(47776003)(81542003)(44976005)(105606002)(76482001)(50986999)(31966008)(106466001)(85852003)(20776003)(95666004)(88136002)(83322001)(85306004)(97736003)(102836001)(36756003)(26826002)(92566001)(62966002)(99396002)(107046002)(87286001)(83072002)(86362001)(19580405001)(50466002)(92726001)(50226001)(89996001)(229853001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0611;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spdif root clock may be used by other module or defined with
CLK_SET_RATE_GATE, so we can't change the clock rate in driver.
In this patch remove the clk_set_rate and clk_round_rate to protect the
clock.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 sound/soc/fsl/fsl_spdif.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index 70acfe4..f2e4595 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -377,7 +377,6 @@ static int spdif_set_sample_rate(struct snd_pcm_substream *substream,
 	unsigned long csfs = 0;
 	u32 stc, mask, rate;
 	u8 clk, txclk_df, sysclk_df;
-	int ret;
 
 	switch (sample_rate) {
 	case 32000:
@@ -419,21 +418,6 @@ static int spdif_set_sample_rate(struct snd_pcm_substream *substream,
 
 	sysclk_df = spdif_priv->sysclk_df[rate];
 
-	/* Don't mess up the clocks from other modules */
-	if (clk != STC_TXCLK_SPDIF_ROOT)
-		goto clk_set_bypass;
-
-	/*
-	 * The S/PDIF block needs a clock of 64 * fs * txclk_df.
-	 * So request 64 * fs * (txclk_df + 1) to get rounded.
-	 */
-	ret = clk_set_rate(spdif_priv->txclk[rate], 64 * sample_rate * (txclk_df + 1));
-	if (ret) {
-		dev_err(&pdev->dev, "failed to set tx clock rate\n");
-		return ret;
-	}
-
-clk_set_bypass:
 	dev_dbg(&pdev->dev, "expected clock rate = %d\n",
 			(64 * sample_rate * txclk_df * sysclk_df));
 	dev_dbg(&pdev->dev, "actual clock rate = %ld\n",
@@ -1056,7 +1040,7 @@ static u32 fsl_spdif_txclk_caldiv(struct fsl_spdif_priv *spdif_priv,
 {
 	const u32 rate[] = { 32000, 44100, 48000, 96000, 192000 };
 	bool is_sysclk = clk == spdif_priv->sysclk;
-	u64 rate_ideal, rate_actual, sub;
+	u64 rate_actual, sub;
 	u32 sysclk_dfmin, sysclk_dfmax;
 	u32 txclk_df, sysclk_df, arate;
 
@@ -1066,11 +1050,7 @@ static u32 fsl_spdif_txclk_caldiv(struct fsl_spdif_priv *spdif_priv,
 
 	for (sysclk_df = sysclk_dfmin; sysclk_df <= sysclk_dfmax; sysclk_df++) {
 		for (txclk_df = 1; txclk_df <= 128; txclk_df++) {
-			rate_ideal = rate[index] * (txclk_df + 1) * 64;
-			if (round)
-				rate_actual = clk_round_rate(clk, rate_ideal);
-			else
-				rate_actual = clk_get_rate(clk);
+			rate_actual = clk_get_rate(clk);
 
 			arate = rate_actual / 64;
 			arate /= txclk_df * sysclk_df;
-- 
1.7.9.5

