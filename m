Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaCEJuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:50:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39956 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbaCEJuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:50:17 -0500
Message-ID: <5316FFCE.1060603@ti.com>
Date: Wed, 5 Mar 2014 12:43:26 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>, <linux-kernel@vger.kernel.org>
CC: <linux-gpio@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] gpio: davinci: fix gpio selection for OF
References: <5315ED51.1000006@ti.com> <1393970762-5346-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1393970762-5346-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 12:06 AM, Alexander Holler wrote:
> The driver missed an of_xlate function to translate gpio numbers
> as found in the DT to the correct chip and number.
>
> While there I've set #gpio_cells to a fixed value of 2.
>
> I've used gpio-pxa.c as template for those changes and tested my changes
> successfully on a da850 board using entries for gpio-leds in a DT. So I didn't
> reinvent the wheel but just copied and tested stuff.
>
> Thanks to Grygorii Strashko for the hint of the existing code in gpio-pxa.
>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>   drivers/gpio/gpio-davinci.c | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
>
> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index 7629b4f..79f45c4 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
> @@ -44,6 +44,9 @@ struct davinci_gpio_regs {
>
>   static void __iomem *gpio_base;
>
> +static struct davinci_gpio_controller *davinci_gpio_chips;
> +static int davinci_last_gpio;
> +
>   static struct davinci_gpio_regs __iomem *gpio2regs(unsigned gpio)
>   {
>   	void __iomem *ptr;
> @@ -172,6 +175,24 @@ of_err:
>   	return NULL;
>   }
>
> +#ifdef CONFIG_OF_GPIO
> +static int davinci_gpio_of_xlate(struct gpio_chip *gc,
> +			     const struct of_phandle_args *gpiospec,
> +			     u32 *flags)
> +{
> +	if (gpiospec->args[0] > davinci_last_gpio)
> +		return -EINVAL;
> +
> +	if (gc != &davinci_gpio_chips[gpiospec->args[0] / 32].chip)
> +		return -EINVAL;
> +
> +	if (flags)
> +		*flags = gpiospec->args[1];

Just one question here - Could we use gpio_chip-dev and hence, drop
static variables (davinci_gpio_chips, davinci_last_gpio)?

The Davinci device holds davinci_gpio_platform_data
in dev->platform_data and pointer on davinci_gpio_controller array
in dev->p->driver_data.

And looks like, dev_get_platdata(gc->dev) and
dev_get_drvdata(gc->dev) can be used here.

> +
> +	return gpiospec->args[0] % 32;
> +}
> +#endif
> +
>   static int davinci_gpio_probe(struct platform_device *pdev)
>   {
>   	int i, base;
> @@ -236,6 +257,8 @@ static int davinci_gpio_probe(struct platform_device *pdev)
>   			chips[i].chip.ngpio = 32;
>

add here	chips[i].chip.dev = dev;

>   #ifdef CONFIG_OF_GPIO
> +		chips[i].chip.of_gpio_n_cells = 2;
> +		chips[i].chip.of_xlate = davinci_gpio_of_xlate;
>   		chips[i].chip.of_node = dev->of_node;
>   #endif
>   		spin_lock_init(&chips[i].lock);
> @@ -251,6 +274,10 @@ static int davinci_gpio_probe(struct platform_device *pdev)
>
>   	platform_set_drvdata(pdev, chips);
>   	davinci_gpio_irq_setup(pdev);
> +
> +	davinci_gpio_chips = chips;
> +	davinci_last_gpio = ngpio;
> +
>   	return 0;
>   }

regards,
-grygorii


