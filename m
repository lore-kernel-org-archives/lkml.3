Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaCaKiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:38:13 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61493 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaCaKiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:38:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140308114401.GK3327@book.gsilab.sittig.org>
References: <1393842463-5206-1-git-send-email-thloh@altera.com>
	<20140308114401.GK3327@book.gsilab.sittig.org>
Date: Mon, 31 Mar 2014 18:38:08 +0800
X-Google-Sender-Auth: XlqFqurhwinTe87uTLJANErtSCc
Message-ID: <CAOLUe6akGWn24r3Hq16m-fPq+djO4yrkJtUi7g54TN_km_X+zg@mail.gmail.com>
Subject: Re: [PATCH V7 1/1] drivers/gpio: Altera soft IP GPIO driver and
 devicetree binding
From: Tien Hock Loh <thloh@altera.com>
To: Gerhard Sittig <gsi@denx.de>
Cc: Tien Hock Loh <thloh@altera.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        Mark Rutland <mark.rutland@arm.com>, ijc+devicetree@hellion.org.uk,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        dinguyen@altera.com, "lftan@altera.com" <lftan@altera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 8, 2014 at 7:44 PM, Gerhard Sittig <gsi@denx.de> wrote:
> On Mon, Mar 03, 2014 at 18:27 +0800, thloh@altera.com wrote:
>>
>> From: Tien Hock Loh <thloh@altera.com>
>>
>> Add driver support for Altera GPIO soft IP, including interrupts and I/O.
>> Tested on Altera CV SoC board using dipsw and LED using LED framework.
>>
>> Signed-off-by: Tien Hock Loh <thloh@altera.com>
>> ---
>>  .../devicetree/bindings/gpio/gpio-altera.txt       |  44 +++
>>  drivers/gpio/Kconfig                               |   7 +
>>  drivers/gpio/Makefile                              |   1 +
>>  drivers/gpio/gpio-altera.c                         | 419 +++++++++++++++++++++
>>  4 files changed, 471 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-altera.txt
>>  create mode 100644 drivers/gpio/gpio-altera.c
>
> Let's see.  A v7, i.e. quite some iterations done, and still
> whitespace issues, and not a single line of changelogs.  Not
> exactly an invitation for reviewers to spend their time on it.
> It's hard to tell which feedback was received before, and what of
> it has been addressed.

Noted. I'll be sure to put changelogs and fix all the whitespace issues.

>
> Aren't binding patches to be separate (and first) in series these
> days, while driver adjustment or introduction then follows to
> implement what was specified?

OK. I'll split the patch to two with DT bindings as the first one.

>
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
>> @@ -0,0 +1,44 @@
>> +Altera GPIO controller bindings
>> +
>> +Required properties:
>> +- compatible:
>> +  - "altr,pio-1.0"
>> +- reg: Physical base address and length of the controller's registers.
>> +- #gpio-cells : Should be 1
>> +  - The first cell is the gpio offset number
>
> Will there never be any use of flags, that usually are kept in
> the second cell?  Can we tell for sure that one cell is enough?

 OK. I'll add a second cell and mark it as currently unused.

>
>> +- gpio-controller : Marks the device node as a GPIO controller.
>> +- #interrupt-cells : Should be 1.
>> +  - The first cell is the GPIO offset number within the GPIO controller.
>> +- interrupts: Specify the interrupt.
>> +- interrupt-controller: Mark the device node as an interrupt controller
>
> Is #interrupt-cells = <1> enough?  Are triggers fixed in the
> hardware?  A comment about it may prevent people asking
> questions.  (The motivation might be mentioned below, see the
> comment on the two "required properties" sections.)
>

Yes the triggers are fixed in the hardware. I'll add a comment on this.

> I'd sort the last three items differently.  'interrupts' is where
> the GPIO block is "a client" to the IRQ controller which it is
> connected to.  '#interrupt-cells' is the "server side" because
> the GPIO block is an IRQ controller and has the
> 'interrupt-controller' property.
>

I'm assuming the order should be:
"interrupt-controller", "interrupt-cells", "interrupts". Am I correct here?

>> +
>> +Altera GPIO specific required properties:
>
> This made me stop and wonder.  This is the "Altera GPIO
> controller bindings" document, and it has a "Required properties"
> section as well as an "Altera GPIO specific required properties"
> section?  Isn't this highly redundant, and confusing at the same
> time?
>

Noted. I were referring to how other binding docs works and they have
these "specific properties" header.
It seems I should just specify required properties and optional
properties. I'll lump them together.

