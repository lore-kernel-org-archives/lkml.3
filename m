Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaJ0THk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:07:40 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:37707 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaJ0THe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:07:34 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] ASoC: add xtensa xtfpga I2S interface and platform
Date: Mon, 27 Oct 2014 22:07:05 +0300
Message-Id: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XTFPGA boards providean audio subsystem that consists of TI CDCE706
clock synthesizer, I2S transmitter and TLV320AIC23 audio codec.

I2S transmitter has MMIO-based interface that resembles that of the
OpenCores I2S transmitter. I2S transmitter is always a master on I2S
bus. There's no specialized audio DMA, sample data are transferred to
I2S transmitter FIFO by CPU through memory-mapped queue interface.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 .../devicetree/bindings/sound/cdns,xtfpga-i2s.txt  |  18 +
 MAINTAINERS                                        |   1 +
 sound/soc/Kconfig                                  |   1 +
 sound/soc/Makefile                                 |   1 +
 sound/soc/xtensa/Kconfig                           |  14 +
 sound/soc/xtensa/Makefile                          |   1 +
 sound/soc/xtensa/xtfpga-i2s.c                      | 647 +++++++++++++++++++++
 7 files changed, 683 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/cdns,xtfpga-i2s.txt
 create mode 100644 sound/soc/xtensa/Kconfig
 create mode 100644 sound/soc/xtensa/Makefile
 create mode 100644 sound/soc/xtensa/xtfpga-i2s.c

diff --git a/Documentation/devicetree/bindings/sound/cdns,xtfpga-i2s.txt b/Documentation/devicetree/bindings/sound/cdns,xtfpga-i2s.txt
new file mode 100644
index 0000000..befd125
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/cdns,xtfpga-i2s.txt
@@ -0,0 +1,18 @@
+Bindings for I2S controller built into xtfpga Xtensa bitstreams.
+
+Required properties:
+- compatible: shall be "cdns,xtfpga-i2s".
+- reg: memory region (address and length) with device registers.
+- interrupts: interrupt for the device.
+- clocks: phandle to the clk used as master clock. I2S bus clock
+  is derived from it.
+
+Examples:
+
+	i2s0: xtfpga-i2s@0d080000 {
+		#sound-dai-cells = <0>;
+		compatible = "cdns,xtfpga-i2s";
+		reg = <0x0d080000 0x40>;
+		interrupts = <2 1>;
+		clocks = <&cdce706 4>;
+	};
diff --git a/MAINTAINERS b/MAINTAINERS
index acb4523..d7bfeec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10204,6 +10204,7 @@ M:	Max Filippov <jcmvbkbc@gmail.com>
 L:	linux-xtensa@linux-xtensa.org
 S:	Maintained
 F:	drivers/spi/spi-xtensa-xtfpga.c
+F:	sound/soc/xtensa/xtfpga-i2s.c
 
 YAM DRIVER FOR AX.25
 M:	Jean-Paul Roubelat <jpr@f6fbb.org>
diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index 0e96233..9ca12e7 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -56,6 +56,7 @@ source "sound/soc/spear/Kconfig"
 source "sound/soc/tegra/Kconfig"
 source "sound/soc/txx9/Kconfig"
 source "sound/soc/ux500/Kconfig"
+source "sound/soc/xtensa/Kconfig"
 
 # Supported codecs
 source "sound/soc/codecs/Kconfig"
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index 534714a..99d7222 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -33,3 +33,4 @@ obj-$(CONFIG_SND_SOC)	+= spear/
 obj-$(CONFIG_SND_SOC)	+= tegra/
 obj-$(CONFIG_SND_SOC)	+= txx9/
 obj-$(CONFIG_SND_SOC)	+= ux500/
