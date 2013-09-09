Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3IIMNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:13:37 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63319 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3IIMNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:13:35 -0400
Date: Mon, 9 Sep 2013 14:13:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909121329.GA16280@somewhere>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
 <20130906105934.GF20519@somewhere>
 <20130906151851.GQ3966@linux.vnet.ibm.com>
 <1378488088.31445.39.camel@edumazet-glaptop>
 <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909105347.GK31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 12:53:47PM +0200, Peter Zijlstra wrote:
> On Fri, Sep 06, 2013 at 08:59:29PM +0200, Frederic Weisbecker wrote:
> > Imagine that you're running on an rcu read side critical section on CPU 0, which
> > is not in extended quiescent state. Now you get preempted in the middle of your
> > RCU read side critical section (you called rcu_read_lock() but not yet rcu_read_unlock()).
> > 
> > Later on, the task is woken up to be scheduled in CPU 1. If CPU 1 is in extended
> > quiescent state because it runs is userspace, it receives a scheduler IPI,
> > then schedule_user() is called by the end of the interrupt and in turns calls rcu_user_exit()
> > before the task is resumed to the code it was running on CPU 0, in the middle of
> > the rcu read side extended quiescent state.
> > 
> > See, the key here is the rcu_user_exit() that restore the CPU on RCU's state machine.
> > There are other possible scheduler entrypoints when a CPU runs in user extended quiescent
> > state: exception and syscall entries or even preempt_schedule_irq() in case we receive an irq
> > in the kernel while we haven't yet reached the call to rcu_user_exit()... All of these should
> > be covered, otherwise you bet RCU would be prompt to warn.
> > 
> > That's why when we call rcu_is_cpu_idle() from an RCU read side critical section, it's legit even
> > if we can be preempted anytime around it.
> > And preempt_disable() is probably not even necessary, except perhaps if __get_cpu_var() itself
> > relies on non-preemptibility for its own correctness on the address calculation.
> 
> I've tried reading that trice now, still not making much sense.
> 
> In any case rcu_is_cpu_idle() is complete bollocks, either use
> __raw_get_cpu_var() and add a _coherent_ explanation for why its right,
> or its broken.
> 
> In any case the preempt_disable/enable pair there is just plain wrong as
> Eric pointed out.

Check this:

34240697d619c439c55f21989680024dcb604aab "rcu: Disable preemption in rcu_is_cpu_idle()"
