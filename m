Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaK1Nha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:37:30 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:39549 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaK1Nh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:37:28 -0500
MIME-Version: 1.0
In-Reply-To: <1416837696-28066-2-git-send-email-alban.bedel@avionic-design.de>
References: <1416837696-28066-1-git-send-email-alban.bedel@avionic-design.de>
	<1416837696-28066-2-git-send-email-alban.bedel@avionic-design.de>
Date: Fri, 28 Nov 2014 14:37:27 +0100
Message-ID: <CACRpkdZ=qwO9qcr8tt3Pxs+kEPSGo58R8TzNCu9bC=dxHimDBQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: add a driver for GPIOs going through a level shifter
From: Linus Walleij <linus.walleij@linaro.org>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 3:01 PM, Alban Bedel
<alban.bedel@avionic-design.de> wrote:

> This driver support setting the level shifter direction and/or enable
> as needed.
>
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>

Very interesting patch!

I have some worries. What if the backing GPIO chip supports interrupts
on GPIO lines, and consumers do gpiod_get() from this level
shifter front-end, followed by gpio_to_irq()? Then the line will
not be converted to an IRQ properly.

In the device tree case I guess you can refer to the backing
GPIO chip with the interrupt property, but then you have to
coordinate setting the line as input both on this front-end and
on the back-end. Now the drivers won't properly enforce that.

So it would be much nicer if the level shifter front-end would
also propagate irqchip stuff to the back-end. I don't know if that
will be easy.

The second problem is that of handling a level shifter backed
by more than one GPIO chip, as mentioned by Rob for the other
patch. It's better if we store the backing GPIO chip on a per-line
basis. Make struct level_shifter_gpio contain a list of lines and
for each line have another struct that contain per-line data
like the gpiod for that line (so you can find the gpio_chip and
have it unique if need be).

Then I wonder if all level shifters are such that you set the direction
for all lines going in/out of it, or if there are level shifters where this
is controlled on a per-line basis.

Patch MAINTAINERS so that you are indicated as maintainer
of this driver.

Would you consider also maintaining
drivers/gpio/gpio-adnp.c?

> +config GPIO_LEVEL_SHIFTER
> +       tristate "Level shifter GPIO support"

depends on OF_GPIO or select OF_GPIO?
select REGULATOR?

(...)
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/gpio/driver.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/regulator/consumer.h>

Thanks for using descriptors solely.

> +#define MAX_DATA_GPIO 32

Why? Use a list with dynamic allocation instead of such
arbitrary restrictions.

> +enum level_shifter_direction {
> +       DIRECTION_NONE,
> +       DIRECTION_INPUT,
> +       DIRECTION_OUTPUT
> +};
> +
> +struct level_shifter_gpio {
> +       struct gpio_chip gc;
> +
> +       spinlock_t lock;
> +       int num_requested;
> +
> +       struct gpio_desc *data_gpio[MAX_DATA_GPIO];
> +       struct gpio_desc *enable_gpio;
> +       struct gpio_desc *direction_gpio;
> +       enum level_shifter_direction direction;
> +
> +       struct regulator *vcc_a;
> +       struct regulator *vcc_b;

Is VCC_A and VCC_B really the right terminology?

I see this in some datasheets but the pinout seems top be
VCC and VDD, which one is it? Needs crystal clear documentation
anyways.

> +};

Add kerneldoc to this struct.

> +#define to_level_shifter_gpio(c) \
> +       container_of(c, struct level_shifter_gpio, gc)
> +
> +int level_shifter_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct level_shifter_gpio *ls = to_level_shifter_gpio(chip);
> +
> +       spin_lock(&ls->lock);

Since the backend may be slow (e.g. on an I2C bus)
it is not wise to use a spinlock here.

Exactly what is it protecting really? I think you can just
remove it.

> +       if (ls->num_requested == 0 && ls->enable_gpio)
> +               gpiod_set_value(ls->enable_gpio, 1);
> +
> +       ls->num_requested++;

Instead of your own refence counting, use struct kref for
whatever it is you need to keep track of. It will handle
callbacks when references reach 0 etc.

<linux/kref.h> grep kernel for examples.

(...)
> +void level_shifter_gpio_free(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct level_shifter_gpio *ls = to_level_shifter_gpio(chip);
> +
> +       spin_lock(&ls->lock);
> +
> +       ls->num_requested--;
> +
> +       if (ls->num_requested == 0) {
> +               if (ls->enable_gpio)
> +                       gpiod_set_value(ls->enable_gpio, 0);
> +               if (ls->direction_gpio)
> +                       ls->direction = DIRECTION_NONE;

Is that really true? Isn't it just keeping what it used to be?

DIRECTION_DONT_CARE seems more appropriate if you
use it like this.

(...)
> +static int level_shifter_gpio_probe(struct platform_device *pdev)
> +{
> +       struct device_node *np = pdev->dev.of_node;
> +       struct level_shifter_gpio *ls;
> +       struct gpio_desc *gpiod;
> +       int err, i;
> +
> +       ls = devm_kzalloc(&pdev->dev, sizeof(*ls), GFP_KERNEL);
> +       if (!ls)
> +               return -ENOMEM;
> +
> +       spin_lock_init(&ls->lock);
> +
> +       if (np)
> +               ls->gc.label = np->name;
> +       else
> +               ls->gc.label = "level-shifter-gpio";
> +
> +       ls->gc.of_node = pdev->dev.of_node;
> +       ls->gc.base = -1;
> +       ls->gc.request = level_shifter_gpio_request;
> +       ls->gc.free = level_shifter_gpio_free;
> +       ls->gc.set = level_shifter_gpio_set;
> +       ls->gc.direction_output = level_shifter_gpio_direction_output;
> +       ls->gc.get = level_shifter_gpio_get;
> +       ls->gc.direction_input = level_shifter_gpio_direction_input;
> +
> +       for (i = 0; i < MAX_DATA_GPIO; i++) {
> +               gpiod = devm_gpiod_get_index_optional(
> +                       &pdev->dev, "data", i, GPIOD_IN);

Instead just keep getting indexes until we get
a -ENOENT and add dynamically to a gpiod list.

 +       ls->vcc_a = devm_regulator_get_optional(&pdev->dev, "vcca");
> +       if (IS_ERR(ls->vcc_a) && PTR_ERR(ls->vcc_a) != -ENODEV)
> +               return PTR_ERR(ls->vcc_a);
> +       if (!IS_ERR(ls->vcc_a)) {
> +               err = regulator_enable(ls->vcc_a);
> +               if (err)
> +                       return err;
> +       }
> +
> +       ls->vcc_b = devm_regulator_get_optional(&pdev->dev, "vccb");
> +       if (IS_ERR(ls->vcc_b) && PTR_ERR(ls->vcc_b) != -ENODEV)
> +               return PTR_ERR(ls->vcc_b);
> +       if (!IS_ERR(ls->vcc_b)) {
> +               err = regulator_enable(ls->vcc_b);
> +               if (err)
> +                       return err;
> +       }

Why are the regulators enabled even if the level shifter is not
in use?

Should these regulator_enable() calls be done at the same
place as the other enablement, when a GPIO is requested
and num_requested goes from 0->1?

Yours,
Linus Walleij
