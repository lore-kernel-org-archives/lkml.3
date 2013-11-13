Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab3KMXt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:49:28 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:44042 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3KMXtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:49:18 -0500
MIME-Version: 1.0
In-Reply-To: <1777251.JReTVdX0Pd@avalon>
References: <20131106234737.8971.37405.sendpatchset@w520>
	<1777251.JReTVdX0Pd@avalon>
Date: Thu, 14 Nov 2013 08:49:16 +0900
Message-ID: <CANqRtoRkMO8Xcno+ZPDPddPp3FNHT_E+6B=i7K_ixELzseRcFw@mail.gmail.com>
Subject: Re: [PATCH] gpio: Renesas RZ GPIO driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Simon Horman [Horms]" <horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, Nov 13, 2013 at 9:03 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> Thank you for the patch.
>
> Please read below for a couple of comments in addition to Linus' review.
>
> On Thursday 07 November 2013 08:47:37 Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> This patch adds a GPIO driver for the RZ series of SoCs from
>> Renesas. The driver can be used as platform device with dynamic
>> or static GPIO assignment or via DT using dynamic GPIOs.
>>
>> The hardware allows control of GPIOs in blocks of up to 16 pins,
>> and once device may span multiple blocks. Interrupts are not
>> included in this hardware block, if interrupts are needed then
>> the PFC needs to be configured to a IRQ pin function which is
>> handled by the GIC hardware.
>>
>> Tested with yet-to-be-posted platform device and DT devices on
>> r7s72100 and Genmai using LEDs, DIP switches and I2C bitbang.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>> ---
>>
>>  drivers/gpio/Kconfig                  |    6
>>  drivers/gpio/Makefile                 |    1
>>  drivers/gpio/gpio-rz.c                |  241 ++++++++++++++++++++++++++++++
>>  include/linux/platform_data/gpio-rz.h |   13 +
>>  4 files changed, 261 insertions(+)
>>
>> --- 0001/drivers/gpio/Kconfig
>> +++ work/drivers/gpio/Kconfig 2013-11-06 12:07:13.000000000 +0900
>> @@ -230,6 +230,12 @@ config GPIO_RCAR
>>       help
>>         Say yes here to support GPIO on Renesas R-Car SoCs.
>>
>> +config GPIO_RZ
>> +     tristate "Renesas RZ GPIO"
>> +     depends on ARM
>> +     help
>> +       Say yes here to support GPIO on Renesas RZ SoCs.
>> +
>>  config GPIO_SAMSUNG
>>       bool
>>       depends on PLAT_SAMSUNG
>> --- 0001/drivers/gpio/Makefile
>> +++ work/drivers/gpio/Makefile        2013-11-06 12:07:13.000000000 +0900
>> @@ -62,6 +62,7 @@ obj-$(CONFIG_GPIO_PXA)              += gpio-pxa.o
>>  obj-$(CONFIG_GPIO_RC5T583)   += gpio-rc5t583.o
>>  obj-$(CONFIG_GPIO_RDC321X)   += gpio-rdc321x.o
>>  obj-$(CONFIG_GPIO_RCAR)              += gpio-rcar.o
>> +obj-$(CONFIG_GPIO_RZ)                += gpio-rz.o
>>  obj-$(CONFIG_GPIO_SAMSUNG)   += gpio-samsung.o
>>  obj-$(CONFIG_ARCH_SA1100)    += gpio-sa1100.o
>>  obj-$(CONFIG_GPIO_SCH)               += gpio-sch.o
>> --- /dev/null
>> +++ work/drivers/gpio/gpio-rz.c       2013-11-06 14:20:02.000000000 +0900
>> @@ -0,0 +1,241 @@
>> +/*
>> + * RZ GPIO Support - Ports
>> + *
>> + *  Copyright (C) 2013 Magnus Damm
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
>> USA
>> + */
>
> You can ditch the last two paragraphs.

Ok!

>> +
>> +#include <linux/init.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/ioport.h>
>> +#include <linux/io.h>
>> +#include <linux/bitops.h>
>> +#include <linux/err.h>
>> +#include <linux/gpio.h>
>> +#include <linux/slab.h>
>> +#include <linux/module.h>
>> +#include <linux/pinctrl/consumer.h>
>> +#include <linux/platform_data/gpio-rz.h>
>
> Could you please sort the headers alphabetically ?

Sure, good idea.

