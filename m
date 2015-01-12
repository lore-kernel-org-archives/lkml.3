Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbbALXua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:50:30 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46876 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbbALXu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:50:28 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Robert Jarzmik <robert.jarzmik@free.fr>, "Daniel Mack" <daniel@zonque.org>,
        "Haojian Zhuang" <haojian.zhuang@gmail.com>,
        "Robert Jarzmik" <robert.jarzmik@free.fr>,
        "Stephen Boyd" <sboyd@codeaurora.org>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        "Arnd Bergmann" <arnd@arndb.de>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1419688528-760-3-git-send-email-robert.jarzmik@free.fr>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1419688528-760-1-git-send-email-robert.jarzmik@free.fr>
 <1419688528-760-3-git-send-email-robert.jarzmik@free.fr>
Message-ID: <20150112235021.20842.4658@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 2/4] arm: pxa: Transition pxa25x and pxa27x to clk framework
Date: Mon, 12 Jan 2015 15:50:21 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Robert Jarzmik (2014-12-27 05:55:26)
> Transition the PXA25x and PXA27x CPUs to the clock framework.
> This transition still enables legacy platforms to run without device
> tree as before, ie relying on platform data encoded in board specific
> files.
> 
> The transition breaks the previous clocks activation of pin
> control (gpio11 and gpio12). Machine files should be amended to take
> that into account.
> 
> This is the last step of clock framework transition for pxa25x and
> pxa27x, leaving only pxa3xx for further work.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

Reviewed-by: Michael Turquette <mturquette@linaro.org>

