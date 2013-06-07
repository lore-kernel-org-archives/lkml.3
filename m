Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3FGG3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:29:13 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57690 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3FGG3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:29:11 -0400
Message-ID: <51B17D19.1070901@linux.vnet.ibm.com>
Date: Fri, 07 Jun 2013 11:56:33 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Ingo Molnar <mingo@kernel.org>, "alex.shi@intel.com" <alex.shi@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: power-efficient scheduling design
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com> <20130604150316.GE32728@e103034-lin>
In-Reply-To: <20130604150316.GE32728@e103034-lin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060717-3568-0000-0000-000003BB8B5C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morten,

I have one point to make below.

On 06/04/2013 08:33 PM, Morten Rasmussen wrote:
> 
> Thanks for sharing your view.
> 
> I agree with idea of having a high level user switch to change
> power/performance policy trade-offs for the system. Not only for
> scheduling. I also share your view that the scheduler is in the ideal
> place to drive the frequency scaling and idle policies.
> 
> However, I think that an integrated solution with one unified policy
> implemented in the scheduler would take a significant rewrite of the
> scheduler and the power management frameworks even if we start with just
> a few SoCs.
> 
> To reach an integrated solution that does better than the current
> approach there is a range of things that need to be considered:
> 
> - Define a power-efficient scheduling policy. Depending on the power
>   gating support on the particular system packing tasks may improve
>   power-efficiency while spreading the tasks may be better for others.
> 
> - Define how the user policy switch works. In previous discussions it
>   was proposed to have a high level switch that allows specification of
>   what the system should strive to achieve - power saving or performance.
>   In those discussions, what power meant wasn't exactly defined.
> 
> - Find a generic way to represent the power topology which includes
>   power domains, voltage domains and frequency domains. Also, more
>   importantly how we can derive the optimal power/performance policy for
>   the specific platform. There may be dependencies between idle and
>   frequency states like it is the case for frequency boost mode like Arjan
>   mentions in his reply.
> 
> - The fact that not all platforms expose all idle states to the OS and
>   that closed firmware may do whatever it likes behind the scenes. There
>   are various reasons to do this. Not all of them are bad.
> 
> - Define a scheduler driven frequency scaling policy that at least
>   matches the 'performance' of the current cpufreq policies and has
>   potential for further improvements.
> 
> - Match the power savings of the current cpuidle governors which are
>   based on arcane heuristics developed over years to predict things like
>   the occurrence of the next interrupt.
> 
> - Thermal aspects add more complexity to the power/performance policy.
>   Depending on the platform, overheating may be handled by frequency
>   capping or restricting the number of active cpus.
> 
> - Asymmetric/heterogeneous multi-processors need to be dealt with.
> 
> This is not a complete list. My point is that moving all policy to the
> scheduler will significantly increase the complexity of the scheduler.
> It is my impression that the general opinion is that the scheduler is
> already too complicated. Correct me if I'm wrong.

I don't think this is the idea. As you have rightly pointed out above,
the current cpuidle and cpufrequency governors are based on heuristics
that have been developed over years. So in my opinion, we must not
strive at duplicating this effort in the scheduler, rather we must
strive at improving the co-operation between scheduler and these governors.

As I have mentioned in the reply to Ingo's mail, we do not have a two
way co-operation between cpuidle/cpufrequency subsystems and scheduler.
When the scheduler decides not to schedule tasks on certain CPUs for a
long time the cpuidle governor for instance, puts them into deep idle
state since it looks at load average of CPUs, among other things before
doing this.

So here we notice that cpuidle is *listening* to scheduler decisions.
However when the scheduler decides to schedule newer/woken up tasks, it
looks for the *idlest* cpu to run them on, without considering which
idle state that CPU is in. The result is waking up a deep idle state
CPU, rather than a shallow one, thus hindering power savings. IOW, the
scheduler is *not listening* to the decisions taken by the cpuidle governor.

If we observe the basis and the principle of scheduling today, the
scheduler makes its decisions based on the scheduling domain hierarchy
and more importantly the *load* on the CPUs. It does not consider other
aspects like idleness/frequency/ thermal aspects among the things that
you and Ingo have pointed out. I think here is where we need to step in.
We need scheduler to be *well aware* of its ecosystem,
*not necessarily decide this ecosystem*.

As Amit Kucheria has pointed out, currently without this two way
co-operation, we might see scheduler fighting with these subsystems.
We could as one of the steps to power savings in scheduler, try and
eliminate that.

> While the proposed task packing patches are not complete solutions, they
> address the first item on the above list and can be seen as a step
> towards the goal.
> 
> Should I read your recommendation as you prefer a complete and
> potentially huge patch set over incremental patch sets?
> 
> It would be good to have even a high level agreement on the path forward
> where the expectation first and foremost is to take advantage of the
> schedulers ideal position to drive the power management while
> simplifying the power management code.
> 
> Thanks,
> Morten
> 

Regards
Preeti U Murthy

