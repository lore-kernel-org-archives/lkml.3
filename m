Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaH2WUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:20:04 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:47368 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750896AbaH2WUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:20:02 -0400
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <d6e00e965c5a9d0f033c09d8049678f9>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        yongjun_wei@trendmicro.com.cn, heiko@sntech.de, dianders@chromium.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH 2/2] rockchip-i2s: add power setting for I2S controller, also fix some bugs
Date: Fri, 29 Aug 2014 15:09:56 -0700
Message-Id: <1409350196-17784-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409350027-17604-1-git-send-email-jay.xu@rock-chips.com>
References: <1409350027-17604-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes:
* add snd_soc_dai_init_dma_data
* fix duplicated argument to "I2S_DMACR_TDE_DISABLE"
* set 1.8v or 3.3v power for I2S controller by GRF interface
* enable "hclk" always
* dma maxburst change to 16

Requested on RK3XXX I2S controllers, and tested ok on rk3288-pinky board.

Change-Id: If17b8022a38c2974f32bfb2dd4b8d16644ec57ac
Signed-off-by: Jianqun <jay.xu@rock-chips.com>
---
 sound/soc/rockchip/rockchip_i2s.c | 93 +++++++++++++++++++++++----------------
 sound/soc/rockchip/rockchip_i2s.h | 13 +++---
 2 files changed, 63 insertions(+), 43 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 8d8e4b5..e07bdbd 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -10,14 +10,15 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
+#include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
 #include <linux/of_gpio.h>
-#include <linux/clk.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
-#include <sound/pcm_params.h>
 #include <sound/dmaengine_pcm.h>
+#include <sound/pcm_params.h>
 
 #include "rockchip_i2s.h"
 
@@ -25,6 +26,7 @@
 
 struct rk_i2s_dev {
 	struct device *dev;
+	struct regmap *grf;
 
 	struct clk *hclk;
 	struct clk *mclk;
@@ -66,11 +68,6 @@ static int i2s_runtime_resume(struct device *dev)
 	return 0;
 }
 
-static inline struct rk_i2s_dev *to_info(struct snd_soc_dai *dai)
-{
-	return snd_soc_dai_get_drvdata(dai);
-}
-
 static void rockchip_snd_txctrl(struct rk_i2s_dev *i2s, int on)
 {
 	unsigned int val = 0;
@@ -79,7 +76,6 @@ static void rockchip_snd_txctrl(struct rk_i2s_dev *i2s, int on)
 	if (on) {
 		regmap_update_bits(i2s->regmap, I2S_DMACR,
 				   I2S_DMACR_TDE_ENABLE, I2S_DMACR_TDE_ENABLE);
-
 		regmap_update_bits(i2s->regmap, I2S_XFER,
 				   I2S_XFER_TXS_START | I2S_XFER_RXS_START,
 				   I2S_XFER_TXS_START | I2S_XFER_RXS_START);
@@ -159,19 +155,20 @@ static void rockchip_snd_rxctrl(struct rk_i2s_dev *i2s, int on)
 	}
 }
 
