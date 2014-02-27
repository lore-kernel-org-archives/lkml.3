Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaB0On3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:43:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42981 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaB0On0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:43:26 -0500
Message-ID: <530F4EED.9050207@ti.com>
Date: Thu, 27 Feb 2014 08:42:53 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mark Brown <broonie@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [RFC PATCH 1/6] PM / Voltagedomain: Add generic clk notifier
 handler for regulator based dynamic voltage scaling
References: <1392755543-28335-1-git-send-email-nm@ti.com> <1392755543-28335-2-git-send-email-nm@ti.com> <20140225055142.22529.21814@quantum> <530D0394.4020208@ti.com> <20140227023455.GA15712@kahuna> <20140227050043.12081.54173@quantum>
In-Reply-To: <20140227050043.12081.54173@quantum>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 11:00 PM, Mike Turquette wrote:
> Quoting Nishanth Menon (2014-02-26 18:34:55)
>> +/**
>> + * pm_runtime_get_rate() - Returns the device operational frequency
>> + * @dev:       Device to handle
>> + * @rate:      Returns rate in Hz.
>> + *
>> + * Returns appropriate error value in case of error conditions, else
>> + * returns 0 and rate is updated. The pm_domain logic does all the necessary
>> + * operation (which may consider magic hardware stuff) to provide the rate.
>> + *
>> + * NOTE: the rate returned is a snapshot and in many cases just a bypass
>> + * to clk api to set the rate.
>> + */
>> +int pm_runtime_get_rate(struct device *dev, unsigned long *rate)
> 
> Instead of "rate", how about we use "level" and leave it undefined as to
> what that means? It would be equally valid for level to represent a
> clock rate, or an opp from a table of opp's, or a p-state, or some value
> passed to a PM microcontroller.

IMHO, from a driver which already exists for multiple SoCs/
architectures, we cannot have variant definitions that a generic
driver will be unable to depend upon. what should such a driver
expect? level == rate OR level == index to p-state or magic PM
controller value?

Today the definitions are very clear to such a driver, pm_runtime APIs
are used for device specific idle management, but for active
management, use clk and regulator code as needed - ofcourse, that
machine specificity triggers the need for the 50 odd cpufreq drivers
we have today - intent was to be able to abstract it enough for a
generic logic to exist.

> 
> Code that is tightly coupled to the hardware would simply know what
> value to use with no extra sugar.

agreed on the machine specific implementation, but the logic at driver
level will then get tied down to machine specific implementation as well

> 
> Generic code would need to get the various supported "levels" populated
> at run time, but a DT binding could do that, or a query to the ACPI
> tables, or whatever.

then we'd also have to introduce a translator API for drivers that
need frequency -> we go back to the old world of having specific
functions depending on usage in the frequency world, ACPI world, PM
controller world.

That completely breaks the concept of having a higher level function,
right?

> 
>> +{
>> +       unsigned long flags;
>> +       int error = -ENOSYS;
>> +
>> +       if (!rate || !dev)
>> +               return -EINVAL;
>> +
>> +       spin_lock_irqsave(&dev->power.lock, flags);
>> +       if (!pm_runtime_active(dev)) {
>> +               error = -EINVAL;
>> +               goto out;
>> +       }
>> +
>> +       if (dev->pm_domain && dev->pm_domain->active_ops.get_rate)
>> +               error = dev->pm_domain->active_ops.get_rate(dev, rate);
>> +out:
>> +       spin_unlock_irqrestore(&dev->power.lock, flags);
>> +
>> +       return error;
>> +}
>> +
>> +/**
>> + * pm_runtime_set_rate() - Set a specific rate for the device operation
>> + * @dev:       Device to handle
>> + * @rate:      Rate to set in Hz
>> + *
>> + * Returns appropriate error value in case of error conditions, else
>> + * returns 0. The pm_domain logic does all the necessary operation (which
>> + * may include voltage scale operations or other magic hardware stuff) to
>> + * achieve the operation. It is guarenteed that the requested rate is achieved
>> + * on returning from this function if return value is 0.
>> + */
>> +int pm_runtime_set_rate(struct device *dev, unsigned long rate)
> 
> Additionally I wonder if the function signature should include a way to
> specify the sub-unit of a device that we are operating on? This is a way
> to tackle the issues you raised regarding multiple clocks per device,
> etc. Two approaches come to mind:
> 
> int pm_runtime_set_rate(struct device *dev, int index,
> 				unsigned long rate);
> 
> Where index is a sub-unit of struct device *dev.

Here the problem is trying to define what that index is. should it be
clk index? how again would a generic driver be able to consistently
function? lets, for a moment replace that with a string - "clk_name"
to uniquely identify the clk -> but then, it still, in concept makes
it no better than a clk_set_rate since we are uniquely identifying the
clk to operate upon -> and we can definitely add "magic dvfs" stuff on
existing clock framework without a need for additional wrappers (which
what the original $subject series does).


>The second approach is
> to create a publicly declared structure representing the sub-unit. Some
> variations on that theme:
> 
> int pm_runtime_set_rate(struct perf_domain *perfdm, unsigned long rate);
> 
> or,
> 
> int pm_runtime_set_rate(struct generic_power_domain *gpd,
> 				unsigned long rate);
> 
> or whatever that sub-unit looks like. The gpd thing might be a total
> layering violation, I don't know. Or perhaps it's a decent idea but it
> shouldn't be as a PM runtime call. Again, I dunno.

Again, we goes back to the same question, right? which clock in a
power_domain/perf_domain are we intending with the rate? a device
belongs to a perf domain -> Taking drivers/cpufreq/imx6q-cpufreq.c as
an example.
Clocks needed: arm_clk, pll1_sys_clk, pll1_sw_clk, step_clk,
pll2_pfd2_396m_clk.
regulators needed: arm_reg, pu_reg, soc_reg.

The device we want to set a frequency is the ARM processor. by
describing "perf_domain" or "generic power domain" as a single clock
entity, we might as well use clk_set_rate instead to be specific,
instead of writing one wrapper on top of the entire thing.


I apologize, more I think in this angle, less I think such a generic
api seems feasible.

-- 
Regards,
Nishanth Menon
