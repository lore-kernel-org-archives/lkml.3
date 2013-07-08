Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3GHRXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:23:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44156 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074Ab3GHRXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:23:07 -0400
Message-ID: <51DAF55C.5040502@ti.com>
Date: Mon, 8 Jul 2013 12:22:36 -0500
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
References: <1371849949-12649-1-git-send-email-nm@ti.com> <1371849949-12649-2-git-send-email-nm@ti.com> <20130704154105.GD27646@sirena.org.uk> <20130705135507.GA17439@kahuna> <20130705140828.GA27646@sirena.org.uk> <51D6DD3A.1030002@ti.com> <20130705165235.GC27646@sirena.org.uk> <51D70356.30707@ti.com> <20130705174727.GF27646@sirena.org.uk>
In-Reply-To: <20130705174727.GF27646@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 12:47 PM, Mark Brown wrote:
> On Fri, Jul 05, 2013 at 12:33:10PM -0500, Nishanth Menon wrote:
>
>> Taking an example of twl-regulator and omap_pmic, are you suggesting
>> omap_pmic to be a user twl-regulator using
>> include/linux/regulator/consumer.h? or are you suggesting that
>> omap_pmic should not be a regulator at all?
>
> No, I'm suggesting that omap_pmic find the TWL driver data at runtime
> (eg, using the device tree to locate the relevant regulator) and get the
> information out of the regulator driver that way.  It can then tell the
> hardware about the data that way without having to explictly add every
> single regulator both standalone and to the OMAP driver.

Apologies on delayed response, I had spend sometime thinking about 
this(and try some prototype code), here it goes:

case #1 - TPS62361 has a single SMPS and a single generic i2c bus, one 
can talk on. In this case, you'd associate the regulator device in one 
place - i2cX or on custom SoC hardware interface.

When used with custom SoC hardware interface, generic tps62361 regulator 
which talks regular i2c wont even probe for omap_pmic to get the 
regulator data from tps62361 regulator driver. Even if we were to define 
the generic TPS62361 in dts nodes, it will fail probe as it cant access 
any of it's registers using generic i2c.

case #2 - TWL6030/2 has a multiple SMPS and LDOs and a two i2c bus one 
can talk on. however, SMPS meant for SoC can only be controlled by 
custom SoC hardware. In this case, we'd not even have a 
regulator_register taking place for SMPS controlled by custom hardware.

I am lost as to how we can even do this?

All the dts node tells for an SMPS today is:
vaux3: regulator-vaux3 {
         compatible = "ti,twl6030-vaux3";
} as an example.
the slew data is embedded inside the twl-regulator data structures - if 
it never gets probed, it wont make that data available in regulator core 
information.

so doing something like:
omap_pmic_vdd_mpu {
	pmic-supply = <&vcore1>;
};
wont work, unless we define a phandle vcore1.
vcore1: regulator-vcore1 {
	compatible="ti,twl6030-vcore1";
};
wont help us either, because this wont be an SMPS that twl-regulator can 
even try to control.

So, how would omap_pmic find vcore1 twl driver data when it does not 
even twl6030 does not even probe vcore1? and making twl-regulator.c 
probe vcore1 (aka making it probe for a device that it cannot manage) is 
conceptually wrong, no (not to mention wrong definition of two device 
nodes in dt blob for the same device)?


>
>>> There's no information about how to use this register in your
>>> bindings...  but anyway, can't be too hard to add this if it's actually
>>> used.
>
>> Yes it is, and also happens to be how OMAPs achieve maximum power
>> savings - when low power modes are achieved in OMAP(automatic
>> hardware assisted commands are send to the specific command
>> registers in PMIC and viceversa on wakeup) - but this also happens
>> to be very specific to OMAP way of handling things. I can refer to
>> the Reference Manual as to how it actually works, but that'd be an
>> overkill, I will try to expand on the bindings a little more, I
>> guess.
>
> OK, so this is a register defined by the OMAP architecture?  I think

