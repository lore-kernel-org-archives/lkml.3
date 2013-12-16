Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab3LPH3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 02:29:24 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:47783 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3LPH3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 02:29:21 -0500
MIME-Version: 1.0
In-Reply-To: <1386871973-26762-3-git-send-email-grygorii.strashko@ti.com>
References: <1386871973-26762-1-git-send-email-grygorii.strashko@ti.com> <1386871973-26762-3-git-send-email-grygorii.strashko@ti.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 16 Dec 2013 16:29:00 +0900
Message-ID: <CAAVeFuJSe_BZ+cr8ZVz-etAzsUbe_taS+0EqM+pXhKhTdyuWiQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: davinci: reuse for Keystone SoC
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Sekhar Nori <nsekhar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, prabhakar.csengg@gmail.com,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 3:12 AM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> The similar GPIO HW block is used by keystone SoCs as
> in Davinci SoCs.
> Hence, reuse Davinci GPIO driver for Keystone taking into
> account that Keystone contains ARM GIC IRQ controller which
> is implemented using IRQ Chip.
>
> Documentation:
>         http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf
>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Sekhar Nori <nsekhar@ti.com>
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> CC: devicetree@vger.kernel.org
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  .../devicetree/bindings/gpio/gpio-davinci.txt      |    4 +-
>  drivers/gpio/gpio-davinci.c                        |   49 +++++++++++++++-----
>  2 files changed, 40 insertions(+), 13 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> index a2e839d..4ce9862 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> @@ -1,7 +1,7 @@
> -Davinci GPIO controller bindings
> +Davinci/Keystone GPIO controller bindings
>
>  Required Properties:
> -- compatible: should be "ti,dm6441-gpio"
> +- compatible: should be "ti,dm6441-gpio", "ti,keystone-gpio"
>
>  - reg: Physical base address of the controller and the size of memory mapped
>         registers.
> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index 73f65ca..3e44e0c 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
> @@ -413,6 +413,27 @@ static const struct irq_domain_ops davinci_gpio_irq_ops = {
>         .xlate = irq_domain_xlate_onetwocell,
>  };
>
> +static struct irq_chip *davinci_gpio_get_irq_chip(unsigned int irq)
> +{
> +       static struct irq_chip_type gpio_unbanked;
> +
> +       gpio_unbanked = *container_of(irq_get_chip(irq),
> +                                     struct irq_chip_type, chip);
> +
> +       return &gpio_unbanked.chip;
> +};
> +
> +static struct irq_chip *keystone_gpio_get_irq_chip(unsigned int irq)
> +{
> +       static struct irq_chip gpio_unbanked;
> +
> +       gpio_unbanked = *irq_get_chip(irq);
> +       pr_err("keystone_gpio_get_irq_chip\n");

Do you intend this pr_err() to remain here?

> +       return &gpio_unbanked;
> +};
> +
> +static const struct of_device_id davinci_gpio_ids[];
> +
>  /*
>   * NOTE:  for suspend/resume, probably best to make a platform_device with
>   * suspend_late/resume_resume calls hooking into results of the set_wake()
> @@ -433,6 +454,15 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>         struct davinci_gpio_platform_data *pdata = dev->platform_data;
>         struct davinci_gpio_regs __iomem *g;
>         struct irq_domain       *irq_domain = NULL;
> +       const struct of_device_id *match;
> +       struct irq_chip *irq_chip;
> +       struct irq_chip *(*gpio_get_irq_chip)(unsigned int irq);
> +
> +       gpio_get_irq_chip = davinci_gpio_get_irq_chip;
> +       match = of_match_device(of_match_ptr(davinci_gpio_ids),
> +                               dev);
> +       if (match)
> +               gpio_get_irq_chip = match->data;
>
>         ngpio = pdata->ngpio;
>         res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> @@ -442,7 +472,6 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>         }
>
>         bank_irq = res->start;
> -
>         if (!bank_irq) {
>                 dev_err(dev, "Invalid IRQ resource\n");
>                 return -ENODEV;
> @@ -484,25 +513,22 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>         }
>
>         /*
> -        * AINTC can handle direct/unbanked IRQs for GPIOs, with the GPIO
> +        * INTC can handle direct/unbanked IRQs for GPIOs, with the GPIO
>          * controller only handling trigger modes.  We currently assume no
>          * IRQ mux conflicts; gpio_irq_type_unbanked() is only for GPIOs.
>          */
>         if (pdata->gpio_unbanked) {
> -               static struct irq_chip_type gpio_unbanked;
> -
>                 /* pass "bank 0" GPIO IRQs to AINTC */
>                 chips[0].chip.to_irq = gpio_to_irq_unbanked;
>                 chips[0].gpio_irq = bank_irq;
>                 chips[0].gpio_unbanked = pdata->gpio_unbanked;
>                 binten = BIT(0);
>
> -               /* AINTC handles mask/unmask; GPIO handles triggering */
> +               /* INTC handles mask/unmask; GPIO handles triggering */
>                 irq = bank_irq;
> -               gpio_unbanked = *container_of(irq_get_chip(irq),
> -                                             struct irq_chip_type, chip);
> -               gpio_unbanked.chip.name = "GPIO-AINTC";
> -               gpio_unbanked.chip.irq_set_type = gpio_irq_type_unbanked;
> +               irq_chip = gpio_get_irq_chip(irq);
> +               irq_chip->name = "GPIO-AINTC";

According to the other renamings I see in this file, shouldn't the
string also be changed to "GPIO-INTC"?
