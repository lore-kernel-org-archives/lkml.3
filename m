Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbaEPRdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:33:47 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:46386 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575AbaEPRdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:33:45 -0400
MIME-Version: 1.0
In-Reply-To: <1400082247-24168-1-git-send-email-lejun.zhu@linux.intel.com>
References: <1400082247-24168-1-git-send-email-lejun.zhu@linux.intel.com>
Date: Fri, 16 May 2014 19:33:44 +0200
Message-ID: <CACRpkdZ67KoaMWUzpPm5g7yvQ-_q9zxuS+4wcXP0u18MW=XovA@mail.gmail.com>
Subject: Re: [PATCH] gpio: Add support for Intel SoC PMIC (Crystal Cove)
From: Linus Walleij <linus.walleij@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bin.yang@intel.com, Darren Hart <dvhart@linux.intel.com>,
        "Holmberg, Hans" <hans.holmberg@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 5:44 PM, Zhu, Lejun <lejun.zhu@linux.intel.com> wrote:

> Devices based on Intel SoC products such as Baytrail have a Power
> Management IC. In the PMIC there are subsystems for voltage regulation,
> A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
> Crystal Cove.
>
> This patch adds support for the GPIO function in Crystal Cove.
>
> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>

(...)

> +config GPIO_INTEL_SOC_PMIC
> +       bool "GPIO on Intel SoC PMIC"
> +       depends on INTEL_SOC_PMIC

select GPIOLIB_IRQCHIP

and use the infrastructure from commit
1425052097b53de841e064dc190a9009480c208c
"gpio: add IRQ chip helpers in gpiolib"

Some fixes for sleeping chips have been merged and are available
on the "devel" branch in the GPIO tree, so you may need to base
your development on that.

Adding some kerneldoc to the below struct will maybe make you
realize whether you actually need it or not.

