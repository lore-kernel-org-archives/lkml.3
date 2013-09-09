Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3IIN3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:29:20 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44562 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3IIN3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:29:16 -0400
Date: Mon, 9 Sep 2013 06:29:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909132908.GO3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1378488088.31445.39.camel@edumazet-glaptop>
 <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909121329.GA16280@somewhere>
 <20130909083926.3eceebef@gandalf.local.home>
 <20130909124547.GB16280@somewhere>
 <20130909085504.2ddd7e69@gandalf.local.home>
 <20130909130851.GC16280@somewhere>
 <20130909092142.05780991@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909092142.05780991@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090913-9332-0000-0000-0000015A8DA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 09:21:42AM -0400, Steven Rostedt wrote:
> On Mon, 9 Sep 2013 15:08:53 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Sep 09, 2013 at 08:55:04AM -0400, Steven Rostedt wrote:
> 
> > > From reading the context a bit more, it seems that the per cpu value is
> > > more a "per task" value that happens to be using per cpu variables, and
> > > changes on context switches. Is that correct?
> > 
> > Yeah that's probably what confuse so many people. It's indeed at the same
> > time a task state and a per cpu state.
> 
> Especially since the function name itself is "rcu_is_cpu_idle()" which
> tells you it's a cpu state, and not a task state. Why would you care in
> RCU if CPU 1 is idle if you are on CPU 2? The name should be changed.

I could call it rcu_watching_this_cpu(), and rename the current
rcu_watching_this_cpu() to __rcu_watching_this_cpu().

It should be possible to make a straightforward comment that helps.
I will let Frederic take first crack at it.

> > Pretty much like tsk->ti->preempt_count that people now try to implement
> > through a per cpu value.
> 
> Actually, preempt_count is more a CPU state than a task state. When
> preempt_count is set, that CPU can not schedule out the current task.
> It really has nothing to do with the task itself. It's the CPU that
> can't do something. Preempt count should never traverse with a task
> from one CPU to another.

And this is similar to what is happening with rcu_is_cpu_idle().  The
rcu_dynticks.dynticks per-CPU variable cannot transition between zero
and non-zero while a given non-idle task is running.  So what about
the idle tasks?  Well, they run with preemption disabled, so they can
safely access per-CPU variables.

							Thanx, Paul

