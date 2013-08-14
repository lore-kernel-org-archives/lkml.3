Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965Ab3HNMBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:01:08 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58488 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759917Ab3HNMBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:01:04 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: kgene.kim@samsung.com
Subject: [PATCH v2 3/4] ARM: S3C24XX: add platform-devices for new dma driver for s3c2412 and s3c2443
Date: Wed, 14 Aug 2013 14:00:56 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        linus.walleij@linaro.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <201308141359.13872.heiko@sntech.de>
In-Reply-To: <201308141359.13872.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308141400.56486.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes defining the mapping for the request sources.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
changes since v1:
- follow new pdata definition

 arch/arm/mach-s3c24xx/common.c        |  106 +++++++++++++++++++++++++++++++++
 arch/arm/mach-s3c24xx/common.h        |    3 +
 arch/arm/mach-s3c24xx/mach-jive.c     |    1 +
 arch/arm/mach-s3c24xx/mach-smdk2413.c |    1 +
 arch/arm/mach-s3c24xx/mach-smdk2416.c |    1 +
 arch/arm/mach-s3c24xx/mach-smdk2443.c |    1 +
 arch/arm/mach-s3c24xx/mach-vstms.c    |    1 +
 7 files changed, 114 insertions(+)

diff --git a/arch/arm/mach-s3c24xx/common.c b/arch/arm/mach-s3c24xx/common.c
index c157103..6e19167 100644
--- a/arch/arm/mach-s3c24xx/common.c
+++ b/arch/arm/mach-s3c24xx/common.c
@@ -30,6 +30,7 @@
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/platform_data/dma-s3c24xx.h>
 
 #include <mach/hardware.h>
 #include <mach/regs-clock.h>
@@ -43,6 +44,7 @@
 
 #include <mach/regs-gpio.h>
 #include <plat/regs-serial.h>
+#include <mach/dma.h>
 
 #include <plat/cpu.h>
 #include <plat/devs.h>
@@ -302,3 +304,107 @@ void __init_or_cpufreq s3c24xx_setup_clocks(unsigned long fclk,
 	clk_p.rate = pclk;
 	clk_f.rate = fclk;
 }
