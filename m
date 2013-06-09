Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab3FIEgK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 00:36:10 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:45036 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3FIEgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 00:36:09 -0400
Message-ID: <51B405AF.2030301@linux.vnet.ibm.com>
Date: Sun, 09 Jun 2013 10:03:51 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: David Lang <david@lang.hm>
CC: Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@kernel.org>,
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
Subject: Re: power-efficient scheduling design
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com> <51B177AA.1000600@linux.vnet.ibm.com> <CAHkRjk5BzoyB0EPbKOU3UZ+zOkhb-u5Tf_pSgO-7JdjW=HCvgQ@mail.gmail.com> <51B221AF.9070906@linux.vnet.ibm.com> <alpine.DEB.2.02.1306071030470.11669@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1306071030470.11669@nftneq.ynat.uz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060904-1396-0000-0000-0000031715A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 06/07/2013 11:06 PM, David Lang wrote:
> On Fri, 7 Jun 2013, Preeti U Murthy wrote:
> 
>> Hi Catalin,
>>
>> On 06/07/2013 08:21 PM, Catalin Marinas wrote:
> <SNIP>
>>> Take the cpuidle example, it uses the load average of the CPUs,
>>> however this load average is currently controlled by the scheduler
>>> (load balance). Rather than using a load average that degrades over
>>> time and gradually putting the CPU into deeper sleep states, the
>>> scheduler could predict more accurately that a run-queue won't have
>>> any work over the next x ms and ask for a deeper sleep state from the
>>> beginning.
>>
>> How will the scheduler know that there will not be work in the near
>> future? How will the scheduler ask for a deeper sleep state?
>>
>> My answer to the above two questions are, the scheduler cannot know how
>> much work will come up. All it knows is the current load of the
>> runqueues and the nature of the task (thanks to the PJT's metric). It
>> can then match the task load to the cpu capacity and schedule the tasks
>> on the appropriate cpus.
> 
> how will the cpuidle govenor know what will come up in the future?
> 
> the scheduler knows more than the current load on the runqueus, it
> tracks some information about the past behavior of the process that it
> uses for it's decisions. This is information that cpuidle doesn't have.

This is incorrect. The scheduler knows the possible future load on a cpu
due to past behavior, thats right, and so does cpuidle today. It queries
the load average for predicted idle time and compares this with exit
latencies of the idle states.

> 
> <SNIP>
>> I don't see what the problem is with the cpuidle governor waiting for
>> the load to degrade before putting that cpu to sleep. In my opinion,
>> putting a cpu to deeper sleep states should happen gradually.
> 
> remember that it takes power and time to wake up a cpu to put it in a
> deeper sleep state.

Correct. I apologise in saying that it does it gradually. This is not
entirely right. cpuidle governor can decide on the state the cpu is best
put into directly without going through the shallow idle states.
It also takes care to rectify any incorrect prediction. So there is no
exit-enter-exit-enter sub optimal implementation.

> 
>>> Of course, you could export more scheduler information to cpuidle,
>>> various hooks (task wakeup etc.) but then we have another framework,
>>> cpufreq. It also decides the CPU parameters (frequency) based on the
>>> load controlled by the scheduler. Can cpufreq decide whether it's
>>> better to keep the CPU at higher frequency so that it gets to idle
>>> quicker and therefore deeper sleep states? I don't think it has enough
>>> information because there are at least three deciding factors
>>> (cpufreq, cpuidle and scheduler's load balancing) which are not
>>> unified.
>>
>> Why not? When the cpu load is high, cpu frequency governor knows it has
>> to boost the frequency of that CPU. The task gets over quickly, the CPU
>> goes idle. Then the cpuidle governor kicks in to put the CPU to deeper
>> sleep state gradually.
>>
>> Meanwhile the scheduler should ensure that the tasks are retained on
>> that CPU,whose frequency is boosted and should not load balance it, so
>> that they can get over quickly. This I think is what is missing. Again
>> this comes down to the scheduler taking feedback from the CPU frequency
>> governors which is not currently happening.
> 
> how should the scheduler know that the cpufreq governor decided to boost
> the speed of one CPU to handle an important process as opposed to
> handling multiple smaller processes?

This has been elaborated in my response to Rafael's mail. Scheduler
decides to call cpu frequency governor when it sees fit. Then cpu
frequency governor boosts the frequency of that cpu. cpu_power  will now
match the task load. So scheduler will not move the task away from that
cpu since load does not exceed cpu capacity. So scheduler knows in this way.

> the communication between the two is starting to sound really messy
> 

Not really. More is elaborated in responses to Catalin and Rafael's mails.

Regards
Preeti U Murthy
> David Lang
> 