> ---
>  arch/arm/Kconfig           |   1 +
>  arch/arm/mach-pxa/Makefile |   9 +--
>  arch/arm/mach-pxa/pxa25x.c | 182 ---------------------------------------------
>  arch/arm/mach-pxa/pxa27x.c | 174 +------------------------------------------
>  4 files changed, 7 insertions(+), 359 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 97d07ed..466ebc2 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -611,6 +611,7 @@ config ARCH_PXA
>         select ARCH_REQUIRE_GPIOLIB
>         select ARM_CPU_SUSPEND if PM
>         select AUTO_ZRELADDR
> +       select COMMON_CLK if PXA27x || PXA25x
>         select CLKDEV_LOOKUP
>         select CLKSRC_MMIO
>         select CLKSRC_OF
> diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
> index eb0bf76..1566a27 100644
> --- a/arch/arm/mach-pxa/Makefile
> +++ b/arch/arm/mach-pxa/Makefile
> @@ -3,16 +3,15 @@
>  #
>  
>  # Common support (must be linked before board specific support)
> -obj-y                          += clock.o devices.o generic.o irq.o \
> -                                  reset.o
> +obj-y                          += devices.o generic.o irq.o reset.o
>  obj-$(CONFIG_PM)               += pm.o sleep.o standby.o
>  
>  # Generic drivers that other drivers may depend upon
>  
>  # SoC-specific code
> -obj-$(CONFIG_PXA25x)           += mfp-pxa2xx.o clock-pxa2xx.o pxa2xx.o pxa25x.o
> -obj-$(CONFIG_PXA27x)           += mfp-pxa2xx.o clock-pxa2xx.o pxa2xx.o pxa27x.o
> -obj-$(CONFIG_PXA3xx)           += mfp-pxa3xx.o clock-pxa3xx.o pxa3xx.o smemc.o pxa3xx-ulpi.o
> +obj-$(CONFIG_PXA25x)           += mfp-pxa2xx.o pxa2xx.o pxa25x.o
> +obj-$(CONFIG_PXA27x)           += mfp-pxa2xx.o pxa2xx.o pxa27x.o
> +obj-$(CONFIG_PXA3xx)           += mfp-pxa3xx.o clock.o clock-pxa3xx.o pxa3xx.o smemc.o pxa3xx-ulpi.o
>  obj-$(CONFIG_CPU_PXA300)       += pxa300.o
>  obj-$(CONFIG_CPU_PXA320)       += pxa320.o
>  obj-$(CONFIG_CPU_PXA930)       += pxa930.o
> diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
> index 66e4a2b..70e6d0e 100644
> --- a/arch/arm/mach-pxa/pxa25x.c
> +++ b/arch/arm/mach-pxa/pxa25x.c
> @@ -44,181 +44,6 @@
>   * Various clock factors driven by the CCCR register.
>   */
>  
> -/* Crystal Frequency to Memory Frequency Multiplier (L) */
> -static unsigned char L_clk_mult[32] = { 0, 27, 32, 36, 40, 45, 0, };
> -
> -/* Memory Frequency to Run Mode Frequency Multiplier (M) */
> -static unsigned char M_clk_mult[4] = { 0, 1, 2, 4 };
> -
> -/* Run Mode Frequency to Turbo Mode Frequency Multiplier (N) */
> -/* Note: we store the value N * 2 here. */
> -static unsigned char N2_clk_mult[8] = { 0, 0, 2, 3, 4, 0, 6, 0 };
> -
> -/* Crystal clock */
> -#define BASE_CLK       3686400
> -
> -/*
> - * Get the clock frequency as reflected by CCCR and the turbo flag.
> - * We assume these values have been applied via a fcs.
> - * If info is not 0 we also display the current settings.
> - */
> -unsigned int pxa25x_get_clk_frequency_khz(int info)
> -{
> -       unsigned long cccr, turbo;
> -       unsigned int l, L, m, M, n2, N;
> -
> -       cccr = CCCR;
> -       asm( "mrc    p14, 0, %0, c6, c0, 0" : "=r" (turbo) );
> -
> -       l  =  L_clk_mult[(cccr >> 0) & 0x1f];
> -       m  =  M_clk_mult[(cccr >> 5) & 0x03];
> -       n2 = N2_clk_mult[(cccr >> 7) & 0x07];
> -
> -       L = l * BASE_CLK;
> -       M = m * L;
> -       N = n2 * M / 2;
> -
> -       if(info)
> -       {
> -               L += 5000;
> -               printk( KERN_INFO "Memory clock: %d.%02dMHz (*%d)\n",
> -                       L / 1000000, (L % 1000000) / 10000, l );
> -               M += 5000;
> -               printk( KERN_INFO "Run Mode clock: %d.%02dMHz (*%d)\n",
> -                       M / 1000000, (M % 1000000) / 10000, m );
> -               N += 5000;
> -               printk( KERN_INFO "Turbo Mode clock: %d.%02dMHz (*%d.%d, %sactive)\n",
> -                       N / 1000000, (N % 1000000) / 10000, n2 / 2, (n2 % 2) * 5,
> -                       (turbo & 1) ? "" : "in" );
> -       }
> -
> -       return (turbo & 1) ? (N/1000) : (M/1000);
> -}
> -
> -static unsigned long clk_pxa25x_mem_getrate(struct clk *clk)
> -{
> -       return L_clk_mult[(CCCR >> 0) & 0x1f] * BASE_CLK;
> -}
> -
> -static const struct clkops clk_pxa25x_mem_ops = {
> -       .enable         = clk_dummy_enable,
> -       .disable        = clk_dummy_disable,
> -       .getrate        = clk_pxa25x_mem_getrate,
> -};
> -
> -static const struct clkops clk_pxa25x_lcd_ops = {
> -       .enable         = clk_pxa2xx_cken_enable,
> -       .disable        = clk_pxa2xx_cken_disable,
> -       .getrate        = clk_pxa25x_mem_getrate,
> -};
> -
> -static unsigned long gpio12_config_32k[] = {
> -       GPIO12_32KHz,
> -};
> -
> -static unsigned long gpio12_config_gpio[] = {
> -       GPIO12_GPIO,
> -};
> -
> -static void clk_gpio12_enable(struct clk *clk)
> -{
> -       pxa2xx_mfp_config(gpio12_config_32k, 1);
> -}
> -
> -static void clk_gpio12_disable(struct clk *clk)
> -{
> -       pxa2xx_mfp_config(gpio12_config_gpio, 1);
> -}
> -
> -static const struct clkops clk_pxa25x_gpio12_ops = {
> -       .enable         = clk_gpio12_enable,
> -       .disable        = clk_gpio12_disable,
> -};
> -
> -static unsigned long gpio11_config_3m6[] = {
> -       GPIO11_3_6MHz,
> -};
> -
> -static unsigned long gpio11_config_gpio[] = {
> -       GPIO11_GPIO,
> -};
> -
> -static void clk_gpio11_enable(struct clk *clk)
> -{
> -       pxa2xx_mfp_config(gpio11_config_3m6, 1);
> -}
> -
> -static void clk_gpio11_disable(struct clk *clk)
> -{
> -       pxa2xx_mfp_config(gpio11_config_gpio, 1);
> -}
> -
> -static const struct clkops clk_pxa25x_gpio11_ops = {
> -       .enable         = clk_gpio11_enable,
> -       .disable        = clk_gpio11_disable,
> -};
> -
> -/*
> - * 3.6864MHz -> OST, GPIO, SSP, PWM, PLLs (95.842MHz, 147.456MHz)
> - * 95.842MHz -> MMC 19.169MHz, I2C 31.949MHz, FICP 47.923MHz, USB 47.923MHz
> - * 147.456MHz -> UART 14.7456MHz, AC97 12.288MHz, I2S 5.672MHz (allegedly)
> - */
> -
> -/*
> - * PXA 2xx clock declarations.
> - */
> -static DEFINE_PXA2_CKEN(pxa25x_hwuart, HWUART, 14745600, 1);
> -static DEFINE_PXA2_CKEN(pxa25x_ffuart, FFUART, 14745600, 1);
> -static DEFINE_PXA2_CKEN(pxa25x_btuart, BTUART, 14745600, 1);
> -static DEFINE_PXA2_CKEN(pxa25x_stuart, STUART, 14745600, 1);
> -static DEFINE_PXA2_CKEN(pxa25x_usb, USB, 47923000, 5);
> -static DEFINE_PXA2_CKEN(pxa25x_mmc, MMC, 19169000, 0);
> -static DEFINE_PXA2_CKEN(pxa25x_i2c, I2C, 31949000, 0);
> -static DEFINE_PXA2_CKEN(pxa25x_ssp, SSP, 3686400, 0);
> -static DEFINE_PXA2_CKEN(pxa25x_nssp, NSSP, 3686400, 0);
> -static DEFINE_PXA2_CKEN(pxa25x_assp, ASSP, 3686400, 0);
> -static DEFINE_PXA2_CKEN(pxa25x_pwm0, PWM0, 3686400, 0);
> -static DEFINE_PXA2_CKEN(pxa25x_pwm1, PWM1, 3686400, 0);
> -static DEFINE_PXA2_CKEN(pxa25x_ac97, AC97, 24576000, 0);
> -static DEFINE_PXA2_CKEN(pxa25x_i2s, I2S, 14745600, 0);
> -static DEFINE_PXA2_CKEN(pxa25x_ficp, FICP, 47923000, 0);
> -
> -static DEFINE_CK(pxa25x_lcd, LCD, &clk_pxa25x_lcd_ops);
> -static DEFINE_CLK(pxa25x_gpio11, &clk_pxa25x_gpio11_ops, 3686400, 0);
> -static DEFINE_CLK(pxa25x_gpio12, &clk_pxa25x_gpio12_ops, 32768, 0);
> -static DEFINE_CLK(pxa25x_mem, &clk_pxa25x_mem_ops, 0, 0);
> -
> -static struct clk_lookup pxa25x_clkregs[] = {
> -       INIT_CLKREG(&clk_pxa25x_lcd, "pxa2xx-fb", NULL),
> -       INIT_CLKREG(&clk_pxa25x_ffuart, "pxa2xx-uart.0", NULL),
> -       INIT_CLKREG(&clk_pxa25x_btuart, "pxa2xx-uart.1", NULL),
> -       INIT_CLKREG(&clk_pxa25x_stuart, "pxa2xx-uart.2", NULL),
> -       INIT_CLKREG(&clk_pxa25x_usb, "pxa25x-udc", NULL),
> -       INIT_CLKREG(&clk_pxa25x_mmc, "pxa2xx-mci.0", NULL),
> -       INIT_CLKREG(&clk_pxa25x_i2c, "pxa2xx-i2c.0", NULL),
> -       INIT_CLKREG(&clk_pxa25x_ssp, "pxa25x-ssp.0", NULL),
> -       INIT_CLKREG(&clk_pxa25x_nssp, "pxa25x-nssp.1", NULL),
> -       INIT_CLKREG(&clk_pxa25x_assp, "pxa25x-nssp.2", NULL),
> -       INIT_CLKREG(&clk_pxa25x_pwm0, "pxa25x-pwm.0", NULL),
> -       INIT_CLKREG(&clk_pxa25x_pwm1, "pxa25x-pwm.1", NULL),
> -       INIT_CLKREG(&clk_pxa25x_i2s, "pxa2xx-i2s", NULL),
> -       INIT_CLKREG(&clk_pxa25x_stuart, "pxa2xx-ir", "UARTCLK"),
> -       INIT_CLKREG(&clk_pxa25x_ficp, "pxa2xx-ir", "FICPCLK"),
> -       INIT_CLKREG(&clk_pxa25x_ac97, NULL, "AC97CLK"),
> -       INIT_CLKREG(&clk_pxa25x_gpio11, NULL, "GPIO11_CLK"),
> -       INIT_CLKREG(&clk_pxa25x_gpio12, NULL, "GPIO12_CLK"),
> -       INIT_CLKREG(&clk_pxa25x_mem, "pxa2xx-pcmcia", NULL),
> -#ifdef CONFIG_CPU_PXA26x
> -       INIT_CLKREG(&clk_dummy, "pxa26x-gpio", NULL),
> -#else
> -       INIT_CLKREG(&clk_dummy, "pxa25x-gpio", NULL),
> -#endif
> -       INIT_CLKREG(&clk_dummy, "sa1100-rtc", NULL),
> -};
> -
> -static struct clk_lookup pxa25x_hwuart_clkreg =
> -       INIT_CLKREG(&clk_pxa25x_hwuart, "pxa2xx-uart.3", NULL);
> -
>  #ifdef CONFIG_PM
>  
>  #define SAVE(x)                sleep_save[SLEEP_SAVE_##x] = x
> @@ -374,8 +199,6 @@ static int __init pxa25x_init(void)
>  
>                 reset_status = RCSR;
>  
> -               clkdev_add_table(pxa25x_clkregs, ARRAY_SIZE(pxa25x_clkregs));
> -
>                 if ((ret = pxa_init_dma(IRQ_DMA, 16)))
>                         return ret;
>  
> @@ -383,7 +206,6 @@ static int __init pxa25x_init(void)
>  
>                 register_syscore_ops(&pxa_irq_syscore_ops);
>                 register_syscore_ops(&pxa2xx_mfp_syscore_ops);
> -               register_syscore_ops(&pxa2xx_clock_syscore_ops);
>  
>                 pxa_register_device(&pxa25x_device_gpio, &pxa25x_gpio_info);
>                 ret = platform_add_devices(pxa25x_devices,
> @@ -392,10 +214,6 @@ static int __init pxa25x_init(void)
>                         return ret;
>         }
>  
> -       /* Only add HWUART for PXA255/26x; PXA210/250 do not have it. */
> -       if (cpu_is_pxa255())
> -               clkdev_add(&pxa25x_hwuart_clkreg);
> -
>         return ret;
>  }
>  
> diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
> index af423a4..0485248 100644
> --- a/arch/arm/mach-pxa/pxa27x.c
> +++ b/arch/arm/mach-pxa/pxa27x.c
> @@ -37,7 +37,8 @@
>  
>  #include "generic.h"
>  #include "devices.h"
> -#include "clock.h"
> +#include <linux/clk-provider.h>
> +#include <linux/clkdev.h>
>  
>  void pxa27x_clear_otgph(void)
>  {
> @@ -73,174 +74,6 @@ void pxa27x_configure_ac97reset(int reset_gpio, bool to_gpio)
>  }
>  EXPORT_SYMBOL_GPL(pxa27x_configure_ac97reset);
>  
> -/* Crystal clock: 13MHz */
> -#define BASE_CLK       13000000
> -
> -/*
> - * Get the clock frequency as reflected by CCSR and the turbo flag.
> - * We assume these values have been applied via a fcs.
> - * If info is not 0 we also display the current settings.
> - */
> -unsigned int pxa27x_get_clk_frequency_khz(int info)
> -{
> -       unsigned long ccsr, clkcfg;
> -       unsigned int l, L, m, M, n2, N, S;
> -               int cccr_a, t, ht, b;
> -
> -       ccsr = CCSR;
> -       cccr_a = CCCR & (1 << 25);
> -
> -       /* Read clkcfg register: it has turbo, b, half-turbo (and f) */
> -       asm( "mrc    p14, 0, %0, c6, c0, 0" : "=r" (clkcfg) );
> -       t  = clkcfg & (1 << 0);
> -       ht = clkcfg & (1 << 2);
> -       b  = clkcfg & (1 << 3);
> -
> -       l  = ccsr & 0x1f;
> -       n2 = (ccsr>>7) & 0xf;
> -       m  = (l <= 10) ? 1 : (l <= 20) ? 2 : 4;
> -
> -       L  = l * BASE_CLK;
> -       N  = (L * n2) / 2;
> -       M  = (!cccr_a) ? (L/m) : ((b) ? L : (L/2));
> -       S  = (b) ? L : (L/2);
> -
> -       if (info) {
> -               printk( KERN_INFO "Run Mode clock: %d.%02dMHz (*%d)\n",
> -                       L / 1000000, (L % 1000000) / 10000, l );
> -               printk( KERN_INFO "Turbo Mode clock: %d.%02dMHz (*%d.%d, %sactive)\n",
> -                       N / 1000000, (N % 1000000)/10000, n2 / 2, (n2 % 2)*5,
> -                       (t) ? "" : "in" );
> -               printk( KERN_INFO "Memory clock: %d.%02dMHz (/%d)\n",
> -                       M / 1000000, (M % 1000000) / 10000, m );
> -               printk( KERN_INFO "System bus clock: %d.%02dMHz \n",
> -                       S / 1000000, (S % 1000000) / 10000 );
> -       }
> -
> -       return (t) ? (N/1000) : (L/1000);
> -}
> -
> -/*
> - * Return the current mem clock frequency as reflected by CCCR[A], B, and L
> - */
> -static unsigned long clk_pxa27x_mem_getrate(struct clk *clk)
> -{
> -       unsigned long ccsr, clkcfg;
> -       unsigned int l, L, m, M;
> -               int cccr_a, b;
> -
> -       ccsr = CCSR;
> -       cccr_a = CCCR & (1 << 25);
> -
> -       /* Read clkcfg register: it has turbo, b, half-turbo (and f) */
> -       asm( "mrc    p14, 0, %0, c6, c0, 0" : "=r" (clkcfg) );
> -       b = clkcfg & (1 << 3);
> -
> -       l = ccsr & 0x1f;
> -       m = (l <= 10) ? 1 : (l <= 20) ? 2 : 4;
> -
> -       L = l * BASE_CLK;
> -       M = (!cccr_a) ? (L/m) : ((b) ? L : (L/2));
> -
> -       return M;
> -}
> -
> -static const struct clkops clk_pxa27x_mem_ops = {
> -       .enable         = clk_dummy_enable,
> -       .disable        = clk_dummy_disable,
> -       .getrate        = clk_pxa27x_mem_getrate,
> -};
> -
> -/*
> - * Return the current LCD clock frequency in units of 10kHz as
> - */
> -static unsigned int pxa27x_get_lcdclk_frequency_10khz(void)
> -{
> -       unsigned long ccsr;
> -       unsigned int l, L, k, K;
> -
> -       ccsr = CCSR;
> -
> -       l = ccsr & 0x1f;
> -       k = (l <= 7) ? 1 : (l <= 16) ? 2 : 4;
> -
> -       L = l * BASE_CLK;
> -       K = L / k;
> -
> -       return (K / 10000);
> -}
> -
> -static unsigned long clk_pxa27x_lcd_getrate(struct clk *clk)
> -{
> -       return pxa27x_get_lcdclk_frequency_10khz() * 10000;
> -}
> -
> -static const struct clkops clk_pxa27x_lcd_ops = {
> -       .enable         = clk_pxa2xx_cken_enable,
> -       .disable        = clk_pxa2xx_cken_disable,
> -       .getrate        = clk_pxa27x_lcd_getrate,
> -};
> -
> -static DEFINE_PXA2_CKEN(pxa27x_ffuart, FFUART, 14857000, 1);
> -static DEFINE_PXA2_CKEN(pxa27x_btuart, BTUART, 14857000, 1);
> -static DEFINE_PXA2_CKEN(pxa27x_stuart, STUART, 14857000, 1);
> -static DEFINE_PXA2_CKEN(pxa27x_i2s, I2S, 14682000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_i2c, I2C, 32842000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_usb, USB, 48000000, 5);
> -static DEFINE_PXA2_CKEN(pxa27x_mmc, MMC, 19500000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_ficp, FICP, 48000000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_usbhost, USBHOST, 48000000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_pwri2c, PWRI2C, 13000000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_keypad, KEYPAD, 32768, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_ssp1, SSP1, 13000000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_ssp2, SSP2, 13000000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_ssp3, SSP3, 13000000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_pwm0, PWM0, 13000000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_pwm1, PWM1, 13000000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_ac97, AC97, 24576000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_ac97conf, AC97CONF, 24576000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_msl, MSL, 48000000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_usim, USIM, 48000000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_memstk, MEMSTK, 19500000, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_im, IM, 0, 0);
> -static DEFINE_PXA2_CKEN(pxa27x_memc, MEMC, 0, 0);
> -
> -static DEFINE_CK(pxa27x_lcd, LCD, &clk_pxa27x_lcd_ops);
> -static DEFINE_CK(pxa27x_camera, CAMERA, &clk_pxa27x_lcd_ops);
> -static DEFINE_CLK(pxa27x_mem, &clk_pxa27x_mem_ops, 0, 0);
> -
> -static struct clk_lookup pxa27x_clkregs[] = {
> -       INIT_CLKREG(&clk_pxa27x_lcd, "pxa2xx-fb", NULL),
> -       INIT_CLKREG(&clk_pxa27x_camera, "pxa27x-camera.0", NULL),
> -       INIT_CLKREG(&clk_pxa27x_ffuart, "pxa2xx-uart.0", NULL),
> -       INIT_CLKREG(&clk_pxa27x_btuart, "pxa2xx-uart.1", NULL),
> -       INIT_CLKREG(&clk_pxa27x_stuart, "pxa2xx-uart.2", NULL),
> -       INIT_CLKREG(&clk_pxa27x_i2s, "pxa2xx-i2s", NULL),
> -       INIT_CLKREG(&clk_pxa27x_i2c, "pxa2xx-i2c.0", NULL),
> -       INIT_CLKREG(&clk_pxa27x_usb, "pxa27x-udc", NULL),
> -       INIT_CLKREG(&clk_pxa27x_mmc, "pxa2xx-mci.0", NULL),
> -       INIT_CLKREG(&clk_pxa27x_stuart, "pxa2xx-ir", "UARTCLK"),
> -       INIT_CLKREG(&clk_pxa27x_ficp, "pxa2xx-ir", "FICPCLK"),
> -       INIT_CLKREG(&clk_pxa27x_usbhost, "pxa27x-ohci", NULL),
> -       INIT_CLKREG(&clk_pxa27x_pwri2c, "pxa2xx-i2c.1", NULL),
> -       INIT_CLKREG(&clk_pxa27x_keypad, "pxa27x-keypad", NULL),
> -       INIT_CLKREG(&clk_pxa27x_ssp1, "pxa27x-ssp.0", NULL),
> -       INIT_CLKREG(&clk_pxa27x_ssp2, "pxa27x-ssp.1", NULL),
> -       INIT_CLKREG(&clk_pxa27x_ssp3, "pxa27x-ssp.2", NULL),
> -       INIT_CLKREG(&clk_pxa27x_pwm0, "pxa27x-pwm.0", NULL),
> -       INIT_CLKREG(&clk_pxa27x_pwm1, "pxa27x-pwm.1", NULL),
> -       INIT_CLKREG(&clk_pxa27x_ac97, NULL, "AC97CLK"),
> -       INIT_CLKREG(&clk_pxa27x_ac97conf, NULL, "AC97CONFCLK"),
> -       INIT_CLKREG(&clk_pxa27x_msl, NULL, "MSLCLK"),
> -       INIT_CLKREG(&clk_pxa27x_usim, NULL, "USIMCLK"),
> -       INIT_CLKREG(&clk_pxa27x_memstk, NULL, "MSTKCLK"),
> -       INIT_CLKREG(&clk_pxa27x_im, NULL, "IMCLK"),
> -       INIT_CLKREG(&clk_pxa27x_memc, NULL, "MEMCLK"),
> -       INIT_CLKREG(&clk_pxa27x_mem, "pxa2xx-pcmcia", NULL),
> -       INIT_CLKREG(&clk_dummy, "pxa27x-gpio", NULL),
> -       INIT_CLKREG(&clk_dummy, "sa1100-rtc", NULL),
> -};
> -
>  #ifdef CONFIG_PM
>  
>  #define SAVE(x)                sleep_save[SLEEP_SAVE_##x] = x
> @@ -466,8 +299,6 @@ static int __init pxa27x_init(void)
>  
>                 reset_status = RCSR;
>  
> -               clkdev_add_table(pxa27x_clkregs, ARRAY_SIZE(pxa27x_clkregs));
> -
>                 if ((ret = pxa_init_dma(IRQ_DMA, 32)))
>                         return ret;
>  
> @@ -475,7 +306,6 @@ static int __init pxa27x_init(void)
>  
>                 register_syscore_ops(&pxa_irq_syscore_ops);
>                 register_syscore_ops(&pxa2xx_mfp_syscore_ops);
> -               register_syscore_ops(&pxa2xx_clock_syscore_ops);
>  
>                 pxa_register_device(&pxa27x_device_gpio, &pxa27x_gpio_info);
>                 ret = platform_add_devices(devices, ARRAY_SIZE(devices));
> -- 
> 2.1.0
> 
