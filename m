Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaBQKkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:40:20 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:32178 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751818AbaBQKkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:40:13 -0500
Date: Mon, 17 Feb 2014 10:40:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Peter Zijlstra <peterz@infradead.org>,
        Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched/core: Create new task with twice disabled
 preemption
Message-ID: <20140217104005.GB17487@arm.com>
References: <1392306716.5384.3.camel@tkhai>
 <20140213160013.GE6835@laptop.programming.kicks-ass.net>
 <52FD01A6.8060404@yandex.ru>
 <20140214105255.GA10596@arm.com>
 <20140217103738.7369d84b@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217103738.7369d84b@mschwide>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 09:37:38AM +0000, Martin Schwidefsky wrote:
> On Fri, 14 Feb 2014 10:52:55 +0000
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > On Thu, Feb 13, 2014 at 09:32:22PM +0400, Kirill Tkhai wrote:
> > > On 13.02.2014 20:00, Peter Zijlstra wrote:
> > > > On Thu, Feb 13, 2014 at 07:51:56PM +0400, Kirill Tkhai wrote:
> > > >> For archs without __ARCH_WANT_UNLOCKED_CTXSW set this means
> > > >> that all newly created tasks execute finish_arch_post_lock_switch()
> > > >> and post_schedule() with preemption enabled.
> > > > 
> > > > That's IA64 and MIPS; do they have a 'good' reason to use this?
> > > 
> > > It seems my description misleads reader, I'm sorry if so.
> > > 
> > > I mean all architectures *except* IA64 and MIPS. All, which
> > > has no __ARCH_WANT_UNLOCKED_CTXSW defined.
> > > 
> > > IA64 and MIPS already have preempt_enable() in schedule_tail():
> > > 
> > > #ifdef __ARCH_WANT_UNLOCKED_CTXSW
> > >         /* In this case, finish_task_switch does not reenable preemption */
> > >         preempt_enable();
> > > #endif
> > > 
> > > Their initial preemption is not decremented in finish_lock_switch().
> > > 
> > > So, we speak about x86, ARM64 etc.
> > > 
> > > Look at ARM64's finish_arch_post_lock_switch(). It looks a task
> > > must to not be preempted between switch_mm() and this function.
> > > But in case of new task this is possible.
> > 
> > We had a thread about this at the end of last year:
> > 
> > https://lkml.org/lkml/2013/11/15/82
> > 
> > There is indeed a problem on arm64, something like this (and I think
> > s390 also needs a fix):
> > 
> > 1. switch_mm() via check_and_switch_context() defers the actual mm
> >    switch by setting TIF_SWITCH_MM
> > 2. the context switch is considered 'done' by the kernel before
> >    finish_arch_post_lock_switch() and therefore we can be preempted to a
> >    new thread before finish_arch_post_lock_switch()
> > 3. The new thread has the same mm as the preempted thread but we
> >    actually missed the mm switching in finish_arch_post_lock_switch()
> >    because TIF_SWITCH_MM is per thread rather than mm
> >
> > > This is the problem I tried to solve. I don't know arm64, and I can't
> > > say how it is serious.
> > 
> > Have you managed to reproduce this? I don't say it doesn't exist, but I
> > want to make sure that any patch actually fixes it.
> > 
> > So we have more solutions, one of the first two suitable for stable:
> > 
> > 1. Propagate the TIF_SWITCH_MM to the next thread (suggested by Martin)
> 
> This is what I put in place for s390 but with the name TIF_TLB_WAIT instead
> of TIF_SWITCH_MM. I took the liberty to add the code to the features branch
> of the linux-s390 tree including the common code change that is necessary:
> 
> https://git.kernel.org/cgit/linux/kernel/git/s390/linux.git/commit/?h=features&id=09ddfb4d5602095aad04eada8bc8df59e873a6ef

I don't see a problem with additional calls to
finish_arch_post_lock_switch() on arm and arm64 but I would have done
this in more than one step:

1. Introduce finish_switch_mm()
2. Convert arm and arm64 to finish_switch_mm() (which means we no longer
   check whether the interrupts are disabled in switch_mm() to defer the
   switch
3. Remove generic finish_arch_post_lock_switch() because its
   functionality has been entirely replaced by finish_switch_mm()

Anyway, we probably end up in the same place anyway.

But does this solve the problem of being preempted between switch_mm()
and finish_arch_post_lock_switch()? I guess we still need the same
guarantees that both switch_mm() and the hook happen on the same CPU.

> https://git.kernel.org/cgit/linux/kernel/git/s390/linux.git/commit/?h=features&id=525d65f8f66ac29136ba6d2336f5a73b038701e2

That's a way to solve it for s390. I don't particularly like
transferring the mm switch pending TIF flag to the next task but I think
it does the job (just personal preference).

-- 
Catalin
