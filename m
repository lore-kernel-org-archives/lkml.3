Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3HXAR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 20:17:57 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:37789 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3HXARy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 20:17:54 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Dan Williams <djbw@fb.com>, Jaroslav Kysela <perex@perex.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH v2 12/18] ARM: s3c64xx: Add support for DMA using generic amba-pl08x driver
Date: Sat, 24 Aug 2013 02:17:46 +0200
Message-ID: <1735130.krsoNtKQQV@flatron>
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-Reply-To: <1376243970-6489-13-git-send-email-tomasz.figa@gmail.com>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com> <1376243970-6489-13-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds all required platform-specific data and initialization
code to support the generic amba-pl08x driver on S3C64xx SoCs.

Also some compatibility definitions are added to make the transition
from legacy API to DMA engine easier. The biggest hack here is passing
const char * pointers through DMA resource, casted to unsigned long,
but this is how Samsung DMA wrappers (used to support both s3c-dma and
DMA engine in drivers) are designed.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/Kconfig                         |   1 +
 arch/arm/mach-s3c64xx/Kconfig            |   8 +-
 arch/arm/mach-s3c64xx/Makefile           |   1 +
 arch/arm/mach-s3c64xx/common.h           |   5 +
 arch/arm/mach-s3c64xx/include/mach/dma.h |  63 ++++++++
 arch/arm/mach-s3c64xx/pl080.c            | 244 +++++++++++++++++++++++++++++++
 arch/arm/plat-samsung/devs.c             |  12 +-
 arch/arm/plat-samsung/dma-ops.c          |   8 +-
 8 files changed, 337 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/mach-s3c64xx/pl080.c

Changes since v1:
 - Stopped hijacking pl330_filter() symbol to plug pl08_filter_id()
   as channel filtering callback on S3C64xx.

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 43594d5..7e0e1b6 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -721,6 +721,7 @@ config ARCH_S3C64XX
 	bool "Samsung S3C64XX"
 	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
+	select ARM_AMBA
 	select ARM_VIC
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index 2057853..704c5e4 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -28,9 +28,15 @@ config CPU_S3C6410
 	help
 	  Enable S3C6410 CPU support
 
+config S3C64XX_PL080
+	bool "S3C64XX DMA using generic PL08x driver"
+	select AMBA_PL08X
+	select SAMSUNG_DMADEV
+
 config S3C64XX_DMA
-	bool "S3C64XX DMA"
+	bool "S3C64XX DMA using legacy S3C DMA API"
 	select S3C_DMA
+	depends on !S3C64XX_PL080
 
 config S3C64XX_SETUP_SDHCI
 	bool
diff --git a/arch/arm/mach-s3c64xx/Makefile b/arch/arm/mach-s3c64xx/Makefile
index 31d0c91..4e3326a 100644
--- a/arch/arm/mach-s3c64xx/Makefile
+++ b/arch/arm/mach-s3c64xx/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
 # DMA support
 
 obj-$(CONFIG_S3C64XX_DMA)	+= dma.o
+obj-$(CONFIG_S3C64XX_PL080)	+= pl080.o
 
 # Device support
 
diff --git a/arch/arm/mach-s3c64xx/common.h b/arch/arm/mach-s3c64xx/common.h
index e8f990b..4e84617 100644
--- a/arch/arm/mach-s3c64xx/common.h
+++ b/arch/arm/mach-s3c64xx/common.h
@@ -60,4 +60,9 @@ int __init s3c64xx_pm_late_initcall(void);
 static inline int s3c64xx_pm_late_initcall(void) { return 0; }
 #endif
 
+#ifdef CONFIG_S3C64XX_PL080
+extern struct pl08x_platform_data s3c64xx_dma0_plat_data;
+extern struct pl08x_platform_data s3c64xx_dma1_plat_data;
+#endif
+
 #endif /* __ARCH_ARM_MACH_S3C64XX_COMMON_H */
diff --git a/arch/arm/mach-s3c64xx/include/mach/dma.h b/arch/arm/mach-s3c64xx/include/mach/dma.h
index fe1a98c..26a6bc3 100644
--- a/arch/arm/mach-s3c64xx/include/mach/dma.h
+++ b/arch/arm/mach-s3c64xx/include/mach/dma.h
@@ -11,6 +11,8 @@
 #ifndef __ASM_ARCH_DMA_H
 #define __ASM_ARCH_DMA_H __FILE__
 
+#ifdef CONFIG_S3C64XX_DMA
+
 #define S3C_DMA_CHANNELS	(16)
 
 /* see mach-s3c2410/dma.h for notes on dma channel numbers */
