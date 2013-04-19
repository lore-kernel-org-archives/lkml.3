Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030811Ab3DSQWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:22:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34295 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221Ab3DSQV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:21:58 -0400
Date: Fri, 19 Apr 2013 11:21:53 -0500
From: Nishanth Menon <nm@ti.com>
To: Taras Kondratiuk <taras@ti.com>
CC: <lgirdwood@gmail.com>, <broonie@kernel.org>, <rjw@sisk.pl>,
        <viresh.kumar@linaro.org>, <shawn.guo@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] cpufreq/regulator: Limit minimum voltage only
Message-ID: <20130419162153.GA24066@kahuna>
References: <1366372554-20866-1-git-send-email-taras@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1366372554-20866-1-git-send-email-taras@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:55-20130419, Taras Kondratiuk wrote:
> Using a "voltage tolerance" for doing DVFS is not a proper way.
> It leads to a few issues:
> - voltage is limited to a narrow range near OPP voltage,
>   so other consumers of the same regulator can't set their own constraints
>   if they don't overlap with this narrow range. No ganged rails :(
> - usually OPP voltage is an absolute minimum voltage
>   necessary for correct work (not taking into account AVS).
>   Applying plus/minus tolerance can lead to an unstable device.
>   For example omap-cpufreq has 4% tolerance configured,
>   so for OMAP4430 MPU OPP50 we get 0.984V instead of 1.025V. 
there is a reason for this - board level IRDROP and the real PMIC
accuracy compared to the SoC assumption about the PMIC accuracy.

That said, I had been always been a little confused with the usage
in AM335x. For that matter, I dont even think this is constrainted to
TI SoC usage, other SoCs also probably have the same pain.

How does it actually work?

Lets say ntarget/Vnom has PMIC tolerance of 5% (SoC tolerance assumed
for OPP voltage documented in data manual for the SoC), say the
OPP voltage is 1.2V - that translates to an voltage of 1.14V on a perfect
PMIC (with 0 drop or perfect accuracy) for the SoC.
Now, the real world is never perfect. So, lets take the following cases:
a) PMIC with 2% variance
b) PMIC with 5% variance (usually the reference PMIC we put on SoC
   vendor platform)
c) PMIC with 10% variance.

How does this translate to dts definition? As you stated, with 5%
variance(b), the call will become min_uV=1.14V max_uV=1.26V when
the tolerance translation is done. with (a) and (c) tolernace value
chooses a different value.

In short,
a) we need to be able to describe in some form the assumption for
board variances in the OPP voltage in the SoC data manual.
b) we need some way for board/PMIC definitions to be able to influence
and adjust for assumption.

This is what I believe is achieved using voltage_tolerance.

regulator_set_voltage_min is not really the way to do it IMHO.

-- 
Regards,
Nishanth Menon
