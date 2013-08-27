Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3H0Jaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:30:39 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:59143 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3H0Jai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:30:38 -0400
MIME-Version: 1.0
In-Reply-To: <52167900.3040502@wwwdotorg.org>
References: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
	<52150AD9.3040808@wwwdotorg.org>
	<CAJxxZ0O77bgP8_rkRm-EgjAJ45SY2Pd3AGVSMhFxbsfNUmiqGg@mail.gmail.com>
	<52167900.3040502@wwwdotorg.org>
Date: Tue, 27 Aug 2013 17:30:37 +0800
Message-ID: <CAJxxZ0PVCY_Hmqdi243gSLGc_vuyx4AbCSdADU5daEqbKar5KA@mail.gmail.com>
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

On Fri, Aug 23, 2013 at 4:48 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/22/2013 01:07 AM, Sonic Zhang wrote:
>> Hi Stephen,
>>
>> On Thu, Aug 22, 2013 at 2:45 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On 08/21/2013 12:30 AM, Sonic Zhang wrote:
>>>> From: Sonic Zhang <sonic.zhang@analog.com>
>>>>
>>>> The new ADI GPIO2 controller was introduced since the BF548 and BF60x
>>>> processors. It differs a lot from the old one on BF5xx processors. So,
>>>> create a pinctrl driver under the pinctrl framework.
>>>
>>>>  drivers/pinctrl/Kconfig                    |   17 +
>>>>  drivers/pinctrl/Makefile                   |    3 +
>>>>  drivers/pinctrl/pinctrl-adi2-bf54x.c       |  572 +++++++++++
>>>>  drivers/pinctrl/pinctrl-adi2-bf60x.c       |  454 +++++++++
>>>
>>> Those files look reasonable.
>>>
>>>>  drivers/pinctrl/pinctrl-adi2.c             | 1501 ++++++++++++++++++++++++++++
>>>>  drivers/pinctrl/pinctrl-adi2.h             |   75 ++
>>>>  include/linux/platform_data/pinctrl-adi2.h |   40 +
>>>
>>>> diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
>>>
>>>> +/**
>>>> + * struct gpio_reserve_map - a GPIO map structure containing the
>>>> + * reservation status of each PIN.
>>>> + *
>>>> + * @owner: who request the reservation
>>>> + * @rsv_gpio: if this pin is reserved as GPIO
>>>> + * @rsv_int: if this pin is reserved as interrupt
>>>> + * @rsv_peri: if this pin is reserved as part of a peripheral device
>>>> + */
>>>> +struct gpio_reserve_map {
>>>> +     unsigned char owner[RESOURCE_LABEL_SIZE];
>>>> +     bool rsv_gpio;
>>>> +     bool rsv_int;
>>>> +     bool rsv_peri;
>>>> +};
>>>
>>> Why is that needed; don't the pinctrl/GPIO cores already know which
>>> pinctrl pins and which GPIOs are used, and for what?
>>
>> The interrupt pin is requested and reserved in irq_chip operation
>> irq_set_type() other than gpio_request(). In Blackfin, one gpio pin is
>> allowed to be set up as both gpio interrupt and gpio input concurrently.
>> So, we need bits to differentiate them.
>
> Does the HW need to be programmed differently in those cases?
>
> If not, I still don't see why the driver cares; if the HW allows both
> usages concurrently, there's nothing to check and hence no need to
> record any state.
>
> If the HW must be programmed differently, can't you read the current
> state out of the HW?

After checking the blackfin HRM again, I think the GPIO interrupt mode
is not mutually exclusive with the peripheral mode as well as the gpio
mode. So, it is not necessary to check the reservation mode of the
requested pin in IRQ chip operation. I will remove the reservation
map.

