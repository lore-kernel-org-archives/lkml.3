Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3KNIA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:00:27 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:55801 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3KNIAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:00:24 -0500
Date: Thu, 14 Nov 2013 09:00:10 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched/mm: add finish_switch_mm function
Message-ID: <20131114090010.2dc05610@mschwide>
In-Reply-To: <20131113170358.GG18837@arm.com>
References: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
	<1384330574-18418-2-git-send-email-schwidefsky@de.ibm.com>
	<20131113114143.GJ21461@twins.programming.kicks-ass.net>
	<20131113121909.GA18837@arm.com>
	<20131113170556.7e170e89@mschwide>
	<20131113170358.GG18837@arm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111408-8372-0000-0000-000007C46A2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 17:03:58 +0000
Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Wed, Nov 13, 2013 at 04:05:56PM +0000, Martin Schwidefsky wrote:
> > On Wed, 13 Nov 2013 12:19:09 +0000
> > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Wed, Nov 13, 2013 at 11:41:43AM +0000, Peter Zijlstra wrote:
> > > > On Wed, Nov 13, 2013 at 09:16:13AM +0100, Martin Schwidefsky wrote:
> > > > >  	fire_sched_in_preempt_notifiers(current);
> > > > >  	if (mm)
> > > > > @@ -4140,8 +4141,10 @@ void idle_task_exit(void)
> > > > >  
> > > > >  	BUG_ON(cpu_online(smp_processor_id()));
> > > > >  
> > > > > -	if (mm != &init_mm)
> > > > > +	if (mm != &init_mm) {
> > > > >  		switch_mm(mm, &init_mm, current);
> > > > > +		finish_switch_mm(&init_mm, current);
> > > > > +	}
> > > > >  	mmdrop(mm);
> > > > >  }
> > > 
> > > Here finish_switch_mm() is called in the same context with switch_mm().
> > > What we have on ARM via switch_mm() is to check for irqs_disabled() and
> > > if yes, defer the actual switching via a flag until the
> > > finish_arch_post_lock_switch() hook. But on ARM we only cared about the
> > > interrupts being enabled.
> > 
> > The guarantee s390 needs is that the rq-lock is not taken. What I have
> > seen with the wait loop in switch_mm is a dead lock because one CPU #0
> > was looping in switch_mm to wait for the TLB flush of another CPU #1.
> > CPU #1 got an interrupt that tried to wake-up a task which happened to
> > be on the run-queue of CPU #0.
> 
> I'm not familiar with the s390 code, so how's the waiting done? Is it
> part of an on_each_cpu() call (that's what I got from smp_ptlb_all)?
 
Ok, the long explanation: the requirement of the architecture is that a
PTE need to be modified in a coordinated fashion if there is the possibility
that another CPU is using the mm at the same time. Coordinated means that
the modification has to be done with specific instructions, IPTE and IDTE.
These instructions make sure that other CPUs can complete instructions
that use the PTE before the PTE is made invalid and the associated TLB
is flushed.

Problem is that these instructions are slow, basically they do on_each_cpu
under the hood. Therefore the code tries to batch PTE operations. For each
PTE the code decides if it can do a batched/lazy PTE update or if the
expensive way with IPTE is required. Now if the decision to use a batched
PTE update has just been made with the PTE still valid this can race with
another CPU attaching the mm with switch_mm(). Until the first CPU is done
with PTE modification the second CPU may not use the mm yet. 

The coordination between CPU is done with the mm->context.attach_count.
The upper 16 bit have a flush-counter, the lower 16 bit an attach counter.
Each attacher of an mm increases the lower 16 bit, this is used by the
flusher to decide between lazy and direct flushing. Each flusher increases
the upper 16 bit while it is in the critical phase of the update. The
attacher uses this to loop until the flush counter is zero again. And
this wait loop may not hold any locks, otherwise it can dead-lock.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

