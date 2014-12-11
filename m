Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbaLKBaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:30:12 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:12962 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaLKBaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:30:10 -0500
X-IronPort-AV: E=Sophos;i="5.07,554,1413270000"; 
   d="scan'208";a="52777711"
Message-ID: <5488F398.2000605@broadcom.com>
Date: Wed, 10 Dec 2014 17:30:00 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>, Scott Branden <sbranden@broadcom.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 2/5] gpio: Cygnus: add GPIO driver
References: <rjui@broadcom.com> <1418071319-11779-1-git-send-email-rjui@broadcom.com> <1418071319-11779-3-git-send-email-rjui@broadcom.com> <CAAVeFuJ875fvEwPbnc-Eewsw4Rp7hLbv7nXWBb=OgvLwhQBVvQ@mail.gmail.com>
In-Reply-To: <CAAVeFuJ875fvEwPbnc-Eewsw4Rp7hLbv7nXWBb=OgvLwhQBVvQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/10/2014 2:34 AM, Alexandre Courbot wrote:
> On Tue, Dec 9, 2014 at 5:41 AM, Ray Jui <rjui@broadcom.com> wrote:
>> This GPIO driver supports all 3 GPIO controllers in the Broadcom Cygnus
>> SoC. The 3 GPIO controllers are 1) the ASIU GPIO controller, 2) the
>> chipCommonG GPIO controller, and 3) the ALWAYS-ON GPIO controller
>>
>> Signed-off-by: Ray Jui <rjui@broadcom.com>
>> Reviewed-by: Scott Branden <sbranden@broadcom.com>
>> ---
>>   drivers/gpio/Kconfig           |   11 +
>>   drivers/gpio/Makefile          |    1 +
>>   drivers/gpio/gpio-bcm-cygnus.c |  705 ++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 717 insertions(+)
>>   create mode 100644 drivers/gpio/gpio-bcm-cygnus.c
>>
>> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
>> index 633ec21..3e3b0342 100644
>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -126,6 +126,17 @@ config GPIO_74XX_MMIO
>>              8 bits:     74244 (Input), 74273 (Output)
>>              16 bits:    741624 (Input), 7416374 (Output)
>>
>> +config GPIO_BCM_CYGNUS
>> +       bool "Broadcom Cygnus GPIO support"
>> +       depends on ARCH_BCM_CYGNUS && OF_GPIO
>> +       help
>> +         Say yes here to turn on GPIO support for Broadcom Cygnus SoC
>> +
>> +         The Broadcom Cygnus SoC has 3 GPIO controllers including the ASIU
>> +         GPIO controller (ASIU), the chipCommonG GPIO controller (CCM), and
>> +         the always-ON GPIO controller (CRMU). All 3 GPIO controllers are
>> +         supported by this driver
>> +
>>   config GPIO_CLPS711X
>>          tristate "CLPS711X GPIO support"
>>          depends on ARCH_CLPS711X || COMPILE_TEST
>> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
>> index 81755f1..31eb7e0 100644
>> --- a/drivers/gpio/Makefile
>> +++ b/drivers/gpio/Makefile
>> @@ -19,6 +19,7 @@ obj-$(CONFIG_GPIO_ADP5520)    += gpio-adp5520.o
>>   obj-$(CONFIG_GPIO_ADP5588)     += gpio-adp5588.o
>>   obj-$(CONFIG_GPIO_AMD8111)     += gpio-amd8111.o
>>   obj-$(CONFIG_GPIO_ARIZONA)     += gpio-arizona.o
>> +obj-$(CONFIG_GPIO_BCM_CYGNUS)  += gpio-bcm-cygnus.o
>>   obj-$(CONFIG_GPIO_BCM_KONA)    += gpio-bcm-kona.o
>>   obj-$(CONFIG_GPIO_BT8XX)       += gpio-bt8xx.o
>>   obj-$(CONFIG_GPIO_CLPS711X)    += gpio-clps711x.o
>> diff --git a/drivers/gpio/gpio-bcm-cygnus.c b/drivers/gpio/gpio-bcm-cygnus.c
>> new file mode 100644
>> index 0000000..4fd9b73
>> --- /dev/null
>> +++ b/drivers/gpio/gpio-bcm-cygnus.c
>> @@ -0,0 +1,705 @@
>> +/*
>> + * Copyright (C) 2014 Broadcom Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <linux/module.h>
>> +#include <linux/irq.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/io.h>
>> +#include <linux/gpio.h>
>> +#include <linux/ioport.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/irqchip/chained_irq.h>
>> +
>> +#define CYGNUS_GPIO_DATA_IN_OFFSET   0x00
>> +#define CYGNUS_GPIO_DATA_OUT_OFFSET  0x04
>> +#define CYGNUS_GPIO_OUT_EN_OFFSET    0x08
>> +#define CYGNUS_GPIO_IN_TYPE_OFFSET   0x0c
>> +#define CYGNUS_GPIO_INT_DE_OFFSET    0x10
>> +#define CYGNUS_GPIO_INT_EDGE_OFFSET  0x14
>> +#define CYGNUS_GPIO_INT_MSK_OFFSET   0x18
>> +#define CYGNUS_GPIO_INT_STAT_OFFSET  0x1c
>> +#define CYGNUS_GPIO_INT_MSTAT_OFFSET 0x20
>> +#define CYGNUS_GPIO_INT_CLR_OFFSET   0x24
>> +#define CYGNUS_GPIO_PAD_RES_OFFSET   0x34
>> +#define CYGNUS_GPIO_RES_EN_OFFSET    0x38
>> +
>> +/* drive strength control for ASIU GPIO */
>> +#define CYGNUS_GPIO_ASIU_DRV0_CTRL_OFFSET 0x58
>> +
>> +/* drive strength control for CCM GPIO */
>> +#define CYGNUS_GPIO_CCM_DRV0_CTRL_OFFSET  0x00
>> +
>> +#define GPIO_BANK_SIZE 0x200
>> +#define NGPIOS_PER_BANK 32
>> +#define GPIO_BIT(pin) ((pin) % NGPIOS_PER_BANK)
>> +#define GPIO_BANK(pin) ((pin) / NGPIOS_PER_BANK)
>> +
>> +#define GPIO_FLAG_BIT_MASK           0xffff
>> +#define GPIO_PULL_BIT_SHIFT          16
>> +#define GPIO_PULL_BIT_MASK           0x3
>> +
>> +#define GPIO_DRV_STRENGTH_BIT_SHIFT  20
>> +#define GPIO_DRV_STRENGTH_BITS       3
>> +#define GPIO_DRV_STRENGTH_BIT_MASK   ((1 << GPIO_DRV_STRENGTH_BITS) - 1)
>> +
>> +/*
>> + * For GPIO internal pull up/down registers
>> + */
>> +enum gpio_pull {
>> +       GPIO_PULL_NONE = 0,
>> +       GPIO_PULL_UP,
>> +       GPIO_PULL_DOWN,
>> +       GPIO_PULL_INVALID,
>> +};
>> +
>> +/*
>> + * GPIO drive strength
>> + */
>> +enum gpio_drv_strength {
>> +       GPIO_DRV_STRENGTH_2MA = 0,
>> +       GPIO_DRV_STRENGTH_4MA,
>> +       GPIO_DRV_STRENGTH_6MA,
>> +       GPIO_DRV_STRENGTH_8MA,
>> +       GPIO_DRV_STRENGTH_10MA,
>> +       GPIO_DRV_STRENGTH_12MA,
>> +       GPIO_DRV_STRENGTH_14MA,
>> +       GPIO_DRV_STRENGTH_16MA,
>> +       GPIO_DRV_STRENGTH_INVALID,
>> +};
>> +
>> +struct bcm_cygnus_gpio {
>> +       struct device *dev;
>> +       void __iomem *base;
>> +       void __iomem *io_ctrl;
>> +       spinlock_t lock;
>> +       struct gpio_chip gc;
>> +       unsigned num_banks;
>> +       int irq;
>> +       struct irq_domain *irq_domain;
>> +};
>> +
>> +static unsigned int gpio_base_index;
>
> Nope. What happens if there are other GPIO controllers with
> conflicting base GPIOs? I guess this adds more weight to that
> "linux,gpio-base" property I mentioned in
> http://www.spinics.net/lists/arm-kernel/msg384847.html .
>
> The best solution would be for users of the GPIOs provided by this
> driver to not rely on GPIO numbers at all, and exclusively use the
> gpiod interface. Is that an option for you?
>
Doesn't sysfs still rely the global GPIO number? We need to support the 
sysfs GPIO entries because some of our customers are using that for GPIO 
configuration.

