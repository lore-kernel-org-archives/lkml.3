Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaHGVS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:18:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:4225 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750890AbaHGVS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:18:26 -0400
Date: Thu, 7 Aug 2014 17:18:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140807171823.1a481290@gandalf.local.home>
In-Reply-To: <20140807200813.GB3935@laptop>
References: <20140806120958.GZ8101@linux.vnet.ibm.com>
	<20140806163035.GG19379@twins.programming.kicks-ass.net>
	<20140806224518.GA8101@linux.vnet.ibm.com>
	<20140807084544.GJ19379@twins.programming.kicks-ass.net>
	<20140807150031.GB5821@linux.vnet.ibm.com>
	<20140807152600.GW9918@twins.programming.kicks-ass.net>
	<20140807172753.GG3588@twins.programming.kicks-ass.net>
	<20140807184635.GI3588@twins.programming.kicks-ass.net>
	<20140807154907.6f59cf6e@gandalf.local.home>
	<20140807155326.18481e66@gandalf.local.home>
	<20140807200813.GB3935@laptop>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2014 22:08:13 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> OK, you've got to start over and start at the beginning, because I'm
> really not understanding this..
> 
> What is a 'trampoline' and what are you going to use them for.

Great question! :-)

The trampoline is some code that is used to jump to and then jump
someplace else. Currently, we use this for kprobes and ftrace. For
ftrace we have the ftrace_caller trampoline, which is static. When
booting, most functions in the kernel call the mcount code which
simply returns without doing anything. This too is a "trampoline". At
boot, we convert these calls to nops (as you already know). When we
enable callbacks from functions, we convert those calls to call
"ftrace_caller" which is a small assembly trampoline that will call
some function that registered with ftrace.

Now why do we need the call_rcu_task() routine?

Right now, if you register multiple callbacks to ftrace, even if they
are not tracing the same routine, ftrace has to change ftrace_caller to
call another trampoline (in C), that does a loop of all ops registered
with ftrace, and compares the function to the ops hash tables to see if
the ops function should be called for that function.

What we want to do is to create a dynamic trampoline that is a copy of
the ftrace_caller code, but instead of calling this list trampoline, it
calls the ops function directly. This way, each ops registered with
ftrace can have its own custom trampoline that when called will only
call the ops function and not have to iterate over a list. This only
happens if the function being traced only has this one ops registered.
For functions with multiple ops attached to it, we need to call the
list anyway. But for the majority of the cases, this is not the case.

The one caveat for this is, how do we free this custom trampoline when
the ops is done with it? Especially for users of ftrace that
dynamically create their own ops (like perf, and ftrace instances).

We need to find a way to free it, but unfortunately, there's no way to
know when it is safe to free it. There's no way to disable preemption
or have some other notifier to let us know if a task has jumped to this
trampoline and has been preempted (sleeping). The only safe way to know
that no task is on the trampoline is to remove the calls to it,
synchronize the CPUS (so the trampolines are not even in the caches),
and then wait for all tasks to go through some quiescent state. This
state happens to be either not running, in userspace, or when it
voluntarily calls schedule. Because nothing that uses this trampoline
should do that, and if the task voluntarily calls schedule, we know
it's not on the trampoline.

Make sense?

-- Steve
