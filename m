Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaBMRps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:45:48 -0500
Received: from forward8l.mail.yandex.net ([84.201.143.141]:37125 "EHLO
	forward8l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaBMRpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:45:36 -0500
X-Greylist: delayed 630 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2014 12:45:35 EST
X-Yandex-Uniq: e9160fff-4711-4362-99a5-5a7667138b99
Authentication-Results: smtp12.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <52FD01A6.8060404@yandex.ru>
Date: Thu, 13 Feb 2014 21:32:22 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched/core: Create new task with twice disabled preemption
References: <1392306716.5384.3.camel@tkhai> <20140213160013.GE6835@laptop.programming.kicks-ass.net>
In-Reply-To: <20140213160013.GE6835@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.02.2014 20:00, Peter Zijlstra wrote:
> On Thu, Feb 13, 2014 at 07:51:56PM +0400, Kirill Tkhai wrote:
>> For archs without __ARCH_WANT_UNLOCKED_CTXSW set this means
>> that all newly created tasks execute finish_arch_post_lock_switch()
>> and post_schedule() with preemption enabled.
> 
> That's IA64 and MIPS; do they have a 'good' reason to use this?

It seems my description misleads reader, I'm sorry if so.

I mean all architectures *except* IA64 and MIPS. All, which
has no __ARCH_WANT_UNLOCKED_CTXSW defined.

IA64 and MIPS already have preempt_enable() in schedule_tail():

#ifdef __ARCH_WANT_UNLOCKED_CTXSW
        /* In this case, finish_task_switch does not reenable preemption */
        preempt_enable();
#endif

Their initial preemption is not decremented in finish_lock_switch().

So, we speak about x86, ARM64 etc.

Look at ARM64's finish_arch_post_lock_switch(). It looks a task
must to not be preempted between switch_mm() and this function.
But in case of new task this is possible.

Example:
RT thread p0 and RT thread p1 are on shared mm. System has 2 cpu.

p0 is bound to CPU0.
p1 is bound to CPU1.

p1 has set timer and it is sleeping.

p0 create fair thread f. Task f wakes on CPU1.

When f is between raw_spin_unlock_irq() and
finish_arch_post_lock_switch(), preemption is enabled.
In this moment the process p1 is waking on CPU1.

For p1 the check

if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next)) || prev != next)

in switch_mm() is not passed, because mm is the same. So, later
we do not do cpu_switch_mm() in finish_arch_post_lock_switch()
and we just go to userspace.

This is the problem I tried to solve. I don't know arm64, and I can't
say how it is serious.

But it looks the place is buggy.

Kirill

> That is; the alternative is to fix those two archs and remove the
> __ARCH_WANT_UNLOCKED_CTXSW clutter alltogether; which seems like a big
> win to me.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

