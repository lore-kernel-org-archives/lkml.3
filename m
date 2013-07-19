Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761118Ab3GSS7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:59:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46457 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760042Ab3GSS7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:59:00 -0400
Message-ID: <51E98C71.5010709@wwwdotorg.org>
Date: Fri, 19 Jul 2013 12:58:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linus.walleij@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] pinctrl: Add support for additional dynamic states
References: <20130716090310.5541.36777.stgit@localhost> <20130716090536.5541.36289.stgit@localhost> <51E70B5D.6030802@wwwdotorg.org> <20130718073638.GP7656@atomide.com> <51E84180.6080902@wwwdotorg.org> <20130719073957.GZ7656@atomide.com>
In-Reply-To: <20130719073957.GZ7656@atomide.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 01:39 AM, Tony Lindgren wrote:
> * Stephen Warren <swarren@wwwdotorg.org> [130718 12:33]:
>> On 07/18/2013 01:36 AM, Tony Lindgren wrote:
>>> * Stephen Warren <swarren@wwwdotorg.org> [130717 14:30]:
>>>> On 07/16/2013 03:05 AM, Tony Lindgren wrote:
>> ...
>>>> Why shouldn't e.g. a pinctrl-based I2C mux also be able to do runtime
>>>> PM? Does the mux setting select which states are used for runtime PM, or
>>>> does runtime PM override the basic mux setting, or must the pincrl-I2C
>>>> mux manually implement custom runtime-PM/pinctrl interaction since
>>>> there's no generic answer to those questions? How many more custom
>>>> exceptions will there be?
>>>
>>> The idea is that runtime PM will never touch the basic mux settings
>>> at all. The "default" state should be considered a static state
>>> that is claimed during driver probe, and released when the driver
>>> is unloaded. This is typically let's say 90% of the pins for any
>>> device.
>>>
>>> For runtime PM, we can just toggle the PM related pinctrl states as
>>> they have been verified to match the active state during init.
>>>
>>> So I don't see why pinctrl-I2C would have to do anything specific.
>>> All that is required is that the pins are grouped for the consumer
>>> driver, and we can provide some automated checks on the states for
>>> runtime PM.
>>
>> So, consider a pinctrl-based I2C mux. It has 2 states to cover two I2C
>> buses:
>>
>> a) bus 1: I2C controller is muxed out onto one set of pins.
>>
>> b) bus 2: I2C controller is muxed out onto another set of pins.
>>
>> Now, the system could go idle in either of those 2 states, and then
>> later need to return to one of those states. I just don't see how that
>> would work, since the runtime PM code in this series switches to *an*
>> active state when the device becomes non-idle. If the definition of the
>> idle state switches the mux function for both sets of pins to some
>> idle/quiescent value, then you'd need to do different reprogramming when
>> going back to "the" active state; I guess the system would need to
>> remember which state was active before switching to idle, then switch
>> back to that same state rather than hard-coding the active state name as
>> "active"...
> 
> I think the only sane way to deal with this is to make the I2C controller
> to show up as two separate I2C controller instances. Then use runtime
> PM to save and restore the state for each instance, and locking between
> the two driver instances.
> 
> For the pin muxing part, I'd do this:
> 
> 			i2c1 instance	i2c2 instance	notes
> default_state		0 pins		0 pins		(or dedicated pins only)
> active_state		all pins	alls pins
> idle_state		safe mode	safe mode
> 
> Then when i2c1 instance is done, it's runtime PM suspend muxes the pins
> to safe mode, or some nop state. Then when i2c2 instance is woken, it's
> runtime PM resume muxes pins to i2c2.

I see two issues with that approach:

1) Runtime PM doesn't always put a device into an idle state as soon as
its work is done. Sometimes (always?) there is a delay between when the
device is last used and when the HW is actually made idle so that if the
device is re-activated quickly, the kernel hasn't wasted time making it
idle then active again. You'd have to force that delay to complete when
switching between the two virtual controller devices.

2) This requires two separate device objects for the two I2C instances.
I guess you could have the driver for the one I2C mux node end up
instantiating two child devices for this purpose, and hence make that
happen without needing to change the DT ABI. However, that sure feels
complex...

I wonder if it wouldn't be better to have active/idle/sleep as
"modifiers" to the state name rather than alternatives, so you end up
with states named:

default
nobus:active
nobus:idle
nobus:sleep
bus0:active
bus0:idle
bus0:sleep
bus1:active
bus1:idle
bus1:sleep

Of course, if you continue on with that approach (i.e. you add more
sub-fields each separated by a colon), you end up with a huge
combinatorial mess of state names.
