Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab3FLPYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:24:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:5813 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab3FLPYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:24:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,853,1363158000"; 
   d="scan'208";a="352313533"
Message-ID: <51B892C4.6090800@linux.intel.com>
Date: Wed, 12 Jun 2013 08:24:52 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: David Lang <david@lang.hm>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ingo Molnar <mingo@kernel.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Galbraith <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: power-efficient scheduling design
References: <20130530134718.GB32728@e103034-lin> <51B221AF.9070906@linux.vnet.ibm.com> <20130608112801.GA8120@MacBook-Pro.local> <1834293.MlyIaiESPL@vostro.rjw.lan> <51B3F99A.4000101@linux.vnet.ibm.com> <51B5FE02.7040607@linaro.org> <alpine.DEB.2.02.1306111722470.24968@nftneq.ynat.uz> <51B7D38A.7050204@linux.intel.com> <20130612102019.GA6976@arm.com>
In-Reply-To: <20130612102019.GA6976@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> This isn't in the fastpath, it's in the rebalancing logic.
>>
>> the reality is much more complex unfortunately.
>> C and P states hang together tightly, and even C state on one core
>> impacts other cores' performance, just like P state selection on one
>> core impacts other cores.
>>
>> (at least for x86, we should really stop talking as if the OS picks
>> the "frequency", that's just not the case anymore)
>
> I agree, the reality is very complex. But we should go back and analyse
> what problem we are trying to solve, what each framework is trying to
> address.
>
> When viewed separately from the scheduler, cpufreq and cpuidle governors
> do the right thing. But they both base their action on the CPU load
> (balance) decided by the scheduler and it's the latter that we are
> trying to adjust (and we are still debating what the right approach is).
>
> Since such information seems too complex to be moved into the scheduler,
> why don't we get cpufreq in charge of restricting the load balancing to
> certain CPUs? It already tracks the load/idle time to (gradually) change
> the P state. Depending on the governor/policy, it could decide that (for

(btw in case you missed it, for Intel HW we no longer use cpufreq anymore)


> Cpuidle I think for now can stay the same, gradually entering deeper
> sleep states. It could be later unified with cpufreq if there are any
> benefits. In deciding the load balancing restrictions, maybe cpufreq
> should be aware of C-state latencies.

on the Intel side, we're likely to merge the Intel idle driver and P state driver
in the near future fwiw.
We'll keep using cpuidle framework (since it doesn't do all that much other than
provide a nice hook for the idle loop), but we likely will make a hw specific
selection logic there.

I do agree the scheduler needs to get integrated a bit better, in that it
has some better knowledge, and to be honest, we likely need to switch from
giving tasks credit for "time consumed" to giving them credit for something like
"cycles consumed" or "instructions executed" or a mix thereof.
So that a task that runs on a slower CPU (for either policy choice reasons or
due to hardware capabilities), it gets charged less than when it runs fast.

