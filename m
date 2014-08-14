Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaHNWxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 18:53:51 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38240 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaHNWxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 18:53:50 -0400
Date: Thu, 14 Aug 2014 15:53:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v5 tip/core/rcu 11/16] rcu: Defer rcu_tasks_kthread()
 creation till first call_rcu_tasks()
Message-ID: <20140814225344.GB4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAJhHMCAvzXUgCuiO5nDB0oZYkFsyJ1bdJmz5JML4jrLrC5F0qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCAvzXUgCuiO5nDB0oZYkFsyJ1bdJmz5JML4jrLrC5F0qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081422-3532-0000-0000-000003DB8756
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 06:28:53PM -0400, Pranith Kumar wrote:
> On Mon, Aug 11, 2014 at 6:49 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >
> > It is expected that many sites will have CONFIG_TASKS_RCU=y, but
> > will never actually invoke call_rcu_tasks().  For such sites, creating
> > rcu_tasks_kthread() at boot is wasteful.  This commit therefore defers
> > creation of this kthread until the time of the first call_rcu_tasks().
> >
> > This of course means that the first call_rcu_tasks() must be invoked
> > from process context after the scheduler is fully operational.
> >
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcu/update.c | 33 ++++++++++++++++++++++++++-------
> >  1 file changed, 26 insertions(+), 7 deletions(-)
> >
> > diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> > index 1256a900cd01..d997163c7e92 100644
> > --- a/kernel/rcu/update.c
> > +++ b/kernel/rcu/update.c
> > @@ -378,7 +378,12 @@ DEFINE_SRCU(tasks_rcu_exit_srcu);
> >  static int rcu_task_stall_timeout __read_mostly = HZ * 60 * 10;
> >  module_param(rcu_task_stall_timeout, int, 0644);
> >
> > -/* Post an RCU-tasks callback. */
> > +static void rcu_spawn_tasks_kthread(void);
> > +
> > +/*
> > + * Post an RCU-tasks callback.  First call must be from process context
> > + * after the scheduler if fully operational.
> > + */
> >  void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
> >  {
> >         unsigned long flags;
> > @@ -391,8 +396,10 @@ void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
> >         *rcu_tasks_cbs_tail = rhp;
> >         rcu_tasks_cbs_tail = &rhp->next;
> >         raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
> > -       if (needwake)
> > +       if (needwake) {
> > +               rcu_spawn_tasks_kthread();
> >                 wake_up(&rcu_tasks_cbs_wq);
> > +       }
> >  }
> >  EXPORT_SYMBOL_GPL(call_rcu_tasks);
> >
> > @@ -618,15 +625,27 @@ static int __noreturn rcu_tasks_kthread(void *arg)
> >         }
> >  }
> >
> > -/* Spawn rcu_tasks_kthread() at boot time. */
> > -static int __init rcu_spawn_tasks_kthread(void)
> > +/* Spawn rcu_tasks_kthread() at first call to call_rcu_tasks(). */
> > +static void rcu_spawn_tasks_kthread(void)
> >  {
> > -       struct task_struct __maybe_unused *t;
> > +       static DEFINE_MUTEX(rcu_tasks_kthread_mutex);
> > +       static struct task_struct *rcu_tasks_kthread_ptr;
> > +       struct task_struct *t;
> >
> > +       if (ACCESS_ONCE(rcu_tasks_kthread_ptr)) {
> > +               smp_mb(); /* Ensure caller sees full kthread. */
> > +               return;
> > +       }
> 
> I don't see the need for this smp_mb(). The caller has already seen
> that rcu_tasks_kthread_ptr is assigned. What are we ensuring with this
> barrier again?

We are ensuring that any later operations on rcu_tasks_kthread_ptr
see a fully initialized thread.  Because these later operations
might be loads, we cannot rely on control dependencies.

> an smp_rmb() before this ACCESS_ONCE() and an smp_wmb() after
> assigning to rcu_tasks_kthread_ptr should be enough, right?

Probably.  But given that rcu_spawn_tasks_kthread() is only called
when a CPU is onlined, I am not much inclined to weaken it.

> > +       mutex_lock(&rcu_tasks_kthread_mutex);
> > +       if (rcu_tasks_kthread_ptr) {
> > +               mutex_unlock(&rcu_tasks_kthread_mutex);
> > +               return;
> > +       }
> >         t = kthread_run(rcu_tasks_kthread, NULL, "rcu_tasks_kthread");
> >         BUG_ON(IS_ERR(t));
> > -       return 0;
> > +       smp_mb(); /* Ensure others see full kthread. */
> > +       ACCESS_ONCE(rcu_tasks_kthread_ptr) = t;
> 
> Isn't it better to reverse these two statements and change as follows?
> 
> ACCESS_ONCE(rcu_tasks_kthread_ptr) = t;
> smp_wmb();

This would break.  We need all the task creation stuff to be seen as
having happened before the store to rcu_tasks_kthread_ptr.  Putting
the barrier after the store to rcu_tasks_kthread_ptr would allow
both compiler and CPU to reorder task-creation stuff to follow the
store to the pointer, which would not be good.

> or
> 
> smp_store_release(rcu_tasks_kthread_ptr, t);
> 
> will ensure that this write to rcu_task_kthread_ptr is ordered with
> the previous read. I recently read memory-barriers.txt, so please
> excuse me if I am totally wrong. But I am confused! :(

Hmmm...  An smp_store_release() combined with smp_load_acquire()
up earlier might be a good approach.  Maybe as a future cleanup.

But please note that smp_store_release() puts the barrier -before-
the store.  ;-)

							Thanx, Paul

> > +       mutex_unlock(&rcu_tasks_kthread_mutex);
> >  }
> > -early_initcall(rcu_spawn_tasks_kthread);
> >
> >  #endif /* #ifdef CONFIG_TASKS_RCU */
> > --
> > 1.8.1.5
> >
> 
> 
> 
> -- 
> Pranith
> 

