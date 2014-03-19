Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277AbaCSOUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:20:49 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:34110 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965263AbaCSOUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:20:44 -0400
Date: Wed, 19 Mar 2014 15:20:30 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-leds@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 12/16] avr32: favr-32: use generic pwm_bl driver
Message-ID: <20140319142029.GD20872@samfundet.no>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395234209-15546-13-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395234209-15546-13-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 19 Mar 2014 14:03:25 +0100 or thereabout, Alexandre Belloni wrote:
> Switch to the generic pwm_bl driver instead of atmel-pwm-bl.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

I do not have this board either.

> ---
>  arch/avr32/boards/favr-32/setup.c    | 49 +++++++++++++++++++++++-------------
>  arch/avr32/configs/favr-32_defconfig |  6 ++---
>  2 files changed, 34 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/avr32/boards/favr-32/setup.c b/arch/avr32/boards/favr-32/setup.c
> index 1f121497b517..391f026705a5 100644
> --- a/arch/avr32/boards/favr-32/setup.c
> +++ b/arch/avr32/boards/favr-32/setup.c
> @@ -18,7 +18,10 @@
>  #include <linux/gpio.h>
>  #include <linux/leds.h>
>  #include <linux/atmel-mci.h>
> -#include <linux/atmel-pwm-bl.h>
> +#include <linux/pwm.h>
> +#include <linux/pwm_backlight.h>
> +#include <linux/regulator/fixed.h>
> +#include <linux/regulator/machine.h>
>  #include <linux/spi/spi.h>
>  #include <linux/spi/ads7846.h>
>  
> @@ -33,6 +36,8 @@
>  #include <mach/board.h>
>  #include <mach/portmux.h>
>  
> +#define PWM_BL_CH 2
> +
>  /* Oscillator frequencies. These are board-specific */
>  unsigned long at32_board_osc_rates[3] = {
>  	[0] = 32768,	/* 32.768 kHz on RTC osc */
> @@ -227,29 +232,37 @@ void __init favr32_setup_leds(void)
>  	platform_device_register(&favr32_led_dev);
>  }
>  
> -static struct atmel_pwm_bl_platform_data atmel_pwm_bl_pdata = {
> -	.pwm_channel		= 2,
> -	.pwm_frequency		= 200000,
> -	.pwm_compare_max	= 345,
> -	.pwm_duty_max		= 345,
> -	.pwm_duty_min		= 90,
> -	.pwm_active_low		= 1,
> -	.gpio_on		= GPIO_PIN_PA(28),
> -	.on_active_low		= 0,
> +static struct pwm_lookup pwm_lookup[] = {
> +	PWM_LOOKUP("at91sam9rl-pwm", PWM_BL_CH, "pwm-backlight.0", NULL),
>  };
>  
> -static struct platform_device atmel_pwm_bl_dev = {
> -	.name		= "atmel-pwm-bl",
> -	.id		= 0,
> -	.dev		= {
> -		.platform_data = &atmel_pwm_bl_pdata,
> +static struct regulator_consumer_supply fixed_power_consumers[] = {
> +	REGULATOR_SUPPLY("power", "pwm-backlight.0"),
> +};
> +
> +static struct platform_pwm_backlight_data pwm_bl_data = {
> +	.enable_gpio		= GPIO_PIN_PA(28),
> +	.pwm_period_ns		= 5000,
> +	.max_brightness		= 255,
> +	.dft_brightness		= 255,
> +	.lth_brightness		= 50,
> +	.pwm_active_low		= true,
> +};
> +
> +static struct platform_device pwm_bl_device = {
> +	.name = "pwm-backlight",
> +	.dev = {
> +		.platform_data = &pwm_bl_data,
>  	},
>  };
>  
>  static void __init favr32_setup_atmel_pwm_bl(void)
>  {
> -	platform_device_register(&atmel_pwm_bl_dev);
> -	at32_select_gpio(atmel_pwm_bl_pdata.gpio_on, 0);
> +	pwm_add_table(pwm_lookup, ARRAY_SIZE(pwm_lookup));
> +	regulator_register_always_on(0, "fixed", fixed_power_consumers,
> +				    ARRAY_SIZE(fixed_power_consumers), 3300000);
> +	platform_device_register(&pwm_bl_device);
> +	at32_select_gpio(pwm_bl_data.enable_gpio, 0);
>  }
>  
>  void __init setup_board(void)
> @@ -339,7 +352,7 @@ static int __init favr32_init(void)
>  
>  	set_abdac_rate(at32_add_device_abdac(0, &abdac0_data));
>  
> -	at32_add_device_pwm(1 << atmel_pwm_bl_pdata.pwm_channel);
> +	at32_add_device_pwm(1 << PWM_BL_CH);
>  	at32_add_device_spi(1, spi1_board_info, ARRAY_SIZE(spi1_board_info));
>  	at32_add_device_mci(0, &mci0_data);
>  	at32_add_device_usba(0, NULL);
> diff --git a/arch/avr32/configs/favr-32_defconfig b/arch/avr32/configs/favr-32_defconfig
> index 07bed3f7eb5e..b3eb67dc05ac 100644
> --- a/arch/avr32/configs/favr-32_defconfig
> +++ b/arch/avr32/configs/favr-32_defconfig
> @@ -67,7 +67,6 @@ CONFIG_MTD_PHYSMAP=y
>  CONFIG_BLK_DEV_LOOP=m
>  CONFIG_BLK_DEV_NBD=m
>  CONFIG_BLK_DEV_RAM=m
> -CONFIG_ATMEL_PWM=m
>  CONFIG_ATMEL_TCLIB=y
>  CONFIG_ATMEL_SSC=m
>  CONFIG_NETDEVICES=y
> @@ -108,7 +107,7 @@ CONFIG_FB=y
>  CONFIG_FB_ATMEL=y
>  CONFIG_BACKLIGHT_LCD_SUPPORT=y
>  # CONFIG_LCD_CLASS_DEVICE is not set
> -CONFIG_BACKLIGHT_ATMEL_PWM=m
> +CONFIG_BACKLIGHT_PWM=m
>  CONFIG_SOUND=m
>  CONFIG_SOUND_PRIME=m
>  # CONFIG_HID_SUPPORT is not set
> @@ -123,7 +122,6 @@ CONFIG_MMC=y
>  CONFIG_MMC_ATMELMCI=y
>  CONFIG_NEW_LEDS=y
>  CONFIG_LEDS_CLASS=y
> -CONFIG_LEDS_ATMEL_PWM=m
>  CONFIG_LEDS_GPIO=y
>  CONFIG_LEDS_TRIGGERS=y
>  CONFIG_LEDS_TRIGGER_TIMER=y
> @@ -132,6 +130,8 @@ CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
>  CONFIG_RTC_CLASS=y
>  CONFIG_RTC_DRV_AT32AP700X=y
>  CONFIG_DMADEVICES=y
> +CONFIG_PWM=y
> +CONFIG_PWM_ATMEL=y
>  CONFIG_EXT2_FS=y
>  CONFIG_EXT3_FS=y
>  # CONFIG_EXT3_FS_XATTR is not set
-- 
mvh
Hans-Christian Egtvedt
