Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaLGBBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 20:01:55 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:62591 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaLGBBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 20:01:53 -0500
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
Subject: [PATCH v3] ASoC: add xtensa xtfpga I2S interface and platform
Date: Sun,  7 Dec 2014 04:01:35 +0300
Message-Id: <1417914095-26553-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XTFPGA boards provides an audio subsystem that consists of TI CDCE706
clock synthesizer, I2S transmitter and TLV320AIC23 audio codec.

I2S transmitter has MMIO-based interface that resembles that of the
OpenCores I2S transmitter. I2S transmitter is always a master on I2S
bus. There's no specialized audio DMA, sample data are transferred to
I2S transmitter FIFO by CPU through memory-mapped queue interface.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
Changes v2->v3:
- drop .owner = THIS_MODULE from the struct platform_driver initialization;
- rebase to 3.18-rc7.

Changes v1->v2:
- fix module name in the sound/soc/xtensa/Makefile;
- split PCM data transfer code and I2S interface setup code;
- move clock enabling/disabling to runtime PM code;
- document I2S interface RATIO field;
- rewrite I2S interface LEVEL field calculation to avoid overflows;
- drop select statements from Kconfig;
- document RCU usage for tx_substream;
- clean up code running in RCU read-side critical section;
- use threaded IRQ handler instead of IRQ + tasklet;
- remove empty PCM callback handlers;
- add const to static structures where applicable;
- use platform_set_drvdata instead of dev_set_drvdata;
- drop redundant error reporting code;
- use platform_get_irq instead of platform_get_resource;
- clean up xtfpga_i2s_remove;
- add comments.

 .../devicetree/bindings/sound/cdns,xtfpga-i2s.txt  |  18 +
 MAINTAINERS                                        |   1 +
 sound/soc/Kconfig                                  |   1 +
 sound/soc/Makefile                                 |   1 +
 sound/soc/xtensa/Kconfig                           |   7 +
 sound/soc/xtensa/Makefile                          |   3 +
 sound/soc/xtensa/xtfpga-i2s.c                      | 675 +++++++++++++++++++++
 7 files changed, 706 insertions(+)
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
index 180d560..6a09926 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10409,6 +10409,7 @@ M:	Max Filippov <jcmvbkbc@gmail.com>
 L:	linux-xtensa@linux-xtensa.org
 S:	Maintained
 F:	drivers/spi/spi-xtensa-xtfpga.c
+F:	sound/soc/xtensa/xtfpga-i2s.c
 
 YAM DRIVER FOR AX.25
 M:	Jean-Paul Roubelat <jpr@f6fbb.org>
diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index 7d5d644..dcc79aa 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -55,6 +55,7 @@ source "sound/soc/spear/Kconfig"
 source "sound/soc/tegra/Kconfig"
 source "sound/soc/txx9/Kconfig"
 source "sound/soc/ux500/Kconfig"
+source "sound/soc/xtensa/Kconfig"
 
 # Supported codecs
 source "sound/soc/codecs/Kconfig"
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index d88edfc..6c24e6a 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -32,3 +32,4 @@ obj-$(CONFIG_SND_SOC)	+= spear/
 obj-$(CONFIG_SND_SOC)	+= tegra/
 obj-$(CONFIG_SND_SOC)	+= txx9/
 obj-$(CONFIG_SND_SOC)	+= ux500/
