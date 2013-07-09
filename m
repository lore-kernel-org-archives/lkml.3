Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab3GIQFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:05:02 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47018 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3GIQE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:04:58 -0400
Message-ID: <51DC3487.2080503@ti.com>
Date: Tue, 9 Jul 2013 11:04:23 -0500
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
References: <1371849949-12649-1-git-send-email-nm@ti.com> <1371849949-12649-2-git-send-email-nm@ti.com> <20130704154105.GD27646@sirena.org.uk> <20130705135507.GA17439@kahuna> <20130705140828.GA27646@sirena.org.uk> <51D6DD3A.1030002@ti.com> <20130705165235.GC27646@sirena.org.uk> <51D70356.30707@ti.com> <20130705174727.GF27646@sirena.org.uk> <51DAF55C.5040502@ti.com> <20130709152954.GF27646@sirena.org.uk>
In-Reply-To: <20130709152954.GF27646@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 10:29 AM, Mark Brown wrote:
> On Mon, Jul 08, 2013 at 12:22:36PM -0500, Nishanth Menon wrote:
>
>> case #1 - TPS62361 has a single SMPS and a single generic i2c bus,
>> one can talk on. In this case, you'd associate the regulator device
>> in one place - i2cX or on custom SoC hardware interface.
>
>> When used with custom SoC hardware interface, generic tps62361
>> regulator which talks regular i2c wont even probe for omap_pmic to
>> get the regulator data from tps62361 regulator driver. Even if we
>> were to define the generic TPS62361 in dts nodes, it will fail probe
>> as it cant access any of it's registers using generic i2c.
>
> This seems like something we should be able to cope with by for example
> adding a bus for the custom PMIC interface or otherwise finding a way to

I had considered introducing a custom bus for custom PMIC interface, but 
as you stated below, standard regulators will probably need some custom 
monkeying around.

> get to the data at runtime based on the compatible string.  This would
> need some custom code in the regulators but would have the advantage of
> keeping the data the same at least.  Hrm.

Ofcourse,this will be to add custom set/get_voltage implementation using 
this "custom API" which we discussed was'nt that good an idea.

I am at a stalemate as to where we should go from here.

>
>>> Another option is for the drivers to provide the data and use the
>>> helpers for their linear ranges as part of a more complex
>>> implementation.
>
>> Having looked at a few regulator driver implementations, there seems
>> to be the following combinations:
>> a) drivers which have n ranges of linear voltages for incremental selector
>> b) drivers with 1 range of linear voltages only for all ranges of selectors
>> c) drivers with 1 range of linear voltages and nonlinear voltage
>> values for other vsels.
>
> Everything else is just a special case of option a - either there's just
> a single range or there's a bunch of ranges each with a single value.  I
> suspect that ranges will be the most useful thing for any hardware which
> can practically be used by these regulators anyway.

True, but slightly different topic though.

>
>>> OK, that's a bit more fun but I think the kernel wants that information
>>> in general anyway since a software cpufreq driver or something might
>>> want to make the same latency decisions.  This is what set_voltage_time()
>>> is for in part.  But to a first approximation is there really much
>>> variation in the numbers?
>
>> between PMICs? yep, twl4030 does 4mV/uSec, 6030 can do 6mV/uSec,
>> TPS62361 can do 32mV/uSec, TWL6035/37 does 0.220mV/uSec
>
> Those are ramp rates, they're not I2C I/O limits.  Ramp rates we already
> know about.  I think what you're saying here is that this latency value
> is actually about worst case ramp times?
Arrgh.. my bad. I confused ramp time with I2C transfer timeout 
parameter. I know that I2C bus can be held[1] by PMIC as long as it is 
busy. Some custom ASIC can do some weird stuff I suppose. I dont seem to 
have clear data points in the sketchy TRMs for 6030/2 , 6035, 5030, for 
these other than to state it is i2c specification compliant (/me 
grumbles). So, I just have emperical value which is a bit conservative 
and seem to work on the devices.


[1] http://www.i2c-bus.org/clock-generation-stretching-arbitration/
-- 
Regards,
Nishanth Menon
