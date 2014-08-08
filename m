Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbaHHQjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:39:16 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46983 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbaHHQjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:39:13 -0400
Date: Fri, 8 Aug 2014 09:39:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, bobby.prani@gmail.com,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140808163905.GA5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140807184635.GI3588@twins.programming.kicks-ass.net>
 <20140807154907.6f59cf6e@gandalf.local.home>
 <20140807155326.18481e66@gandalf.local.home>
 <20140807200813.GB3935@laptop>
 <20140807171823.1a481290@gandalf.local.home>
 <20140808064020.GZ9918@twins.programming.kicks-ass.net>
 <20140808101221.21056900@gandalf.local.home>
 <20140808143413.GB9918@twins.programming.kicks-ass.net>
 <20140808105858.171da847@gandalf.local.home>
 <20140808162714.GG9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808162714.GG9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080816-0928-0000-0000-000003FA92CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 06:27:14PM +0200, Peter Zijlstra wrote:
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

Unless this is done in idle, at which point RCU-sched is studiously
ignoring any preempt_disable() sections.

							Thanx, Paul

