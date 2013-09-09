Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3IIQhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:37:45 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41613 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab3IIQhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:37:43 -0400
Date: Mon, 9 Sep 2013 09:22:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909162215.GY3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909121329.GA16280@somewhere>
 <20130909083926.3eceebef@gandalf.local.home>
 <20130909124547.GB16280@somewhere>
 <20130909085504.2ddd7e69@gandalf.local.home>
 <20130909131452.GA31370@twins.programming.kicks-ass.net>
 <20130909134605.GP3966@linux.vnet.ibm.com>
 <20130909095511.735bcffc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909095511.735bcffc@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090916-5806-0000-0000-000022AC6917
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 09:55:11AM -0400, Steven Rostedt wrote:
> On Mon, 9 Sep 2013 06:46:05 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> 
> > > Also, if its per-task, why don't we have this in the task struct? The
> > > current scheme makes the context switch more expensive -- is this the
> > > right trade-off?
> > 
> > There are constraints based on the task, but RCU really is
> > paying attention to CPUs, not than tasks.  (With the exception of
> > TREE_PREEMPT_RCU, which does keep lists of tasks that it has to pay
> > attention to, namely those that have been preempted within their current
> > RCU read-side critical section.)
> 
> Conceptually wise, RCU keeps track of task state, not CPU state. In all
> your diagrams in your presentations, where you talk about grace periods
> and quiescent states, you show tasks, not CPUs.
> 
> RCU's implementation is based on CPUs, and only when rcu_read_lock()
> prevents preemption. As you stated above, TREE_PREEMPT_RCU needs to
> keep track of tasks.

Actually, in TINY_RCU and TREE_RCU, preemption is disabled to begin
with, so that rcu_read_lock() doesn't need to do anything.  I left
the preempt_disable() in rcu_read_lock() and the preempt_enable() in
rcu_read_unlock() in case we ever have need to run either TINY_RCU or
TREE_RCU in a CONFIG_PREEPT=y kernel.

That said, TREE_PREEMPT_RCU's implementation does track tasks sometimes,
but only in the (hopefully) uncommon case where an RCU read-side critical
section is preempted.

However, the API we are arguing about is deep within the implementation.
It is not at the level of rcu_read_lock().  It is something that should
not have that many invocations -- after all, the things using it are
binding themselves unusually close to RCU.

> I think you are too deep into the implementation, that you are
> forgetting the concept that you created :-)

Like I said before (though admittedly after you wrote the above), the
implementation came first and the concepts much later.  ;-)

							Thanx, Paul

