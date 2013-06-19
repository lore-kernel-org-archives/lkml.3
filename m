Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237Ab3FSLEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:04:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39331 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934022Ab3FSLEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:04:14 -0400
Message-ID: <51C19011.5050107@ti.com>
Date: Wed, 19 Jun 2013 14:03:45 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ARM: dts: omap4-panda: Add USB Host support
References: <1371571487-14389-1-git-send-email-rogerq@ti.com> <1371571487-14389-2-git-send-email-rogerq@ti.com> <51C106A1.9030001@ti.com> <51C15F7E.5020305@ti.com> <20130619074605.GW5523@atomide.com> <51C183AC.8040801@ti.com>
In-Reply-To: <51C183AC.8040801@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 01:10 PM, Benoit Cousson wrote:
> On 06/19/2013 02:46 AM, Tony Lindgren wrote:
>> * Roger Quadros <rogerq@ti.com> [130619 00:42]:
>>> Hi Benoit,
>>>
>>> On 06/19/2013 04:17 AM, Benoit Cousson wrote:
>>>> Hi Roger,
>>>>
>>>> On 06/18/2013 11:04 AM, Roger Quadros wrote:
>>>>> Provide the RESET and Power regulators for the USB PHY,
>>>>> the USB Host port mode and the PHY device.
>>>>>
>>>>> Also provide pin multiplexer information for the USB host
>>>>> pins.
>>>>>
>>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>>> ---
>>>>>    arch/arm/boot/dts/omap4-panda-common.dtsi |   62 +++++++++++++++++++++++++++++
>>>>>    1 files changed, 62 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
>>>>> index 00cbaa5..7a21e8e 100644
>>>>> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
>>>>> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
>>>>> @@ -59,6 +59,42 @@
>>>>>                "AFML", "Line In",
>>>>>                "AFMR", "Line In";
>>>>>        };
>>>>> +
>>>>> +    /* HS USB Port 1 RESET */
>>>>> +    hsusb1_reset: hsusb1_reset_reg {
>>>>> +        compatible = "regulator-fixed";
>>>>> +        regulator-name = "hsusb1_reset";
>>>>> +        regulator-min-microvolt = <3300000>;
>>>>> +        regulator-max-microvolt = <3300000>;
>>>>> +        gpio = <&gpio2 30 0>;    /* gpio_62 */
>>>>> +        startup-delay-us = <70000>;
>>>>> +        enable-active-high;
>>>>> +    };
>>>>
>>>> Is this really a regulator? Or just a GPIO line used to reset the USB PHY?
>>>
>>> It is in fact a GPIO line used as reset.
>>>>
>>>> If this is the case, I don't think it should be represented as a regulator.
>>>
>>> Why not? I think it fits very well in the regulator device model.
> 
> I'm not sure fitting very well is the correct term.
> It works, for sure, but it is no different than when we were trying to abuse the regulator fmwk to enable the 32k clock in phoenix.
> It is just a hack.
> 

The only difference is there is a dedicated framework for clocks. Since there is nothing specific to
handle reset lines it is left to the driver writer how he wants to manage it.

>>> I couldn't find a better
>>> way to represent this. It gives us a way to specify not only the GPIO line but also
>>> the polarity. I know mostly reset is active low but still there is flexibility as you never
>>> know for sure.
> 
> Mmm, and what about just controlling the gpio from the driver?

Yes gpio is possible. But then you need to add additional code in the driver to parse GPIO number and polarity.
Using regulator_get() was plain simple for me.

> 
>> I think it's really a mux + a comparator. But from Linux driver point of view
>> a regulator fits well as we don't have anything better. After all, the pin
>> voltage changes, and then something can be done based on the comparator
>> value.
>>
>>> Do you have any better ideas?
>>
>> We have a similar issue with the MMC1 PBIAS. I think in the long run we
>> should expand regulator (and possibly pinctrl) framework(s) to handle
>> comparators. We could just assume that a comparatator is a regulator,
>> and have a comparator binding that just uses the regulator code.
> 
> In the case of pbias, the pinctrl seems to be a much better fit for my point of view. pinctrl can handle pin configuration and this is what the pbias is in the case of MMC pins.
> 
>>> FYI. The USB PHY driver is already treating reset as a regulator and is into 3.10. Reworking that
>>> will take some time. Not getting these in will prevent USB host/ethernet support on panda.
> 
> That's not because we did some mistake in the past that we have to keep doing that :-)
> 

I had actually thought it well and don't consider it as a mistake. It is just a difference in opinion.

>> Yes and we need to have some solution for v3.11 as we've dropped the
>> legacy data for omap4. Otherwise things won't work properly.
> 
> I'm fine taking it as soon as big disclaimer is added to avoid mis-using the regulator in the future for controlling a gpio line.
> 

I can re-work the phy driver. No problem. But I'm still not convinced
what it will improve. IMHO it just adds more code in the phy driver without any benefits.

cheers,
-roger