@@ -128,4 +130,65 @@ struct s3c2410_dma_chan {
 
 #include <plat/dma-core.h>
 
+#else
+
+#define S3C64XX_DMA_CHAN(name)		((unsigned long)(name))
+
+/* DMA0/SDMA0 */
+#define DMACH_UART0		S3C64XX_DMA_CHAN("uart0_tx")
+#define DMACH_UART0_SRC2	S3C64XX_DMA_CHAN("uart0_rx")
+#define DMACH_UART1		S3C64XX_DMA_CHAN("uart1_tx")
+#define DMACH_UART1_SRC2	S3C64XX_DMA_CHAN("uart1_rx")
+#define DMACH_UART2		S3C64XX_DMA_CHAN("uart2_tx")
+#define DMACH_UART2_SRC2	S3C64XX_DMA_CHAN("uart2_rx")
+#define DMACH_UART3		S3C64XX_DMA_CHAN("uart3_tx")
+#define DMACH_UART3_SRC2	S3C64XX_DMA_CHAN("uart3_rx")
+#define DMACH_PCM0_TX		S3C64XX_DMA_CHAN("pcm0_tx")
+#define DMACH_PCM0_RX		S3C64XX_DMA_CHAN("pcm0_rx")
+#define DMACH_I2S0_OUT		S3C64XX_DMA_CHAN("i2s0_tx")
+#define DMACH_I2S0_IN		S3C64XX_DMA_CHAN("i2s0_rx")
+#define DMACH_SPI0_TX		S3C64XX_DMA_CHAN("spi0_tx")
+#define DMACH_SPI0_RX		S3C64XX_DMA_CHAN("spi0_rx")
+#define DMACH_HSI_I2SV40_TX	S3C64XX_DMA_CHAN("i2s2_tx")
+#define DMACH_HSI_I2SV40_RX	S3C64XX_DMA_CHAN("i2s2_rx")
+
+/* DMA1/SDMA1 */
+#define DMACH_PCM1_TX		S3C64XX_DMA_CHAN("pcm1_tx")
+#define DMACH_PCM1_RX		S3C64XX_DMA_CHAN("pcm1_rx")
+#define DMACH_I2S1_OUT		S3C64XX_DMA_CHAN("i2s1_tx")
+#define DMACH_I2S1_IN		S3C64XX_DMA_CHAN("i2s1_rx")
+#define DMACH_SPI1_TX		S3C64XX_DMA_CHAN("spi1_tx")
+#define DMACH_SPI1_RX		S3C64XX_DMA_CHAN("spi1_rx")
+#define DMACH_AC97_PCMOUT	S3C64XX_DMA_CHAN("ac97_out")
+#define DMACH_AC97_PCMIN	S3C64XX_DMA_CHAN("ac97_in")
+#define DMACH_AC97_MICIN	S3C64XX_DMA_CHAN("ac97_mic")
+#define DMACH_PWM		S3C64XX_DMA_CHAN("pwm")
+#define DMACH_IRDA		S3C64XX_DMA_CHAN("irda")
+#define DMACH_EXTERNAL		S3C64XX_DMA_CHAN("external")
+#define DMACH_SECURITY_RX	S3C64XX_DMA_CHAN("sec_rx")
+#define DMACH_SECURITY_TX	S3C64XX_DMA_CHAN("sec_tx")
+
+enum dma_ch {
+	DMACH_MAX = 32
+};
+
+struct s3c2410_dma_client {
+	char	*name;
+};
+
+static inline bool samsung_dma_has_circular(void)
+{
+	return true;
+}
+
+static inline bool samsung_dma_is_dmadev(void)
+{
+	return true;
+}
+
+#include <linux/amba/pl08x.h>
+#include <plat/dma-ops.h>
+
+#endif
+
 #endif /* __ASM_ARCH_IRQ_H */
diff --git a/arch/arm/mach-s3c64xx/pl080.c b/arch/arm/mach-s3c64xx/pl080.c
new file mode 100644
index 0000000..901a984
--- /dev/null
+++ b/arch/arm/mach-s3c64xx/pl080.c
@@ -0,0 +1,244 @@
+/*
+ * Samsung's S3C64XX generic DMA support using amba-pl08x driver.
+ *
+ * Copyright (c) 2013 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/pl080.h>
+#include <linux/amba/pl08x.h>
+#include <linux/of.h>
+
+#include <mach/irqs.h>
+#include <mach/map.h>
+
+#include "regs-sys.h"
+
+static int pl08x_get_xfer_signal(const struct pl08x_channel_data *cd)
+{
+	return cd->min_signal;
+}
+
+static void pl08x_put_xfer_signal(const struct pl08x_channel_data *cd, int ch)
+{
+}
+
+/*
+ * DMA0
+ */
+
+static struct pl08x_channel_data s3c64xx_dma0_info[] = {
+	{
+		.bus_id = "uart0_tx",
+		.min_signal = 0,
+		.max_signal = 0,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "uart0_rx",
+		.min_signal = 1,
+		.max_signal = 1,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "uart1_tx",
+		.min_signal = 2,
+		.max_signal = 2,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "uart1_rx",
+		.min_signal = 3,
+		.max_signal = 3,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "uart2_tx",
+		.min_signal = 4,
+		.max_signal = 4,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "uart2_rx",
+		.min_signal = 5,
+		.max_signal = 5,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "uart3_tx",
+		.min_signal = 6,
+		.max_signal = 6,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "uart3_rx",
+		.min_signal = 7,
+		.max_signal = 7,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "pcm0_tx",
+		.min_signal = 8,
+		.max_signal = 8,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "pcm0_rx",
+		.min_signal = 9,
+		.max_signal = 9,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "i2s0_tx",
+		.min_signal = 10,
+		.max_signal = 10,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "i2s0_rx",
+		.min_signal = 11,
+		.max_signal = 11,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "spi0_tx",
+		.min_signal = 12,
+		.max_signal = 12,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "spi0_rx",
+		.min_signal = 13,
+		.max_signal = 13,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "i2s2_tx",
+		.min_signal = 14,
+		.max_signal = 14,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "i2s2_rx",
+		.min_signal = 15,
+		.max_signal = 15,
+		.periph_buses = PL08X_AHB2,
+	}
+};
+
+struct pl08x_platform_data s3c64xx_dma0_plat_data = {
+	.memcpy_channel = {
+		.bus_id = "memcpy",
+		.cctl_memcpy =
+			(PL080_BSIZE_4 << PL080_CONTROL_SB_SIZE_SHIFT |
+			PL080_BSIZE_4 << PL080_CONTROL_DB_SIZE_SHIFT |
+			PL080_WIDTH_32BIT << PL080_CONTROL_SWIDTH_SHIFT |
+			PL080_WIDTH_32BIT << PL080_CONTROL_DWIDTH_SHIFT |
+			PL080_CONTROL_PROT_BUFF | PL080_CONTROL_PROT_CACHE |
+			PL080_CONTROL_PROT_SYS),
+	},
+	.lli_buses = PL08X_AHB1,
+	.mem_buses = PL08X_AHB1,
+	.get_xfer_signal = pl08x_get_xfer_signal,
+	.put_xfer_signal = pl08x_put_xfer_signal,
+	.slave_channels = s3c64xx_dma0_info,
+	.num_slave_channels = ARRAY_SIZE(s3c64xx_dma0_info),
+};
+
+static AMBA_AHB_DEVICE(s3c64xx_dma0, "dma-pl080s.0", 0,
+			0x75000000, {IRQ_DMA0}, &s3c64xx_dma0_plat_data);
+
+/*
+ * DMA1
+ */
+
+static struct pl08x_channel_data s3c64xx_dma1_info[] = {
+	{
+		.bus_id = "pcm1_tx",
+		.min_signal = 0,
+		.max_signal = 0,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "pcm1_rx",
+		.min_signal = 1,
+		.max_signal = 1,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "i2s1_tx",
+		.min_signal = 2,
+		.max_signal = 2,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "i2s1_rx",
+		.min_signal = 3,
+		.max_signal = 3,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "spi1_tx",
+		.min_signal = 4,
+		.max_signal = 4,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "spi1_rx",
+		.min_signal = 5,
+		.max_signal = 5,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "ac97_out",
+		.min_signal = 6,
+		.max_signal = 6,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "ac97_in",
+		.min_signal = 7,
+		.max_signal = 7,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "ac97_mic",
+		.min_signal = 8,
+		.max_signal = 8,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "pwm",
+		.min_signal = 9,
+		.max_signal = 9,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "irda",
+		.min_signal = 10,
+		.max_signal = 10,
+		.periph_buses = PL08X_AHB2,
+	}, {
+		.bus_id = "external",
+		.min_signal = 11,
+		.max_signal = 11,
+		.periph_buses = PL08X_AHB2,
+	},
+};
+
+struct pl08x_platform_data s3c64xx_dma1_plat_data = {
+	.memcpy_channel = {
+		.bus_id = "memcpy",
+		.cctl_memcpy =
+			(PL080_BSIZE_4 << PL080_CONTROL_SB_SIZE_SHIFT |
+			PL080_BSIZE_4 << PL080_CONTROL_DB_SIZE_SHIFT |
+			PL080_WIDTH_32BIT << PL080_CONTROL_SWIDTH_SHIFT |
+			PL080_WIDTH_32BIT << PL080_CONTROL_DWIDTH_SHIFT |
+			PL080_CONTROL_PROT_BUFF | PL080_CONTROL_PROT_CACHE |
+			PL080_CONTROL_PROT_SYS),
+	},
+	.lli_buses = PL08X_AHB1,
+	.mem_buses = PL08X_AHB1,
+	.get_xfer_signal = pl08x_get_xfer_signal,
+	.put_xfer_signal = pl08x_put_xfer_signal,
+	.slave_channels = s3c64xx_dma1_info,
+	.num_slave_channels = ARRAY_SIZE(s3c64xx_dma1_info),
+};
+
+static AMBA_AHB_DEVICE(s3c64xx_dma1, "dma-pl080s.1", 0,
+			0x75100000, {IRQ_DMA1}, &s3c64xx_dma1_plat_data);
+
+static int __init s3c64xx_pl080_init(void)
+{
+	/* Set all DMA configuration to be DMA, not SDMA */
+	writel(0xffffff, S3C64XX_SDMA_SEL);
+
+	if (of_have_populated_dt())
+		return 0;
+
+	amba_device_register(&s3c64xx_dma0_device, &iomem_resource);
+	amba_device_register(&s3c64xx_dma1_device, &iomem_resource);
+
+	return 0;
+}
+arch_initcall(s3c64xx_pl080_init);
diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index 0f9c3f4..90b4b61 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -1513,8 +1513,10 @@ void __init s3c64xx_spi0_set_platdata(int (*cfg_gpio)(void), int src_clk_nr,
 	pd.num_cs = num_cs;
 	pd.src_clk_nr = src_clk_nr;
 	pd.cfg_gpio = (cfg_gpio) ? cfg_gpio : s3c64xx_spi0_cfg_gpio;
-#ifdef CONFIG_PL330_DMA
+#if defined(CONFIG_PL330_DMA)
 	pd.filter = pl330_filter;
+#elif defined(CONFIG_S3C64XX_PL080)
+	pd.filter = pl08x_filter_id;
 #endif
 
 	s3c_set_platdata(&pd, sizeof(pd), &s3c64xx_device_spi0);
@@ -1554,8 +1556,10 @@ void __init s3c64xx_spi1_set_platdata(int (*cfg_gpio)(void), int src_clk_nr,
 	pd.num_cs = num_cs;
 	pd.src_clk_nr = src_clk_nr;
 	pd.cfg_gpio = (cfg_gpio) ? cfg_gpio : s3c64xx_spi1_cfg_gpio;
-#ifdef CONFIG_PL330_DMA
+#if defined(CONFIG_PL330_DMA)
 	pd.filter = pl330_filter;
+#elif defined(CONFIG_S3C64XX_PL080)
+	pd.filter = pl08x_filter_id;
 #endif
 
 	s3c_set_platdata(&pd, sizeof(pd), &s3c64xx_device_spi1);
@@ -1595,8 +1599,10 @@ void __init s3c64xx_spi2_set_platdata(int (*cfg_gpio)(void), int src_clk_nr,
 	pd.num_cs = num_cs;
 	pd.src_clk_nr = src_clk_nr;
 	pd.cfg_gpio = (cfg_gpio) ? cfg_gpio : s3c64xx_spi2_cfg_gpio;
-#ifdef CONFIG_PL330_DMA
+#if defined(CONFIG_PL330_DMA)
 	pd.filter = pl330_filter;
+#elif defined(CONFIG_S3C64XX_PL080)
+	pd.filter = pl08x_filter_id;
 #endif
 
 	s3c_set_platdata(&pd, sizeof(pd), &s3c64xx_device_spi2);
diff --git a/arch/arm/plat-samsung/dma-ops.c b/arch/arm/plat-samsung/dma-ops.c
index ec0d731..886326e 100644
--- a/arch/arm/plat-samsung/dma-ops.c
+++ b/arch/arm/plat-samsung/dma-ops.c
@@ -18,6 +18,12 @@
 
 #include <mach/dma.h>
 
+#if defined(CONFIG_PL330_DMA)
+#define dma_filter pl330_filter
+#elif defined(CONFIG_S3C64XX_PL080)
+#define dma_filter pl08x_filter_id
+#endif
+
 static unsigned samsung_dmadev_request(enum dma_ch dma_ch,
 				struct samsung_dma_req *param,
 				struct device *dev, char *ch_name)
@@ -30,7 +36,7 @@ static unsigned samsung_dmadev_request(enum dma_ch dma_ch,
 	if (dev->of_node)
 		return (unsigned)dma_request_slave_channel(dev, ch_name);
 	else
-		return (unsigned)dma_request_channel(mask, pl330_filter,
+		return (unsigned)dma_request_channel(mask, dma_filter,
 							(void *)dma_ch);
 }
 
-- 
1.8.3.2