I can definitely change the code to use device tree property 
"linux,gpio-base" though.

>> +
>> +static struct bcm_cygnus_gpio *to_bcm_cygnus_gpio(struct gpio_chip *gc)
>> +{
>> +       return container_of(gc, struct bcm_cygnus_gpio, gc);
>> +}
>> +
>> +static int bcm_cygnus_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
>> +{
>> +       struct bcm_cygnus_gpio *cygnus_gpio = to_bcm_cygnus_gpio(gc);
>> +
>> +       return irq_find_mapping(cygnus_gpio->irq_domain, offset);
>> +}
>> +
>> +static unsigned int __gpio_reg_offset(struct bcm_cygnus_gpio *cygnus_gpio,
>> +               unsigned gpio)
>> +{
>> +       return GPIO_BANK(gpio) * GPIO_BANK_SIZE;
>> +}
>
> The cygnus_gpio argument in this function is unused. The compiler is
> supposed to signal such issues. Have you looked at your compiler
> output?
>
Let me change it to marco GPIO_REG(gpio) as you suggested.

>> +
>> +static unsigned int __gpio_bitpos(struct bcm_cygnus_gpio *cygnus_gpio,
>> +               unsigned gpio)
>> +{
>> +       return GPIO_BIT(gpio);
>> +}
>
> Same here. Also they are so simple that macros would be more adequate
> here I believe:
>
Agreed.

