Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057AbaK1A20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 19:28:26 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36685 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750729AbaK1A2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 19:28:25 -0500
Date: Fri, 28 Nov 2014 01:28:22 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, Alexander Stein <alexanders83@web.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 00/11] ARM: at91: remove !DT support for at91rm9200
Message-ID: <20141128002822.GM4508@piout.net>
References: <cover.1417103399.git.nicolas.ferre@atmel.com>
 <3550407.q87bWB4Jdt@wuerfel>
 <20141127171243.GL4508@piout.net>
 <3935244.Dm2HkZj2Bg@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3935244.Dm2HkZj2Bg@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/11/2014 at 00:12:25 +0100, Arnd Bergmann wrote :
> On Thursday 27 November 2014 18:12:43 Alexandre Belloni wrote:
> > 
> > As discussed some weeks ago, I prepared patches to switch sama5d[3-4] to
> > multiplatform. We are still missing the SMC and matrix drivers to switch
> > sam9 and rm9200.
> 
> I just looked at the drivers because I got curious, and to see if
> there are still any low-hanging fruit, but I guess you already picked
> them all ;-)

Yeah, my main goal was to test multiplatform on sama5d3 and it was
actually quite easy. The worst still being rm9200 ;)

> 
> >  - sound/atmel/ac97c.c (that one is still not converted to DT anyway...)
> 
> This one seems fairly straightforward to do, including a DT binding,
> but the result is still ugly as it supports the at32 chips that
> do things very differently.
> 
> The patch below gets it to compile and should be enough as a replacement
> once a compatible string gets added.
> 

Actually, some work was done but we never saw an other version of the
series. Alexander, are you still interested? Else we can take the patch
below.

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/246679.html

> >  - drivers/watchdog/at91rm9200_wdt.c (WIP, will be converted properly to
> >    an MFD)
> 
> I think we discussed this one before. Remind me why we can't just convert
> it to use watchdog_register() for simplification and then move whatever
> remains into the arch/arm/mach-at91/at91rm9200_time.c file, or both
> into drivers/clocksource.
> 

Yeah, the new plan is to merge the watchdog with at91rm9200_time.c and
move it either to drivers/clocksource or make an mfd. I believe the
former would be easier.

> 	Arnd
> 
> 8<----
> ASoC: atmel/ac97c: remove platform_data dependency
> 
> As at91 gets changed to multiplatform, we can't use the mach/cpu.h
> header any more, but this is ok as it only gets used to check for
> cpu_is_at32ap7000(), which arch/avr32.
> 
> In order to make the driver work without platform_data, this also
> changes the reset gpio line handling so it can look up the gpio
> descriptor from DT. It is still missing a compatible string and
> a binding that describes the valid DT properties.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
> index b59427d5a697..4eec216b7f92 100644
> --- a/sound/atmel/ac97c.c
> +++ b/sound/atmel/ac97c.c
> @@ -34,10 +34,10 @@
>  #include <linux/platform_data/dma-dw.h>
>  #include <linux/dma/dw.h>
>  
> +#ifdef CONFIG_AVR32
>  #include <mach/cpu.h>
> -
> -#ifdef CONFIG_ARCH_AT91
> -#include <mach/hardware.h>
> +#else
> +#define cpu_is_at32ap7000() (0)
>  #endif
>  
>  #include "ac97c.h"
> @@ -78,7 +78,7 @@ struct atmel_ac97c {
>  	void __iomem			*regs;
>  	int				irq;
>  	int				opened;
> -	int				reset_pin;
> +	struct gpio_desc		*reset_pin;
>  };
>  
>  #define get_chip(card) ((struct atmel_ac97c *)(card)->private_data)
> @@ -890,11 +890,11 @@ static void atmel_ac97c_reset(struct atmel_ac97c *chip)
>  	ac97c_writel(chip, CAMR, 0);
>  	ac97c_writel(chip, COMR, 0);
>  
> -	if (gpio_is_valid(chip->reset_pin)) {
> -		gpio_set_value(chip->reset_pin, 0);
> +	if (chip->reset_pin) {
> +		gpiod_set_value(chip->reset_pin, 0);
>  		/* AC97 v2.2 specifications says minimum 1 us. */
>  		udelay(2);
> -		gpio_set_value(chip->reset_pin, 1);
> +		gpiod_set_value(chip->reset_pin, 1);
>  	} else {
>  		ac97c_writel(chip, MR, AC97C_MR_WRST | AC97C_MR_ENA);
>  		udelay(2);
> @@ -923,7 +923,7 @@ static int atmel_ac97c_probe(struct platform_device *pdev)
>  	}
>  
>  	pdata = pdev->dev.platform_data;
> -	if (!pdata) {
> +	if (cpu_is_at32ap7000() && !pdata) {
>  		dev_dbg(&pdev->dev, "no platform data\n");
>  		return -ENXIO;
>  	}
> @@ -980,16 +980,18 @@ static int atmel_ac97c_probe(struct platform_device *pdev)
>  		goto err_ioremap;
>  	}
>  
> -	if (gpio_is_valid(pdata->reset_pin)) {
> -		if (gpio_request(pdata->reset_pin, "reset_pin")) {
> +	if (pdata && gpio_is_valid(pdata->reset_pin)) {
> +		if (devm_gpio_request(&pdev->dev, pdata->reset_pin, "reset")) {
>  			dev_dbg(&pdev->dev, "reset pin not available\n");
> -			chip->reset_pin = -ENODEV;
> +			chip->reset_pin = NULL;
>  		} else {
>  			gpio_direction_output(pdata->reset_pin, 1);
> -			chip->reset_pin = pdata->reset_pin;
> +			chip->reset_pin = gpio_to_desc(pdata->reset_pin);
>  		}
>  	} else {
> -		chip->reset_pin = -EINVAL;
> +		chip->reset_pin = devm_gpiod_get(&pdev->dev, "reset", 0);
> +		if (IS_ERR(chip->reset_pin))
> +			chip->reset_pin = NULL;
>  	}
>  
>  	atmel_ac97c_reset(chip);
> @@ -1113,9 +1115,6 @@ err_dma:
>  		chip->dma.tx_chan = NULL;
>  	}
>  err_ac97_bus:
> -	if (gpio_is_valid(chip->reset_pin))
> -		gpio_free(chip->reset_pin);
> -
>  	iounmap(chip->regs);
>  err_ioremap:
>  	free_irq(irq, chip);
> @@ -1170,9 +1169,6 @@ static int atmel_ac97c_remove(struct platform_device *pdev)
>  	struct snd_card *card = platform_get_drvdata(pdev);
>  	struct atmel_ac97c *chip = get_chip(card);
>  
> -	if (gpio_is_valid(chip->reset_pin))
> -		gpio_free(chip->reset_pin);
> -
>  	ac97c_writel(chip, CAMR, 0);
>  	ac97c_writel(chip, COMR, 0);
>  	ac97c_writel(chip, MR,   0);
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
