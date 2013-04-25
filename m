Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460Ab3DYXBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 19:01:04 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:59926 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757640Ab3DYXBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 19:01:02 -0400
MIME-Version: 1.0
In-Reply-To: <1366727607-27444-7-git-send-email-james.hogan@imgtec.com>
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
	<1366727607-27444-7-git-send-email-james.hogan@imgtec.com>
Date: Fri, 26 Apr 2013 01:01:01 +0200
Message-ID: <CACRpkdbzYpQqe4yabAwFSAG2rPstT8jM_--LssHi=ttUYtu1ug@mail.gmail.com>
Subject: Re: [PATCH 6/8] gpio-tz1090: add TZ1090 gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 4:33 PM, James Hogan <james.hogan@imgtec.com> wrote:

> Add a GPIO driver for the main GPIOs found in the TZ1090 (Comet) SoC.
> This doesn't include low-power GPIOs as they're controlled separately
> via the Powerdown Controller (PDC) registers.
>
> The driver is instantiated by device tree and supports interrupts for
> all GPIOs.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-doc@vger.kernel.org

(...)
> +  - #gpio-cells: Should be 2. The syntax of the gpio specifier used by client
> +    nodes should have the following values.
> +       <[phandle of the gpio controller node]
> +        [gpio number within the gpio bank]
> +        [standard Linux gpio flags]>

So when someone using this device tree for Symbian or Windows
Mobile start to work, what does "standard Linux gpio flags" tell them?

> +    Values for gpio specifier:
> +    - GPIO number: a value in the range 0 to 29.
> +    - GPIO flags: standard Linux GPIO flags as found in of_gpio.h

Dito. Linux-specifics are not generally allowed in device trees,
and if they are anyway used they shall be prefixed with "linux,"

> +  Bank subnode optional properties:
> +  - gpio-ranges: Mapping to pin controller pins

Here you seem to use DT GPIO ranges, yet the pinctrl driver registers
some GPIO range, care to explain how that fits together?

> +  - #interrupt-cells: Should be 2. The syntax of the interrupt specifier used by
> +    client nodes should have the following values.
> +       <[phandle of the interurupt controller]
> +        [gpio number within the gpio bank]
> +        [standard Linux irq flags]>
> +
> +    Values for irq specifier:
> +    - GPIO number: a value in the range 0 to 29
> +    - IRQ flags: standard Linux IRQ flags for edge and level triggering

Same comments.

(...)

+#include <asm/global_lock.h>

What on earth is that. I can only fear it. I don't like the
looks of that thing.

(...)
> +/* Convenience register accessors */
> +static void tz1090_gpio_write(struct tz1090_gpio_bank *bank,
> +                             unsigned int reg_offs, u32 data)
> +{
> +       iowrite32(data, bank->reg + reg_offs);
> +}
> +
> +static u32 tz1090_gpio_read(struct tz1090_gpio_bank *bank,
> +                           unsigned int reg_offs)
> +{
> +       return ioread32(bank->reg + reg_offs);
> +}

The pinctrl driver included the keyword "inline" for these so
this should be consistent and do that too.

(...)
> +static void tz1090_gpio_clear_bit(struct tz1090_gpio_bank *bank,
> +                                 unsigned int reg_offs,
> +                                 unsigned int offset)
> +{
> +       int lstat;
> +
> +       __global_lock2(lstat);
> +       _tz1090_gpio_clear_bit(bank, reg_offs, offset);
> +       __global_unlock2(lstat);
> +}

This global lock scares me.

+static inline void _tz1090_gpio_clear_bit(struct tz1090_gpio_bank *bank,
+                                         unsigned int reg_offs,
+                                         unsigned int offset)
+{
+       u32 value;
+
+       value = tz1090_gpio_read(bank, reg_offs);
+       value &= ~(0x1 << offset);

I usually do this:

#include <linux/bitops.h>

value &= ~BIT(offset);

+       tz1090_gpio_write(bank, reg_offs, value);
+}

