Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaGELOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 07:14:34 -0400
Received: from regular1.263xmail.com ([211.150.99.137]:37828 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446AbaGELOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 07:14:15 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <1a231d0d0341c4de8c6194ba88cb56e1>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: jianqun <xjq@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, grant.likely@linaro.org, robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, zhangqing@rock-chips.com,
        hj@rock-chips.com, kever.yang@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, kfx@rock-chips.com, Jianqun Xu <xjq@rock-chips.com>
Subject: [PATCH v3 2/2] ASoC: add driver for Rockchip RK3xxx I2S controller
Date: Sat,  5 Jul 2014 19:13:03 +0800
Message-Id: <1404558783-1820-1-git-send-email-xjq@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404458944-6861-1-git-send-email-xjq@rock-chips.com>
References: <1404458944-6861-1-git-send-email-xjq@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianqun Xu <xjq@rock-chips.com>

Add driver for i2s controller found on rk3066, rk3168 and rk3288
processors from rockchip.

Tested on the RK3288 SDK board.

Signed-off-by: Jianqun Xu <xjq@rock-chips.com>
---
changes since v2:
- replace 4 with DMA_SLAVE_BUSWIDTH_4_BYTES
- modify supported rate to SNDRV_PCM_RATE_8000_192000
- rename head file to "rockchi_i2s.h"

changes since v1:
- proper indentation for function arguments, adviced by Varka Bhadram
- replace sizeof(struct rk_i2s_dev) with sizeof(*i2s), adviced by Mark Rutland
- not to include head files which are unused actually in driver, adviced by Mark Brown
- modify i2s_tx_status/i2s_rx_status to more meaningful with tx_start/rx_start, adviced by Mark Brown
- use regmap_update_bits to reduce the amount of time spent locked, adviced by Mark Brown
- add warning for possible error while waiting for the hardware to be ready, adviced by Mark Brown
- error checking for clk_set_rate, adviced by Mark Brown
- error checking for i2s_runtime_resume, adviced by Mark Brown
- remove set_clkdiv operation, clock setting will do it, adviced by Mark Brown
- no need SND_SOC for SND_SOC_ROCKCHIP, also allow the driver to be select when COMPILE_TEST is selected, adviced by Lars-Peter Clausen
- not to include head files which are unused actually in driver, adviced by Lars-Peter Clausen
- I2S core just use one snd_soc_dai_driver struct, adviced by Lars-Peter Clausen
- delete rockchip_pcm.c and related codes, use generic dmaengine API, adviced by Lars-Peter and Mark Brown
- a driver should never attempt to change its own device name, just use the name that the kernel set, adviced by Lars-Peter and Mark Brown

 sound/soc/Kconfig                 |    1 +
 sound/soc/Makefile                |    1 +
 sound/soc/rockchip/Kconfig        |   12 +
 sound/soc/rockchip/Makefile       |    4 +
 sound/soc/rockchip/rockchip_i2s.c |  530 +++++++++++++++++++++++++++++++++++++
 sound/soc/rockchip/rockchip_i2s.h |  223 ++++++++++++++++
 6 files changed, 771 insertions(+)
 create mode 100644 sound/soc/rockchip/Kconfig
 create mode 100644 sound/soc/rockchip/Makefile
 create mode 100644 sound/soc/rockchip/rockchip_i2s.c
 create mode 100644 sound/soc/rockchip/rockchip_i2s.h

diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index 0060b31..0e96233 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -47,6 +47,7 @@ source "sound/soc/kirkwood/Kconfig"
 source "sound/soc/intel/Kconfig"
 source "sound/soc/mxs/Kconfig"
 source "sound/soc/pxa/Kconfig"
+source "sound/soc/rockchip/Kconfig"
 source "sound/soc/samsung/Kconfig"
 source "sound/soc/s6000/Kconfig"
 source "sound/soc/sh/Kconfig"
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index 5f1df02..534714a 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_SND_SOC)	+= nuc900/
 obj-$(CONFIG_SND_SOC)	+= omap/
 obj-$(CONFIG_SND_SOC)	+= kirkwood/
 obj-$(CONFIG_SND_SOC)	+= pxa/
+obj-$(CONFIG_SND_SOC)	+= rockchip/
 obj-$(CONFIG_SND_SOC)	+= samsung/
 obj-$(CONFIG_SND_SOC)	+= s6000/
 obj-$(CONFIG_SND_SOC)	+= sh/
diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
new file mode 100644
index 0000000..c196a46
--- /dev/null
+++ b/sound/soc/rockchip/Kconfig
@@ -0,0 +1,12 @@
+config SND_SOC_ROCKCHIP
+	tristate "ASoC support for Rockchip"
+	depends on COMPILE_TEST || ARCH_ROCKCHIP
+	select SND_SOC_GENERIC_DMAENGINE_PCM
+	select SND_ROCKCHIP_I2S
+	help
+	  Say Y or M if you want to add support for codecs attached to
+	  the Rockchip SoCs' Audio interfaces. You will also need to
+	  select the audio interfaces to support below.
+
+config SND_ROCKCHIP_I2S
+	tristate
diff --git a/sound/soc/rockchip/Makefile b/sound/soc/rockchip/Makefile
new file mode 100644
index 0000000..1006418
--- /dev/null
+++ b/sound/soc/rockchip/Makefile
@@ -0,0 +1,4 @@
+# ROCKCHIP Platform Support
+snd-soc-i2s-objs := rockchip_i2s.o
+
+obj-$(CONFIG_SND_ROCKCHIP_I2S) += snd-soc-i2s.o
diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
new file mode 100644
index 0000000..af1d8eb
--- /dev/null
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -0,0 +1,530 @@
+/* sound/soc/rockchip/rockchip_i2s.c
+ *
+ * ALSA SoC Audio Layer - Rockchip I2S Controller driver
+ *
+ * Copyright (c) 2014 Rockchip Electronics Co. Ltd.
+ * Author: Jianqun <jay.xu@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/of_gpio.h>
+#include <linux/clk.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <sound/pcm_params.h>
+#include <sound/dmaengine_pcm.h>
+
+#include "rockchip_i2s.h"
+
+#define DRV_NAME "rockchip-i2s"
+
+struct rk_i2s_dev {
+	struct device *dev;
+
+	struct clk *hclk;
+	struct clk *mclk;
+
+	struct snd_dmaengine_dai_dma_data capture_dma_data;
+	struct snd_dmaengine_dai_dma_data playback_dma_data;
+
+	struct regmap *regmap;
+
+/*
+ * Used to indicate the tx/rx status.
+ * I2S controller hopes to start the tx and rx together,
+ * also to stop them when they are both try to stop.
+*/
+	bool tx_start;
+	bool rx_start;
+};
+
+static int i2s_runtime_suspend(struct device *dev)
+{
+	struct rk_i2s_dev *i2s = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(i2s->mclk);
+
+	return 0;
+}
+
+static int i2s_runtime_resume(struct device *dev)
+{
+	struct rk_i2s_dev *i2s = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_prepare_enable(i2s->mclk);
+	if (ret) {
+		dev_err(i2s->dev, "clock enable failed %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static inline struct rk_i2s_dev *to_info(struct snd_soc_dai *dai)
+{
+	return snd_soc_dai_get_drvdata(dai);
+}
+
+static void rockchip_snd_txctrl(struct rk_i2s_dev *i2s, int on)
+{
+	unsigned int val = 0;
+	int retry = 10;
+
+	if (on) {
+		regmap_update_bits(i2s->regmap, I2S_DMACR,
+				   I2S_DMACR_TDE_ENABLE, I2S_DMACR_TDE_ENABLE);
+
+		regmap_update_bits(i2s->regmap, I2S_XFER,
+				   I2S_XFER_TXS_START | I2S_XFER_RXS_START,
+				   I2S_XFER_TXS_START | I2S_XFER_RXS_START);
+
+		i2s->tx_start = true;
+	} else {
+		i2s->tx_start = false;
+
+		regmap_update_bits(i2s->regmap, I2S_DMACR,
+				   I2S_DMACR_TDE_ENABLE, I2S_DMACR_TDE_ENABLE);
+
+		if (!i2s->rx_start) {
+			regmap_update_bits(i2s->regmap, I2S_XFER,
+					   I2S_XFER_TXS_START |
+					   I2S_XFER_RXS_START,
+					   I2S_XFER_TXS_STOP |
+					   I2S_XFER_RXS_STOP);
+
+			regmap_update_bits(i2s->regmap, I2S_CLR,
+					   I2S_CLR_TXC | I2S_CLR_TXC,
+					   I2S_CLR_TXC | I2S_CLR_TXC);
+
+			regmap_read(i2s->regmap, I2S_CLR, &val);
+
+			/* Should wait for clear operation to finish */
+			while (val) {
+				regmap_read(i2s->regmap, I2S_CLR, &val);
+				retry--;
+				if (!retry)
+					dev_warn(i2s->dev, "fail to clear\n");
+			}
+		}
+	}
+}
+
+static void rockchip_snd_rxctrl(struct rk_i2s_dev *i2s, int on)
+{
+	unsigned int val = 0;
+	int retry = 10;
+
+	if (on) {
+		regmap_update_bits(i2s->regmap, I2S_DMACR,
+				   I2S_DMACR_RDE_ENABLE, I2S_DMACR_RDE_ENABLE);
+
+		regmap_update_bits(i2s->regmap, I2S_XFER,
+				   I2S_XFER_TXS_START | I2S_XFER_RXS_START,
+				   I2S_XFER_TXS_START | I2S_XFER_RXS_START);
+
+		i2s->rx_start = true;
+	} else {
+		i2s->rx_start = false;
+
+		regmap_update_bits(i2s->regmap, I2S_DMACR,
+				   I2S_DMACR_RDE_ENABLE, I2S_DMACR_RDE_DISABLE);
+
+		if (!i2s->tx_start) {
+			regmap_update_bits(i2s->regmap, I2S_XFER,
+					   I2S_XFER_TXS_START |
+					   I2S_XFER_RXS_START,
+					   I2S_XFER_TXS_STOP |
+					   I2S_XFER_RXS_STOP);
+
+			regmap_update_bits(i2s->regmap, I2S_CLR,
+					   I2S_CLR_TXC | I2S_CLR_TXC,
+					   I2S_CLR_TXC | I2S_CLR_TXC);
+
+			regmap_read(i2s->regmap, I2S_CLR, &val);
+
+			/* Should wait for clear operation to finish */
+			while (val) {
+				regmap_read(i2s->regmap, I2S_CLR, &val);
+				retry--;
+				if (!retry)
+					dev_warn(i2s->dev, "fail to clear\n");
+			}
+		}
+	}
+}
+
+static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
+				unsigned int fmt)
+{
+	struct rk_i2s_dev *i2s = to_info(cpu_dai);
+	unsigned int mask = 0, val = 0;
+
+	mask = I2S_CKR_MSS_SLAVE;
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBS_CFS:
+		val = I2S_CKR_MSS_SLAVE;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFM:
+		val = I2S_CKR_MSS_MASTER;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	regmap_update_bits(i2s->regmap, I2S_CKR, mask, val);
+
+	mask = I2S_TXCR_IBM_MASK;
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_RIGHT_J:
+		val = I2S_TXCR_IBM_RSJM;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		val = I2S_TXCR_IBM_LSJM;
+		break;
+	case SND_SOC_DAIFMT_I2S:
+		val = I2S_TXCR_IBM_NORMAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	regmap_update_bits(i2s->regmap, I2S_TXCR, mask, val);
+
+	mask = I2S_RXCR_IBM_MASK;
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_RIGHT_J:
+		val = I2S_RXCR_IBM_RSJM;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		val = I2S_RXCR_IBM_LSJM;
+		break;
+	case SND_SOC_DAIFMT_I2S:
+		val = I2S_RXCR_IBM_NORMAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	regmap_update_bits(i2s->regmap, I2S_RXCR, mask, val);
+
+	return 0;
+}
+
+static int rockchip_i2s_hw_params(struct snd_pcm_substream *substream,
+				  struct snd_pcm_hw_params *params,
+				  struct snd_soc_dai *dai)
+{
+	struct rk_i2s_dev *i2s = to_info(dai);
+	unsigned int val = 0;
+
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S8:
+		val |= I2S_TXCR_VDW(8);
+		break;
+	case SNDRV_PCM_FORMAT_S16_LE:
+		val |= I2S_TXCR_VDW(16);
+		break;
+	case SNDRV_PCM_FORMAT_S20_3LE:
+		val |= I2S_TXCR_VDW(20);
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		val |= I2S_TXCR_VDW(24);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	regmap_update_bits(i2s->regmap, I2S_TXCR, I2S_TXCR_VDW_MASK, val);
+	regmap_update_bits(i2s->regmap, I2S_RXCR, I2S_RXCR_VDW_MASK, val);
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		dai->playback_dma_data = &i2s->playback_dma_data;
+		regmap_update_bits(i2s->regmap, I2S_DMACR, I2S_DMACR_TDL_MASK,
+				   I2S_DMACR_TDL(1) | I2S_DMACR_TDE_ENABLE);
+	} else {
+		dai->capture_dma_data = &i2s->capture_dma_data;
+		regmap_update_bits(i2s->regmap, I2S_DMACR, I2S_DMACR_RDL_MASK,
+				   I2S_DMACR_RDL(1) | I2S_DMACR_RDE_ENABLE);
+	}
+
+	return 0;
+}
+
+static int rockchip_i2s_trigger(struct snd_pcm_substream *substream,
+				int cmd, struct snd_soc_dai *dai)
+{
+	struct rk_i2s_dev *i2s = to_info(dai);
+	int ret = 0;
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+			rockchip_snd_rxctrl(i2s, 1);
+		else
+			rockchip_snd_txctrl(i2s, 1);
+		break;
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+			rockchip_snd_rxctrl(i2s, 0);
+		else
+			rockchip_snd_txctrl(i2s, 0);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int rockchip_i2s_set_sysclk(struct snd_soc_dai *cpu_dai, int clk_id,
+				   unsigned int freq, int dir)
+{
+	struct rk_i2s_dev *i2s = to_info(cpu_dai);
+	int ret;
+
+	ret = clk_set_rate(i2s->mclk, freq);
+	if (ret)
+		dev_err(i2s->dev, "Fail to set mclk %d\n", ret);
+
+	return ret;
+}
+
+static const struct snd_soc_dai_ops rockchip_i2s_dai_ops = {
+	.hw_params = rockchip_i2s_hw_params,
+	.set_sysclk = rockchip_i2s_set_sysclk,
+	.set_fmt = rockchip_i2s_set_fmt,
+	.trigger = rockchip_i2s_trigger,
+};
+
+static struct snd_soc_dai_driver rockchip_i2s_dai = {
+	.playback = {
+		.channels_min = 2,
+		.channels_max = 8,
+		.rates = SNDRV_PCM_RATE_8000_192000,
+		.formats = (SNDRV_PCM_FMTBIT_S8 |
+			    SNDRV_PCM_FMTBIT_S16_LE |
+			    SNDRV_PCM_FMTBIT_S20_3LE |
+			    SNDRV_PCM_FMTBIT_S24_LE),
+	},
+	.capture = {
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_8000_192000,
+		.formats = (SNDRV_PCM_FMTBIT_S8 |
+			    SNDRV_PCM_FMTBIT_S16_LE |
+			    SNDRV_PCM_FMTBIT_S20_3LE |
+			    SNDRV_PCM_FMTBIT_S24_LE),
+	},
+	.ops = &rockchip_i2s_dai_ops,
+};
+
+static const struct snd_soc_component_driver rockchip_i2s_component = {
+	.name = DRV_NAME,
+};
+
+static bool rockchip_i2s_wr_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case I2S_TXCR:
+	case I2S_RXCR:
+	case I2S_CKR:
+	case I2S_DMACR:
+	case I2S_INTCR:
+	case I2S_XFER:
+	case I2S_CLR:
+	case I2S_TXDR:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool rockchip_i2s_rd_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case I2S_TXCR:
+	case I2S_RXCR:
+	case I2S_CKR:
+	case I2S_DMACR:
+	case I2S_INTCR:
+	case I2S_XFER:
+	case I2S_CLR:
+	case I2S_RXDR:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool rockchip_i2s_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case I2S_FIFOLR:
+	case I2S_INTSR:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool rockchip_i2s_precious_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case I2S_FIFOLR:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static const struct regmap_config rockchip_i2s_regmap_config = {
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.val_bits = 32,
+	.max_register = I2S_RXDR,
+	.writeable_reg = rockchip_i2s_wr_reg,
+	.readable_reg = rockchip_i2s_rd_reg,
+	.volatile_reg = rockchip_i2s_volatile_reg,
+	.precious_reg = rockchip_i2s_precious_reg,
+	.cache_type = REGCACHE_FLAT,
+};
+
+static int rockchip_i2s_probe(struct platform_device *pdev)
+{
+	struct rk_i2s_dev *i2s;
+	struct resource *res;
+	void __iomem *regs;
+	int ret;
+
+	i2s = devm_kzalloc(&pdev->dev, sizeof(*i2s), GFP_KERNEL);
+	if (!i2s) {
+		dev_err(&pdev->dev, "Can't allocate rk_i2s_dev\n");
+		return -ENOMEM;
+	}
+
+	/* try to prepare related clocks */
+	i2s->hclk = devm_clk_get(&pdev->dev, "i2s_hclk");
+	if (IS_ERR(i2s->hclk)) {
+		dev_err(&pdev->dev, "Can't retrieve i2s bus clock\n");
+		return PTR_ERR(i2s->hclk);
+	}
+
+	i2s->mclk = devm_clk_get(&pdev->dev, "i2s_clk");
+	if (IS_ERR(i2s->mclk)) {
+		dev_err(&pdev->dev, "Can't retrieve i2s master clock\n");
+		return PTR_ERR(i2s->mclk);
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(regs)) {
+		dev_err(&pdev->dev, "No memory resource\n");
+		return PTR_ERR(regs);
+	}
+
+	i2s->regmap = devm_regmap_init_mmio(&pdev->dev, regs,
+					    &rockchip_i2s_regmap_config);
+	if (IS_ERR(i2s->regmap)) {
+		dev_err(&pdev->dev,
+			"Failed to initialise managed register map\n");
+		return PTR_ERR(i2s->regmap);
+	}
+
+	i2s->playback_dma_data.addr = res->start + I2S_TXDR;
+	i2s->playback_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	i2s->playback_dma_data.maxburst = 16;
+
+	i2s->capture_dma_data.addr = res->start + I2S_RXDR;
+	i2s->capture_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	i2s->capture_dma_data.maxburst = 16;
+
+	i2s->dev = &pdev->dev;
+	dev_set_drvdata(&pdev->dev, i2s);
+
+	pm_runtime_enable(&pdev->dev);
+	if (!pm_runtime_enabled(&pdev->dev)) {
+		ret = i2s_runtime_resume(&pdev->dev);
+		if (ret)
+			goto err_pm_disable;
+	}
+
+	ret = devm_snd_soc_register_component(&pdev->dev,
+					      &rockchip_i2s_component,
+					      &rockchip_i2s_dai, 1);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not register DAI\n");
+		goto err_suspend;
+	}
+
+	ret = snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not register PCM\n");
+		goto err_pcm_register;
+	}
+
+	return 0;
+
+err_pcm_register:
+	snd_dmaengine_pcm_unregister(&pdev->dev);
+err_suspend:
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		i2s_runtime_suspend(&pdev->dev);
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
+
+	return ret;
+}
+
+static int rockchip_i2s_remove(struct platform_device *pdev)
+{
+	struct rk_i2s_dev *i2s = dev_get_drvdata(&pdev->dev);
+
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		i2s_runtime_suspend(&pdev->dev);
+
+	clk_disable_unprepare(i2s->mclk);
+	clk_disable_unprepare(i2s->hclk);
+	snd_dmaengine_pcm_unregister(&pdev->dev);
+	snd_soc_unregister_component(&pdev->dev);
+
+	return 0;
+}
+
+static const struct of_device_id rockchip_i2s_match[] = {
+	{ .compatible = "rockchip,rk3066-i2s", },
+	{},
+};
+
+static const struct dev_pm_ops rockchip_i2s_pm_ops = {
+	SET_RUNTIME_PM_OPS(i2s_runtime_suspend, i2s_runtime_resume,
+			   NULL)
+};
+
+static struct platform_driver rockchip_i2s_driver = {
+	.probe = rockchip_i2s_probe,
+	.remove = rockchip_i2s_remove,
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(rockchip_i2s_match),
+		.pm = &rockchip_i2s_pm_ops,
+	},
+};
+module_platform_driver(rockchip_i2s_driver);
+
+MODULE_DESCRIPTION("ROCKCHIP IIS ASoC Interface");
+MODULE_AUTHOR("jianqun <jay.xu@rock-chips.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRV_NAME);
+MODULE_DEVICE_TABLE(of, rockchip_i2s_match);
diff --git a/sound/soc/rockchip/rockchip_i2s.h b/sound/soc/rockchip/rockchip_i2s.h
new file mode 100644
index 0000000..89a5d8b
--- /dev/null
+++ b/sound/soc/rockchip/rockchip_i2s.h
@@ -0,0 +1,223 @@
+/*
+ * sound/soc/rockchip/rockchip_i2s.h
+ *
+ * ALSA SoC Audio Layer - Rockchip I2S Controller driver
+ *
+ * Copyright (c) 2014 Rockchip Electronics Co. Ltd.
+ * Author: Jianqun xu <jay.xu@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ROCKCHIP_IIS_H
+#define _ROCKCHIP_IIS_H
+
+/*
+ * TXCR
+ * transmit operation control register
+*/
+#define I2S_TXCR_RCNT_SHIFT	17
+#define I2S_TXCR_RCNT_MASK	(0x3f << I2S_TXCR_RCNT_SHIFT)
+#define I2S_TXCR_CSR_SHIFT	15
+#define I2S_TXCR_CSR(x)		(x << I2S_TXCR_CSR_SHIFT)
+#define I2S_TXCR_CSR_MASK	(3 << I2S_TXCR_CSR_SHIFT)
+#define I2S_TXCR_HWT		BIT(14)
+#define I2S_TXCR_SJM_SHIFT	12
+#define I2S_TXCR_SJM_R		(0 << I2S_TXCR_SJM_SHIFT)
+#define I2S_TXCR_SJM_L		(1 << I2S_TXCR_SJM_SHIFT)
+#define I2S_TXCR_FBM_SHIFT	11
+#define I2S_TXCR_FBM_MSB	(0 << I2S_TXCR_FBM_SHIFT)
+#define I2S_TXCR_FBM_LSB	(1 << I2S_TXCR_FBM_SHIFT)
+#define I2S_TXCR_IBM_SHIFT	9
+#define I2S_TXCR_IBM_NORMAL	(0 << I2S_TXCR_IBM_SHIFT)
+#define I2S_TXCR_IBM_LSJM	(1 << I2S_TXCR_IBM_SHIFT)
+#define I2S_TXCR_IBM_RSJM	(2 << I2S_TXCR_IBM_SHIFT)
+#define I2S_TXCR_IBM_MASK	(3 << I2S_TXCR_IBM_SHIFT)
+#define I2S_TXCR_PBM_SHIFT	7
+#define I2S_TXCR_PBM_MODE(x)	(x << I2S_TXCR_PBM_SHIFT)
+#define I2S_TXCR_PBM_MASK	(3 << I2S_TXCR_PBM_SHIFT)
+#define I2S_TXCR_TFS_SHIFT	5
+#define I2S_TXCR_TFS_I2S	(0 << I2S_TXCR_TFS_SHIFT)
+#define I2S_TXCR_TFS_PCM	(1 << I2S_TXCR_TFS_SHIFT)
+#define I2S_TXCR_VDW_SHIFT	0
+#define I2S_TXCR_VDW(x)		((x - 1) << I2S_TXCR_VDW_SHIFT)
+#define I2S_TXCR_VDW_MASK	(0x1f << I2S_TXCR_VDW_SHIFT)
+
+/*
+ * RXCR
+ * receive operation control register
+*/
+#define I2S_RXCR_HWT		BIT(14)
+#define I2S_RXCR_SJM_SHIFT	12
+#define I2S_RXCR_SJM_R		(0 << I2S_RXCR_SJM_SHIFT)
+#define I2S_RXCR_SJM_L		(1 << I2S_RXCR_SJM_SHIFT)
+#define I2S_RXCR_FBM_SHIFT	11
+#define I2S_RXCR_FBM_MSB	(0 << I2S_RXCR_FBM_SHIFT)
+#define I2S_RXCR_FBM_LSB	(1 << I2S_RXCR_FBM_SHIFT)
+#define I2S_RXCR_IBM_SHIFT	9
+#define I2S_RXCR_IBM_NORMAL	(0 << I2S_RXCR_IBM_SHIFT)
+#define I2S_RXCR_IBM_LSJM	(1 << I2S_RXCR_IBM_SHIFT)
+#define I2S_RXCR_IBM_RSJM	(2 << I2S_RXCR_IBM_SHIFT)
+#define I2S_RXCR_IBM_MASK	(3 << I2S_RXCR_IBM_SHIFT)
+#define I2S_RXCR_PBM_SHIFT	7
+#define I2S_RXCR_PBM_MODE(x)	(x << I2S_RXCR_PBM_SHIFT)
+#define I2S_RXCR_PBM_MASK	(3 << I2S_RXCR_PBM_SHIFT)
+#define I2S_RXCR_TFS_SHIFT	5
+#define I2S_RXCR_TFS_I2S	(0 << I2S_RXCR_TFS_SHIFT)
+#define I2S_RXCR_TFS_PCM	(1 << I2S_RXCR_TFS_SHIFT)
+#define I2S_RXCR_VDW_SHIFT	0
+#define I2S_RXCR_VDW(x)		((x - 1) << I2S_RXCR_VDW_SHIFT)
+#define I2S_RXCR_VDW_MASK	(0x1f << I2S_RXCR_VDW_SHIFT)
+
+/*
+ * CKR
+ * clock generation register
+*/
+#define I2S_CKR_MSS_SHIFT	27
+#define I2S_CKR_MSS_MASTER	(0 << I2S_CKR_MSS_SHIFT)
+#define I2S_CKR_MSS_SLAVE	(1 << I2S_CKR_MSS_SHIFT)
+#define I2S_CKR_MSS_MASK	(1 << I2S_CKR_MSS_SHIFT)
+#define I2S_CKR_CKP_SHIFT	26
+#define I2S_CKR_CKP_NEG		(0 << I2S_CKR_CKP_SHIFT)
+#define I2S_CKR_CKP_POS		(1 << I2S_CKR_CKP_SHIFT)
+#define I2S_CKR_RLP_SHIFT	25
+#define I2S_CKR_RLP_NORMAL	(0 << I2S_CKR_RLP_SHIFT)
+#define I2S_CKR_RLP_OPPSITE	(1 << I2S_CKR_RLP_SHIFT)
+#define I2S_CKR_TLP_SHIFT	24
+#define I2S_CKR_TLP_NORMAL	(0 << I2S_CKR_TLP_SHIFT)
+#define I2S_CKR_TLP_OPPSITE	(1 << I2S_CKR_TLP_SHIFT)
+#define I2S_CKR_MDIV_SHIFT	16
+#define I2S_CKR_MDIV(x)		((x - 1) << I2S_CKR_MDIV_SHIFT)
+#define I2S_CKR_MDIV_MASK	(0xff << I2S_CKR_MDIV_SHIFT)
+#define I2S_CKR_RSD_SHIFT	8
+#define I2S_CKR_RSD(x)		((x - 1) << I2S_CKR_RSD_SHIFT)
+#define I2S_CKR_RSD_MASK	(0xff << I2S_CKR_RSD_SHIFT)
+#define I2S_CKR_TSD_SHIFT	0
+#define I2S_CKR_TSD(x)		((x - 1) << I2S_CKR_TSD_SHIFT)
+#define I2S_CKR_TSD_MASK	(0xff << I2S_CKR_TSD_SHIFT)
+
+/*
+ * FIFOLR
+ * FIFO level register
+*/
+#define I2S_FIFOLR_RFL_SHIFT	24
+#define I2S_FIFOLR_RFL_MASK	(0x3f << I2S_FIFOLR_RFL_SHIFT)
+#define I2S_FIFOLR_TFL3_SHIFT	18
+#define I2S_FIFOLR_TFL3_MASK	(0x3f << I2S_FIFOLR_TFL3_SHIFT)
+#define I2S_FIFOLR_TFL2_SHIFT	12
+#define I2S_FIFOLR_TFL2_MASK	(0x3f << I2S_FIFOLR_TFL2_SHIFT)
+#define I2S_FIFOLR_TFL1_SHIFT	6
+#define I2S_FIFOLR_TFL1_MASK	(0x3f << I2S_FIFOLR_TFL1_SHIFT)
+#define I2S_FIFOLR_TFL0_SHIFT	0
+#define I2S_FIFOLR_TFL0_MASK	(0x3f << I2S_FIFOLR_TFL0_SHIFT)
+
+/*
+ * DMACR
+ * DMA control register
+*/
+#define I2S_DMACR_RDE_SHIFT	24
+#define I2S_DMACR_RDE_DISABLE	(0 << I2S_DMACR_RDE_SHIFT)
+#define I2S_DMACR_RDE_ENABLE	(1 << I2S_DMACR_RDE_SHIFT)
+#define I2S_DMACR_RDL_SHIFT	16
+#define I2S_DMACR_RDL(x)	((x - 1) << I2S_DMACR_RDL_SHIFT)
+#define I2S_DMACR_RDL_MASK	(0x1f << I2S_DMACR_RDL_SHIFT)
+#define I2S_DMACR_TDE_SHIFT	8
+#define I2S_DMACR_TDE_DISABLE	(0 << I2S_DMACR_TDE_SHIFT)
+#define I2S_DMACR_TDE_ENABLE	(1 << I2S_DMACR_TDE_SHIFT)
+#define I2S_DMACR_TDL_SHIFT	0
+#define I2S_DMACR_TDL(x)	((x - 1) << I2S_DMACR_TDL_SHIFT)
+#define I2S_DMACR_TDL_MASK	(0x1f << I2S_DMACR_TDL_SHIFT)
+
+/*
+ * INTCR
+ * interrupt control register
+*/
+#define I2S_INTCR_RFT_SHIFT	20
+#define I2S_INTCR_RFT(x)	((x - 1) << I2S_INTCR_RFT_SHIFT)
+#define I2S_INTCR_RXOIC		BIT(18)
+#define I2S_INTCR_RXOIE_SHIFT	17
+#define I2S_INTCR_RXOIE_DISABLE	(0 << I2S_INTCR_RXOIE_SHIFT)
+#define I2S_INTCR_RXOIE_ENABLE	(1 << I2S_INTCR_RXOIE_SHIFT)
+#define I2S_INTCR_RXFIE_SHIFT	16
+#define I2S_INTCR_RXFIE_DISABLE	(0 << I2S_INTCR_RXFIE_SHIFT)
+#define I2S_INTCR_RXFIE_ENABLE	(1 << I2S_INTCR_RXFIE_SHIFT)
+#define I2S_INTCR_TFT_SHIFT	4
+#define I2S_INTCR_TFT(x)	((x - 1) << I2S_INTCR_TFT_SHIFT)
+#define I2S_INTCR_TFT_MASK	(0x1f << I2S_INTCR_TFT_SHIFT)
+#define I2S_INTCR_TXUIC		BIT(2)
+#define I2S_INTCR_TXUIE_SHIFT	1
+#define I2S_INTCR_TXUIE_DISABLE	(0 << I2S_INTCR_TXUIE_SHIFT)
+#define I2S_INTCR_TXUIE_ENABLE	(1 << I2S_INTCR_TXUIE_SHIFT)
+
+/*
+ * INTSR
+ * interrupt status register
+*/
+#define I2S_INTSR_TXEIE_SHIFT	0
+#define I2S_INTSR_TXEIE_DISABLE	(0 << I2S_INTSR_TXEIE_SHIFT)
+#define I2S_INTSR_TXEIE_ENABLE	(1 << I2S_INTSR_TXEIE_SHIFT)
+#define I2S_INTSR_RXOI_SHIFT	17
+#define I2S_INTSR_RXOI_INA	(0 << I2S_INTSR_RXOI_SHIFT)
+#define I2S_INTSR_RXOI_ACT	(1 << I2S_INTSR_RXOI_SHIFT)
+#define I2S_INTSR_RXFI_SHIFT	16
+#define I2S_INTSR_RXFI_INA	(0 << I2S_INTSR_RXFI_SHIFT)
+#define I2S_INTSR_RXFI_ACT	(1 << I2S_INTSR_RXFI_SHIFT)
+#define I2S_INTSR_TXUI_SHIFT	1
+#define I2S_INTSR_TXUI_INA	(0 << I2S_INTSR_TXUI_SHIFT)
+#define I2S_INTSR_TXUI_ACT	(1 << I2S_INTSR_TXUI_SHIFT)
+#define I2S_INTSR_TXEI_SHIFT	0
+#define I2S_INTSR_TXEI_INA	(0 << I2S_INTSR_TXEI_SHIFT)
+#define I2S_INTSR_TXEI_ACT	(1 << I2S_INTSR_TXEI_SHIFT)
+
+/*
+ * XFER
+ * Transfer start register
+*/
+#define I2S_XFER_RXS_SHIFT	1
+#define I2S_XFER_RXS_STOP	(0 << I2S_XFER_RXS_SHIFT)
+#define I2S_XFER_RXS_START	(1 << I2S_XFER_RXS_SHIFT)
+#define I2S_XFER_TXS_SHIFT	0
+#define I2S_XFER_TXS_STOP	(0 << I2S_XFER_TXS_SHIFT)
+#define I2S_XFER_TXS_START	(1 << I2S_XFER_TXS_SHIFT)
+
+/*
+ * CLR
+ * clear SCLK domain logic register
+*/
+#define I2S_CLR_RXC	BIT(1)
+#define I2S_CLR_TXC	BIT(0)
+
+/*
+ * TXDR
+ * Transimt FIFO data register, write only.
+*/
+#define I2S_TXDR_MASK	(0xff)
+
+/*
+ * RXDR
+ * Receive FIFO data register, write only.
+*/
+#define I2S_RXDR_MASK	(0xff)
+
+/* Clock divider id */
+enum {
+	ROCKCHIP_DIV_MCLK = 0,
+	ROCKCHIP_DIV_BCLK,
+};
+
+/* I2S REGS */
+#define I2S_TXCR	(0x0000)
+#define I2S_RXCR	(0x0004)
+#define I2S_CKR		(0x0008)
+#define I2S_FIFOLR	(0x000c)
+#define I2S_DMACR	(0x0010)
+#define I2S_INTCR	(0x0014)
+#define I2S_INTSR	(0x0018)
+#define I2S_XFER	(0x001c)
+#define I2S_CLR		(0x0020)
+#define I2S_TXDR	(0x0024)
+#define I2S_RXDR	(0x0028)
+
+#endif /* _ROCKCHIP_IIS_H */
-- 
1.7.9.5


