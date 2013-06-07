Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab3FGSLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:11:10 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:60475 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab3FGSLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:11:08 -0400
Message-ID: <51B221AF.9070906@linux.vnet.ibm.com>
Date: Fri, 07 Jun 2013 23:38:47 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>
CC: alex.shi@intel.com, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Galbraith <efault@gmx.de>, pjt@google.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>, arjan@linux.intel.com,
        len.brown@intel.com, corbet@lwn.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: power-efficient scheduling design
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com> <51B177AA.1000600@linux.vnet.ibm.com> <CAHkRjk5BzoyB0EPbKOU3UZ+zOkhb-u5Tf_pSgO-7JdjW=HCvgQ@mail.gmail.com>
In-Reply-To: <CAHkRjk5BzoyB0EPbKOU3UZ+zOkhb-u5Tf_pSgO-7JdjW=HCvgQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060718-1618-0000-0000-00000409795C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On 06/07/2013 08:21 PM, Catalin Marinas wrote:
> I think you are missing Ingo's point. It's not about the scheduler
> complying with decisions made by various governors in the kernel
> (which may or may not have enough information) but rather the
> scheduler being in a better position for making such decisions.

My mail pointed out that I disagree with this design ("the scheduler
being in a better position for making such decisions").
I think it should be a 2 way co-operation. I have elaborated below.

> Take the cpuidle example, it uses the load average of the CPUs,
> however this load average is currently controlled by the scheduler
> (load balance). Rather than using a load average that degrades over
> time and gradually putting the CPU into deeper sleep states, the
> scheduler could predict more accurately that a run-queue won't have
> any work over the next x ms and ask for a deeper sleep state from the
> beginning.

How will the scheduler know that there will not be work in the near
future? How will the scheduler ask for a deeper sleep state?

My answer to the above two questions are, the scheduler cannot know how
much work will come up. All it knows is the current load of the
runqueues and the nature of the task (thanks to the PJT's metric). It
can then match the task load to the cpu capacity and schedule the tasks
on the appropriate cpus.

As a consequence, it leaves certain cpus idle. The load of these cpus
degrade. It is via this load that the scheduler asks for a deeper sleep
state. Right here we have scheduler talking to the cpuidle governor.

I don't see what the problem is with the cpuidle governor waiting for
the load to degrade before putting that cpu to sleep. In my opinion,
putting a cpu to deeper sleep states should happen gradually. This means
time will tell the governors what kinds of workloads are running on the
system. If the cpu is idle for long, it probably means that the system
is less loaded and it makes sense to put the cpus to deeper sleep
states. Of course there could be sporadic bursts or quieting down of
tasks, but these are corner cases.

> 
> Of course, you could export more scheduler information to cpuidle,
> various hooks (task wakeup etc.) but then we have another framework,
> cpufreq. It also decides the CPU parameters (frequency) based on the
> load controlled by the scheduler. Can cpufreq decide whether it's
> better to keep the CPU at higher frequency so that it gets to idle
> quicker and therefore deeper sleep states? I don't think it has enough
> information because there are at least three deciding factors
> (cpufreq, cpuidle and scheduler's load balancing) which are not
> unified.

Why not? When the cpu load is high, cpu frequency governor knows it has
to boost the frequency of that CPU. The task gets over quickly, the CPU
goes idle. Then the cpuidle governor kicks in to put the CPU to deeper
sleep state gradually.

Meanwhile the scheduler should ensure that the tasks are retained on
that CPU,whose frequency is boosted and should not load balance it, so
that they can get over quickly. This I think is what is missing. Again
this comes down to the scheduler taking feedback from the CPU frequency
governors which is not currently happening.

> 
> Some tasks could be known to the scheduler to require significant CPU
> cycles when waken up. The scheduler can make the decision to either
> boost the frequency of the non-idle CPU and place the task there or
> simply wake up the idle CPU. There are all sorts of power implications
> here like whether it's better to keep two CPUs at half speed or one at
> full speed and the other idle. Such parameters could be provided by
> per-platform hooks.

This is why the cpuidle and cpufrequency drivers are for. They are meant
to collect such parameters. It is just that the scheduler should be made
aware of them.

> 
>> I would repeat here that today we interface cpuidle/cpufrequency
>> policies with scheduler but not the other way around. They do their bit
>> when a cpu is busy/idle. However scheduler does not see that somebody
>> else is taking instructions from it and comes back to give different
>> instructions!
> 
> The key here is that cpuidle/cpufreq make their primary decision based
> on something controlled by the scheduler: the CPU load (via run-queue
> balancing). You would then like the scheduler take such decision back
> into account. It just looks like a closed loop, possibly 'unstable' .

Why? Why would you call a scheduler->cpuidle->cpufrequency interaction a
closed loop and not the new_scheduler = scheduler+cpuidle+cpufrequency a
closed loop? Here too the scheduler should be made well aware of the
decisions it took in the past right?

> 
> So I think we either (a) come up with 'clearer' separation of
> responsibilities between scheduler and cpufreq/cpuidle 

I agree with this. This is what I have been emphasizing, if we feel that
the cpufrequency/ cpuidle subsystems are suboptimal in terms of the
information that they use to make their decisions, let us improve them.
But this will not yield us any improvement if the scheduler does not
have enough information. And IMHO, the next fundamental information that
the scheduler needs should come from cpufreq and cpuidle.

Then we should move onto supplying scheduler information from the power
domain topology, thermal factors, user policies. This does not need a
re-write of the scheduler, this would need a good interface between the
scheduler and the rest of the ecosystem. This ecosystem includes the
cpuidle subsystem, cpu frequency subsystems and they are already in
place. Lets use them.

or (b) come up
> with a unified load-balancing/cpufreq/cpuidle implementation as per
> Ingo's request. The latter is harder but, with a good design, has
> potentially a lot more benefits.
> 
> A possible implementation for (a) is to let the scheduler focus on
> performance load-balancing but control the balance ratio from a
> cpufreq governor (via things like arch_scale_freq_power() or something
> new). CPUfreq would not be concerned just with individual CPU
> load/frequency but also making a decision on how tasks are balanced
> between CPUs based on the overall load (e.g. four CPUs are enough for
> the current load, I can shut the other four off by telling the
> scheduler not to use them).
> 
> As for Ingo's preferred solution (b), a proposal forward could be to
> factor the load balancing out of kernel/sched/fair.c and provide an
> abstract interface (like load_class?) for easier extending or
> different policies (e.g. small task packing). 

 Let me elaborate on the patches that have been posted so far on the
power awareness of the scheduler. When we say *power aware scheduler*
what exactly do we want it to do?

In my opinion, we want it to *avoid touching idle cpus*, so as to keep
them in that state longer and *keep more power domains idle*, so as to
yield power savings with them turned off. The patches released so far
are striving to do the latter. Correct me if I am wrong at this. Also
feel free to point out any other expectation from the power aware
scheduler if I am missing any.

If I have got Ingo's point right, the issues with them are that they are
not taking a holistic approach to meet the said goal. Keeping more power
domains idle (by packing tasks) would sound much better if the scheduler
has taken all aspects of doing such a thing into account, like

1. How idle are the cpus, on the domain that it is packing
2. Can they go to turbo mode, because if they do,then we cant pack
tasks. We would need certain cpus in that domain idle.
3. Are the domains in which we pack tasks power gated?
4. Will there be significant performance drop by packing? Meaning do the
tasks share cpu resources? If they do there will be severe contention.

The approach I suggest therefore would be to get the scheduler well in
sync with the eco system, then the patches posted so far will achieve
their goals more easily and with very few regressions because they are
well informed decisions.


Regards
Preeti U Murthy


> Best regards.
> 
> --
> Catalin
> 

