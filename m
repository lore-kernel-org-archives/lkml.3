Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3EUVKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 17:10:49 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:60265 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3EUVKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 17:10:48 -0400
Date: Tue, 21 May 2013 14:09:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 13/13] rcu: Shrink TINY_RCU by reworking
 CPU-stall ifdefs
Message-ID: <20130521210957.GV3578@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130520145751.GA32218@linux.vnet.ibm.com>
 <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1369061900-546-13-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130521173140.GA3878@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521173140.GA3878@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052121-5518-0000-0000-00000EE29E6E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 10:31:41AM -0700, Josh Triplett wrote:
> On Mon, May 20, 2013 at 07:58:20AM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > TINY_RCU's reset_cpu_stall_ticks() and check_cpu_stalls() functions
> > are defined unconditionally, and are empty functions if CONFIG_RCU_TRACE
> > is disabled (which in turns disables detection of RCU CPU stalls).
> > These empty functions can add a bit of bloat to TINY_RCU, so this
> > commit reworks the ifdefs so that these functions are defined only
> > if they actually do something.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Strange.  Both of these functions are static, and called in only one
> place, so shouldn't the compiler inline them (and thus throw them away
> completely when empty)?  Why does it not do so?

Good point for most architectures.  But given Tiny RCU's purpose, it
should allow for stupid compilers.  And I do need to fix the commit
message to call out the other benefit, namely saving a couple of
lines of source code.

							Thanx, Paul

> - Josh Triplett
> 
> > ---
> >  kernel/rcutiny.c        | 4 ++--
> >  kernel/rcutiny_plugin.h | 6 ++----
> >  2 files changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> > index 4adc9e2..aa34411 100644
> > --- a/kernel/rcutiny.c
> > +++ b/kernel/rcutiny.c
> > @@ -204,7 +204,7 @@ static int rcu_is_cpu_rrupt_from_idle(void)
> >   */
> >  static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
> >  {
> > -	reset_cpu_stall_ticks(rcp);
> > +	RCU_TRACE(reset_cpu_stall_ticks(rcp));
> >  	if (rcp->rcucblist != NULL &&
> >  	    rcp->donetail != rcp->curtail) {
> >  		rcp->donetail = rcp->curtail;
> > @@ -251,7 +251,7 @@ void rcu_bh_qs(int cpu)
> >   */
> >  void rcu_check_callbacks(int cpu, int user)
> >  {
> > -	check_cpu_stalls();
> > +	RCU_TRACE(check_cpu_stalls());
> >  	if (user || rcu_is_cpu_rrupt_from_idle())
> >  		rcu_sched_qs(cpu);
> >  	else if (!in_softirq())
> > diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
> > index 65ef180..0cd385a 100644
> > --- a/kernel/rcutiny_plugin.h
> > +++ b/kernel/rcutiny_plugin.h
> > @@ -158,15 +158,11 @@ static void check_cpu_stall(struct rcu_ctrlblk *rcp)
> >  		rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
> >  }
> >  
> > -#endif /* #ifdef CONFIG_RCU_TRACE */
> > -
> >  static void reset_cpu_stall_ticks(struct rcu_ctrlblk *rcp)
> >  {
> > -#ifdef CONFIG_RCU_TRACE
> >  	rcp->ticks_this_gp = 0;
> >  	rcp->gp_start = jiffies;
> >  	rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
> > -#endif /* #ifdef CONFIG_RCU_TRACE */
> >  }
> >  
> >  static void check_cpu_stalls(void)
> > @@ -174,3 +170,5 @@ static void check_cpu_stalls(void)
> >  	RCU_TRACE(check_cpu_stall(&rcu_bh_ctrlblk));
> >  	RCU_TRACE(check_cpu_stall(&rcu_sched_ctrlblk));
> >  }
> > +
> > +#endif /* #ifdef CONFIG_RCU_TRACE */
> > -- 
> > 1.8.1.5
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