>> +- altr,interrupt_trigger: Specifies the interrupt trigger type the GPIO
>> +  hardware is synthesized. This field is required if the Altera GPIO controller
>> +  used has IRQ enabled as the interrupt type is not software controlled,
>> +  but hardware synthesized. Required if GPIO is used as an interrupt
>> +  controller. The value is defined in <dt-bindings/interrupt-controller/irq.h>
>> +  Only the following flags are supported:
>> +    IRQ_TYPE_EDGE_RISING
>> +    IRQ_TYPE_EDGE_FALLING
>> +    IRQ_TYPE_EDGE_BOTH
>> +    IRQ_TYPE_LEVEL_HIGH
>> +
>> +Altera GPIO specific optional properties:
>> +- altr,gpio-bank-width: Width of the GPIO bank. This defines how many pins the
>> +  GPIO device has. Ranges between 1-32. Optional and defaults to 32 is not
>> +  specified.
>> +
>> +Example:
>> +
>> +gpio_altr: gpio@40000 {
>> +    compatible = "altr,pio-1.0";
>> +    reg = <0xff200000 0x10>;
>> +    interrupts = <0 45 4>;
>> +    altr,gpio-bank-width = <32>;
>> +    altr,interrupt_trigger = <IRQ_TYPE_EDGE_RISING>;
>> +    #gpio-cells = <1>;
>> +    gpio-controller;
>> +    #interrupt-cells = <1>;
>> +    interrupt-controller;
>> +};
>
> The node's address does not match the 'reg' property.  The
> interrupt trigger uses symbolic names, so could the 'interrupts'
> spec.  Examples should not assume an external 'interrupt-parent'
> but should list them for completeness.
>

Noted. I'll change the address.

>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -128,6 +128,13 @@ config GPIO_GENERIC_PLATFORM
>>       help
>>         Say yes here to support basic platform_device memory-mapped GPIO controllers.
>>
>> +config GPIO_ALTERA
>> +       tristate "Altera GPIO"
>> +       select IRQ_DOMAIN
>> +       depends on OF_GPIO
>> +       help
>> +         Say yes here to support the Altera PIO device.
>> +
>
> I guess checkpatch nags about the rather short help text.
> Tristate options probably should mention the opportunity to build
> a module, and by convention should state what the module's name
> then would be (which in total gets you the minimum number of help
> text lines as a byproduct).
>

Noted. I'll update this.

>> --- /dev/null
>> +++ b/drivers/gpio/gpio-altera.c
>> @@ -0,0 +1,419 @@
>> [ ... ]
>> +
>> +#include <linux/gpio.h>
>> +#include <linux/init.h>
>> +#include <linux/irqdomain.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/io.h>
>> +#include <linux/irq.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/of_gpio.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +
>> +#include <linux/irqchip/chained_irq.h>
>
> Includes should be alpha-sorted.  To detect duplicates, and to
> avoid or reduce conflicts.
>

Noted.

>> +
>> +#define ALTERA_GPIO_DATA             0x0
>> +#define ALTERA_GPIO_DIR                      0x4
>> +#define ALTERA_GPIO_IRQ_MASK         0x8
>> +#define ALTERA_GPIO_EDGE_CAP         0xc
>> +#define ALTERA_GPIO_OUTSET           0x10
>> +#define ALTERA_GPIO_OUTCLEAR         0x14
>
> OUTSET and OUTCLEAR are not used in the driver source.  You might
> as well drop their declarations (after all you are not declaring
> the register set layout here, but are just introducing magic
> offset numbers for some of the registers that the driver may
> access).
>

OK noted.

