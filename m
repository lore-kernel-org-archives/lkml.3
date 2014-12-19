Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaLSOPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:15:12 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:51255 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaLSOPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:15:10 -0500
MIME-Version: 1.0
In-Reply-To: <1645416.VNQj8YWB7M@phil>
References: <1418830837-7422-1-git-send-email-stefan.hengelein@fau.de>
	<2864831.LEPnyFh3Il@phil>
	<CABv5NL_SLyY9-yookdTVdNXzCmUEqJ_QB6ofzw_q0H7Vcwbzfg@mail.gmail.com>
	<1645416.VNQj8YWB7M@phil>
Date: Fri, 19 Dec 2014 15:15:09 +0100
X-Google-Sender-Auth: P07zq8P7M5bqTcivNVStmI0cTEw
Message-ID: <CABv5NL_GisHMZVK03M3j_cGMVcoZ7L+Czt5TP2Sp4abBeUxuCQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: SAMSUNG: remove dead #elif CONFIG_S3C24XX_DMAC
From: Stefan Hengelein <stefan.hengelein@fau.de>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        kgene@kernel.org, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From what i can see, the block was already dead when it was introduced.
d2193ce2 changed the "if ARCH_S3C64XX" into the Kconfig file itself,
before it was around the source statement in arch/arm/Kconfig

if there are really just downstream users that explicitly have to add
a statement to select S3C64XX_DEV_SPI0 and therefore add the
possibility to enable the block i want to remove, i'd argue that these
downstream users could also add the block itself. I'm not sure how
intuitive it might be for downstream users to add a select in Kconfig
to enable their machine to communicate with a device, but i'm also not
familiar with the hardware we're talking about.

However, i'd prefer to have a consistent upstream state and leave
these problems to downstream users, but that's for the Maintainer to
decide :)



2014-12-18 20:03 GMT+01:00 Heiko Stübner <heiko@sntech.de>:
> Hi Stefan,
>
> Am Donnerstag, 18. Dezember 2014, 14:43:01 schrieb Stefan Hengelein:
>> So you actually tested the code I removed in the patch? can you
>> provide a configuration that compiles that piece of code?
>
> Yep, one of my boards (Asus eeeReader DR-900) was actually able to transmit
> stuff via the libertas spi wifi driver using the s3c64xx-spi driver.
>
> The smdk2416 is currently the only board for the s3c2416 in the kernel. I don't
> know if it had actual spi devices connected, but if it had, a suitable diff would
> look something like the diff below. Of course hooking up spi devices would
> work the same in any out-of-tree board for the supported socs.
>
>
> For people reading along, the s3c24xx spi distribution is as follows:
> s3c2410, s3c2412, s3c2440: (I think) two s3c24xx-spi
> s3c2443: one s3c64xx-spi and one s3c24xx-spi
> s3c2416: one s3c64xx-spi
> s3c2450: two s3c64xx-spi
>
>
> Heiko
>
>
> ------------ 8< ------------
> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
> index 9eb2229..5210e5d 100644
> --- a/arch/arm/mach-s3c24xx/Kconfig
> +++ b/arch/arm/mach-s3c24xx/Kconfig
> @@ -419,6 +419,8 @@ config MACH_SMDK2416
>         select S3C_DEV_HSMMC1
>         select S3C_DEV_NAND
>         select S3C_DEV_USB_HOST
> +       select S3C64XX_DEV_SPI0
> +       select S3C2443_SETUP_SPI
>         help
>           Say Y here if you are using an SMDK2416
>
> diff --git a/arch/arm/mach-s3c24xx/mach-smdk2416.c b/arch/arm/mach-s3c24xx/mach-smdk2416.c
> index 86394f7..b6c6ff4 100644
> --- a/arch/arm/mach-s3c24xx/mach-smdk2416.c
> +++ b/arch/arm/mach-s3c24xx/mach-smdk2416.c
> @@ -52,6 +52,9 @@
>  #include <linux/platform_data/s3c-hsudc.h>
>  #include <plat/samsung-time.h>
>
> +#include <linux/spi/spi.h>
> +#include <linux/platform_data/spi-s3c64xx.h>
> +
>  #include <plat/fb.h>
>
>  #include "common.h"
> @@ -207,6 +210,26 @@ static struct s3c_sdhci_platdata smdk2416_hsmmc1_pdata __initdata = {
>         .cd_type                = S3C_SDHCI_CD_NONE,
>  };
>
> +struct s3c64xx_spi_csinfo libertas_cs_info = {
> +       .fb_delay = 0,
> +       .line = 128, /* gpio cs line */
> +};
> +
> +
> +static struct spi_board_info spi_board_info[] = {
> +    {
> +       .modalias               = "libertas_spi",
> +       .max_speed_hz           = 1200000,
> +       .bus_num                = 0,
> +       .irq                    = 12, /* some interrupt number */
> +       .chip_select            = 0,
> +       .mode                   = SPI_MODE_3,
> +       .controller_data        = &libertas_cs_info,
> +/*     .platform_data          = &foo1_pdata, */
> +    },
> +};
> +
> +
>  static struct platform_device *smdk2416_devices[] __initdata = {
>         &s3c_device_fb,
>         &s3c_device_wdt,
> @@ -216,6 +239,7 @@ static struct platform_device *smdk2416_devices[] __initdata = {
>         &s3c_device_hsmmc1,
>         &s3c_device_usb_hsudc,
>         &s3c2443_device_dma,
> +       &s3c64xx_device_spi0,
>  };
>
>  static void __init smdk2416_init_time(void)
> @@ -250,6 +274,9 @@ static void __init smdk2416_machine_init(void)
>         gpio_request(S3C2410_GPB(1), "Display Reset");
>         gpio_direction_output(S3C2410_GPB(1), 1);
>
> +       s3c64xx_spi0_set_platdata(NULL, 0, ARRAY_SIZE(spi_board_info));
> +       spi_register_board_info(spi_board_info, ARRAY_SIZE(spi_board_info));
> +
>         platform_add_devices(smdk2416_devices, ARRAY_SIZE(smdk2416_devices));
>         smdk_machine_init();
>  }
> diff --git a/arch/arm/mach-s3c24xx/setup-spi.c b/arch/arm/mach-s3c24xx/setup-spi.c
> index 3d47e02..d66c4e0 100644
> --- a/arch/arm/mach-s3c24xx/setup-spi.c
> +++ b/arch/arm/mach-s3c24xx/setup-spi.c
> @@ -16,6 +16,7 @@
>
>  #include <mach/hardware.h>
>  #include <mach/regs-gpio.h>
> +#include <mach/gpio-samsung.h>
>
>  #ifdef CONFIG_S3C64XX_DEV_SPI0
>  int s3c64xx_spi0_cfg_gpio(void)
>
