Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab3FTMps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:45:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39947 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757711Ab3FTMpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:45:45 -0400
Date: Thu, 20 Jun 2013 07:45:42 -0500
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <viresh.kumar@linaro.org>,
        <cpufreq@vger.kernel.org>
Subject: Re: [RFC PATCH] regulator: core: allow consumers to request to
 closes step voltage
Message-ID: <20130620124542.GA28320@kahuna>
References: <1371669474-24473-1-git-send-email-nm@ti.com>
 <20130619223828.GK1403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130619223828.GK1403@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23:38-20130619, Mark Brown wrote:
> On Wed, Jun 19, 2013 at 02:17:54PM -0500, Nishanth Menon wrote:
> 
> > Account for step size accuracy when exact voltage requests are send for
> > step based regulators.
> 
> If the consumer can tolerate a different voltage why not just request
> the range that can be tolerated?  Your problem here is specifying an
> exact voltage.
I think you mean using regulator_get_linear_step

> 
> > The specific example I faced was using cpufreq-cpu0 driver with voltages
> > for OPPs for MPU rail and attempting the common definitions against voltages
> > that are non-exact multiples of stepsize of PMIC.
> 
> > The alternative would be implement custom set_voltage (as againsta simpler
> > set_voltage_sel and using linear map/list functions) for the regulator which
> > will account for the same.
> 
> > Yet another alternative might be to introduce yet another custom function similar
> > to regulator_set_voltage_tol which accounts for this. something like:
> > regulator_set_voltage_floor(regulator, voltage, tol) or something to that effect.
> 
> Or as I keep telling you guys the consumer can just do that directly
> using the existing API; the whole point in specifying the voltage as a
> range is to allow the consumer to cope with arbatrary regulators by
> giving a range of voltages that it can accept.
> 
> The API is deliberately very conservative in these matters since there
> is a danger of physical damage if things really go wrong in some
> applications, it makes sure that both the drivers and the system
> integration are involved.
I agree. The intent of this series was to start a conversation to see if
we can make it simpler.

Searching for the users of regulator_get_linear_step in 3.10-rc6
shows none.

For a generic driver which needs to handle platforms which
have tolerance, they'd use regulator_set_voltage_tol. But the
implementation would allow for uV - tol to uV + tol as range, which in
the case I mentioned(min voltage =uV) wont work.

If the consumer wants to be aware of linear step regulator, they'd have to do:
step_uV = regulator_get_linear_step(...);
regulator_set_voltage(uV, uV + step_uV);

Then this wont handle tolerance. So the solution seems to be (for the
consumer):
step_uV = regulator_get_linear_step(...);
..
if (tol)
	regulator_set_voltage_tol(uV, tol);
else
	regulator_set_voltage(uV, uV + step_uV);
(with the required error checks for regulator being a linear regulator
 etc..).

At least to me, there is no sane manner to handle "tolerance" and linear step
accuracy for a defined voltage (Should tolerance be rounded off to
step_uV? what about the border cases etc.)

Would you agree?
-- 
Regards,
Nishanth Menon

PS: Since I just looped in cpufreq list, discussion thread:
http://marc.info/?t=137166954900005&r=1&w=2
