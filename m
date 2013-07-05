Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045Ab3GERdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 13:33:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45690 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964963Ab3GERdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 13:33:41 -0400
Message-ID: <51D70356.30707@ti.com>
Date: Fri, 5 Jul 2013 12:33:10 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Taras Kondratiuk <taras@ti.com>
Subject: Re: [RFC PATCH V2 1/8] regulator: Introduce OMAP regulator to control
 PMIC over VC/VP
References: <1371849949-12649-1-git-send-email-nm@ti.com> <1371849949-12649-2-git-send-email-nm@ti.com> <20130704154105.GD27646@sirena.org.uk> <20130705135507.GA17439@kahuna> <20130705140828.GA27646@sirena.org.uk> <51D6DD3A.1030002@ti.com> <20130705165235.GC27646@sirena.org.uk>
In-Reply-To: <20130705165235.GC27646@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 11:52 AM, Mark Brown wrote:
> On Fri, Jul 05, 2013 at 09:50:34AM -0500, Nishanth Menon wrote:
>> On 07/05/2013 09:08 AM, Mark Brown wrote:
>
>>>> option 1) we just bypass get_voltage/set_voltage to point through to
>>>> this function. result will be something similar to what we got here[1]
>
>>> I don't really know what you mean when you say "bypass get_voltage/set_voltage
>>> so it's kind of hard to comment...  the link you posted appears to be a
>>> link to the code I'm reviewing so it's not terribly enlightening.
>
>> :) it is similar, yes. by bypass get/set_voltage, I mean something like [1]
>
> No, that's not a good idea.

I agree.

>
>>> What makes you think that the existing regulator drivers need to be
>>> modified?
>
>> data path difference - Almost all standard regulators use i2c
>> (standard i2c APIs) for every other SMPS/LDO except for the ones
>> controlled by OMAP custom i2c path(vc/vp), the
>> set_voltage/get_voltage needs a different implementation when it
>> comes to using the vc/vp path.
>
>>> They already have all the data exported to the core (or
>>> should do)...
>
>> I see that twl-regulator does not indeed do it, but, assuming the
>> regulators have all the data exported to the core, the data is
>> hidden in struct regulator_desc which is private to the device and
>> driver. lets go through these:
>
> That's just a simple matter of programming to fix, and any regulator
> which can work with this sort of table based stuff you're looking at
> here must also be able to be converted to work with the equivalent code
> in the regulator core so open coding is a deficiency in the driver.

OK, conceptually, I am a bit lost here (may be I thinking about "how the 
heck am I supposed to implement this?") - Hoping for your patience in 
trying to get through to my thick skull :)

Taking an example of twl-regulator and omap_pmic, are you suggesting 
omap_pmic to be a user twl-regulator using 
include/linux/regulator/consumer.h? or are you suggesting that omap_pmic 
should not be a regulator at all?

Could you suggest what you have in your mind here, I can see how we can 
make that happen. I am not averse to writing new code ofcourse.

>
>>> +	.cmd_reg_addr = 0x00,
>
>> command register is used for sending low power state commands -
>> which is not the same as voltage register or vsel_reg as used in
>> depicted in regulator_desc.	
>
> There's no information about how to use this register in your
> bindings...  but anyway, can't be too hard to add this if it's actually
> used.

Yes it is, and also happens to be how OMAPs achieve maximum power 
savings - when low power modes are achieved in OMAP(automatic hardware 
assisted commands are send to the specific command registers in PMIC and 
viceversa on wakeup) - but this also happens to be very specific to OMAP 
way of handling things. I can refer to the Reference Manual as to how it 
actually works, but that'd be an overkill, I will try to expand on the 
bindings a little more, I guess.

>
>>> +	.i2c_timeout_us = 200,
>
>> yep, does not match up.
>
> Like I say I just don't see why this is even specified per device.
>
>>> +	.max_uV = 1450000,
>
>> can be used with constraints, but most regulator drivers seem to
>> store this internally.
>
> Or just trivially calculate it as we do currently.
>
>>> +	.voltage_selector_offset = 0,
>>> +	.voltage_selector_mask = 0x7F,
>>> +	.voltage_selector_setbits = 0x0,
>>> +	.voltage_selector_zero = false,
>
>> to an extent we can map these to vsel_mask, linear_min_sel etc.
>> (again assuming the regulator driver has populated it - most that
>> implement custom set_voltage, get_voltage do not do that.
>
> Anything that implements a custom set_voltage() won't work with your
> data structure either...

It would not work with OMAP either ;). But that said, drivers do freely 
implement custom set_voltage/get_voltage primarily because there are 
ranges in supported voltages that are non-linear and try to be generic 
to work on non-OMAP platforms as well. However, within the supported 
range, only the linear ranges are used with OMAP.

>
>> Other option is to make rdev available to omap_pmic regulator -
>> which again implies change in existing regulator driver?
>
> Why would any of the drivers need to change to do this?  They're already
> exporting the information.
I am thinking here: two regulator drivers, using same rdev/desc for 
getting the data. probably makes no sense, I agree.

>
>>> the only thing that's missing is the timeouts and it's
>>> not at all obvious why those need to be tuned per device.
>
>> OMAP VC hardware has no idea about how long to wait before giving up
>> on an ongoing i2c transaction. This may depend on PMIC and what it
>> does before acking on i2c.
>
> So pick a high number (it's only for error cases...)?
>
from hardware perspective yeah, if it does not lockup (based on erratas 
on specific devices ;) ). it also controls in part, the latency of 
response to Voltage processor from Voltage controller also needed for 
computing SmartReflex latencies (as it should consider worst case 
conditions)

-- 
Regards,
Nishanth Menon
