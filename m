Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3LVPyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 10:54:09 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59936 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab3LVPyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 10:54:06 -0500
Message-ID: <52B70AB8.6030503@ti.com>
Date: Sun, 22 Dec 2013 21:22:24 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
CC: Rob Herring <rob.herring@calxeda.com>, <prabhakar.csengg@gmail.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] gpio: davinci: don't create irq_domain in case
 of unbanked irqs
References: <1387361272-20861-1-git-send-email-grygorii.strashko@ti.com> <1387361272-20861-2-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1387361272-20861-2-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 December 2013 03:37 PM, Grygorii Strashko wrote:
> The system may crash if:
> - there are more then 1 bank

s/then/than

> - unbanked irqs are enabled
> - someone will call gpio_to_irq() for GPIO from bank2 or above
> 
> Hence, fix it by not creating irq_domain if unbanked irqs are enabled
> and correct gpio_to_irq_banked() to handle this properly.
> 
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> 
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/gpio/gpio-davinci.c |   34 +++++++++++++++++++---------------
>  1 file changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index 5d163c0..1b33806 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
> @@ -351,7 +351,10 @@ static int gpio_to_irq_banked(struct gpio_chip *chip, unsigned offset)
>  {
>  	struct davinci_gpio_controller *d = chip2controller(chip);
>  
> -	return irq_create_mapping(d->irq_domain, d->chip.base + offset);
> +	if (d->irq_domain)
> +		return irq_create_mapping(d->irq_domain, d->chip.base + offset);
> +	else
> +		return -ENXIO;
>  }
>  
>  static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
> @@ -429,7 +432,7 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>  	struct davinci_gpio_controller *chips = platform_get_drvdata(pdev);
>  	struct davinci_gpio_platform_data *pdata = dev->platform_data;
>  	struct davinci_gpio_regs __iomem *g;
> -	struct irq_domain	*irq_domain;
> +	struct irq_domain	*irq_domain = NULL;
>  
>  	ngpio = pdata->ngpio;
>  	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> @@ -453,18 +456,20 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>  	}
>  	clk_prepare_enable(clk);
>  
> -	irq = irq_alloc_descs(-1, 0, ngpio, 0);
> -	if (irq < 0) {
> -		dev_err(dev, "Couldn't allocate IRQ numbers\n");
> -		return irq;
> -	}
> +	if (!pdata->gpio_unbanked) {
> +		irq = irq_alloc_descs(-1, 0, ngpio, 0);
> +		if (irq < 0) {
> +			dev_err(dev, "Couldn't allocate IRQ numbers\n");
> +			return -ENODEV;

The code was correct before moving. Any objections to doing

			return irq;

instead?

Thanks,
Sekhar
