Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3FGGGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:06:06 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:34588 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3FGGGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:06:03 -0400
Message-ID: <51B177AA.1000600@linux.vnet.ibm.com>
Date: Fri, 07 Jun 2013 11:33:22 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>, alex.shi@intel.com,
        peterz@infradead.org, vincent.guittot@linaro.org, efault@gmx.de,
        pjt@google.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, arjan@linux.intel.com,
        len.brown@intel.com, corbet@lwn.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de
Subject: Re: power-efficient scheduling design
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com>
In-Reply-To: <20130531105204.GE30394@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060705-5816-0000-0000-000008514586
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/31/2013 04:22 PM, Ingo Molnar wrote:
> PeterZ and me tried to point out the design requirements previously, but 
> it still does not appear to be clear enough to people, so let me spell it 
> out again, in a hopefully clearer fashion.
> 
> The scheduler has valuable power saving information available:
> 
>  - when a CPU is busy: about how long the current task expects to run
> 
>  - when a CPU is idle: how long the current CPU expects _not_ to run
> 
>  - topology: it knows how the CPUs and caches interrelate and already 
>    optimizes based on that
> 
>  - various high level and low level load averages and other metrics about 
>    the recent past that show how busy a particular CPU is, how busy the 
>    whole system is, and what the runtime properties of individual tasks is 
>    (how often it sleeps, etc.)
> 
> so the scheduler is in an _ideal_ position to do a judgement call about 
> the near future and estimate how deep an idle state a CPU core should 
> enter into and what frequency it should run at.

I don't think the problem lies in the fact that scheduler is not making
these decisions about which idle state the CPU should enter or which
frequency the CPU should run at.

IIUC, I think the problem lies in the part where although the
*cpuidle and cpufrequency governors are co-operating with the scheduler,
the scheduler is not doing the same.*

Let me elaborate with respect to cpuidle subsystem. When the scheduler
chooses the CPUs to run tasks on, it leaves certain other CPUs idle. The
cpuidle governor then evaluates, among other things, the load average of
the CPUs, before deciding to put it into an ideal idle state. With the
PJT's metric, an idle CPU's load average degrades over time and cpuidle
governor will perhaps decide to put such CPUs to deep idle states.

But the problem surfaces when scheduler gets to choose a CPU to run
new/woken up tasks on. It chooses the *idlest_cpu* to run the task on
without considering how deep an idle state that CPU is in,if at all it
is in an idle state. It would end up waking a deep sleeping CPU, which
will *hinder power savings*.

I think here is where we need to focus. Currently, there is no
*two way co-operation between the scheduler and cpuidle/cpufrequency*
subsystems, which makes no sense. In the above case for instance
scheduler prompts the cpuidle governor to put CPU to idle state and
comes back to hamper that move.

> 
> The scheduler is also at a high enough level to host a "I want maximum 
> performance, power does not matter to me" user policy override switch and 
> similar user policy details.
> 
> No ifs and whens about that.
> 
> Today the power saving landscape is fragmented and sad: we just randomly 
> interface scheduler task packing changes with some idle policy (and 
> cpufreq policy), which might or might not combine correctly.

I would repeat here that today we interface cpuidle/cpufrequency
policies with scheduler but not the other way around. They do their bit
when a cpu is busy/idle. However scheduler does not see that somebody
else is taking instructions from it and comes back to give different
instructions!

Therefore I think among other things, this is one fundamental issue that
we need to resolve in the steps towards better power savings through
scheduler.

Regards
Preeti U Murthy


