Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab3H2JSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:18:38 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:63837 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3H2JSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:18:37 -0400
MIME-Version: 1.0
In-Reply-To: <521E07DB.3050204@wwwdotorg.org>
References: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
	<52150AD9.3040808@wwwdotorg.org>
	<CAJxxZ0O77bgP8_rkRm-EgjAJ45SY2Pd3AGVSMhFxbsfNUmiqGg@mail.gmail.com>
	<52167900.3040502@wwwdotorg.org>
	<CAJxxZ0PVCY_Hmqdi243gSLGc_vuyx4AbCSdADU5daEqbKar5KA@mail.gmail.com>
	<521D1C8F.7090006@wwwdotorg.org>
	<CAJxxZ0O=r8hydMU3K44b_FnTyWir2yrVBON6d4TfAhY+dxuTVw@mail.gmail.com>
	<521E07DB.3050204@wwwdotorg.org>
Date: Thu, 29 Aug 2013 17:18:36 +0800
Message-ID: <CAJxxZ0PcrqQ+_rcV=qJd_T8kHTyruZRQS0Kyfa-bYYd3trRRKw@mail.gmail.com>
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

On Wed, Aug 28, 2013 at 10:23 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/27/2013 09:56 PM, Sonic Zhang wrote:
>> Hi Stephen,
>>
>> On Wed, Aug 28, 2013 at 5:39 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On 08/27/2013 03:30 AM, Sonic Zhang wrote:
>>>> Hi Stephen,
>>>>
>>>> On Fri, Aug 23, 2013 at 4:48 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>>> On 08/22/2013 01:07 AM, Sonic Zhang wrote:
>>>>>> Hi Stephen,
>>>>>>
>>>>>> On Thu, Aug 22, 2013 at 2:45 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>>>>> On 08/21/2013 12:30 AM, Sonic Zhang wrote:
>>>>>>>> From: Sonic Zhang <sonic.zhang@analog.com>
>>>>>>>>
>>>>>>>> The new ADI GPIO2 controller was introduced since the BF548 and BF60x
>>>>>>>> processors. It differs a lot from the old one on BF5xx processors. So,
>>>>>>>> create a pinctrl driver under the pinctrl framework.
>>>
>>>>>> The
>>>>>> pinctrl_id field in platform data is to make the driver flexible for
>>>>>> future SoCs. If the later case is true, I can just fix the pinctrl
>>>>>> device name to "pinctrl-adi2.0".
>>>>>
>>>>> I was talking about pdata->port_pin_base being passed to
>>>>> gpiochip_add_pin_range(), not the device name.
>>>>>
>>>>>> The GPIO device's HW regsiter base, pin base, pin number and the
>>>>>> relationship with the PINT device are defined in the platform data.
>>>>>
>>>>> Hmmm. I suppose with a platform-data-based driver, there isn't a good
>>>>> opportunity to encode which HW the code is running on, and then derive
>>>>> those parameters from the SoC type and/or put that information into
>>>>> device tree. Perhaps platform data is the only way, although isn't there
>>>>> some kind of "device ID -> data" mapping table option, so that probe()
>>>>> can be told which SoC is in use based on the device name, and use that
>>>>> to look up SoC-specific data?
>>>>
>>>> The soc data driver is use to describe the pin group and function
>>>> information of peripherals managed by a pin controller. It is more
>>>> traditional and simpler to put the device specific parameters into the
>>>> platform data.
>>>
>>> Sure, that's the way things have been done historically. However, if
>>> there's a better way, one may as well use it.
>>>
>>>>
>>>>
>>>>>
>>>>>>>> +static struct platform_driver adi_pinctrl_driver = {
>>>>>>>> +     .probe          = adi_pinctrl_probe,
>>>>>>>> +     .remove         = adi_pinctrl_remove,
>>>>>>>> +     .driver         = {
>>>>>>>> +             .name   = DRIVER_NAME,
>>>>>>>> +     },
>>>>>>>> +};
>>>>>>>> +
>>>>>>>> +static struct platform_driver adi_gpio_pint_driver = {
>>>>>>>> +     .probe          = adi_gpio_pint_probe,
>>>>>>>> +     .remove         = adi_gpio_pint_remove,
>>>>>>>> +     .driver         = {
>>>>>>>> +             .name   = "adi-gpio-pint",
>>>>>>>> +     },
>>>>>>>> +};
>>>>>>>> +
>>>>>>>> +static struct platform_driver adi_gpio_driver = {
>>>>>>>> +     .probe          = adi_gpio_probe,
>>>>>>>> +     .remove         = adi_gpio_remove,
>>>>>>>> +     .driver         = {
>>>>>>>> +             .name   = "adi-gpio",
>>>>>>>> +     },
>>>>>>>> +};
>>>>>>>
>>>>>>> Hmmm. Is there one HW block that controls GPIOs and pinctrl, or are
>>>>>>> there separate HW blocks?
>>>>>>>
>>>>>>> If there's one HW block, why not have just one driver?
>>>>>>>
>>>>>>> If there are separate HW blocks, then having separate GPIO and pinctrl
>>>>>>> drivers seems like it would make sense.
>>>>>>
>>>>>> There are 6 to 9 GPIO HW blocks in one Blackfin SoC. Function
>>>>>> pinmux_enable_setting() in current pinctrl framework assumes the
>>>>>> function mux setting of one peripheral pin group is configured in one
>>>>>> pinctrl device. But, the function mux setting of one blackfin
>>>>>> peripheral may be done among different GPIO HW blocks. So, I have to
>>>>>> separate the pinctrl driver from the GPIO block driver add the ranges
>>>>>> of all GPIO blocks into one pinctrl device for Blackfin.
>>>>>
>>>>> I don't think you need separate device; the pin control mapping table
>>>>> entries for a particular state simply needs to include entries for
>>>>> multiple pin controllers.
>>>>
>>>> Calling pinctrl_select_state() multiple times with different pin
>>>> controllers is not an atomic operation. If the second call fails, the
>>>> pins requested successfully in the first call won't be freed
>>>> automatically.
>>>
>>> Drivers should only call pinctrl_select_state() once. The state that
>>> gets selected can affect multiple pin controllers at once. This should
>>> be an atomic operation as far as the client driver is concerned. If any
>>> of that isn't true, it's a bug in pinctrl.
>>
>> /**
>>  * pinctrl_select_state() - select/activate/program a pinctrl state to HW
>>  * @p: the pinctrl handle for the device that requests configuration
>>  * @state: the state handle to select/activate/program
>>  */
>> int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
>>
>> If drivers should still call pinctrl_select_state() once in case of
>> multiple pin controllers, the first parameter of
>> pinctrl_select_state() is wrong. Which pinctrl device among all
>> affected pin controllers  should the driver use? Or whatever pinctrl
>> device?
>
> The function prototype is not wrong. "struct pinctrl *p" is not a
> pinctrl device, but rather it's the result of calling pinctrl_get().
> This value encompasses all information required to program all pinctrl
> HW devices that need to be programmed.

Thanks to explain. I didn't dig into struct pinctrl much.

Regards,

Sonic

>
>> To separate the pinctrl_settings of one peripheral to multiple pinctrl
>> devices, multiple pinctrl group arrays and function arrays should be
>> defined in the soc data file. This change increases the code size of
>> the soc data file a lot without get any real benefits. The pin
>> controller device can be defined as a logic device to cover all gpio
>> devices, which are mapped into one peripheral pin id space without
>> collision. All overhead in the soc data file can be removed in this
>> way.
>
> It's possible to debate how to construct the pinctrl drivers themselves,
> but this has no impact at all on how a client driver calls the pinctrl APIs.
>
