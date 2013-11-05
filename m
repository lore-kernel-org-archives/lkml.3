Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3KEIAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 03:00:54 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:62920 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3KEIAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 03:00:51 -0500
MIME-Version: 1.0
In-Reply-To: <5277E722.50205@ti.com>
References: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com>
 <1383406775-14902-4-git-send-email-prabhakar.csenng@gmail.com> <5277E722.50205@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 5 Nov 2013 13:30:29 +0530
Message-ID: <CA+V-a8uLAnVdjNiqNJnOaP1qJU8wF4pqkO0b1DKo1Q3bM8qPcg@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] gpio: davinci: use irqdomain
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Alex Elder <alex.elder@linaro.org>, LDOC <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi grygorii,

Thanks for the review.

On Mon, Nov 4, 2013 at 11:57 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> Hi Prabhakar Lad,
>
> On 11/02/2013 05:39 PM, Lad, Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch converts the davinci gpio driver to use irqdomain
>> support.
>
> This patch needs to be splitted in two:
> 1) add IRQ domain support
> 2) remove intc_irq_num
>
OK

>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>   arch/arm/mach-davinci/da830.c              |    1 -
>>   arch/arm/mach-davinci/da850.c              |    1 -
>>   arch/arm/mach-davinci/dm355.c              |    1 -
>>   arch/arm/mach-davinci/dm365.c              |    1 -
>>   arch/arm/mach-davinci/dm644x.c             |    1 -
>>   arch/arm/mach-davinci/dm646x.c             |    1 -
>>   drivers/gpio/gpio-davinci.c                |   49 ++++++++++++++++++----------
>>   include/linux/platform_data/gpio-davinci.h |    3 +-
>>   8 files changed, 32 insertions(+), 26 deletions(-)
>>
>
> [...]
>
>>
>>   int __init dm646x_gpio_register(void)
>> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
>> index 95c6df1..bcb6d8d 100644
>> --- a/drivers/gpio/gpio-davinci.c
>> +++ b/drivers/gpio/gpio-davinci.c
>> @@ -16,6 +16,7 @@
>>   #include <linux/err.h>
>>   #include <linux/io.h>
>>   #include <linux/irq.h>
>> +#include <linux/irqdomain.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/platform_data/gpio-davinci.h>
>>
>> @@ -292,7 +293,7 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
>>               __raw_writel(status, &g->intstat);
>>
>>               /* now demux them to the right lowlevel handler */
>> -             n = d->irq_base;
>> +             n = irq_find_mapping(d->irq_domain, 0);
>
> Sorry, but I don't understand why have you used <0> as hwirq?
>
> All below logic may not work in case if we switch to use Linear IRQ domain :(
> - irq_create_mapping() may return ANY Linux IRQ number. It means, for
> example, for bank0(ngpio=32)[0] it may return Linux_IRQ=200 or 201 or any other.
>  Also, for bank3(ngpio=16)[0] it may return Linux_IRQ=150, etc.
> - More over, if you call irq_create_mapping() 32 times you may NOT get
>  sequential Linux_IRQ numbers.
>
> So, the better sequence here can be smth. as below
> (I can't verify it - my HW support only unbanked IRQs):
>
Yeah below logic works fine for banked IRQs.

>         if (irq & 1)
>                 mask <<= 16;
>
>         while (1) {
>                 u32             status;
>                 int             bit;
>
>                 /* ack any irqs */
>                 status = __raw_readl(&g->intstat) & mask;
>                 if (!status)
>                         break;
>                 __raw_writel(status, &g->intstat);
>
>                 /* now demux them to the right lowlevel handler */
>                 while (status) {
>                         bit = __ffs(status);
>                         status &= ~(1 << bit);
>                         generic_handle_irq(irq_find_mapping(d->irq_domain, bit));
>                 }
>         }
>
>
>>               if (irq & 1) {
>>                       n += 16;
>>                       status >>= 16;
>> @@ -313,10 +314,7 @@ static int gpio_to_irq_banked(struct gpio_chip *chip, unsigned offset)
>>   {
>>       struct davinci_gpio_controller *d = chip2controller(chip);
>>
>> -     if (d->irq_base >= 0)
>> -             return d->irq_base + offset;
>> -     else
>> -             return -ENODEV;
>> +     return irq_find_mapping(d->irq_domain, offset);
>
> I think you can use irq_create_mapping() here instead of
> irq_find_mapping(), so IRQ will be mapped/allocated on demand.
> Also, it seems, above code may crash in case if SoC has >1 GPIO banks and
> gpio_unbanked > 0 and someone will call gpio_to_irq(>31).
>
Fixed it.

>>   }
>>
>>   static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
>> @@ -373,6 +371,7 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>>       struct davinci_gpio_controller *chips = platform_get_drvdata(pdev);
>>       struct davinci_gpio_platform_data *pdata = dev->platform_data;
>>       struct davinci_gpio_regs __iomem *g;
>> +     int gpio_irq = 0;
>>
>>       ngpio = pdata->ngpio;
>>       res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>> @@ -402,9 +401,15 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>>        */
>>       for (gpio = 0, bank = 0; gpio < ngpio; bank++, gpio += 32) {
>>               chips[bank].chip.to_irq = gpio_to_irq_banked;
>> -             chips[bank].irq_base = pdata->gpio_unbanked
>> -                     ? -EINVAL
>> -                     : (pdata->intc_irq_num + gpio);
>> +             if (!pdata->gpio_unbanked) {
>> +                     chips[bank].irq_domain =
>> +                             irq_domain_add_linear(NULL, 32,
>
> Use chips[i].chip.ngpio here instead of const 32?
>
OK

>> +                                                   &irq_domain_simple_ops,
>
> Pass &davinci_gpio_irq_ops (see below)
>
>> +                                                   NULL);
>
> Pass &chips[bank] as host_data and use .map() callback (see below)
>
OK

>> +
>> +                     if (!chips[bank].irq_domain)
>> +                             return -ENOMEM;
>> +             }
>>       }
>>
>>       /*
>> @@ -445,9 +450,7 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>>        * Or, AINTC can handle IRQs for banks of 16 GPIO IRQs, which we
>>        * then chain through our own handler.
>>        */
>> -     for (gpio = 0, irq = gpio_to_irq(0), bank = 0;
>> -                     gpio < ngpio;
>> -                     bank++, bank_irq++) {
>> +     for (gpio = 0, irq = 0, bank = 0; gpio < ngpio; bank++, bank_irq++) {
>>               unsigned                i;
>>
>>               /* disabled by default, enabled only as needed */
>> @@ -465,12 +468,22 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>>                */
>>               irq_set_handler_data(bank_irq, &chips[gpio / 32]);
>>
>> -             for (i = 0; i < 16 && gpio < ngpio; i++, irq++, gpio++) {
>> -                     irq_set_chip(irq, &gpio_irqchip);
>> -                     irq_set_chip_data(irq, (__force void *)g);
>> -                     irq_set_handler_data(irq, (void *)__gpio_mask(gpio));
>> -                     irq_set_handler(irq, handle_simple_irq);
>> -                     set_irq_flags(irq, IRQF_VALID);
>> +             if (!(bank % 2))
>> +                     irq = 0;
>> +             else
>> +                     irq = 16;
>
> As I mentioned above, I think, it is not good to play with IRQ numbers here.
> Only chained IRQs and <binten> can be configured in this cycle.
>
Done

>> +
>> +             for (i = 0; i < 16 && gpio < ngpio; i++, gpio++) {
>> +                     int irqno =
>> +                             irq_create_mapping(chips[gpio / 32].irq_domain,
>> +                                                i + irq);
>> +
>> +                     irq_set_chip(irqno, &gpio_irqchip);
>> +                     irq_set_chip_data(irqno, (__force void *)g);
>> +                     irq_set_handler_data(irqno, (void *)__gpio_mask(gpio));
>> +                     irq_set_handler(irqno, handle_simple_irq);
>> +                     set_irq_flags(irqno, IRQF_VALID);
>
> It makes no sense to manually create mapping. Usually it can be done in
> .map() callback of IRQ domain. Like:
>
> static int davinci_gpio_irq_map(struct irq_domain *d, unsigned int irq,
>                             irq_hw_number_t hw)
> {
>         struct davinci_gpio_controller *chip = d->host_data;
>         unsigned gpio = chip->chip.base + hw;
>
>         irq_set_chip_and_handler_name(irq, &gpio_irqchip, handle_simple_irq,
>                                       "davinci_gpio");
>         irq_set_irq_type(irq, IRQ_TYPE_NONE);
>         set_irq_flags(irq, IRQF_VALID);
> ...
>         return 0;
> }
>
> static const struct irq_domain_ops davinci_gpio_irq_ops = {
>         .map = davinci_gpio_irq_map,
>         .xlate = irq_domain_xlate_onetwocell,
> };
>
>
Fixed it.

Regards,
--Prabhakar Lad
