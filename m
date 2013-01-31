Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3AaHaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 02:30:19 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:50689 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab3AaHaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 02:30:16 -0500
Message-ID: <510A1D7A.3050408@linux.vnet.ibm.com>
Date: Thu, 31 Jan 2013 15:30:02 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de
Subject: Re: [RFC 2/2] sched/fair: prefer a CPU in the "lowest" idle state
References: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de> <1359580757-4121-3-git-send-email-bigeasy@linutronix.de> <5109D313.1020409@linux.vnet.ibm.com>	<8738xiue31.fsf@sejong.aot.lge.com> <510A1198.2070803@linux.vnet.ibm.com> <87txpxu9cx.fsf@sejong.aot.lge.com>
In-Reply-To: <87txpxu9cx.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13013107-5816-0000-0000-0000067E216D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 02:58 PM, Namhyung Kim wrote:
> On Thu, 31 Jan 2013 14:39:20 +0800, Michael Wang wrote:
>> On 01/31/2013 01:16 PM, Namhyung Kim wrote:
>>> Anyway, I have an idea with this in mind.  It's like adding a new "idle
>>> load" to each idle cpu rather than special casing the idle cpus like
>>> above.  IOW an idle cpu will get very small load weight depends on how
>>> deep it's slept so that it can be compared to other cpus in a same way
>>> but we can find prefered (lowest load) cpu among the idle cpus.
>>>
>>> The simple way I can think of is adding idle_level to a rq load in
>>> weighted_cpuload():
>>>
>>> static unsigned long weighted_cpuload(const int cpu)
>>> {
>>> 	return cpu_rq(cpu)->load.weight + cpuidle_get_state(cpu);
>>> }
>>
>> Hmm... then we don't need changes in find_idlest_cpu(), just compare the
>> load as before, but it works only when the appendix state value is
>> smaller than the lowest load of one task, which is 15 currently, I'm not
>> sure whether we have the promise...
> 
> You said about a nice 19 process, right?  But I found that SCHED_IDLE
> task will have weight of 3. :(
> 
>   #define WEIGHT_IDLEPRIO                3

I missed that policy :)

> 
> 
> But AFAIK the number of states in cpuidle is usually less than 10 so maybe
> we can change the weight then, but there's no promise...

And I just got another case we should take care:

	group 0		cpu 0			cpu 1
			power index 8		power index 8


	group 1		cpu 2			cpu 3
			power index 0		load 15

so load of group 0 is 16 and group 1 is 15, but group 0 is better...

Regards,
Michael Wang

> 
> Thanks,
> Namhyung
> 

