Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaHCWFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 18:05:43 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:46999 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaHCWFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 18:05:42 -0400
Date: Sun, 3 Aug 2014 15:05:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140803220535.GH8101@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140802145616.GA18195@redhat.com>
 <20140802225757.GB8101@linux.vnet.ibm.com>
 <20140803133318.GB671@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140803133318.GB671@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080322-7164-0000-0000-00000390332F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2014 at 03:33:18PM +0200, Oleg Nesterov wrote:
> On 08/02, Paul E. McKenney wrote:
> >
> > On Sat, Aug 02, 2014 at 04:56:16PM +0200, Oleg Nesterov wrote:
> > > On 07/31, Paul E. McKenney wrote:
> > > >
> > > > +		rcu_read_lock();
> > > > +		for_each_process_thread(g, t) {
> > > > +			if (t != current && ACCESS_ONCE(t->on_rq) &&
> > > > +			    !is_idle_task(t)) {
> > >
> > > I didn't notice this check before, but it is not needed. for_each_process()
> > > can see the idle threads, there are not on process/thread lists.
>     ^^^^^^^
> 
> argh, I mean't "can't see" of course...
> 
> > Good to know.  Any other important tasks I am missing?
> 
> Nothing else.

Whew!  ;-)

> > I am guessing that I need to do something like this:
> >
> > 	for_each_process(g) {
> > 		/* Do build step. */
> > 		for_each_thread(g, t) {
> > 			if (g == t)
> > 				continue;
> > 			/* Do build step. */
> > 		}
> > 	}
> 
> Sorry, I don't understand... This is equivalent to
> 
> 	for_each_process_thread(g, t) {
> 		/* Do build step. */
> 	}

OK, got it.

> > Your point about exiting tasks I get, and I believe I can solve it.
> > I am hoping that the above sort of construction takes care of the
> > idle threads.
> 
> It is simple to find the idle threads, just
> 
> 	for_each_cpu(cpu) {
> 		do_something(cpu_rq(cpu)->idle);
> 	}
> 
> but it is not clear to me what else you need to do with the idle threads.
> Probably not too much, they mostly run under preempt_disable().

OK, looks easy enough.  And yes, one good question is what, if anything,
we need to do with the idle threads.

> > I might also need to do something to handle changes in
> > process/thread hierarchy -- but hopefully without having to read-acquire
> > the task-list lock.
> 
> It seems that you need another global list, a task should be visible on that
> list until exit_rcu().

As in create another global list that all tasks are added to when created
and then remved from when they exit?

							Thanx, Paul

