Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaGaRCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:02:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50281 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaGaRCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:02:47 -0400
Date: Thu, 31 Jul 2014 10:02:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 01/10] rcu: Add call_rcu_tasks()
Message-ID: <20140731170232.GW11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53D9F084.7000706@cn.fujitsu.com>
 <20140731160924.GR11241@linux.vnet.ibm.com>
 <20140731163138.GA15228@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731163138.GA15228@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073117-9332-0000-0000-0000018EC837
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 06:31:38PM +0200, Oleg Nesterov wrote:
> Again, sorry, I didn't read the patches yet, just noticed your discussion...
> 
> On 07/31, Paul E. McKenney wrote:
> >
> > On Thu, Jul 31, 2014 at 03:30:12PM +0800, Lai Jiangshan wrote:
> >
> > > > +				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
> > > > +				t->rcu_tasks_holdout = 1;
> > > > +				list_add(&t->rcu_tasks_holdout_list,
> > > > +					 &rcu_tasks_holdouts);
> > >
> > > I think get_task_struct() is needed here to avoid the task disappears.
> >
> > Hmmm...  Let's see...
> >
> > Looks like get_task_struct() does a blind atomic increment of ->usage.
> > And put_task_struct() does an atomic_dec_and_test().  So one question
> > is "what prevents us from doing get_task_struct() after the final
> > put_task_struct() has pushed ->usage down to zero?"
> >
> > Hopefully there is a grace period in there somewhere, otherwise it will
> > be necessary to take the task-list lock, which I would like to avoid.
> >
> > Looks like the call_rcu() of delayed_put_task_struct() in release_task()
> > might be doing this.
> 
> Yes, exactly, so get_task_struct() is always fine as long as task_struct
> itself is protected by RCU.
> 
> But can't we avoid get_task_struct()? This can pin a lot of task_struct's.
> Can't we just add list_del_rcu(holdout_list) into __unhash_process() ?

If I add the list_del_rcu() there, then I am back to a concurrent list,
which I would like to avoid.  Don't get me wrong, it was fun playing with
the list-locked stuff, but best to avoid it if we can.

Also, the current implementation implicitly locks down the task_structs
via the exit path.  The nice thing about using get_task_struct to lock
them down is that -only- the task_struct itself is locked down -- the
task can be reaped and so on.  In contrast, the current exit_rcu_tasks()
approach delays the semantic exit instead of just hanging onto the
underlying task_struct a bit longer.

> We only need to ensure that list_add() above can't race with that list_del(),
> perhaps we can tolerate lock_task_sighand() ?

I am worried about a task that does a voluntary context switch, then exits.
This could results in rcu_tasks_kthread() and __unhash_process() both
wanting to dequeue at the same time, right?

							Thanx, Paul

