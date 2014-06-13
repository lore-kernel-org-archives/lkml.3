Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaFMCGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 22:06:03 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50756 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaFMCGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 22:06:01 -0400
Date: Thu, 12 Jun 2014 19:05:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] rcu: Only pin GP kthread when full dynticks is actually
 used
Message-ID: <20140613020554.GA9974@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402618619-32630-1-git-send-email-fweisbec@gmail.com>
 <20140613012432.GH4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613012432.GH4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061302-7164-0000-0000-0000026A2C06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 06:24:32PM -0700, Paul E. McKenney wrote:
> On Fri, Jun 13, 2014 at 02:16:59AM +0200, Frederic Weisbecker wrote:
> > CONFIG_NO_HZ_FULL may be enabled widely on distros nowadays but actual
> > users should be a tiny minority, if actually any.
> > 
> > Also there is a risk that affining the GP kthread to a single CPU could
> > end up noticeably reducing RCU performances and increasing energy
> > consumption.
> > 
> > So lets affine the GP kthread only when nohz full is actually used
> > (ie: when the nohz_full= parameter is filled or CONFIG_NO_HZ_FULL_ALL=y)
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Josh Triplett <josh@joshtriplett.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > ---
> >  kernel/rcu/tree_plugin.h | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index cbc2c45..726f52c 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -2843,12 +2843,16 @@ static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
> >   */
> >  static void rcu_bind_gp_kthread(void)
> >  {
> > -#ifdef CONFIG_NO_HZ_FULL
> > -	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
> > +	int cpu;
> > +
> > +	if (!tick_nohz_full_enabled())
> > +		return;
> > +
> > +	cpu = ACCESS_ONCE(tick_do_timer_cpu);
> > 
> >  	if (cpu < 0 || cpu >= nr_cpu_ids)
> >  		return;
> > +
> >  	if (raw_smp_processor_id() != cpu)
> >  		set_cpus_allowed_ptr(current, cpumask_of(cpu));
> > -#endif /* #ifdef CONFIG_NO_HZ_FULL */
> >  }
> 
> Hello, Frederic,
> 
> I have the following queued.  Shall I port yours on top of mine, or is
> there an issue with mine?

OK, I suppose I should show you what it looks like ported on top of mine.

I didn't understand the removal of "#ifdef CONFIG_NO_HZ_FULL", so I
left that.  I also didn't understand how dumping the GP kthreads onto
a single CPU could affect energy efficiency all that much, so I omitted
that from the commit log.  If I am missing something, please enlighten me.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Only pin GP kthread when full dynticks is actually used

CONFIG_NO_HZ_FULL is widely enabled in distros, but only a small fraction
of the users will be taking advantage of it.  Furthermore, there is
a risk that affining the GP kthread to a single CPU could noticeably
increase RCU grace-period latency.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index c93c525b71fe..2f5679791594 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2865,7 +2865,7 @@ static void rcu_bind_gp_kthread(void)
 #ifdef CONFIG_NO_HZ_FULL
 	int cpu = tick_do_timer_cpu;
 
-	if (cpu < 0 || cpu >= nr_cpu_ids)
+	if (cpu < 0 || cpu >= nr_cpu_ids || !tick_nohz_full_enabled())
 		return;
 #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
 	if (raw_smp_processor_id() != cpu)

