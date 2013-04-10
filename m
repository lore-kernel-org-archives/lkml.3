Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936587Ab3DJUpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:45:54 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61962 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3DJUpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:45:52 -0400
MIME-Version: 1.0
In-Reply-To: <1365441321-21952-3-git-send-email-kevin.strasser@linux.intel.com>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
	<1365441321-21952-3-git-send-email-kevin.strasser@linux.intel.com>
Date: Wed, 10 Apr 2013 22:45:51 +0200
Message-ID: <CACRpkdaU-QT-VBiG8i5XreEP-DvTosHeptUo+5vdmSyi0=uWTw@mail.gmail.com>
Subject: Re: [PATCH 3/4] gpio: Kontron PLD gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Kevin Strasser <kevin.strasser@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Brunner <michael.brunner@kontron.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>, Michael Brunner <mibru@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 7:15 PM, Kevin Strasser
<kevin.strasser@linux.intel.com> wrote:

> From: Michael Brunner <michael.brunner@kontron.com>
>
> Add gpio support for the on-board PLD found on some Kontron embedded
> modules.
>
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>

Trying to do some real review...

(...)
> +++ b/drivers/gpio/gpio-kempld.c
> +#include <linux/acpi.h>

Is this used?

> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/mfd/kempld.h>
> +#include <linux/seq_file.h>
> +
> +#include "gpio-kempld.h"
> +
> +static int gpiobase = -1;
> +static int gpioien = 0x00;
> +static int gpioevt_lvl_edge = -1;
> +static int gpioevt_low_high = -1;
> +static int gpionmien = 0x00;

(...)

+static int kempld_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+       struct kempld_gpio_data *gpio
+               = container_of(chip, struct kempld_gpio_data, chip);
+       return gpio->irq;
+}

I don't understand this *at all* so help me out here.

.gpio_to_irq() should return a *Linux* IRQ number, usually we take
the event offset (in this case) and map to a Linux IRQ using the
irqdomain helper library. Can you explain how we can be sure that
this number (apparently just a read from a register on the device)
can be made to correspond to a Linux IRQ?

Also if this thing can generate IRQs, are these one line to the CPU
per IRQ really? Don't you need to demux the status register and
create a cascades irqchip?

Maybe it's just me not understanding x86 & ACPI so bear with me...

> +static int kempld_gpio_setup_event(struct kempld_gpio_data *gpio)
> +{
> +       struct kempld_device_data *pld = gpio->pld;
> +       struct gpio_chip *chip = &gpio->chip;
> +       int irq;
> +
> +       irq = gpio->irq;
> +
> +       kempld_get_mutex_set_index(pld, KEMPLD_IRQ_GPIO);
> +       irq = kempld_read8(pld, KEMPLD_IRQ_GPIO);
> +
> +       /* Leave if interrupts are not supported by the GPIO core */
> +       if ((irq & 0xf0) == 0xf0)
> +               return 0;
> +
> +       gpio->irq = irq & 0x0f;

So you read the IRQ from some plug-n-play here, and it's some
system-wide IRQ number?

(...)
> +       if (gpio->irq)
> +               chip->to_irq =          kempld_gpio_to_irq;

So that is this mystery with the IRQs and how they turn into
Linux IRQs.

> +module_param(gpiobase, int, 0444);

Why do you need to be able to configure this?
It must be a real usecase, debugging can be done by patching
the code.

> +module_param(gpioien, int, 0444);
> +module_param(gpioevt_lvl_edge, int, 0444);
> +module_param(gpioevt_low_high, int, 0444);
> +module_param(gpionmien, int, 0444);

Argh how can anyone possibly make this out ... do you really
need them or can we get rid of some and rely on autodetect?

> +MODULE_DESCRIPTION("KEM PLD GPIO Driver");
> +MODULE_AUTHOR("Michael Brunner <michael.brunner@kontron.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:kempld_gpio");
> +MODULE_PARM_DESC(gpiobase, "Set GPIO base (default -1=dynamic)");
> +MODULE_PARM_DESC(gpioien, "Set GPIO IEN register (default 0x00)");
> +MODULE_PARM_DESC(gpioevt_lvl_edge,
> +                       "Set GPIO EVT_LVL_EDGE register (default -1=no change)");
> +MODULE_PARM_DESC(gpioevt_low_high,
> +                       "Set GPIO EVT_LOW_HIGH register (default -1=no change)");
> +MODULE_PARM_DESC(gpionmien, "Set GPIO NMIEN register (default 0x00)");


So I don't really like that interrupt enablement and edge and low/high
is done with module parameters instead of just creating an irqchip and
have it implement the operations to do exactly these things at runtime
instead.

Again maybe some x86 thing I don't get...

> diff --git a/drivers/gpio/gpio-kempld.h b/drivers/gpio/gpio-kempld.h
(...)
> +struct kempld_gpio_data {
> +       struct gpio_chip                chip;
> +       int                             irq;
> +       struct kempld_device_data       *pld;
> +       uint16_t                        mask;

Just u16?

> +};

(...)
> diff --git a/drivers/gpio/gpio-kempld_now1.c b/drivers/gpio/gpio-kempld_now1.c
> +#include <linux/io.h>

Do you use this?

> +#include <linux/slab.h>
> +#include <linux/errno.h>
> +#include <linux/acpi.h>

And this?

> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/mfd/kempld.h>
> +#include <linux/seq_file.h>
> +
> +#include "gpio-kempld.h"
(...)
> +

Most comments concern the other driver too.

Yours,
Linus Walleij
