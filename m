Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990AbaDILE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:04:58 -0400
Received: from tx2ehsobe007.messaging.microsoft.com ([65.55.88.31]:18727 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932560AbaDILEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:04:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz1458K154dIzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh8275dh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <broonie@kernel.org>, <Li.Xiubo@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <rob@landley.net>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <shawn.guo@linaro.org>
Subject: [PATCH v4] ASoC: fsl_sai: Add clock controls for SAI
Date: Wed, 9 Apr 2014 19:06:17 +0800
Message-ID: <1397041577-9580-1-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SAI mainly has the following clocks:
  bus clock
    control and configure registers and to generate synchronous
    interrupts and DMA requests.

  mclk1, mclk2, mclk3
    to generate the bit clock when the receiver or transmitter is
    configured for an internally generated bit clock.

So this patch adds these clocks and their clock controls to the driver,
meanwhile, corrects the existing DTS accordingly so those platforms can
benifit from the further feature with different clock sources.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
CC: Xiubo Li <Li.Xiubo@freescale.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---

@Xiubo
Even though you've tested it before, I'd still like to wait for your test
result to this newer version.

Changelog
v4:
 * Merged into single patch.
 * Fixed bus clock ID on vf610.
v3:
 * Use int type for ret instead of u32.
 * Added Acked-by and Tested-by from Xiubo Li.
v2:
 * Appended two extra mclks to the driver since SAI actually has three.
 * Renamed clock name to 'bus' and 'mclk' according to the reference manual.

 .../devicetree/bindings/sound/fsl-sai.txt          |  9 ++--
 arch/arm/boot/dts/vf610.dtsi                       |  6 ++-
 sound/soc/fsl/fsl_sai.c                            | 51 ++++++++++++++++++++--
 sound/soc/fsl/fsl_sai.h                            |  4 ++
 4 files changed, 61 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt b/Documentation/devicetree/bindings/sound/fsl-sai.txt
index 35c09fe..0f4e238 100644
--- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
+++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
@@ -10,7 +10,8 @@ Required properties:
 - compatible: Compatible list, contains "fsl,vf610-sai" or "fsl,imx6sx-sai".
 - reg: Offset and length of the register set for the device.
 - clocks: Must contain an entry for each entry in clock-names.
-- clock-names : Must include the "sai" entry.
+- clock-names : Must include the "bus" for register access and "mclk1" "mclk2"
+  "mclk3" for bit clock and frame clock providing.
 - dmas : Generic dma devicetree binding as described in
   Documentation/devicetree/bindings/dma/dma.txt.
 - dma-names : Two dmas have to be defined, "tx" and "rx".
@@ -30,8 +31,10 @@ sai2: sai@40031000 {
 	      reg = <0x40031000 0x1000>;
 	      pinctrl-names = "default";
 	      pinctrl-0 = <&pinctrl_sai2_1>;
-	      clocks = <&clks VF610_CLK_SAI2>;
-	      clock-names = "sai";
+	      clocks = <&clks VF610_CLK_PLATFORM_BUS>,
+		     <&clks VF610_CLK_SAI2>,
+		     <&clks 0>, <&clks 0>;
+	      clock-names = "bus", "mclk1", "mclk2", "mclk3";
 	      dma-names = "tx", "rx";
 	      dmas = <&edma0 0 VF610_EDMA_MUXID0_SAI2_TX>,
 		   <&edma0 0 VF610_EDMA_MUXID0_SAI2_RX>;
diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index d31ce1b..4c3cd59 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -139,8 +139,10 @@
 				compatible = "fsl,vf610-sai";
 				reg = <0x40031000 0x1000>;
 				interrupts = <0 86 0x04>;
-				clocks = <&clks VF610_CLK_SAI2>;
-				clock-names = "sai";
+				clocks = <&clks VF610_CLK_PLATFORM_BUS>,
+				       <&clks VF610_CLK_SAI2>,
+				       <&clks 0>, <&clks 0>;
+				clock-names = "bus", "mclk1", "mclk2", "mclk3";
 				status = "disabled";
 			};
 
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index db9f75e..7cd4af9 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -401,7 +401,23 @@ static int fsl_sai_startup(struct snd_pcm_substream *substream,
 		struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
-	u32 reg;
+	struct device *dev = &sai->pdev->dev;
+	u32 reg, i;
+	int ret;
+
+	ret = clk_prepare_enable(sai->bus_clk);
+	if (ret) {
+		dev_err(dev, "failed to enable bus clock\n");
+		return ret;
+	}
+
+	for (i = 0; i < FSL_SAI_MCLK_MAX; i++) {
+		ret = clk_prepare_enable(sai->mclk_clk[i]);
+		if (ret) {
+			dev_err(dev, "failed to enable mclk%d clock\n", i + 1);
+			goto err;
+		}
+	}
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		reg = FSL_SAI_TCR3;
@@ -412,13 +428,20 @@ static int fsl_sai_startup(struct snd_pcm_substream *substream,
 			   FSL_SAI_CR3_TRCE);
 
 	return 0;
+
+err:
+	for (; i > 0; i--)
+		clk_disable_unprepare(sai->mclk_clk[i - 1]);
+	clk_disable_unprepare(sai->bus_clk);
+
+	return ret;
 }
 
 static void fsl_sai_shutdown(struct snd_pcm_substream *substream,
 		struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
-	u32 reg;
+	u32 reg, i;
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		reg = FSL_SAI_TCR3;
@@ -427,6 +450,10 @@ static void fsl_sai_shutdown(struct snd_pcm_substream *substream,
 
 	regmap_update_bits(sai->regmap, reg, FSL_SAI_CR3_TRCE,
 			   ~FSL_SAI_CR3_TRCE);
+
+	for (i = 0; i < FSL_SAI_MCLK_MAX; i++)
+		clk_disable_unprepare(sai->mclk_clk[i]);
+	clk_disable_unprepare(sai->bus_clk);
 }
 
 static const struct snd_soc_dai_ops fsl_sai_pcm_dai_ops = {
@@ -559,7 +586,8 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	struct fsl_sai *sai;
 	struct resource *res;
 	void __iomem *base;
-	int irq, ret;
+	char tmp[8];
+	int irq, ret, i;
 
 	sai = devm_kzalloc(&pdev->dev, sizeof(*sai), GFP_KERNEL);
 	if (!sai)
@@ -582,12 +610,27 @@ static int fsl_sai_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 
 	sai->regmap = devm_regmap_init_mmio_clk(&pdev->dev,
-			"sai", base, &fsl_sai_regmap_config);
+			"bus", base, &fsl_sai_regmap_config);
 	if (IS_ERR(sai->regmap)) {
 		dev_err(&pdev->dev, "regmap init failed\n");
 		return PTR_ERR(sai->regmap);
 	}
 
+	sai->bus_clk = devm_clk_get(&pdev->dev, "bus");
+	if (IS_ERR(sai->bus_clk)) {
+		dev_err(&pdev->dev, "failed to get bus clock\n");
+		return PTR_ERR(sai->bus_clk);
+	}
+
+	for (i = 0; i < FSL_SAI_MCLK_MAX; i++) {
+		sprintf(tmp, "mclk%d", i + 1);
+		sai->mclk_clk[i] = devm_clk_get(&pdev->dev, tmp);
+		if (IS_ERR(sai->mclk_clk[i])) {
+			dev_err(&pdev->dev, "failed to get mclk%d clock\n", i + 1);
+			return PTR_ERR(sai->mclk_clk[i]);
+		}
+	}
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(&pdev->dev, "no irq for node %s\n", np->full_name);
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index 677670d..0e6c9f5 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -119,6 +119,8 @@
 #define FSL_SAI_CLK_MAST2	2
 #define FSL_SAI_CLK_MAST3	3
 
+#define FSL_SAI_MCLK_MAX	3
+
 /* SAI data transfer numbers per DMA request */
 #define FSL_SAI_MAXBURST_TX 6
 #define FSL_SAI_MAXBURST_RX 6
@@ -126,6 +128,8 @@
 struct fsl_sai {
 	struct platform_device *pdev;
 	struct regmap *regmap;
+	struct clk *bus_clk;
+	struct clk *mclk_clk[FSL_SAI_MCLK_MAX];
 
 	bool big_endian_regs;
 	bool big_endian_data;
-- 
1.8.4


