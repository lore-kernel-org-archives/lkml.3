Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbaEMHzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:55:45 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:34004 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbaEMHzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:55:44 -0400
MIME-Version: 1.0
In-Reply-To: <1399944102-9089-1-git-send-email-berthe.ab@gmail.com>
References: <1399944102-9089-1-git-send-email-berthe.ab@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 13 May 2014 16:55:23 +0900
Message-ID: <CAAVeFuLuP4V4+heh-cpMxQ66jMBkM5XX7YjqabEMGW=GjneqmQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: using devm functions for timberdale gpio memory
 allocation This eases memory allocation and provides appropriate logging
To: abdoulaye berthe <berthe.ab@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A welcome cleanup, but the subject line of your patch is waaay too
long. As a rule of thumb, try to limit it to 50 characters ([PATCH]
tag not included), with slight overlapping tolerated.

Also to better spot which driver is changed, please prefix it with
"gpio: timberdale: "

For this patch, "gpio: timberdale: use devm functions" looks good to me.

The rest of your subject line should be the actual commit message.

Thanks,
Alex.

On Tue, May 13, 2014 at 10:21 AM, abdoulaye berthe <berthe.ab@gmail.com> wrote:
> Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
> ---
>  drivers/gpio/gpio-timberdale.c | 47 ++++++++++++++----------------------------
>  1 file changed, 16 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/gpio/gpio-timberdale.c b/drivers/gpio/gpio-timberdale.c
> index f9a8fbd..efc7c12 100644
> --- a/drivers/gpio/gpio-timberdale.c
> +++ b/drivers/gpio/gpio-timberdale.c
> @@ -224,6 +224,7 @@ static struct irq_chip timbgpio_irqchip = {
>  static int timbgpio_probe(struct platform_device *pdev)
>  {
>         int err, i;
> +       struct device *dev = &pdev->dev;
>         struct gpio_chip *gc;
>         struct timbgpio *tgpio;
>         struct resource *iomem;
> @@ -231,35 +232,35 @@ static int timbgpio_probe(struct platform_device *pdev)
>         int irq = platform_get_irq(pdev, 0);
>
>         if (!pdata || pdata->nr_pins > 32) {
> -               err = -EINVAL;
> -               goto err_mem;
> +               dev_err(dev, "Invalid platform data\n");
> +               return -EINVAL;
>         }
>
>         iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         if (!iomem) {
> -               err = -EINVAL;
> -               goto err_mem;
> +               dev_err(dev, "Unable to get resource\n");
> +               return -EINVAL;
>         }
>
> -       tgpio = kzalloc(sizeof(*tgpio), GFP_KERNEL);
> +       tgpio = devm_kzalloc(dev, sizeof(struct timbgpio), GFP_KERNEL);
>         if (!tgpio) {
> -               err = -EINVAL;
> -               goto err_mem;
> +               dev_err(dev, "Memory alloc failed\n");
> +               return -EINVAL;
>         }
>         tgpio->irq_base = pdata->irq_base;
>
>         spin_lock_init(&tgpio->lock);
>
> -       if (!request_mem_region(iomem->start, resource_size(iomem),
> -               DRIVER_NAME)) {
> -               err = -EBUSY;
> -               goto err_request;
> +       if (!devm_request_mem_region(dev, iomem->start, resource_size(iomem),
> +                                    DRIVER_NAME)) {
> +               dev_err(dev, "Region already claimed\n");
> +               return -EBUSY;
>         }
>
> -       tgpio->membase = ioremap(iomem->start, resource_size(iomem));
> +       tgpio->membase = devm_ioremap(dev, iomem->start, resource_size(iomem));
>         if (!tgpio->membase) {
> -               err = -ENOMEM;
> -               goto err_ioremap;
> +               dev_err(dev, "Cannot ioremap\n");
> +               return -ENOMEM;
>         }
>
>         gc = &tgpio->gpio;
> @@ -279,7 +280,7 @@ static int timbgpio_probe(struct platform_device *pdev)
>
>         err = gpiochip_add(gc);
>         if (err)
> -               goto err_chipadd;
> +               return err;
>
>         platform_set_drvdata(pdev, tgpio);
>
> @@ -302,17 +303,6 @@ static int timbgpio_probe(struct platform_device *pdev)
>         irq_set_chained_handler(irq, timbgpio_irq);
>
>         return 0;
> -
> -err_chipadd:
> -       iounmap(tgpio->membase);
> -err_ioremap:
> -       release_mem_region(iomem->start, resource_size(iomem));
> -err_request:
> -       kfree(tgpio);
> -err_mem:
> -       printk(KERN_ERR DRIVER_NAME": Failed to register GPIOs: %d\n", err);
> -
> -       return err;
>  }
>
>  static int timbgpio_remove(struct platform_device *pdev)
> @@ -320,7 +310,6 @@ static int timbgpio_remove(struct platform_device *pdev)
>         int err;
>         struct timbgpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
>         struct timbgpio *tgpio = platform_get_drvdata(pdev);
> -       struct resource *iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         int irq = platform_get_irq(pdev, 0);
>
>         if (irq >= 0 && tgpio->irq_base > 0) {
> @@ -338,10 +327,6 @@ static int timbgpio_remove(struct platform_device *pdev)
>         if (err)
>                 printk(KERN_ERR DRIVER_NAME": failed to remove gpio_chip\n");
>
> -       iounmap(tgpio->membase);
> -       release_mem_region(iomem->start, resource_size(iomem));
> -       kfree(tgpio);
> -
>         return 0;
>  }
>
> --
> 1.8.3.2
>
