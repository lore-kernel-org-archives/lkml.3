Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3FGOwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:52:24 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:55018 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3FGOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <51B177AA.1000600@linux.vnet.ibm.com>
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com>
 <51B177AA.1000600@linux.vnet.ibm.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 7 Jun 2013 15:51:42 +0100
X-Google-Sender-Auth: rhaI006m3QoRcPsqg6ajE7WZv8U
Message-ID: <CAHkRjk5BzoyB0EPbKOU3UZ+zOkhb-u5Tf_pSgO-7JdjW=HCvgQ@mail.gmail.com>
Subject: Re: power-efficient scheduling design
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>, alex.shi@intel.com,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Galbraith <efault@gmx.de>, pjt@google.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>, arjan@linux.intel.com,
        len.brown@intel.com, corbet@lwn.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Preeti,

On 7 June 2013 07:03, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> On 05/31/2013 04:22 PM, Ingo Molnar wrote:
>> PeterZ and me tried to point out the design requirements previously, but
>> it still does not appear to be clear enough to people, so let me spell it
>> out again, in a hopefully clearer fashion.
>>
>> The scheduler has valuable power saving information available:
>>
>>  - when a CPU is busy: about how long the current task expects to run
>>
>>  - when a CPU is idle: how long the current CPU expects _not_ to run
>>
>>  - topology: it knows how the CPUs and caches interrelate and already
>>    optimizes based on that
>>
>>  - various high level and low level load averages and other metrics about
>>    the recent past that show how busy a particular CPU is, how busy the
>>    whole system is, and what the runtime properties of individual tasks is
>>    (how often it sleeps, etc.)
>>
>> so the scheduler is in an _ideal_ position to do a judgement call about
>> the near future and estimate how deep an idle state a CPU core should
>> enter into and what frequency it should run at.
>
> I don't think the problem lies in the fact that scheduler is not making
> these decisions about which idle state the CPU should enter or which
> frequency the CPU should run at.
>
> IIUC, I think the problem lies in the part where although the
> *cpuidle and cpufrequency governors are co-operating with the scheduler,
> the scheduler is not doing the same.*

I think you are missing Ingo's point. It's not about the scheduler
complying with decisions made by various governors in the kernel
(which may or may not have enough information) but rather the
scheduler being in a better position for making such decisions.

Take the cpuidle example, it uses the load average of the CPUs,
however this load average is currently controlled by the scheduler
(load balance). Rather than using a load average that degrades over
time and gradually putting the CPU into deeper sleep states, the
scheduler could predict more accurately that a run-queue won't have
any work over the next x ms and ask for a deeper sleep state from the
beginning.

Of course, you could export more scheduler information to cpuidle,
various hooks (task wakeup etc.) but then we have another framework,
cpufreq. It also decides the CPU parameters (frequency) based on the
load controlled by the scheduler. Can cpufreq decide whether it's
better to keep the CPU at higher frequency so that it gets to idle
quicker and therefore deeper sleep states? I don't think it has enough
information because there are at least three deciding factors
(cpufreq, cpuidle and scheduler's load balancing) which are not
unified.

Some tasks could be known to the scheduler to require significant CPU
cycles when waken up. The scheduler can make the decision to either
boost the frequency of the non-idle CPU and place the task there or
simply wake up the idle CPU. There are all sorts of power implications
here like whether it's better to keep two CPUs at half speed or one at
full speed and the other idle. Such parameters could be provided by
per-platform hooks.

> I would repeat here that today we interface cpuidle/cpufrequency
> policies with scheduler but not the other way around. They do their bit
> when a cpu is busy/idle. However scheduler does not see that somebody
> else is taking instructions from it and comes back to give different
> instructions!

The key here is that cpuidle/cpufreq make their primary decision based
on something controlled by the scheduler: the CPU load (via run-queue
balancing). You would then like the scheduler take such decision back
into account. It just looks like a closed loop, possibly 'unstable' .

So I think we either (a) come up with 'clearer' separation of
responsibilities between scheduler and cpufreq/cpuidle or (b) come up
with a unified load-balancing/cpufreq/cpuidle implementation as per
Ingo's request. The latter is harder but, with a good design, has
potentially a lot more benefits.

A possible implementation for (a) is to let the scheduler focus on
performance load-balancing but control the balance ratio from a
cpufreq governor (via things like arch_scale_freq_power() or something
new). CPUfreq would not be concerned just with individual CPU
load/frequency but also making a decision on how tasks are balanced
between CPUs based on the overall load (e.g. four CPUs are enough for
the current load, I can shut the other four off by telling the
scheduler not to use them).

As for Ingo's preferred solution (b), a proposal forward could be to
factor the load balancing out of kernel/sched/fair.c and provide an
abstract interface (like load_class?) for easier extending or
different policies (e.g. small task packing). You may for example
implement a power saving load policy where idle_balance() does not
pull tasks from other CPUs but rather invoke cpuidle with a prediction
about how long it's going to be idle for. A load class could also give
hints to the cpufreq about the actual load needed using normalised
values and the cpufreq driver could set the best frequency to match
such load. Another hook for task wake-up could place it on the
appropriate run-queue (either for power or performance). And so on.

I don't say the above is the right solution, just a proposal. I think
an initial prototype for Ingo's approach could make a good topic for
the KS.

Best regards.

--
Catalin
