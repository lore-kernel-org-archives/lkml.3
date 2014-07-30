Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaG3QIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:08:20 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46001 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbaG3QIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:08:19 -0400
Date: Wed, 30 Jul 2014 09:08:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140730160812.GO11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140730154949.GA26787@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730154949.GA26787@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073016-0928-0000-0000-000003BB66A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 05:49:49PM +0200, Oleg Nesterov wrote:
> On 07/28, Paul E. McKenney wrote:
> >
> > This commit adds a new RCU-tasks flavor of RCU, which provides
> > call_rcu_tasks().  This RCU flavor's quiescent states are voluntary
> > context switch (not preemption!), userspace execution, and the idle loop.
> > Note that unlike other RCU flavors, these quiescent states occur in tasks,
> > not necessarily CPUs.  Includes fixes from Steven Rostedt.
> 
> I still hope I will read this series later. Not that I really hope I will
> understand it ;)

Well, don't put too much time into it just now.  Bozo here has been doing
concurrent programming so long that he sometimes misses opportunities
for single-threaded programming.  Hence the locked-list stuff.  :-/

> Just one question for now,
> 
> > +static int __noreturn rcu_tasks_kthread(void *arg)
> > +{
> > +	unsigned long flags;
> > +	struct task_struct *g, *t;
> > +	struct rcu_head *list;
> > +	struct rcu_head *next;
> > +
> > +	/* FIXME: Add housekeeping affinity. */
> > +
> > +	/*
> > +	 * Each pass through the following loop makes one check for
> > +	 * newly arrived callbacks, and, if there are some, waits for
> > +	 * one RCU-tasks grace period and then invokes the callbacks.
> > +	 * This loop is terminated by the system going down.  ;-)
> > +	 */
> > +	for (;;) {
> > +
> > +		/* Pick up any new callbacks. */
> > +		raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
> > +		smp_mb__after_unlock_lock(); /* Enforce GP memory ordering. */
> > +		list = rcu_tasks_cbs_head;
> > +		rcu_tasks_cbs_head = NULL;
> > +		rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
> > +		raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
> > +
> > +		/* If there were none, wait a bit and start over. */
> > +		if (!list) {
> > +			schedule_timeout_interruptible(HZ);
> > +			flush_signals(current);
> 
> Why? And I see more flush_signals() in the current kernel/rcu/ code. Unless
> a kthread does allow_signal() it can't have a pending signal?

Because I am overly paranoid.  ;-)

							Thanx, Paul