>
>>>> +static int adi_gpio_probe(struct platform_device *pdev)
>>> ...
>>>> +     /* Add gpio pin range */
>>>> +     snprintf(pinctrl_devname, RESOURCE_LABEL_SIZE, "pinctrl-adi2.%d",
>>>> +             pdata->pinctrl_id);
>>>> +     pinctrl_devname[RESOURCE_LABEL_SIZE - 1] = 0;
>>>> +     ret = gpiochip_add_pin_range(&port->chip, pinctrl_devname,
>>>> +             0, pdata->port_pin_base, port->width);
>>>
>>> This looks like platform data is providing the GPIO <-> pinctrl pin ID
>>> mapping, or at least part of it. Surely that mapping is fixed by the HW
>>> design, and hence isn't something platform data should influence. Do the
>>> files pinctrl-adi2-bf*.c not contain complete information about each HW
>>> configuration for some reason?
>>
>> Is it possible that 2 and more pinctrl devices are on the same SoC?
>
> Yes.
>
>> Or do we always assume there is only one pinctrl device on one SoC
>
> No.
>
>> The
>> pinctrl_id field in platform data is to make the driver flexible for
>> future SoCs. If the later case is true, I can just fix the pinctrl
>> device name to "pinctrl-adi2.0".
>
> I was talking about pdata->port_pin_base being passed to
> gpiochip_add_pin_range(), not the device name.
>
>> The GPIO device's HW regsiter base, pin base, pin number and the
>> relationship with the PINT device are defined in the platform data.
>
> Hmmm. I suppose with a platform-data-based driver, there isn't a good
> opportunity to encode which HW the code is running on, and then derive
> those parameters from the SoC type and/or put that information into
> device tree. Perhaps platform data is the only way, although isn't there
> some kind of "device ID -> data" mapping table option, so that probe()
> can be told which SoC is in use based on the device name, and use that
> to look up SoC-specific data?

The soc data driver is use to describe the pin group and function
information of peripherals managed by a pin controller. It is more
traditional and simpler to put the device specific parameters into the
platform data.


>
>>>> +static struct platform_driver adi_pinctrl_driver = {
>>>> +     .probe          = adi_pinctrl_probe,
>>>> +     .remove         = adi_pinctrl_remove,
>>>> +     .driver         = {
>>>> +             .name   = DRIVER_NAME,
>>>> +     },
>>>> +};
>>>> +
>>>> +static struct platform_driver adi_gpio_pint_driver = {
>>>> +     .probe          = adi_gpio_pint_probe,
>>>> +     .remove         = adi_gpio_pint_remove,
>>>> +     .driver         = {
>>>> +             .name   = "adi-gpio-pint",
>>>> +     },
>>>> +};
>>>> +
>>>> +static struct platform_driver adi_gpio_driver = {
>>>> +     .probe          = adi_gpio_probe,
>>>> +     .remove         = adi_gpio_remove,
>>>> +     .driver         = {
>>>> +             .name   = "adi-gpio",
>>>> +     },
>>>> +};
>>>
>>> Hmmm. Is there one HW block that controls GPIOs and pinctrl, or are
>>> there separate HW blocks?
>>>
>>> If there's one HW block, why not have just one driver?
>>>
>>> If there are separate HW blocks, then having separate GPIO and pinctrl
>>> drivers seems like it would make sense.
>>
>> There are 6 to 9 GPIO HW blocks in one Blackfin SoC. Function
>> pinmux_enable_setting() in current pinctrl framework assumes the
>> function mux setting of one peripheral pin group is configured in one
>> pinctrl device. But, the function mux setting of one blackfin
>> peripheral may be done among different GPIO HW blocks. So, I have to
>> separate the pinctrl driver from the GPIO block driver add the ranges
>> of all GPIO blocks into one pinctrl device for Blackfin.
>
> I don't think you need separate device; the pin control mapping table
> entries for a particular state simply needs to include entries for
> multiple pin controllers.
>

Calling pinctrl_select_state() multiple times with different pin
controllers is not an atomic operation. If the second call fails, the
pins requested successfully in the first call won't be freed
automatically.

And it is more complicated for peripheral driver to handle pin group
and function in multiple pin controllers. The peripheral driver has to
know explicit which pinctrl devices to select other than calling the
default devm_pinctrl_get_select_default().

So, I think if multiple gpio devices should be set up together for one
peripheral, having one pin controller device to handle all of them is
a more reasonable and clear solution.


Thanks

Sonic
