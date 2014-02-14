Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaBNLPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:15:54 -0500
Received: from relay.parallels.com ([195.214.232.42]:42695 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaBNLPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:15:53 -0500
Message-ID: <1392376569.5384.25.camel@tkhai>
Subject: Re: [PATCH] sched/core: Create new task with twice disabled
 preemption
From: Kirill Tkhai <ktkhai@parallels.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Kirill Tkhai <tkhai@yandex.ru>, Peter Zijlstra <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "Martin Schwidefsky" <schwidefsky@de.ibm.com>
Date: Fri, 14 Feb 2014 15:16:09 +0400
In-Reply-To: <20140214105255.GA10596@arm.com>
References: <1392306716.5384.3.camel@tkhai>
	 <20140213160013.GE6835@laptop.programming.kicks-ass.net>
	 <52FD01A6.8060404@yandex.ru> <20140214105255.GA10596@arm.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Птн, 14/02/2014 в 10:52 +0000, Catalin Marinas пишет:
> On Thu, Feb 13, 2014 at 09:32:22PM +0400, Kirill Tkhai wrote:
> > On 13.02.2014 20:00, Peter Zijlstra wrote:
> > > On Thu, Feb 13, 2014 at 07:51:56PM +0400, Kirill Tkhai wrote:
> > >> For archs without __ARCH_WANT_UNLOCKED_CTXSW set this means
> > >> that all newly created tasks execute finish_arch_post_lock_switch()
> > >> and post_schedule() with preemption enabled.
> > > 
> > > That's IA64 and MIPS; do they have a 'good' reason to use this?
> > 
> > It seems my description misleads reader, I'm sorry if so.
> > 
> > I mean all architectures *except* IA64 and MIPS. All, which
> > has no __ARCH_WANT_UNLOCKED_CTXSW defined.
> > 
> > IA64 and MIPS already have preempt_enable() in schedule_tail():
> > 
> > #ifdef __ARCH_WANT_UNLOCKED_CTXSW
> >         /* In this case, finish_task_switch does not reenable preemption */
> >         preempt_enable();
> > #endif
> > 
> > Their initial preemption is not decremented in finish_lock_switch().
> > 
> > So, we speak about x86, ARM64 etc.
> > 
> > Look at ARM64's finish_arch_post_lock_switch(). It looks a task
> > must to not be preempted between switch_mm() and this function.
> > But in case of new task this is possible.
> 
> We had a thread about this at the end of last year:
> 
> https://lkml.org/lkml/2013/11/15/82
>
> There is indeed a problem on arm64, something like this (and I think
> s390 also needs a fix):
> 
> 1. switch_mm() via check_and_switch_context() defers the actual mm
>    switch by setting TIF_SWITCH_MM
> 2. the context switch is considered 'done' by the kernel before
>    finish_arch_post_lock_switch() and therefore we can be preempted to a
>    new thread before finish_arch_post_lock_switch()
> 3. The new thread has the same mm as the preempted thread but we
>    actually missed the mm switching in finish_arch_post_lock_switch()
>    because TIF_SWITCH_MM is per thread rather than mm
> 
> > This is the problem I tried to solve. I don't know arm64, and I can't
> > say how it is serious.
> 
> Have you managed to reproduce this? I don't say it doesn't exist, but I
> want to make sure that any patch actually fixes it.

No, I have not tried. I found this place while analysing scheduler code.
But it seems with the RT technics suggested previous message it's quite
possible.

> So we have more solutions, one of the first two suitable for stable:
> 
> 1. Propagate the TIF_SWITCH_MM to the next thread (suggested by Martin)
> 2. Get rid of TIF_SWITCH_MM and use mm_cpumask for tracking (I already
>    have the patch, it just needs a lot more testing)
> 3. Re-write the ASID allocation algorithm to no longer require IPIs and
>    therefore drop finish_arch_post_lock_switch() (this can be done, so
>    pretty intrusive for stable)
> 4. Replace finish_arch_post_lock_switch() with finish_mm_switch() as per
>    Martin's patch and I think this would guarantee a call always, we can
>    move the mm switching from switch_mm() to finish_mm_switch() and no
>    need for flags to mark deferred mm switching
> 
> For arm64, we'll most likely go with 2 for stable and move to 3 shortly
> after, no need for other deferred mm switching.
> 

It's good, but one of architectures is a corner case. It seems to me
it's better to have the same enviroment/preemption for the first schedule
and for others.

This minimises the number of rare errors and this may help in the future.
The first schedule happens rare and it's tested worse.

Kirill

