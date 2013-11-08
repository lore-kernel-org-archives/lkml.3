Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab3KHU47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:56:59 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:47829 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab3KHU44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:56:56 -0500
Message-ID: <527D5013.7080508@koalo.de>
Date: Fri, 08 Nov 2013 21:56:51 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: alsa-devel@alsa-project.org,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, martin@sperl.org
Subject: [RFC] ASoC: Add support for BCM2835
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for digital audio (I2S)
for the BCM2835 SoC that is used by the
Raspberry Pi. External audio codecs can be
connected to the Raspberry Pi via P5 header.

It relies on cyclic DMA engine support for BCM2835.

Signed-off-by: Florian Meier <florian.meier@koalo.de>
---

This patch does not cleanly apply, because it depends on the
DMA driver. Anyhow, I would be glad to get some comments.

 arch/arm/boot/dts/bcm2835.dtsi  |   12 +
 sound/soc/Kconfig               |    1 +
 sound/soc/Makefile              |    1 +
 sound/soc/bcm2835/Kconfig       |   15 +
 sound/soc/bcm2835/Makefile      |    6 +
 sound/soc/bcm2835/bcm2835-i2s.c |  962 +++++++++++++++++++++++++++++++++++++++
 sound/soc/bcm2835/bcm2835-pcm.c |   74 +++
 sound/soc/bcm2835/bcm2835-pcm.h |   29 ++
 8 files changed, 1100 insertions(+)
 create mode 100644 sound/soc/bcm2835/Kconfig
 create mode 100644 sound/soc/bcm2835/Makefile
 create mode 100644 sound/soc/bcm2835/bcm2835-i2s.c
 create mode 100644 sound/soc/bcm2835/bcm2835-pcm.c
 create mode 100644 sound/soc/bcm2835/bcm2835-pcm.h

diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dtsi
index 1514198..17f7b1b 100644
--- a/arch/arm/boot/dts/bcm2835.dtsi
+++ b/arch/arm/boot/dts/bcm2835.dtsi
@@ -125,6 +125,18 @@
 			dma-channels = <15>;   /* DMA channel 15 is not handled yet */
 			dma-requests = <32>;
 		};
+
+		bcm2835_i2s: i2s@7e203000 {
+			compatible = "brcm,bcm2835-i2s";
+			reg = <	0x7e203000 0x20
+				0x7e101098 0x02>;
+
+			dmas = <&dma 0
+				&dma 0>;
+			dma-names = "tx", "rx";
+
+			status = "disabled";
+		};
 	};
 
 	clocks {
diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index 5138b84..077e4a4 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -33,6 +33,7 @@ config SND_SOC_GENERIC_DMAENGINE_PCM
 # All the supported SoCs
 source "sound/soc/atmel/Kconfig"
 source "sound/soc/au1x/Kconfig"
+source "sound/soc/bcm2835/Kconfig"
 source "sound/soc/blackfin/Kconfig"
 source "sound/soc/cirrus/Kconfig"
 source "sound/soc/davinci/Kconfig"
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index 61a64d2..298768f 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_SND_SOC)	+= codecs/
 obj-$(CONFIG_SND_SOC)	+= generic/
 obj-$(CONFIG_SND_SOC)	+= atmel/
 obj-$(CONFIG_SND_SOC)	+= au1x/
+obj-$(CONFIG_SND_SOC)	+= bcm2835/
 obj-$(CONFIG_SND_SOC)	+= blackfin/
 obj-$(CONFIG_SND_SOC)	+= cirrus/
 obj-$(CONFIG_SND_SOC)	+= davinci/