-static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
+static int rockchip_i2s_set_fmt(struct snd_soc_dai *dai,
 				unsigned int fmt)
 {
-	struct rk_i2s_dev *i2s = to_info(cpu_dai);
+	struct rk_i2s_dev *i2s = snd_soc_dai_get_drvdata(dai);
 	unsigned int mask = 0, val = 0;
 
-	mask = I2S_CKR_MSS_SLAVE;
+	mask = I2S_CKR_MSS_MASK;
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
-		val = I2S_CKR_MSS_SLAVE;
+		/* Set default source clock in Master mode */
+		val = I2S_CKR_MSS_MASTER;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
-		val = I2S_CKR_MSS_MASTER;
+		val = I2S_CKR_MSS_SLAVE;
 		break;
 	default:
 		return -EINVAL;
@@ -220,7 +217,7 @@ static int rockchip_i2s_hw_params(struct snd_pcm_substream *substream,
 				  struct snd_pcm_hw_params *params,
 				  struct snd_soc_dai *dai)
 {
-	struct rk_i2s_dev *i2s = to_info(dai);
+	struct rk_i2s_dev *i2s = snd_soc_dai_get_drvdata(dai);
 	unsigned int val = 0;
 
 	switch (params_format(params)) {
@@ -243,24 +240,13 @@ static int rockchip_i2s_hw_params(struct snd_pcm_substream *substream,
 	regmap_update_bits(i2s->regmap, I2S_TXCR, I2S_TXCR_VDW_MASK, val);
 	regmap_update_bits(i2s->regmap, I2S_RXCR, I2S_RXCR_VDW_MASK, val);
 
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		dai->playback_dma_data = &i2s->playback_dma_data;
-		regmap_update_bits(i2s->regmap, I2S_DMACR, I2S_DMACR_TDL_MASK,
-				   I2S_DMACR_TDL(1) | I2S_DMACR_TDE_ENABLE);
-	} else {
-		dai->capture_dma_data = &i2s->capture_dma_data;
-		regmap_update_bits(i2s->regmap, I2S_DMACR, I2S_DMACR_RDL_MASK,
-				   I2S_DMACR_RDL(1) | I2S_DMACR_RDE_ENABLE);
-	}
-
 	return 0;
 }
 
 static int rockchip_i2s_trigger(struct snd_pcm_substream *substream,
 				int cmd, struct snd_soc_dai *dai)
 {
-	struct rk_i2s_dev *i2s = to_info(dai);
-	int ret = 0;
+	struct rk_i2s_dev *i2s = snd_soc_dai_get_drvdata(dai);
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
@@ -280,17 +266,16 @@ static int rockchip_i2s_trigger(struct snd_pcm_substream *substream,
 			rockchip_snd_txctrl(i2s, 0);
 		break;
 	default:
-		ret = -EINVAL;
-		break;
+		return -EINVAL;
 	}
 
-	return ret;
+	return 0;
 }
 
-static int rockchip_i2s_set_sysclk(struct snd_soc_dai *cpu_dai, int clk_id,
+static int rockchip_i2s_set_sysclk(struct snd_soc_dai *dai, int clk_id,
 				   unsigned int freq, int dir)
 {
-	struct rk_i2s_dev *i2s = to_info(cpu_dai);
+	struct rk_i2s_dev *i2s = snd_soc_dai_get_drvdata(dai);
 	int ret;
 
 	ret = clk_set_rate(i2s->mclk, freq);
@@ -300,6 +285,16 @@ static int rockchip_i2s_set_sysclk(struct snd_soc_dai *cpu_dai, int clk_id,
 	return ret;
 }
 
+static int rockchip_i2s_dai_probe(struct snd_soc_dai *dai)
+{
+	struct rk_i2s_dev *i2s = snd_soc_dai_get_drvdata(dai);
+
+	dai->capture_dma_data = &i2s->capture_dma_data;
+	dai->playback_dma_data = &i2s->playback_dma_data;
+
+	return 0;
+}
+
 static const struct snd_soc_dai_ops rockchip_i2s_dai_ops = {
 	.hw_params = rockchip_i2s_hw_params,
 	.set_sysclk = rockchip_i2s_set_sysclk,
@@ -308,7 +303,9 @@ static const struct snd_soc_dai_ops rockchip_i2s_dai_ops = {
 };
 
 static struct snd_soc_dai_driver rockchip_i2s_dai = {
+	.probe = rockchip_i2s_dai_probe,
 	.playback = {
+		.stream_name = "Playback",
 		.channels_min = 2,
 		.channels_max = 8,
 		.rates = SNDRV_PCM_RATE_8000_192000,
@@ -318,6 +315,7 @@ static struct snd_soc_dai_driver rockchip_i2s_dai = {
 			    SNDRV_PCM_FMTBIT_S24_LE),
 	},
 	.capture = {
+		.stream_name = "Capture",
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_8000_192000,
@@ -361,6 +359,8 @@ static bool rockchip_i2s_rd_reg(struct device *dev, unsigned int reg)
 	case I2S_XFER:
 	case I2S_CLR:
 	case I2S_RXDR:
+	case I2S_FIFOLR:
+	case I2S_INTSR:
 		return true;
 	default:
 		return false;
@@ -370,8 +370,8 @@ static bool rockchip_i2s_rd_reg(struct device *dev, unsigned int reg)
 static bool rockchip_i2s_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case I2S_FIFOLR:
 	case I2S_INTSR:
+	case I2S_CLR:
 		return true;
 	default:
 		return false;
@@ -381,8 +381,6 @@ static bool rockchip_i2s_volatile_reg(struct device *dev, unsigned int reg)
 static bool rockchip_i2s_precious_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case I2S_FIFOLR:
-		return true;
 	default:
 		return false;
 	}
@@ -402,15 +400,20 @@ static const struct regmap_config rockchip_i2s_regmap_config = {
 
 static int rockchip_i2s_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	struct rk_i2s_dev *i2s;
 	struct resource *res;
 	void __iomem *regs;
 	int ret;
 
 	i2s = devm_kzalloc(&pdev->dev, sizeof(*i2s), GFP_KERNEL);
-	if (!i2s) {
-		dev_err(&pdev->dev, "Can't allocate rk_i2s_dev\n");
+	if (!i2s)
 		return -ENOMEM;
+
+	i2s->grf = syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
+	if (IS_ERR(i2s->grf)) {
+		dev_err(&pdev->dev, "Can't retrieve grf property\n");
+		return PTR_ERR(i2s->grf);
 	}
 
 	/* try to prepare related clocks */
@@ -419,6 +422,11 @@ static int rockchip_i2s_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Can't retrieve i2s bus clock\n");
 		return PTR_ERR(i2s->hclk);
 	}
+	ret = clk_prepare_enable(i2s->hclk);
+	if (ret) {
+		dev_err(i2s->dev, "hclock enable failed %d\n", ret);
+		return ret;
+	}
 
 	i2s->mclk = devm_clk_get(&pdev->dev, "i2s_clk");
 	if (IS_ERR(i2s->mclk)) {
@@ -450,6 +458,17 @@ static int rockchip_i2s_probe(struct platform_device *pdev)
 	i2s->dev = &pdev->dev;
 	dev_set_drvdata(&pdev->dev, i2s);
 
+	if (of_property_read_bool(np, "rockchip,grf-io-vsel"))
+		ret = regmap_write(i2s->grf, GRF_IO_VSEL,
+				   BIT(6) << 16 | BIT(6));
+	else
+		ret = regmap_write(i2s->grf, GRF_IO_VSEL,
+				   BIT(6) << 16);
+	if (ret) {
+		dev_err(i2s->dev, "Could not write to GRF: %d\n", ret);
+		return ret;
+	}
+
 	pm_runtime_enable(&pdev->dev);
 	if (!pm_runtime_enabled(&pdev->dev)) {
 		ret = i2s_runtime_resume(&pdev->dev);
diff --git a/sound/soc/rockchip/rockchip_i2s.h b/sound/soc/rockchip/rockchip_i2s.h
index 89a5d8b..8f9a589 100644
--- a/sound/soc/rockchip/rockchip_i2s.h
+++ b/sound/soc/rockchip/rockchip_i2s.h
@@ -201,12 +201,6 @@
 */
 #define I2S_RXDR_MASK	(0xff)
 
-/* Clock divider id */
-enum {
-	ROCKCHIP_DIV_MCLK = 0,
-	ROCKCHIP_DIV_BCLK,
-};
-
 /* I2S REGS */
 #define I2S_TXCR	(0x0000)
 #define I2S_RXCR	(0x0004)
@@ -220,4 +214,11 @@ enum {
 #define I2S_TXDR	(0x0024)
 #define I2S_RXDR	(0x0028)
 
+/*
+ * IO voltage select
+ * 1: I2S controller powerd by 1.8v
+ * 0: I2S controller powerd by 3.3v (default)
+*/
+#define GRF_IO_VSEL (0x380)
+
 #endif /* _ROCKCHIP_IIS_H */
-- 
1.8.3.2

