Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaKBPRu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 10:17:50 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:22015 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaKBPRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 10:17:46 -0500
X-ME-Helo: localhost.localdomain
X-ME-Date: Sun, 02 Nov 2014 16:17:44 +0100
X-ME-IP: 109.222.89.236
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Daniel Mack <zonque@gmail.com>,
        linux-kernel@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v1 2/3] arm: pxa: Transition pxa25x to clk framework
Date: Sun,  2 Nov 2014 16:16:54 +0100
Message-Id: <1414941415-13146-3-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414941415-13146-1-git-send-email-robert.jarzmik@free.fr>
References: <1414941415-13146-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Transition the PXA25x CPUs to the clock framework.
This transition still enables legacy platforms to run without device
tree as before, ie relying on platform data encoded in board specific
files.

The transition breaks the previous clocks activation of pin
control (gpio11 and gpio12). Machine files should be amended to take
that into account.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 arch/arm/Kconfig            |   1 +
 arch/arm/mach-pxa/Makefile  |   9 +--
 arch/arm/mach-pxa/generic.c |   2 +
 arch/arm/mach-pxa/generic.h |   1 +
 arch/arm/mach-pxa/pxa25x.c  | 182 --------------------------------------------
 5 files changed, 8 insertions(+), 187 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 89c4b5c..2bae231 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -625,6 +625,7 @@ config ARCH_PXA
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_CPU_SUSPEND if PM
 	select AUTO_ZRELADDR
+	select COMMON_CLK if PXA27x || PXA25x
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select CLKSRC_OF
diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 2fe1824..f05b36d 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -3,16 +3,15 @@
 #
 
 # Common support (must be linked before board specific support)
-obj-y				+= clock.o devices.o generic.o irq.o \
-				   reset.o
+obj-y				+= devices.o generic.o irq.o reset.o
 obj-$(CONFIG_PM)		+= pm.o sleep.o standby.o
 
 # Generic drivers that other drivers may depend upon
 
 # SoC-specific code
-obj-$(CONFIG_PXA25x)		+= mfp-pxa2xx.o clock-pxa2xx.o pxa2xx.o pxa25x.o
-obj-$(CONFIG_PXA27x)		+= mfp-pxa2xx.o clock-pxa2xx.o pxa2xx.o pxa27x.o
-obj-$(CONFIG_PXA3xx)		+= mfp-pxa3xx.o clock-pxa3xx.o pxa3xx.o smemc.o pxa3xx-ulpi.o
+obj-$(CONFIG_PXA25x)		+= mfp-pxa2xx.o pxa2xx.o pxa25x.o
+obj-$(CONFIG_PXA27x)		+= mfp-pxa2xx.o pxa2xx.o pxa27x.o
+obj-$(CONFIG_PXA3xx)		+= mfp-pxa3xx.o clock.o clock-pxa3xx.o pxa3xx.o smemc.o pxa3xx-ulpi.o
 obj-$(CONFIG_CPU_PXA300)	+= pxa300.o
 obj-$(CONFIG_CPU_PXA320)	+= pxa320.o
 obj-$(CONFIG_CPU_PXA930)	+= pxa930.o
diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
index 4ca801b..d988c53 100644
--- a/arch/arm/mach-pxa/generic.c
+++ b/arch/arm/mach-pxa/generic.c
@@ -63,6 +63,8 @@ EXPORT_SYMBOL(get_clock_tick_rate);
  */
 void __init pxa_timer_init(void)
 {
+	if (cpu_is_pxa25x())
+		pxa25x_clocks_init();
 	if (cpu_is_pxa27x())
 		pxa27x_clocks_init();
 	pxa_timer_nodt_init(IRQ_OST0, io_p2v(0x40a00000),
diff --git a/arch/arm/mach-pxa/generic.h b/arch/arm/mach-pxa/generic.h
index 7fda082..c66fe38 100644
--- a/arch/arm/mach-pxa/generic.h
+++ b/arch/arm/mach-pxa/generic.h
@@ -14,6 +14,7 @@
 struct irq_data;
 
 extern void pxa_timer_init(void);
+extern int pxa25x_clocks_init(void);
 extern int pxa27x_clocks_init(void);
 
 extern void __init pxa_map_io(void);
diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
index 66e4a2b..70e6d0e 100644
--- a/arch/arm/mach-pxa/pxa25x.c
+++ b/arch/arm/mach-pxa/pxa25x.c
@@ -44,181 +44,6 @@
  * Various clock factors driven by the CCCR register.
  */
 
-/* Crystal Frequency to Memory Frequency Multiplier (L) */
-static unsigned char L_clk_mult[32] = { 0, 27, 32, 36, 40, 45, 0, };
-
-/* Memory Frequency to Run Mode Frequency Multiplier (M) */
-static unsigned char M_clk_mult[4] = { 0, 1, 2, 4 };
-
-/* Run Mode Frequency to Turbo Mode Frequency Multiplier (N) */
-/* Note: we store the value N * 2 here. */
-static unsigned char N2_clk_mult[8] = { 0, 0, 2, 3, 4, 0, 6, 0 };
-
-/* Crystal clock */
-#define BASE_CLK	3686400
-
-/*
- * Get the clock frequency as reflected by CCCR and the turbo flag.
- * We assume these values have been applied via a fcs.
- * If info is not 0 we also display the current settings.
- */
-unsigned int pxa25x_get_clk_frequency_khz(int info)
-{
-	unsigned long cccr, turbo;
-	unsigned int l, L, m, M, n2, N;
-
-	cccr = CCCR;
-	asm( "mrc\tp14, 0, %0, c6, c0, 0" : "=r" (turbo) );
-
-	l  =  L_clk_mult[(cccr >> 0) & 0x1f];
-	m  =  M_clk_mult[(cccr >> 5) & 0x03];
-	n2 = N2_clk_mult[(cccr >> 7) & 0x07];
-
-	L = l * BASE_CLK;
-	M = m * L;
-	N = n2 * M / 2;
-
-	if(info)
-	{
-		L += 5000;
-		printk( KERN_INFO "Memory clock: %d.%02dMHz (*%d)\n",
-			L / 1000000, (L % 1000000) / 10000, l );
-		M += 5000;
-		printk( KERN_INFO "Run Mode clock: %d.%02dMHz (*%d)\n",
-			M / 1000000, (M % 1000000) / 10000, m );
-		N += 5000;
-		printk( KERN_INFO "Turbo Mode clock: %d.%02dMHz (*%d.%d, %sactive)\n",
-			N / 1000000, (N % 1000000) / 10000, n2 / 2, (n2 % 2) * 5,
-			(turbo & 1) ? "" : "in" );
-	}
-
-	return (turbo & 1) ? (N/1000) : (M/1000);
-}
-
-static unsigned long clk_pxa25x_mem_getrate(struct clk *clk)
-{
-	return L_clk_mult[(CCCR >> 0) & 0x1f] * BASE_CLK;
-}
-
-static const struct clkops clk_pxa25x_mem_ops = {
-	.enable		= clk_dummy_enable,
-	.disable	= clk_dummy_disable,
-	.getrate	= clk_pxa25x_mem_getrate,
-};
-
-static const struct clkops clk_pxa25x_lcd_ops = {
-	.enable		= clk_pxa2xx_cken_enable,
-	.disable	= clk_pxa2xx_cken_disable,
-	.getrate	= clk_pxa25x_mem_getrate,
-};
-
-static unsigned long gpio12_config_32k[] = {
-	GPIO12_32KHz,
-};
-
-static unsigned long gpio12_config_gpio[] = {
-	GPIO12_GPIO,
-};
-
-static void clk_gpio12_enable(struct clk *clk)
-{
-	pxa2xx_mfp_config(gpio12_config_32k, 1);
-}
-
-static void clk_gpio12_disable(struct clk *clk)
-{
-	pxa2xx_mfp_config(gpio12_config_gpio, 1);
-}
-
-static const struct clkops clk_pxa25x_gpio12_ops = {
-	.enable         = clk_gpio12_enable,
-	.disable        = clk_gpio12_disable,
-};
-
-static unsigned long gpio11_config_3m6[] = {
-	GPIO11_3_6MHz,
-};
-
-static unsigned long gpio11_config_gpio[] = {
-	GPIO11_GPIO,
-};
-
-static void clk_gpio11_enable(struct clk *clk)
-{
-	pxa2xx_mfp_config(gpio11_config_3m6, 1);
-}
-
-static void clk_gpio11_disable(struct clk *clk)
-{
-	pxa2xx_mfp_config(gpio11_config_gpio, 1);
-}
-
-static const struct clkops clk_pxa25x_gpio11_ops = {
-	.enable         = clk_gpio11_enable,
-	.disable        = clk_gpio11_disable,
-};
-
-/*
- * 3.6864MHz -> OST, GPIO, SSP, PWM, PLLs (95.842MHz, 147.456MHz)
- * 95.842MHz -> MMC 19.169MHz, I2C 31.949MHz, FICP 47.923MHz, USB 47.923MHz
- * 147.456MHz -> UART 14.7456MHz, AC97 12.288MHz, I2S 5.672MHz (allegedly)
- */
-
-/*
- * PXA 2xx clock declarations.
- */
-static DEFINE_PXA2_CKEN(pxa25x_hwuart, HWUART, 14745600, 1);
-static DEFINE_PXA2_CKEN(pxa25x_ffuart, FFUART, 14745600, 1);
-static DEFINE_PXA2_CKEN(pxa25x_btuart, BTUART, 14745600, 1);
-static DEFINE_PXA2_CKEN(pxa25x_stuart, STUART, 14745600, 1);
-static DEFINE_PXA2_CKEN(pxa25x_usb, USB, 47923000, 5);
-static DEFINE_PXA2_CKEN(pxa25x_mmc, MMC, 19169000, 0);
-static DEFINE_PXA2_CKEN(pxa25x_i2c, I2C, 31949000, 0);
-static DEFINE_PXA2_CKEN(pxa25x_ssp, SSP, 3686400, 0);
-static DEFINE_PXA2_CKEN(pxa25x_nssp, NSSP, 3686400, 0);
-static DEFINE_PXA2_CKEN(pxa25x_assp, ASSP, 3686400, 0);
-static DEFINE_PXA2_CKEN(pxa25x_pwm0, PWM0, 3686400, 0);
-static DEFINE_PXA2_CKEN(pxa25x_pwm1, PWM1, 3686400, 0);
-static DEFINE_PXA2_CKEN(pxa25x_ac97, AC97, 24576000, 0);
-static DEFINE_PXA2_CKEN(pxa25x_i2s, I2S, 14745600, 0);
-static DEFINE_PXA2_CKEN(pxa25x_ficp, FICP, 47923000, 0);
-
-static DEFINE_CK(pxa25x_lcd, LCD, &clk_pxa25x_lcd_ops);
-static DEFINE_CLK(pxa25x_gpio11, &clk_pxa25x_gpio11_ops, 3686400, 0);
-static DEFINE_CLK(pxa25x_gpio12, &clk_pxa25x_gpio12_ops, 32768, 0);
-static DEFINE_CLK(pxa25x_mem, &clk_pxa25x_mem_ops, 0, 0);
-
-static struct clk_lookup pxa25x_clkregs[] = {
-	INIT_CLKREG(&clk_pxa25x_lcd, "pxa2xx-fb", NULL),
-	INIT_CLKREG(&clk_pxa25x_ffuart, "pxa2xx-uart.0", NULL),
-	INIT_CLKREG(&clk_pxa25x_btuart, "pxa2xx-uart.1", NULL),
-	INIT_CLKREG(&clk_pxa25x_stuart, "pxa2xx-uart.2", NULL),
-	INIT_CLKREG(&clk_pxa25x_usb, "pxa25x-udc", NULL),
-	INIT_CLKREG(&clk_pxa25x_mmc, "pxa2xx-mci.0", NULL),
-	INIT_CLKREG(&clk_pxa25x_i2c, "pxa2xx-i2c.0", NULL),
-	INIT_CLKREG(&clk_pxa25x_ssp, "pxa25x-ssp.0", NULL),
-	INIT_CLKREG(&clk_pxa25x_nssp, "pxa25x-nssp.1", NULL),
-	INIT_CLKREG(&clk_pxa25x_assp, "pxa25x-nssp.2", NULL),
-	INIT_CLKREG(&clk_pxa25x_pwm0, "pxa25x-pwm.0", NULL),
-	INIT_CLKREG(&clk_pxa25x_pwm1, "pxa25x-pwm.1", NULL),
-	INIT_CLKREG(&clk_pxa25x_i2s, "pxa2xx-i2s", NULL),
-	INIT_CLKREG(&clk_pxa25x_stuart, "pxa2xx-ir", "UARTCLK"),
-	INIT_CLKREG(&clk_pxa25x_ficp, "pxa2xx-ir", "FICPCLK"),
-	INIT_CLKREG(&clk_pxa25x_ac97, NULL, "AC97CLK"),
-	INIT_CLKREG(&clk_pxa25x_gpio11, NULL, "GPIO11_CLK"),
-	INIT_CLKREG(&clk_pxa25x_gpio12, NULL, "GPIO12_CLK"),
-	INIT_CLKREG(&clk_pxa25x_mem, "pxa2xx-pcmcia", NULL),
-#ifdef CONFIG_CPU_PXA26x
-	INIT_CLKREG(&clk_dummy, "pxa26x-gpio", NULL),
-#else
-	INIT_CLKREG(&clk_dummy, "pxa25x-gpio", NULL),
-#endif
-	INIT_CLKREG(&clk_dummy, "sa1100-rtc", NULL),
-};
-
-static struct clk_lookup pxa25x_hwuart_clkreg =
-	INIT_CLKREG(&clk_pxa25x_hwuart, "pxa2xx-uart.3", NULL);
-
 #ifdef CONFIG_PM
 
 #define SAVE(x)		sleep_save[SLEEP_SAVE_##x] = x
@@ -374,8 +199,6 @@ static int __init pxa25x_init(void)
 
 		reset_status = RCSR;
 
-		clkdev_add_table(pxa25x_clkregs, ARRAY_SIZE(pxa25x_clkregs));
-
 		if ((ret = pxa_init_dma(IRQ_DMA, 16)))
 			return ret;
 
@@ -383,7 +206,6 @@ static int __init pxa25x_init(void)
 
 		register_syscore_ops(&pxa_irq_syscore_ops);
 		register_syscore_ops(&pxa2xx_mfp_syscore_ops);
-		register_syscore_ops(&pxa2xx_clock_syscore_ops);
 
 		pxa_register_device(&pxa25x_device_gpio, &pxa25x_gpio_info);
 		ret = platform_add_devices(pxa25x_devices,
@@ -392,10 +214,6 @@ static int __init pxa25x_init(void)
 			return ret;
 	}
 
-	/* Only add HWUART for PXA255/26x; PXA210/250 do not have it. */
-	if (cpu_is_pxa255())
-		clkdev_add(&pxa25x_hwuart_clkreg);
-
 	return ret;
 }
 
-- 
2.1.0

