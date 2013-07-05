Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034Ab3GEOvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:51:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55674 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444Ab3GEOvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:51:07 -0400
Message-ID: <51D6DD3A.1030002@ti.com>
Date: Fri, 5 Jul 2013 09:50:34 -0500
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
References: <1371849949-12649-1-git-send-email-nm@ti.com> <1371849949-12649-2-git-send-email-nm@ti.com> <20130704154105.GD27646@sirena.org.uk> <20130705135507.GA17439@kahuna> <20130705140828.GA27646@sirena.org.uk>
In-Reply-To: <20130705140828.GA27646@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 09:08 AM, Mark Brown wrote:
> On Fri, Jul 05, 2013 at 08:55:07AM -0500, Nishanth Menon wrote:
>
> Please write in paragraphs, an enormous wall of unbroken text isn't
> helpful for legibility.

Apologies on the same. Will try to do better.

>
>> On 16:41-20130704, Mark Brown wrote:
>
>>> So, this still has the thing where all the data about the PMIC is
>>> replicated (but now in this driver).  It should be possible to pull all
>>> the above information except possibly the I2C timeout and perhaps the
>>> I2C address (if there's a separate control interface) from the standard
>>> regulator core data structures for the PMIC.  This would allow the
>>> driver to Just Work with any PMIC without needing to add it in two
>>> places.
>
>> option 1) we just bypass get_voltage/set_voltage to point through to
>> this function. result will be something similar to what we got here[1]
>
> I don't really know what you mean when you say "bypass get_voltage/set_voltage
> so it's kind of hard to comment...  the link you posted appears to be a
> link to the code I'm reviewing so it's not terribly enlightening.

:) it is similar, yes. by bypass get/set_voltage, I mean something like [1]

>
>> Again, based on this discussion, it is wrong - and we already did implement
>> the *wrong* way in OMAP and the new code is supposed to throw away the
>> old code once all relevant platforms are converted to DT.
>> - now, we could improve this by passing rdev and slurp out required
>>   data from regulator structures, but obviously, as you pointed out, it wont
>>   be sufficient.
>> - In this solution, we will have existing regulator drivers supporting
>> additional data path. *but* that also means that existing regulator
>> drivers will need to be modified to handle multiple data path and "Just
>> Work" wont happen - so not really good other than screw up existing
>> regulator drivers with handling OMAP specific APIs in them.
>
> What makes you think that the existing regulator drivers need to be
> modified?


data path difference - Almost all standard regulators use i2c (standard 
i2c APIs) for every other SMPS/LDO except for the ones controlled by 
OMAP custom i2c path(vc/vp), the set_voltage/get_voltage needs a 
different implementation when it comes to using the vc/vp path.

 > They already have all the data exported to the core (or
 > should do)...

I see that twl-regulator does not indeed do it, but, assuming the 
regulators have all the data exported to the core, the data is hidden in 
struct regulator_desc which is private to the device and driver. lets go 
through these:

 > +static const struct omap_pmic_info omap_twl4030_vdd1 = {
 > +	.slave_addr = 0x12,
Not readily exposed, but we can solve that using reg=<0x12>; in dts - 
this might not be duplication as the register address will be unique for 
the bus.

 > +	.voltage_reg_addr = 0x00,
desc->vsel_reg maps fine

 > +	.cmd_reg_addr = 0x00,
command register is used for sending low power state commands - which is 
not the same as voltage register or vsel_reg as used in depicted in 
regulator_desc.	

 > +	.i2c_timeout_us = 200,
yep, does not match up.

 > +	.slew_rate_uV = 4000,
desc->ramp_delay maps fine

 > +	.step_size_uV = 12500,
desc->uV_step maps fine.

 > +	.min_uV = 600000,
desc->min_uV maps fine.

 > +	.max_uV = 1450000,
can be used with constraints, but most regulator drivers seem to store 
this internally.

 > +	.voltage_selector_offset = 0,
 > +	.voltage_selector_mask = 0x7F,
 > +	.voltage_selector_setbits = 0x0,
 > +	.voltage_selector_zero = false,
to an extent we can map these to vsel_mask, linear_min_sel etc. (again 
assuming the regulator driver has populated it - most that implement 
custom set_voltage, get_voltage do not do that.

Now, How do you suggest I pick up this data in omap_pmic regulator?
linux/regulator/consumer.h does not seem appropriate omap_pmic is not 
really a consumer of the regulator and further all the detailed data is 
not exposed either.

Other option is to make rdev available to omap_pmic regulator - which 
again implies change in existing regulator driver?


> the only thing that's missing is the timeouts and it's
> not at all obvious why those need to be tuned per device.

OMAP VC hardware has no idea about how long to wait before giving up on 
an ongoing i2c transaction. This may depend on PMIC and what it does 
before acking on i2c.

>
>> option 2) make omap_pmic regulator use twl_regulator - regulator
>> chaining.
>
> Again I don't know what this is.
Lets ignore this for the moment.


[1] 
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=63bfff4e20211b464cbea6e79e5fd36df227c154
-- 
Regards,
Nishanth Menon
