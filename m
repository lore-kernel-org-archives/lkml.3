Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaHNVz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:55:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46471 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbaHNVz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:55:27 -0400
Date: Thu, 14 Aug 2014 14:55:21 -0700
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
Subject: Re: [PATCH v5 tip/core/rcu 09/16] rcu: Improve RCU-tasks energy
 efficiency
Message-ID: <20140814215521.GZ4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-9-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAJhHMCDT1_Per3Qfx8qd23btnLmMVgPucL7OcUncUHWURGp6aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCDT1_Per3Qfx8qd23btnLmMVgPucL7OcUncUHWURGp6aQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081421-6688-0000-0000-0000040579E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 05:42:06PM -0400, Pranith Kumar wrote:
> On Mon, Aug 11, 2014 at 6:48 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >
> > The current RCU-tasks implementation uses strict polling to detect
> > callback arrivals.  This works quite well, but is not so good for
> > energy efficiency.  This commit therefore replaces the strict polling
> > with a wait queue.
> >
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcu/update.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> > index f1535404a79e..1256a900cd01 100644
> > --- a/kernel/rcu/update.c
> > +++ b/kernel/rcu/update.c
> > @@ -368,6 +368,7 @@ early_initcall(check_cpu_stall_init);
> >  /* Global list of callbacks and associated lock. */
> >  static struct rcu_head *rcu_tasks_cbs_head;
> >  static struct rcu_head **rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
> > +static DECLARE_WAIT_QUEUE_HEAD(rcu_tasks_cbs_wq);
> >  static DEFINE_RAW_SPINLOCK(rcu_tasks_cbs_lock);
> >
> >  /* Track exiting tasks in order to allow them to be waited for. */
> > @@ -381,13 +382,17 @@ module_param(rcu_task_stall_timeout, int, 0644);
> >  void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
> >  {
> >         unsigned long flags;
> > +       bool needwake;
> >
> >         rhp->next = NULL;
> >         rhp->func = func;
> >         raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
> > +       needwake = !rcu_tasks_cbs_head;
> >         *rcu_tasks_cbs_tail = rhp;
> >         rcu_tasks_cbs_tail = &rhp->next;
> >         raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
> > +       if (needwake)
> > +               wake_up(&rcu_tasks_cbs_wq);
> >  }
> >  EXPORT_SYMBOL_GPL(call_rcu_tasks);
> 
> I think you want
> 
> needwake = !!rcu_tasks_cbs_head;
> 
> otherwise it will wake up when rcu_tasks_cbs_head is null, no?

Well, that is exactly what we want.  Note that we do the test -before-
the enqueue.  This means that we do the wakeup if the list -was-
empty before the enqueue, which is exactly the case where the task
might be asleep without having already been sent a wakeup.

Assuming that wakeups are reliably delivered, of course.  But if they
are not reliably delivered, that is a bug that needs to be fixed.

							Thanx, Paul

> > @@ -498,8 +503,12 @@ static int __noreturn rcu_tasks_kthread(void *arg)
> >
> >                 /* If there were none, wait a bit and start over. */
> >                 if (!list) {
> > -                       schedule_timeout_interruptible(HZ);
> > -                       WARN_ON(signal_pending(current));
> > +                       wait_event_interruptible(rcu_tasks_cbs_wq,
> > +                                                rcu_tasks_cbs_head);
> > +                       if (!rcu_tasks_cbs_head) {
> > +                               WARN_ON(signal_pending(current));
> > +                               schedule_timeout_interruptible(HZ/10);
> > +                       }
> >                         continue;
> >                 }
> >
> > @@ -605,6 +614,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
> >                         list = next;
> >                         cond_resched();
> >                 }
> > +               schedule_timeout_uninterruptible(HZ/10);
> >         }
> >  }
> >
> > --
> > 1.8.1.5
> >
> 
> 
> 
> -- 
> Pranith
> 

