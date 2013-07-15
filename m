Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3GOJzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 05:55:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59744 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754696Ab3GOJzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 05:55:11 -0400
Date: Mon, 15 Jul 2013 10:55:05 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130715095504.GA15799@MacBook-Pro.local>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <51DC414F.5050900@linux.intel.com>
 <51DE9859.8090405@linux.vnet.ibm.com>
 <20130712134811.GG20960@e103034-lin>
 <51E36FF3.1050909@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E36FF3.1050909@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Preeti,

On Mon, Jul 15, 2013 at 04:43:47AM +0100, Preeti U Murthy wrote:
> On 07/12/2013 07:18 PM, Morten Rasmussen wrote:
> > On Thu, Jul 11, 2013 at 12:34:49PM +0100, Preeti U Murthy wrote:
> >> I have a few quick comments.
> >>
> >> I am concerned too about scheduler making its load balancing decisions
> >> based on the cpu frequency for the reason that it could create an
> >> imbalance in the load across cpus.
> >>
> >> Scheduler could keep loading a cpu, because its cpu frequency goes on
> >> increasing, and it could keep un-loading a cpu because its cpu frequency
> >> goes on decreasing. This increase and decrease as an effect of the load
> >> itself. This is of course assuming that the driver would make its
> >> decisions proportional to the cpu load. There could be many more
> >> complications, if the driver makes its decisions on factors unknown to
> >> the scheduler.
> >>
> >> Therefore my suggestion is that we should simply have the scheduler
> >> asking for increase/decrease in the frequency and letting it at that.
> > 
> > If I understand correctly your concern is about the effect of frequency
> > scaling on load-balancing when using tracked load (PJT's) for the task
> > loads as it is done in Alex Shi's patches.
> > 
> > That problem is present even with the existing cpufreq governors and has
> > not been addressed yet. Tasks on cpus at low frequencies appear bigger
> > since they run longer, which will cause the load-balancer to think the
> > cpu loaded and move tasks to other cpus. That will cause cpufreq to
> > lower the frequency of that cpu and make any remaining tasks look even
> > bigger. The story repeats itself.
> > 
> > One might be tempted to suggest to use arch_scale_freq_power to tell the
> > load-balancer about frequency scaling. But in its current form it will
> > actually make it worse, as cpu_power is currently used to indicate max
> > compute capacity and not the current one.
> > 
> > I don't understand how a simple up/down request from the scheduler would
> > solve that problem. It would just make frequency scaling slower if you
> > only go up or down one step at the time. Much like the existing
> > conservative cpufreq governor that nobody uses. Maybe I am missing
> > something?
> > 
> > I think we should look into scaling the tracked load by some metric that
> > represents the current performance of the cpu whenever the tracked load
> > is updated as it was suggested by Arjan in our previous discussion. I
> > included it in my power scheduler design proposal, but I haven't done
> > anything about it yet.
> > 
> > In short, I agree that there is a problem around load-balancing and
> > frequency scaling that needs to be fixed. Without Alex's patches the
> > problem is not present as task load doesn't depend on the cpu load of the
> > task.
> 
> My concern is something like this:
> 
> Scheduler sees a cpu loaded, asks the driver for an increase in its
> frequency. Let us assume now that the driver agrees to increase the
> frequency. Next time the scheduler checks this cpu, it has higher
> capacity due to the increase in the frequency. It loads it more. Now the
> load is high again, an increase in cpu frequency is asked. This cycle if
> it repeats will see a few cpus heavily loaded with the maximum frequency
> that it could possibly run at, while the rest are not at all. Will this
> patch result in such a see-saw situation? This is something I am unable
> to make out.

I don't think Morten's patches change the current behaviour when
cpu_power is set to maximum for all the CPUs. In this first prototype it
actually makes this behaviour explicit by setting cpu_power to max for
the first core and 1 for the rest and gradually allowing next cores to
be used if the previous are loaded. But that's because it doesn't yet
consider the topology. With this in place and feedback from the low
level driver, it could simply tell the load balancer to use the entire
socket as all the cores have the same frequency or that it doesn't make
sense from a power perspective to only use a core within a socket.

> Currently the scheduler sees all cpus alike at a core level. So the bias
> towards some cpu is based only on the load. But in this patch, the bias
> in scheduling can be based on cpu frequency as well. What kind of an
> impact can this have on load balancing? This is my primary concern.
> Probably you will be able to see this in your testing. But just bringing
> out this point.

I don't think we could overload cpu_power any further. It's used mainly
for CPU capacity (Morten's patch sets it to either 1 or 1024). I think
the way around is to make the load tracking frequency-invariant,
possibly using things like aperf/mperf or other counters. It's not
perfect either but probably better than time-based load-tracking for
this scenario.

> >> Secondly, I think we should spend more time on when to make a call to
> >> the frequency driver in your patchset regarding the change in the
> >> frequency of the CPU, the scheduler wishes to request. The reason being,
> >> the whole effort of integrating the knowledge of cpu frequency
> >> statistics into the scheduler is being done because the scheduler can
> >> call the frequency driver at times *complimenting* load balancing,
> >> unlike now.
> > 
> > I don't think I get your point here. The current policy in this patch
> > set is just a prototype that should be improved. The power scheduler
> > does complement the load-balancer already by asking for frequency
> > changes as the cpu load changes.
> 
> Scenario : Lets say the scheduler at some point finds that load
> balancing cannot be done for performance at some point in time. At this
> time, it would be good to have the frequencies of the cpus boosted.
> 
> In the existing implementation, the cpu frequency governor gets called
> after certain intervals of time, asynchronous with the load balancing.
> In the above scenario the frequency governor would probably not come to
> the rescue in time to ask for a boost in the frequency of the cpus. Your
> patch has the potential to solve this. We are now considering calling
> calculate_cpu_capacities() in the scheduler tick. Will this solve the
> above mentioned scenario? Or is the above scenario hypothetical?

Morten's patches calculate the CPU capacities periodically but it will
be tight to the scheduler tick in a new version. The power scheduler has
tighter integration with the task scheduler, so it gets statistics like
load, number of tasks. It can easily detect whether the load can be
spread to other CPUs or it just needs to boost the current frequency.

In terms of how it boosts the performance, a suggestion was to keep the
power scheduler relatively simple with an API to a new model of power
driver and have the actual scaling algorithm (governor) as library used
by the low-level driver. We can keep the API simple like
get_max_performance() etc. but the driver has the potential to choose
what is best suited for the hardware.

-- 
Catalin
