Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaHHR1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:27:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:25668 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751157AbaHHR1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:27:19 -0400
Date: Fri, 8 Aug 2014 13:27:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140808132716.28aa1c14@gandalf.local.home>
In-Reply-To: <20140808162714.GG9918@twins.programming.kicks-ass.net>
References: <20140807172753.GG3588@twins.programming.kicks-ass.net>
	<20140807184635.GI3588@twins.programming.kicks-ass.net>
	<20140807154907.6f59cf6e@gandalf.local.home>
	<20140807155326.18481e66@gandalf.local.home>
	<20140807200813.GB3935@laptop>
	<20140807171823.1a481290@gandalf.local.home>
	<20140808064020.GZ9918@twins.programming.kicks-ass.net>
	<20140808101221.21056900@gandalf.local.home>
	<20140808143413.GB9918@twins.programming.kicks-ass.net>
	<20140808105858.171da847@gandalf.local.home>
	<20140808162714.GG9918@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014 18:27:14 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Aug 08, 2014 at 10:58:58AM -0400, Steven Rostedt wrote:
> 
> > > > No, they are also used by optimized kprobes. This is why optimized
> > > > kprobes depend on !CONFIG_PREEMPT. [ added Masami to the discussion ].
> > > 
> > > How do those work? Is that one where the INT3 relocates the instruction
> > > stream into an alternative 'text' and that JMPs back into the original
> > > stream at the end?
> > 
> > No, it's where we replace the 'int3' with a jump to a trampoline that
> > simulates an INT3. Speeds things up quite a bit.
> 
> OK, so the trivial 'fix' for that is to patch the probe site like:
> 
> 	preempt_disable();		INC	GS:%__preempt_count
> 	call trampoline;		CALL	0xDEADBEEF
> 	preempt_enable();		DEC	GS:%__preempt_count
> 					JNZ	1f
> 					CALL	___preempt_schedule
> 				1f:
> 
> At which point the preempt_disable/enable() are the read side primitives
> and call_rcu_sched/synchronize_sched are sufficient to release it.
> 
> With the per-cpu preempt count stuff we have on x86 that is 4
> instructions for the preempt_*() stuff -- they're 'big' instructions
> though, since 3 have memops and 2 have a segment prefix.
> 
> 

Well, this looks like it may make kprobes a bit more complex, and even
slow down slightly the optimized probe.

Also note that if we add call_rcu_tasks(), then perf function tracing
can be called directly instead of being added to the trampoline that
disables and enables preemption before calling it.

-- Steve
