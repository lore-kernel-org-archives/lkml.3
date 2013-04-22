Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3DVGLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 02:11:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42689 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554Ab3DVGL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 02:11:28 -0400
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: "Kondratiuk, Taras" <taras@ti.com>, "Menon, Nishanth" <nm@ti.com>,
        "Mohammed, Afzal" <afzal@ti.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "Tseglytskyi, Andrii" <andrii.tseglytskyi@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "AnilKumar, Chimata" <anilkumar@ti.com>
Subject: RE: [RFC PATCH 0/2] cpufreq/regulator: Limit minimum voltage only
Thread-Topic: [RFC PATCH 0/2] cpufreq/regulator: Limit minimum voltage only
Thread-Index: AQHOPPWnjGbzBZ5kaESap05wkTLpFZjdmI6AgAClz9OAAe7PQA==
Date: Mon, 22 Apr 2013 06:11:12 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EDB23C1@DBDE01.ent.ti.com>
References: <1366372554-20866-1-git-send-email-taras@ti.com>,<20130419162153.GA24066@kahuna>
 <F2EE74CEB87D4A44AC98442FCBF00207018E2E21@DNCE04.ent.ti.com>
In-Reply-To: <F2EE74CEB87D4A44AC98442FCBF00207018E2E21@DNCE04.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.145.159]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(removing Anil's email-id since it's no longer valid)

On Sat, Apr 20, 2013 at 05:54:10, Kondratiuk, Taras wrote:
> On 04/19/2013 07:21 PM, Nishanth Menon wrote:
> > On 14:55-20130419, Taras Kondratiuk wrote:
> >> Using a "voltage tolerance" for doing DVFS is not a proper way.
> >> It leads to a few issues:
> >> - voltage is limited to a narrow range near OPP voltage,
> >>   so other consumers of the same regulator can't set their own constraints
> >>   if they don't overlap with this narrow range. No ganged rails :(
> >> - usually OPP voltage is an absolute minimum voltage
> >>   necessary for correct work (not taking into account AVS).

The absolute minimum voltage part is not applicable for all SoCs.
In case of AM335x there a nominal voltage that is specified in the
OPP table and there's a plus/minus tolerance at the IO level within
which things are guaranteed to work. To lower the power consumption
we would want to go as low as possible without violating the
requirement at the SoC boundary level. I don't know how the OPP voltages
are speced for non TI devices but if there's a permissible range I guess
everyone would like to set the voltage near the lower end of the spectrum.

> >>   Applying plus/minus tolerance can lead to an unstable device.
> >>   For example omap-cpufreq has 4% tolerance configured,
> >>   so for OMAP4430 MPU OPP50 we get 0.984V instead of 1.025V. 

So if you set the tolerance to 0% instead of removing it completely
won't the problem go away?

> > there is a reason for this - board level IRDROP and the real PMIC
> > accuracy compared to the SoC assumption about the PMIC accuracy.
> 
> I don't see how current implementation of voltage-tolerance can help with this.
> 

It does help (more below).

> >
> > That said, I had been always been a little confused with the usage
> > in AM335x. For that matter, I dont even think this is constrainted to
> > TI SoC usage, other SoCs also probably have the same pain.
> >
> > How does it actually work?
> 
> I think this is a question to Afzal as he is an original author
> of commit 42daffd2d6c665716d442d518022ecaad17ddf64 which later
> migrated to cpufreq-cpu0 driver.
> 
> I can only guess...
> Without tolerance cpufreq requests the same value for min_uV and max_uV.
> So regulator have to set an exact voltage value on the rail,
> which is not always possible if different PMICs can be used for the SoC.
> For example in v3.9-rc7 voltage-tolerance is used *only*
> in AM33xx which can use two PMICs: TPS65217 and TPS65910.
> These PMICs have different voltage steps so they can't set the same voltage.
> I think this was the reason for adding voltage-tolerance.
> 

The PMICs have the same step size of 12.5mV but unfortunately they don't have
a register setting to meet the nominal voltage requirement for all the OPPs.
As per the SoC datasheet, for OPP120 the nominal voltage is 1.26V but the closest
that the PMIC outputs can come is either 1.25V or 1.275V. Now i think there's
been some confusion in the implementation phase due to things like board level
IR drops and variations mentioned in the PMIC datasheets which has resulted in
the tolerance being used both in am33xx.dtsi and then again in the cpufreq driver.

Ignoring the PMIC variations and board level IR drops for moment, the way I think
it should have been done is - OPP entries have the nominal voltages and we specify
the tolerance either in % in the DT file. The cpufreq driver looks up the nominal
voltage from the OPP table and then requests the regulator framework to factor in
the tolerance and then select the lowest permissible voltage. 

