Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3GJM1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:27:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24362 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3GJM1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:27:37 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=mY5AGG0wUPsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=x45eBLDEq7QA:10 a=oYh8eL3xjYd5ljICvmcA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373459254.7458.49.camel@gandalf.local.home>
Subject: Re: timer: lockup in run_timer_softirq()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        Tejun Heo <tj@kernel.org>, tglx@linutronix.de,
        LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org
Date: Wed, 10 Jul 2013 08:27:34 -0400
In-Reply-To: <20130710095210.GD17211@twins.programming.kicks-ass.net>
References: <51DC902F.3070403@oracle.com>
	 <20130709224706.GA13855@redhat.com> <51DC9379.9050408@oracle.com>
	 <20130709230316.GB13855@redhat.com> <51DC983F.2010409@oracle.com>
	 <20130710095210.GD17211@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 11:52 +0200, Peter Zijlstra wrote:

> Fun.. :-) we trace __local_bh_enable() and hit a ftrace callback between
> telling lockdep we enabled softirqs and actually doing so.
> 
> I'm just a tad confused by the trace; it says we go:
>   lock_is_held()
>     check_flags()
> 
> Looking at perf_tp_event() this would most likely be from:
> 
>   ctx = rcu_dereference(task->perf_event_ctxp[perf_sw_context]);

Function tracing should not be treated as a normal trace point. It is
much more invasive, and there's things that one should be weary about
when using it.

> 
> Where the lock_is_held() would be from rcu_dereference_check()'s
> rcu_read_lock_sched_held(). However, by there we've already passed
> rcu_read_lock() which includes rcu_lock_acquire() -> lock_acquire() ->
> check_flags(). So it should've triggered there.
> 
> Ideally we'd not trace __local_bh_enable() at all, seeing as how any RCU usage
> in there would be bound to trigger this.

I find it very useful to trace __local_bh_enable(). I also trace RCU
calls.

When using function tracing, you need to use
rcu_dereference_raw_notrace().

Also, function tracing callbacks should avoid rcu_read_lock(), as that's
traced as well. You can use preempt_disable_notrace() for rcu usage.

-- Steve


