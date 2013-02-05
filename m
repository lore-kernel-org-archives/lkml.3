Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3BERxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:53:09 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44776 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3BERxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:53:06 -0500
MIME-Version: 1.0
In-Reply-To: <1359822572-26009-8-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
	<1359822572-26009-8-git-send-email-acourbot@nvidia.com>
Date: Tue, 5 Feb 2013 18:53:05 +0100
Message-ID: <CACRpkdbib-+pvMiLQN=f6d-1dhK2OK3znJeGoL7rDxDQYuJRuA@mail.gmail.com>
Subject: Re: [PATCH 6/9] gpiolib: use descriptors internally
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Make sure gpiolib works internally with descriptors and (chip, offset)
> pairs instead of using the global integer namespace. This prepares the

Its a numberspace not a namespace right?

> ground for the removal of the global gpio_desc[] array and the
> introduction of the descriptor-based GPIO API.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

> +/*
> + * Internal gpiod_* API using descriptors instead of the integer namespace.
> + * Most of this should eventually go public.
> + */
> +static int gpiod_request(struct gpio_desc *desc, const char *label);
> +static void gpiod_free(struct gpio_desc *desc);
> +static int gpiod_direction_input(struct gpio_desc *desc);
> +static int gpiod_direction_output(struct gpio_desc *desc, int value);
> +static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce);
> +static int gpiod_get_value_cansleep(struct gpio_desc *desc);
> +static void gpiod_set_value_cansleep(struct gpio_desc *desc, int value);
> +static int gpiod_get_value(struct gpio_desc *desc);
> +static void gpiod_set_value(struct gpio_desc *desc, int value);
> +static int gpiod_cansleep(struct gpio_desc *desc);
> +static int gpiod_to_irq(struct gpio_desc *desc);
> +static int gpiod_export(struct gpio_desc *desc, bool direction_may_change);
> +static int gpiod_export_link(struct device *dev, const char *name,
> +                            struct gpio_desc *desc);
> +static int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value);
> +static void gpiod_unexport(struct gpio_desc *desc);

Usually I don't like these upfrons forward-declarations, but in this
case I *do* because they are here for a reason, to later become
extern. So I like it!

> +/*
> + * Return the GPIO number of the passed descriptor relative to its chip
> + */
> +static int gpio_chip_hwgpio(const struct gpio_desc *desc)
> +{
> +       return (desc - &gpio_desc[0]) - desc->chip->base;
> +}

That was a scary method. But it works as long as the
descriptors are in a static array I guess...

> +/**
> + * Convert a GPIO number to its descriptor
> + */
> +static struct gpio_desc *gpio_to_desc(unsigned gpio)
> +{
> +       if (WARN(!gpio_is_valid(gpio), "invalid GPIO %d\n", gpio))
> +               return NULL;

Don't we want to return ERR_PTR(-EINVAL); here?

Then you can use IS_ERR() on the pointers later.

This is the approach taken by the external API for clk
and pins.

> +/**
> + * Convert a GPIO descriptor to the integer namespace.
> + * This should disappear in the future but is needed since we still
> + * use GPIO numbers for error messages and sysfs nodes
> + */
> +static int desc_to_gpio(const struct gpio_desc *desc)
> +{
> +       return desc - &gpio_desc[0];
> +}

Aha OK the scary stuff goes away. Good...

> +
> +

You can never get enough whitespace ;-)

>  /* caller holds gpio_lock *OR* gpio is marked as requested */

That comment should be above the *next* function right?

Strictly speaking it does not apply to gpiod_to_chip() if
I read it right.

> +static struct gpio_chip *gpiod_to_chip(struct gpio_desc *desc)
> +{
> +       return desc->chip;
> +}
> +
>  struct gpio_chip *gpio_to_chip(unsigned gpio)
>  {
> -       return gpio_desc[gpio].chip;
> +       return gpiod_to_chip(gpio_to_desc(gpio));
>  }

...Then follows lots of nice stuff...