>> +static void altera_gpio_irq_unmask(struct irq_data *d)
>> +{
>> +     struct altera_gpio_chip *altera_gc = irq_data_get_irq_chip_data(d);
>> +     struct of_mm_gpio_chip *mm_gc = &altera_gc->mmchip;
>> +     unsigned long flags;
>> +     unsigned int intmask;
>
> I'd suggest <stdint.h> style fixed width data types (uint32_t) or
> their kernel equivalents (u32) for operations on fixed width
> peripheral registers.
>

OK. Noted.

>> +
>> +     spin_lock_irqsave(&altera_gc->gpio_lock, flags);
>> +     intmask = readl(mm_gc->regs + ALTERA_GPIO_IRQ_MASK);
>> +     /* Set ALTERA_GPIO_IRQ_MASK bit to unmask */
>> +     intmask |= BIT(irqd_to_hwirq(d));
>> +     writel(intmask, mm_gc->regs + ALTERA_GPIO_IRQ_MASK);
>> +     spin_unlock_irqrestore(&altera_gc->gpio_lock, flags);
>> +}
>
>> +static int altera_gpio_irq_set_type(struct irq_data *d,
>> +                             unsigned int type)
>> +{
>> +     struct altera_gpio_chip *altera_gc = irq_data_get_irq_chip_data(d);
>> +
>> +     if (type == IRQ_TYPE_NONE)
>> +             return 0;
>> +
>> +     if (type == IRQ_TYPE_LEVEL_HIGH &&
>> +     altera_gc->interrupt_trigger == IRQ_TYPE_LEVEL_HIGH) {
>> +             return 0;
>> +     } else {
>> +             if (type == IRQ_TYPE_EDGE_RISING &&
>> +             altera_gc->interrupt_trigger == IRQ_TYPE_EDGE_RISING)
>> +                     return 0;
>> +             else if (type == IRQ_TYPE_EDGE_FALLING &&
>> +             altera_gc->interrupt_trigger == IRQ_TYPE_EDGE_FALLING)
>> +                     return 0;
>> +             else if (type == IRQ_TYPE_EDGE_BOTH &&
>> +             altera_gc->interrupt_trigger == IRQ_TYPE_EDGE_BOTH)
>> +                     return 0;
>> +     }
>> +
>> +     return -EINVAL;
>> +}
>
> Whitespace issues here, obfuscating what's a condition and what
> what the instructions are.  Given that the bodies do 'return',
> the 'elses' may be unnecessary and could save indentation levels.
>

Noted. I'll fix this.

