Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbaGDUXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 16:23:16 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:64861 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299AbaGDUXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 16:23:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 18/19] ARM: SAMSUNG: Remove remaining legacy code
Date: Fri, 04 Jul 2014 22:23:08 +0200
Message-ID: <4267278.JdVSGvRhtr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404496099-26708-19-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com> <1404496099-26708-19-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:w6FAAto9PBDooGSK5PDDRc9QzSdn0aaaWnkgkRL0cUC
 9/zyfk7VzgPsJ6jfXoB3dR+0rk3VWR0I7UiayJbUTEfdrf35lu
 /+8/CZYk+W4S7i7evE9OK0DtAS3Wm1vWeRy7eEZ6+ni0uus6Gl
 eO7jg21RGca08ieAw8vCdbEQAa6pbK6IWTpqZzsV7xGkYc7ezz
 /K4A4W2gliPpjRGbfE8vqf+O3GgnMlw0XUQ4K0/wWDAQZNgiLN
 7ZFDaIZaOEjQccm12R49w0m2jCFhFhU6gt5OQxwOtea6NuxBTo
 ufrWs5Ohf0C4TU5ZMdwEIfZG3Z3nbODcQKXCWAYf+8lL0t0VWO
 CHGbAJvRVeU/qiz4SuVI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2014 19:48:18 Tomasz Figa wrote:
> After refactoring suspend/resume, which was last part with dependencies
> on legacy code, all Kconfig symbols related to Samsung ATAGS support can
> be deselected and more unused code removed. This includes most of s5p-*
> code as well, as s5pv210 was their last user.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>

I actually found a few more, see patch below. Feel free to merge it
into yours.

As discussed on IRC, I have also done an experimental patch to move
the few contents of mach-s5pv210 into mach-exynos, which turned out
very simple and should be uncontroversial but needs more testing.

Finally, there is some more cleanup potential in moving things out
of plat-samsung into the individual platforms (s3c24xx, s3c64xx,
exynos including s5pv210), as a lot of files are now only used
on one of them.

I tried moving everything that the combined mach-exynos needs out
of plat-samsung, but that resulted in about 500-600 lines of duplication
between s3c and exynos for pm-common.c, pm-common.h, pmdebug.c
and pm-check.c, so those four files should probably remain shared
for now.

	Arnd

commit c0157e3dcf12f9e5d6c41e143bd9ba2bb3fe406a
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri Jul 4 21:10:39 2014 +0200

    ARM: samsung: remove unused device definitions
    
    After the s5p platforms have all been deleted or turned into
    DT-only platforms, a lot of device definitions are now completely
    unused and can be removed.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 0eee25d..14bddde 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -55,22 +55,6 @@ config SAMSUNG_ATAGS
 
 if SAMSUNG_ATAGS
 
-config SAMSUNG_GPIO_EXTRA
-	int "Number of additional GPIO pins"
-	default 128 if SAMSUNG_GPIO_EXTRA128
-	default 64 if SAMSUNG_GPIO_EXTRA64
-	default 0
-	help
-	  Use additional GPIO space in addition to the GPIO's the SOC
-	  provides. This allows expanding the GPIO space for use with
-	  GPIO expanders.
-
-config SAMSUNG_GPIO_EXTRA64
-	bool
-
-config SAMSUNG_GPIO_EXTRA128
-	bool
-
 config S3C_GPIO_SPACE
 	int "Space between gpio banks"
 	default 0
@@ -112,11 +96,6 @@ config S3C_DEV_HSMMC2
 	help
 	  Compile in platform device definitions for HSMMC channel 2
 
-config S3C_DEV_HSMMC3
-	bool
-	help
-	  Compile in platform device definitions for HSMMC channel 3
-
 config S3C_DEV_HWMON
 	bool
 	help
@@ -127,36 +106,6 @@ config S3C_DEV_I2C1
 	help
 	  Compile in platform device definitions for I2C channel 1
 
