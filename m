Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3HPOqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:46:50 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58150 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3HPOqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:46:44 -0400
MIME-Version: 1.0
In-Reply-To: <op.w1c50xgmu7prd4@fabians-laptop.fritz.box>
References: <op.w1c50xgmu7prd4@fabians-laptop.fritz.box>
Date: Fri, 16 Aug 2013 16:46:43 +0200
Message-ID: <CACRpkdbLSDiSAGiZ_PpJganrSoar+2fFPaEjbu_L1Ezx5V8DMg@mail.gmail.com>
Subject: Re: [PATCH] gpio: New driver for LSI ZEVIO SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabian Vogt <fabian@ritter-vogt.de>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 11:59 PM, Fabian Vogt <fabian@ritter-vogt.de> wrote:

> From: Fabian Vogt <fabian@ritter-vogt.de>
>
> This driver supports the GPIO controller found in LSI ZEVIO SoCs.
> It has been successfully tested on a TI nspire CX calculator.
>
> Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>

Hi Fabian, sorry for taking so long for getting around to review this.

> +++ b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt

I want an ACK from one of the DT bindings maintainers for this
portion of the driver ideally. (It looks all right to me.)

> +config GPIO_ZEVIO
> +       bool "LSI ZEVIO SoC memory mapped GPIOs"
> +       depends on ARCH_NSPIRE

Can't this appear in some other SoC?

It doesn't seem very arch-dependent in itself.

I would rather have this depend on OF so any device-tree enabled
SoC may use it, plus we get compile coverage by allmodconfig.

> diff --git a/drivers/gpio/gpio-zevio.c b/drivers/gpio/gpio-zevio.c
(...)
> +/*
> + * Memory layout:
> + * This chip has four gpio sections, each controls 8 GPIOs.
> + * Bit 0 in section 0 is GPIO 0, bit 2 in section 1 is GPIO 10.
> + * Disclaimer: Reverse engineered!
> + * For more information refer to:
> + *
> http://hackspire.unsads.com/wiki/index.php/Memory-mapped_I/O_ports#90000000_-_General_Purpose_I.2FO_.28GPIO.29

Very ambitious. Impressive!

> + * 0x00-0x3F: Section 0
> + *     +0x00: Masked interrupt status (read-only)
> + *     +0x04: R: Interrupt status W: Reset interrupt status
> + *     +0x08: R: Interrupt mask W: Mask interrupt
> + *     +0x0C: W: Unmask interrupt (write-only)
> + *     +0x10: Direction: I/O=1/0
> + *     +0x14: Output
> + *     +0x18: Input (read-only)
> + *     +0x20: R: Sticky interrupts W: Set sticky interrupt

What is a sticky interrupt? Do you mean it is a level IRQ?
Then it's edge triggered if zero and level triggered if "sticky"
is set to 1, right?

> +/* Functions for struct gpio_chip */
> +static int zevio_gpio_get(struct gpio_chip *chip, unsigned pin)
> +{
> +       struct zevio_gpio *controller = to_zevio_gpio(chip);
> +
> +       /* Only reading allowed, so no spinlock needed */
> +       uint16_t val = readw(ZEVIO_GPIO(controller, pin, INPUT));

Use just u16 please. uint16_t is some portable C type.

Please replace uint16_t with u16 everywhere.

> +
> +       return (val >> ZEVIO_GPIO_BIT(pin)) & 0x1;

Use this construct:
return !!(val & ZEVIO_GPIO_BIT(pin));

> +static void zevio_gpio_set(struct gpio_chip *chip, unsigned pin, int value)
> +{
> +       struct zevio_gpio *controller = to_zevio_gpio(chip);
> +       uint16_t val;
> +
> +       spin_lock(&controller->lock);
> +       val = readw(ZEVIO_GPIO(controller, pin, OUTPUT));
> +       if (value)
> +               val |= 1<<ZEVIO_GPIO_BIT(pin);

I usually do this:

#include <linux/bitops.h>

val |= BIT(ZEVIO_GPIO_BIT(pin));

> +       else
> +               val &= ~(1<<ZEVIO_GPIO_BIT(pin));

Dito, sort of...

> +
> +       writew(val, ZEVIO_GPIO(controller, pin, OUTPUT));
> +       spin_unlock(&controller->lock);
> +}
> +
> +static int zevio_gpio_direction_input(struct gpio_chip *chip, unsigned pin)
> +{
> +       struct zevio_gpio *controller = to_zevio_gpio(chip);
> +       uint16_t val;
> +
> +       spin_lock(&controller->lock);
> +
> +       val = readw(ZEVIO_GPIO(controller, pin, DIRECTION));
> +       val |= 1<<ZEVIO_GPIO_BIT(pin);

Same idea as above.

> +       writew(val, ZEVIO_GPIO(controller, pin, DIRECTION));
> +
> +       spin_unlock(&controller->lock);
> +
> +       return 0;
> +}
> +
> +static int zevio_gpio_direction_output(struct gpio_chip *chip,
> +                                      unsigned pin, int value)
> +{
> +       struct zevio_gpio *controller = to_zevio_gpio(chip);
> +       uint16_t val;
> +
> +       spin_lock(&controller->lock);
> +       val = readw(ZEVIO_GPIO(controller, pin, OUTPUT));
> +       if (value)
> +               val |= 1<<ZEVIO_GPIO_BIT(pin);
> +       else
> +               val &= ~(1<<ZEVIO_GPIO_BIT(pin));

And here too.

> +
> +       writew(val, ZEVIO_GPIO(controller, pin, OUTPUT));
> +       val = readw(ZEVIO_GPIO(controller, pin, DIRECTION));
> +       val &= ~(1<<ZEVIO_GPIO_BIT(pin));
> +       writew(val, ZEVIO_GPIO(controller, pin, DIRECTION));

And here.

> +
> +       spin_unlock(&controller->lock);
> +
> +       return 0;
> +}
> +
> +static int zevio_gpio_to_irq(struct gpio_chip *chip, unsigned pin)
> +{
> +       /* Not implemented due to weird lockups */
> +       return -ENXIO;

Hm. I guess this should be marked TODO: or something.

So when you figure this out you also add an irqchip.

The way this looks I was thinking it could use the
drivers/gpio/gpio-generic.c driver, but maybe not?

Yours,
Linus Walleij