> #define CYGNUS_GPIO_REG(pin, reg) (GPIO_BANK(pin) * GPIO_BANK_SIZE + reg)
> #define CYGNUS_GPIO_SHIFT(pin) (pin % NGPIOS_PER_BANK) /* and remove
> the GPIO_BIT macro */
>
Right. The two macros make it simpler. Especially CYGNUS_GPIO_REG that 
takes the register offset as well. Will make the change.

>> +
>> +static void bcm_cygnus_gpio_irq_handler(unsigned int irq,
>> +               struct irq_desc *desc)
>> +{
>> +       struct bcm_cygnus_gpio *cygnus_gpio;
>> +       struct irq_chip *chip = irq_desc_get_chip(desc);
>> +       int i, bit;
>> +
>> +       chained_irq_enter(chip, desc);
>> +
>> +       cygnus_gpio = irq_get_handler_data(irq);
>> +
>> +       /* go through the entire GPIO banks and handle all interrupts */
>> +       for (i = 0; i < cygnus_gpio->num_banks; i++) {
>> +               unsigned long val = readl(cygnus_gpio->base +
>> +                               (i * GPIO_BANK_SIZE) +
>> +                               CYGNUS_GPIO_INT_MSTAT_OFFSET);
>
> Can you add cygnus_readl() and cygnus_writel() functions to avoid
> explicitly doing this operation on cygnus_gpio->base every time? It
> would be clearer and less error-prone.
>
Hmmm...But 'base' isn't the only register block that we access in this 
driver. There's also 'io_ctrl'.

What I can do is to introduce cygnus_readl() and cygnus_writel() like 
you suggested, and in the particular function 
bcm_cygnus_gpio_set_strength where io_ctrl register is needed, still use 
the normal readl and writel functions.

>> +
>> +               for_each_set_bit(bit, &val, NGPIOS_PER_BANK) {
>> +                       unsigned pin = NGPIOS_PER_BANK * i + bit;
>> +                       int child_irq =
>> +                               bcm_cygnus_gpio_to_irq(&cygnus_gpio->gc, pin);
>> +
>> +                       /*
>> +                        * Clear the interrupt before invoking the
>> +                        * handler, so we do not leave any window
>> +                        */
>> +                       writel(1 << bit,
>> +                               cygnus_gpio->base + (i * GPIO_BANK_SIZE) +
>> +                               CYGNUS_GPIO_INT_CLR_OFFSET);
>> +
>> +                       generic_handle_irq(child_irq);
>> +               }
>> +       }
>> +
>> +       chained_irq_exit(chip, desc);
>> +}
>> +
>> +static void bcm_cygnus_gpio_irq_ack(struct irq_data *d)
>> +{
>> +       struct bcm_cygnus_gpio *cygnus_gpio = irq_data_get_irq_chip_data(d);
>> +       unsigned gpio = d->hwirq;
>> +       unsigned int offset, shift;
>> +       u32 val;
>> +
>> +       offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +               CYGNUS_GPIO_INT_CLR_OFFSET;
>> +       shift = __gpio_bitpos(cygnus_gpio, gpio);
>> +
>> +       val = 1 << shift;
>
> val = BIT(shift);
>
Will change.

>> +       writel(val, cygnus_gpio->base + offset);
>> +
>> +       dev_dbg(cygnus_gpio->dev, "gpio:%u offset:0x%04x shift:%u\n", gpio,
>> +                       offset, shift);
>> +}
>> +
>> +static void bcm_cygnus_gpio_irq_mask(struct irq_data *d)
>> +{
>> +       struct bcm_cygnus_gpio *cygnus_gpio = irq_data_get_irq_chip_data(d);
>> +       unsigned gpio = d->hwirq;
>> +       unsigned int offset, shift;
>> +       u32 val;
>> +       unsigned long flags;
>> +
>> +       offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +               CYGNUS_GPIO_INT_MSK_OFFSET;
>> +       shift = __gpio_bitpos(cygnus_gpio, gpio);
>> +
>> +       spin_lock_irqsave(&cygnus_gpio->lock, flags);
>> +
>> +       val = readl(cygnus_gpio->base + offset);
>> +       val &= ~(1 << shift);
>
> val &= ~BIT(shift);
>
Yes.

>> +       writel(val, cygnus_gpio->base + offset);
>> +
>> +       spin_unlock_irqrestore(&cygnus_gpio->lock, flags);
>> +
>> +       dev_dbg(cygnus_gpio->dev, "gpio:%u offset:0x%04x shift:%u\n", gpio,
>> +                       offset, shift);
>> +}
>> +
>> +static void bcm_cygnus_gpio_irq_unmask(struct irq_data *d)
>> +{
>> +       struct bcm_cygnus_gpio *cygnus_gpio = irq_data_get_irq_chip_data(d);
>> +       unsigned gpio = d->hwirq;
>> +       unsigned int offset, shift;
>> +       u32 val;
>> +       unsigned long flags;
>> +
>> +       offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +               CYGNUS_GPIO_INT_MSK_OFFSET;
>> +       shift = __gpio_bitpos(cygnus_gpio, gpio);
>> +
>> +       spin_lock_irqsave(&cygnus_gpio->lock, flags);
>> +
>> +       val = readl(cygnus_gpio->base + offset);
>> +       val |= 1 << shift;
>
> val |= BIT(shift);
>
> Same remark everywhere it applies in this file.
>
Got it. Will go through the entire driver again and use 'BIT' where it 
applies.

>> +       writel(val, cygnus_gpio->base + offset);
>> +
>> +       spin_unlock_irqrestore(&cygnus_gpio->lock, flags);
>> +
>> +       dev_dbg(cygnus_gpio->dev, "gpio:%u offset:0x%04x shift:%u\n", gpio,
>> +                       offset, shift);
>> +}
>
> It seems like you can factorize bcm_cygnus_gpio_irq_mask() and
> bcm_cygnus_gpio_irq_unmask() into one function which prototype would
> be, say:
>
> static void bcm_cygnus_gpio_irq_set_mask(struct irq_data *d, int mask);
>
> which would set of clear the bit according to the value of mask. Then
> your two mask/unmask functions would just need to call this one,
> reducing the amount of redundant code.
>
> Also I noticed that this driver has lots of readl()/twiddle
> bit/writel() sequences. Maybe it would make sense to have a
> cygnus_set_bit(chip, reg, gpio, set) function to factorize this:
>
> void cygnus_set_bit(chip, reg, gpio, set)
> {
>      unsigned int offset = CYGNUS_GPIO_REG(gpio, reg);
>      unsigned int shift = CYGNUS_GPIO_SHIFT(gpio);
>      u32 val;
>
>      val = cygnus_readl(chip, offset);
>      if (set)
>          val |= BIT(shift);
>      else
>          val &= ~BIT(shift);
>      cygnus_writel(chip, offset, val);
> }
>
Okay. Need to go through the entire driver and make the change.

