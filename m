Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaFCFQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:16:16 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51039 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaFCFQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:16:14 -0400
Date: Tue, 3 Jun 2014 10:46:06 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: ego@linux.vnet.ibm.com, rjw@rjwysocki.net, viresh.kumar@linaro.org,
        svaidy@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: governor: Be friendly towards latency-sensitive
 bursty workloads
Message-ID: <20140603051605.GA30422@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com>
 <20140602073306.GA5220@in.ibm.com>
 <538C32AA.5020401@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538C32AA.5020401@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060305-0320-0000-0000-000003715585
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 01:45:38PM +0530, Srivatsa S. Bhat wrote:
> On 06/02/2014 01:03 PM, Gautham R Shenoy wrote:
> > Hi,
> > 
> > On Tue, May 27, 2014 at 02:23:38AM +0530, Srivatsa S. Bhat wrote:
> > 
> > [..snip..]
> >>
> >> Experimental results:
> >> ====================
> >>
> >> I ran a modified version of ebizzy (called 'sleeping-ebizzy') that sleeps in
> >> between its execution such that its total utilization can be a user-defined
> >> value, say 10% or 20% (higher the utilization specified, lesser the amount of
> >> sleeps injected). This ebizzy was run with a single-thread, tied to CPU 8.
> >>
> >> Behavior observed with tracing (sample taken from 40% utilization runs):
> >> ------------------------------------------------------------------------
> >>
> >> Without patch:
> >> ~~~~~~~~~~~~~~
> >> kworker/8:2-12137  416.335742: cpu_frequency: state=2061000 cpu_id=8
> >> kworker/8:2-12137  416.335744: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
> >>       <...>-40753  416.345741: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> >> kworker/8:2-12137  416.345744: cpu_frequency: state=4123000 cpu_id=8
> >> kworker/8:2-12137  416.345746: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
> >>       <...>-40753  416.355738: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> >> <snip>  ---------------------------------------------------------------------  <snip>
> >>       <...>-40753  416.402202: sched_switch: prev_comm=ebizzy ==> next_comm=swapper/8
> >>      <idle>-0      416.502130: sched_switch: prev_comm=swapper/8 ==> next_comm=ebizzy
> >>       <...>-40753  416.505738: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> >> kworker/8:2-12137  416.505739: cpu_frequency: state=2061000 cpu_id=8
> >> kworker/8:2-12137  416.505741: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
> >>       <...>-40753  416.515739: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> >> kworker/8:2-12137  416.515742: cpu_frequency: state=4123000 cpu_id=8
> >> kworker/8:2-12137  416.515744: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
> >>
> >> Observation: Ebizzy went idle at 416.402202, and started running again at
> >> 416.502130. But cpufreq noticed the long idle period, and dropped the frequency
> >> at 416.505739, only to increase it back again at 416.515742, realizing that the
> >> workload is in-fact CPU bound. Thus ebizzy needlessly ran at the lowest frequency
> >> for almost 13 milliseconds (almost 1 full sample period), and this pattern
> >> repeats on every sleep-wakeup. This could hurt latency-sensitive workloads quite
> >> a lot.
> >>
> >> With patch:
> >> ~~~~~~~~~~~
> >>
> >> kworker/8:2-29802  464.832535: cpu_frequency: state=2061000 cpu_id=8
> >> <snip>  ---------------------------------------------------------------------  <snip>
> >> kworker/8:2-29802  464.962538: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
> >>       <...>-40738  464.972533: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> >> kworker/8:2-29802  464.972536: cpu_frequency: state=4123000 cpu_id=8
> >> kworker/8:2-29802  464.972538: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
> >>       <...>-40738  464.982531: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> >> <snip>  ---------------------------------------------------------------------  <snip>
> >> kworker/8:2-29802  465.022533: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
> >>       <...>-40738  465.032531: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> >> kworker/8:2-29802  465.032532: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
> >>       <...>-40738  465.035797: sched_switch: prev_comm=ebizzy ==> next_comm=swapper/8
> >>      <idle>-0      465.240178: sched_switch: prev_comm=swapper/8 ==> next_comm=ebizzy
> >>       <...>-40738  465.242533: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> >> kworker/8:2-29802  465.242535: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
> >>       <...>-40738  465.252531: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
> >>
> > 
> > Have the log entries emmitted by kworker/8 to report about the
> > cpu_frequency states been snipped out in the entries post the
> > "465.032531" mark ?
> > 
> 
> No, why? Anything looks odd at that point?

