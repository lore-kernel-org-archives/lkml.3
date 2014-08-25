Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaHYHU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:20:27 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:26456
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754446AbaHYHU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:20:26 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <nicoleotsuka@gmail.com>, <timur@tabi.org>,
        <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>
CC: <galak@codeaurora.org>, <mark.rutland@arm.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: fsl-sai: using 'lsb-first' property instead of 'big-endian-data'.
Date: Mon, 25 Aug 2014 15:16:01 +0800
Message-ID: <1408950961-19177-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(199003)(189002)(44976005)(6806004)(107046002)(50986999)(85852003)(36756003)(50466002)(50226001)(69596002)(64706001)(81156004)(48376002)(19580395003)(83072002)(102836001)(26826002)(76482001)(83322001)(105606002)(87936001)(20776003)(4396001)(90102001)(106466001)(81342001)(87286001)(104166001)(2201001)(21056001)(77156001)(229853001)(19580405001)(93916002)(68736004)(86362001)(77982001)(81542001)(84676001)(92726001)(47776003)(88136002)(92566001)(80022001)(99396002)(31966008)(97736001)(46102001)(230783001)(62966002)(89996001)(74662001)(85306004)(79102001)(104016003)(74502001)(575784001)(95666004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0612;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03142412E2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This property used for configuring whether the LSB or the MSB is transmitted
first for the fifo data.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Nicolin Chen <nicoleotsuka@gmail.com>
---
 Documentation/devicetree/bindings/sound/fsl-sai.txt | 8 ++++----
 sound/soc/fsl/fsl_sai.c                             | 6 +++---
 sound/soc/fsl/fsl_sai.h                             | 2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt b/Documentation/devicetree/bindings/sound/fsl-sai.txt
index 06a405e..4956b14 100644
--- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
+++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
@@ -20,9 +20,9 @@ Required properties:
   See ../pinctrl/pinctrl-bindings.txt for details of the property values.
 - big-endian: Boolean property, required if all the FTM_PWM registers
   are big-endian rather than little-endian.
-- big-endian-data: If this property is absent, the little endian mode will
-  be in use as default, or the big endian mode will be in use for all the
-  fifo data.
+- lsb-first: Configures whether the LSB or the MSB is transmitted first for
+  the fifo data. If this property is absent, the MSB is transmitted first as
+  default, or the LSB is transmitted first.
 - fsl,sai-synchronous-rx: This is a boolean property. If present, indicating
   that SAI will work in the synchronous mode (sync Tx with Rx) which means
   both the transimitter and receiver will send and receive data by following
@@ -53,5 +53,5 @@ sai2: sai@40031000 {
 	      dmas = <&edma0 0 VF610_EDMA_MUXID0_SAI2_TX>,
 		   <&edma0 0 VF610_EDMA_MUXID0_SAI2_RX>;
 	      big-endian;
-	      big-endian-data;
+	      lsb-first;
 };
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index a6eb784..7eeb1dd 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -175,7 +175,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 	bool tx = fsl_dir == FSL_FMT_TRANSMITTER;
 	u32 val_cr2 = 0, val_cr4 = 0;
 
-	if (!sai->big_endian_data)
+	if (!sai->is_lsb_first)
 		val_cr4 |= FSL_SAI_CR4_MF;
 
 	/* DAI mode */
@@ -304,7 +304,7 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 	val_cr5 |= FSL_SAI_CR5_WNW(word_width);
 	val_cr5 |= FSL_SAI_CR5_W0W(word_width);
 
-	if (sai->big_endian_data)
+	if (sai->is_lsb_first)
 		val_cr5 |= FSL_SAI_CR5_FBT(0);
 	else
 		val_cr5 |= FSL_SAI_CR5_FBT(word_width - 1);
@@ -573,7 +573,7 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(pdev->dev.of_node, "fsl,imx6sx-sai"))
 		sai->sai_on_imx = true;
 
-	sai->big_endian_data = of_property_read_bool(np, "big-endian-data");
+	sai->is_lsb_first = of_property_read_bool(np, "lsb-first");
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&pdev->dev, res);
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index 2cded44..3466720 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -132,7 +132,7 @@ struct fsl_sai {
 	struct clk *bus_clk;
 	struct clk *mclk_clk[FSL_SAI_MCLK_MAX];
 
-	bool big_endian_data;
+	bool is_lsb_first;
 	bool is_dsp_mode;
 	bool sai_on_imx;
 	bool synchronous[2];
-- 
1.8.5