> +/* caller must hold LOCK2 */
> +static inline void _tz1090_gpio_set_bit(struct tz1090_gpio_bank *bank,
> +                                       unsigned int reg_offs,
> +                                       unsigned int offset)
> +{
> +       u32 value;
> +
> +       value = tz1090_gpio_read(bank, reg_offs);
> +       value |= 0x1 << offset;

I usually do this:

#include <linux/bitops.h>

value |= BIT(offset);

> +/* caller must hold LOCK2 */
> +static inline void _tz1090_gpio_mod_bit(struct tz1090_gpio_bank *bank,
> +                                       unsigned int reg_offs,
> +                                       unsigned int offset,
> +                                       int val)

If val is used as it is, make it a bool.

> +{
> +       u32 value;
> +
> +       value = tz1090_gpio_read(bank, reg_offs);
> +       value &= ~(0x1 << offset);
> +       value |= !!val << offset;

You're claming val to [0,1] obviously it's a bool.

> +       tz1090_gpio_write(bank, reg_offs, value);
> +}

(...)
> +static int tz1090_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct tz1090_gpio_bank *bank = to_bank(chip);
> +       int ret;
> +
> +       ret = pinctrl_request_gpio(chip->base + offset);
> +       if (ret)
> +               return ret;
> +
> +       tz1090_gpio_set_bit(bank, REG_GPIO_DIR, offset);
> +       tz1090_gpio_set_bit(bank, REG_GPIO_BIT_EN, offset);
> +
> +       return 0;
> +}

This is nice, it just glues smoothly into pinctrl here.

> +static void tz1090_gpio_free(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct tz1090_gpio_bank *bank = to_bank(chip);
> +
> +       pinctrl_free_gpio(chip->base + offset);
> +
> +       tz1090_gpio_clear_bit(bank, REG_GPIO_BIT_EN, offset);
> +}

And here.

(...)
> +static int gpio_set_irq_type(struct irq_data *data, unsigned int flow_type)
> +{
> +       struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
> +       unsigned int type;
> +       unsigned int polarity;
> +
> +       switch (flow_type) {
> +       case IRQ_TYPE_EDGE_BOTH:
> +               type = GPIO_EDGE_TRIGGERED;
> +               polarity = GPIO_POLARITY_LOW;
> +               break;
> +       case IRQ_TYPE_EDGE_RISING:
> +               type = GPIO_EDGE_TRIGGERED;
> +               polarity = GPIO_POLARITY_HIGH;
> +               break;
> +       case IRQ_TYPE_EDGE_FALLING:
> +               type = GPIO_EDGE_TRIGGERED;
> +               polarity = GPIO_POLARITY_LOW;
> +               break;
> +       case IRQ_TYPE_LEVEL_HIGH:
> +               type = GPIO_LEVEL_TRIGGERED;
> +               polarity = GPIO_POLARITY_HIGH;
> +               break;
> +       case IRQ_TYPE_LEVEL_LOW:
> +               type = GPIO_LEVEL_TRIGGERED;
> +               polarity = GPIO_POLARITY_LOW;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       tz1090_gpio_irq_type(bank, data->hwirq, type);
> +       if (type == GPIO_LEVEL_TRIGGERED)
> +               __irq_set_handler_locked(data->irq, handle_level_irq);
> +       else
> +               __irq_set_handler_locked(data->irq, handle_edge_irq);
> +
> +       if (flow_type == IRQ_TYPE_EDGE_BOTH)
> +               tz1090_gpio_irq_next_edge(bank, data->hwirq);
> +       else
> +               tz1090_gpio_irq_polarity(bank, data->hwirq, polarity);
> +
> +       return 0;
> +}

This is also very nice and handling the toggling edge in
a working way.

Overall looking very nice, just needs som polishing, and I'm way
scared about that global lock.

Yours,
Linus Walleij
