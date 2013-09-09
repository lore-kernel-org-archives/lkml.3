Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab3IIN3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:29:08 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:44661 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3IIN3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:29:05 -0400
Date: Mon, 9 Sep 2013 15:29:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909132900.GE16280@somewhere>
References: <20130906151851.GQ3966@linux.vnet.ibm.com>
 <1378488088.31445.39.camel@edumazet-glaptop>
 <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909121329.GA16280@somewhere>
 <20130909083926.3eceebef@gandalf.local.home>
 <20130909124547.GB16280@somewhere>
 <20130909085504.2ddd7e69@gandalf.local.home>
 <20130909131452.GA31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909131452.GA31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 03:14:52PM +0200, Peter Zijlstra wrote:
> On Mon, Sep 09, 2013 at 08:55:04AM -0400, Steven Rostedt wrote:
> > On Mon, 9 Sep 2013 14:45:49 +0200
> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> >  
> > > > This just proves that the caller of rcu_is_cpu_idle() must disable
> > > > preemption itself for the entire time that it needs to use the result
> > > > of rcu_is_cpu_idle().
> > > 
> > > Sorry, I don't understand your point here. What's wrong with checking the
> > > ret from another CPU?
> > 
> > Hmm, OK, this is why that code is in desperate need of a comment.
> > 
> > From reading the context a bit more, it seems that the per cpu value is
> > more a "per task" value that happens to be using per cpu variables, and
> > changes on context switches. Is that correct?
> > 
> > Anyway, it requires a comment to explain that we are not checking the
> > CPU state, but really the current task state, otherwise that 'ret'
> > value wouldn't travel with the task, but would stick with the CPU.
> 
> Egads.. and the only reason we couldn't do the immediate load is because
> of that atomic mess.
> 
> Also, if its per-task, why don't we have this in the task struct? The
> current scheme makes the context switch more expensive -- is this the
> right trade-off?

No, putting that on the task_struct won't help much in this regard I think.
Regular schedule() calls don't change that per cpu state.

Only preempt_schedule_irq() and schedule_user() are concerned with rcu eqs state
exit/restore. But still storing that on task struct won't help.

> 
> So maybe something like:
> 
> int rcu_is_cpu_idle(void)
> {
> 	/*
> 	 * Comment explaining that rcu_dynticks.dynticks really is a
> 	 * per-task something and we need preemption-safe loading.
> 	 */
> 	atomic_t dynticks = this_cpu_read(rcu_dynticks.dynticks);
> 	return !(__atomic_read(&dynticks) & 0x01);
> }
> 
> Where __atomic_read() would be like atomic_read() but without the
> volatile crap since that's entirely redundant here I think.
> 
> The this_cpu_read() should ensure we get a preemption-safe copy of the
> value.
> 
> Once that this_cpu stuff grows preemption checks we'd need something
> like __raw_this_cpu_read() or whatever the variant without preemption
> checks will be called.

Yeah I thought about using this_cpu_read() too, lets wait for the preemption
checks to get in.