I was expecting to see log messages of the following kind after a
kworker thread is scheduled in.

  "kworker/8:2-12137  416.505739: cpu_frequency: state=2061000 cpu_id=8"

> 
> Note that the CPU went idle from 465.035797 to 465.240178, and hence cpufreq's
> deferrable timer didn't fire (and hence kworker didn't run). But once the CPU
> became busy again at 465.240178, the kworker got scheduled on the CPU within
> 2 ms (at 465.242533).

Yes, but the logs don't show the frequency that the kworker thread
would have set on that cpu.

> [..snip...]
> >>
> >> -		load = 100 * (wall_time - idle_time) / wall_time;
> >> +		/*
> >> +		 * If the CPU had gone completely idle, and a task just woke up
> >> +		 * on this CPU now, it would be unfair to calculate 'load' the
> >> +		 * usual way for this elapsed time-window, because it will show
> >> +		 * near-zero load, irrespective of how CPU intensive the new
> >> +		 * task is. This is undesirable for latency-sensitive bursty
> >> +		 * workloads.
> >> +		 *
> >> +		 * To avoid this, we reuse the 'load' from the previous
> >> +		 * time-window and give this task a chance to start with a
> >> +		 * reasonably high CPU frequency.
> >> +		 *
> >> +		 * Detecting this situation is easy: the governor's deferrable
> >> +		 * timer would not have fired during CPU-idle periods. Hence
> >> +		 * an unusually large 'wall_time' indicates this scenario.
> >> +		 */
> >> +		if (unlikely(wall_time > (2 * sampling_rate))) {
> > 					     ^^^^^^^^^^^^^^^^^^
> > 
> > The sampling rate that you've passed is already multiplied by
> > core_dbs_info->rate_mult. Wouldn't that be sufficient ?
> >
> 
> Hmm, no. Strictly speaking, the sampling rate is not a constant in the ondemand
> governor. It gets multiplied with ->rate_mult to dynamically change the sampling
> rate (whenever that is desired). So in the core cpufreq governor code, we should
> use this value (i.e., whatever the ondemand governor passes to dbs_check_cpu()
> as the sampling_rate, _after_ multiplying with ->rate_mult), since that represents
> the maximum sampling rate of the ondemand cpufreq governor.
> 
> However, the additional multiplication by 2 in this code is to ensure that we
> give sufficient buffer or gap, before we start the new "were we idle for very
> long?" logic that this patch introduces.
> 
> I didn't want to check for 'wall_time > sampling_rate' because the timer can fire
> slightly after the expiration of the sampling period, during regular operation
> as well. So we don't want to treat those instances as "very long idle periods",
> because that would be incorrect. Hence I decided to give an additional buffer
> of a full sampling-period.

Ok this makes sense. Thanks for the explanation.


> 
> > The reason why I am mentioning this is that we could have performed
> > all the scaling-up at one place.
> > 
> 
> Indeed, the scaling-up is performed at only this one place: dbs_check_cpu().
> This is not "scaling-up" per-se, but rather a means to ensure that we don't
> kick off the "copy-previous-load" logic if the CPU wasn't actually
> idle for long.

Ok. Understood. 

> 
> And the multiplication with ->rate_mult in the ondemand governor is to avoid the
> complication arising from the dynamic behaviour of the sampling-period, by simply
> assuming the worst-case (largest) sampling period, all the time. This helps us
> accurately recognize the true idle periods in dbs_check_cpu().
> 
> > 
> > Other than this, the patch looks good.
> > 
> > Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
> 
> Thank you!
> 
> Regards,
> Srivatsa S. Bhat
> 
--
Thanks and Regards
gautham.

