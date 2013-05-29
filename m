Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3E2Pcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:32:54 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:55753 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3E2Pcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:32:52 -0400
MIME-Version: 1.0
In-Reply-To: <1369412476-14245-8-git-send-email-james.hogan@imgtec.com>
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
	<1369412476-14245-8-git-send-email-james.hogan@imgtec.com>
Date: Wed, 29 May 2013 17:32:51 +0200
Message-ID: <CACRpkdb-JNbWxUiiJf=2Y8C0txcKBVoFjBCwkaMVq4my1nzHzQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] gpio-tz1090: add TZ1090 gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 6:21 PM, James Hogan <james.hogan@imgtec.com> wrote:

> Add a GPIO driver for the main GPIOs found in the TZ1090 (Comet) SoC.
> This doesn't include low-power GPIOs as they're controlled separately
> via the Powerdown Controller (PDC) registers.
>
> The driver is instantiated by device tree and supports interrupts for
> all GPIOs.

(...)

This is looking much better.

However I have some more improvement comments, due to new
knowledge. I am sorry about the moving target but it's not my fault...

Basically you should adopt the new style of referencing
flags using the preprocessor.

The examples can be found in the linux-next tree.

> +++ b/Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
(...)
> +  - #gpio-cells: Should be 2. The syntax of the gpio specifier used by client
> +    nodes should have the following values.
> +       <[phandle of the gpio controller node]
> +        [gpio number within the gpio bank]
> +        [gpio flags]>
> +
> +    Values for gpio specifier:
> +    - GPIO number: a value in the range 0 to 29.
> +    - GPIO flags: bit field of flags:
> +        1: active low

Reference flags from
#include <dt-bindings/gpio/gpio.h>

Then you can use the named constants:
GPIO_ACTIVE_HIGH, GPIO_ACTIVE_LOW

(...)
> +  - #interrupt-cells: Should be 2. The syntax of the interrupt specifier used by
> +    client nodes should have the following values.
> +       <[phandle of the interurupt controller]
> +        [gpio number within the gpio bank]
> +        [irq flags]>
> +
> +    Values for irq specifier:
> +    - GPIO number: a value in the range 0 to 29
> +    - IRQ flags: value to describe edge and level triggering
> +        1: trigger on rising edge
> +        2: trigger on falling edge
> +        3: trigger on both rising and falling edges
> +        4: trigger when high
> +        8: trigger when low

This goes here as well.
#include <dt-bindings/interrupt-controller/irq.h>

Then you can use:
IRQ_TYPE_NONE. IRQ_TYPE_EDGE_RISING (etc)

> +       gpios: gpio-controller@02005800 {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               compatible = "img,tz1090-gpio";
> +               reg = <0x02005800 0x90>;
> +
> +               /* bank 0 with an interrupt */
> +               gpios0: bank@0 {
> +                       #gpio-cells = <2>;
> +                       #interrupt-cells = <2>;
> +                       reg = <0>;
> +                       interrupts = <13 4 /* level */>;

And it will look like:
interrupts = <13 IRQ_TYPE_LEVEL_HIGH>;

Which is way easier to understand and you no longer
need to insert comments to explain things.

(...)
> +++ b/drivers/gpio/gpio-tz1090.c

(...)
> +/* REG_GPIO_IRQ_PLRT */
> +#define GPIO_POLARITY_LOW      0
> +#define GPIO_POLARITY_HIGH     1
> +
> +/* REG_GPIO_IRQ_TYPE */
> +#define GPIO_LEVEL_TRIGGERED   0
> +#define GPIO_EDGE_TRIGGERED    1

Why does the comment start with REG_* but not the actual
definition?

(...)
> +/* caller must hold LOCK2 */
> +static inline void _tz1090_gpio_mod_bit(struct tz1090_gpio_bank *bank,
> +                                       unsigned int reg_offs,
> +                                       unsigned int offset,
> +                                       int val)
> +{
> +       u32 value;
> +
> +       value = tz1090_gpio_read(bank, reg_offs);
> +       value &= ~BIT(offset);
> +       value |= !!val << offset;

I can't parse that last line, it is equivalent to writing:

if (val)
    value |= BIT(offset);

Which I think is easier to understand.


> +/* set polarity to trigger on next edge, whether rising or falling */
> +static void tz1090_gpio_irq_next_edge(struct tz1090_gpio_bank *bank,
> +                                     unsigned int offset)
> +{
> +       unsigned int value_p, value_i;
> +       int lstat;
> +
> +       __global_lock2(lstat);
> +       /* irq_polarity[offset] = !input[offset] */

This comments probably need to be a bit more verbose, like explain
to readers what is happening here.

> +       value_i = ~tz1090_gpio_read(bank, REG_GPIO_DIN);
> +       value_p = tz1090_gpio_read(bank, REG_GPIO_IRQ_PLRT);
> +       value_p &= ~BIT(offset);
> +       value_p |= value_i & BIT(offset);
> +       tz1090_gpio_write(bank, REG_GPIO_IRQ_PLRT, value_p);
> +       __global_unlock2(lstat);
> +}

This looks like it'll work though, nice!

(...)
> +static struct of_device_id tz1090_gpio_of_match[] = {
> +       { .compatible = "img,tz1090-gpio" },
> +       { },
> +};

(...)
> +postcore_initcall(tz1090_gpio_init);

Is it really necessary to have this so early?

Apart from these remarks it is looking very good.

Yours,
Linus Walleij
