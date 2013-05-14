Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab3ENJoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:44:34 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38510 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab3ENJoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:44:32 -0400
Message-ID: <1368524655.2618.100.camel@ThinkPad-T5421>
Subject: Re: [PATCH 1/3] x86/sched/context_tracking: Call new
 schedule_preempt_user() from entry_64.S
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 14 May 2013 17:44:15 +0800
In-Reply-To: <1368457419.6828.31.camel@gandalf.local.home>
References: <20130510211225.594959788@goodmis.org>
	 <20130510211825.341015861@goodmis.org>
	 <1368438990.2618.55.camel@ThinkPad-T5421>
	 <1368457419.6828.31.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051409-7014-0000-0000-000003048A84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 11:03 -0400, Steven Rostedt wrote:
> On Mon, 2013-05-13 at 17:56 +0800, Li Zhong wrote:
> 
> > > All this before schedule_user() was able to call user_exit() and take us
> > > out of dynamic tick user context.
> > 
> > Maybe we could just disable function trace for schedule_user()? 
> > 
> > It seems that function trace might use RCU, at least in __schedule()
> > when calling preempt_enable(), and if preemption is really enabled. 
> 
> There is a small use of rcu scheduling (preempt disable/enable) in
> function tracing. One is for perf and dynamic call traces and some hash
> code (multiple users of the function tracer). But those are the unique
> cases, and I really do not want to remove this function just for the non
> common case. Function tracing has proven extremely useful in debugging
> RCU and context tracking. By adding notrace, it's a lost cause.

OK, so it seems a bad idea to disable trace here. 

However, as schedule is traced, so we might get something like 
.schedule <-.schedule_user to know that schedule_user is called?

> 
> Not to mention, adding trace_printk() there will break it too, and that
> does not use any RCU but still disables preemption because the writing
> to the ring buffer requires staying on the same CPU.
> 
I guess you mean the preemption enable after buffer written might cause
a task migration, and break the pair of user_enter/user_exit?

Then how about adding trace_printk() after user_exit() there?

> > 
> > user_exit() is used to allow RCU usage after that (with rcu_user_exit).
> > RCU usage is not allowed before that because cpu is in user eqs. And if
> > function trace needs use RCU, then it seems user_exit() itself or its
> > callers couldn't be function traced.
> 
> And it can't be debugged either.
> 
> I can probably black list those functions manually, such that only the
> main function tracer can trace it, all others will not. In otherwords, I
> can have it such that function tracer will not trace those functions for
> perf, dynamic function tracers, or anything that requires changing the
> function list.

I'm totally lost. Need some more time to read the trace code (please
forgive me for the silly questions in this mail...)

By "main function tracer", do you mean the function_trace_call()? And I
don't understand how to black list some functions manually?

If function_trace_call() is the main function tracer you mentioned,
there is preemption disable/enable in it. schedule might happen where
preemption is enabled. Or maybe you mean we should make all those
functions called with preemption disabled(or irqs disabled)?  

Then syscall_trace_enter(), syscall_trace_leave(), do_notify_resume(),
need be converted the similar way as schedule_preempt_user() did? 

Thanks, Zhong

> I could probably also add a heavier weight synchronize_sched() that even
> synchronizes cpus in userspace.
> 
> > 
> > If __schedule() in preempt_enable() is the only place function trace
> > uses RCU, then after converting to schedule_preempt_user(), it is safe
> > as irqs are disabled for __schedule() to happen. But user_exit() itself
> > and some other callers might still need function trace be disabled.
> 
> The above makes no sense to me. function tracing didn't break, but the
> user_exit() did because of a preemption in the wrong place, as there was
> no protection there to prevent an unnecessary preemption.
> 
> 
> -- Steve
> 
> 


