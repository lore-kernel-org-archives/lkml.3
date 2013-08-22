Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab3HVHHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:07:11 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:55792 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab3HVHHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:07:09 -0400
MIME-Version: 1.0
In-Reply-To: <52150AD9.3040808@wwwdotorg.org>
References: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
	<52150AD9.3040808@wwwdotorg.org>
Date: Thu, 22 Aug 2013 15:07:08 +0800
Message-ID: <CAJxxZ0O77bgP8_rkRm-EgjAJ45SY2Pd3AGVSMhFxbsfNUmiqGg@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] pinctrl: ADI PIN control driver for the GPIO
 controller on bf54x and bf60x.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Aug 22, 2013 at 2:45 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/21/2013 12:30 AM, Sonic Zhang wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> The new ADI GPIO2 controller was introduced since the BF548 and BF60x
>> processors. It differs a lot from the old one on BF5xx processors. So,
>> create a pinctrl driver under the pinctrl framework.
>
>>  drivers/pinctrl/Kconfig                    |   17 +
>>  drivers/pinctrl/Makefile                   |    3 +
>>  drivers/pinctrl/pinctrl-adi2-bf54x.c       |  572 +++++++++++
>>  drivers/pinctrl/pinctrl-adi2-bf60x.c       |  454 +++++++++
>
> Those files look reasonable.
>
>>  drivers/pinctrl/pinctrl-adi2.c             | 1501 ++++++++++++++++++++++++++++
>>  drivers/pinctrl/pinctrl-adi2.h             |   75 ++
>>  include/linux/platform_data/pinctrl-adi2.h |   40 +
>
>> diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
>
>> +/**
>> + * struct gpio_reserve_map - a GPIO map structure containing the
>> + * reservation status of each PIN.
>> + *
>> + * @owner: who request the reservation
>> + * @rsv_gpio: if this pin is reserved as GPIO
>> + * @rsv_int: if this pin is reserved as interrupt
>> + * @rsv_peri: if this pin is reserved as part of a peripheral device
>> + */
>> +struct gpio_reserve_map {
>> +     unsigned char owner[RESOURCE_LABEL_SIZE];
>> +     bool rsv_gpio;
>> +     bool rsv_int;
>> +     bool rsv_peri;
>> +};
>
> Why is that needed; don't the pinctrl/GPIO cores already know which
> pinctrl pins and which GPIOs are used, and for what?

The interrupt pin is requested and reserved in irq_chip operation
irq_set_type() other than gpio_request(). In Blackfin, one gpio pin is
allowed to be set up as both gpio interrupt and gpio input concurrently.
So, we need bits to differentiate them.


>
>> +#if defined(CONFIG_DEBUG_FS)
>> +static inline unsigned short get_gpio_dir(struct gpio_port *port,
>> ...
>
> Why aren't the existing GPIO/pinctrl subsystem debugfs files enough?
>

Yes, I do use the existing subsystem debugfs file.

port->chip.dbg_show             = adi_gpio_dbg_show;

root:/> cat /sys/kernel/debug/gpio
GPIOs 0-15, adi-gpio:
GPIO_0:         physmap-flash.0                 Peripheral
GPIO_1:         physmap-flash.0                 Peripheral
GPIO_2:         physmap-flash.0                 Peripheral
GPIO_3:         physmap-flash.0                 Peripheral
GPIO_4:         physmap-flash.0                 Peripheral
......


>> +static int adi_pinmux_request(struct pinctrl_dev *pctldev, unsigned pin)
> ...
>> +     /* If a pin can be muxed as either GPIO or peripheral, make
>> +      * sure it is not already a GPIO pin when we request it.
>> +      */
>> +     if (port->rsvmap[offset].rsv_gpio) {
>> +             if (system_state == SYSTEM_BOOTING)
>> +                     dump_stack();
>> +             dev_err(pctldev->dev,
>> +                    "%s: Peripheral PIN %d is already reserved as GPIO by %s!\n",
>> +                    __func__, pin, get_label(port, offset));
>> +             spin_unlock_irqrestore(&port->lock, flags);
>> +             return -EBUSY;
>> +     }
>
> Yes, this definitely warrants some more explanation. It looks odd. What
> is "system_state"?
>

The system_state checking, which is from the legacy bf5xx gpio driver,
is to warn if any peripheral pin is requested before the kernel_init
is executed. It seems this is not necessary under the pinctrl
framework. I will remove all these checking.


>> +static int adi_gpio_probe(struct platform_device *pdev)
> ...
>> +     /* Add gpio pin range */
>> +     snprintf(pinctrl_devname, RESOURCE_LABEL_SIZE, "pinctrl-adi2.%d",
>> +             pdata->pinctrl_id);
>> +     pinctrl_devname[RESOURCE_LABEL_SIZE - 1] = 0;
>> +     ret = gpiochip_add_pin_range(&port->chip, pinctrl_devname,
>> +             0, pdata->port_pin_base, port->width);
>
> This looks like platform data is providing the GPIO <-> pinctrl pin ID
> mapping, or at least part of it. Surely that mapping is fixed by the HW
> design, and hence isn't something platform data should influence. Do the
> files pinctrl-adi2-bf*.c not contain complete information about each HW
> configuration for some reason?

Is it possible that 2 and more pinctrl devices are on the same SoC? Or
do we always assume there is only one pinctrl device on one SoC? The
pinctrl_id field in platform data is to make the driver flexible for
future SoCs. If the later case is true, I can just fix the pinctrl
device name to "pinctrl-adi2.0".

The GPIO device's HW regsiter base, pin base, pin number and the
relationship with the PINT device are defined in the platform data.

>
>> +static struct platform_driver adi_pinctrl_driver = {
>> +     .probe          = adi_pinctrl_probe,
>> +     .remove         = adi_pinctrl_remove,
>> +     .driver         = {
>> +             .name   = DRIVER_NAME,
>> +     },
>> +};
>> +
>> +static struct platform_driver adi_gpio_pint_driver = {
>> +     .probe          = adi_gpio_pint_probe,
>> +     .remove         = adi_gpio_pint_remove,
>> +     .driver         = {
>> +             .name   = "adi-gpio-pint",
>> +     },
>> +};
>> +
>> +static struct platform_driver adi_gpio_driver = {
>> +     .probe          = adi_gpio_probe,
>> +     .remove         = adi_gpio_remove,
>> +     .driver         = {
>> +             .name   = "adi-gpio",
>> +     },
>> +};
>
> Hmmm. Is there one HW block that controls GPIOs and pinctrl, or are
> there separate HW blocks?
>
> If there's one HW block, why not have just one driver?
>
> If there are separate HW blocks, then having separate GPIO and pinctrl
> drivers seems like it would make sense.

There are 6 to 9 GPIO HW blocks in one Blackfin SoC. Function
pinmux_enable_setting() in current pinctrl framework assumes the
function mux setting of one peripheral pin group is configured in one
pinctrl device. But, the function mux setting of one blackfin
peripheral may be done among different GPIO HW blocks. So, I have to
separate the pinctrl driver from the GPIO block driver add the ranges
of all GPIO blocks into one pinctrl device for Blackfin.

Regards,

Sonic
