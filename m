Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3H0Vje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:39:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41485 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3H0Vjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:39:31 -0400
Message-ID: <521D1C8F.7090006@wwwdotorg.org>
Date: Tue, 27 Aug 2013 15:39:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sonic Zhang <sonic.adi@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 1/3 v3] pinctrl: ADI PIN control driver for the GPIO controller
 on bf54x and bf60x.
References: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com> <52150AD9.3040808@wwwdotorg.org> <CAJxxZ0O77bgP8_rkRm-EgjAJ45SY2Pd3AGVSMhFxbsfNUmiqGg@mail.gmail.com> <52167900.3040502@wwwdotorg.org> <CAJxxZ0PVCY_Hmqdi243gSLGc_vuyx4AbCSdADU5daEqbKar5KA@mail.gmail.com>
In-Reply-To: <CAJxxZ0PVCY_Hmqdi243gSLGc_vuyx4AbCSdADU5daEqbKar5KA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 03:30 AM, Sonic Zhang wrote:
> Hi Stephen,
> 
> On Fri, Aug 23, 2013 at 4:48 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 08/22/2013 01:07 AM, Sonic Zhang wrote:
>>> Hi Stephen,
>>>
>>> On Thu, Aug 22, 2013 at 2:45 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>> On 08/21/2013 12:30 AM, Sonic Zhang wrote:
>>>>> From: Sonic Zhang <sonic.zhang@analog.com>
>>>>>
>>>>> The new ADI GPIO2 controller was introduced since the BF548 and BF60x
>>>>> processors. It differs a lot from the old one on BF5xx processors. So,
>>>>> create a pinctrl driver under the pinctrl framework.

>>> The
>>> pinctrl_id field in platform data is to make the driver flexible for
>>> future SoCs. If the later case is true, I can just fix the pinctrl
>>> device name to "pinctrl-adi2.0".
>>
>> I was talking about pdata->port_pin_base being passed to
>> gpiochip_add_pin_range(), not the device name.
>>
>>> The GPIO device's HW regsiter base, pin base, pin number and the
>>> relationship with the PINT device are defined in the platform data.
>>
>> Hmmm. I suppose with a platform-data-based driver, there isn't a good
>> opportunity to encode which HW the code is running on, and then derive
>> those parameters from the SoC type and/or put that information into
>> device tree. Perhaps platform data is the only way, although isn't there
>> some kind of "device ID -> data" mapping table option, so that probe()
>> can be told which SoC is in use based on the device name, and use that
>> to look up SoC-specific data?
> 
> The soc data driver is use to describe the pin group and function
> information of peripherals managed by a pin controller. It is more
> traditional and simpler to put the device specific parameters into the
> platform data.

Sure, that's the way things have been done historically. However, if
there's a better way, one may as well use it.

> 
> 
>>
>>>>> +static struct platform_driver adi_pinctrl_driver = {
>>>>> +     .probe          = adi_pinctrl_probe,
>>>>> +     .remove         = adi_pinctrl_remove,
>>>>> +     .driver         = {
>>>>> +             .name   = DRIVER_NAME,
>>>>> +     },
>>>>> +};
>>>>> +
>>>>> +static struct platform_driver adi_gpio_pint_driver = {
>>>>> +     .probe          = adi_gpio_pint_probe,
>>>>> +     .remove         = adi_gpio_pint_remove,
>>>>> +     .driver         = {
>>>>> +             .name   = "adi-gpio-pint",
>>>>> +     },
>>>>> +};
>>>>> +
>>>>> +static struct platform_driver adi_gpio_driver = {
>>>>> +     .probe          = adi_gpio_probe,
>>>>> +     .remove         = adi_gpio_remove,
>>>>> +     .driver         = {
>>>>> +             .name   = "adi-gpio",
>>>>> +     },
>>>>> +};
>>>>
>>>> Hmmm. Is there one HW block that controls GPIOs and pinctrl, or are
>>>> there separate HW blocks?
>>>>
>>>> If there's one HW block, why not have just one driver?
>>>>
>>>> If there are separate HW blocks, then having separate GPIO and pinctrl
>>>> drivers seems like it would make sense.
>>>
>>> There are 6 to 9 GPIO HW blocks in one Blackfin SoC. Function
>>> pinmux_enable_setting() in current pinctrl framework assumes the
>>> function mux setting of one peripheral pin group is configured in one
>>> pinctrl device. But, the function mux setting of one blackfin
>>> peripheral may be done among different GPIO HW blocks. So, I have to
>>> separate the pinctrl driver from the GPIO block driver add the ranges
>>> of all GPIO blocks into one pinctrl device for Blackfin.
>>
>> I don't think you need separate device; the pin control mapping table
>> entries for a particular state simply needs to include entries for
>> multiple pin controllers.
> 
> Calling pinctrl_select_state() multiple times with different pin
> controllers is not an atomic operation. If the second call fails, the
> pins requested successfully in the first call won't be freed
> automatically.

Drivers should only call pinctrl_select_state() once. The state that
gets selected can affect multiple pin controllers at once. This should
be an atomic operation as far as the client driver is concerned. If any
of that isn't true, it's a bug in pinctrl.

> And it is more complicated for peripheral driver to handle pin group
> and function in multiple pin controllers. The peripheral driver has to
> know explicit which pinctrl devices to select other than calling the
> default devm_pinctrl_get_select_default().

No; see above.

> So, I think if multiple gpio devices should be set up together for one
> peripheral, having one pin controller device to handle all of them is
> a more reasonable and clear solution.
