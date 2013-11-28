Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab3K1Pyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:54:52 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:49735 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab3K1Pys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:54:48 -0500
MIME-Version: 1.0
In-Reply-To: <1385628388-23827-1-git-send-email-acourbot@nvidia.com>
References: <1385628388-23827-1-git-send-email-acourbot@nvidia.com>
Date: Thu, 28 Nov 2013 17:54:47 +0200
Message-ID: <CAHp75VcHa7cxAt_utwMVp7j+YeKcqa0_N5B=7-ZmTMD_6AV1Lw@mail.gmail.com>
Subject: Re: [PATCH] gpio: better lookup method for platform GPIOs
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 10:46 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Change the format of the platform GPIO lookup tables to make them less
> confusing and improve lookup efficiency.
>
> The previous format was a single linked-list that required to compare
> the device name and function ID of every single GPIO defined for each
> lookup. Switch that to a list of per-device tables, so that the lookup
> can be done in two steps, omitting the GPIOs that are not relevant for a
> particular device.
>
> The matching rules are now defined as follows:
> - The device name must match *exactly*, and can be NULL for GPIOs not
>   assigned to a particular device,
> - If the function ID in the lookup table is NULL, the con_id argument of
>   gpiod_get() will not be used for lookup. However, if it is defined, it
>   must match exactly.
> - The index must always match.

Thanks for that, since I'm also was a bit confused of those dev_id/con_id stuff.
Few comments below (mostly about style).


> --- a/Documentation/gpio/board.txt
> +++ b/Documentation/gpio/board.txt

> @@ -88,16 +89,20 @@ Note that GPIO_LOOKUP() is just a shortcut to GPIO_LOOKUP_IDX() where idx = 0.
>
>  A lookup table can then be defined as follows:
>
> -       struct gpiod_lookup gpios_table[] = {
> -       GPIO_LOOKUP_IDX("gpio.0", 15, "foo.0", "led", 0, GPIO_ACTIVE_HIGH),
> -       GPIO_LOOKUP_IDX("gpio.0", 16, "foo.0", "led", 1, GPIO_ACTIVE_HIGH),
> -       GPIO_LOOKUP_IDX("gpio.0", 17, "foo.0", "led", 2, GPIO_ACTIVE_HIGH),
> -       GPIO_LOOKUP("gpio.0", 1, "foo.0", "power", GPIO_ACTIVE_LOW),
> -       };
> +struct gpiod_lookup_table gpios_table = {
> +       .dev_id = "foo.0",
> +       .size = 4,
> +       .table = {
> +       GPIO_LOOKUP_IDX("gpio.0", 15, "led", 0, GPIO_ACTIVE_HIGH),
> +       GPIO_LOOKUP_IDX("gpio.0", 16, "led", 1, GPIO_ACTIVE_HIGH),
> +       GPIO_LOOKUP_IDX("gpio.0", 17, "led", 2, GPIO_ACTIVE_HIGH),
> +       GPIO_LOOKUP("gpio.0", 1, "power", GPIO_ACTIVE_LOW),

Can you use deeper indentation for GPIO_* lines here?


> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c

> @@ -2326,72 +2322,77 @@ static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
>         return desc;
>  }
>
> -static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
> -                                   unsigned int idx,
> -                                   enum gpio_lookup_flags *flags)
> +static struct gpiod_lookup_table *gpiod_find_lookup_table(struct device *dev)
>  {
>         const char *dev_id = dev ? dev_name(dev) : NULL;
> -       struct gpio_desc *desc = ERR_PTR(-ENODEV);
> -       unsigned int match, best = 0;
> -       struct gpiod_lookup *p;
> +       struct gpiod_lookup_table *table;
>
>         mutex_lock(&gpio_lookup_lock);
>
> -       list_for_each_entry(p, &gpio_lookup_list, list) {
> -               match = 0;
> +       list_for_each_entry(table, &gpio_lookup_list, list) {
> +               if (table->dev_id && dev_id && strcmp(table->dev_id, dev_id))

Maybe check !dev_id outside of loop?

> +                       continue;
>
> -               if (p->dev_id) {
> -                       if (!dev_id || strcmp(p->dev_id, dev_id))
> -                               continue;
> +               if (dev_id != table->dev_id)
> +                       continue;
>
> -                       match += 2;
> -               }
> +               return table;

What  about

if (dev_id == table->dev_id)
 return table;

?

> +       }
>
> -               if (p->con_id) {
> -                       if (!con_id || strcmp(p->con_id, con_id))
> -                               continue;
> +       mutex_unlock(&gpio_lookup_lock);
>
> -                       match += 1;
> -               }
> +       return NULL;
> +}
>
> -               if (p->idx != idx)
> -                       continue;
> +static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
> +                                   unsigned int idx,
> +                                   enum gpio_lookup_flags *flags)
> +{
> +       struct gpio_desc *desc = ERR_PTR(-ENODEV);
> +       struct gpiod_lookup_table *table;
> +       int i;
>
> -               if (match > best) {
> -                       struct gpio_chip *chip;
>

Looks like redundant empty line.

> -                       chip = find_chip_by_name(p->chip_label);
> +       table = gpiod_find_lookup_table(dev);
> +       if (!table)
> +               return desc;
>
> -                       if (!chip) {
> -                               dev_warn(dev, "cannot find GPIO chip %s\n",
> -                                        p->chip_label);
> -                               continue;
> -                       }
> +       for (i = 0; i < table->size; i++) {
> +               struct gpio_chip *chip;
> +               struct gpiod_lookup *p = &table->table[i];
>
> -                       if (chip->ngpio <= p->chip_hwnum) {
> -                               dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
> -                                        chip->label, chip->ngpio);
> +               if (p->idx != idx)
> +                       continue;
> +
> +               if (p->con_id) {
> +                       if (!con_id || strcmp(p->con_id, con_id))

Could be one 'if' and moreover !con_id check might be outside a loop.

>                                 continue;
> -                       }
> +               }
>
> -                       desc = gpio_to_desc(chip->base + p->chip_hwnum);
> -                       *flags = p->flags;
> +               chip = find_chip_by_name(p->chip_label);
>
> -                       if (match != 3)
> -                               best = match;
> -                       else
> -                               break;
> +               if (!chip) {
> +                       dev_warn(dev, "cannot find GPIO chip %s\n",
> +                                p->chip_label);
> +                       continue;
>                 }
> -       }
>
> -       mutex_unlock(&gpio_lookup_lock);
> +               if (chip->ngpio <= p->chip_hwnum) {
> +                       dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
> +                                chip->label, chip->ngpio);
> +                       continue;
> +               }
> +
> +               desc = gpiochip_offset_to_desc(chip, p->chip_hwnum);
> +               *flags = p->flags;
> +       }
>
>         return desc;
>  }

-- 
With Best Regards,
Andy Shevchenko