-config S3C_DEV_I2C2
-	bool
-	help
-	  Compile in platform device definitions for I2C channel 2
-
-config S3C_DEV_I2C3
-	bool
-	help
-	  Compile in platform device definition for I2C controller 3
-
-config S3C_DEV_I2C4
-	bool
-	help
-	  Compile in platform device definition for I2C controller 4
-
-config S3C_DEV_I2C5
-	bool
-	help
-	  Compile in platform device definition for I2C controller 5
-
-config S3C_DEV_I2C6
-	bool
-	help
-	  Compile in platform device definition for I2C controller 6
-
-config S3C_DEV_I2C7
-	bool
-	help
-	  Compile in platform device definition for I2C controller 7
-
 config S3C_DEV_FB
 	bool
 	help
@@ -272,7 +221,7 @@ config SAMSUNG_PM_GPIO
 
 config SAMSUNG_DMADEV
 	bool "Use legacy Samsung DMA abstraction"
-	depends on CPU_S5PV210 || ARCH_S3C64XX
+	depends on ARCH_S3C64XX
 	select DMADEVICES
 	default y
 	help
diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index 83c7d15..319c547 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -282,36 +282,6 @@ void s3c_sdhci2_set_platdata(struct s3c_sdhci_platdata *pd)
 }
 #endif /* CONFIG_S3C_DEV_HSMMC2 */
 
-#ifdef CONFIG_S3C_DEV_HSMMC3
-static struct resource s3c_hsmmc3_resource[] = {
-	[0] = DEFINE_RES_MEM(S3C_PA_HSMMC3, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_HSMMC3),
-};
-
-struct s3c_sdhci_platdata s3c_hsmmc3_def_platdata = {
-	.max_width	= 4,
-	.host_caps	= (MMC_CAP_4_BIT_DATA |
-			   MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED),
-};
-
-struct platform_device s3c_device_hsmmc3 = {
-	.name		= "s3c-sdhci",
-	.id		= 3,
-	.num_resources	= ARRAY_SIZE(s3c_hsmmc3_resource),
-	.resource	= s3c_hsmmc3_resource,
-	.dev		= {
-		.dma_mask		= &samsung_device_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-		.platform_data		= &s3c_hsmmc3_def_platdata,
-	},
-};
-
-void s3c_sdhci3_set_platdata(struct s3c_sdhci_platdata *pd)
-{
-	s3c_sdhci_set_platdata(pd, &s3c_hsmmc3_def_platdata);
-}
-#endif /* CONFIG_S3C_DEV_HSMMC3 */
-
 /* I2C */
 
 static struct resource s3c_i2c0_resource[] = {
@@ -379,186 +349,6 @@ void __init s3c_i2c1_set_platdata(struct s3c2410_platform_i2c *pd)
 }
 #endif /* CONFIG_S3C_DEV_I2C1 */
 