I might say yes, but that will only be because I just know OMAP 
architecture alone, Have'nt had enough indepth knowledge of other 
architectures to make a broader statement :(

> it's reasonable to add something to allow this to be obtained to the
> core, using a DT property seems yucky since every board usingt this is
> going to have to cut'n'paste the value.  Some sort of custom parameter
> readback thing perhaps, it doesn't have to be too generic.

custom of->match data parameter is how it is done today in this patch

>
>>> Anything that implements a custom set_voltage() won't work with your
>>> data structure either...
>
>> It would not work with OMAP either ;). But that said, drivers do
>
> Yes, that's kind of my point - as with the code Paul was implementing it
> doesn't matter if you can't support every single regualtor since the
> hardware design constrains what the regulator can do.  The regualtor
> framework already has helpers which factor out the code for anything
> which has the limiations the OMAP hardware has (or where it doesn't we
> could add them) so there shouldn't be any need for a driver to provide
> custom callbacks.

custom callback context was as follows: if we force the SoC generic 
regulators to use OMAP custom interfaces, then we have a need for custom 
callbacks, else w.r.t PMIC data, covered above, we do not need any 
custom callbacks, agreed.

>> freely implement custom set_voltage/get_voltage primarily because
>> there are ranges in supported voltages that are non-linear and try
>> to be generic to work on non-OMAP platforms as well. However, within
>> the supported range, only the linear ranges are used with OMAP.
>
> OK, that's a bit more interesting but I expect such regulators will
> actually work with the linear ranges helpers I added the other day
> (Marvell had a PMIC using them and I realised that the same pattern can
> be applied to a bunch of other devices).  Do you think that'd cover the
> cases you're aware of?
>
> Another option is for the drivers to provide the data and use the
> helpers for their linear ranges as part of a more complex
> implementation.

Having looked at a few regulator driver implementations, there seems to 
be the following combinations:
a) drivers which have n ranges of linear voltages for incremental selector
b) drivers with 1 range of linear voltages only for all ranges of selectors
c) drivers with 1 range of linear voltages and nonlinear voltage values 
for other vsels.


>
>>>> OMAP VC hardware has no idea about how long to wait before giving up
>>>> on an ongoing i2c transaction. This may depend on PMIC and what it
>>>> does before acking on i2c.
>
>>> So pick a high number (it's only for error cases...)?
>
>> from hardware perspective yeah, if it does not lockup (based on
>> erratas on specific devices ;) ). it also controls in part, the
>> latency of response to Voltage processor from Voltage controller
>> also needed for computing SmartReflex latencies (as it should
>> consider worst case conditions)
>
> OK, that's a bit more fun but I think the kernel wants that information
> in general anyway since a software cpufreq driver or something might
> want to make the same latency decisions.  This is what set_voltage_time()
> is for in part.  But to a first approximation is there really much
> variation in the numbers?

between PMICs? yep, twl4030 does 4mV/uSec, 6030 can do 6mV/uSec, 
TPS62361 can do 32mV/uSec, TWL6035/37 does 0.220mV/uSec

For a given PMIC, voltage X to Y time will vary ofcourse. SmartReflex 
AVS is something cpufreq wont know about -> completely different topic 
of its own :)

What we are representing is data for PMIC supported on specific SoC 
hardware controller interface meant just for PMIC - IMHO, it is similar 
to data that twl-regulator stores for the SMPS/LDOs that it can control 
- given these are starting to become legacy platforms (OMAP3,4,5) and 
the fact that it is a one-off(at this point in time) knwon custom 
hardware doing stuff like this, we would'nt expect too much churn either 
there(new PMICs added etc). On the flip side, I do understand your 
concern with scalability and ease of re-use here. but given that we 
have'nt seen much of a churn in this data for years on the go now, I'd 
expect lesser in the future. This dedicated interface has been dropped 
in our future chips precisely due to the lack of scalability to PMIC 
choices such as those using SPI.

just my 2 cents.
-- 
Regards,
Nishanth Menon