+obj-$(CONFIG_SND_SOC)	+= xtensa/
diff --git a/sound/soc/xtensa/Kconfig b/sound/soc/xtensa/Kconfig
new file mode 100644
index 0000000..98d6e0c
--- /dev/null
+++ b/sound/soc/xtensa/Kconfig
@@ -0,0 +1,14 @@
+config SND_SOC_XTFPGA_I2S
+	tristate
+	select REGMAP_MMIO
+
+config SND_SOC_XTENSA_XTFPGA
+	tristate "SoC Audio for xtensa xtfpga"
+	depends on XTENSA_PLATFORM_XTFPGA
+	select SND_SOC_XTFPGA_I2S
+	select SND_SOC_TLV320AIC23_SPI
+	select SND_SIMPLE_CARD
+	help
+	  Say Y or M if you want to add support for codecs attached to
+	  xtfpga daughter board. You will also need to select the platform
+	  to support below.
diff --git a/sound/soc/xtensa/Makefile b/sound/soc/xtensa/Makefile
new file mode 100644
index 0000000..97b8eb5
--- /dev/null
+++ b/sound/soc/xtensa/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SND_SOC_XTFPGA_I2S) += xtfpga-i2s.o
diff --git a/sound/soc/xtensa/xtfpga-i2s.c b/sound/soc/xtensa/xtfpga-i2s.c
new file mode 100644
index 0000000..393d5c3
--- /dev/null
+++ b/sound/soc/xtensa/xtfpga-i2s.c
@@ -0,0 +1,647 @@
+/*
+ * Xtfpga I2S controller driver
+ *
+ * Copyright (c) 2014 Cadence Design Systems Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+
+#define DRV_NAME	"xtfpga-i2s"
+
+#define XTFPGA_I2S_VERSION	0x00
+#define XTFPGA_I2S_CONFIG	0x04
+#define XTFPGA_I2S_INT_MASK	0x08
+#define XTFPGA_I2S_INT_STATUS	0x0c
+#define XTFPGA_I2S_CHAN0_DATA	0x10
+#define XTFPGA_I2S_CHAN1_DATA	0x14
+#define XTFPGA_I2S_CHAN2_DATA	0x18
+#define XTFPGA_I2S_CHAN3_DATA	0x1c
+
+#define XTFPGA_I2S_CONFIG_TX_ENABLE	0x1
+#define XTFPGA_I2S_CONFIG_INT_ENABLE	0x2
+#define XTFPGA_I2S_CONFIG_LEFT		0x4
+#define XTFPGA_I2S_CONFIG_RATIO_BASE	8
+#define XTFPGA_I2S_CONFIG_RATIO_MASK	0x0000ff00
+#define XTFPGA_I2S_CONFIG_RES_BASE	16
+#define XTFPGA_I2S_CONFIG_RES_MASK	0x003f0000
+#define XTFPGA_I2S_CONFIG_LEVEL_BASE	24
+#define XTFPGA_I2S_CONFIG_LEVEL_MASK	0x0f000000
+#define XTFPGA_I2S_CONFIG_CHANNEL_BASE	28
+
+#define XTFPGA_I2S_INT_UNDERRUN		0x1
+#define XTFPGA_I2S_INT_LEVEL		0x2
+#define XTFPGA_I2S_INT_VALID		0x3
+
+#define XTFPGA_I2S_FIFO_SIZE		8192
+#define XTFPGA_I2S_CONFIG_DEFAULT_LEVEL	3
+
+/*
+ * I2S controller operation:
+ *
+ * Enabling TX: output 1 period of zeros (starting with left channel)
+ * and then queued data.
+ *
+ * Level status and interrupt: whenever FIFO level is below FIFO trigger,
+ * level status is 1 and an IRQ is asserted (if enabled).
+ *
+ * Underrun status and interrupt: whenever FIFO is empty, underrun status
+ * is 1 and an IRQ is asserted (if enabled).
+ */
+struct xtfpga_i2s {
+	struct device *dev;
+	struct clk *clk;
+	bool clk_enabled;
+	struct regmap *regmap;
+	void __iomem *regs;
+
+	struct snd_pcm_substream *tx_substream;
+	unsigned tx_ptr; /* next frame index in the sample buffer */
+	unsigned tx_fifo_sz; /* current fifo level estimate */
+	unsigned tx_fifo_low; /* FIFO level when level interrupt occurs */
+	unsigned tx_fifo_high; /* maximal FIFO level */
+	struct tasklet_struct refill_fifo; /* FIFO refilling tasklet */
+};
+
+static bool xtfpga_i2s_wr_reg(struct device *dev, unsigned int reg)
+{
+	return reg >= XTFPGA_I2S_CONFIG;
+}
+
+static bool xtfpga_i2s_rd_reg(struct device *dev, unsigned int reg)
+{
+	return reg < XTFPGA_I2S_CHAN0_DATA;
+}
+
+static bool xtfpga_i2s_volatile_reg(struct device *dev, unsigned int reg)
+{
+	return reg == XTFPGA_I2S_INT_STATUS;
+}
+
+static const struct regmap_config xtfpga_i2s_regmap_config = {
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.val_bits = 32,
+	.max_register = XTFPGA_I2S_CHAN3_DATA,
+	.writeable_reg = xtfpga_i2s_wr_reg,
+	.readable_reg = xtfpga_i2s_rd_reg,
+	.volatile_reg = xtfpga_i2s_volatile_reg,
+	.cache_type = REGCACHE_FLAT,
+};
+
+static void xtfpga_i2s_push_tx(struct xtfpga_i2s *i2s)
+{
+	struct snd_pcm_substream *tx_substream;
+	struct snd_pcm_runtime *runtime;
+
+	rcu_read_lock();
+	tx_substream = rcu_dereference(i2s->tx_substream);
+	runtime = tx_substream->runtime;
+#define xtfpga_i2s_tx_loop(i2s, runtime, channels, sample_bits) \
+	do { \
+		const u##sample_bits (*p)[channels] = \
+			(void *)runtime->dma_area; \
+		for (; i2s->tx_fifo_sz < i2s->tx_fifo_high; \
+		     i2s->tx_fifo_sz += 2) { \
+			iowrite32(p[i2s->tx_ptr][0], \
+				  i2s->regs + XTFPGA_I2S_CHAN0_DATA); \
+			iowrite32(p[i2s->tx_ptr][channels - 1], \
+				  i2s->regs + XTFPGA_I2S_CHAN0_DATA); \
+			if (++i2s->tx_ptr >= runtime->buffer_size) \
+				i2s->tx_ptr = 0; \
+		} \
+	} while (0)
+
+	switch (runtime->sample_bits | (runtime->channels << 8)) {
+	case 0x110:
+		xtfpga_i2s_tx_loop(i2s, runtime, 1, 16);
+		break;
+	case 0x210:
+		xtfpga_i2s_tx_loop(i2s, runtime, 2, 16);
+		break;
+	case 0x120:
+		xtfpga_i2s_tx_loop(i2s, runtime, 1, 32);
+		break;
+	case 0x220:
+		xtfpga_i2s_tx_loop(i2s, runtime, 2, 32);
+		break;
+	}
+	rcu_read_unlock();
+}
+
+static void xtfpga_i2s_irq_update_config(struct xtfpga_i2s *i2s,
+					 unsigned int_status)
+{
+	if (!(int_status & XTFPGA_I2S_INT_LEVEL))
+		regmap_write(i2s->regmap, XTFPGA_I2S_INT_MASK,
+			     XTFPGA_I2S_INT_VALID);
+	else if (!(int_status & XTFPGA_I2S_INT_UNDERRUN))
+		regmap_write(i2s->regmap, XTFPGA_I2S_INT_MASK,
+			     XTFPGA_I2S_INT_UNDERRUN);
+
+	if (!(int_status & XTFPGA_I2S_INT_UNDERRUN))
+		regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
+				   XTFPGA_I2S_CONFIG_INT_ENABLE |
+				   XTFPGA_I2S_CONFIG_TX_ENABLE,
+				   XTFPGA_I2S_CONFIG_INT_ENABLE |
+				   XTFPGA_I2S_CONFIG_TX_ENABLE);
+}
+
+static void xtfpga_i2s_refill_fifo(struct xtfpga_i2s *i2s)
+{
+	struct snd_pcm_substream *tx_substream;
+	unsigned int_status;
+	unsigned i;
+
+	rcu_read_lock();
+	tx_substream = rcu_dereference(i2s->tx_substream);
+	if (tx_substream && snd_pcm_running(tx_substream)) {
+		for (i = 0; i < 2; ++i) {
+			xtfpga_i2s_push_tx(i2s);
+			regmap_write(i2s->regmap, XTFPGA_I2S_INT_STATUS,
+				     XTFPGA_I2S_INT_VALID);
+			regmap_read(i2s->regmap, XTFPGA_I2S_INT_STATUS,
+				    &int_status);
+
+			if (!(int_status & XTFPGA_I2S_INT_LEVEL))
+				break;
+			i2s->tx_fifo_sz = i2s->tx_fifo_low;
+		}
+	} else {
+		regmap_read(i2s->regmap, XTFPGA_I2S_INT_STATUS,
+			    &int_status);
+	}
+	rcu_read_unlock();
+	xtfpga_i2s_irq_update_config(i2s, int_status);
+}
+
+static void xtfpga_i2s_refill_fifo_tasklet(unsigned long p)
+{
+	xtfpga_i2s_refill_fifo((struct xtfpga_i2s *)p);
+}
+
+static irqreturn_t xtfpga_i2s_interrupt(int irq, void *dev_id)
+{
+	struct xtfpga_i2s *i2s = dev_id;
+	struct snd_pcm_substream *tx_substream;
+	int tx_active;
+	unsigned int_status;
+
+	regmap_read(i2s->regmap, XTFPGA_I2S_INT_STATUS, &int_status);
+	if (!(int_status & XTFPGA_I2S_INT_VALID))
+		return IRQ_NONE;
+
+	if (int_status & XTFPGA_I2S_INT_UNDERRUN) {
+		i2s->tx_fifo_sz = 0;
+		regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
+				   XTFPGA_I2S_CONFIG_INT_ENABLE |
+				   XTFPGA_I2S_CONFIG_TX_ENABLE, 0);
+	} else {
+		i2s->tx_fifo_sz = i2s->tx_fifo_low;
+		regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
+				   XTFPGA_I2S_CONFIG_INT_ENABLE, 0);
+	}
+
+	rcu_read_lock();
+	tx_substream = rcu_dereference(i2s->tx_substream);
+	tx_active = tx_substream && snd_pcm_running(tx_substream);
+	if (tx_active) {
+		snd_pcm_period_elapsed(tx_substream);
+		if (int_status & XTFPGA_I2S_INT_UNDERRUN)
+			dev_dbg_ratelimited(i2s->dev, "%s: underrun\n",
+					    __func__);
+		tx_substream = rcu_dereference(i2s->tx_substream);
+		tx_active = tx_substream && snd_pcm_running(tx_substream);
+	}
+	rcu_read_unlock();
+
+	if (tx_active) {
+		if (i2s->tx_fifo_high < 256)
+			xtfpga_i2s_refill_fifo(i2s);
+		else
+			tasklet_hi_schedule(&i2s->refill_fifo);
+	} else {
+		xtfpga_i2s_irq_update_config(i2s, int_status);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int xtfpga_i2s_startup(struct snd_pcm_substream *substream,
+				 struct snd_soc_dai *dai)
+{
+	struct xtfpga_i2s *i2s = snd_soc_dai_get_drvdata(dai);
+
+	snd_soc_dai_set_dma_data(dai, substream, i2s);
+	return 0;
+}
+
+static int xtfpga_i2s_start(struct xtfpga_i2s *i2s,
+			    struct snd_pcm_substream *substream)
+{
+	i2s->tx_ptr = 0;
+	rcu_assign_pointer(i2s->tx_substream, substream);
+
+	xtfpga_i2s_push_tx(i2s);
+	regmap_write(i2s->regmap, XTFPGA_I2S_INT_STATUS, XTFPGA_I2S_INT_VALID);
+	regmap_write(i2s->regmap, XTFPGA_I2S_INT_MASK, XTFPGA_I2S_INT_VALID);
+	regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
+			   XTFPGA_I2S_CONFIG_INT_ENABLE |
+			   XTFPGA_I2S_CONFIG_TX_ENABLE,
+			   XTFPGA_I2S_CONFIG_INT_ENABLE |
+			   XTFPGA_I2S_CONFIG_TX_ENABLE);
+	return 0;
+}
+
+static int xtfpga_i2s_stop(struct xtfpga_i2s *i2s,
+			   struct snd_pcm_substream *substream)
+{
+	rcu_assign_pointer(i2s->tx_substream, NULL);
+	return 0;
+}
+
+static int xtfpga_i2s_trigger(struct snd_pcm_substream *substream, int cmd,
+				 struct snd_soc_dai *dai)
+{
+	int ret;
+	struct xtfpga_i2s *i2s = snd_soc_dai_get_drvdata(dai);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		ret = xtfpga_i2s_start(i2s, substream);
+		break;
+
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		ret = xtfpga_i2s_stop(i2s, substream);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int xtfpga_i2s_hw_params(struct snd_pcm_substream *substream,
+				   struct snd_pcm_hw_params *params,
+				   struct snd_soc_dai *dai)
+{
+	struct xtfpga_i2s *i2s = snd_soc_dai_get_drvdata(dai);
+	unsigned srate = params_rate(params);
+	unsigned channels = params_channels(params);
+	unsigned period_size = params_period_size(params);
+	unsigned sample_size = snd_pcm_format_width(params_format(params));
+	unsigned freq, ratio, level;
+	int err;
+
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S16_LE:
+	case SNDRV_PCM_FORMAT_S32_LE:
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
+			   XTFPGA_I2S_CONFIG_RES_MASK,
+			   sample_size << XTFPGA_I2S_CONFIG_RES_BASE);
+
+	if (i2s->clk_enabled) {
+		clk_disable_unprepare(i2s->clk);
+		i2s->clk_enabled = false;
+	}
+	freq = 256 * srate;
+	err = clk_set_rate(i2s->clk, freq);
+	if (err < 0)
+		return err;
+
+	err = clk_prepare_enable(i2s->clk);
+	if (err < 0)
+		return err;
+	i2s->clk_enabled = true;
+
+	ratio = (freq - srate * sample_size * 8) /
+		(srate * sample_size * 4);
+
+	regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
+			   XTFPGA_I2S_CONFIG_RATIO_MASK,
+			   ratio << XTFPGA_I2S_CONFIG_RATIO_BASE);
+
+	i2s->tx_fifo_low = XTFPGA_I2S_FIFO_SIZE / 2;
+	for (level = 1;
+	     /* period_size * 2: FIFO always gets 2 samples per frame */
+	     i2s->tx_fifo_low / 2 >= period_size * 2;
+	     ++level)
+		i2s->tx_fifo_low /= 2;
+
+	i2s->tx_fifo_high = 2 * i2s->tx_fifo_low;
+	i2s->tx_fifo_sz = 0;
+	i2s->tx_ptr = 0;
+
+	regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
+			   XTFPGA_I2S_CONFIG_LEVEL_MASK,
+			   level << XTFPGA_I2S_CONFIG_LEVEL_BASE);
+
+	dev_dbg(i2s->dev,
+		"%s srate: %u, channels: %u, sample_size: %u, period_size: %u\n",
+		__func__, srate, channels, sample_size, period_size);
+	dev_dbg(i2s->dev, "%s freq: %u, ratio: %u, level: %u\n",
+		__func__, freq, ratio, level);
+
+	return 0;
+}
+
+static int xtfpga_i2s_hw_free(struct snd_pcm_substream *substream,
+			      struct snd_soc_dai *dai)
+{
+	struct xtfpga_i2s *i2s = snd_soc_dai_get_drvdata(dai);
+
+	if (i2s->clk_enabled) {
+		clk_disable_unprepare(i2s->clk);
+		i2s->clk_enabled = false;
+	}
+	return 0;
+}
+
+static int xtfpga_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
+				 unsigned int fmt)
+{
+	if ((fmt & SND_SOC_DAIFMT_INV_MASK) != SND_SOC_DAIFMT_NB_NF)
+		return -EINVAL;
+	if ((fmt & SND_SOC_DAIFMT_MASTER_MASK) != SND_SOC_DAIFMT_CBS_CFS)
+		return -EINVAL;
+	if ((fmt & SND_SOC_DAIFMT_FORMAT_MASK) != SND_SOC_DAIFMT_I2S)
+		return -EINVAL;
+
+	return 0;
+}
+
+/* PCM */
+
+static const struct snd_pcm_hardware xtfpga_pcm_hardware = {
+	.info = SNDRV_PCM_INFO_INTERLEAVED |
+		SNDRV_PCM_INFO_MMAP_VALID |
+		SNDRV_PCM_INFO_BLOCK_TRANSFER,
+	.formats		= SNDRV_PCM_FMTBIT_S16_LE |
+				  SNDRV_PCM_FMTBIT_S32_LE,
+	.channels_min		= 1,
+	.channels_max		= 2,
+	.period_bytes_min	= 2,
+	.period_bytes_max	= XTFPGA_I2S_FIFO_SIZE / 2 * 8,
+	.periods_min		= 2,
+	.periods_max		= XTFPGA_I2S_FIFO_SIZE * 8 / 2,
+	.buffer_bytes_max	= XTFPGA_I2S_FIFO_SIZE * 8,
+	.fifo_size		= 16,
+};
+
+static int xtfpga_pcm_open(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	void *p;
+
+	snd_soc_set_runtime_hwparams(substream, &xtfpga_pcm_hardware);
+	p = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
+	runtime->private_data = p;
+
+	return 0;
+}
+
+static int xtfpga_pcm_close(struct snd_pcm_substream *substream)
+{
+	synchronize_rcu();
+	return 0;
+}
+
+static int xtfpga_pcm_hw_params(struct snd_pcm_substream *substream,
+				struct snd_pcm_hw_params *hw_params)
+{
+	int ret;
+
+	ret = snd_pcm_lib_malloc_pages(substream,
+				       params_buffer_bytes(hw_params));
+	return ret;
+}
+
+static int xtfpga_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	int ret;
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		ret = 0;
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static snd_pcm_uframes_t xtfpga_pcm_pointer(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct xtfpga_i2s *i2s = runtime->private_data;
+	snd_pcm_uframes_t pos = i2s->tx_ptr;
+
+	return pos < runtime->buffer_size ? pos : 0;
+}
+
+static int xtfpga_pcm_new(struct snd_soc_pcm_runtime *rtd)
+{
+	struct snd_card *card = rtd->card->snd_card;
+	size_t size = xtfpga_pcm_hardware.buffer_bytes_max;
+
+	return snd_pcm_lib_preallocate_pages_for_all(rtd->pcm,
+						     SNDRV_DMA_TYPE_DEV,
+						     card->dev, size, size);
+}
+
+static void xtfpga_pcm_free(struct snd_pcm *pcm)
+{
+	snd_pcm_lib_preallocate_free_for_all(pcm);
+}
+
+static struct snd_pcm_ops xtfpga_pcm_ops = {
+	.open		= xtfpga_pcm_open,
+	.close		= xtfpga_pcm_close,
+	.ioctl		= snd_pcm_lib_ioctl,
+	.hw_params	= xtfpga_pcm_hw_params,
+	.trigger	= xtfpga_pcm_trigger,
+	.pointer	= xtfpga_pcm_pointer,
+};
+
+struct snd_soc_platform_driver xtfpga_soc_platform = {
+	.pcm_new	= xtfpga_pcm_new,
+	.pcm_free	= xtfpga_pcm_free,
+	.ops		= &xtfpga_pcm_ops,
+};
+
+static const struct snd_soc_component_driver xtfpga_i2s_component = {
+	.name		= DRV_NAME,
+};
+
+static const struct snd_soc_dai_ops xtfpga_i2s_dai_ops = {
+	.startup	= xtfpga_i2s_startup,
+	.trigger	= xtfpga_i2s_trigger,
+	.hw_params      = xtfpga_i2s_hw_params,
+	.hw_free	= xtfpga_i2s_hw_free,
+	.set_fmt        = xtfpga_i2s_set_fmt,
+};
+
+static struct snd_soc_dai_driver xtfpga_i2s_dai[] = {
+	{
+		.name = "xtfpga-i2s",
+		.id = 0,
+		.playback = {
+			.channels_min = 1,
+			.channels_max = 2,
+			.rates = SNDRV_PCM_RATE_8000_96000,
+			.formats = SNDRV_PCM_FMTBIT_S16_LE |
+				   SNDRV_PCM_FMTBIT_S32_LE,
+		},
+		.ops = &xtfpga_i2s_dai_ops,
+	},
+};
+
+static int xtfpga_i2s_probe(struct platform_device *pdev)
+{
+	struct xtfpga_i2s *i2s;
+	struct resource *mem, *irq;
+	int err;
+
+	i2s = devm_kzalloc(&pdev->dev, sizeof(*i2s), GFP_KERNEL);
+	if (!i2s) {
+		err = -ENOMEM;
+		goto err;
+	}
+	dev_set_drvdata(&pdev->dev, i2s);
+	i2s->dev = &pdev->dev;
+	dev_dbg(&pdev->dev, "dev: %p, i2s: %p\n", &pdev->dev, i2s);
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&pdev->dev, "No memory resource\n");
+		err = -ENODEV;
+		goto err;
+	}
+	i2s->regs = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(i2s->regs)) {
+		err = PTR_ERR(i2s->regs);
+		goto err;
+	}
+
+	i2s->regmap = devm_regmap_init_mmio(&pdev->dev, i2s->regs,
+					    &xtfpga_i2s_regmap_config);
+	if (IS_ERR(i2s->regmap)) {
+		dev_err(&pdev->dev, "regmap init failed\n");
+		err = PTR_ERR(i2s->regmap);
+		goto err;
+	}
+
+	i2s->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(i2s->clk)) {
+		dev_err(&pdev->dev, "couldn't get clock\n");
+		err = PTR_ERR(i2s->clk);
+		goto err;
+	}
+
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!irq) {
+		dev_err(&pdev->dev, "No IRQ resource\n");
+		err = -ENODEV;
+		goto err;
+	}
+	err = devm_request_irq(&pdev->dev, irq->start, xtfpga_i2s_interrupt,
+			       IRQF_SHARED, pdev->name, i2s);
+	if (err < 0) {
+		dev_err(&pdev->dev, "request_irq failed\n");
+		goto err;
+	}
+	tasklet_init(&i2s->refill_fifo, xtfpga_i2s_refill_fifo_tasklet,
+		     (unsigned long)i2s);
+
+	regmap_write(i2s->regmap, XTFPGA_I2S_CONFIG,
+		     (0x1 << XTFPGA_I2S_CONFIG_CHANNEL_BASE));
+	regmap_write(i2s->regmap, XTFPGA_I2S_INT_STATUS, XTFPGA_I2S_INT_VALID);
+	regmap_write(i2s->regmap, XTFPGA_I2S_INT_MASK, XTFPGA_I2S_INT_UNDERRUN);
+
+	err = snd_soc_register_platform(&pdev->dev, &xtfpga_soc_platform);
+	if (err < 0) {
+		dev_err(&pdev->dev, "couldn't register platform\n");
+		goto err;
+	}
+	err = devm_snd_soc_register_component(&pdev->dev,
+					      &xtfpga_i2s_component,
+					      xtfpga_i2s_dai,
+					      ARRAY_SIZE(xtfpga_i2s_dai));
+	if (err < 0)
+		dev_err(&pdev->dev, "couldn't register component\n");
+err:
+	if (err)
+		dev_err(&pdev->dev, "%s: err = %d\n", __func__, err);
+	return err;
+}
+
+static int xtfpga_i2s_remove(struct platform_device *pdev)
+{
+	struct xtfpga_i2s *i2s = dev_get_drvdata(&pdev->dev);
+
+	if (i2s) {
+		tasklet_kill(&i2s->refill_fifo);
+		if (i2s->regmap && !IS_ERR(i2s->regmap)) {
+			regmap_write(i2s->regmap, XTFPGA_I2S_CONFIG, 0);
+			regmap_write(i2s->regmap, XTFPGA_I2S_INT_MASK, 0);
+			regmap_write(i2s->regmap, XTFPGA_I2S_INT_STATUS,
+				     XTFPGA_I2S_INT_VALID);
+		}
+		if (i2s->clk_enabled)
+			clk_disable_unprepare(i2s->clk);
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id xtfpga_i2s_of_match[] = {
+	{ .compatible = "cdns,xtfpga-i2s", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, xtfpga_i2s_of_match);
+#endif
+
+static struct platform_driver xtfpga_i2s_driver = {
+	.probe   = xtfpga_i2s_probe,
+	.remove  = xtfpga_i2s_remove,
+	.driver  = {
+		.name = "xtfpga-i2s",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(xtfpga_i2s_of_match),
+	},
+};
+
+module_platform_driver(xtfpga_i2s_driver);
+
+MODULE_AUTHOR("Max Filippov <jcmvbkbc@gmail.com>");
+MODULE_DESCRIPTION("xtfpga I2S controller driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.1.4