-#ifdef CONFIG_S3C_DEV_I2C2
-static struct resource s3c_i2c2_resource[] = {
-	[0] = DEFINE_RES_MEM(S3C_PA_IIC2, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_IIC2),
-};
-
-struct platform_device s3c_device_i2c2 = {
-	.name		= "s3c2410-i2c",
-	.id		= 2,
-	.num_resources	= ARRAY_SIZE(s3c_i2c2_resource),
-	.resource	= s3c_i2c2_resource,
-};
-
-void __init s3c_i2c2_set_platdata(struct s3c2410_platform_i2c *pd)
-{
-	struct s3c2410_platform_i2c *npd;
-
-	if (!pd) {
-		pd = &default_i2c_data;
-		pd->bus_num = 2;
-	}
-
-	npd = s3c_set_platdata(pd, sizeof(struct s3c2410_platform_i2c),
-			       &s3c_device_i2c2);
-
-	if (!npd->cfg_gpio)
-		npd->cfg_gpio = s3c_i2c2_cfg_gpio;
-}
-#endif /* CONFIG_S3C_DEV_I2C2 */
-
-#ifdef CONFIG_S3C_DEV_I2C3
-static struct resource s3c_i2c3_resource[] = {
-	[0] = DEFINE_RES_MEM(S3C_PA_IIC3, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_IIC3),
-};
-
-struct platform_device s3c_device_i2c3 = {
-	.name		= "s3c2440-i2c",
-	.id		= 3,
-	.num_resources	= ARRAY_SIZE(s3c_i2c3_resource),
-	.resource	= s3c_i2c3_resource,
-};
-
-void __init s3c_i2c3_set_platdata(struct s3c2410_platform_i2c *pd)
-{
-	struct s3c2410_platform_i2c *npd;
-
-	if (!pd) {
-		pd = &default_i2c_data;
-		pd->bus_num = 3;
-	}
-
-	npd = s3c_set_platdata(pd, sizeof(struct s3c2410_platform_i2c),
-			       &s3c_device_i2c3);
-
-	if (!npd->cfg_gpio)
-		npd->cfg_gpio = s3c_i2c3_cfg_gpio;
-}
-#endif /*CONFIG_S3C_DEV_I2C3 */
-
-#ifdef CONFIG_S3C_DEV_I2C4
-static struct resource s3c_i2c4_resource[] = {
-	[0] = DEFINE_RES_MEM(S3C_PA_IIC4, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_IIC4),
-};
-
-struct platform_device s3c_device_i2c4 = {
-	.name		= "s3c2440-i2c",
-	.id		= 4,
-	.num_resources	= ARRAY_SIZE(s3c_i2c4_resource),
-	.resource	= s3c_i2c4_resource,
-};
-
-void __init s3c_i2c4_set_platdata(struct s3c2410_platform_i2c *pd)
-{
-	struct s3c2410_platform_i2c *npd;
-
-	if (!pd) {
-		pd = &default_i2c_data;
-		pd->bus_num = 4;
-	}
-
-	npd = s3c_set_platdata(pd, sizeof(struct s3c2410_platform_i2c),
-			       &s3c_device_i2c4);
-
-	if (!npd->cfg_gpio)
-		npd->cfg_gpio = s3c_i2c4_cfg_gpio;
-}
-#endif /*CONFIG_S3C_DEV_I2C4 */
-
-#ifdef CONFIG_S3C_DEV_I2C5
-static struct resource s3c_i2c5_resource[] = {
-	[0] = DEFINE_RES_MEM(S3C_PA_IIC5, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_IIC5),
-};
-
-struct platform_device s3c_device_i2c5 = {
-	.name		= "s3c2440-i2c",
-	.id		= 5,
-	.num_resources	= ARRAY_SIZE(s3c_i2c5_resource),
-	.resource	= s3c_i2c5_resource,
-};
-
-void __init s3c_i2c5_set_platdata(struct s3c2410_platform_i2c *pd)
-{
-	struct s3c2410_platform_i2c *npd;
-
-	if (!pd) {
-		pd = &default_i2c_data;
-		pd->bus_num = 5;
-	}
-
-	npd = s3c_set_platdata(pd, sizeof(struct s3c2410_platform_i2c),
-			       &s3c_device_i2c5);
-
-	if (!npd->cfg_gpio)
-		npd->cfg_gpio = s3c_i2c5_cfg_gpio;
-}
-#endif /*CONFIG_S3C_DEV_I2C5 */
-
-#ifdef CONFIG_S3C_DEV_I2C6
-static struct resource s3c_i2c6_resource[] = {
-	[0] = DEFINE_RES_MEM(S3C_PA_IIC6, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_IIC6),
-};
-
-struct platform_device s3c_device_i2c6 = {
-	.name		= "s3c2440-i2c",
-	.id		= 6,
-	.num_resources	= ARRAY_SIZE(s3c_i2c6_resource),
-	.resource	= s3c_i2c6_resource,
-};
-
-void __init s3c_i2c6_set_platdata(struct s3c2410_platform_i2c *pd)
-{
-	struct s3c2410_platform_i2c *npd;
-
-	if (!pd) {
-		pd = &default_i2c_data;
-		pd->bus_num = 6;
-	}
-
-	npd = s3c_set_platdata(pd, sizeof(struct s3c2410_platform_i2c),
-			       &s3c_device_i2c6);
-
-	if (!npd->cfg_gpio)
-		npd->cfg_gpio = s3c_i2c6_cfg_gpio;
-}
-#endif /* CONFIG_S3C_DEV_I2C6 */
-
-#ifdef CONFIG_S3C_DEV_I2C7
-static struct resource s3c_i2c7_resource[] = {
-	[0] = DEFINE_RES_MEM(S3C_PA_IIC7, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_IIC7),
-};
-
-struct platform_device s3c_device_i2c7 = {
-	.name		= "s3c2440-i2c",
-	.id		= 7,
-	.num_resources	= ARRAY_SIZE(s3c_i2c7_resource),
-	.resource	= s3c_i2c7_resource,
-};
-
-void __init s3c_i2c7_set_platdata(struct s3c2410_platform_i2c *pd)
-{
-	struct s3c2410_platform_i2c *npd;
-
-	if (!pd) {
-		pd = &default_i2c_data;
-		pd->bus_num = 7;
-	}
-
-	npd = s3c_set_platdata(pd, sizeof(struct s3c2410_platform_i2c),
-			       &s3c_device_i2c7);
-
-	if (!npd->cfg_gpio)
-		npd->cfg_gpio = s3c_i2c7_cfg_gpio;
-}
-#endif /* CONFIG_S3C_DEV_I2C7 */
-
 /* I2S */
 
 #ifdef CONFIG_PLAT_S3C24XX