(...)
>  static ssize_t gpio_direction_show(struct device *dev,
>                 struct device_attribute *attr, char *buf)
>  {
> -       const struct gpio_desc  *desc = dev_get_drvdata(dev);
> -       unsigned                gpio = desc - gpio_desc;
> +       struct gpio_desc        *desc = dev_get_drvdata(dev);

Why not const anymore?

(Applies to all these similar cases in the patch.)

consting is nice. Especially in subsystem code.
I know it is hard to get compilation right without warnings
at times. But it pays off.

In the pinctrl subsystem I spend endless hours reading this
wiki page:

http://en.wikipedia.org/wiki/Const-correctness

I still don't quite get it. And it also wears off. But I like to use it.

> @@ -594,29 +647,32 @@ static ssize_t export_store(struct class *class,
> +       desc = gpio_to_desc(gpio);

I hope you have tested this hunk of the patch from userspace?

> @@ -637,17 +694,18 @@ static ssize_t unexport_store(struct class *class,

This too?

(etc for the userspace interfaces)

> @@ -1538,48 +1622,54 @@ int gpio_direction_input(unsigned gpio)
>                 }
>         }
>
> -       status = chip->direction_input(chip, gpio);
> +       status = chip->direction_input(chip, offset);
>         if (status == 0)
>                 clear_bit(FLAG_IS_OUT, &desc->flags);
>
> -       trace_gpio_direction(chip->base + gpio, 1, status);
> +       trace_gpio_direction(desc_to_gpio(desc), 1, status);
>  lose:
>         return status;
>  fail:
>         spin_unlock_irqrestore(&gpio_lock, flags);
> -       if (status)
> +       if (status) {
> +               int gpio = -1;
> +               if (desc)
> +                       gpio = desc_to_gpio(desc);
>                 pr_debug("%s: gpio-%d status %d\n",
>                         __func__, gpio, status);
> +       }
>         return status;
>  }

So using ERR_PTR/PTR_ERR helps you propagate
errors in situations like these.

Just:

if (IS_ERR(desc))
    status = PTR_ERR(desc);

> -int gpio_direction_output(unsigned gpio, int value)
> +static int gpiod_direction_output(struct gpio_desc *desc, int value)
>  {
>         unsigned long           flags;
>         struct gpio_chip        *chip;
> -       struct gpio_desc        *desc = &gpio_desc[gpio];
>         int                     status = -EINVAL;
> +       int offset;

Use hwgpio?


>         /* Open drain pin should not be driven to 1 */
>         if (value && test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
> -               return gpio_direction_input(gpio);
> +               return gpiod_direction_input(desc);
>
>         /* Open source pin should not be driven to 0 */
>         if (!value && test_bit(FLAG_OPEN_SOURCE,  &desc->flags))
> -               return gpio_direction_input(gpio);
> +               return gpiod_direction_input(desc);
>
>         spin_lock_irqsave(&gpio_lock, flags);
>
> -       if (!gpio_is_valid(gpio))
> +       if (!desc)

if (IS_ERR(desc)) ?

> @@ -1589,11 +1679,12 @@ int gpio_direction_output(unsigned gpio, int value)
>
>         might_sleep_if(chip->can_sleep);
>
> +       offset = gpio_chip_hwgpio(desc);

Maybe rename to hwgpio? Or is that done later?

We should stick with either hwgpio or offset everywhere or
it will be a mess.

(...)
>  fail:
>         spin_unlock_irqrestore(&gpio_lock, flags);
> -       if (status)
> +       if (status) {
> +               int gpio = -1;
> +               if (desc)
> +                       gpio = desc_to_gpio(desc);
>                 pr_debug("%s: gpio-%d status %d\n",
>                         __func__, gpio, status);
> +       }
>         return status;

Again IS_ERR()/ERR_PTR(). -1 is not nice.

>  /**
> @@ -1622,24 +1722,22 @@ EXPORT_SYMBOL_GPL(gpio_direction_output);
>   * @gpio: the gpio to set debounce time
>   * @debounce: debounce time is microseconds
>   */
> -int gpio_set_debounce(unsigned gpio, unsigned debounce)
> +static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
>  {
>         unsigned long           flags;
>         struct gpio_chip        *chip;
> -       struct gpio_desc        *desc = &gpio_desc[gpio];
>         int                     status = -EINVAL;
> +       int                     offset;

hwgpio?

(then follows some repating cases)

(then some nice code)

> -int gpio_get_value_cansleep(unsigned gpio)
> +static int gpiod_get_value_cansleep(struct gpio_desc *desc)
>  {
>         struct gpio_chip        *chip;
>         int value;
> +       int offset;

hwgpio?

Basically the patch is very nice but I'd like you to iron out and proofread
as per above so we have strong consistency, strong const:ing,
and stringent naming (offset vs hwgpio come to mind).

Yours,
Linus Walleij