+
+#if defined(CONFIG_CPU_S3C2410) || defined(CONFIG_CPU_S3C2412) || \
+    defined(CONFIG_CPU_S3C2440) || defined(CONFIG_CPU_S3C2442)
+static struct resource s3c2410_dma_resource[] = {
+	[0] = DEFINE_RES_MEM(S3C24XX_PA_DMA, S3C24XX_SZ_DMA),
+	[1] = DEFINE_RES_IRQ(IRQ_DMA0),
+	[2] = DEFINE_RES_IRQ(IRQ_DMA1),
+	[3] = DEFINE_RES_IRQ(IRQ_DMA2),
+	[4] = DEFINE_RES_IRQ(IRQ_DMA3),
+};
+#endif
+
+#ifdef CONFIG_CPU_S3C2412
+static struct s3c24xx_dma_channel s3c2412_dma_channels[DMACH_MAX] = {
+	[DMACH_XD0] = { S3C24XX_DMA_AHB, true, 17 },
+	[DMACH_XD1] = { S3C24XX_DMA_AHB, true, 18 },
+	[DMACH_SDI] = { S3C24XX_DMA_APB, false, 10 },
+	[DMACH_SPI0_RX] = { S3C24XX_DMA_APB, true, 1 },
+	[DMACH_SPI0_TX] = { S3C24XX_DMA_APB, true, 0 },
+	[DMACH_SPI1_RX] = { S3C24XX_DMA_APB, true, 3 },
+	[DMACH_SPI1_TX] = { S3C24XX_DMA_APB, true, 2 },
+	[DMACH_UART0] = { S3C24XX_DMA_APB, true, 19 },
+	[DMACH_UART1] = { S3C24XX_DMA_APB, true, 21 },
+	[DMACH_UART2] = { S3C24XX_DMA_APB, true, 23 },
+	[DMACH_UART0_SRC2] = { S3C24XX_DMA_APB, true, 20 },
+	[DMACH_UART1_SRC2] = { S3C24XX_DMA_APB, true, 22 },
+	[DMACH_UART2_SRC2] = { S3C24XX_DMA_APB, true, 24 },
+	[DMACH_TIMER] = { S3C24XX_DMA_APB, true, 9 },
+	[DMACH_I2S_IN] = { S3C24XX_DMA_APB, true, 5 },
+	[DMACH_I2S_OUT] = { S3C24XX_DMA_APB, true, 4 },
+	[DMACH_USB_EP1] = { S3C24XX_DMA_APB, true, 13 },
+	[DMACH_USB_EP2] = { S3C24XX_DMA_APB, true, 14 },
+	[DMACH_USB_EP3] = { S3C24XX_DMA_APB, true, 15 },
+	[DMACH_USB_EP4] = { S3C24XX_DMA_APB, true, 16 },
+};
+
+static struct s3c24xx_dma_platdata s3c2412_dma_platdata = {
+	.num_phy_channels = 4,
+	.channels = s3c2412_dma_channels,
+	.num_channels = DMACH_MAX,
+};
+
+struct platform_device s3c2412_device_dma = {
+	.name		= "s3c2412-dma",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(s3c2410_dma_resource),
+	.resource	= s3c2410_dma_resource,
+	.dev	= {
+		.platform_data	= &s3c2412_dma_platdata,
+	},
+};
+#endif
+
+#if defined(CONFIG_CPUS_3C2443) || defined(CONFIG_CPU_S3C2416)
+static struct resource s3c2443_dma_resource[] = {
+	[0] = DEFINE_RES_MEM(S3C24XX_PA_DMA, S3C24XX_SZ_DMA),
+	[1] = DEFINE_RES_IRQ(IRQ_S3C2443_DMA0),
+	[2] = DEFINE_RES_IRQ(IRQ_S3C2443_DMA1),
+	[3] = DEFINE_RES_IRQ(IRQ_S3C2443_DMA2),
+	[4] = DEFINE_RES_IRQ(IRQ_S3C2443_DMA3),
+	[5] = DEFINE_RES_IRQ(IRQ_S3C2443_DMA4),
+	[6] = DEFINE_RES_IRQ(IRQ_S3C2443_DMA5),
+};
+
+static struct s3c24xx_dma_channel s3c2443_dma_channels[DMACH_MAX] = {
+	[DMACH_XD0] = { S3C24XX_DMA_AHB, true, 17 },
+	[DMACH_XD1] = { S3C24XX_DMA_AHB, true, 18 },
+	[DMACH_SDI] = { S3C24XX_DMA_APB, false, 10 },
+	[DMACH_SPI0_RX] = { S3C24XX_DMA_APB, true, 1 },
+	[DMACH_SPI0_TX] = { S3C24XX_DMA_APB, true, 0 },
+	[DMACH_SPI1_RX] = { S3C24XX_DMA_APB, true, 3 },
+	[DMACH_SPI1_TX] = { S3C24XX_DMA_APB, true, 2 },
+	[DMACH_UART0] = { S3C24XX_DMA_APB, true, 19 },
+	[DMACH_UART1] = { S3C24XX_DMA_APB, true, 21 },
+	[DMACH_UART2] = { S3C24XX_DMA_APB, true, 23 },
+	[DMACH_UART3] = { S3C24XX_DMA_APB, true, 25 },
+	[DMACH_UART0_SRC2] = { S3C24XX_DMA_APB, true, 20 },
+	[DMACH_UART1_SRC2] = { S3C24XX_DMA_APB, true, 22 },
+	[DMACH_UART2_SRC2] = { S3C24XX_DMA_APB, true, 24 },
+	[DMACH_UART3_SRC2] = { S3C24XX_DMA_APB, true, 26 },
+	[DMACH_TIMER] = { S3C24XX_DMA_APB, true, 9 },
+	[DMACH_I2S_IN] = { S3C24XX_DMA_APB, true, 5 },
+	[DMACH_I2S_OUT] = { S3C24XX_DMA_APB, true, 4 },
+	[DMACH_PCM_IN] = { S3C24XX_DMA_APB, true, 28 },
+	[DMACH_PCM_OUT] = { S3C24XX_DMA_APB, true, 27 },
+	[DMACH_MIC_IN] = { S3C24XX_DMA_APB, true, 29 },
+};
+
+static struct s3c24xx_dma_platdata s3c2443_dma_platdata = {
+	.num_phy_channels = 6,
+	.channels = s3c2443_dma_channels,
+	.num_channels = DMACH_MAX,
+};
+
+struct platform_device s3c2443_device_dma = {
+	.name		= "s3c2443-dma",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(s3c2443_dma_resource),
+	.resource	= s3c2443_dma_resource,
+	.dev	= {
+		.platform_data	= &s3c2443_dma_platdata,
+	},
+};
+#endif
diff --git a/arch/arm/mach-s3c24xx/common.h b/arch/arm/mach-s3c24xx/common.h
index 84b2806..fe07189 100644
--- a/arch/arm/mach-s3c24xx/common.h
+++ b/arch/arm/mach-s3c24xx/common.h
@@ -109,4 +109,7 @@ extern void s3c2443_init_irq(void);
 
 extern struct syscore_ops s3c24xx_irq_syscore_ops;
 
