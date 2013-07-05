Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab3GENzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:55:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36533 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3GENzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:55:37 -0400
Date: Fri, 5 Jul 2013 08:55:07 -0500
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Taras Kondratiuk <taras@ti.com>
Subject: Re: [RFC PATCH V2 1/8] regulator: Introduce OMAP regulator to
 control PMIC over VC/VP
Message-ID: <20130705135507.GA17439@kahuna>
References: <1371849949-12649-1-git-send-email-nm@ti.com>
 <1371849949-12649-2-git-send-email-nm@ti.com>
 <20130704154105.GD27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130704154105.GD27646@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:41-20130704, Mark Brown wrote:
> On Fri, Jun 21, 2013 at 04:25:42PM -0500, Nishanth Menon wrote:
> 
> > +static const struct omap_pmic_info omap_twl4030_vdd1 = {
> > +	.slave_addr = 0x12,
> > +	.voltage_reg_addr = 0x00,
> > +	.cmd_reg_addr = 0x00,
> > +	.i2c_timeout_us = 200,
> > +	.slew_rate_uV = 4000,
> > +	.step_size_uV = 12500,
> > +	.min_uV = 600000,
> > +	.max_uV = 1450000,
> > +	.voltage_selector_offset = 0,
> > +	.voltage_selector_mask = 0x7F,
> > +	.voltage_selector_setbits = 0x0,
> > +	.voltage_selector_zero = false,
> > +};
> 
> So, this still has the thing where all the data about the PMIC is
> replicated (but now in this driver).  It should be possible to pull all
> the above information except possibly the I2C timeout and perhaps the
> I2C address (if there's a separate control interface) from the standard
> regulator core data structures for the PMIC.  This would allow the
> driver to Just Work with any PMIC without needing to add it in two
> places.
> 
> Other than that this looks good, the only issue I see is where the
> driver is getting the data from.
I like the idea and had tried to implement it as well..lets get down to
the details: If I understand what you are stating,
regulators such as twl-regulator has the same/similar data that is
represented here. twl-regulator uses standard i2c path, it cannot
send voltage over so called "SR path". Alrite, so, lets say we reuse
definition of VDD1,
option 1) we just bypass get_voltage/set_voltage to point through to
this function. result will be something similar to what we got here[1]
Again, based on this discussion, it is wrong - and we already did implement
the *wrong* way in OMAP and the new code is supposed to throw away the
old code once all relevant platforms are converted to DT.
- now, we could improve this by passing rdev and slurp out required
 data from regulator structures, but obviously, as you pointed out, it wont
 be sufficient.
- In this solution, we will have existing regulator drivers supporting
additional data path. *but* that also means that existing regulator
drivers will need to be modified to handle multiple data path and "Just
Work" wont happen - so not really good other than screw up existing
regulator drivers with handling OMAP specific APIs in them.

option 2) make omap_pmic regulator use twl_regulator - regulator
chaining.
 - we already agreed that this is conceptually wrong[2](regulator
   talking to another regulator). So wont debate more here.
 - but here, you'd have omap_pmic regulator "using twl/existing
 regulators" to pick up data about slew, conversion information etc..

This series attempts to keep omap pmic delta simplified to just the
additional PMIC data, no replication of code or "OMAP specific
infection" of existing generic regulators.

Is there any other suggestions how to pick up the data from an existing
regulator and avoid few bytes of data replication?

[1]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/arm/mach-omap2/omap_twl.c#n142
[2] http://marc.info/?t=136513865200005&r=1&w=2
-- 
Regards,
Nishanth Menon