> +struct crystalcove_gpio {
> +       struct mutex            buslock; /* irq_bus_lock */
> +       struct gpio_chip        chip;
> +       int                     irq;
> +       int                     irq_base;

You should not have hardcoded IRQ bases around. Use an irqdomain
to map IRQs, and even better: use the one provided in
chip->irqdomain by GPIOLIB_IRQCHIP. (It's a requirement.)

> +       int                     update;
> +       int                     trigger_type;
> +       int                     irq_mask;

Should this be a bool since you just set it to 0 or 1?

> +};
> +static struct crystalcove_gpio gpio_info;
> +
> +static void __crystalcove_irq_mask(int gpio, int mask)

I don't really like __doubleunderscore specifiers, can you use a
unique name or something instead.

> +{
> +       u8 mirqs0 = gpio < 8 ? MGPIO0IRQS0 : MGPIO1IRQS0;
> +       int offset = gpio < 8 ? gpio : gpio - 8;

Meh.
unsigned int offset = gpio%8;

> +
> +       if (mask)
> +               intel_soc_pmic_setb(mirqs0, 1 << offset);

Use
#include <linux/bitops.h>

intel_soc_pmic_setb(mirqs0, BIT(offset));

I really like the BIT() macros.

> +       else
> +               intel_soc_pmic_clearb(mirqs0, 1 << offset);

Dito.

> +static void __crystalcove_irq_type(int gpio, int type)
> +{
> +       u8 ctli = gpio < 8 ? GPIO0P0CTLI + gpio : GPIO1P0CTLI + (gpio - 8);

Do it like the first time instead, this is hard to read.

> +       type &= IRQ_TYPE_EDGE_BOTH;
> +       intel_soc_pmic_clearb(ctli, CTLI_INTCNT_BE);
> +
> +       if (type == IRQ_TYPE_EDGE_BOTH)
> +               intel_soc_pmic_setb(ctli, CTLI_INTCNT_BE);
> +       else if (type == IRQ_TYPE_EDGE_RISING)
> +               intel_soc_pmic_setb(ctli, CTLI_INTCNT_PE);
> +       else if (type & IRQ_TYPE_EDGE_FALLING)
> +               intel_soc_pmic_setb(ctli, CTLI_INTCNT_NE);
> +}
> +
> +static int crystalcove_gpio_direction_input(struct gpio_chip *chip,
> +                                           unsigned gpio)
> +{
> +       u8 ctlo = gpio < 8 ? GPIO0P0CTLO + gpio : GPIO1P0CTLO + (gpio - 8);

Dito.

> +
> +       intel_soc_pmic_writeb(ctlo, CTLO_INPUT_DEF);
> +       return 0;
> +}
> +
> +static int crystalcove_gpio_direction_output(struct gpio_chip *chip,
> +                                            unsigned gpio, int value)
> +{
> +       u8 ctlo = gpio < 8 ? GPIO0P0CTLO + gpio : GPIO1P0CTLO + (gpio - 8);

Dito. (etc for all)

> +
> +       intel_soc_pmic_writeb(ctlo, CTLO_OUTPUT_DEF | value);
> +       return 0;
> +}
> +
> +static int crystalcove_gpio_get(struct gpio_chip *chip, unsigned gpio)
> +{
> +       u8 ctli = gpio < 8 ? GPIO0P0CTLI + gpio : GPIO1P0CTLI + (gpio - 8);
> +
> +       return intel_soc_pmic_readb(ctli) & 0x1;
> +}
> +
> +static void crystalcove_gpio_set(struct gpio_chip *chip,
> +                                unsigned gpio, int value)
> +{
> +       u8 ctlo = gpio < 8 ? GPIO0P0CTLO + gpio : GPIO1P0CTLO + (gpio - 8);
> +
> +       if (value)
> +               intel_soc_pmic_setb(ctlo, 1);
> +       else
> +               intel_soc_pmic_clearb(ctlo, 1);
> +}
> +
> +static int crystalcove_irq_type(struct irq_data *data, unsigned type)
> +{
> +       struct crystalcove_gpio *cg = irq_data_get_irq_chip_data(data);
> +
> +       cg->trigger_type = type;
> +       cg->update |= UPDATE_TYPE;
> +
> +       return 0;
> +}
> +
> +static int crystalcove_gpio_to_irq(struct gpio_chip *chip, unsigned gpio)
> +{
> +       struct crystalcove_gpio *cg =
> +               container_of(chip, struct crystalcove_gpio, chip);
> +
> +       return cg->irq_base + gpio;
> +}

Nope. Use the irqdomain in chip->irqdomain.

> +static void crystalcove_bus_lock(struct irq_data *data)
> +{
> +       struct crystalcove_gpio *cg = irq_data_get_irq_chip_data(data);

This and all IRQ function callbacks needs to use a construct like
this:

struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
struct crystalcove_gpio *cg = container_of(gc, struct crystalcove_gpio, chip);

> +
> +       mutex_lock(&cg->buslock);
> +}
> +
> +static void crystalcove_bus_sync_unlock(struct irq_data *data)
> +{

The same here and for each irq function, as the irqchip helpers pass
struct gpio_chip* as irq_chip_data.

> +       struct crystalcove_gpio *cg = irq_data_get_irq_chip_data(data);
> +       int gpio = data->irq - cg->irq_base;
> +
> +       if (cg->update & UPDATE_TYPE)
> +               __crystalcove_irq_type(gpio, cg->trigger_type);
> +       if (cg->update & UPDATE_MASK)
> +               __crystalcove_irq_mask(gpio, cg->irq_mask);
> +       cg->update = 0;
> +
> +       mutex_unlock(&cg->buslock);
> +}
> +
> +static void crystalcove_irq_unmask(struct irq_data *data)
> +{
> +       struct crystalcove_gpio *cg = irq_data_get_irq_chip_data(data);
> +
> +       cg->irq_mask = 0;
> +       cg->update |= UPDATE_MASK;
> +}
> +
> +static void crystalcove_irq_mask(struct irq_data *data)
> +{
> +       struct crystalcove_gpio *cg = irq_data_get_irq_chip_data(data);
> +
> +       cg->irq_mask = 1;
> +       cg->update |= UPDATE_MASK;
> +}
> +
> +static struct irq_chip crystalcove_irqchip = {
> +       .name                   = "PMIC-GPIO",
> +       .irq_mask               = crystalcove_irq_mask,
> +       .irq_unmask             = crystalcove_irq_unmask,
> +       .irq_set_type           = crystalcove_irq_type,
> +       .irq_bus_lock           = crystalcove_bus_lock,
> +       .irq_bus_sync_unlock    = crystalcove_bus_sync_unlock,
> +};
> +
> +static irqreturn_t crystalcove_gpio_irq_handler(int irq, void *data)
> +{
> +       struct crystalcove_gpio *cg = data;

If you also use gpiochip_set_chained_irqchip() you need something like
this here:

struct gpio_chip *gc = data;
then  the container_of() construction.

> +       int pending;
> +       int gpio;
> +
> +       pending = intel_soc_pmic_readb(GPIO0IRQ) & 0xff;
> +       pending |= (intel_soc_pmic_readb(GPIO1IRQ) & 0xff) << 8;
> +       intel_soc_pmic_writeb(GPIO0IRQ, pending & 0xff);
> +       intel_soc_pmic_writeb(GPIO1IRQ, (pending >> 8) & 0xff);
> +
> +       local_irq_disable();
> +       for (gpio = 0; gpio < cg->chip.ngpio; gpio++)
> +               if (pending & (1 << gpio))
> +                       generic_handle_irq(cg->irq_base + gpio);
> +       local_irq_enable();
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static void crystalcove_gpio_dbg_show(struct seq_file *s,
> +                                     struct gpio_chip *chip)
> +{
> +       struct crystalcove_gpio *cg =
> +               container_of(chip, struct crystalcove_gpio, chip);
> +       int gpio, offset;
> +       u8 ctlo, ctli, mirqs0, mirqsx, irq;
> +
> +       for (gpio = 0; gpio < cg->chip.ngpio; gpio++) {
> +               offset = gpio < 8 ? gpio : gpio - 8;
> +               ctlo = intel_soc_pmic_readb(
> +                       (gpio < 8 ? GPIO0P0CTLO : GPIO1P0CTLO) + offset);
> +               ctli = intel_soc_pmic_readb(
> +                       (gpio < 8 ? GPIO0P0CTLI : GPIO1P0CTLI) + offset);
> +               mirqs0 = intel_soc_pmic_readb(
> +                       gpio < 8 ? MGPIO0IRQS0 : MGPIO1IRQS0);
> +               mirqsx = intel_soc_pmic_readb(
> +                       gpio < 8 ? MGPIO0IRQSX : MGPIO1IRQSX);
> +               irq = intel_soc_pmic_readb(
> +                       gpio < 8 ? GPIO0IRQ : GPIO1IRQ);
> +               seq_printf(s, " gpio-%-2d %s %s %s %s ctlo=%2x,%s %s %s\n",
> +                          gpio, ctlo & CTLO_DIR_OUT ? "out" : "in ",
> +                          ctli & 0x1 ? "hi" : "lo",
> +                          ctli & CTLI_INTCNT_NE ? "fall" : "    ",
> +                          ctli & CTLI_INTCNT_PE ? "rise" : "    ",
> +                          ctlo,
> +                          mirqs0 & (1 << offset) ? "s0 mask  " : "s0 unmask",
> +                          mirqsx & (1 << offset) ? "sx mask  " : "sx unmask",
> +                          irq & (1 << offset) ? "pending" : "       ");
> +       }
> +}

Looks helpful!

> +static int crystalcove_gpio_probe(struct platform_device *pdev)
> +{
> +       int irq = platform_get_irq(pdev, 0);
> +       struct crystalcove_gpio *cg = &gpio_info;
> +       int retval;
> +       int i;
> +       struct device *dev = intel_soc_pmic_dev();
> +
> +       mutex_init(&cg->buslock);
> +       cg->chip.label = "intel_crystalcove";
> +       cg->chip.direction_input = crystalcove_gpio_direction_input;
> +       cg->chip.direction_output = crystalcove_gpio_direction_output;
> +       cg->chip.get = crystalcove_gpio_get;
> +       cg->chip.set = crystalcove_gpio_set;
> +       cg->chip.to_irq = crystalcove_gpio_to_irq;

You don't define to_irq when using GPIOLIB_IRQCHIP.

> +       cg->chip.base = -1;
> +       cg->chip.ngpio = NUM_GPIO;
> +       cg->chip.can_sleep = 1;

true. Set it to true. This is a bool.

> +       cg->chip.dev = dev;
> +       cg->chip.dbg_show = crystalcove_gpio_dbg_show;
> +
> +       retval = gpiochip_add(&cg->chip);
> +       if (retval) {
> +               dev_warn(&pdev->dev, "add gpio chip error: %d\n", retval);
> +               goto out;
> +       }

Skip from here:

> +       cg->irq_base = irq_alloc_descs(-1, 0, NUM_GPIO, 0);
> +       if (cg->irq_base < 0) {
> +               retval = cg->irq_base;
> +               cg->irq_base = 0;
> +               dev_warn(&pdev->dev, "irq_alloc_descs error: %d\n", retval);
> +               goto out_remove_gpio;
> +       }
> +
> +       for (i = 0; i < NUM_GPIO; i++) {
> +               irq_set_chip_data(i + cg->irq_base, cg);
> +               irq_set_chip_and_handler_name(i + cg->irq_base,
> +                                             &crystalcove_irqchip,
> +                                             handle_simple_irq, "demux");
> +       }

To here, replace with:

gpiochip_irqchip_add(&cg->chip, &crystalcove_irqchip, cg->irq_base,
handle_simple_irq, IRQ_TYPE_NONE);

> +       retval = request_threaded_irq(irq, NULL, crystalcove_gpio_irq_handler,
> +                                     IRQF_ONESHOT, "crystalcove_gpio", cg);
> +
> +       if (retval) {
> +               dev_warn(&pdev->dev, "request irq failed: %d\n", retval);
> +               goto out_free_desc;
> +       }

Maybe use
gpiochip_set_chained_irqchip() here.

Yours,
Linus Walleij
