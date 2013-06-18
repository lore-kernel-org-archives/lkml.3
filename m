Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685Ab3FRSmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:42:19 -0400
Received: from mail.lang.hm ([64.81.33.126]:46220 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933480Ab3FRSmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:42:17 -0400
Date: Tue, 18 Jun 2013 10:39:27 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Morten Rasmussen <morten.rasmussen@arm.com>
cc: Ingo Molnar <mingo@kernel.org>, "alex.shi@intel.com" <alex.shi@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: power-efficient scheduling design
In-Reply-To: <20130618102324.GF5460@e103034-lin>
Message-ID: <alpine.DEB.2.02.1306181032160.9258@nftneq.ynat.uz>
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com> <20130614160522.GG32728@e103034-lin> <alpine.DEB.2.02.1306171809200.9258@nftneq.ynat.uz> <20130618102324.GF5460@e103034-lin>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Morten Rasmussen wrote:

>> I don't think that you are passing nearly enough information around.
>>
>> A fairly simple example
>>
>> take a relatively modern 4-core system with turbo mode where speed controls
>> affect two cores at a time (I don't know the details of the available CPUs to
>> know if this is an exact fit to any existing system, but I think it's a
>> reasonable fit)
>>
>> If you are running with a loadave of 2, should you power down 2 cores and run
>> the other two in turbo mode, power down 2 cores and not increase the speed, or
>> leave all 4 cores running as is.
>>
>> Depending on the mix of processes, I could see any one of the three being the
>> right answer.
>>
>> If you have a process that's maxing out it's cpu time on one core, going to
>> turbo mode is the right thing as the other processes should fit on the other
>> core and that process will use more CPU (theoretically getting done sooner)
>>
>> If no process is close to maxing out the core, then if you are in power saving
>> mode, you probably want to shut down two cores and run everything on the other
>> two
>>
>> If you only have two processes eating almost all your CPU time, going to two
>> cores is probably the right thing to do.
>>
>> If you have more processes, each eating a little bit of time, then continuing
>> to run on all four cores uses more cache, and could let all of the tasks finish
>> faster.
>>
>>
>> So, how is the Power Scheduler going to get this level of information?
>>
>> It doesn't seem reasonable to either pass this much data around, or to try and
>> give two independant tools access to the same raw data (since that data is so
>> tied to the internal details of the scheduler). If we are talking two parts of
>> the same thing, then it's perfectly legitimate to have this sort of intimate
>> knowledge of the internal data structures.
>
> I realize that my description is not very clear about this point. Total
> load is clearly not enough information for the power scheduler to take
> any reasonable decisions. By current load, I mean per-cpu load, number
> of tasks, and possibly more task statistics. Enough information to
> determine the best use of the system cpus.
>
> As stated in my previous reply, this is not the ultimate design. It
> expect to have many design iterations. If it turns out that it doesn't
> make sense to have a separate power scheduler, then we should merge
> them. I just propose to divide the design into manageable components. A
> unified design covering the scheduler, two other policy frameworks, and
> new policies is too complex in my opinion.
>
> The power scheduler may be viewed as an external extension to the
> periodic scheduler load balance. I don't see a major problem in
> accessing raw data in the scheduler. The power scheduler will live in
> sched/power.c. In a unified solution where you put everything into
> sched/fair.c you would still need access to the same raw data to make
> the right power scheduling decisions. By having the power scheduler
> separately we just attempt to minimize the entanglement.

Why insist on this being treated as an external component that you have to pass 
messages to?

If you allow it to be combined, then it can lookup the info it needs rather than 
trying to define an API between the two that accounts for everything that you 
need to know (now and in the future)

This will mean that as the internals of one change it will affect the internals 
of the other, but it seems like this is far more likely to be successful.

If you have hundreds or thousands of processes, it's bad enough to lookup the 
data directly, but trying to marshal the infromation to send it to a separate 
component seems counterproductive.

David Lang
