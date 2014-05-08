Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbaEHUwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:52:30 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40904 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbaEHUw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:52:28 -0400
Message-ID: <536BEE89.3040602@gmail.com>
Date: Thu, 08 May 2014 13:52:25 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stratos Karafotis <stratosk@semaphore.gr>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: dirk.brandewie@gmail.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Smythies <dsmythies@telus.net>
Subject: Re: [RFC PATCH] cpufreq: intel_pstate: Change the calculation of
 next pstate
References: <5368255D.3090207@semaphore.gr>
In-Reply-To: <5368255D.3090207@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 04:57 PM, Stratos Karafotis wrote:
> Currently the driver calculates the next pstate proportional to
> core_busy factor, scaled by the ratio max_pstate / current_pstate.
> 
> Using the scaled load (core_busy) to calculate the next pstate
> is not always correct, because there are cases that the load is
> independent from current pstate. For example, a tight 'for' loop
> through many sampling intervals will cause a load of 100% in
> every pstate.
> 
> So, change the above method and calculate the next pstate with
> the assumption that the next pstate should not depend on the
> current pstate. The next pstate should only be proportional
> to measured load. Use the linear function to calculate the load:
> 
> Next P-state = A + B * load
> 
> where A = min_state and B = (max_pstate - min_pstate) / 100
> If turbo is enabled the B = (turbo_pstate - min_pstate) / 100
> The load is calculated using the kernel time functions.
> 

This will hurt your power numbers under "normal" conditions where you
are not running a performance workload. Consider the following:

   1. The system is idle, all core at min P state and utilization is low say < 10%
   2. You run something that drives the load as seen by the kernel to 100%
      which scaled by the current P state.

This would cause the P state to go from min -> max in one step.  Which is
what you want if you are only looking at a single core.  But this will also
drag every core in the package to the max P state as well.  This would be fine
if the power vs frequency cure was linear all the cores would finish
their work faster and go idle sooner (race to halt) and maybe spend
more time in a deeper C state which dwarfs the amount of power we can
save by controlling P states. Unfortunately this is *not* the case, 
power vs frequency curve is non-linear and get very steep in the turbo
range.  If it were linear there would be no reason to have P state
control you could select the highest P state and walk away.

Being conservative on the way up and aggressive on way down give you
the best power efficiency on non-benchmark loads.  Most benchmarks
are pretty useless for measuring power efficiency (unless they were
designed for it) since they are measuring how fast something can be
done which is measuring the efficiency at max performance.

The performance issues you pointed out were caused by commit 
fcb6a15c intel_pstate: Take core C0 time into account for core busy calculation
and the ensuing problem is caused. These have been fixed in the patch set

   https://lkml.org/lkml/2014/5/8/574

The performance comparison between before/after this patch set, your patch
and ondemand/acpi_cpufreq is available at:
    http://openbenchmarking.org/result/1405085-PL-C0200965993
ffmpeg was added to the set of benchmarks because there was a regression
reported against this benchmark as well.
    https://bugzilla.kernel.org/show_bug.cgi?id=75121

--Dirk



 
   
