Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3EJArN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 20:47:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab3EJArM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 20:47:12 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=p2Mg_QFlwKQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=QQEAQuFRF4kA:10 a=auFbS-VuTNY3QOpuIb4A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368146829.7373.146.camel@gandalf.local.home>
Subject: Re: [PATCH] x86/sched/dynamic-ticks: Call new
 schedule_irq_disable() for scheduling in entry_64.S
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 09 May 2013 20:47:09 -0400
In-Reply-To: <20130510002203.GA2394@somewhere>
References: <1368062480.7373.95.camel@gandalf.local.home>
	 <20130510002203.GA2394@somewhere>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-10 at 02:22 +0200, Frederic Weisbecker wrote:
>  
> > @@ -654,6 +653,7 @@ sysret_check:
> >  	LOCKDEP_SYS_EXIT
> >  	DISABLE_INTERRUPTS(CLBR_NONE)
> >  	TRACE_IRQS_OFF
> > +sysret_check_irqsoff:
> >  	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
> >  	andl %edi,%edx
> >  	jnz  sysret_careful
> > @@ -675,12 +675,10 @@ sysret_check:
> >  sysret_careful:
> >  	bt $TIF_NEED_RESCHED,%edx
> >  	jnc sysret_signal
> > -	TRACE_IRQS_ON
> > -	ENABLE_INTERRUPTS(CLBR_NONE)
> >  	pushq_cfi %rdi
> > -	SCHEDULE_USER
> > +	call schedule_irq_disabled
> >  	popq_cfi %rdi
> > -	jmp sysret_check
> > +	jmp sysret_check_irqsoff
> 
> Don't we still want to call LOCKDEP_SYS_EXIT?, the previous
> task scheduled might have taken some locks.

Sure, but would that still catch this? I thought LOCKDEP_SYS_EXIT just
cared about going into user land if the current task had locks. Where it
shouldn't here. And you are concerned about the previous task. Well, the
scheduler should have caught that, as you shouldn't have any spin locks
there. And it doesn't matter if the previous task had a mutex. The
previous task is still in kernel space.

>  
> > +/*
> > + * this is the entry point to schedule() from kernel irq off context.
> > + * Note, that this is called and return with irqs disabled. This will
> > + * protect us against recursive calling from irq.
> > + */
> > +asmlinkage void __sched schedule_irq_disabled(void)
> > +{
> > +	enum ctx_state prev_state;
> > +
> > +	prev_state = exception_enter();
> 
> So why have you turned user_enter to exception_enter?
> Is it to make it work anywhere and not just preemption on
> user resume time?

Pretty much. I just copied the way preempt_schedule_irq() did this.

> 
> > +
> > +	local_irq_enable();
> > +	__schedule();
> 
> Are you sure it's fine to call __schedule() instead of schedule()?
> I don't know much about the blk work to handle there but it may be
> worth considering.

Note, this isn't a call to schedule that was made by normal kernel
space. This is very much like a preemption. In fact, it is a preemption
and my first patch used preempt_schedule_irq() instead, but as that's
made for CONFIG_PREEMPT enabled, it seemed a bit hacky to take that out
of that context.

This is only called when the task is being preempted. But because its
going to user land, its OK. The blk code there is more worried about
something that did some work, set itself to TASK_UNINTERRUPTIBLE and
then called schedule() (think completions). That is, the blk code that
needs to be submitted will be the code that wakes up this task.

We should never be in anything but TASK_RUNNING when going into user
space.

> 
> > +	local_irq_disable();
> > +
> > +	exception_exit(prev_state);
> > +}
> 
> The patch looks pretty good otherwise.

Thanks!

-- Steve