+extern struct platform_device s3c2412_device_dma;
+extern struct platform_device s3c2443_device_dma;
+
 #endif /* __ARCH_ARM_MACH_S3C24XX_COMMON_H */
diff --git a/arch/arm/mach-s3c24xx/mach-jive.c b/arch/arm/mach-s3c24xx/mach-jive.c
index a45fcd8..43c23e2 100644
--- a/arch/arm/mach-s3c24xx/mach-jive.c
+++ b/arch/arm/mach-s3c24xx/mach-jive.c
@@ -466,6 +466,7 @@ static struct platform_device *jive_devices[] __initdata = {
 	&jive_device_wm8750,
 	&s3c_device_nand,
 	&s3c_device_usbgadget,
+	&s3c2412_device_dma,
 };
 
 static struct s3c2410_udc_mach_info jive_udc_cfg __initdata = {
diff --git a/arch/arm/mach-s3c24xx/mach-smdk2413.c b/arch/arm/mach-s3c24xx/mach-smdk2413.c
index 8146e92..c9d31ef 100644
--- a/arch/arm/mach-s3c24xx/mach-smdk2413.c
+++ b/arch/arm/mach-s3c24xx/mach-smdk2413.c
@@ -89,6 +89,7 @@ static struct platform_device *smdk2413_devices[] __initdata = {
 	&s3c_device_i2c0,
 	&s3c_device_iis,
 	&s3c_device_usbgadget,
+	&s3c2412_device_dma,
 };
 
 static void __init smdk2413_fixup(struct tag *tags, char **cmdline,
diff --git a/arch/arm/mach-s3c24xx/mach-smdk2416.c b/arch/arm/mach-s3c24xx/mach-smdk2416.c
index cb46847..f88e672 100644
--- a/arch/arm/mach-s3c24xx/mach-smdk2416.c
+++ b/arch/arm/mach-s3c24xx/mach-smdk2416.c
@@ -215,6 +215,7 @@ static struct platform_device *smdk2416_devices[] __initdata = {
 	&s3c_device_hsmmc0,
 	&s3c_device_hsmmc1,
 	&s3c_device_usb_hsudc,
+	&s3c2443_device_dma,
 };
 
 static void __init smdk2416_map_io(void)
diff --git a/arch/arm/mach-s3c24xx/mach-smdk2443.c b/arch/arm/mach-s3c24xx/mach-smdk2443.c
index 9435c3b..d9933fc 100644
--- a/arch/arm/mach-s3c24xx/mach-smdk2443.c
+++ b/arch/arm/mach-s3c24xx/mach-smdk2443.c
@@ -115,6 +115,7 @@ static struct platform_device *smdk2443_devices[] __initdata = {
 #ifdef CONFIG_SND_SOC_SMDK2443_WM9710
 	&s3c_device_ac97,
 #endif
+	&s3c2443_device_dma,
 };
 
 static void __init smdk2443_map_io(void)
diff --git a/arch/arm/mach-s3c24xx/mach-vstms.c b/arch/arm/mach-s3c24xx/mach-vstms.c
index b665884..f7ec9c5 100644
--- a/arch/arm/mach-s3c24xx/mach-vstms.c
+++ b/arch/arm/mach-s3c24xx/mach-vstms.c
@@ -126,6 +126,7 @@ static struct platform_device *vstms_devices[] __initdata = {
 	&s3c_device_iis,
 	&s3c_device_rtc,
 	&s3c_device_nand,
+	&s3c2412_device_dma,
 };
 
 static void __init vstms_fixup(struct tag *tags, char **cmdline,
-- 
1.7.10.4