> *But* there is a trick.
> If you compare MPU OPP voltages in AM335x datasheet and am33xx.dtsi
> you will see that am33xx.dtsi has already applied tolerance (2%) on top
> of nominal voltages.
> So final range passed to regulator is [Vnom; Vnom+2*tol]
> instead of [Vnom-tol; Vnom+tol].
> That's why it works for AM335x, but IMHO it is a hack.

I agree. It sort of ended up a hack that needs to be fixed by removing the
additional tolerance in am33xx.dtsi.

> That patch broke omap-cpufreq functionality, since mach-omap2/oppxxxx_data.c
> files doesn't have tolerance added on top of nominal voltages.
> 

Again, if you specify 0% as the tolerance this would be fine, no?

> regulator_set_voltage_min() should solve AM335x issue
> without introducing voltage-tolerance hack.

No, we want to pass on all the factors to be considered to the appropriate
framework which in this case is the regulator framework and let it decide
the min voltage. If you consider multiple users like ABB and AVS, I think
it makes much more sense to have the requirements from the different users
being passed on to the regulator framework and letting it decide what works
for all of them.

> Probably I need to add one more patch to the series which will remove
> voltage-tolerance from am335x.dtsi and set CPU voltages back to nominal.
> 
> >
> > Lets say ntarget/Vnom has PMIC tolerance of 5% (SoC tolerance assumed
> > for OPP voltage documented in data manual for the SoC), say the
> > OPP voltage is 1.2V - that translates to an voltage of 1.14V on a perfect
> > PMIC (with 0 drop or perfect accuracy) for the SoC.
> 
> Even if you have a perfect PMIC it worth to set 1.2V.
> 
> For example OMAP4 DM states clearly about what nominal voltage is:
> "Nominal voltage value documented in this table corresponds
> to the voltage to be applied at power IC (PMIC) level.
> Whereas minimum and maximum voltage values correspond
> to the possible voltage at OMAP ball level."
> 

So if you have another PMIC (not the one used on reference boards) which can
give two possible outputs for a particular OPP - nominal voltage (VDD1) and
another one (VDD2) where Vmin < VDD2 < VDD1, you would still prefer to go with
VDD1? Since the OMAP4 DM puts this as a requirement I guess there's not much
that can be done here but there are SoCs which are can be paired with multiple
PMICs and not everyone will be a perfect match. For OMAP I think you can just
set the tolerance to 0% and get the perfect match that you want.

> > Now, the real world is never perfect. So, lets take the following cases:
> > a) PMIC with 2% variance
> > b) PMIC with 5% variance (usually the reference PMIC we put on SoC
> >    vendor platform)
> 
> In two cases above PMIC tolerance fits into SoC tolerance, so no issue.
> Just set nominal voltage to PMIC and that's all.

I would say just ask the regulator framework to select a voltage within the
tolerance window around the nominal voltage. We need to at some level take
into consideration the PMIC tolerance also. Ideally the PMIC tolerance will
lie within the SoC tolerance so the search window for the voltage to set in
the PMIC just reduces a bit.

> 
> > c) PMIC with 10% variance.
> 
> This is "out of specification" use-case.
> It should be possible to add a knowledge about tolerance into regulator
> framework and then add a new constraint type "guarantee-minimum",
> but I don't think we need some generic solution for this specific case.
> You can override OPPs from board dts and add some margin
> on top of nominal voltages if bad PMIC is used.

IMHO we should not blindly override the OPPs in the board files. We should
just refine the permissible range of the valid OPPs either as a % of Vnom or
as a fixed value that the board designer is comfortable with. 

But i guess this would in some way or other end up setting a lower bound only -
so regulator_set_voltage_min() just be the right API to go after.

> 
> >
> > How does this translate to dts definition? As you stated, with 5%
> > variance(b), the call will become min_uV=1.14V max_uV=1.26V when
> > the tolerance translation is done. with (a) and (c) tolernace value
> > chooses a different value.
> >
> > In short,
> > a) we need to be able to describe in some form the assumption for
> > board variances in the OPP voltage in the SoC data manual.
> > b) we need some way for board/PMIC definitions to be able to influence
> > and adjust for assumption.

Yes, I agree on the need to factor in the board IR drop and the PMIC variations
in a generic manner. I am guessing the reason for adding in the tolerance in
the am33xx.dtsi was to work around the board level IR drop. We had some boards
showing larger than expected IR drop and this was resulting in the voltage at
the SoC boundary level falling out of the speced range if the regulator framwework
set the PMIC output near the lower end of the permissible range (not sure if
PMIC variations was also in the developer's mind).

Regards,
Vaibhav B.
