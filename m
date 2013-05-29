Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab3E2Nzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:55:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17755 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759565Ab3E2Nza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:55:30 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=SF8-ipd7Fh4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=cu63OdLxYnwA:10 a=W4eAmNYtzYbRQgHzC04A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369835728.15552.69.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH] ftrace: Use schedule_on_each_cpu() as a heavy
 synchronize_sched()
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Date: Wed, 29 May 2013 09:55:28 -0400
In-Reply-To: <20130529133315.GC6172@linux.vnet.ibm.com>
References: <1369785676.15552.55.camel@gandalf.local.home>
	 <20130529075249.GC12193@twins.programming.kicks-ass.net>
	 <20130529133315.GC6172@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 06:33 -0700, Paul E. McKenney wrote:

> > Is there something a little smarter we can do? Could we use
> > on_each_cpu_cond() with a function that checks if the CPU really is
> > fully idle?
> 
> One recent change that should help is making the _rcuidle variants of
> the tracing functions callable from both idle and irq.  To make the
> on_each_cpu_cond() approach work, event tracing would need to switch
> from RCU (which might be preemptible RCU) to RCU-sched (whose read-side
> critical sections can pair with on_each_cpu().  I have to defer to Steven
> on whether this is a good approach.
> 

Just to be clear, the issue is only with the function tracer. This has
nothing to do with trace events, as we have the _rcuidle() variants to
deal with that.

We want the function tracer to trace pretty much everything it can,
especially a complex system like RCU. Thus, I would say that the burden
goes onto the tracing facility to solve this and not prevent tracing
critical parts of RCU.

As you stated with the problem of in_irq(), there's a point where we are
in an interrupt but the in_irq() isn't set yet. And this even shows up
in function tracing:

  <idle>-0       0d...   141.555326: function:             smp_apic_timer_interrupt
  <idle>-0       0d...   141.555327: function:                native_apic_mem_write
  <idle>-0       0d...   141.555327: function:                exit_idle
  <idle>-0       0d...   141.555327: function:                irq_enter
  <idle>-0       0d...   141.555327: function:                   rcu_irq_enter
  <idle>-0       0d...   141.555328: function:                   idle_cpu
  <idle>-0       0d.h.   141.555328: function:                   tick_check_idle
  <idle>-0       0d.h.   141.555328: function:                      tick_check_oneshot_broadcast
  <idle>-0       0d.h.   141.555328: function:                      ktime_get

Notice that we traced smp_apic_timer_interrupt, native_apic_mem_write,
exit_idle, irq_enter, and rcu_irq_enter, before rcu even was informed
that we are coming out of idle.

Then idle_cpu was also traced before the preempt_count was changed to
notify that we are in an interrupt (the 'h' in "0d.h.").

-- Steve


