Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaHRSZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:25:11 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:58912 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHRSZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:25:09 -0400
Date: Mon, 18 Aug 2014 14:25:04 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org, len.brown@intel.com,
        yuyang.du@intel.com, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, corbet@lwn.net, catalin.marinas@arm.com,
        markgross@thegnar.org, sundar.iyer@intel.com,
        linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com,
        Lorenzo.Pieralisi@arm.com, mike.turquette@linaro.org,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
Subject: Re: [RFC PATCH V2 02/19] sched/power: Move idle state selection into
 the scheduler
In-Reply-To: <53F235B8.8060506@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.11.1408181400220.29347@knanqh.ubzr>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com> <20140811113246.31956.49929.stgit@preeti.in.ibm.com> <alpine.LFD.2.11.1408181140190.29347@knanqh.ubzr> <53F235B8.8060506@linux.vnet.ibm.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2014, Preeti U Murthy wrote:

> On 08/18/2014 09:24 PM, Nicolas Pitre wrote:
> > On Mon, 11 Aug 2014, Preeti U Murthy wrote:
> > 
> >> The goal of the power aware scheduling design is to integrate all
> >> policy, metrics and averaging into the scheduler. Today the
> >> cpu power management is fragmented and hence inconsistent.
> >>
> >> As a first step towards this integration, rid the cpuidle state management
> >> of the governors. Retain only the cpuidle driver in the cpu idle
> >> susbsystem which acts as an interface between the scheduler and low
> >> level platform specific cpuidle drivers. For all decision making around
> >> selection of idle states,the cpuidle driver falls back to the scheduler.
> >>
> >> The current algorithm for idle state selection is the same as the logic used
> >> by the menu governor. However going ahead the heuristics will be tuned and
> >> improved upon with metrics better known to the scheduler.
> > 
> > I'd strongly suggest a different approach here.  Instead of copying the 
> > menu governor code and tweaking it afterwards, it would be cleaner to 
> > literally start from scratch with a new governor.  Said new governor 
> > would grow inside the scheduler with more design freedom instead of 
> > being strapped on the side.
> > 
> > By copying existing code, the chance for cruft to remain for a long time 
> > is close to 100%. We already have one copy of it, let's keep it working 
> > and start afresh instead.
> > 
> > By starting clean it is way easier to explain and justify additions to a 
> > new design than convincing ourselves about the removal of no longer 
> > needed pieces from a legacy design.
> 
> Ok. The reason I did it this way was that I did not find anything
> grossly wrong in the current cpuidle governor algorithm. Of course this
> can be improved but I did not see strong reasons to completely wipe it
> away. I see good scope to improve upon the existing algorithm with
> additional knowledge of *the idle states being mapped to scheduling
> domains*. This will in itself give us a better algorithm and does not
> mandate significant changes from the current algorithm. So I really
> don't see why we need to start from scratch.

Sure the current algorithm can be improved.  But it has its limitations 
by design.  And simply making it more topology aware wouldn't justify 
moving it into the scheduler.

What we're contemplating is something completely integrated with the 
scheduler where cpuidle and cpufreq (and eventually thermal management) 
together are part of the same "governor" to provide global decisions on 
all 
fronts.

Not only should the next wake-up event be predicted, but also the 
anticipated system load, etc.  The scheduler may know that a given CPU 
is unlikely to be used for a while and could call for the deepest 
C-state right away without waiting for the current menu heuristic to 
converge.

There is also Daniel's I/O latency tracking that could replace the menu 
governor latency guessing, the later based on heuristics that could be 
described as black magic.

And all this has to eventually be policed by a global performance/power 
concern that should weight C-states, P-states and task placement 
together and select the best combination (Morten's work).

Therefore the current menu algorithm won't do it. It simply wasn't 
designed for that.

We'll have the opportunity to discuss this further tomorrow anyway.

> The primary issue that I found was that with the goal being power aware
> scheduler we must ensure that the possibility of a governor getting
> registered with cpuidle to choose idle states no longer will exist. The
> reason being there is just *one entity who will take this decision and
> there is no option about it*. This patch intends to bring the focus to
> this specific detail.

I think there is nothing wrong with having multiple governors being 
registered.  We simply decide at runtime via sysfs which one has control 
over the low-level cpuidle drivers.


Nicolas
