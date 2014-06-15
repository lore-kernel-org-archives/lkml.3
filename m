Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaFOWTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 18:19:50 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:58965 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaFOWTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 18:19:47 -0400
MIME-Version: 1.0
In-Reply-To: <1402305728-2155-1-git-send-email-linus.walleij@linaro.org>
References: <1402305728-2155-1-git-send-email-linus.walleij@linaro.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 16 Jun 2014 07:19:26 +0900
Message-ID: <CAAVeFuJmrqtcPqJ5q+jV6v1yS1mO_W_DUBKehMf9JaVSTF3cgg@mail.gmail.com>
Subject: Re: [PATCH] power: poweroff: gpio: convert to use descriptors
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 6:22 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> This switches the GPIO poweroff driver to use GPIO descriptors
> rather than numeral GPIOs. We get rid of the specific inversion
> handling as GPIO descriptors know if they are active low or
> high and can assert the line properly, so we do not need to
> check the flag OF_GPIO_ACTIVE_LOW returned from the old call
> of_get_gpio_flags() anymore.
>
> Also convert to use managed resources and use dev_* message
> printing while we're at it.
>
> Cc: Alexandre Courbot <acourbot@nvidia.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/power/reset/gpio-poweroff.c | 52 ++++++++++++++-----------------------
>  1 file changed, 19 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/power/reset/gpio-poweroff.c b/drivers/power/reset/gpio-poweroff.c
> index e290d48ddd99..41e1594589d5 100644
> --- a/drivers/power/reset/gpio-poweroff.c
> +++ b/drivers/power/reset/gpio-poweroff.c
> @@ -15,31 +15,29 @@
>  #include <linux/init.h>
>  #include <linux/delay.h>
>  #include <linux/platform_device.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/of_platform.h>
> -#include <linux/of_gpio.h>
>  #include <linux/module.h>
>
>  /*
>   * Hold configuration here, cannot be more than one instance of the driver
>   * since pm_power_off itself is global.
>   */
> -static int gpio_num = -1;
> -static int gpio_active_low;
> +static struct gpio_desc *reset_gpio;
>
>  static void gpio_poweroff_do_poweroff(void)
>  {
> -       BUG_ON(!gpio_is_valid(gpio_num));
> +       BUG_ON(!reset_gpio);
>
>         /* drive it active, also inactive->active edge */
> -       gpio_direction_output(gpio_num, !gpio_active_low);
> +       gpiod_direction_output(reset_gpio, 1);
>         mdelay(100);
>         /* drive inactive, also active->inactive edge */
> -       gpio_set_value(gpio_num, gpio_active_low);
> +       gpiod_set_value(reset_gpio, 0);
>         mdelay(100);
>
>         /* drive it active, also inactive->active edge */
> -       gpio_set_value(gpio_num, !gpio_active_low);
> +       gpiod_set_value(reset_gpio, 1);
>
>         /* give it some time */
>         mdelay(3000);
> @@ -49,54 +47,42 @@ static void gpio_poweroff_do_poweroff(void)
>
>  static int gpio_poweroff_probe(struct platform_device *pdev)
>  {
> -       enum of_gpio_flags flags;
>         bool input = false;
> -       int ret;
>
>         /* If a pm_power_off function has already been added, leave it alone */
>         if (pm_power_off != NULL) {
> -               pr_err("%s: pm_power_off function already registered",
> +               dev_err(&pdev->dev,
> +                       "%s: pm_power_off function already registered",
>                        __func__);
>                 return -EBUSY;
>         }
>
> -       gpio_num = of_get_gpio_flags(pdev->dev.of_node, 0, &flags);
> -       if (!gpio_is_valid(gpio_num))
> -               return gpio_num;
> -
> -       gpio_active_low = flags & OF_GPIO_ACTIVE_LOW;
> +       reset_gpio = devm_gpiod_get(&pdev->dev, NULL);
> +       if (!reset_gpio)
> +               return -ENODEV;

IIRC gpiod_get() can never return NULL and will always return an error
code. This should probably be

if (IS_ERR(reset_gpio))
        return PTR_ERR(reset_gpio);

>
>         input = of_property_read_bool(pdev->dev.of_node, "input");
>
> -       ret = gpio_request(gpio_num, "poweroff-gpio");
> -       if (ret) {
> -               pr_err("%s: Could not get GPIO %d", __func__, gpio_num);
> -               return ret;
> -       }
>         if (input) {
> -               if (gpio_direction_input(gpio_num)) {
> -                       pr_err("Could not set direction of GPIO %d to input",
> -                              gpio_num);
> -                       goto err;
> +               if (gpiod_direction_input(reset_gpio)) {
> +                       dev_err(&pdev->dev,
> +                               "Could not set direction of reset GPIO to input\n");
> +                       return -ENODEV;
>                 }
>         } else {
> -               if (gpio_direction_output(gpio_num, gpio_active_low)) {
> -                       pr_err("Could not set direction of GPIO %d", gpio_num);
> -                       goto err;
> +               if (gpiod_direction_output(reset_gpio, 0)) {
> +                       dev_err(&pdev->dev,
> +                               "Could not set direction of reset GPIO\n");
> +                       return -ENODEV;
>                 }
>         }
>
>         pm_power_off = &gpio_poweroff_do_poweroff;
>         return 0;
> -
> -err:
> -       gpio_free(gpio_num);
> -       return -ENODEV;
>  }
>
>  static int gpio_poweroff_remove(struct platform_device *pdev)
>  {
> -       gpio_free(gpio_num);
>         if (pm_power_off == &gpio_poweroff_do_poweroff)
>                 pm_power_off = NULL;
>
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-gpio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
