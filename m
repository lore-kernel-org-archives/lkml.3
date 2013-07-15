Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab3GOWwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:52:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:19194 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758326Ab3GOWwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:52:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,672,1367996400"; 
   d="scan'208";a="331831318"
Message-ID: <51E47D30.5030203@linux.intel.com>
Date: Mon, 15 Jul 2013 15:52:32 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        alex.shi@intel.com, efault@gmx.de, pjt@google.com, len.brown@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <20130713064909.GW25631@dyad.programming.kicks-ass.net> <51E166C8.3000902@linux.intel.com> <20130715195914.GC23818@dyad.programming.kicks-ass.net> <51E45E8B.705@linux.intel.com> <20130715210650.GF23818@dyad.programming.kicks-ass.net> <20130715211230.GG23818@dyad.programming.kicks-ass.net>
In-Reply-To: <20130715211230.GG23818@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/2013 2:12 PM, Peter Zijlstra wrote:
> On Mon, Jul 15, 2013 at 11:06:50PM +0200, Peter Zijlstra wrote:
>> OK, but isn't that part of why the micro controller might not make you go
>> faster even if you do program a higher P state?
>>
>> But yes, I understand this issue in the 'traditional' cpufreq sense. There's no
>> point in ramping the speed if all you do is stall more.
>>
>> But I was under the impression the 'hardware' was doing this. If not then we
>> need the whole go-faster and go-slower thing and places to call them and means
>> to determine to call them etc.
>
>
> So with the scheduler measuring cpu utilization we could say to go-faster when
> u>0.8 and go-slower when u<0.75 or so. Lacking any better metrics like the
> stall stuff etc.
>
> So I understand that ondemand spends quite a lot of time 'sampling' what the
>  system does while the scheduler mostly already knows this.

yeah ondemand does this, but ondemand is actually a pretty bad governor.
not because of the sampling, but because of its algorithm.

if you look at what the ondemand algorithm tries to do, it's trying to
manage the cpu "frequency" primarily for when the system is idle.
Ten to twelve years ago, this was actually important and it does a decent
job on that.

HOWEVER, on modern CPUs, even many of the ARM ones, the frequency
when you're idle is zero anyway regardless of what you as OS ask for.

And when Linux went tickless, ondemand went to deferred timers, which make it
even worse.

btw technically ondemand does not sample things, you may (or may not) understand
what it does.
Every 10 (or 100) milliseconds, ondemand makes a new P state decision.
It does this by asking the scheduler the time used, does a delta and
ends up at a utilization %age which then goes into a formula.
It's not that ondemand samples inbetween decision moments to see if the system
is busy or not; the microaccounting that the scheduler does is used instead,
and only at decision moments.


