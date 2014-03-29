Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaC2Eou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 00:44:50 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:40720 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaC2Eoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 00:44:46 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbU35xG1QtagB+9e9vxvehf1UQFaF4PikJhsPNAMw=D1Q@mail.gmail.com>
References: <1395933906-2268-1-git-send-email-harinik@xilinx.com>
	<CACRpkdbU35xG1QtagB+9e9vxvehf1UQFaF4PikJhsPNAMw=D1Q@mail.gmail.com>
Date: Sat, 29 Mar 2014 10:14:45 +0530
Message-ID: <CAFcVECJsEp_s2V5=oK_UJahGRUpWYWMCxTMxqdpX+O0qebP41A@mail.gmail.com>
Subject: Re: [PATCH 1/2] GPIO: Add driver for Zynq GPIO controller
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        michals@xilinx.com, Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sat, Mar 29, 2014 at 3:20 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Mar 27, 2014 at 4:25 PM, Harini Katakam <harinik@xilinx.com> wrote:
>
>> Add support for GPIO controller used by Xilinx Zynq
>>
>> Signed-off-by: Harini Katakam <harinik@xilinx.com>
>
> This will not be integrated before v3.16 so we have some time to
> think things over.
>
>> +config GPIO_ZYNQ
>> +       bool "Xilinx ZYNQ GPIO support"
>> +       depends on ARCH_ZYNQ
>> +       select GENERIC_IRQ_CHIP
>
> I think that rather than selecting GENERIC_IRQ_CHIP,
> select my new GPIOLIB_IRQCHIP and use the new helpers
> gpiochip_irqchip_add() and gpiochip_set_chained_irqchip().
>
> Look in drivers/gpio/gpio-pl061.c for example usage.
>
> This is available in the "devel" or "for-next" branch of my
> gpio tree at
> https://git.kernel.org/cgit/linux/kernel/git/linusw/linux-gpio.git/
>

OK.

<snip>
>> +/* Read/Write access to the GPIO PS registers */
>> +static inline u32 zynq_gpio_readreg(void __iomem *offset)
>> +{
>> +       return readl_relaxed(offset);
>> +}
>> +
>> +static inline void zynq_gpio_writereg(void __iomem *offset, u32 val)
>> +{
>> +       writel_relaxed(val, offset);
>> +}
>
> I think this is unnecessary and confusing indirection.
> Just use the readl_relaxed/writel_relaxed functions directly in
> the code.
>

This is just to be flexible.

<snip>
>> +                       if (!(int_sts & 1))
>> +                               continue;
>> +                       gpio_irq_desc = irq_to_desc(gpio_irq);
>> +                       BUG_ON(!gpio_irq_desc);
>> +                       chip = irq_desc_get_chip(gpio_irq_desc);
>> +                       BUG_ON(!chip);
>> +                       chip->irq_ack(&gpio_irq_desc->irq_data);
>> +
>> +                       /* call the pin specific handler */
>> +                       generic_handle_irq(gpio_irq);
>> +               }
>> +               /* shift to first virtual irq of next bank */
>> +               gpio_irq = gpio->irq_base + zynq_gpio_pin_table[bank_num] + 1;
>
> This is also pretty convoluted. Are you sure you don't want to
> implement one gpiochip per bank instead? I guess the final "+1"
> means there is actually one IRQ per bank even?
>

There is only one IRQ for all four banks.
I will try to make this logic and other places in the driver you pointed out,
less convoluted.
The handling is (very) slightly different for the upper two banks and
lower two banks.

<snip>
>> +static const struct dev_pm_ops zynq_gpio_dev_pm_ops = {
>> +       SET_SYSTEM_SLEEP_PM_OPS(zynq_gpio_suspend, zynq_gpio_resume)
>> +       SET_RUNTIME_PM_OPS(zynq_gpio_runtime_suspend, zynq_gpio_runtime_resume,
>> +                          zynq_gpio_idle)
>> +};
>
> Is this runtime PM implementation aligned with Ulf Hansson's recent
> new helpers to simplify suspend+runtime PM coexistance?
>

I'm sorry i just looked at them -
pm_runtime_force_suspend/resume are not used here.

>> +       chip->dbg_show = NULL;
>> +       chip->base = 0;         /* default pin base */
>
> The GPIO numberspace is not the same as the pin number space.
> This is only going to work if you have no other GPIO controllers
> on your system. Use -1 as base so you get dynamic allocation
> of a GPIO number range instead.
>
> Make sure to use the new descriptor API for defining and accessing
> GPIOs in all drivers and it will not matter which base you get.
> (Good eh? :-)
>
> As it appears you're using device tree, it is all transparent and
> you need not worry.
>

OK.

<snip>

Thanks for the review!

Regards,
Harini
