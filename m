Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaBQMzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 07:55:39 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:33860 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaBQMzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 07:55:38 -0500
Date: Mon, 17 Feb 2014 13:55:32 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Peter Zijlstra <peterz@infradead.org>,
        Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched/core: Create new task with twice disabled
 preemption
Message-ID: <20140217135532.372ef91e@mschwide>
In-Reply-To: <20140217104005.GB17487@arm.com>
References: <1392306716.5384.3.camel@tkhai>
	<20140213160013.GE6835@laptop.programming.kicks-ass.net>
	<52FD01A6.8060404@yandex.ru>
	<20140214105255.GA10596@arm.com>
	<20140217103738.7369d84b@mschwide>
	<20140217104005.GB17487@arm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021712-1948-0000-0000-000007D5EFFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014 10:40:06 +0000
Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Mon, Feb 17, 2014 at 09:37:38AM +0000, Martin Schwidefsky wrote:
> > On Fri, 14 Feb 2014 10:52:55 +0000
> > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > 
> > > On Thu, Feb 13, 2014 at 09:32:22PM +0400, Kirill Tkhai wrote:
> > > > On 13.02.2014 20:00, Peter Zijlstra wrote:
> > > > > On Thu, Feb 13, 2014 at 07:51:56PM +0400, Kirill Tkhai wrote:
> > > > >> For archs without __ARCH_WANT_UNLOCKED_CTXSW set this means
> > > > >> that all newly created tasks execute finish_arch_post_lock_switch()
> > > > >> and post_schedule() with preemption enabled.
> > > > > 
> > > > > That's IA64 and MIPS; do they have a 'good' reason to use this?
> > > > 
> > > > It seems my description misleads reader, I'm sorry if so.
> > > > 
> > > > I mean all architectures *except* IA64 and MIPS. All, which
> > > > has no __ARCH_WANT_UNLOCKED_CTXSW defined.
> > > > 
> > > > IA64 and MIPS already have preempt_enable() in schedule_tail():
> > > > 
> > > > #ifdef __ARCH_WANT_UNLOCKED_CTXSW
> > > >         /* In this case, finish_task_switch does not reenable preemption */
> > > >         preempt_enable();
> > > > #endif
> > > > 
> > > > Their initial preemption is not decremented in finish_lock_switch().
> > > > 
> > > > So, we speak about x86, ARM64 etc.
> > > > 
> > > > Look at ARM64's finish_arch_post_lock_switch(). It looks a task
> > > > must to not be preempted between switch_mm() and this function.
> > > > But in case of new task this is possible.
> > > 
> > > We had a thread about this at the end of last year:
> > > 
> > > https://lkml.org/lkml/2013/11/15/82
> > > 
> > > There is indeed a problem on arm64, something like this (and I think
> > > s390 also needs a fix):
> > > 
> > > 1. switch_mm() via check_and_switch_context() defers the actual mm
> > >    switch by setting TIF_SWITCH_MM
> > > 2. the context switch is considered 'done' by the kernel before
> > >    finish_arch_post_lock_switch() and therefore we can be preempted to a
> > >    new thread before finish_arch_post_lock_switch()
> > > 3. The new thread has the same mm as the preempted thread but we
> > >    actually missed the mm switching in finish_arch_post_lock_switch()
> > >    because TIF_SWITCH_MM is per thread rather than mm
> > >
> > > > This is the problem I tried to solve. I don't know arm64, and I can't
> > > > say how it is serious.
> > > 
> > > Have you managed to reproduce this? I don't say it doesn't exist, but I
> > > want to make sure that any patch actually fixes it.
> > > 
> > > So we have more solutions, one of the first two suitable for stable:
> > > 
> > > 1. Propagate the TIF_SWITCH_MM to the next thread (suggested by Martin)
> > 
> > This is what I put in place for s390 but with the name TIF_TLB_WAIT instead
> > of TIF_SWITCH_MM. I took the liberty to add the code to the features branch
> > of the linux-s390 tree including the common code change that is necessary:
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/s390/linux.git/commit/?h=features&id=09ddfb4d5602095aad04eada8bc8df59e873a6ef
> 
> I don't see a problem with additional calls to
> finish_arch_post_lock_switch() on arm and arm64 but I would have done
> this in more than one step:
> 
> 1. Introduce finish_switch_mm()
> 2. Convert arm and arm64 to finish_switch_mm() (which means we no longer
>    check whether the interrupts are disabled in switch_mm() to defer the
>    switch
> 3. Remove generic finish_arch_post_lock_switch() because its
>    functionality has been entirely replaced by finish_switch_mm()
> 
> Anyway, we probably end up in the same place anyway.

Peter pointed me to finish_arch_post_lock switch as a replacement for
finish_switch_mm. They are basically doing the same thing and I do not care
too much how the function is called. finish_arch_post_lock_switch is ok from
my point of view. If you want to change it be aware of the header file hell
you are getting into. 
 
> But does this solve the problem of being preempted between switch_mm()
> and finish_arch_post_lock_switch()? I guess we still need the same
> guarantees that both switch_mm() and the hook happen on the same CPU.

By itself no, I do not think so. finish_arch_post_lock_switch is supposed
to be called with no locks held, so preemption should be enabled as well.

> > https://git.kernel.org/cgit/linux/kernel/git/s390/linux.git/commit/?h=features&id=525d65f8f66ac29136ba6d2336f5a73b038701e2
> 
> That's a way to solve it for s390. I don't particularly like
> transferring the mm switch pending TIF flag to the next task but I think
> it does the job (just personal preference).

It gets the job done. The alternative is another per-cpu bitmap for each
mm. I prefer the transfer of the TIF flag to the next task, we do that
for the machine check flag TIF_MCCK_PENDING anyway. One more bit to transfer
does not hurt.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

