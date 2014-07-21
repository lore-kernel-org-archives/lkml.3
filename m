Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbaGUQ4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:56:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51068 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679AbaGUQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:56:37 -0400
X-IronPort-AV: E=Sophos;i="5.01,702,1400025600"; 
   d="scan'208";a="154741398"
Message-ID: <53CD4644.4010907@citrix.com>
Date: Mon, 21 Jul 2014 17:56:36 +0100
From: Jonathan Davies <jonathan.davies@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH RFC] sched/core: Make idle_cpu return 0 if doing softirq
 work
References: <1405688346-7349-1-git-send-email-jonathan.davies@citrix.com> <20140718140821.GD20603@laptop.programming.kicks-ass.net>
In-Reply-To: <20140718140821.GD20603@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18/07/14 15:08, Peter Zijlstra wrote:
> On Fri, Jul 18, 2014 at 01:59:06PM +0100, Jonathan Davies wrote:
>> The current implementation of idle_cpu only considers tasks that might be in the
>> CPU's runqueue. If there's nothing in the specified CPU's runqueue, it will
>> return 1. But if the CPU is doing work in the softirq context, it is wrong for
>> idle_cpu to return 1. This patch makes it return 0.
>>
>> I observed this to be a problem with a device driver kicking a kthread by
>> executing wake_up from softirq context. The Completely Fair Scheduler's
>> select_task_rq_fair was looking for an "idle sibling" of the CPU executing it by
>> calling select_idle_sibling, passing the executing CPU as the 'target'
>> parameter. The first thing that select_idle_sibling does is to check whether the
>> 'target' CPU is idle, using idle_cpu, and to return that CPU if so. Despite the
>> executing CPU being busy in softirq context, idle_cpu was returning 1, meaning
>> that the scheduler would consistently try to run the kthread on the same CPU as
>> the kick came from. Given that the softirq work was on-going, this led to a
>> multi-millisecond delay before the scheduler eventually realised it should
>> migrate the kthread to a different CPU.
>
> If your softirq takes _that_ long its broken anyhow.

Modern NICs can sustain 40 Gb/s of traffic. For network device drivers 
that use NAPI, polling is done in softirq context. At this data-rate, 
the per-packet processing overhead means means that a lot of CPU time is 
spent in softirq.

(CCing Dave and Eric for their thoughts about long-running softirq due 
to NAPI. The example I gave above was of xen-netback sending data to 
another virtual interface at a high rate.)

>> A solution to this problem would be to make idle_cpu return 0 when the CPU is
>> running in softirq context. I haven't got a patch for that because I couldn't
>> find an easy way of querying whether an arbitrary CPU is doing this. (Perhaps I
>> should look at the per-CPU softirq_work_list[]...?)
>
> in_serving_softirq()?

That's probably more appropriate, but only tells us about the currently 
executing CPU, rather than what other CPUs are doing.

>> Instead, the following patch is a partial solution, only handling the case when
>> the currently-executing CPU is in softirq context. This was sufficient to solve
>> the problem I observed.
>
> NAK, IRQ and SoftIRQ are outside of what the scheduler can control, so
> for its purpose the CPU is indeed idle.

The scheduler can't control those things, but surely it wants to make 
the best possible placement for the things it can control? So it seems 
odd to me that it would ignore relevant information about the resources 
it can use. As I observed, it leads to pathological behaviour, and is 
easily fixed.

Jonathan
