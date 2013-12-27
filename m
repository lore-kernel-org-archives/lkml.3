Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3L0Kwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:52:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47766 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab3L0Kwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:52:50 -0500
Message-ID: <52BD6948.6010603@ti.com>
Date: Fri, 27 Dec 2013 13:49:28 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Rob Herring <rob.herring@calxeda.com>
CC: <prabhakar.csengg@gmail.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] gpio: davinci: reuse for Keystone SoC
References: <1387885284-8119-1-git-send-email-grygorii.strashko@ti.com> <1387885284-8119-3-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1387885284-8119-3-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 12/24/2013 01:41 PM, Grygorii Strashko wrote:
> The similar GPIO HW block is used by keystone SoCs as
> in Davinci SoCs.
> Hence, reuse Davinci GPIO driver for Keystone taking into
> account that Keystone contains ARM GIC IRQ controller which
> is implemented using IRQ Chip.
>
> Documentation:
> 	http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf
>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: devicetree@vger.kernel.org
>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>   .../devicetree/bindings/gpio/gpio-davinci.txt      |    4 +-
>   drivers/gpio/gpio-davinci.c                        |   48 ++++++++++++++++----
>   2 files changed, 42 insertions(+), 10 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> index a2e839d..4ce9862 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> @@ -1,7 +1,7 @@
> -Davinci GPIO controller bindings
> +Davinci/Keystone GPIO controller bindings
>
>   Required Properties:
> -- compatible: should be "ti,dm6441-gpio"
> +- compatible: should be "ti,dm6441-gpio", "ti,keystone-gpio"

Do you agree with this bindings changes?
They are very simple

>
>   - reg: Physical base address of the controller and the size of memory mapped
>          registers.
> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index 7629b4f..d0f135d 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
> @@ -37,6 +37,8 @@ struct davinci_gpio_regs {
>   	u32	intstat;
>   };
>
> +typedef struct irq_chip *(*gpio_get_irq_chip_cb_t)(unsigned int irq);
> +
>   #define BINTEN	0x8 /* GPIO Interrupt Per-Bank Enable Register */
>
>   #define chip2controller(chip)	\
> @@ -413,6 +415,26 @@ static const struct irq_domain_ops davinci_gpio_irq_ops = {
>   	.xlate = irq_domain_xlate_onetwocell,
>   };
>
> +static struct irq_chip *davinci_gpio_get_irq_chip(unsigned int irq)
> +{
> +	static struct irq_chip_type gpio_unbanked;
> +
> +	gpio_unbanked = *container_of(irq_get_chip(irq),
> +				      struct irq_chip_type, chip);
> +
> +	return &gpio_unbanked.chip;
> +};
> +
> +static struct irq_chip *keystone_gpio_get_irq_chip(unsigned int irq)
> +{
> +	static struct irq_chip gpio_unbanked;
> +
> +	gpio_unbanked = *irq_get_chip(irq);
> +	return &gpio_unbanked;
> +};
> +
> +static const struct of_device_id davinci_gpio_ids[];
> +
>   /*
>    * NOTE:  for suspend/resume, probably best to make a platform_device with
>    * suspend_late/resume_resume calls hooking into results of the set_wake()
> @@ -433,6 +455,18 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>   	struct davinci_gpio_platform_data *pdata = dev->platform_data;
>   	struct davinci_gpio_regs __iomem *g;
>   	struct irq_domain	*irq_domain = NULL;
> +	const struct of_device_id *match;
> +	struct irq_chip *irq_chip;
> +	gpio_get_irq_chip_cb_t gpio_get_irq_chip;
> +
> +	/*
> +	 * Use davinci_gpio_get_irq_chip by default to handle non DT cases
> +	 */
> +	gpio_get_irq_chip = davinci_gpio_get_irq_chip;
> +	match = of_match_device(of_match_ptr(davinci_gpio_ids),
> +				dev);
> +	if (match)
> +		gpio_get_irq_chip = (gpio_get_irq_chip_cb_t)match->data;
>
>   	ngpio = pdata->ngpio;
>   	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> @@ -489,8 +523,6 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>   	 * IRQ mux conflicts; gpio_irq_type_unbanked() is only for GPIOs.
>   	 */
>   	if (pdata->gpio_unbanked) {
> -		static struct irq_chip_type gpio_unbanked;
> -
>   		/* pass "bank 0" GPIO IRQs to AINTC */
>   		chips[0].chip.to_irq = gpio_to_irq_unbanked;
>   		chips[0].gpio_irq = bank_irq;
> @@ -499,10 +531,9 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>
>   		/* AINTC handles mask/unmask; GPIO handles triggering */
>   		irq = bank_irq;
> -		gpio_unbanked = *container_of(irq_get_chip(irq),
> -					      struct irq_chip_type, chip);
> -		gpio_unbanked.chip.name = "GPIO-AINTC";
> -		gpio_unbanked.chip.irq_set_type = gpio_irq_type_unbanked;
> +		irq_chip = gpio_get_irq_chip(irq);
> +		irq_chip->name = "GPIO-AINTC";
> +		irq_chip->irq_set_type = gpio_irq_type_unbanked;
>
>   		/* default trigger: both edges */
>   		g = gpio2regs(0);
> @@ -511,7 +542,7 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>
>   		/* set the direct IRQs up to use that irqchip */
>   		for (gpio = 0; gpio < pdata->gpio_unbanked; gpio++, irq++) {
> -			irq_set_chip(irq, &gpio_unbanked.chip);
> +			irq_set_chip(irq, irq_chip);
>   			irq_set_handler_data(irq, &chips[gpio / 32]);
>   			irq_set_status_flags(irq, IRQ_TYPE_EDGE_BOTH);
>   		}
> @@ -554,7 +585,8 @@ done:
>
>   #if IS_ENABLED(CONFIG_OF)
>   static const struct of_device_id davinci_gpio_ids[] = {
> -	{ .compatible = "ti,dm6441-gpio", },
> +	{ .compatible = "ti,keystone-gpio", keystone_gpio_get_irq_chip},
> +	{ .compatible = "ti,dm6441-gpio", davinci_gpio_get_irq_chip},
>   	{ /* sentinel */ },
>   };
>   MODULE_DEVICE_TABLE(of, davinci_gpio_ids);
>