>> +static void altera_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
>> +{
>> +     struct altera_gpio_chip *altera_gc = irq_desc_get_handler_data(desc);
>> +     struct irq_chip *chip = irq_desc_get_chip(desc);
>> +     struct of_mm_gpio_chip *mm_gc = &altera_gc->mmchip;
>> +     unsigned long status;
>> +
>> +     int i;
>
> Several blocks of declarations?  Remove the empty line.
>
> And I'm really not a fan of mixing assignment instructions "this
> complex, beyond trivial initialization" with declarations.  But
> this style is rather popular. :(  Since this is a new driver,
> there is not reason to "continue" what others did before.
>

OK noted. I'll implement this correctly.

>> +
>> +     chained_irq_enter(chip, desc);
>> +     /* Handling for level trigger and edge trigger is different */
>> +     if (altera_gc->interrupt_trigger == IRQ_TYPE_LEVEL_HIGH) {
>> +             status = readl_relaxed(mm_gc->regs + ALTERA_GPIO_DATA);
>> +             status &= readl_relaxed(mm_gc->regs + ALTERA_GPIO_IRQ_MASK);
>> +
>> +             for (i = 0; i < mm_gc->gc.ngpio; i++) {
>> +                     if (status & BIT(i)) {
>> +                             generic_handle_irq(irq_find_mapping(
>> +                                     altera_gc->domain, i));
>> +                     }
>> +             }
>> +     } else {
>> +             while ((status =
>> +                     (readl_relaxed(mm_gc->regs + ALTERA_GPIO_EDGE_CAP) &
>> +                     readl_relaxed(mm_gc->regs + ALTERA_GPIO_IRQ_MASK)))) {
>> +                     writel_relaxed(status,
>> +                             mm_gc->regs + ALTERA_GPIO_EDGE_CAP);
>> +                     for (i = 0; i < mm_gc->gc.ngpio; i++) {
>> +                             if (status & BIT(i)) {
>> +                                     generic_handle_irq(irq_find_mapping(
>> +                                             altera_gc->domain, i));
>> +                             }
>> +                     }
>> +             }
>> +     }
>
> for_each_set_bit() might be more descriptive, save indentation
> levels, and could use availalbe CPU instructions.
>
> There are more whitespace issues here.
>
> And I'm afraid that use of _relaxed() accessors makes the driver
> depend on specific architectures, which should then reflect in
> the Kconfig dependencies.
>
> Given that we are not talking about a GPIO block that is
> contained in SoCs which implement a specific CPU, but instead
> talk about an IP block that is supposed to get implemented in
> FPGAs connected to arbitrary CPUs, I'd suggest to use more
> portable instructions.
>

I'll use for_each_set_bit() function as the iterator.
I'll fix the whitespace issue and run the check_patch before submitting again.
Yes. There are complains about using _relaxed(). I'll remove the
_relaxed() function and use just writel and readl.

>> +
>> +     chained_irq_exit(chip, desc);
>> +}
>
>
>> +int altera_gpio_probe(struct platform_device *pdev)
>> +{
>> +     struct device_node *node = pdev->dev.of_node;
>> +     int i, id, reg, ret;
>> +     struct altera_gpio_chip *altera_gc = devm_kzalloc(&pdev->dev,
>> +                             sizeof(*altera_gc), GFP_KERNEL);
>> +     if (altera_gc == NULL) {
>> +             pr_err("%s: out of memory\n", node->full_name);
>> +             return -ENOMEM;
>> +     }
>> +     altera_gc->domain = 0;
>
> This really needs a whitespace cleanup.  I do suggest to clearly
> separate declarations and instructions.  This reduces diffs upon
> further maintenance, and really isn't that expensive in terms of
> typing characters (which should not be a criterion during
> development anyway).
>

Noted.

>> +
>> +     spin_lock_init(&altera_gc->gpio_lock);
>> +
>> +     id = pdev->id;
>> +
>> +     if (of_property_read_u32(node, "altr,gpio-bank-width", &reg))
>> +             /*By default assume full GPIO controller*/
>> +             altera_gc->mmchip.gc.ngpio = 32;
>> +     else
>> +             altera_gc->mmchip.gc.ngpio = reg;
>> +
>> +     if (altera_gc->mmchip.gc.ngpio > 32) {
>> +             dev_warn(&pdev->dev,
>> +                     "ngpio is greater than 32, defaulting to 32\n");
>> +             altera_gc->mmchip.gc.ngpio = 32;
>> +     }
>
> Does this "maximum number of supported pins per bank" deserve a
> symbolic name?  The "32' is repeated here several times within a
> few lines.
>

OK I'll add a macro to the number.

>> +
>> +     altera_gc->mmchip.gc.direction_input    = altera_gpio_direction_input;
>> +     altera_gc->mmchip.gc.direction_output   = altera_gpio_direction_output;
>> +     altera_gc->mmchip.gc.get                = altera_gpio_get;
>> +     altera_gc->mmchip.gc.set                = altera_gpio_set;
>> +     altera_gc->mmchip.gc.to_irq             = altera_gpio_to_irq;
>> +     altera_gc->mmchip.gc.owner              = THIS_MODULE;
>> +
>> +     ret = of_mm_gpiochip_add(node, &altera_gc->mmchip);
>> +     if (ret) {
>> +             dev_err(&pdev->dev, "Failed adding memory mapped gpiochip\n");
>> +             return ret;
>> +     }
>> +
>> +     platform_set_drvdata(pdev, altera_gc);
>> +
>> +     altera_gc->mapped_irq = irq_of_parse_and_map(node, 0);
>> +
>> +     if (!altera_gc->mapped_irq)
>> +             goto skip_irq;
>> +
>> +     altera_gc->domain = irq_domain_add_linear(node,
>> +             altera_gc->mmchip.gc.ngpio, &altera_gpio_irq_ops, altera_gc);
>> +
>> +     if (!altera_gc->domain) {
>> +             ret = -ENODEV;
>> +             goto dispose_irq;
>> +     }
>> +
>> +     for (i = 0; i < altera_gc->mmchip.gc.ngpio; i++)
>> +             irq_create_mapping(altera_gc->domain, i);
>> +
>> +     if (of_property_read_u32(node, "altr,interrupt_type", &reg)) {
>> +             ret = -EINVAL;
>> +             dev_err(&pdev->dev,
>> +                     "altr,interrupt_type value not set in device tree\n");
>> +             goto teardown;
>> +     }
>> +     altera_gc->interrupt_trigger = reg;
>> +
>> +     irq_set_handler_data(altera_gc->mapped_irq, altera_gc);
>> +     irq_set_chained_handler(altera_gc->mapped_irq, altera_gpio_irq_handler);
>> +
>> +     return 0;
>
> The 'skip_irq' label should be here.  It's really not an
> exceptional case or error path, it's just a shortcut for the
> absence of an optional feature.
>

OK noted.

>> +
>> +teardown:
>> +     irq_domain_remove(altera_gc->domain);
>> +dispose_irq:
>> +     irq_dispose_mapping(altera_gc->mapped_irq);
>> +     WARN_ON(gpiochip_remove(&altera_gc->mmchip.gc) < 0);
>> +
>> +     pr_err("%s: registration failed with status %d\n",
>> +             node->full_name, ret);
>> +
>> +     return ret;
>> +skip_irq:
>> +     return 0;
>> +}
>
>
> virtually yours
> Gerhard Sittig
> --
> DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
> HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
> Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
