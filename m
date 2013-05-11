Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3EKB0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 21:26:25 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:55288 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab3EKB0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 21:26:23 -0400
Date: Sat, 11 May 2013 03:26:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86/sched/dynamic-ticks: Call new schedule_irq_disable()
 for scheduling in entry_64.S
Message-ID: <20130511012617.GD13340@somewhere>
References: <1368062480.7373.95.camel@gandalf.local.home>
 <20130510002203.GA2394@somewhere>
 <1368146829.7373.146.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368146829.7373.146.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 08:47:09PM -0400, Steven Rostedt wrote:
> On Fri, 2013-05-10 at 02:22 +0200, Frederic Weisbecker wrote:
> >  
> > > @@ -654,6 +653,7 @@ sysret_check:
> > >  	LOCKDEP_SYS_EXIT
> > >  	DISABLE_INTERRUPTS(CLBR_NONE)
> > >  	TRACE_IRQS_OFF
> > > +sysret_check_irqsoff:
> > >  	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
> > >  	andl %edi,%edx
> > >  	jnz  sysret_careful
> > > @@ -675,12 +675,10 @@ sysret_check:
> > >  sysret_careful:
> > >  	bt $TIF_NEED_RESCHED,%edx
> > >  	jnc sysret_signal
> > > -	TRACE_IRQS_ON
> > > -	ENABLE_INTERRUPTS(CLBR_NONE)
> > >  	pushq_cfi %rdi
> > > -	SCHEDULE_USER
> > > +	call schedule_irq_disabled
> > >  	popq_cfi %rdi
> > > -	jmp sysret_check
> > > +	jmp sysret_check_irqsoff
> > 
> > Don't we still want to call LOCKDEP_SYS_EXIT?, the previous
> > task scheduled might have taken some locks.
> 
> Sure, but would that still catch this? I thought LOCKDEP_SYS_EXIT just
> cared about going into user land if the current task had locks. Where it
> shouldn't here. And you are concerned about the previous task. Well, the
> scheduler should have caught that, as you shouldn't have any spin locks
> there. And it doesn't matter if the previous task had a mutex. The
> previous task is still in kernel space.

Ah you're right. But still the current task had several opportunities to take locks
since the context switch. It's still relevant to check that.

> > 
> > > +
> > > +	local_irq_enable();
> > > +	__schedule();
> > 
> > Are you sure it's fine to call __schedule() instead of schedule()?
> > I don't know much about the blk work to handle there but it may be
> > worth considering.
> 
> Note, this isn't a call to schedule that was made by normal kernel
> space. This is very much like a preemption. In fact, it is a preemption
> and my first patch used preempt_schedule_irq() instead, but as that's
> made for CONFIG_PREEMPT enabled, it seemed a bit hacky to take that out
> of that context.
> 
> This is only called when the task is being preempted. But because its
> going to user land, its OK. The blk code there is more worried about
> something that did some work, set itself to TASK_UNINTERRUPTIBLE and
> then called schedule() (think completions). That is, the blk code that
> needs to be submitted will be the code that wakes up this task.
> 
> We should never be in anything but TASK_RUNNING when going into user
> space.

Ok, I haven't checked the details of what that blk_ thing is doing so,
if it really doesn't care about any kind of preemption, that's ok.
