Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965252Ab3DTAYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 20:24:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54101 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965100Ab3DTAYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 20:24:18 -0400
From: "Kondratiuk, Taras" <taras@ti.com>
To: "Menon, Nishanth" <nm@ti.com>, "Mohammed, Afzal" <afzal@ti.com>
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
Thread-Index: AQHOPPWnMzYHUcFPIkS0l8RDJnNbipjdmI6AgAClz9M=
Date: Sat, 20 Apr 2013 00:24:10 +0000
Message-ID: <F2EE74CEB87D4A44AC98442FCBF00207018E2E21@DNCE04.ent.ti.com>
References: <1366372554-20866-1-git-send-email-taras@ti.com>,<20130419162153.GA24066@kahuna>
In-Reply-To: <20130419162153.GA24066@kahuna>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.49]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 07:21 PM, Nishanth Menon wrote:
> On 14:55-20130419, Taras Kondratiuk wrote:
>> Using a "voltage tolerance" for doing DVFS is not a proper way.
>> It leads to a few issues:
>> - voltage is limited to a narrow range near OPP voltage,
>>   so other consumers of the same regulator can't set their own constraints
>>   if they don't overlap with this narrow range. No ganged rails :(
>> - usually OPP voltage is an absolute minimum voltage
>>   necessary for correct work (not taking into account AVS).
>>   Applying plus/minus tolerance can lead to an unstable device.
>>   For example omap-cpufreq has 4% tolerance configured,
>>   so for OMAP4430 MPU OPP50 we get 0.984V instead of 1.025V. 
> there is a reason for this - board level IRDROP and the real PMIC
> accuracy compared to the SoC assumption about the PMIC accuracy.

I don't see how current implementation of voltage-tolerance can help with this.

>
> That said, I had been always been a little confused with the usage
> in AM335x. For that matter, I dont even think this is constrainted to
> TI SoC usage, other SoCs also probably have the same pain.
>
> How does it actually work?

I think this is a question to Afzal as he is an original author
of commit 42daffd2d6c665716d442d518022ecaad17ddf64 which later
migrated to cpufreq-cpu0 driver.

I can only guess...
Without tolerance cpufreq requests the same value for min_uV and max_uV.
So regulator have to set an exact voltage value on the rail,
which is not always possible if different PMICs can be used for the SoC.
For example in v3.9-rc7 voltage-tolerance is used *only*
in AM33xx which can use two PMICs: TPS65217 and TPS65910.
These PMICs have different voltage steps so they can't set the same voltage.
I think this was the reason for adding voltage-tolerance.

*But* there is a trick.
If you compare MPU OPP voltages in AM335x datasheet and am33xx.dtsi
you will see that am33xx.dtsi has already applied tolerance (2%) on top
of nominal voltages.
So final range passed to regulator is [Vnom; Vnom+2*tol]
instead of [Vnom-tol; Vnom+tol].
That's why it works for AM335x, but IMHO it is a hack.
That patch broke omap-cpufreq functionality, since mach-omap2/oppxxxx_data.c
files doesn't have tolerance added on top of nominal voltages.

regulator_set_voltage_min() should solve AM335x issue
without introducing voltage-tolerance hack.
Probably I need to add one more patch to the series which will remove
voltage-tolerance from am335x.dtsi and set CPU voltages back to nominal.

>
> Lets say ntarget/Vnom has PMIC tolerance of 5% (SoC tolerance assumed
> for OPP voltage documented in data manual for the SoC), say the
> OPP voltage is 1.2V - that translates to an voltage of 1.14V on a perfect
> PMIC (with 0 drop or perfect accuracy) for the SoC.

Even if you have a perfect PMIC it worth to set 1.2V.

For example OMAP4 DM states clearly about what nominal voltage is:
"Nominal voltage value documented in this table corresponds
to the voltage to be applied at power IC (PMIC) level.
Whereas minimum and maximum voltage values correspond
to the possible voltage at OMAP ball level."

> Now, the real world is never perfect. So, lets take the following cases:
> a) PMIC with 2% variance
> b) PMIC with 5% variance (usually the reference PMIC we put on SoC
>    vendor platform)

In two cases above PMIC tolerance fits into SoC tolerance, so no issue.
Just set nominal voltage to PMIC and that's all.

> c) PMIC with 10% variance.

This is "out of specification" use-case.
It should be possible to add a knowledge about tolerance into regulator
framework and then add a new constraint type "guarantee-minimum",
but I don't think we need some generic solution for this specific case.
You can override OPPs from board dts and add some margin
on top of nominal voltages if bad PMIC is used.

>
> How does this translate to dts definition? As you stated, with 5%
> variance(b), the call will become min_uV=1.14V max_uV=1.26V when
> the tolerance translation is done. with (a) and (c) tolernace value
> chooses a different value.
>
> In short,
> a) we need to be able to describe in some form the assumption for
> board variances in the OPP voltage in the SoC data manual.
> b) we need some way for board/PMIC definitions to be able to influence
> and adjust for assumption.

Why do we need this?
Most board designs has a proper PMIC that matches SoC tolerance requirements.
Is there any example where PMIC tolerance is less than required by SoC?

>
> This is what I believe is achieved using voltage_tolerance.
>
>
> regulator_set_voltage_min is not really the way to do it IMHO.

What issues do you see with regulator_set_voltage_min() approach?

PS: I have to sent this email from Outlook web interface :(
Sorry if it is not formatted correctly.

-- 
BR
Taras Kondratiuk | GlobalLogic