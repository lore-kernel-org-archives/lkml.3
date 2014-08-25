Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaHYDfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 23:35:50 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:54477
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753805AbaHYDfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 23:35:48 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <nicoleotsuka@gmail.com>, <timur@tabi.org>,
        <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>
CC: <galak@codeaurora.org>, <mark.rutland@arm.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 4/4] ASoC: fsl-sai: Convert to use regmap framework's endianness method.
Date: Mon, 25 Aug 2014 11:31:02 +0800
Message-ID: <1408937462-18727-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1408937462-18727-1-git-send-email-Li.Xiubo@freescale.com>
References: <1408937462-18727-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(79102001)(104166001)(92726001)(89996001)(93916002)(48376002)(26826002)(83322001)(20776003)(87936001)(104016003)(99396002)(68736004)(229853001)(85306004)(87286001)(6806004)(50466002)(2201001)(64706001)(69596002)(88136002)(86362001)(44976005)(97736001)(19580405001)(81542001)(102836001)(81342001)(107046002)(74502001)(4396001)(84676001)(80022001)(77156001)(74662001)(31966008)(85852003)(62966002)(106466001)(46102001)(50986999)(90102001)(36756003)(92566001)(76176999)(50226001)(81156004)(105606002)(19580395003)(21056001)(95666004)(76482001)(83072002)(47776003)(77982001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0614;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 Documentation/devicetree/bindings/sound/fsl-sai.txt | 7 +++----
 sound/soc/fsl/fsl_sai.c                             | 6 +-----
 sound/soc/fsl/fsl_sai.h                             | 1 -
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt b/Documentation/devicetree/bindings/sound/fsl-sai.txt
index dc9f9c3..06a405e 100644
--- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
+++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
@@ -18,9 +18,8 @@ Required properties:
 - pinctrl-names: Must contain a "default" entry.
 - pinctrl-NNN: One property must exist for each entry in pinctrl-names.
   See ../pinctrl/pinctrl-bindings.txt for details of the property values.
-- big-endian-regs: If this property is absent, the little endian mode will
-  be in use as default, or the big endian mode will be in use for all the
-  device registers.
+- big-endian: Boolean property, required if all the FTM_PWM registers
+  are big-endian rather than little-endian.
 - big-endian-data: If this property is absent, the little endian mode will
   be in use as default, or the big endian mode will be in use for all the
   fifo data.
@@ -53,6 +52,6 @@ sai2: sai@40031000 {
 	      dma-names = "tx", "rx";
 	      dmas = <&edma0 0 VF610_EDMA_MUXID0_SAI2_TX>,
 		   <&edma0 0 VF610_EDMA_MUXID0_SAI2_RX>;
-	      big-endian-regs;
+	      big-endian;
 	      big-endian-data;
 };
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 60fe7c7..a6eb784 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -544,7 +544,7 @@ static bool fsl_sai_writeable_reg(struct device *dev, unsigned int reg)
 	}
 }
 
-static struct regmap_config fsl_sai_regmap_config = {
+static const struct regmap_config fsl_sai_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
@@ -573,10 +573,6 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(pdev->dev.of_node, "fsl,imx6sx-sai"))
 		sai->sai_on_imx = true;
 
-	sai->big_endian_regs = of_property_read_bool(np, "big-endian-regs");
-	if (sai->big_endian_regs)
-		fsl_sai_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
-
 	sai->big_endian_data = of_property_read_bool(np, "big-endian-data");
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index b3d8864..2cded44 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -132,7 +132,6 @@ struct fsl_sai {
 	struct clk *bus_clk;
 	struct clk *mclk_clk[FSL_SAI_MCLK_MAX];
 
-	bool big_endian_regs;
 	bool big_endian_data;
 	bool is_dsp_mode;
 	bool sai_on_imx;
-- 
1.8.5