@@ -1184,46 +974,3 @@ void __init s3c64xx_spi1_set_platdata(int (*cfg_gpio)(void), int src_clk_nr,
 	s3c_set_platdata(&pd, sizeof(pd), &s3c64xx_device_spi1);
 }
 #endif /* CONFIG_S3C64XX_DEV_SPI1 */
-
-#ifdef CONFIG_S3C64XX_DEV_SPI2
-static struct resource s3c64xx_spi2_resource[] = {
-	[0] = DEFINE_RES_MEM(S3C_PA_SPI2, SZ_256),
-	[1] = DEFINE_RES_DMA(DMACH_SPI2_TX),
-	[2] = DEFINE_RES_DMA(DMACH_SPI2_RX),
-	[3] = DEFINE_RES_IRQ(IRQ_SPI2),
-};
-
-struct platform_device s3c64xx_device_spi2 = {
-	.name		= "s3c6410-spi",
-	.id		= 2,
-	.num_resources	= ARRAY_SIZE(s3c64xx_spi2_resource),
-	.resource	= s3c64xx_spi2_resource,
-	.dev = {
-		.dma_mask		= &samsung_device_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
-void __init s3c64xx_spi2_set_platdata(int (*cfg_gpio)(void), int src_clk_nr,
-						int num_cs)
-{
-	struct s3c64xx_spi_info pd;
-
-	/* Reject invalid configuration */
-	if (!num_cs || src_clk_nr < 0) {
-		pr_err("%s: Invalid SPI configuration\n", __func__);
-		return;
-	}
-
-	pd.num_cs = num_cs;
-	pd.src_clk_nr = src_clk_nr;
-	pd.cfg_gpio = (cfg_gpio) ? cfg_gpio : s3c64xx_spi2_cfg_gpio;
-#if defined(CONFIG_PL330_DMA)
-	pd.filter = pl330_filter;
-#elif defined(CONFIG_S3C64XX_PL080)
-	pd.filter = pl08x_filter_id;
-#endif
-
-	s3c_set_platdata(&pd, sizeof(pd), &s3c64xx_device_spi2);
-}
-#endif /* CONFIG_S3C64XX_DEV_SPI2 */
diff --git a/arch/arm/plat-samsung/include/plat/dma-pl330.h b/arch/arm/plat-samsung/include/plat/dma-pl330.h
deleted file mode 100644
index abe07fa..0000000
--- a/arch/arm/plat-samsung/include/plat/dma-pl330.h
+++ /dev/null
@@ -1,121 +0,0 @@
-/*
- * Copyright (C) 2010 Samsung Electronics Co. Ltd.
- *	Jaswinder Singh <jassi.brar@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __DMA_PL330_H_
-#define __DMA_PL330_H_ __FILE__
-
-/*
- * PL330 can assign any channel to communicate with
- * any of the peripherals attched to the DMAC.
- * For the sake of consistency across client drivers,
- * We keep the channel names unchanged and only add
- * missing peripherals are added.
- * Order is not important since DMA PL330 API driver
- * use these just as IDs.
- */
-enum dma_ch {
-	DMACH_UART0_RX = 0,
-	DMACH_UART0_TX,
-	DMACH_UART1_RX,
-	DMACH_UART1_TX,
-	DMACH_UART2_RX,
-	DMACH_UART2_TX,
-	DMACH_UART3_RX,
-	DMACH_UART3_TX,
-	DMACH_UART4_RX,
-	DMACH_UART4_TX,
-	DMACH_UART5_RX,
-	DMACH_UART5_TX,
-	DMACH_USI_RX,
-	DMACH_USI_TX,
-	DMACH_IRDA,
-	DMACH_I2S0_RX,
-	DMACH_I2S0_TX,
-	DMACH_I2S0S_TX,
-	DMACH_I2S1_RX,
-	DMACH_I2S1_TX,
-	DMACH_I2S2_RX,
-	DMACH_I2S2_TX,
-	DMACH_SPI0_RX,
-	DMACH_SPI0_TX,
-	DMACH_SPI1_RX,
-	DMACH_SPI1_TX,
-	DMACH_SPI2_RX,
-	DMACH_SPI2_TX,
-	DMACH_AC97_MICIN,
-	DMACH_AC97_PCMIN,
-	DMACH_AC97_PCMOUT,
-	DMACH_EXTERNAL,
-	DMACH_PWM,
-	DMACH_SPDIF,
-	DMACH_HSI_RX,
-	DMACH_HSI_TX,
-	DMACH_PCM0_TX,
-	DMACH_PCM0_RX,
-	DMACH_PCM1_TX,
-	DMACH_PCM1_RX,
-	DMACH_PCM2_TX,
-	DMACH_PCM2_RX,
-	DMACH_MSM_REQ3,
-	DMACH_MSM_REQ2,
-	DMACH_MSM_REQ1,
-	DMACH_MSM_REQ0,
-	DMACH_SLIMBUS0_RX,
-	DMACH_SLIMBUS0_TX,
-	DMACH_SLIMBUS0AUX_RX,
-	DMACH_SLIMBUS0AUX_TX,
-	DMACH_SLIMBUS1_RX,
-	DMACH_SLIMBUS1_TX,
-	DMACH_SLIMBUS2_RX,
-	DMACH_SLIMBUS2_TX,
-	DMACH_SLIMBUS3_RX,
-	DMACH_SLIMBUS3_TX,
-	DMACH_SLIMBUS4_RX,
-	DMACH_SLIMBUS4_TX,
-	DMACH_SLIMBUS5_RX,
-	DMACH_SLIMBUS5_TX,
-	DMACH_MIPI_HSI0,
-	DMACH_MIPI_HSI1,
-	DMACH_MIPI_HSI2,
-	DMACH_MIPI_HSI3,
-	DMACH_MIPI_HSI4,
-	DMACH_MIPI_HSI5,
-	DMACH_MIPI_HSI6,
-	DMACH_MIPI_HSI7,
-	DMACH_DISP1,
-	DMACH_MTOM_0,
-	DMACH_MTOM_1,
-	DMACH_MTOM_2,
-	DMACH_MTOM_3,
-	DMACH_MTOM_4,
-	DMACH_MTOM_5,
-	DMACH_MTOM_6,
-	DMACH_MTOM_7,
-	/* END Marker, also used to denote a reserved channel */
-	DMACH_MAX,
-};
-
-struct s3c2410_dma_client {
-	char	*name;
-};
-
-static inline bool samsung_dma_has_circular(void)
-{
-	return true;
-}
-
-static inline bool samsung_dma_is_dmadev(void)
-{
-	return true;
-}
-
-#include <plat/dma-ops.h>
-
-#endif	/* __DMA_PL330_H_ */
diff --git a/arch/arm/plat-samsung/include/plat/keypad-core.h b/arch/arm/plat-samsung/include/plat/keypad-core.h
deleted file mode 100644
index d513e1b..0000000
--- a/arch/arm/plat-samsung/include/plat/keypad-core.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * linux/arch/arm/plat-samsung/include/plat/keypad-core.h
- *
- * Copyright (C) 2010 Samsung Electronics Co.Ltd
- * Author: Joonyoung Shim <jy0922.shim@samsung.com>
- *
- * Samsung keypad controller core function
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- */
-
-#ifndef __ASM_ARCH_KEYPAD_CORE_H
-#define __ASM_ARCH_KEYPAD_CORE_H
-
-/* These function are only for use with the core support code, such as
- * the cpu specific initialisation code
- */
-
-/* re-define device name depending on support. */
-static inline void samsung_keypad_setname(char *name)
-{
-#ifdef CONFIG_SAMSUNG_DEV_KEYPAD
-	samsung_device_keypad.name = name;
-#endif
-}
-
-#endif /* __ASM_ARCH_KEYPAD_CORE_H */

