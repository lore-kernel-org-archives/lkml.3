Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab3E3T1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:27:10 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51409 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3E3T07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:26:59 -0400
MIME-Version: 1.0
In-Reply-To: <1369814513-24967-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1369814513-24967-1-git-send-email-mathias.nyman@linux.intel.com>
Date: Thu, 30 May 2013 21:26:58 +0200
Message-ID: <CACRpkdZbeUUuxDNWvv2pdNTcbHtTgdLNT5si1seA8As_2t2yEg@mail.gmail.com>
Subject: Re: [PATCH] gpio: add Intel BayTrail gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 10:01 AM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> Add support for gpio on Intel BayTrail platforms. BayTrail supports 3 banks
> of gpios called SCORE, NCORE ans SUS with 102, 28 and 43 gpio pins.
> Supports gpio interrupts
>
> Pins may be muxed to alternate function instead of gpio by firmware.
> This driver does not touch the pin muxing and expect firmare
> to set pin muxing and pullup/down properties properly.
>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Even though it is not talking to the firmware about changing the state
of pins etc, can we expect it to do so at a later point? Some
comments in the code make me pretty sure that this is the case.

I think there may be a good incentive to put this driver into
drivers/pinctrl/* instead and implement parts of the pinctrl
interfaces.

Pls consult Documentation/pinctrl.txt.

> +/*
> + * Baytrail gpio controller consist of three separate sub-controllers called
> + * SCORE, NCORE and SUS. The sub-controllers are identified by their acpi UID.
> + *
> + * GPIO numbering is _not_ ordered meaning that gpio # 0 in ACPI namespace does
> + * _not_ correspond to the first gpio register at controller's gpio base.
> + * There is no logic or pattern in mapping gpio numbers to registers (pads) so
> + * each sub-controller needs to have its own mapping table
> + */
> +
> +static unsigned score_gpio_to_pad[BYT_NGPIO_SCORE] = {
> +       85, 89, 93, 96, 99, 102, 98, 101, 34, 37,
> +       36, 38, 39, 35, 40, 84, 62, 61, 64, 59,
> +       54, 56, 60, 55, 63, 57, 51, 50, 53, 47,
> +       52, 49, 48, 43, 46, 41, 45, 42, 58, 44,
> +       95, 105, 70, 68, 67, 66, 69, 71, 65, 72,
> +       86, 90, 88, 92, 103, 77, 79, 83, 78, 81,
> +       80, 82, 13, 12, 15, 14, 17, 18, 19, 16,
> +       2, 1, 0, 4, 6, 7, 9, 8, 33, 32,
> +       31, 30, 29, 27, 25, 28, 26, 23, 21, 20,
> +       24, 22, 5, 3, 10, 11, 106, 87, 91, 104,
> +       97, 100,
> +};
> +
> +static unsigned ncore_gpio_to_pad[BYT_NGPIO_NCORE] = {
> +       19, 18, 17, 20, 21, 22, 24, 25, 23, 16,
> +       14, 15, 12, 26, 27, 1, 4, 8, 11, 0,
> +       3, 6, 10, 13, 2, 5, 9, 7,
> +};
> +
> +static unsigned sus_gpio_to_pad[BYT_NGPIO_SUS] = {
> +       29, 33, 30, 31, 32, 34, 36, 35, 38, 37,
> +       18, 11, 20, 17, 1, 8, 10, 19, 12, 0,
> +       2, 23, 39, 28, 27, 22, 21, 24, 25, 26,
> +       51, 56, 54, 49, 55, 48, 57, 50, 58, 52,
> +       53, 59, 40,
> +};

This is duplicating the functionality of mapping pins to GPIO ranges
which already exist in the pinctrl subsystem.

gpiochip_add_pin_range(chip, "foo", offset, pin_base, N);

This can be reused by instatiating a shallow pinctrl driver which only
populates the .name, .pins, .owner, .get_groups_count(),
.get_group_name(), and . get_group_pins() of a struct pinctrl_desc
(we can discuss about making the group functions optional)
and then using the GPIO ranges to cross reference pins to
GPIOs.

Then you could use from <linux/pinctrl/pinctrl.h>
pinctrl_find_gpio_range_from_pin(struct pinctrl_dev *pctldev,
                                 unsigned int pin);

And other helpers to cross-reference pins and GPIOs.

(...)
> +static void __iomem *byt_gpio_reg(struct gpio_chip *chip, unsigned offset,
> +                                int reg)
> +{
> +       struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
> +       u32 reg_offset;
> +       void __iomem *ptr;
> +
> +       if (reg == BYT_INT_STAT_REG)
> +               reg_offset = (offset / 32) * 4;
> +       else
> +               reg_offset = vg->gpio_to_pad[offset] * 16;
> +       ptr = (void __iomem *) (vg->reg_base + reg_offset + reg);
> +       return ptr;
> +}
> +
> +static int byt_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
> +


> +/* Policy about what should be done when requesting a gpio is unclear.
> + * In most cases PIN MUX 000 means gpio function, with the exception of SUS
> + * core pins 11-21 where gpio is mux 001.

This also looks suspicious. If it is "unclear" I am reading here:
"we will sooner or later have to deal with pin control somekindof".

> + * Some pins are set by bios to a non-gpio mux, but still marked as gpio
> + * resource in acpi tables, and they work just as they should when not touching
> + * the pin muxing. (For example mmc card detect switch)
> + *
> + * option 1, check pin mux is "gpio", else fail (FIXME gpio SUS pins 11-21):
> + *     void __iomem *reg = byt_gpio_reg(chip, offset, BYT_CONF0_REG);
> + *     u32 value;
> + *     value = readl(reg) & BYT_PIN_MUX;
> + *     if (value)
> + *             return -EINVAL;
> + *
> + * option 2, force pin mux to gpio mode (FIXME gpio SUS pins 11-21):
> + *     void __iomem *reg = byt_gpio_reg(chip, offset, BYT_CONF0_REG);
> + *     u32 value;
> + *     value = readl(reg) & BYT_PIN_MUX;
> + *     writel(value & ~BYT_PIN_MUX, reg);
> + *
> + * option 3: don't touch the pinmuxing at all, let BIOS handle it
> + */
> +       pm_runtime_get(&vg->pdev->dev);
> +
> +       return 0;
> +}

If you ever want to do option 1 or 2, you should use pinctrl.

It also has (when implemented) the upside of exposing all these
gory details through debugfs for nice debugging, so developers
can see the state of all pads here.

I would recommend putting this in drivers/pinctrl, and
use a single probe() function, but call both gpiochip_add()
and pinctrl_register() then use gpiochip_add_pin_range()
to map pins to GPIOs. Compare e.g.
drivers/pinctrl/pinctrl-abx500.c

Yours,
Linus Walleij
