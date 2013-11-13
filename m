Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab3KMQHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:07:22 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:42112 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab3KMQHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:07:18 -0500
Date: Wed, 13 Nov 2013 17:05:56 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched/mm: add finish_switch_mm function
Message-ID: <20131113170556.7e170e89@mschwide>
In-Reply-To: <20131113121909.GA18837@arm.com>
References: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
	<1384330574-18418-2-git-send-email-schwidefsky@de.ibm.com>
	<20131113114143.GJ21461@twins.programming.kicks-ass.net>
	<20131113121909.GA18837@arm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111316-4966-0000-0000-0000077EB40B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 12:19:09 +0000
Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Wed, Nov 13, 2013 at 11:41:43AM +0000, Peter Zijlstra wrote:
> > On Wed, Nov 13, 2013 at 09:16:13AM +0100, Martin Schwidefsky wrote:
> > > The switch_mm function is called with the task_lock and/or with
> > > request queue lock. Add finish_switch_mm to allow an architecture
> > > to execute some code after the mm has been switched but without
> > > any locks held. One use case is the s390 architecture which will
> > > use this to wait for the completion of TLB flush operations.
> 
> We have similar needs on arm and arm64 (full cache flushing where we
> want interrupts enable or some IPIs for TLB tagging synchronisation).

On s390 we need to wait for the completion of a TLB flush.

> > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > > index 1deccd7..89409cb 100644
> > > --- a/kernel/sched/core.c
> > > +++ b/kernel/sched/core.c
> > > @@ -32,7 +32,7 @@
> > >  #include <linux/init.h>
> > >  #include <linux/uaccess.h>
> > >  #include <linux/highmem.h>
> > > -#include <asm/mmu_context.h>
> > > +#include <linux/mmu_context.h>
> > >  #include <linux/interrupt.h>
> > >  #include <linux/capability.h>
> > >  #include <linux/completion.h>
> > > @@ -1996,6 +1996,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
> > >  	perf_event_task_sched_in(prev, current);
> > >  	finish_lock_switch(rq, prev);
> > >  	finish_arch_post_lock_switch();
> > > +	finish_switch_mm(current->mm, current);
> 
> This could use the same hook.

Yes.
 
> > >  
> > >  	fire_sched_in_preempt_notifiers(current);
> > >  	if (mm)
> > > @@ -4140,8 +4141,10 @@ void idle_task_exit(void)
> > >  
> > >  	BUG_ON(cpu_online(smp_processor_id()));
> > >  
> > > -	if (mm != &init_mm)
> > > +	if (mm != &init_mm) {
> > >  		switch_mm(mm, &init_mm, current);
> > > +		finish_switch_mm(&init_mm, current);
> > > +	}
> > >  	mmdrop(mm);
> > >  }
> 
> Here finish_switch_mm() is called in the same context with switch_mm().
> What we have on ARM via switch_mm() is to check for irqs_disabled() and
> if yes, defer the actual switching via a flag until the
> finish_arch_post_lock_switch() hook. But on ARM we only cared about the
> interrupts being enabled.

The guarantee s390 needs is that the rq-lock is not taken. What I have
seen with the wait loop in switch_mm is a dead lock because one CPU #0
was looping in switch_mm to wait for the TLB flush of another CPU #1.
CPU #1 got an interrupt that tried to wake-up a task which happened to
be on the run-queue of CPU #0.

> > > diff --git a/mm/mmu_context.c b/mm/mmu_context.c
> > > index 8a8cd02..11b3d47 100644
> > > --- a/mm/mmu_context.c
> > > +++ b/mm/mmu_context.c
> > > @@ -8,8 +8,6 @@
> > >  #include <linux/export.h>
> > >  #include <linux/sched.h>
> > >  
> > > -#include <asm/mmu_context.h>
> > > -
> > >  /*
> > >   * use_mm
> > >   *	Makes the calling kernel thread take on the specified
> > > @@ -31,6 +29,7 @@ void use_mm(struct mm_struct *mm)
> > >  	tsk->mm = mm;
> > >  	switch_mm(active_mm, mm, tsk);
> > >  	task_unlock(tsk);
> > > +	finish_switch_mm(mm, tsk);
> 
> As above, for ARM we only care about interrupts being enabled, so it
> didn't require a hook.
> 
> Is s390 switch_mm() ok with only interrupts being enabled but some locks
> held?

Interrupts on/off is not the problem for s390. 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

