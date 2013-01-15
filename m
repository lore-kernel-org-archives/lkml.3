Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab3AONTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:19:08 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:57056 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3AONTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:19:06 -0500
Message-ID: <50F5573D.4060007@atmel.com>
Date: Tue, 15 Jan 2013 14:18:53 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>, <plagnioj@jcrosoft.com>
CC: <gregkh@linuxfoundation.org>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <w.sang@pengutronix.de>,
        <jbe@pengutronix.de>, <highguy@gmail.com>,
        <broonie@opensource.wolfsonmicro.com>, <daniel-gl@gmx.net>,
        <rmallon@gmail.com>, <sr@denx.de>, <wg@grandegger.com>,
        <tru@work-microwave.de>, <mark.rutland@arm.com>
Subject: Re: [PATCH RESEND 6/6 v13] gpio: Add block gpio to several gpio drivers
References: <1358250716-21986-1-git-send-email-stigge@antcom.de> <1358250716-21986-7-git-send-email-stigge@antcom.de>
In-Reply-To: <1358250716-21986-7-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 15/01/2013 12:51, Roland Stigge a écrit :
> This patch adds block GPIO support to several gpio drivers.
>
> This implements block GPIO only for some selected drivers since block GPIO is
> an optional feature which may not be suitable for every GPIO hardware. (With
> automatic fallback to the single GPIO functions if not available in a driver.)
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>
>
> ---
>   drivers/gpio/Kconfig              |    2
>   drivers/gpio/gpio-em.c            |   23 ++++++++++
>   drivers/gpio/gpio-ge.c            |   29 +++++++++++++
>   drivers/gpio/gpio-generic.c       |   56 +++++++++++++++++++++++++
>   drivers/gpio/gpio-ks8695.c        |   34 +++++++++++++++
>   drivers/gpio/gpio-lpc32xx.c       |   82 ++++++++++++++++++++++++++++++++++++++
>   drivers/gpio/gpio-max730x.c       |   61 ++++++++++++++++++++++++++++
>   drivers/gpio/gpio-max732x.c       |   59 +++++++++++++++++++++++++++
>   drivers/gpio/gpio-mc33880.c       |   16 +++++++
>   drivers/gpio/gpio-ml-ioh.c        |   27 ++++++++++++
>   drivers/gpio/gpio-mm-lantiq.c     |   22 ++++++++++
>   drivers/gpio/gpio-mpc5200.c       |   64 +++++++++++++++++++++++++++++
>   drivers/gpio/gpio-mpc8xxx.c       |   41 +++++++++++++++++++
>   drivers/gpio/gpio-pca953x.c       |   64 +++++++++++++++++++++++++++++
>   drivers/gpio/gpio-pcf857x.c       |   24 +++++++++++
>   drivers/gpio/gpio-pch.c           |   27 ++++++++++++
>   drivers/gpio/gpio-pl061.c         |   17 +++++++
>   drivers/gpio/gpio-sa1100.c        |   20 +++++++++
>   drivers/gpio/gpio-samsung.c       |   31 ++++++++++++++
>   drivers/gpio/gpio-twl6040.c       |   32 ++++++++++++++
>   drivers/gpio/gpio-ucb1400.c       |   23 ++++++++++
>   drivers/gpio/gpio-vt8500.c        |   24 +++++++++++
>   drivers/gpio/gpio-xilinx.c        |   44 ++++++++++++++++++++
>   drivers/pinctrl/pinctrl-at91.c    |   29 +++++++++++++

I do not want to delay the process of inclusion for this patch series. 
But I have a little question on AT91 driver modification...

>   drivers/pinctrl/pinctrl-nomadik.c |   36 ++++++++++++++++
>   25 files changed, 887 insertions(+)

[..]

> --- linux-2.6.orig/drivers/pinctrl/pinctrl-at91.c
> +++ linux-2.6/drivers/pinctrl/pinctrl-at91.c
> @@ -49,6 +49,7 @@ struct at91_gpio_chip {
>   	struct clk		*clock;		/* associated clock */
>   	struct irq_domain	*domain;	/* associated irq domain */
>   	struct at91_pinctrl_mux_ops *ops;	/* ops */
> +	unsigned long		mask_cache;	/* cached mask for block gpio */
>   };
>
>   #define to_at91_gpio_chip(c) container_of(c, struct at91_gpio_chip, chip)
> @@ -1125,6 +1126,32 @@ static void at91_gpio_set(struct gpio_ch
>   	writel_relaxed(mask, pio + (val ? PIO_SODR : PIO_CODR));
>   }
>
> +static unsigned long at91_gpio_get_block(struct gpio_chip *chip,
> +					 unsigned long mask)
> +{
> +	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> +	void __iomem *pio = at91_gpio->regbase;
> +	u32 pdsr;
> +
> +	pdsr = __raw_readl(pio + PIO_PDSR);

Maybe you should use readl_relaxed() here as it is used in the 
at91_gpio_[get|set]() functions.


> +	return pdsr & mask;
> +}
> +
> +static void at91_gpio_set_block(struct gpio_chip *chip, unsigned long mask,
> +				unsigned long val)
> +{
> +	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> +	void __iomem *pio = at91_gpio->regbase;
> +
> +	/* Do synchronous data output with a single write access */
> +	if (mask != at91_gpio->mask_cache) {
> +		at91_gpio->mask_cache = mask;
> +		__raw_writel(~mask, pio + PIO_OWDR);
> +		__raw_writel(mask, pio + PIO_OWER);
> +	}
> +	__raw_writel(val, pio + PIO_ODSR);

Ditto.

> +}
> +
>   static int at91_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
>   				int val)
>   {
> @@ -1435,8 +1462,10 @@ static struct gpio_chip at91_gpio_templa
>   	.free			= at91_gpio_free,
>   	.direction_input	= at91_gpio_direction_input,
>   	.get			= at91_gpio_get,
> +	.get_block		= at91_gpio_get_block,
>   	.direction_output	= at91_gpio_direction_output,
>   	.set			= at91_gpio_set,
> +	.set_block		= at91_gpio_set_block,
>   	.to_irq			= at91_gpio_to_irq,
>   	.dbg_show		= at91_gpio_dbg_show,
>   	.can_sleep		= 0,
> --- linux-2.6.orig/drivers/pinctrl/pinctrl-nomadik.c
> +++ linux-2.6/drivers/pinctrl/pinctrl-nomadik.c

[..]

Otherwise, seems ok to me ; for AT91 part:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Best regards,
-- 
Nicolas Ferre