>> +
>> +enum { REG_PSR, REG_PPR, REG_PMSR, REG_NR };
>> +
>> +struct rz_gpio_priv {
>> +     void __iomem *io[REG_NR];
>> +     struct gpio_chip gpio_chip;
>> +};
>> +
>> +static inline unsigned long rz_gpio_read_ppr(struct rz_gpio_priv *p, int
>> offs)
>> +{
>> +     unsigned long msk = BIT(offs % RZ_GPIOS_PER_PORT);
>> +     int offset = (offs / RZ_GPIOS_PER_PORT) * 4;
>
> offs and offset are unsigned, you can make them unsigned int.

Ok!

>> +     return ioread32(p->io[REG_PPR] + offset) & msk;
>
> I believe you should return !!(...) here, or in the caller, to make sure the
> gpio_get_value() operation returns either 0 or 1. I would do it here and
> return a u32 instead of unsigned long.

I disagree with the !! because it is just pure overhead, please see
the __gpio_get_value() comment, it says returning zero or nonzero. So
I left this portion as-is.

>> +}
>> +
>> +static inline void rz_gpio_write(struct rz_gpio_priv *p, int reg, int offs,
>> +                              bool value)
>> +{
>> +     unsigned long msk = BIT(offs % RZ_GPIOS_PER_PORT);
>> +     int offset = (offs / RZ_GPIOS_PER_PORT) * 4;
>
> offs and offset are unsigned here too.

Ok!

>> +
>> +     /* upper 16 bits contain mask and lower 16 actual value */
>> +     iowrite32(value ? (msk | (msk << 16)) : (msk << 16),
>
> I would have written it has
>
> (value ? msk : 0) | (msk << 16)
>
> but I suppose gcc is smart enough to optimize this.

I left this as-is.

>> +               p->io[reg] + offset);
>> +}
>> +
>> +static inline struct rz_gpio_priv *gpio_to_priv(struct gpio_chip *chip)
>> +{
>> +     return container_of(chip, struct rz_gpio_priv, gpio_chip);
>> +}
>> +
>> +static int rz_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
>> +{
>> +     /* Set bit in PM register via PMSR to disable output */
>> +     rz_gpio_write(gpio_to_priv(chip), REG_PMSR, offset, true);
>> +     return 0;
>> +}
>> +
>> +static int rz_gpio_get(struct gpio_chip *chip, unsigned offset)
>> +{
>> +     /* Get bit from PPR register to determine pin state */
>> +     return (int)(rz_gpio_read_ppr(gpio_to_priv(chip), offset));
>> +}
>> +
>> +static void rz_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
>> +{
>> +     /* Set bit in P register via PSR to control output */
>> +     rz_gpio_write(gpio_to_priv(chip), REG_PSR, offset, !!value);
>> +}
>> +
>> +static int rz_gpio_direction_output(struct gpio_chip *chip, unsigned
>> offset,
>> +                                int value)
>> +{
>> +     /* Write GPIO value to output before selecting output mode of pin */
>> +     rz_gpio_set(chip, offset, value);
>> +
>> +     /* Clear bit in PM register via PMSR to enable output */
>> +     rz_gpio_write(gpio_to_priv(chip), REG_PMSR, offset, false);
>> +     return 0;
>> +}
>> +
>> +static int rz_gpio_request(struct gpio_chip *chip, unsigned offset)
>> +{
>> +     return pinctrl_request_gpio(chip->base + offset);
>> +}
>> +
>> +static void rz_gpio_free(struct gpio_chip *chip, unsigned offset)
>> +{
>> +     pinctrl_free_gpio(chip->base + offset);
>> +
>> +     /* Set the GPIO as an input to ensure that the next GPIO request won't
>> +     * drive the GPIO pin as an output.
>> +     */
>> +     rz_gpio_direction_input(chip, offset);
>> +}
>> +
>> +static int rz_gpio_probe(struct platform_device *pdev)
>> +{
>> +     struct gpio_rz_config *pdata = dev_get_platdata(&pdev->dev);
>> +     struct rz_gpio_priv *p;
>> +     struct resource *io[3];
>> +     struct gpio_chip *gpio_chip;
>> +     struct device_node *np = pdev->dev.of_node;
>> +     struct of_phandle_args args;
>> +     int number_of_pins, gpio_base;
>> +     int k, nr;
>
> unsigned ?

Ok!

> By the way, what's wrong with i as a loop index ? :-)

Nothing, but I left it as-is anyway! =)

>> +     int ret;
>> +
>> +     p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
>> +     if (!p) {
>> +             dev_err(&pdev->dev, "failed to allocate driver data\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     for (k = 0; k < REG_NR; k++)
>> +             io[k] = platform_get_resource(pdev, IORESOURCE_MEM, k);
>> +
>> +     /* In case of 3 resources PSR, PPR and PMSR order is expected */
>> +     if (io[REG_PSR] && io[REG_PPR] && io[REG_PMSR]) {
>> +             nr = REG_NR;
>> +     } else {
>> +             /* A single resource is also acceptable (PPR only) */
>> +             if (io[0] && !io[1] && !io[2]) {
>> +                     nr = 1;
>> +             } else {
>> +                     dev_err(&pdev->dev, "missing IOMEM\n");
>> +                     return -EINVAL;
>> +             }
>> +     }
>> +
>> +     for (k = 0; k < nr; k++) {
>> +             p->io[k] = devm_ioremap_nocache(&pdev->dev, io[k]->start,
>> +                                             resource_size(io[k]));
>
> You can use devm_ioremap_resource. The function prints an error on failure so
> you can remove the dev_err() call below. Make sure to check the return value
> with IS_ERR() and return PTR_ERR() insted of the fixed -ENXIO error.

Good idea, this indeed makes the code nicer.

I've included these changes in V2 that I posted a little while ago.

Thanks for your review.

Cheers,

/ magnus
