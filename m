Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaLQHe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 02:34:26 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:55630 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaLQHeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 02:34:25 -0500
MIME-Version: 1.0
In-Reply-To: <1418226977-17128-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1418226977-17128-1-git-send-email-ricardo.ribalda@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 17 Dec 2014 16:34:04 +0900
Message-ID: <CAAVeFuKp89U=tUwOSUYktdPamK2=HXqpnJxR7M=H0LSmSYqcDQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] gpio/xilinx: Convert the driver to platform device interface
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 12:56 AM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> This way we do not need to transverse the device tree manually and we
> support hot plugged devices.
>
> Also Implement remove callback so the driver can be unloaded
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>
> v4: Add missing module_exit
>
>  drivers/gpio/gpio-xilinx.c | 83 ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 66 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
> index e668ec4..c7ed92b 100644
> --- a/drivers/gpio/gpio-xilinx.c
> +++ b/drivers/gpio/gpio-xilinx.c
> @@ -44,12 +44,18 @@
>   * gpio_state: GPIO state shadow register
>   * gpio_dir: GPIO direction shadow register
>   * gpio_lock: Lock used for synchronization
> + * inited: True if the port has been inited
>   */
>  struct xgpio_instance {
>         struct of_mm_gpio_chip mmchip;
>         u32 gpio_state;
>         u32 gpio_dir;
>         spinlock_t gpio_lock;
> +       bool inited;
> +};
> +
> +struct xgpio {
> +       struct xgpio_instance port[2];
>  };
>
>  /**
> @@ -172,24 +178,56 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
>  }
>
>  /**
> + * xgpio_remove - Remove method for the GPIO device.
> + * @pdev: pointer to the platform device
> + *
> + * This function remove gpiochips and frees all the allocated resources.
> + */
> +static int xgpio_remove(struct platform_device *pdev)
> +{
> +       struct xgpio *xgpio = platform_get_drvdata(pdev);
> +       int i;
> +
> +       for (i = 0; i < 2; i++) {
> +               if (!xgpio->port[i].inited)
> +                       continue;
> +               gpiochip_remove(&xgpio->port[i].mmchip.gc);
> +
> +               if (i == 1)
> +                       xgpio->port[i].mmchip.regs -= XGPIO_CHANNEL_OFFSET;
> +
> +               iounmap(xgpio->port[i].mmchip.regs);

This should not be here. The mapping and call to gpiochip_add() are
performed by of_mm_gpiochip_add(). We should thus have a
of_mm_gpiochip_remove() function that undoes what _add did instead of
expected all users to do unmap themselves. Can you add a patch to your
series that adds this function?

Also I am not sure I understand why the unmapping is done only once.
Both chips are supposed to have been added (and thus mapped) at this
stage. Oh right I see, so this driver ends up mapping the same area
twice! Not only are you iomapping the same area twice, you are
unmapping it only once, and only if the chip is dual. This looks very
broken.

Couldn't you redesign the driver the following way: only add one chip
(since you have 1 DT node), with an extra member to track which GPIOs
belong to the second chip (in case it is dual), and change the other
functions to handle this.

> +               kfree(xgpio->port[i].mmchip.gc.label);
> +       }
> +
> +       return 0;
> +}
> +
> +/**
>   * xgpio_of_probe - Probe method for the GPIO device.
> - * @np: pointer to device tree node
> + * @pdev: pointer to the platform device
>   *
>   * This function probes the GPIO device in the device tree. It initializes the
>   * driver data structure. It returns 0, if the driver is bound to the GPIO
>   * device, or a negative value if there is an error.
>   */
> -static int xgpio_of_probe(struct device_node *np)
> +static int xgpio_probe(struct platform_device *pdev)
>  {
> +       struct xgpio *xgpio;
>         struct xgpio_instance *chip;
>         int status = 0;
> +       struct device_node *np = pdev->dev.of_node;
>         const u32 *tree_info;
>         u32 ngpio;
>
> -       chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> -       if (!chip)
> +       xgpio = devm_kzalloc(&pdev->dev, sizeof(*xgpio), GFP_KERNEL);
> +       if (!xgpio)
>                 return -ENOMEM;
>
> +       platform_set_drvdata(pdev, xgpio);
> +
> +       chip = &xgpio->port[0];
> +
>         /* Update GPIO state shadow register with default value */
>         of_property_read_u32(np, "xlnx,dout-default", &chip->gpio_state);
>
> @@ -209,6 +247,7 @@ static int xgpio_of_probe(struct device_node *np)
>
>         spin_lock_init(&chip->gpio_lock);
>
> +       chip->mmchip.gc.dev = &pdev->dev;
>         chip->mmchip.gc.direction_input = xgpio_dir_in;
>         chip->mmchip.gc.direction_output = xgpio_dir_out;
>         chip->mmchip.gc.get = xgpio_get;
> @@ -219,20 +258,18 @@ static int xgpio_of_probe(struct device_node *np)
>         /* Call the OF gpio helper to setup and register the GPIO device */
>         status = of_mm_gpiochip_add(np, &chip->mmchip);
>         if (status) {
> -               kfree(chip);
>                 pr_err("%s: error in probe function with status %d\n",
>                        np->full_name, status);
>                 return status;
>         }
> +       chip->inited = true;
>
>         pr_info("XGpio: %s: registered, base is %d\n", np->full_name,
>                                                         chip->mmchip.gc.base);
>
>         tree_info = of_get_property(np, "xlnx,is-dual", NULL);
>         if (tree_info && be32_to_cpup(tree_info)) {
> -               chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> -               if (!chip)
> -                       return -ENOMEM;
> +               chip = &xgpio->port[1];
>
>                 /* Update GPIO state shadow register with default value */
>                 of_property_read_u32(np, "xlnx,dout-default-2",
> @@ -254,6 +291,7 @@ static int xgpio_of_probe(struct device_node *np)
>
>                 spin_lock_init(&chip->gpio_lock);
>
> +               chip->mmchip.gc.dev = &pdev->dev;
>                 chip->mmchip.gc.direction_input = xgpio_dir_in;
>                 chip->mmchip.gc.direction_output = xgpio_dir_out;
>                 chip->mmchip.gc.get = xgpio_get;
> @@ -264,7 +302,7 @@ static int xgpio_of_probe(struct device_node *np)
>                 /* Call the OF gpio helper to setup and register the GPIO dev */
>                 status = of_mm_gpiochip_add(np, &chip->mmchip);
>                 if (status) {
> -                       kfree(chip);
> +                       xgpio_remove(pdev);
>                         pr_err("%s: error in probe function with status %d\n",
>                         np->full_name, status);
>                         return status;
> @@ -272,6 +310,7 @@ static int xgpio_of_probe(struct device_node *np)
>
>                 /* Add dual channel offset */
>                 chip->mmchip.regs += XGPIO_CHANNEL_OFFSET;
> +               chip->inited = true;

The DT binding also suggests this should be one single chip. There is
a lot of redundant code that you could suppress if you follow the
design I suggest above.
