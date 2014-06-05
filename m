Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaFELfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:35:48 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:41474 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750921AbaFELfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:35:46 -0400
Date: Thu, 5 Jun 2014 12:35:42 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 01/16] sched: Documentation for scheduler energy cost
 model
Message-ID: <20140605113542.GT29593@e103034-lin>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-2-git-send-email-morten.rasmussen@arm.com>
 <CAKfTPtB6fC76vtChMqAcrnrOaEsEM7pM411qW4VmGJh4TYgT8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtB6fC76vtChMqAcrnrOaEsEM7pM411qW4VmGJh4TYgT8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 09:49:35AM +0100, Vincent Guittot wrote:
> Hi Morten,
> 
> On 23 May 2014 20:16, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > This documentation patch provide a brief overview of the experimental
> > scheduler energy costing model and associated data structures.
> >
> > Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> > ---
> >  Documentation/scheduler/sched-energy.txt |   66 ++++++++++++++++++++++++++++++
> >  1 file changed, 66 insertions(+)
> >  create mode 100644 Documentation/scheduler/sched-energy.txt
> >
> > diff --git a/Documentation/scheduler/sched-energy.txt b/Documentation/scheduler/sched-energy.txt
> > new file mode 100644
> > index 0000000..c6896c0
> > --- /dev/null
> > +++ b/Documentation/scheduler/sched-energy.txt
> > @@ -0,0 +1,66 @@
> > +Energy cost model for energy-aware scheduling (EXPERIMENTAL)
> > +
> > +Introduction
> > +=============
> > +The basic energy model uses platform energy data stored in sched_energy data
> > +structures attached to the sched_groups in the sched_domain hierarchy. The
> > +energy cost model offers two function that can be used to guide scheduling
> > +decisions:
> > +
> > +1.     energy_diff_util(cpu, util, wakeups)
> 
> Could you give us mor edetails of what util and wakeups are ?
> util is a absolute value or a delta
> Is wakeups a boolean or does wakeups define a number of tasks/cpus
> that wake up ?

Good point... It is not clear at all. Improving the documentation is at
the top of my todo list.

cpu: The cpu in question.

util: Is a signed utilization delta. That is, the amount of utilization
we want to add or remove from the cpu. We don't have good metric for
utilization yet (I assume you have followed the thread on that topic
that started from your recent patch posting), so for now I have used
load_avg_contrib. energy_diff_task() just passes the task
load_avg_contrib as the utilization to energy_diff_load().

wakeups: Is the number of wakeups (task enqueues, not idle exits) caused
by the utilization we are about to add or remove from the cpu. We need
to pick some period to measure the wakeups over. For that I have
introduced task wakeup tracking, very similar to the existing load tracking.
The wakeup tracking gives us an indication of how often a task will
cause an idle exit if it ran alone on a cpu. For short but frequently
running tasks, the wakeup cost may be where the majority of the energy
is spent.

> 
> > +2.     energy_diff_task(cpu, task)
> > +
> > +Both return the energy cost delta caused by adding/removing utilization or a
> > +task to/from a specific cpu.
> > +
> > +CONFIG_SCHED_ENERGY needs to be defined in Kconfig to enable the energy cost
> > +model and associated data structures.
> > +
> > +The basic algorithm
> > +====================
> > +The basic idea is to determine the energy cost at each level in sched_domain
> > +hierarchy based on utilization:
> > +
> > +       for_each_domain(cpu, sd) {
> > +               sg = sched_group_of(cpu)
> > +               energy_before = curr_util(sg) * busy_power(sg)
> > +                               + 1-curr_util(sg) * idle_power(sg)
> > +               energy_after = new_util(sg) * busy_power(sg)
> > +                               + 1-new_util(sg) * idle_power(sg)
> > +                               + new_util(sg) * task_wakeups
> > +                                                       * wakeup_energy(sg)
> > +               energy_diff += energy_before - energy_after
> > +       }
> > +
> > +       return energy_diff
> 
> So this is the algorithm used in energy_diff_util and energy_diff_task ?

It is. energy_diff_task() is basically just a wrapper for
energy_diff_util().

> it's not straight foward for me to map the algorithm variable and the
> function argument

The pseudo-code above is very simplified. It is an attempt to show that
the algorithm goes up the sched_domain hierarhcy and estimates the
energy impact of adding/removing 'util' amount of utilization to/from
the cpu.

{curr, new}_util is the cpu utilization at the lowest level and
the overall non-idle time for the entire group for higher levels.
utilization is in the range 0.0 to 1.0.

busy_power is the power consumption of the group (for TC2, cpu at the
lowest level, cluster at the next).

idle_power is the power consumption of the group while idle (for TC2,
WFI at the lowest level, cluster power down at cluster level).

task_wakeups (should have been just 'wakeups' in the general case) is the
number of wakeups caused by the utilization we are adding/removing. To
predict how many of the wakeups that causes idle exits we scale the
number by the utilization (assuming that wakeups are uniformly
distributed). wakeup_energy is the energy consumed for an idle
exit/entry cycle for the group (for TC2, WFI at lowest level, cluster
power down at cluster level).

At each level we need to compute the energy before and after the change
to find the energy delta.

Does that answer your question?

> 
> > +
> > +Platform energy data
> > +=====================
> > +struct sched_energy has the following members:
> > +
> > +cap_states:
> > +       List of struct capacity_state representing the supported capacity states
> > +       (P-states). struct capacity_state has two members: cap and power, which
> > +       represents the compute capacity and the busy power of the state. The
> > +       list must ordered by capacity low->high.
> > +
> > +nr_cap_states:
> > +       Number of capacity states in cap_states.
> > +
> > +max_capacity:
> > +       The highest capacity supported by any of the capacity states in
> > +       cap_states.
> 
> can't you directly use cap_states[nr_cap_states].cap has the array is ordered ?

Yes, indeed. max_capacity can be removed.

Morten

