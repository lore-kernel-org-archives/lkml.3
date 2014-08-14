Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaHNVt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:49:59 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:36815 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaHNVt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:49:57 -0400
Date: Thu, 14 Aug 2014 14:49:50 -0700
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
Subject: Re: [PATCH v5 tip/core/rcu 06/16] rcutorture: Add torture tests for
 RCU-tasks
Message-ID: <20140814214950.GA10580@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAJhHMCBVHR007FO11sajnw1n8fuCz6Sw_PnsDxgOXP3-AYXnbw@mail.gmail.com>
 <20140814214415.GY4752@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140814214415.GY4752@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081421-1344-0000-0000-00000379278B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 02:44:15PM -0700, Paul E. McKenney wrote:
> On Thu, Aug 14, 2014 at 05:34:53PM -0400, Pranith Kumar wrote:
> > On Mon, Aug 11, 2014 at 6:48 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > >
> > > This commit adds torture tests for RCU-tasks.  It also fixes a bug that
> > > would segfault for an RCU flavor lacking a callback-barrier function.
> > >
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > > ---
> > >  include/linux/rcupdate.h |  1 +
> > >  kernel/rcu/rcutorture.c  | 50 +++++++++++++++++++++++++++++++++++++++++++++++-
> > >  2 files changed, 50 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > > index e6aea256ad39..f504f797c9c8 100644
> > > --- a/include/linux/rcupdate.h
> > > +++ b/include/linux/rcupdate.h
> > > @@ -55,6 +55,7 @@ enum rcutorture_type {
> > >         RCU_FLAVOR,
> > >         RCU_BH_FLAVOR,
> > >         RCU_SCHED_FLAVOR,
> > > +       RCU_TASKS_FLAVOR,
> > >         SRCU_FLAVOR,
> > >         INVALID_RCU_FLAVOR
> > >  };
> > > diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
> > > index febe07062ac5..52423f2c74da 100644
> > > --- a/kernel/rcu/rcutorture.c
> > > +++ b/kernel/rcu/rcutorture.c
> > > @@ -601,6 +601,52 @@ static struct rcu_torture_ops sched_ops = {
> > >         .name           = "sched"
> > >  };
> > >
> > > +#ifdef CONFIG_TASKS_RCU
> > > +
> > > +/*
> > > + * Definitions for RCU-tasks torture testing.
> > > + */
> > > +
> > > +static int tasks_torture_read_lock(void)
> > > +{
> > > +       return 0;
> > > +}
> > > +
> > > +static void tasks_torture_read_unlock(int idx)
> > > +{
> > > +}
> > > +
> > > +static void rcu_tasks_torture_deferred_free(struct rcu_torture *p)
> > > +{
> > > +       call_rcu_tasks(&p->rtort_rcu, rcu_torture_cb);
> > > +}
> > > +
> > > +static struct rcu_torture_ops tasks_ops = {
> > > +       .ttype          = RCU_TASKS_FLAVOR,
> > > +       .init           = rcu_sync_torture_init,
> > > +       .readlock       = tasks_torture_read_lock,
> > > +       .read_delay     = rcu_read_delay,  /* just reuse rcu's version. */
> > > +       .readunlock     = tasks_torture_read_unlock,
> > > +       .completed      = rcu_no_completed,
> > > +       .deferred_free  = rcu_tasks_torture_deferred_free,
> > > +       .sync           = synchronize_rcu_tasks,
> > > +       .exp_sync       = synchronize_rcu_tasks,
> > > +       .call           = call_rcu_tasks,
> > > +       .cb_barrier     = rcu_barrier_tasks,
> > > +       .fqs            = NULL,
> > > +       .stats          = NULL,
> > > +       .irq_capable    = 1,
> > > +       .name           = "tasks"
> > > +};
> > > +
> > > +#define RCUTORTURE_TASKS_OPS &tasks_ops,
> > 
> > Not sure about the comma here, no harm but still... a minor nit :)
> 
> Good point, it would be better to parenthesize this an put the comma
> at the point of use.  Fixed!

Except that this gives me a syntax error when CONFIG_TASKS_RCU=n because
we end up with a pair of consecutive commas.  Nice try, though!  ;-)

							Thanx, Paul

> > > +
> > > +#else /* #ifdef CONFIG_TASKS_RCU */
> > > +
> > > +#define RCUTORTURE_TASKS_OPS
> > > +
> > > +#endif /* #else #ifdef CONFIG_TASKS_RCU */
> > > +
> > >  /*
> > >   * RCU torture priority-boost testing.  Runs one real-time thread per
> > >   * CPU for moderate bursts, repeatedly registering RCU callbacks and
> > > @@ -1295,7 +1341,8 @@ static int rcu_torture_barrier_cbs(void *arg)
> > >                 if (atomic_dec_and_test(&barrier_cbs_count))
> > >                         wake_up(&barrier_wq);
> > >         } while (!torture_must_stop());
> > > -       cur_ops->cb_barrier();
> > > +       if (cur_ops->cb_barrier != NULL)
> > > +               cur_ops->cb_barrier();
> > >         destroy_rcu_head_on_stack(&rcu);
> > >         torture_kthread_stopping("rcu_torture_barrier_cbs");
> > >         return 0;
> > > @@ -1534,6 +1581,7 @@ rcu_torture_init(void)
> > >         int firsterr = 0;
> > >         static struct rcu_torture_ops *torture_ops[] = {
> > >                 &rcu_ops, &rcu_bh_ops, &rcu_busted_ops, &srcu_ops, &sched_ops,
> > > +               RCUTORTURE_TASKS_OPS
> > >         };
> > >
> > >         if (!torture_init_begin(torture_type, verbose, &rcutorture_runnable))
> > > --
> > > 1.8.1.5
> > >
> > 
> > 
> > 
> > -- 
> > Pranith
> > 

