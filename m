Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3AVDT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:19:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:17574 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab3AVDT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:19:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="280273113"
Message-ID: <50FE0575.6090005@intel.com>
Date: Tue, 22 Jan 2013 11:20:21 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, namhyung@kernel.org,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        preeti@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 09/22] sched: compute runnable load avg in cpu_load
 and cpu_avg_load_per_task
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-10-git-send-email-alex.shi@intel.com> <50E7EAB1.6020302@intel.com> <50E92DC3.4050906@intel.com> <CA+55aFxbS-u1Zfwg2oKOmHq6FBF+dRRhrdssqc9PpC_gXoV3+g@mail.gmail.com> <50EFB1DB.7090804@intel.com> <50FD54EA.4060804@intel.com>
In-Reply-To: <50FD54EA.4060804@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>
>>>> I just looked into the aim9 benchmark, in this case it forks 2000 tasks,
>>>> after all tasks ready, aim9 give a signal than all tasks burst waking up
>>>> and run until all finished.
>>>> Since each of tasks are finished very quickly, a imbalanced empty cpu
>>>> may goes to sleep till a regular balancing give it some new tasks. That
>>>> causes the performance dropping. cause more idle entering.
>>>
>>> Sounds like for AIM (and possibly for other really bursty loads), we
>>> might want to do some load-balancing at wakeup time by *just* looking
>>> at the number of running tasks, rather than at the load average. Hmm?
>>>
>>> The load average is fundamentally always going to run behind a bit,
>>> and while you want to use it for long-term balancing, a short-term you
>>> might want to do just a "if we have a huge amount of runnable
>>> processes, do a load balancing *now*". Where "huge amount" should
>>> probably be relative to the long-term load balancing (ie comparing the
>>> number of runnable processes on this CPU right *now* with the load
>>> average over the last second or so would show a clear spike, and a
>>> reason for quick action).
>>>
>>
>> Sorry for response late!
>>
>> Just written a patch following your suggestion, but no clear improvement for this case.
>> I also tried change the burst checking interval, also no clear help.
>>
>> If I totally give up runnable load in periodic balancing, the performance can recover 60%
>> of lose.
>>
>> I will try to optimize wake up balancing in weekend.
>>
> 
> (btw, the time for runnable avg to accumulate to 100%, needs 345ms; to
> 50% needs 32 ms)
> 
> I have tried some tuning in both wake up balancing and regular
> balancing. Yes, when using instant load weight (without runnable avg
> engage), both in waking up, and regular balance, the performance recovered.
> 
> But with per_cpu nr_running tracking, it's hard to find a elegant way to
> detect the burst whenever in waking up or in regular balance.
> In waking up, the whole sd_llc domain cpus are candidates, so just
> checking this_cpu is not enough.
> In regular balance, this_cpu is the migration destination cpu, checking
> if the burst on the cpu is not useful. Instead, we need to check whole
> domains' increased task number.
> 
> So, guess 2 solutions for this issue.
> 1, for quick waking up, we need use instant load(same as current
> balancing) to do balance; and for regular balance, we can record both
> instant load and runnable load data for whole domain, then decide which
> one to use according to task number increasing in the domain after
> tracking done the whole domain.
> 
> 2, we can keep current instant load balancing as performance balance
> policy, and using runnable load balancing in power friend policy.
> Since, none of us find performance benefit with runnable load balancing
> on benchmark hackbench/kbuild/aim9/tbench/specjbb etc.
> I prefer the 2nd.

3, On the other hand, Considering the aim9 testing scenario is rare in
real life(prepare thousands tasks and then wake up them at the same
time). And the runnable load avg includes useful running history info.
Only aim9 5~7% performance dropping is not unacceptable.
(kbuild/hackbench/tbench/specjbb have no clear performance change)

So we can let this drop be with a reminder in code. Any comments?

