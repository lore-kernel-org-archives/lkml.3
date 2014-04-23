Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaDWCEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:04:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:57871 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbaDWCEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:04:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,908,1389772800"; 
   d="scan'208";a="517661912"
Message-ID: <53571FB2.2040706@linux.intel.com>
Date: Wed, 23 Apr 2014 10:04:34 +0800
From: "Jin, Yao" <yao.jin@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl-baytrail: workaround for irq descriptor conflict
 on ASUS T100TA
References: <1397443272-31467-1-git-send-email-yao.jin@linux.intel.com>	<534B4C6D.5070003@linux.intel.com> <CACRpkdYXD-Fd0tFJtir8ifsTqdBvA0Rznc4Hmzoq_ByBjTahdw@mail.gmail.com>
In-Reply-To: <CACRpkdYXD-Fd0tFJtir8ifsTqdBvA0Rznc4Hmzoq_ByBjTahdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/4/22 21:18, Linus Walleij wrote:
> On Mon, Apr 14, 2014 at 4:48 AM, Jin, Yao <yao.jin@linux.intel.com> wrote:
> 
>> A crash is triggered on the ASUS T100TA Baytrail-T because of a IRQ
>> descriptor conflict. There are two gpio triggered acpi events in this
>> device, GPIO 6 and 18. These gpios are translated to irqs by calling
>> gpio_to_irq which in turn will call irq_create_mapping(vg->domain, offset).
>> irq_create_mapping will take care of allocating the irq descriptor, taking
>> the first available number starting from the given value (6 in our case).
>> The 0-15 are already reserved by legacy ISA code, so it gets the first
>> free irq descriptor which is number 16. The i915 driver also uses irq 16,
>> it loads later than gpio and crashes in probe.
>>
>> The bug is reported here:
>> https://bugzilla.kernel.org/show_bug.cgi?id=68291
>>
>> The rootcause we know now is a low level irq issue. It needs a long term
>> solution to fix the issue in irq system.
>>
>> This patch is a workaround which changes the Baytrail GPIO driver to avoid
>> the IRQ conflict. It still uses the irq domain to allocate irq descriptor
>> but start from a predefined irq base number (256).
>>
>> Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
>> ---
>>  drivers/pinctrl/pinctrl-baytrail.c | 37
>> +++++++++++++++++++++++++++++--------
>>  1 file changed, 29 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-baytrail.c
>> b/drivers/pinctrl/pinctrl-baytrail.c
>> index 6e8301f..45b2d81 100644
>> --- a/drivers/pinctrl/pinctrl-baytrail.c
>> +++ b/drivers/pinctrl/pinctrl-baytrail.c
>> @@ -124,6 +124,18 @@ static struct pinctrl_gpio_range byt_ranges[] = {
>>         },
>>  };
>>
>> +/*
>> + * Start from an irq base number above x86 ioapic range to work around some
>> + * nasty, which is still in 3.14 unresolved irq descriptor conflicts.
>> + */
>> +#define BYT_GPIO_PIN_IRQBASE   256
>> +
>> +static int byt_pin_irqbase[] = {
>> +       BYT_GPIO_PIN_IRQBASE,
>> +       BYT_GPIO_PIN_IRQBASE + BYT_NGPIO_SCORE,
>> +       BYT_GPIO_PIN_IRQBASE + BYT_NGPIO_SCORE + BYT_NGPIO_NCORE,
>> +};
>> +
>>  struct byt_gpio {
>>         struct gpio_chip                chip;
>>         struct irq_domain               *domain;
>> @@ -131,6 +143,7 @@ struct byt_gpio {
>>         spinlock_t                      lock;
>>         void __iomem                    *reg_base;
>>         struct pinctrl_gpio_range       *range;
>> +       int                             pin_irqbase;
>>  };
>>
>>  #define to_byt_gpio(c) container_of(c, struct byt_gpio, chip)
>> @@ -481,7 +494,7 @@ static int byt_gpio_probe(struct platform_device *pdev)
>>         struct pinctrl_gpio_range *range;
>>         acpi_handle handle = ACPI_HANDLE(dev);
>>         unsigned hwirq;
>> -       int ret;
>> +       int ret, i;
>>
>>         if (acpi_bus_get_device(handle, &acpi_dev))
>>                 return -ENODEV;
>> @@ -496,6 +509,12 @@ static int byt_gpio_probe(struct platform_device *pdev)
>>                 if (!strcmp(acpi_dev->pnp.unique_id, range->name)) {
>>                         vg->chip.ngpio = range->npins;
>>                         vg->range = range;
>> +                       ret = kstrtol(range->name, 10, &i);
>> +                       if (ret != 0)
>> +                               return ret;
>> +
>> +                       i--;
>> +                       vg->pin_irqbase = byt_pin_irqbase[i];
>>                         break;
>>                 }
>>         }
>> @@ -527,19 +546,14 @@ static int byt_gpio_probe(struct platform_device
>> *pdev)
>>         gc->can_sleep = false;
>>         gc->dev = dev;
>>
>> -       ret = gpiochip_add(gc);
>> -       if (ret) {
>> -               dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
>> -               return ret;
>> -       }
>> -
>>         /* set up interrupts  */
>>         irq_rc = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>>         if (irq_rc && irq_rc->start) {
>>                 hwirq = irq_rc->start;
>>                 gc->to_irq = byt_gpio_to_irq;
>>
>> -               vg->domain = irq_domain_add_linear(NULL, gc->ngpio,
>> +               vg->domain = irq_domain_add_simple(NULL, gc->ngpio,
>> +                                                  vg->pin_irqbase,
>>                                                    &byt_gpio_irq_ops, vg);
>>                 if (!vg->domain)
>>                         return -ENXIO;
>> @@ -550,6 +564,12 @@ static int byt_gpio_probe(struct platform_device *pdev)
>>                 irq_set_chained_handler(hwirq, byt_gpio_irq_handler);
>>         }
>>
>> +       ret = gpiochip_add(gc);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
>> +               return ret;
>> +       }
>> +
>>         pm_runtime_enable(dev);
>>
>>         return 0;
>> @@ -572,6 +592,7 @@ static const struct dev_pm_ops byt_gpio_pm_ops = {
>>
>>  static const struct acpi_device_id byt_gpio_acpi_match[] = {
>>         { "INT33B2", 0 },
>> +       { "INT33FC", 0 },
>>         { }
>>  };
>>  MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
> 
> Urgent fix and the maintainers did not react in a week? Well maybe they need
> to be on the To: line...
> 
Thanks for reminding. I will keep in mind for next time.

> Mathias: can you send a patch adding yourself as maintainer of this
> driver in the MAINTAINERS file so stuff like this does not fall to the
> floor (me)?
> 
> Second: this fix is ugly like hell, is it really the best we can think
> of, plus in the commit message I'd very much like to know the
> real issue behind this as people in the x86 camp seem to be
> using some strange static IRQ line assignments that I cannot
> really understand so I don't know what the proper fix for this is :-(

GPIO driver is loaded before graphics. It's no problem for it to get the
first free irq, which number is 16. After a while, graphics driver is
loaded. The IRQ number (16) it needs is hardwired by BIOS. Here is part
of DSDT table:

Name (AR00, Package (0x11)
{
    Package (0x04)
    {
        0x0002FFFF,
        Zero,
        Zero,
        0x10	/* Jin Yao: IRQ number 16 */
    },
    ......
}

The problem happens at __irq_alloc_descs().

__irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int
node, struct module *owner)
{
	......
	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
from, cnt, 0);
	ret = -EEXIST;

	/* Jin Yao: irq = 16, start = 17 */
/* A */ if (irq >=0 && start != irq)
		goto err;
	......
err:
}

When graphics driver probing, the irq is 16 and
bitmap_find_next_zero_area() returns 17. That's correct, because 16 has
been allocated to GPIO pin. The problem is at the line A, the checking
is failed and goto "err:" directly. The next io_apic processing code
(not list here) assumes all irq descriptors belongs to a io_apic chip,
and that all chip_data is of type irq_cfg. But unfortunately in this
case, the chip_data in irq_desc of IRQ16 is pointing to byt_gpio, then
crash happens.

So this needs to be fixed in two places:
1. make sure io_apic code does not access data in interrupt descriptors
that belong to other "interrupt controllers", eg gpio than io_apic.

2. fix graphics driver / bios to not request the not needed irq 16

Probably the above fixes need long time, so I decide to use a simple and
direct way by just shifting the irq for GPIO pins to avoid the conflict.

This patch "[PATCH] pinctrl-baytrail: workaround for irq descriptor
conflict on ASUS T100TA" has format issue. I post it by forwarding via
Thunderbird, but lead to format issue, I'm so sorry for that.

I post another patch "[PATCH] pinctrl-baytrail: fix for irq descriptor
conflict on ASUS T100TA" to solve the format issue.

Thanks
Jin Yao

> 
> Yours,
> Linus Walleij
> 
