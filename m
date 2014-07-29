Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaG2P5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:57:54 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:57403 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaG2P5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:57:53 -0400
Date: Tue, 29 Jul 2014 08:57:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140729155747.GO11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140729075055.GY19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729075055.GY19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072915-7164-0000-0000-000003750275
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 09:50:55AM +0200, Peter Zijlstra wrote:
> On Mon, Jul 28, 2014 at 03:56:12PM -0700, Paul E. McKenney wrote:
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index bc1638b33449..a0d2f3a03566 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -2762,6 +2762,7 @@ need_resched:
> >  		} else {
> >  			deactivate_task(rq, prev, DEQUEUE_SLEEP);
> >  			prev->on_rq = 0;
> > +			rcu_note_voluntary_context_switch(prev);
> >  
> >  			/*
> >  			 * If a worker went to sleep, notify and ask workqueue
> > @@ -2828,6 +2829,7 @@ asmlinkage __visible void __sched schedule(void)
> >  	struct task_struct *tsk = current;
> >  
> >  	sched_submit_work(tsk);
> > +	rcu_note_voluntary_context_switch(tsk);
> >  	__schedule();
> >  }
> 
> Yeah, not entirely happy with that, you add two calls into one of the
> hotest paths of the kernel.

I did look into leveraging counters, but cannot remember why I decided
that this was a bad idea.  I guess it is time to recheck...

The ->nvcsw field in the task_struct structure looks promising:

o	Looks like it does in fact get incremented in __schedule() via
	the switch_count pointer.

o	Looks like it is unconditionally compiled in.

o	There are no memory barriers, but a synchronize_sched()
	should take care of that, given that this counter is
	incremented with interrupts disabled.

So I should be able to snapshot the task_struct structure's ->nvcsw
field and avoid the added code in the fastpaths.

Seem plausible, or am I confused about the role of ->nvcsw?

> And I'm still not entirely sure why, your 0/x babbled something about
> trampolines, but I'm not sure I understand how those lead to this.

Steven Rostedt sent an email recently giving more detail.  And of course
now I am having trouble finding it.  Maybe he will take pity on us and
send along a pointer to it.  ;-)

							Thanx, Paul

