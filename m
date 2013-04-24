Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3DXNPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 09:15:19 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:61869 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab3DXNPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 09:15:17 -0400
MIME-Version: 1.0
In-Reply-To: <201304191709.r3JH9w0R017814@latitude>
References: <201304191709.r3JH9w0R017814@latitude>
Date: Wed, 24 Apr 2013 15:15:16 +0200
Message-ID: <CACRpkdaSLGmmvWYG6ez1h90e=OZXq4yqtUFXKnTpUWG916LmjA@mail.gmail.com>
Subject: Re: [NEW DRIVER V6 5/7] drivers/gpio: DA9058 GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 6:56 PM, Anthony Olech
<anthony.olech.opensource@diasemi.com> wrote:

> This patch is relative to next-20130419 of linux-next
>
> This is the GPIO component driver of the Dialog DA9058 PMIC.
> This driver is just one component of the whole DA9058 PMIC driver.
> It depends on the CORE component driver of the DA9058 MFD.
> The meaning of the PMIC register 21 bits 1 and 5 has been documented
> in the driver source.
>
> Changes relative to V5 of this patch:
> - rebased to next-20130419 in git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> - removed redundant #include <linux/mfd/da9058/version.h>
> - corrected dates on copyright statements
>
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> Signed-off-by: David Dajun Chen <david.chen@diasemi.com>

Sorry for slow review ...

> +struct da9058_gpio {
> +       struct da9058 *da9058;
> +       struct platform_device *pdev;
> +       struct gpio_chip gp;
> +       struct mutex lock;
> +       int irq_0;
> +       int irq_1;

Why are you keeping thes two numbers here? Use the irqdomain
to contain irq mappings, this is just confusion things. (See review
commens further below.)

> +       u8 inp_config;
> +       u8 out_config;

> +static int da9058_gpio_get(struct gpio_chip *gc, unsigned offset)
> +{
> +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> +       struct da9058 *da9058 = gpio->da9058;
> +       unsigned int gpio_level;
> +       int ret;
> +
> +       if (offset > 1)
> +               return -EINVAL;

So we have only two pins, OK that's said in Kconfig too...

(...)
> +static void da9058_gpio_set(struct gpio_chip *gc, unsigned offset, int value)
> +{
> +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> +       struct da9058 *da9058 = gpio->da9058;
> +       unsigned int gpio_cntrl;
> +       int ret;
> +
> +       if (offset > 1) {
> +               dev_err(da9058->dev,
> +                       "Failed to set GPIO%d output=%d because illegal GPIO\n",
> +                       offset, value);
> +               return;
> +       }

Here you have an error print, pls insert that on the get function too
then.

(...)
> +       if (offset) {
> +

I would put a comment here like
/* pin 1 clause */

Maybe it's more logical to have if (!offset) and handle pin
0 first, then pin 1 in the else clause?

> +               ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG, &gpio_cntrl);
> +               if (ret)
> +                       goto exit;
> +               gpio->out_config &= ~0x80;
> +               gpio->out_config |= value ? 0x80 : 0x00;
> +
> +               if (!(gpio_cntrl & 0x20))       /* an INP pin */
> +                       goto exit;

Please use #define to define these magic bits.
Something like this:

#include <linux/bitops.h>

#define DA9058_GPIO0_VAL  BIT(3)
#define DA9058_GPIO0_INOUT  BIT(1)
#define DA9058_GPIO1_VAL  BIT(7)
#define DA9058_GPIO1_INOUT  BIT(5)

(etc, so we see what all bits are for)

then use these defines in the code...

> +
> +               gpio_cntrl &= ~0xF0;
> +               gpio_cntrl |= 0xF0 & gpio->out_config;
> +
> +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);
> +       } else {
> +

I would put a comment here like
/* pin 0 clause */


> +               ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG, &gpio_cntrl);
> +               if (ret)
> +                       goto exit;
> +               gpio->out_config &= ~0x08;
> +               gpio->out_config |= value ? 0x08 : 0x00;
> +
> +               if (!(gpio_cntrl & 0x02))       /* an INP pin */
> +                       goto exit;

Magic bits, see above.

(...)
> +/*
> + *  da9058_gpio_to_irq is an implementation of the GPIO Hook
> + *  @to_irq: supporting non-static gpio_to_irq() mappings
> + *  whose implementation may not sleep. This hook is called
> + *  when setting up the threaded GPIO irq handler.
> + */
> +static int da9058_gpio_to_irq(struct gpio_chip *gc, u32 offset)
> +{
> +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> +       struct da9058 *da9058 = gpio->da9058;
> +
> +       if (offset > 1)
> +               return -EINVAL;
> +
> +       if (offset)
> +               return da9058_to_virt_irq_num(da9058, gpio->irq_1);
> +       else
> +               return da9058_to_virt_irq_num(da9058, gpio->irq_0);
> +}

OK, if the DA9058 core is using irqdomain.

> +       if (offset) {
> +               u8 debounce_bits = debounce ? 0x80 : 0x00;

Is this really correct??

In earlier code you use bit 7 to set the value!

This is partly why I ask you to use #defines for the bits:
less risk to do things wrong by e.g. copy/paste bugs.

> +               gpio->inp_config &= ~0x08;
> +               gpio->inp_config |= debounce_bits;

Dito.

(...)
> +static int da9058_gpio_probe(struct platform_device *pdev)
(...)
> +       /*
> +        * INP configured pins:
> +        *     9 == DebounceOn+ActiceLowPullUp
> +        *
> +        * OUT configured pins:
> +        *     7 == PushPull+ExternalPullUpToVDDIO
> +        *     3 == PushPull+InternalPullUpToVDDIO
> +        *     2 == OpenDrain+InternalPullUpToVDDIO
> +        */
> +
> +       gpio->inp_config = 0x99;
> +       gpio->out_config = 0x77;

Again here you should #define the bits and | or them together
instead of using comments to clarify it.

This is pinctrl basically but since you seem to hardcode it it can
be in the GPIO subsystem anyway.

Yours,
Linus Walleij