>> +
>> +static int bcm_cygnus_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>> +{
>> +       struct bcm_cygnus_gpio *cygnus_gpio = irq_data_get_irq_chip_data(d);
>> +       unsigned gpio = d->hwirq;
>> +       unsigned int int_type, dual_edge, edge_lvl;
>> +       unsigned int offset, shift;
>> +       u32 val;
>> +       unsigned long flags;
>> +
>> +       switch (type & IRQ_TYPE_SENSE_MASK) {
>> +       case IRQ_TYPE_EDGE_RISING:
>> +               int_type = 0;
>> +               dual_edge = 0;
>> +               edge_lvl = 1;
>> +               break;
>> +
>> +       case IRQ_TYPE_EDGE_FALLING:
>> +               int_type = 0;
>> +               dual_edge = 0;
>> +               edge_lvl = 0;
>> +               break;
>> +
>> +       case IRQ_TYPE_EDGE_BOTH:
>> +               int_type = 0;
>> +               dual_edge = 1;
>> +               edge_lvl = 0;
>> +               break;
>> +
>> +       case IRQ_TYPE_LEVEL_HIGH:
>> +               int_type = 1;
>> +               dual_edge = 0;
>> +               edge_lvl = 1;
>> +               break;
>> +
>> +       case IRQ_TYPE_LEVEL_LOW:
>> +               int_type = 1;
>> +               dual_edge = 0;
>> +               edge_lvl = 0;
>> +               break;
>> +
>> +       default:
>> +               dev_err(cygnus_gpio->dev, "invalid GPIO irq type 0x%x\n", type);
>> +               return -EINVAL;
>> +       }
>> +
>> +       spin_lock_irqsave(&cygnus_gpio->lock, flags);
>> +
>> +       shift = __gpio_bitpos(cygnus_gpio, gpio);
>> +       offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +               CYGNUS_GPIO_IN_TYPE_OFFSET;
>> +       val = readl(cygnus_gpio->base + offset);
>> +       val &= ~(1 << shift);
>> +       val |= int_type << shift;
>> +       writel(val, cygnus_gpio->base + offset);
>> +
>> +       offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +               CYGNUS_GPIO_INT_DE_OFFSET;
>> +       val = readl(cygnus_gpio->base + offset);
>> +       val &= ~(1 << shift);
>> +       val |= dual_edge << shift;
>> +       writel(val, cygnus_gpio->base + offset);
>> +
>> +       offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +               CYGNUS_GPIO_INT_EDGE_OFFSET;
>> +       val = readl(cygnus_gpio->base + offset);
>> +       val &= ~(1 << shift);
>> +       val |= edge_lvl << shift;
>> +       writel(val, cygnus_gpio->base + offset);
>
> With the functions/macros suggested above I think you could change the
> 3 blocks above into something like:
>
> cygnus_set_bit(cygnus_gpio, CYGNUS_GPIO_IN_TYPE_OFFSET, gpio, int_type);
> cygnus_set_bit(cygnus_gpio, CYGNUS_GPIO_INT_DE_OFFSET, gpio, dual_edge);
> cygnus_set_bit(cygnus_gpio, CYGNUS_GPIO_INT_EDGE_OFFSET, gpio, edge_lvl);
>
Yes. Indeed a lot simpler and easier to read. Thanks.

>> +
>> +       spin_unlock_irqrestore(&cygnus_gpio->lock, flags);
>> +
>> +       return 0;
>> +}
>> +
>> +static struct irq_chip bcm_cygnus_gpio_irq_chip = {
>> +       .name = "bcm-cygnus-gpio",
>> +       .irq_ack = bcm_cygnus_gpio_irq_ack,
>> +       .irq_mask = bcm_cygnus_gpio_irq_mask,
>> +       .irq_unmask = bcm_cygnus_gpio_irq_unmask,
>> +       .irq_set_type = bcm_cygnus_gpio_irq_set_type,
>> +};
>> +
>> +static int bcm_cygnus_gpio_direction_input(struct gpio_chip *gc,
>> +               unsigned gpio)
>> +{
>> +       struct bcm_cygnus_gpio *cygnus_gpio = to_bcm_cygnus_gpio(gc);
>> +       unsigned int offset, shift;
>> +       u32 val;
>> +       unsigned long flags;
>> +
>> +       offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +               CYGNUS_GPIO_OUT_EN_OFFSET;
>> +       shift = __gpio_bitpos(cygnus_gpio, gpio);
>> +
>> +       spin_lock_irqsave(&cygnus_gpio->lock, flags);
>> +
>> +       val = readl(cygnus_gpio->base + offset);
>> +       val &= ~(1 << shift);
>> +       writel(val, cygnus_gpio->base + offset);
>> +
>> +       spin_unlock_irqrestore(&cygnus_gpio->lock, flags);
>> +
>> +       dev_dbg(cygnus_gpio->dev, "gpio:%u offset:0x%04x shift:%u\n", gpio,
>> +                       offset, shift);
>> +
>> +       return 0;
>> +}
>> +
>> +static int bcm_cygnus_gpio_direction_output(struct gpio_chip *gc,
>> +               unsigned gpio, int value)
>> +{
>> +       struct bcm_cygnus_gpio *cygnus_gpio = to_bcm_cygnus_gpio(gc);
>> +       unsigned int offset, shift;
>> +       u32 val;
>> +       unsigned long flags;
>> +
>> +       offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +               CYGNUS_GPIO_OUT_EN_OFFSET;
>> +       shift = __gpio_bitpos(cygnus_gpio, gpio);
>> +
>> +       spin_lock_irqsave(&cygnus_gpio->lock, flags);
>> +
>> +       val = readl(cygnus_gpio->base + offset);
>> +       val |= 1 << shift;
>> +       writel(val, cygnus_gpio->base + offset);
>> +
>> +       dev_dbg(cygnus_gpio->dev, "gpio:%u offset:0x%04x shift:%u\n", gpio,
>> +                       offset, shift);
>> +
>> +       offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +               CYGNUS_GPIO_DATA_OUT_OFFSET;
>> +
>> +       val = readl(cygnus_gpio->base + offset);
>> +       if (value)
>> +               val |= 1 << shift;
>> +       else
>> +               val &= ~(1 << shift);
>> +       writel(val, cygnus_gpio->base + offset);
>
> And here you would have:
>
> cygnus_set_bit(cygnus_gpio, CYGNUS_GPIO_OUT_EN_OFFSET, gpio, 1);
> cygnus_set_bit(cygnus_gpio, CYGNUS_GPIO_DATA_OUT_OFFSET, gpio, value);
>
> Many other sites in this file could be simplified this way.
>
Yes. Will make the change.

>> +
>> +       spin_unlock_irqrestore(&cygnus_gpio->lock, flags);
>> +
>> +       dev_dbg(cygnus_gpio->dev,
>> +               "gpio:%u offset:0x%04x shift:%u val:0x%08x\n",
>> +               gpio, offset, shift, val);
>> +
>> +       return 0;
>> +}
>> +
>> +static void bcm_cygnus_gpio_set(struct gpio_chip *gc, unsigned gpio,
>> +               int value)
>> +{
>> +       struct bcm_cygnus_gpio *cygnus_gpio = to_bcm_cygnus_gpio(gc);
>> +       unsigned int offset, shift;
>> +       u32 val;
>> +       unsigned long flags;
>> +
>> +       offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +               CYGNUS_GPIO_DATA_OUT_OFFSET;
>> +       shift = __gpio_bitpos(cygnus_gpio, gpio);
>> +
>> +       spin_lock_irqsave(&cygnus_gpio->lock, flags);
>> +
>> +       val = readl(cygnus_gpio->base + offset);
>> +       if (value)
>> +               val |= 1 << shift;
>> +       else
>> +               val &= ~(1 << shift);
>> +       writel(val, cygnus_gpio->base + offset);
>> +
>> +       spin_unlock_irqrestore(&cygnus_gpio->lock, flags);
>> +
>> +       dev_dbg(cygnus_gpio->dev,
>> +               "gpio:%u offset:0x%04x shift:%u val:0x%08x\n",
>> +               gpio, offset, shift, val);
>> +}
>> +
>> +static int bcm_cygnus_gpio_get(struct gpio_chip *gc, unsigned gpio)
>> +{
>> +       struct bcm_cygnus_gpio *cygnus_gpio = to_bcm_cygnus_gpio(gc);
>> +       unsigned int offset, shift;
>> +       u32 val;
>> +
>> +       offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +               CYGNUS_GPIO_DATA_IN_OFFSET;
>> +       shift = __gpio_bitpos(cygnus_gpio, gpio);
>> +
>> +       val = readl(cygnus_gpio->base + offset);
>> +       val = (val >> shift) & 1;
>> +
>> +       dev_dbg(cygnus_gpio->dev, "gpio:%u offset:0x%04x shift:%u val:%u\n",
>> +                       gpio, offset, shift, val);
>> +
>> +       return val;
>> +}
>> +
>> +static struct lock_class_key gpio_lock_class;
>> +
>> +static int bcm_cygnus_gpio_irq_map(struct irq_domain *d, unsigned int irq,
>> +                                irq_hw_number_t hwirq)
>> +{
>> +       int ret;
>> +
>> +       ret = irq_set_chip_data(irq, d->host_data);
>> +       if (ret < 0)
>> +               return ret;
>> +       irq_set_lockdep_class(irq, &gpio_lock_class);
>> +       irq_set_chip_and_handler(irq, &bcm_cygnus_gpio_irq_chip,
>> +                       handle_simple_irq);
>> +       set_irq_flags(irq, IRQF_VALID);
>> +
>> +       return 0;
>> +}
>> +
>> +static void bcm_cygnus_gpio_irq_unmap(struct irq_domain *d, unsigned int irq)
>> +{
>> +       irq_set_chip_and_handler(irq, NULL, NULL);
>> +       irq_set_chip_data(irq, NULL);
>> +}
>> +
>> +static struct irq_domain_ops bcm_cygnus_irq_ops = {
>> +       .map = bcm_cygnus_gpio_irq_map,
>> +       .unmap = bcm_cygnus_gpio_irq_unmap,
>> +       .xlate = irq_domain_xlate_twocell,
>> +};
>> +
>> +#ifdef CONFIG_OF_GPIO
>> +static void bcm_cygnus_gpio_set_pull(struct bcm_cygnus_gpio *cygnus_gpio,
>> +               unsigned gpio, enum gpio_pull pull)
>> +{
>> +       unsigned int offset, shift;
>> +       u32 val, pullup;
>> +       unsigned long flags;
>> +
>> +       switch (pull) {
>> +       case GPIO_PULL_UP:
>> +               pullup = 1;
>> +               break;
>> +       case GPIO_PULL_DOWN:
>> +               pullup = 0;
>> +               break;
>> +       case GPIO_PULL_NONE:
>> +       case GPIO_PULL_INVALID:
>> +       default:
>> +               return;
>> +       }
>> +
>> +       spin_lock_irqsave(&cygnus_gpio->lock, flags);
>> +
>> +       /* set pull up/down */
>> +       offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +               CYGNUS_GPIO_PAD_RES_OFFSET;
>> +       shift = __gpio_bitpos(cygnus_gpio, gpio);
>> +
>> +       val = readl(cygnus_gpio->base + offset);
>> +       val &= ~(1 << shift);
>> +       if (pullup)
>> +               val |= 1 << shift;
>> +       writel(val, cygnus_gpio->base + offset);
>> +
>> +       /* enable pad */
>> +       offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +               CYGNUS_GPIO_RES_EN_OFFSET;
>> +       val = readl(cygnus_gpio->base + offset);
>> +       val |= 1 << shift;
>> +       writel(val, cygnus_gpio->base + offset);
>> +
>> +       spin_unlock_irqrestore(&cygnus_gpio->lock, flags);
>> +}
>> +
>> +static void bcm_cygnus_gpio_set_strength(struct bcm_cygnus_gpio *cygnus_gpio,
>> +               unsigned gpio, enum gpio_drv_strength strength)
>> +{
>> +       struct device *dev = cygnus_gpio->dev;
>> +       void __iomem *base;
>> +       unsigned int i, offset, shift;
>> +       u32 val;
>> +       unsigned long flags;
>> +
>> +       /* some GPIO controllers do not support drive strength configuration */
>> +       if (of_find_property(dev->of_node, "no-drv-strength", NULL))
>> +               return;
>> +
>> +       if (cygnus_gpio->io_ctrl) {
>> +               base = cygnus_gpio->io_ctrl;
>> +               offset = CYGNUS_GPIO_CCM_DRV0_CTRL_OFFSET;
>> +       } else {
>> +               base = cygnus_gpio->base;
>> +               offset = __gpio_reg_offset(cygnus_gpio, gpio) +
>> +                       CYGNUS_GPIO_ASIU_DRV0_CTRL_OFFSET;
>> +       }
>> +
>> +       shift = __gpio_bitpos(cygnus_gpio, gpio);
>> +
>> +       spin_lock_irqsave(&cygnus_gpio->lock, flags);
>> +
>> +       for (i = 0; i < GPIO_DRV_STRENGTH_BITS; i++) {
>> +               val = readl(base + offset);
>> +               val &= ~(1 << shift);
>> +               val |= ((strength >> i) & 0x1) << shift;
>> +               writel(val, base + offset);
>> +               offset += 4;
>> +       }
>> +
>> +       spin_unlock_irqrestore(&cygnus_gpio->lock, flags);
>> +}
>> +
>> +static int bcm_cygnus_gpio_of_xlate(struct gpio_chip *gc,
>> +               const struct of_phandle_args *gpiospec, u32 *flags)
>> +{
>> +       struct bcm_cygnus_gpio *cygnus_gpio = to_bcm_cygnus_gpio(gc);
>> +       enum gpio_pull pull;
>> +       enum gpio_drv_strength strength;
>> +
>> +       if (gc->of_gpio_n_cells < 2)
>> +               return -EINVAL;
>> +
>> +       if (WARN_ON(gpiospec->args_count < gc->of_gpio_n_cells))
>> +               return -EINVAL;
>> +
>> +       if (gpiospec->args[0] >= gc->ngpio)
>> +               return -EINVAL;
>> +
>> +       pull = (gpiospec->args[1] >> GPIO_PULL_BIT_SHIFT) & GPIO_PULL_BIT_MASK;
>> +       if (WARN_ON(pull >= GPIO_PULL_INVALID))
>> +               return -EINVAL;
>> +
>> +       strength = (gpiospec->args[1] >> GPIO_DRV_STRENGTH_BIT_SHIFT) &
>> +               GPIO_DRV_STRENGTH_BIT_MASK;
>> +
>> +       if (flags)
>> +               *flags = gpiospec->args[1] & GPIO_FLAG_BIT_MASK;
>> +
>> +       bcm_cygnus_gpio_set_pull(cygnus_gpio, gpiospec->args[0], pull);
>> +       bcm_cygnus_gpio_set_strength(cygnus_gpio, gpiospec->args[0], strength);
>> +
>> +       return gpiospec->args[0];
>> +}
>> +#endif
>> +
>> +static const struct of_device_id bcm_cygnus_gpio_of_match[] = {
>> +       { .compatible = "brcm,cygnus-gpio" },
>> +       { }
>> +};
>> +MODULE_DEVICE_TABLE(of, bcm_cygnus_gpio_of_match);
>> +
>> +static int bcm_cygnus_gpio_probe(struct platform_device *pdev)
>> +{
>> +       struct device *dev = &pdev->dev;
>> +       const struct of_device_id *match;
>> +       struct resource *res;
>> +       struct bcm_cygnus_gpio *cygnus_gpio;
>> +       struct gpio_chip *gc;
>> +       u32 i, ngpios;
>> +       int ret;
>> +
>> +       match = of_match_device(bcm_cygnus_gpio_of_match, dev);
>> +       if (!match) {
>> +               dev_err(&pdev->dev, "failed to find GPIO controller\n");
>> +               return -ENODEV;
>> +       }
>
> Do you still need that block of code? match is never used in this function.
>
Will get rid of it. Pretty much a redundant check.

> ... well, I think you get the drill. Let's first start by factorizing
> as much code as can be to make this driver easier to read (I have a
> few leads, but I am sure there are other similar factorizations that
> can be made). Let's also get rid of this static gpio_base_index
> variable that effectively prevents any other GPIO driver from being
> used alongside with this one. If you really need to use global GPIO
> numbers, let's see if Linus agrees for that "linux,gpio-base" DT
> property that would certainly make many people happy.
>
Will make the change. Thanks for the review. Very helpful!

We do need to use global GPIO numbers, at least before sysfs GPIO 
interface is updated to use gpiod. I'm fine with using 
"linux,gpio-base". Btw, I assume that's per GPIO controller based device 
tree property, correct?