diff --git a/sound/soc/bcm2835/Kconfig b/sound/soc/bcm2835/Kconfig
new file mode 100644
index 0000000..93619ec
--- /dev/null
+++ b/sound/soc/bcm2835/Kconfig
@@ -0,0 +1,15 @@
+config SND_BCM2835_SOC_I2S
+	tristate
+
+config SND_BCM2835_SOC
+	tristate "SoC Audio support for the Broadcom BCM2835 I2S module"
+	depends on ARCH_BCM2835
+	select SND_SOC_DMAENGINE_PCM
+	select DMADEVICES
+	select DMA_BCM2835
+	select SND_SOC_GENERIC_DMAENGINE_PCM
+	select REGMAP_MMIO
+	help
+	  Say Y or M if you want to add support for codecs attached to
+	  the BCM2835 I2S interface. You will also need
+	  to select the audio interfaces to support below.
diff --git a/sound/soc/bcm2835/Makefile b/sound/soc/bcm2835/Makefile
new file mode 100644
index 0000000..f442f57
--- /dev/null
+++ b/sound/soc/bcm2835/Makefile
@@ -0,0 +1,6 @@
+# BCM2835 Platform Support
+snd-soc-bcm2835-objs := bcm2835-pcm.o
+snd-soc-bcm2835-i2s-objs := bcm2835-i2s.o
+
+obj-$(CONFIG_SND_BCM2835_SOC) += snd-soc-bcm2835.o
+obj-$(CONFIG_SND_BCM2835_SOC_I2S) += snd-soc-bcm2835-i2s.o
diff --git a/sound/soc/bcm2835/bcm2835-i2s.c b/sound/soc/bcm2835/bcm2835-i2s.c
new file mode 100644
index 0000000..7fb6ff4
--- /dev/null
+++ b/sound/soc/bcm2835/bcm2835-i2s.c
@@ -0,0 +1,962 @@
+/*
+ * ALSA SoC I2S Audio Layer for Broadcom BCM2835 SoC
+ *
+ * Author:	Florian Meier <florian.meier@koalo.de>
+ *		Copyright 2013
+ *
+ * based on
+ *	Raspberry Pi PCM I2S ALSA Driver
+ *	Copyright (c) by Phil Poole 2013
+ *
+ *	ALSA SoC I2S (McBSP) Audio Layer for TI DAVINCI processor
+ *      Vladimir Barinov, <vbarinov@embeddedalley.com>
+ *	Copyright (C) 2007 MontaVista Software, Inc., <source@mvista.com>
+ *
+ *	OMAP ALSA SoC DAI driver using McBSP port
+ *	Copyright (C) 2008 Nokia Corporation
+ *	Contact: Jarkko Nikula <jarkko.nikula@bitmer.com>
+ *		 Peter Ujfalusi <peter.ujfalusi@ti.com>
+ *
+ *	Freescale SSI ALSA SoC Digital Audio Interface (DAI) driver
+ *	Author: Timur Tabi <timur@freescale.com>
+ *	Copyright 2007-2010 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/initval.h>
+#include <sound/soc.h>
+#include <sound/dmaengine_pcm.h>
+
+#include "bcm2835-pcm.h"
+
+/* Clock registers */
+#define BCM2835_CLK_PCMCTL_REG  0x00
+#define BCM2835_CLK_PCMDIV_REG  0x04
+
+/* Clock register settings */
+#define BCM2835_CLK_PASSWD	(0x5a000000)
+#define BCM2835_CLK_PASSWD_MASK	(0xff000000)
+#define BCM2835_CLK_MASH(v)	((v) << 9)
+#define BCM2835_CLK_FLIP	(1 << 8)
+#define BCM2835_CLK_BUSY	(1 << 7)
+#define BCM2835_CLK_KILL	(1 << 5)
+#define BCM2835_CLK_ENAB	(1 << 4)
+#define BCM2835_CLK_SRC(v)	(v)
+
+#define BCM2835_CLK_DIVI(v)	((v) << 12)
+#define BCM2835_CLK_DIVF(v)	(v)
+
+enum {
+	BCM2835_CLK_MASH_0 = 0,
+	BCM2835_CLK_MASH_1,
+	BCM2835_CLK_MASH_2,
+	BCM2835_CLK_MASH_3,
+};
+
+enum {
+	BCM2835_CLK_SRC_GND = 0,
+	BCM2835_CLK_SRC_OSC,
+	BCM2835_CLK_SRC_DBG0,
+	BCM2835_CLK_SRC_DBG1,
+	BCM2835_CLK_SRC_PLLA,
+	BCM2835_CLK_SRC_PLLC,
+	BCM2835_CLK_SRC_PLLD,
+	BCM2835_CLK_SRC_HDMI,
+};
+
+/* Most clocks are not useable (freq = 0) */
+static const unsigned int bcm2835_clk_freq[BCM2835_CLK_SRC_HDMI+1] = {
+	[BCM2835_CLK_SRC_GND]		= 0,
+	[BCM2835_CLK_SRC_OSC]		= 19200000,
+	[BCM2835_CLK_SRC_DBG0]		= 0,
+	[BCM2835_CLK_SRC_DBG1]		= 0,
+	[BCM2835_CLK_SRC_PLLA]		= 0,
+	[BCM2835_CLK_SRC_PLLC]		= 0,
+	[BCM2835_CLK_SRC_PLLD]		= 500000000,
+	[BCM2835_CLK_SRC_HDMI]		= 0,
+};
+
+
+/* I2S registers */
+#define BCM2835_I2S_CS_A_REG		0x00
+#define BCM2835_I2S_FIFO_A_REG		0x04
+#define BCM2835_I2S_MODE_A_REG		0x08
+#define BCM2835_I2S_RXC_A_REG		0x0c
+#define BCM2835_I2S_TXC_A_REG		0x10
+#define BCM2835_I2S_DREQ_A_REG		0x14
+#define BCM2835_I2S_INTEN_A_REG	0x18
+#define BCM2835_I2S_INTSTC_A_REG	0x1c
+#define BCM2835_I2S_GRAY_REG		0x20
+
+/* I2S register settings */
+#define BCM2835_I2S_STBY		(1 << 25)
+#define BCM2835_I2S_SYNC		(1 << 24)
+#define BCM2835_I2S_RXSEX		(1 << 23)
+#define BCM2835_I2S_RXF		(1 << 22)
+#define BCM2835_I2S_TXE		(1 << 21)
+#define BCM2835_I2S_RXD		(1 << 20)
+#define BCM2835_I2S_TXD		(1 << 19)
+#define BCM2835_I2S_RXR		(1 << 18)
+#define BCM2835_I2S_TXW		(1 << 17)
+#define BCM2835_I2S_CS_RXERR		(1 << 16)
+#define BCM2835_I2S_CS_TXERR		(1 << 15)
+#define BCM2835_I2S_RXSYNC		(1 << 14)
+#define BCM2835_I2S_TXSYNC		(1 << 13)
+#define BCM2835_I2S_DMAEN		(1 << 9)
+#define BCM2835_I2S_RXTHR(v)		((v) << 7)
+#define BCM2835_I2S_TXTHR(v)		((v) << 5)
+#define BCM2835_I2S_RXCLR		(1 << 4)
+#define BCM2835_I2S_TXCLR		(1 << 3)
+#define BCM2835_I2S_TXON		(1 << 2)
+#define BCM2835_I2S_RXON		(1 << 1)
+#define BCM2835_I2S_EN			(1)
+
+#define BCM2835_I2S_CLKDIS		(1 << 28)
+#define BCM2835_I2S_PDMN		(1 << 27)
+#define BCM2835_I2S_PDME		(1 << 26)
+#define BCM2835_I2S_FRXP		(1 << 25)
+#define BCM2835_I2S_FTXP		(1 << 24)
+#define BCM2835_I2S_CLKM		(1 << 23)
+#define BCM2835_I2S_CLKI		(1 << 22)
+#define BCM2835_I2S_FSM		(1 << 21)
+#define BCM2835_I2S_FSI		(1 << 20)
+#define BCM2835_I2S_FLEN(v)		((v) << 10)
+#define BCM2835_I2S_FSLEN(v)		(v)
+
+#define BCM2835_I2S_CHWEX		(1 << 15)
+#define BCM2835_I2S_CHEN		(1 << 14)
+#define BCM2835_I2S_CHPOS(v)		((v) << 4)
+#define BCM2835_I2S_CHWID(v)		(v)
+#define BCM2835_I2S_CH1(v)		((v) << 16)
+#define BCM2835_I2S_CH2(v)		(v)
+
+#define BCM2835_I2S_TX_PANIC(v)	((v) << 24)
+#define BCM2835_I2S_RX_PANIC(v)	((v) << 16)
+#define BCM2835_I2S_TX(v)		((v) << 8)
+#define BCM2835_I2S_RX(v)		(v)
+
+#define BCM2835_I2S_INT_RXERR		(1 << 3)
+#define BCM2835_I2S_INT_TXERR		(1 << 2)
+#define BCM2835_I2S_INT_RXR		(1 << 1)
+#define BCM2835_I2S_INT_TXW		(1 << 0)
+
+/* I2S DMA interface */
+#define BCM2835_I2S_FIFO_PHYSICAL_ADDR	0x7E203004
+#define BCM2835_DMA_DREQ_PCM_TX		2
+#define BCM2835_DMA_DREQ_PCM_RX		3
+
+/* General device struct */
+struct bcm2835_i2s_dev {
+	struct device				*dev;
+
+	struct snd_dmaengine_dai_dma_data	dma_data[2];
+
+	unsigned int				fmt;
+	struct snd_pcm_substream		*first_stream;
+	struct snd_pcm_substream		*second_stream;
+
+	struct regmap *i2s_regmap;
+	struct regmap *clk_regmap;
+};
+
+static void bcm2835_i2s_start_clock(struct bcm2835_i2s_dev *dev)
+{
+	/*
+	 * Start the clock if in master mode.
+	 */
+	unsigned int master = dev->fmt & SND_SOC_DAIFMT_MASTER_MASK;
+
+	switch (master) {
+	case SND_SOC_DAIFMT_CBS_CFS:
+	case SND_SOC_DAIFMT_CBS_CFM:
+		regmap_update_bits(dev->clk_regmap, BCM2835_CLK_PCMCTL_REG,
+			BCM2835_CLK_PASSWD_MASK | BCM2835_CLK_ENAB,
+			BCM2835_CLK_PASSWD | BCM2835_CLK_ENAB);
+		break;
+	default:
+		break;
+	}
+}
+
+static void bcm2835_i2s_stop_clock(struct bcm2835_i2s_dev *dev)
+{
+	unsigned int clkreg;
+	int timeout = 1000;
+
+	/* stop clock */
+	regmap_update_bits(dev->clk_regmap, BCM2835_CLK_PCMCTL_REG,
+			BCM2835_CLK_PASSWD_MASK | BCM2835_CLK_ENAB,
+			BCM2835_CLK_PASSWD);
+
+	/* wait for the BUSY flag going down */
+	while (timeout > 0) {
+		timeout--;
+
+		regmap_read(dev->clk_regmap, BCM2835_CLK_PCMCTL_REG, &clkreg);
+		if (!(clkreg & BCM2835_CLK_BUSY))
+			break;
+	}
+
+	if (timeout <= 0) {
+		/* KILL the clock */
+		dev_err(dev->dev, "I2S clock didn't stop. Kill the clock!\n");
+		regmap_update_bits(dev->clk_regmap, BCM2835_CLK_PCMCTL_REG,
+			BCM2835_CLK_KILL | BCM2835_CLK_PASSWD_MASK,
+			BCM2835_CLK_KILL | BCM2835_CLK_PASSWD);
+	}
+}
+
+static void bcm2835_i2s_clear_fifos(struct bcm2835_i2s_dev *dev)
+{
+	int timeout = 1000;
+	unsigned int syncval;
+	unsigned int csreg;
+	unsigned int i2s_active_state;
+	unsigned int clkreg;
+	unsigned int clk_active_state;
+
+	/* Backup the current state */
+	regmap_read(dev->i2s_regmap, BCM2835_I2S_CS_A_REG, &csreg);
+	i2s_active_state = csreg & (BCM2835_I2S_RXON | BCM2835_I2S_TXON);
+
+	regmap_read(dev->clk_regmap, BCM2835_CLK_PCMCTL_REG, &clkreg);
+	clk_active_state = clkreg & BCM2835_CLK_ENAB;
+
+	/* Start clock if not running */
+	if (!clk_active_state) {
+		regmap_update_bits(dev->clk_regmap, BCM2835_CLK_PCMCTL_REG,
+			BCM2835_CLK_PASSWD_MASK | BCM2835_CLK_ENAB,
+			BCM2835_CLK_PASSWD | BCM2835_CLK_ENAB);
+	}
+
+	/* Stop I2S module */
+	regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
+			BCM2835_I2S_RXON | BCM2835_I2S_TXON, 0);
+
+	/*
+	 * Clear the FIFOs
+	 * Requires at least 2 PCM clock cycles to take effect
+	 */
+	regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
+			BCM2835_I2S_RXCLR | BCM2835_I2S_TXCLR, -1);
+
+	/* Wait for 2 PCM clock cycles */
+
+	/*
+	 * Toggle the SYNC flag - after 2 PCM clock cycles it can be read back
+	 * FIXME: This does not seem to work for slave mode!
+	 */
+	regmap_read(dev->i2s_regmap, BCM2835_I2S_CS_A_REG, &syncval);
+	syncval &= BCM2835_I2S_SYNC;
+
+	regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
+			BCM2835_I2S_SYNC, ~syncval);
+
+	/* Wait for the SYNC flag changing it's state */
+	while (timeout > 0) {
+		timeout--;
+
+		regmap_read(dev->i2s_regmap, BCM2835_I2S_CS_A_REG, &csreg);
+		if ((csreg & BCM2835_I2S_SYNC) != syncval)
+			break;
+	}
+
+	if (timeout <= 0)
+		dev_err(dev->dev, "I2S SYNC error!\n");
+
+	/* Stop clock if it was not running before */
+	if (!clk_active_state)
+		bcm2835_i2s_stop_clock(dev);
+
+	/* Restore I2S state */
+	regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
+			BCM2835_I2S_RXON | BCM2835_I2S_TXON, i2s_active_state);
+}
+
+static int bcm2835_i2s_set_dai_fmt(struct snd_soc_dai *dai,
+				      unsigned int fmt)
+{
+	struct bcm2835_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
+	dev->fmt = fmt;
+	return 0;
+}
+
+static int bcm2835_i2s_hw_params(struct snd_pcm_substream *substream,
+				 struct snd_pcm_hw_params *params,
+				 struct snd_soc_dai *dai)
+{
+	struct bcm2835_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
+
+	unsigned int sampling_rate = params_rate(params);
+	unsigned int data_length, data_delay, half_frame;
+	unsigned int ch1pos, ch2pos, mode, format;
+	unsigned int mash = BCM2835_CLK_MASH_1;
+	unsigned int divi, divf, target_frequency;
+	int clk_src = -1;
+	unsigned int master = dev->fmt & SND_SOC_DAIFMT_MASTER_MASK;
+	unsigned int bit_master =	(master == SND_SOC_DAIFMT_CBS_CFS
+					|| master == SND_SOC_DAIFMT_CBS_CFM);
+
+	unsigned int frame_master =	(master == SND_SOC_DAIFMT_CBS_CFS
+					|| master == SND_SOC_DAIFMT_CBM_CFS);
+	unsigned int csreg;
+
+	/*
+	 * If a stream is already enabled,
+	 * the registers are already set properly.
+	 */
+	regmap_read(dev->i2s_regmap, BCM2835_I2S_CS_A_REG, &csreg);
+
+	if (csreg & (BCM2835_I2S_TXON | BCM2835_I2S_RXON))
+		return 0;
+
+	/*
+	 * Adjust the data length according to the format.
+	 * We prefill the half frame length with an integer
+	 * divider of 2400 as explained at the clock settings.
+	 * Maybe it is overwritten there, if the Integer mode
+	 * does not apply.
+	 */
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S16_LE:
+		data_length = 16;
+		half_frame = 20;
+		break;
+	case SNDRV_PCM_FORMAT_S32_LE:
+		data_length = 32;
+		half_frame = 40;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * Clock Settings
+	 *
+	 * The target frequency of the bit clock is
+	 *	sampling rate * frame length
+	 *
+	 * Integer mode:
+	 * Sampling rates that are multiples of 8000 kHz
+	 * can be driven by the oscillator of 19.2 MHz
+	 * with an integer divider as long as the frame length
+	 * is an integer divider of 19200000/8000=2400 as set up above.
+	 * This is no longer possible if the sampling rate
+	 * is too high (e.g. 192 kHz), because the oscillator is too slow.
+	 *
+	 * MASH mode:
+	 * For all other sampling rates, it is not possible to
+	 * have an integer divider. Approximate the clock
+	 * with the MASH module that induces a slight frequency
+	 * variance. To minimize that it is best to have the fastest
+	 * clock here. That is PLLD with 500 MHz.
+	 */
+	target_frequency = sampling_rate*half_frame*2;
+	clk_src = BCM2835_CLK_SRC_OSC;
+	mash = BCM2835_CLK_MASH_0;
+
+	if (bcm2835_clk_freq[clk_src] % target_frequency == 0
+			&& bit_master && frame_master) {
+		divi = bcm2835_clk_freq[clk_src]/target_frequency;
+		divf = 0;
+	} else {
+		uint64_t dividend;
+
+		/*
+		 * Overwrite half frame length, because the
+		 * above trick is not needed.
+		 * This is fixed, because a bit clock of 64*fs
+		 * seems to be what most codecs want.
+		 * Is it necessary to have this dynamic?
+		 */
+		half_frame = 32;
+		target_frequency = sampling_rate*half_frame*2;
+
+		clk_src = BCM2835_CLK_SRC_PLLD;
+		mash = BCM2835_CLK_MASH_1;
+
+		dividend = bcm2835_clk_freq[clk_src];
+		dividend *= 1024;
+		do_div(dividend, target_frequency);
+		divi = dividend / 1024;
+		divf = dividend % 1024;
+	}
+
+	/* Set clock divider */
+	regmap_write(dev->clk_regmap, BCM2835_CLK_PCMDIV_REG, BCM2835_CLK_PASSWD
+			| BCM2835_CLK_DIVI(divi)
+			| BCM2835_CLK_DIVF(divf));
+
+	/* Setup clock, but don't start it yet */
+	regmap_write(dev->clk_regmap, BCM2835_CLK_PCMCTL_REG, BCM2835_CLK_PASSWD
+			| BCM2835_CLK_MASH(mash)
+			| BCM2835_CLK_SRC(clk_src));
+
+	/* Setup the frame format */
+	format = BCM2835_I2S_CHEN;
+
+	if (data_length > 24)
+		format |= BCM2835_I2S_CHWEX;
+
+	format |= BCM2835_I2S_CHWID((data_length-8)&0xf);
+
+	switch (dev->fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		data_delay = 1;
+		break;
+	default:
+		/* TODO
+		 * Others are possible but are not implemented at the moment.
+		 */
+		dev_err(dev->dev, "%s:bad format\n", __func__);
+		return -EINVAL;
+	}
+
+	ch1pos = data_delay;
+	ch2pos = half_frame+data_delay;
+
+	switch (params_channels(params)) {
+	case 2:
+		format = BCM2835_I2S_CH1(format) | BCM2835_I2S_CH2(format);
+		format |= BCM2835_I2S_CH1(BCM2835_I2S_CHPOS(ch1pos));
+		format |= BCM2835_I2S_CH2(BCM2835_I2S_CHPOS(ch2pos));
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * Set format for both streams.
+	 * We cannot set another frame length
+	 * (and therefore word length) anyway,
+	 * so the format will be the same.
+	 */
+	regmap_write(dev->i2s_regmap, BCM2835_I2S_RXC_A_REG, format);
+	regmap_write(dev->i2s_regmap, BCM2835_I2S_TXC_A_REG, format);
+
+	/* Setup the I2S mode */
+	mode = 0;
+
+	if (data_length <= 16) {
+		/*
+		 * Use frame packed mode (2 channels per 32 bit word)
+		 * We cannot set another frame length in the second stream
+		 * (and therefore word length) anyway,
+		 * so the format will be the same.
+		 */
+		mode |= BCM2835_I2S_FTXP | BCM2835_I2S_FRXP;
+	}
+
+	mode |= BCM2835_I2S_FLEN(half_frame*2-1);
+	mode |= BCM2835_I2S_FSLEN(half_frame);
+
+	/* master or slave? */
+	switch (dev->fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBS_CFS:
+		/* cpu is master */
+		break;
+	case SND_SOC_DAIFMT_CBM_CFS:
+		/*
+		 * codec is bit clock master
+		 * cpu is frame master
+		 */
+		mode |= BCM2835_I2S_CLKM;
+		break;
+	case SND_SOC_DAIFMT_CBS_CFM:
+		/*
+		 * codec is frame master
+		 * cpu is bit clock master
+		 */
+		mode |= BCM2835_I2S_FSM;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFM:
+		/* codec is master */
+		mode |= BCM2835_I2S_CLKM;
+		mode |= BCM2835_I2S_FSM;
+		break;
+	default:
+		dev_err(dev->dev, "%s:bad master\n", __func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * Invert clocks?
+	 *
+	 * The BCM approach seems to be inverted to the classical I2S approach.
+	 */
+	switch (dev->fmt & SND_SOC_DAIFMT_INV_MASK) {
+	case SND_SOC_DAIFMT_NB_NF:
+		/* none - therefore, both for BCM */
+		mode |= BCM2835_I2S_CLKI;
+		mode |= BCM2835_I2S_FSI;
+		break;
+	case SND_SOC_DAIFMT_IB_IF:
+		/* both - therefore, none for BCM*/
+		break;
+	case SND_SOC_DAIFMT_NB_IF:
+		/*
+		 * invert only frame sync - therefore,
+		 * invert only bit clock for BCM
+		 */
+		mode |= BCM2835_I2S_CLKI;
+		break;
+	case SND_SOC_DAIFMT_IB_NF:
+		/*
+		 * invert only bit clock - therefore,
+		 * invert only frame sync for BCM
+		 */
+		mode |= BCM2835_I2S_FSI;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	regmap_write(dev->i2s_regmap, BCM2835_I2S_MODE_A_REG, mode);
+
+
+	/* Setup the DMA parameters */
+	regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
+			BCM2835_I2S_RXTHR(1)
+			| BCM2835_I2S_TXTHR(1)
+			| BCM2835_I2S_DMAEN, -1);
+
+	regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_DREQ_A_REG,
+			  BCM2835_I2S_TX_PANIC(0x10)
+			| BCM2835_I2S_RX_PANIC(0x30)
+			| BCM2835_I2S_TX(0x30)
+			| BCM2835_I2S_RX(0x20), -1);
+
+	/* Clear FIFOs */
+	bcm2835_i2s_clear_fifos(dev);
+
+	return 0;
+}
+
+
+static int bcm2835_i2s_prepare(struct snd_pcm_substream *substream,
+		struct snd_soc_dai *dai)
+{
+	struct bcm2835_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
+	unsigned int cs_reg;
+
+	bcm2835_i2s_start_clock(dev);
+
+	/*
+	 * Clear both FIFOs if the one that should be started
+	 * is not empty at the moment. This should only happen
+	 * after overrun. Otherwise, hw_params would have cleared
+	 * the FIFO.
+	 */
+	regmap_read(dev->i2s_regmap, BCM2835_I2S_CS_A_REG, &cs_reg);
+
+	switch (substream->stream) {
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		if (cs_reg & BCM2835_I2S_TXE)
+			break;
+	case SNDRV_PCM_STREAM_CAPTURE:
+		if (!(cs_reg & BCM2835_I2S_RXD))
+			break;
+
+		bcm2835_i2s_clear_fifos(dev);
+	}
+
+	return 0;
+}
+
+static void bcm2835_i2s_stop(struct bcm2835_i2s_dev *dev,
+		struct snd_pcm_substream *substream)
+{
+	unsigned int still_running;
+
+	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
+		regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
+				BCM2835_I2S_RXON, 0);
+	} else {
+		regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
+				BCM2835_I2S_TXON, 0);
+	}
+
+	regmap_read(dev->i2s_regmap, BCM2835_I2S_CS_A_REG, &still_running);
+	still_running &= BCM2835_I2S_TXON | BCM2835_I2S_RXON;
+
+	/* Stop also the clock when not SND_SOC_DAIFMT_CONT */
+	if (!still_running && !(dev->fmt & SND_SOC_DAIFMT_CONT))
+		bcm2835_i2s_stop_clock(dev);
+
+}
+
+static int bcm2835_i2s_trigger(struct snd_pcm_substream *substream, int cmd,
+			       struct snd_soc_dai *dai)
+{
+	struct bcm2835_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		bcm2835_i2s_start_clock(dev);
+
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
+			regmap_update_bits(dev->i2s_regmap,
+					BCM2835_I2S_CS_A_REG,
+					BCM2835_I2S_RXON, BCM2835_I2S_RXON);
+		} else {
+			regmap_update_bits(dev->i2s_regmap,
+					BCM2835_I2S_CS_A_REG,
+					BCM2835_I2S_TXON, BCM2835_I2S_TXON);
+		}
+		break;
+
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		bcm2835_i2s_stop(dev, substream);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int bcm2835_i2s_startup(struct snd_pcm_substream *substream,
+			       struct snd_soc_dai *dai)
+{
+	struct bcm2835_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
+
+	if (!dev->first_stream) {
+		dev->first_stream = substream;
+
+		/* should this still be running stop it */
+		bcm2835_i2s_stop_clock(dev);
+
+		/* enable PCM block */
+		regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
+				BCM2835_I2S_EN, -1);
+
+		/*
+		 * Disable STBY
+		 * Requires at least 4 PCM clock cycles to take effect
+		 */
+		regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
+				BCM2835_I2S_STBY, -1);
+
+	} else {
+		dev->second_stream = substream;
+	}
+
+	return 0;
+}
+
+static void bcm2835_i2s_shutdown(struct snd_pcm_substream *substream,
+		struct snd_soc_dai *dai)
+{
+	struct bcm2835_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
+
+	bcm2835_i2s_stop(dev, substream);
+
+	if (dev->first_stream == substream)
+		dev->first_stream = dev->second_stream;
+
+	dev->second_stream = NULL;
+
+	/* If both streams are stopped, disable module and clock */
+	if (!dev->first_stream) {
+		/* Disable the module */
+		regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
+				BCM2835_I2S_EN, 0);
+
+		/*
+		 * Stopping clock is necessary, because stop does
+		 * not stop the clock when SND_SOC_DAIFMT_CONT
+		 */
+		bcm2835_i2s_stop_clock(dev);
+	}
+}
+
+static const struct snd_soc_dai_ops bcm2835_i2s_dai_ops = {
+	.startup	= bcm2835_i2s_startup,
+	.shutdown	= bcm2835_i2s_shutdown,
+	.prepare	= bcm2835_i2s_prepare,
+	.trigger	= bcm2835_i2s_trigger,
+	.hw_params	= bcm2835_i2s_hw_params,
+	.set_fmt	= bcm2835_i2s_set_dai_fmt,
+};
+
+static int bcm2835_i2s_dai_probe(struct snd_soc_dai *dai)
+{
+	struct bcm2835_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
+
+	/* Set the appropriate DMA parameters */
+	dev->dma_data[SNDRV_PCM_STREAM_PLAYBACK].addr =
+		(dma_addr_t)BCM2835_I2S_FIFO_PHYSICAL_ADDR;
+	dev->dma_data[SNDRV_PCM_STREAM_CAPTURE].addr =
+		(dma_addr_t)BCM2835_I2S_FIFO_PHYSICAL_ADDR;
+
+	dev->dma_data[SNDRV_PCM_STREAM_PLAYBACK].slave_id =
+		BCM2835_DMA_DREQ_PCM_TX;
+	dev->dma_data[SNDRV_PCM_STREAM_CAPTURE].slave_id =
+		BCM2835_DMA_DREQ_PCM_RX;
+
+	dev->dma_data[SNDRV_PCM_STREAM_PLAYBACK].addr_width =
+		DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dev->dma_data[SNDRV_PCM_STREAM_CAPTURE].addr_width =
+		DMA_SLAVE_BUSWIDTH_4_BYTES;
+
+	/* TODO other burst parameters possible? */
+	dev->dma_data[SNDRV_PCM_STREAM_PLAYBACK].maxburst = 2;
+	dev->dma_data[SNDRV_PCM_STREAM_CAPTURE].maxburst = 2;
+
+	dai->playback_dma_data = &dev->dma_data[SNDRV_PCM_STREAM_PLAYBACK];
+	dai->capture_dma_data = &dev->dma_data[SNDRV_PCM_STREAM_CAPTURE];
+
+	return 0;
+}
+
+static struct snd_soc_dai_driver bcm2835_i2s_dai = {
+	.name		= "bcm2835-i2s",
+	.probe = bcm2835_i2s_dai_probe,
+	.playback = {
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates =	SNDRV_PCM_RATE_8000_192000,
+		.formats =	SNDRV_PCM_FMTBIT_S16_LE
+				| SNDRV_PCM_FMTBIT_S32_LE
+		},
+	.capture = {
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates =	SNDRV_PCM_RATE_8000_192000,
+		.formats =	SNDRV_PCM_FMTBIT_S16_LE
+				| SNDRV_PCM_FMTBIT_S32_LE
+		},
+	.ops = &bcm2835_i2s_dai_ops,
+	.symmetric_rates = 1
+};
+
+static bool bcm2835_i2s_wr_rd_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case BCM2835_I2S_CS_A_REG:
+	case BCM2835_I2S_FIFO_A_REG:
+	case BCM2835_I2S_MODE_A_REG:
+	case BCM2835_I2S_RXC_A_REG:
+	case BCM2835_I2S_TXC_A_REG:
+	case BCM2835_I2S_DREQ_A_REG:
+	case BCM2835_I2S_INTEN_A_REG:
+	case BCM2835_I2S_INTSTC_A_REG:
+	case BCM2835_I2S_GRAY_REG:
+		return true;
+	default:
+		return false;
+	};
+}
+
+static bool bcm2835_i2s_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case BCM2835_I2S_CS_A_REG:
+	case BCM2835_I2S_FIFO_A_REG:
+	case BCM2835_I2S_INTSTC_A_REG:
+	case BCM2835_I2S_GRAY_REG:
+		return true;
+	default:
+		return false;
+	};
+}
+
+static bool bcm2835_i2s_precious_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case BCM2835_I2S_FIFO_A_REG:
+		return true;
+	default:
+		return false;
+	};
+}
+
+
+static bool bcm2835_clk_wr_rd_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case BCM2835_CLK_PCMCTL_REG:
+	case BCM2835_CLK_PCMDIV_REG:
+		return true;
+	default:
+		return false;
+	};
+}
+
+static bool bcm2835_clk_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case BCM2835_CLK_PCMCTL_REG:
+		return true;
+	default:
+		return false;
+	};
+}
+
+static bool bcm2835_clk_precious_reg(struct device *dev, unsigned int reg)
+{
+	return false;
+}
+
+static const struct regmap_config bcm2835_regmap_config[] = {
+	{
+		.reg_bits = 32,
+		.reg_stride = 4,
+		.val_bits = 32,
+		.max_register = BCM2835_I2S_GRAY_REG,
+		.writeable_reg = bcm2835_i2s_wr_rd_reg,
+		.readable_reg = bcm2835_i2s_wr_rd_reg,
+		.volatile_reg = bcm2835_i2s_volatile_reg,
+		.precious_reg = bcm2835_i2s_precious_reg,
+		.cache_type = REGCACHE_RBTREE,
+	},
+	{
+		.reg_bits = 32,
+		.reg_stride = 4,
+		.val_bits = 32,
+		.max_register = BCM2835_CLK_PCMDIV_REG,
+		.writeable_reg = bcm2835_clk_wr_rd_reg,
+		.readable_reg = bcm2835_clk_wr_rd_reg,
+		.volatile_reg = bcm2835_clk_volatile_reg,
+		.precious_reg = bcm2835_clk_precious_reg,
+		.cache_type = REGCACHE_RBTREE,
+	},
+};
+
+static const struct regmap_config bcm2835_i2s_regmap_config = {
+};
+
+static const struct snd_soc_component_driver bcm2835_i2s_component = {
+	.name		= "bcm2835-i2s-comp",
+};
+
+static int bcm2835_i2s_probe(struct platform_device *pdev)
+{
+	struct bcm2835_i2s_dev *dev;
+	int i;
+	int ret;
+	struct regmap *regmap[2];
+
+	/* request both ioareas */
+	for (i = 0; i <= 1; i++) {
+		struct resource *mem, *ioarea;
+		void __iomem *base;
+
+		mem = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (!mem) {
+			dev_err(&pdev->dev, "I2S probe: Memory resource could not be found.\n");
+			return -ENODEV;
+		}
+
+		ioarea = devm_request_mem_region(&pdev->dev, mem->start,
+					   resource_size(mem),
+					   pdev->name);
+		if (!ioarea) {
+			dev_err(&pdev->dev, "I2S probe: Memory region already claimed.\n");
+			return -EBUSY;
+		}
+
+		base = devm_ioremap(&pdev->dev, mem->start,
+				resource_size(mem));
+		if (!base) {
+			dev_err(&pdev->dev, "I2S probe: ioremap failed.\n");
+			return -ENOMEM;
+		}
+
+		regmap[i] = devm_regmap_init_mmio(&pdev->dev, base,
+					    &bcm2835_regmap_config[i]);
+		if (IS_ERR(regmap[i])) {
+			dev_err(&pdev->dev, "I2S probe: regmap init failed\n");
+			return PTR_ERR(regmap[i]);
+		}
+	}
+
+	dev = devm_kzalloc(&pdev->dev, sizeof(struct bcm2835_i2s_dev),
+			   GFP_KERNEL);
+	if (!dev) {
+		dev_err(&pdev->dev, "I2S probe: kzalloc failed.\n");
+		return -ENOMEM;
+	}
+
+	dev->i2s_regmap = regmap[0];
+	dev->clk_regmap = regmap[1];
+
+	/* Store the pdev */
+	dev->dev = &pdev->dev;
+	dev_set_drvdata(&pdev->dev, dev);
+
+	ret = snd_soc_register_component(&pdev->dev,
+			&bcm2835_i2s_component, &bcm2835_i2s_dai, 1);
+
+	if (ret) {
+		dev_err(&pdev->dev, "Could not register DAI: %d\n", ret);
+		ret = -ENOMEM;
+		return ret;
+	}
+
+	ret = bcm2835_pcm_platform_register(&pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not register PCM: %d\n", ret);
+		snd_soc_unregister_component(&pdev->dev);
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct of_device_id bcm2835_i2s_of_match[] = {
+	{ .compatible = "brcm,bcm2835-i2s", },
+	{},
+};
+
+static int bcm2835_i2s_remove(struct platform_device *pdev)
+{
+	bcm2835_pcm_platform_unregister(&pdev->dev);
+	snd_soc_unregister_component(&pdev->dev);
+	return 0;
+}
+
+static struct platform_driver bcm2835_i2s_driver = {
+	.probe		= bcm2835_i2s_probe,
+	.remove		= bcm2835_i2s_remove,
+	.driver		= {
+		.name	= "bcm2835-i2s",
+		.owner	= THIS_MODULE,
+		.of_match_table = bcm2835_i2s_of_match,
+	},
+};
+
+module_platform_driver(bcm2835_i2s_driver);
+
+MODULE_AUTHOR("Florian Meier");
+MODULE_DESCRIPTION("BCM2835 I2S Interface");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/bcm2835/bcm2835-pcm.c b/sound/soc/bcm2835/bcm2835-pcm.c
new file mode 100644
index 0000000..66e1c0e
--- /dev/null
+++ b/sound/soc/bcm2835/bcm2835-pcm.c
@@ -0,0 +1,74 @@
+/*
+ * ALSA PCM interface for Broadcom BCM2835 SoC
+ *
+ * Author:      Florian Meier <florian.meier@koalo.de>
+ *              Copyright 2013
+ *
+ * based on
+ *	ALSA PCM interface for the OMAP SoC
+ *	Copyright (C) 2008 Nokia Corporation
+ *	Contact: Jarkko Nikula <jarkko.nikula@bitmer.com>
+ *	Peter Ujfalusi <peter.ujfalusi@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/dmaengine_pcm.h>
+
+#include "bcm2835-pcm.h"
+
+static const struct snd_pcm_hardware bcm2835_pcm_hardware = {
+	.info			= SNDRV_PCM_INFO_MMAP |
+				  SNDRV_PCM_INFO_MMAP_VALID |
+				  SNDRV_PCM_INFO_INTERLEAVED |
+				  SNDRV_PCM_INFO_JOINT_DUPLEX,
+	.formats		= SNDRV_PCM_FMTBIT_S16_LE |
+				  SNDRV_PCM_FMTBIT_S32_LE,
+	.period_bytes_min	= 32,
+	.period_bytes_max	= 64 * PAGE_SIZE,
+	.periods_min		= 2,
+	.periods_max		= 255,
+	.buffer_bytes_max	= 128 * PAGE_SIZE,
+};
+
+static const struct snd_dmaengine_pcm_config bcm2835_dmaengine_pcm_config = {
+	.prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config,
+	.pcm_hardware = &bcm2835_pcm_hardware,
+	.prealloc_buffer_size = 256 * PAGE_SIZE,
+};
+
+int bcm2835_pcm_platform_register(struct device *dev)
+{
+	return snd_dmaengine_pcm_register(dev,
+				&bcm2835_dmaengine_pcm_config,
+				SND_DMAENGINE_PCM_FLAG_COMPAT);
+}
+EXPORT_SYMBOL_GPL(bcm2835_pcm_platform_register);
+
+void bcm2835_pcm_platform_unregister(struct device *dev)
+{
+	snd_dmaengine_pcm_unregister(dev);
+}
+EXPORT_SYMBOL_GPL(bcm2835_pcm_platform_unregister);
+
+MODULE_AUTHOR("Florian Meier");
+MODULE_DESCRIPTION("BCM2835 PCM ASoC driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/bcm2835/bcm2835-pcm.h b/sound/soc/bcm2835/bcm2835-pcm.h
new file mode 100644
index 0000000..07a70ca
--- /dev/null
+++ b/sound/soc/bcm2835/bcm2835-pcm.h
@@ -0,0 +1,29 @@
+/*
+ * ALSA PCM interface for Broadcom BCM2835 SoC
+ *
+ * Author:      Florian Meier <florian.meier@koalo.de>
+ *              Copyright 2013
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __BCM2835_PCM_H__
+#define __BCM2835_PCM_H__
+
+int bcm2835_pcm_platform_register(struct device *dev);
+void bcm2835_pcm_platform_unregister(struct device *dev);
+
+#endif
-- 
1.7.9.5
