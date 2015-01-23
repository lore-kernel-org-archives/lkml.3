Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbbAWGt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:49:27 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:13644 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbbAWGtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:49:24 -0500
X-IronPort-AV: E=Sophos;i="5.09,453,1418112000"; 
   d="scan'208";a="55576653"
Message-ID: <54C1EEF3.4040406@broadcom.com>
Date: Thu, 22 Jan 2015 22:49:23 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Scott Branden <sbranden@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/4] pinctrl: Broadcom Cygnus pinctrl device tree binding
References: <rjui@broadcom.com>	<1417131990-17954-1-git-send-email-rjui@broadcom.com>	<1417131990-17954-2-git-send-email-rjui@broadcom.com>	<CACRpkdb5pNMbXmWGjrGpAYNLLwv6pWWOJQy0C6BLetNcStFM6A@mail.gmail.com>	<54B01D44.5080601@broadcom.com> <CACRpkdbW5P=w0CPYYf_gfBuD7W0WOdAYCKpTXM5MsK9mdYDc5w@mail.gmail.com> <54C1AE9F.3020407@broadcom.com>
In-Reply-To: <54C1AE9F.3020407@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/22/2015 6:14 PM, Ray Jui wrote:
> 
> 
> On 1/13/2015 12:20 AM, Linus Walleij wrote:
>> On Fri, Jan 9, 2015 at 7:26 PM, Ray Jui <rjui@broadcom.com> wrote:
>>> On 1/9/2015 2:12 AM, Linus Walleij wrote:
>>
>>>> Just use "groups" and "function" and refer to
>>>> Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
>>>>
>>>> Then "alt1", "alt2" etc are non-functional names of functions.
>>>> Use the real function names, like "spi0" or so. This
>>>> alt-business seems to be just a shortcut to make it
>>>> simple, don't do that.
>>>>
>>>> Then you use e.g. "spi0" as a group name. I prefer you
>>>> call that "spi0_grp" or something to say it is a group of
>>>> pins associated with spi0, as spi0 is actually the
>>>> function.
>>>>
>>> Hmmm, I did this by following brcm,bcm11351-pinctrl.txt:
>>> - function: String. Specifies the pin mux selection. Values must be one
>>> of: "alt1", "alt2", "alt3", "alt4"
>>>
>>> But you are right, in the pinctrl binding document it describes the
>>> generic pin multiplexing nodes use "function" and "group".
>>
>> Note "function" and "groups". Note groups is pluralis. You can
>> select multiple groups for a single function.
>>
>>> For example, the group "lcd" covers 30 pins. When I configure "lcd" to
>>> alternate function 1, all 30 pins are muxed to LCD function. When
>>> configured to function 2, all pins are muxed to SRAM function. Now, here
>>> comes the issue, when configured to function 3, pins 1-15 and 20-30
>>> become GPIO function, but pins 16-19 becomes SPI5 function. When it's
>>> configured to function 4, all 30 pins become GPIO.
>>
>> I would split the use case in two groups for LCD and SRAM,
>> and three groups for GPIO:
>> "lcd_grp", "sram_grp", "gpio-1-15_grp",
>> "gpio-16-19_grp", "gpio-20-30_grp", "spi5_grp"
>>
>> Valid combinations become
>>
>> function = "lcd"
>> groups = "lcd_grp";
>>
>> function = "sram"
>> groups = "sram_grp"
>>
>> For all GPIO only this:
>>
>> function = "gpio"
>> groups = "gpio-1-16_grp", "gpio-16-19_grp", "gpio-20-30_grp"
>>
>> For a combined GPIO+SPI:
>>
>> function = "gpio"
>> groups = "gpio-1-16_grp", "gpio-20-30_grp"
>>
>> function = "spi5"
>> groups = "spi5_grp"
>>
>> The pinctrl runtile will protest if you try to combine spi5_grp
>> with gpio-16-19_grp.
>>
>>> In some other cases, when I configure a group to other functions, there
>>> could be spare pins which become unused (not brought out to the pad).
>>> Or, the spare pins may also become a separate function.
>>
>> That's cool.
>>
>>> Based on the LCD example, I'd assume I would do the following for the
>>> default LCD function:
>>>
>>> lcd_node {
>>>         group = "lcd_grp";
>>>         function = "lcd";
>>> };
>>>
>>> And in the case of function 3, I would call the function "spi5" and
>>> assume the rest of pins become either GPIO (or unused)?
>>>
>>> spi5_node {
>>>         group = "lcd_grp";
>>>         function = "spi5";
>>> };
>>
>> Looks cool per above.
>>
>> You need some clever code in the driver to handle double-configuration
>> of registers and so on, but I think it can be done.
>>
>> Using pin control as a GPIO backend can be a bit tricky and will need
>> some testing and elaboration, but the subsystem will block collisions.
>>
>> Yours,
>> Linus Walleij
>>
> 
> Hi Linus,
> 
> I have another question here. In the B0 revision of our Cygnus chip, the
> ASIC team added a feature to allow individual pins to be muxed to GPIO.
> The pinmux controller can still only do group-based muxing in general,
> but at the same time, you can override most (but not all) individual
> pins to GPIO.
> 
> I believe this HW design actually forces us to mix use "groups" and
> "pins" in DT.
> 
> For example, assuming we mux pins 1 - 10 as MMC (one cmd line, one clk
> line, and 8 data lines). One might make the decision that he only needs
> 4 data lines instead of 8 data lines, and he wants to free up the 4 data
> lines and uses as GPIO. Based on this example, is the following DT
> configuration valid?
> 
> sd_node {
>     function = "sd";
>     groups = "sd_grps";
> };
> 
> gpio_node {
>     function = "gpio";
>     pins = "gpio_7", "gpio_8", "gpio_9", "gpio_10"; /* assuming 1:1
> mapping between gpio and pin number to make this example simple */
> };
> 
> Thanks,
> 
> Ray
>

I dig into the pinctrl framework code a bit more and found that I can
use pinctrl_request_gpio from the GPIO driver and implement
gpio_request_enable in the pinctrl driver.

The only problem I see now is that these APIs seem to expect the use of
global GPIO numbers? And all pinctrl drivers I checked seem to be hard
coding the GPIO to pin mapping when declaring the struct
pinctrl_gpio_range array. How would this work in a system like ours that
have 3 GPIO controllers and was required to use a dynamic GPIO number
(i.e., we use gpio->base = -1, so it derives the base from
CONFIG_ARCH_NR_GPIO and goes backwards)?

I guess I can do some runtime calculation in my pinctrl driver to figure
out the GPIO->pin mapping based on CONFIG_ARCH_NR_GPIO, but this is
assuming that we always fix the order of the device nodes of the 3 GPIO
controllers.

I hope I'm not missing something here?

Thanks,

Ray
