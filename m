Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaFMPz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:55:56 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45554 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaFMPzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:55:55 -0400
Date: Fri, 13 Jun 2014 08:55:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] rcu: Only pin GP kthread when full dynticks is actually
 used
Message-ID: <20140613155548.GN4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402618619-32630-1-git-send-email-fweisbec@gmail.com>
 <20140613012432.GH4581@linux.vnet.ibm.com>
 <20140613020554.GA9974@linux.vnet.ibm.com>
 <20140613125543.GD6635@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613125543.GD6635@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061315-0928-0000-0000-000002AEAF87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 02:55:45PM +0200, Frederic Weisbecker wrote:
> On Thu, Jun 12, 2014 at 07:05:54PM -0700, Paul E. McKenney wrote:
> > On Thu, Jun 12, 2014 at 06:24:32PM -0700, Paul E. McKenney wrote:
> > > On Fri, Jun 13, 2014 at 02:16:59AM +0200, Frederic Weisbecker wrote:
> > > > CONFIG_NO_HZ_FULL may be enabled widely on distros nowadays but actual
> > > > users should be a tiny minority, if actually any.
> > > > 
> > > > Also there is a risk that affining the GP kthread to a single CPU could
> > > > end up noticeably reducing RCU performances and increasing energy
> > > > consumption.
> > > > 
> > > > So lets affine the GP kthread only when nohz full is actually used
> > > > (ie: when the nohz_full= parameter is filled or CONFIG_NO_HZ_FULL_ALL=y)
> > > > 
> > > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > > Cc: Josh Triplett <josh@joshtriplett.org>
> > > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > > ---
> > > >  kernel/rcu/tree_plugin.h | 10 +++++++---
> > > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > > > index cbc2c45..726f52c 100644
> > > > --- a/kernel/rcu/tree_plugin.h
> > > > +++ b/kernel/rcu/tree_plugin.h
> > > > @@ -2843,12 +2843,16 @@ static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
> > > >   */
> > > >  static void rcu_bind_gp_kthread(void)
> > > >  {
> > > > -#ifdef CONFIG_NO_HZ_FULL
> > > > -	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
> > > > +	int cpu;
> > > > +
> > > > +	if (!tick_nohz_full_enabled())
> > > > +		return;
> > > > +
> > > > +	cpu = ACCESS_ONCE(tick_do_timer_cpu);
> > > > 
> > > >  	if (cpu < 0 || cpu >= nr_cpu_ids)
> > > >  		return;
> > > > +
> > > >  	if (raw_smp_processor_id() != cpu)
> > > >  		set_cpus_allowed_ptr(current, cpumask_of(cpu));
> > > > -#endif /* #ifdef CONFIG_NO_HZ_FULL */
> > > >  }
> > > 
> > > Hello, Frederic,
> > > 
> > > I have the following queued.  Shall I port yours on top of mine, or is
> > > there an issue with mine?
> > 
> > OK, I suppose I should show you what it looks like ported on top of mine.
> 
> No need to keep my patch as long as yours goes in. It fixes all the issue.
> 
> > 
> > I didn't understand the removal of "#ifdef CONFIG_NO_HZ_FULL", so I
> > left that.
> 
> Yeah that's because the:
> 
>       if (!tick_nohz_full_enabled())
>            return;
> 
> returns unconditionally if CONFIG_NO_HZ_FULL=n. So the whole function
> becomes dead code that should be detected and removed by gcc. So same
> result as with the ifdef.

Well, that part of your patch is worthwhile, then!  And I do therefore
need to restructure to invoke tick_nohz_full_enabled() at the very
beginning of the function.

> > I also didn't understand how dumping the GP kthreads onto
> > a single CPU could affect energy efficiency all that much, so I omitted
> > that from the commit log.  If I am missing something, please enlighten me.
> 
> Because if the kthread is pinned to CPU 0 and a grace period is in progress,
> the kthread is going to disturb the CPU 0 regardless of its possibly deep sleep
> state. OTOH if the kthread is widely affine, it can be scheduled to idle CPUs
> that are less cold and thus wake them from less deep power state.
> 
> Well that all assuming that the scheduler takes care of these deep idle state.
> But I believe it does iirc...

My guess is that enough stuff gets dumped on CPU 0 to make this a non-issue,
but point taken nonetheless.

							Thanx, Paul