+obj-$(CONFIG_SND_SOC)	+= xtensa/
diff --git a/sound/soc/xtensa/Kconfig b/sound/soc/xtensa/Kconfig
new file mode 100644
index 0000000..c201beb
--- /dev/null
+++ b/sound/soc/xtensa/Kconfig
@@ -0,0 +1,7 @@
+config SND_SOC_XTFPGA_I2S
+	tristate "XTFPGA I2S master"
+	select REGMAP_MMIO
+	help
+	  Say Y or M if you want to add support for codecs attached to the
+	  I2S interface on XTFPGA daughter board. You will also need to select
+	  the drivers for the rest of XTFPGA audio subsystem.
diff --git a/sound/soc/xtensa/Makefile b/sound/soc/xtensa/Makefile
new file mode 100644
index 0000000..15efbf9
--- /dev/null
+++ b/sound/soc/xtensa/Makefile
@@ -0,0 +1,3 @@
+snd-soc-xtfpga-i2s-objs := xtfpga-i2s.o
+
+obj-$(CONFIG_SND_SOC_XTFPGA_I2S) += snd-soc-xtfpga-i2s.o
diff --git a/sound/soc/xtensa/xtfpga-i2s.c b/sound/soc/xtensa/xtfpga-i2s.c
new file mode 100644
index 0000000..1cfb19e
--- /dev/null
+++ b/sound/soc/xtensa/xtfpga-i2s.c
@@ -0,0 +1,675 @@
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
+#include <linux/pm_runtime.h>
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
+	struct regmap *regmap;
+	void __iomem *regs;
+
+	/* current playback substream. NULL if not playing.
+	 *
+	 * Access to that field is synchronized between the interrupt handler
+	 * and userspace through RCU.
+	 *
+	 * Interrupt handler (threaded part) does PIO on substream data in RCU
+	 * read-side critical section. Trigger callback sets and clears the
+	 * pointer when the playback is started and stopped with
+	 * rcu_assign_pointer. When userspace is about to free the playback
+	 * stream in the pcm_close callback it synchronizes with the interrupt
+	 * handler by means of synchronize_rcu call.
+	 */
+	struct snd_pcm_substream *tx_substream;
+	unsigned (*tx_fn)(struct xtfpga_i2s *i2s,
+			  struct snd_pcm_runtime *runtime,
+			  unsigned tx_ptr);
+	unsigned tx_ptr; /* next frame index in the sample buffer */
+
+	/* current fifo level estimate.
+	 * Doesn't have to be perfectly accurate, but must be not less than
+	 * the actual FIFO level in order to avoid stall on push attempt.
+	 */
+	unsigned tx_fifo_level;
+
+	/* FIFO level at which level interrupt occurs */
+	unsigned tx_fifo_low;
+
+	/* maximal FIFO level */
+	unsigned tx_fifo_high;
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
+/* Generate functions that do PIO from TX DMA area to FIFO for all supported
+ * stream formats.
+ * Functions will be called xtfpga_pcm_tx_<channels>x<sample bits>, e.g.
+ * xtfpga_pcm_tx_2x16 for 16-bit stereo.
+ *
+ * FIFO consists of 32-bit words, one word per channel, always 2 channels.
+ * If I2S interface is configured with smaller sample resolution, only
+ * the LSB of each word is used.
+ */
+#define xtfpga_pcm_tx_fn(channels, sample_bits) \
+static unsigned xtfpga_pcm_tx_##channels##x##sample_bits( \
+	struct xtfpga_i2s *i2s, struct snd_pcm_runtime *runtime, \
+	unsigned tx_ptr) \
+{ \
+	const u##sample_bits (*p)[channels] = \
+		(void *)runtime->dma_area; \
+\
+	for (; i2s->tx_fifo_level < i2s->tx_fifo_high; \
+	     i2s->tx_fifo_level += 2) { \
+		iowrite32(p[tx_ptr][0], \
+			  i2s->regs + XTFPGA_I2S_CHAN0_DATA); \
+		iowrite32(p[tx_ptr][channels - 1], \
+			  i2s->regs + XTFPGA_I2S_CHAN0_DATA); \
+		if (++tx_ptr >= runtime->buffer_size) \
+			tx_ptr = 0; \
+	} \
+	return tx_ptr; \
+}
+
+xtfpga_pcm_tx_fn(1, 16)
+xtfpga_pcm_tx_fn(2, 16)
+xtfpga_pcm_tx_fn(1, 32)
+xtfpga_pcm_tx_fn(2, 32)
+
+#undef xtfpga_pcm_tx_fn
+
+static bool xtfpga_pcm_push_tx(struct xtfpga_i2s *i2s)
+{
+	struct snd_pcm_substream *tx_substream;
+	bool tx_active;
+
+	rcu_read_lock();
+	tx_substream = rcu_dereference(i2s->tx_substream);
+	tx_active = tx_substream && snd_pcm_running(tx_substream);
+	if (tx_active) {
+		unsigned tx_ptr = ACCESS_ONCE(i2s->tx_ptr);
+		unsigned new_tx_ptr = i2s->tx_fn(i2s, tx_substream->runtime,
+						 tx_ptr);
+
+		cmpxchg(&i2s->tx_ptr, tx_ptr, new_tx_ptr);
+	}
+	rcu_read_unlock();
+
+	return tx_active;
+}
+
+static void xtfpga_pcm_refill_fifo(struct xtfpga_i2s *i2s)
+{
+	unsigned int_status;
+	unsigned i;
+
+	regmap_read(i2s->regmap, XTFPGA_I2S_INT_STATUS,
+		    &int_status);
+
+	for (i = 0; i < 2; ++i) {
+		bool tx_active = xtfpga_pcm_push_tx(i2s);
+
+		regmap_write(i2s->regmap, XTFPGA_I2S_INT_STATUS,
+			     XTFPGA_I2S_INT_VALID);
+		if (tx_active)
+			regmap_read(i2s->regmap, XTFPGA_I2S_INT_STATUS,
+				    &int_status);
+
+		if (!tx_active ||
+		    !(int_status & XTFPGA_I2S_INT_LEVEL))
+			break;
+
+		/* After the push the level IRQ is still asserted,
+		 * means FIFO level is below tx_fifo_low. Estimate
+		 * it as tx_fifo_low.
+		 */
+		i2s->tx_fifo_level = i2s->tx_fifo_low;
+	}
+
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
+	else
+		regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
+				   XTFPGA_I2S_CONFIG_INT_ENABLE |
+				   XTFPGA_I2S_CONFIG_TX_ENABLE, 0);
+}
+
+static irqreturn_t xtfpga_i2s_threaded_irq_handler(int irq, void *dev_id)
+{
+	struct xtfpga_i2s *i2s = dev_id;
+	struct snd_pcm_substream *tx_substream;
+	unsigned config, int_status, int_mask;
+
+	regmap_read(i2s->regmap, XTFPGA_I2S_CONFIG, &config);
+	regmap_read(i2s->regmap, XTFPGA_I2S_INT_MASK, &int_mask);
+	regmap_read(i2s->regmap, XTFPGA_I2S_INT_STATUS, &int_status);
+
+	if (!(config & XTFPGA_I2S_CONFIG_INT_ENABLE) ||
+	    !(int_status & int_mask & XTFPGA_I2S_INT_VALID))
+		return IRQ_NONE;
+
+	/* Update FIFO level estimate in accordance with interrupt status
+	 * register.
+	 */
+	if (int_status & XTFPGA_I2S_INT_UNDERRUN) {
+		i2s->tx_fifo_level = 0;
+		regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
+				   XTFPGA_I2S_CONFIG_TX_ENABLE, 0);
+	} else {
+		/* The FIFO isn't empty, but is below tx_fifo_low. Estimate
+		 * it as tx_fifo_low.
+		 */
+		i2s->tx_fifo_level = i2s->tx_fifo_low;
+	}
+
+	rcu_read_lock();
+	tx_substream = rcu_dereference(i2s->tx_substream);
+
+	if (tx_substream && snd_pcm_running(tx_substream)) {
+		snd_pcm_period_elapsed(tx_substream);
+		if (int_status & XTFPGA_I2S_INT_UNDERRUN)
+			dev_dbg_ratelimited(i2s->dev, "%s: underrun\n",
+					    __func__);
+	}
+	rcu_read_unlock();
+
+	/* Refill FIFO, update allowed IRQ reasons, enable IRQ if FIFO is
+	 * not empty.
+	 */
+	xtfpga_pcm_refill_fifo(i2s);
+
+	return IRQ_HANDLED;
+}
+
+static int xtfpga_i2s_startup(struct snd_pcm_substream *substream,
+			      struct snd_soc_dai *dai)
+{
+	struct xtfpga_i2s *i2s = snd_soc_dai_get_drvdata(dai);
+
+	snd_soc_dai_set_dma_data(dai, substream, i2s);
+	return 0;
+}
+
+static int xtfpga_i2s_hw_params(struct snd_pcm_substream *substream,
+				struct snd_pcm_hw_params *params,
+				struct snd_soc_dai *dai)
+{
+	struct xtfpga_i2s *i2s = snd_soc_dai_get_drvdata(dai);
+	unsigned srate = params_rate(params);
+	unsigned channels = params_channels(params);
+	unsigned period_size = params_period_size(params);
+	unsigned sample_size = snd_pcm_format_width(params_format(params));
+	unsigned freq, ratio, level;
+	int err;
+
+	regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
+			   XTFPGA_I2S_CONFIG_RES_MASK,
+			   sample_size << XTFPGA_I2S_CONFIG_RES_BASE);
+
+	freq = 256 * srate;
+	err = clk_set_rate(i2s->clk, freq);
+	if (err < 0)
+		return err;
+
+	/* ratio field of the config register controls MCLK->I2S clock
+	 * derivation: I2S clock = MCLK / (2 * (ratio + 2)).
+	 *
+	 * So with MCLK = 256 * sample rate ratio is 0 for 32 bit stereo
+	 * and 2 for 16 bit stereo.
+	 */
+	ratio = (freq - (srate * sample_size * 8)) /
+		(srate * sample_size * 4);
+
+	regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
+			   XTFPGA_I2S_CONFIG_RATIO_MASK,
+			   ratio << XTFPGA_I2S_CONFIG_RATIO_BASE);
+
+	i2s->tx_fifo_low = XTFPGA_I2S_FIFO_SIZE / 2;
+
+	/* period_size * 2: FIFO always gets 2 samples per frame */
+	for (level = 1;
+	     i2s->tx_fifo_low / 2 >= period_size * 2 &&
+	     level < (XTFPGA_I2S_CONFIG_LEVEL_MASK >>
+		      XTFPGA_I2S_CONFIG_LEVEL_BASE); ++level)
+		i2s->tx_fifo_low /= 2;
+
+	i2s->tx_fifo_high = 2 * i2s->tx_fifo_low;
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
+static int xtfpga_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
+			      unsigned int fmt)
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
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct xtfpga_i2s *i2s = runtime->private_data;
+	unsigned channels = params_channels(hw_params);
+
+	switch (channels) {
+	case 1:
+	case 2:
+		break;
+
+	default:
+		return -EINVAL;
+
+	}
+
+	switch (params_format(hw_params)) {
+	case SNDRV_PCM_FORMAT_S16_LE:
+		i2s->tx_fn = (channels == 1) ?
+			xtfpga_pcm_tx_1x16 :
+			xtfpga_pcm_tx_2x16;
+		break;
+
+	case SNDRV_PCM_FORMAT_S32_LE:
+		i2s->tx_fn = (channels == 1) ?
+			xtfpga_pcm_tx_1x32 :
+			xtfpga_pcm_tx_2x32;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	ret = snd_pcm_lib_malloc_pages(substream,
+				       params_buffer_bytes(hw_params));
+	return ret;
+}
+
+static int xtfpga_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	int ret = 0;
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct xtfpga_i2s *i2s = runtime->private_data;
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		ACCESS_ONCE(i2s->tx_ptr) = 0;
+		rcu_assign_pointer(i2s->tx_substream, substream);
+		xtfpga_pcm_refill_fifo(i2s);
+		break;
+
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		rcu_assign_pointer(i2s->tx_substream, NULL);
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
+	snd_pcm_uframes_t pos = ACCESS_ONCE(i2s->tx_ptr);
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
+static const struct snd_pcm_ops xtfpga_pcm_ops = {
+	.open		= xtfpga_pcm_open,
+	.close		= xtfpga_pcm_close,
+	.ioctl		= snd_pcm_lib_ioctl,
+	.hw_params	= xtfpga_pcm_hw_params,
+	.trigger	= xtfpga_pcm_trigger,
+	.pointer	= xtfpga_pcm_pointer,
+};
+
+static const struct snd_soc_platform_driver xtfpga_soc_platform = {
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
+	.hw_params      = xtfpga_i2s_hw_params,
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
+static int xtfpga_i2s_runtime_suspend(struct device *dev)
+{
+	struct xtfpga_i2s *i2s = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(i2s->clk);
+	return 0;
+}
+
+static int xtfpga_i2s_runtime_resume(struct device *dev)
+{
+	struct xtfpga_i2s *i2s = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_prepare_enable(i2s->clk);
+	if (ret) {
+		dev_err(dev, "clk_prepare_enable failed: %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int xtfpga_i2s_probe(struct platform_device *pdev)
+{
+	struct xtfpga_i2s *i2s;
+	struct resource *mem;
+	int err, irq;
+
+	i2s = devm_kzalloc(&pdev->dev, sizeof(*i2s), GFP_KERNEL);
+	if (!i2s) {
+		err = -ENOMEM;
+		goto err;
+	}
+	platform_set_drvdata(pdev, i2s);
+	i2s->dev = &pdev->dev;
+	dev_dbg(&pdev->dev, "dev: %p, i2s: %p\n", &pdev->dev, i2s);
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
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
+	regmap_write(i2s->regmap, XTFPGA_I2S_CONFIG,
+		     (0x1 << XTFPGA_I2S_CONFIG_CHANNEL_BASE));
+	regmap_write(i2s->regmap, XTFPGA_I2S_INT_STATUS, XTFPGA_I2S_INT_VALID);
+	regmap_write(i2s->regmap, XTFPGA_I2S_INT_MASK, XTFPGA_I2S_INT_UNDERRUN);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "No IRQ resource\n");
+		err = irq;
+		goto err;
+	}
+	err = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					xtfpga_i2s_threaded_irq_handler,
+					IRQF_SHARED | IRQF_ONESHOT,
+					pdev->name, i2s);
+	if (err < 0) {
+		dev_err(&pdev->dev, "request_irq failed\n");
+		goto err;
+	}
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
+	if (err < 0) {
+		dev_err(&pdev->dev, "couldn't register component\n");
+		goto err_unregister_platform;
+	}
+
+	pm_runtime_enable(&pdev->dev);
+	if (!pm_runtime_enabled(&pdev->dev)) {
+		err = xtfpga_i2s_runtime_resume(&pdev->dev);
+		if (err)
+			goto err_pm_disable;
+	}
+	return 0;
+
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
+err_unregister_platform:
+	snd_soc_unregister_platform(&pdev->dev);
+err:
+	dev_err(&pdev->dev, "%s: err = %d\n", __func__, err);
+	return err;
+}
+
+static int xtfpga_i2s_remove(struct platform_device *pdev)
+{
+	struct xtfpga_i2s *i2s = dev_get_drvdata(&pdev->dev);
+
+	snd_soc_unregister_platform(&pdev->dev);
+	if (i2s->regmap && !IS_ERR(i2s->regmap)) {
+		regmap_write(i2s->regmap, XTFPGA_I2S_CONFIG, 0);
+		regmap_write(i2s->regmap, XTFPGA_I2S_INT_MASK, 0);
+		regmap_write(i2s->regmap, XTFPGA_I2S_INT_STATUS,
+			     XTFPGA_I2S_INT_VALID);
+	}
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		xtfpga_i2s_runtime_suspend(&pdev->dev);
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
+static const struct dev_pm_ops xtfpga_i2s_pm_ops = {
+	SET_RUNTIME_PM_OPS(xtfpga_i2s_runtime_suspend,
+			   xtfpga_i2s_runtime_resume, NULL)
+};
+
+static struct platform_driver xtfpga_i2s_driver = {
+	.probe   = xtfpga_i2s_probe,
+	.remove  = xtfpga_i2s_remove,
+	.driver  = {
+		.name = "xtfpga-i2s",
+		.of_match_table = of_match_ptr(xtfpga_i2s_of_match),
+		.pm = &xtfpga_i2s_pm_ops,
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

