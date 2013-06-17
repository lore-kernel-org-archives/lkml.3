Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3FQIvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:51:45 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:51925 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3FQIvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:51:43 -0400
MIME-Version: 1.0
In-Reply-To: <1371251915-18271-1-git-send-email-ddaney.cavm@gmail.com>
References: <1371251915-18271-1-git-send-email-ddaney.cavm@gmail.com>
Date: Mon, 17 Jun 2013 10:51:42 +0200
Message-ID: <CACRpkdYHzBBbPNujYRGkMFGuQRzeYKs9jgfc3e3HWyxQFahvRQ@mail.gmail.com>
Subject: Re: [PATCH] gpio MIPS/OCTEON: Add a driver for OCTEON's on-chip GPIO pins.
From: Linus Walleij <linus.walleij@linaro.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 1:18 AM, David Daney <ddaney.cavm@gmail.com> wrote:

> From: David Daney <david.daney@cavium.com>
>
> The SOCs in the OCTEON family have 16 (or in some cases 20) on-chip
> GPIO pins, this driver handles them all.  Configuring the pins as
> interrupt sources is handled elsewhere (OCTEON's irq handling code).
>
> Signed-off-by: David Daney <david.daney@cavium.com>

> This patch depends somewhat on patches in Ralf's MIPS/Linux -next tree
> where we have patches that enable the Kconfig CAVIUM_OCTEON_SOC and
> ARCH_REQUIRE_GPIOLIB symbols.  Apart from that it is stand-alone and
> is probably suitable for merging via the GPIO tree.

Really? You're using this:

+#include <asm/octeon/octeon.h>
+#include <asm/octeon/cvmx-gpio-defs.h>

I cannot find this in my tree.

Further I ask why that second file is not part of *this* patch?
It surely seems GPIO-related, and would probably need to
go into include/linux/platform_data/gpio-octeon.h or something
rather than such platform dirs.

(...)
> +config GPIO_OCTEON
> +       tristate "Cavium OCTEON GPIO"
> +       depends on GPIOLIB && CAVIUM_OCTEON_SOC

depend on OF as well right? Or does the CAVIUM_OCTEON_SOC already
imply that?

(...)
> +++ b/drivers/gpio/gpio-octeon.c


> +#define RX_DAT 0x80
> +#define TX_SET 0x88
> +#define TX_CLEAR 0x90


> +/*
> + * The address offset of the GPIO configuration register for a given
> + * line.
> + */
> +static unsigned int bit_cfg_reg(unsigned int gpio)
+       default y
+       help
+         Say yes here to support the on-chip GPIO lines on the OCTEON
+         family of SOCs.
+

Maybe the passed variable shall be named "offset" here, as it is named
offset on all call sites, and it surely local for this instance?

> +{
> +       if (gpio < 16)
> +               return 8 * gpio;
> +       else
> +               return 8 * (gpio - 16) + 0x100;

Put this 0x100 in the #defines above with the name something like
STRIDE.

> +struct octeon_gpio {
> +       struct gpio_chip chip;
> +       u64 register_base;
> +};

OMG everything is 64 bit. Well has to come to this I guess.

> +static void octeon_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +       struct octeon_gpio *gpio = container_of(chip, struct octeon_gpio, chip);
> +       u64 mask = 1ull << offset;

And now BIT(offset) does not work anymore because it is defined as
#define BIT(nr)                 (1UL << (nr))
OK we will have to live with this FTM I guess.

> +static int octeon_gpio_dir_out(struct gpio_chip *chip, unsigned offset,
> +                              int value)
> +{
> +       struct octeon_gpio *gpio = container_of(chip, struct octeon_gpio, chip);
> +       union cvmx_gpio_bit_cfgx cfgx;
> +
> +       octeon_gpio_set(chip, offset, value);
> +
> +       cfgx.u64 = 0;
> +       cfgx.s.tx_oe = 1;

This makes me want to review that magic header file of yours,
I guess this comes from <asm/octeon/cvmx-gpio-defs.h>?

Should not this latter variable be a bool?

I'm not a fan of packed bitfields like this, I prefer if you just
OR | and AND & the bits together in the driver.

> +static int octeon_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct octeon_gpio *gpio = container_of(chip, struct octeon_gpio, chip);
> +       u64 read_bits = cvmx_read_csr(gpio->register_base + RX_DAT);
> +
> +       return ((1ull << offset) & read_bits) != 0;

A common idiom we use for this is:

return !!(read_bits & (1ull << offset));

> +       pdev->dev.platform_data = chip;
> +       chip->label = "octeon-gpio";
> +       chip->dev = &pdev->dev;
> +       chip->owner = THIS_MODULE;
> +       chip->base = 0;
> +       chip->can_sleep = 0;
> +       chip->ngpio = 20;
> +       chip->direction_input = octeon_gpio_dir_in;
> +       chip->get = octeon_gpio_get;
> +       chip->direction_output = octeon_gpio_dir_out;
> +       chip->set = octeon_gpio_set;
> +       err = gpiochip_add(chip);
> +       if (err)
> +               goto out;
> +
> +       dev_info(&pdev->dev, "OCTEON GPIO\n");

This is like shouting "REAL MADRID!" in the bootlog, be a bit more
precise: "octeon GPIO driver probed\n" or something so we know what
is happening.

Yours,
Linus Walleij
