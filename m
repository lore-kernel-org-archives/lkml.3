Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbbA2SAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 13:00:05 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63655 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbbA2SAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 13:00:00 -0500
Date: Wed, 28 Jan 2015 20:15:07 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: Javi Merino <javi.merino@arm.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, broonie@kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v6 6/9] thermal: cpu_cooling: implement the power
 cooling device API
Message-ID: <20150129001506.GA28216@developer>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
 <1417806260-9264-7-git-send-email-javi.merino@arm.com>
 <20150128052330.GD29600@developer.hsd1.ca.comcast.net>
 <9hhh9v9ltqe.fsf@e105922-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9hhh9v9ltqe.fsf@e105922-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

:x
> Hi Eduardo,
> 
> Eduardo Valentin <edubezval@gmail.com> writes:
> 
> > Hello Javi,
> >
> > On Fri, Dec 05, 2014 at 07:04:17PM +0000, Javi Merino wrote:
> >> Add a basic power model to the cpu cooling device to implement the
> >> power cooling device API.  The power model uses the current frequency,
> >> current load and OPPs for the power calculations.  The cpus must have
> >> registered their OPPs using the OPP library.
> >> 
> >> Cc: Zhang Rui <rui.zhang@intel.com>
> >> Cc: Eduardo Valentin <edubezval@gmail.com>
> >> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> >> Signed-off-by: Javi Merino <javi.merino@arm.com>
> >
> > <big cut>
> >
> >> +
> >> +/**
> >> + * get_load() - get load for a cpu since last updated
> >> + * @cpufreq_device:	&struct cpufreq_cooling_device for this cpu
> >> + * @cpu:	cpu number
> >> + *
> >> + * Return: The average load of cpu @cpu in percentage since this
> >> + * function was last called.
> >> + */
> >> +static u32 get_load(struct cpufreq_cooling_device *cpufreq_device, int cpu)
> >> +{
> >> +	u32 load;
> >> +	u64 now, now_idle, delta_time, delta_idle;
> >> +
> >> +	now_idle = get_cpu_idle_time(cpu, &now, 0);
> >> +	delta_idle = now_idle - cpufreq_device->time_in_idle[cpu];
> >> +	delta_time = now - cpufreq_device->time_in_idle_timestamp[cpu];
> >> +
> >> +	if (delta_time <= delta_idle)
> >> +		load = 0;
> >> +	else
> >> +		load = div64_u64(100 * (delta_time - delta_idle), delta_time);
> >> +
> >> +	cpufreq_device->time_in_idle[cpu] = now_idle;
> >> +	cpufreq_device->time_in_idle_timestamp[cpu] = now;
> >> +
> >> +	return load;
> >> +}
> >
> > <cut>
> >
> >>  
> >> +/**
> >> + * cpufreq_get_actual_power() - get the current power
> >> + * @cdev:	&thermal_cooling_device pointer
> >> + *
> >> + * Return the current power consumption of the cpus in milliwatts.
> >> + */
> >> +static u32 cpufreq_get_actual_power(struct thermal_cooling_device *cdev)
> >> +{
> >> +	unsigned long freq;
> >> +	int cpu;
> >> +	u32 static_power, dynamic_power, total_load = 0;
> >> +	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
> >> +
> >> +	freq = cpufreq_quick_get(cpumask_any(&cpufreq_device->allowed_cpus));
> >> +
> >> +	for_each_cpu(cpu, &cpufreq_device->allowed_cpus) {
> >> +		u32 load;
> >> +
> >> +		if (cpu_online(cpu))
> >> +			load = get_load(cpufreq_device, cpu);
> >> +		else
> >> +			load = 0;
> >> +
> >> +		total_load += load;
> >> +	}
> >> +
> >> +	cpufreq_device->last_load = total_load;
> >> +
> >> +	static_power = get_static_power(cpufreq_device, freq);
> >> +	dynamic_power = get_dynamic_power(cpufreq_device, freq);
> >> +
> >> +	return static_power + dynamic_power;
> >> +}
> >
> > With respect to load computation vs. frequency usage vs. power
> > estimation, while getting actual power for a given interval T. What if
> > in interval T, we have used, say, 3 different cpu frequencies, and the
> > load on the first was 50%, on the second 80%, and on the last frequency,
> > the load was 60%, what should be the right load value for computing the
> > actual power? 
> >
> > I mean, we are using the total idle time for a given interval, but 1 -
> > idle not always seams to reflect actual load on different opps, if opps
> > change over time within T time interval window.
> 
> The value returned by cpufreq_get_actual_power is used as a proxy for
> the estimate of the requested power of the actor for the next window
> duration. Even though the frequency might have changed in the previous
> period, the current frequency reflects the latest information about the
> required performance. As it is an estimate, and to avoid making the
> power calculations more complicated, we used utilisation (1 - idle time)
> to calculate the request. The estimate for the T+1 period becomes more
> accurate as the load stabilises.
> 
> In our testing on different workloads using 100ms as the polling period
> for thermal control, we didn't see any problems arising from the use of
> this definition of utilisation.
> 
> Having said that, there are a number of ways to improve the accuracy of
> the power calculations. As part of investigating the effects of
> improving model accuracy and it's effect on thermal control and
> performance, we plan to look at fine-grained frequency and load tracking
> once the initial set of patches are merged.

In this case, I believe we must mark the code at least with a TODO or
REVISIT mark. Can we add the above comments within a REVISIT: mark in
this part of the code?

> 
> Cheers,
> Punit
> 
> >
> > BR,
> >
> >
> > BR,
> >
> > Eduardo Valentin
