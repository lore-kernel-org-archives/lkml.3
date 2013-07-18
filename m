Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab3GRDja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 23:39:30 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43404 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3GRDj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 23:39:28 -0400
Date: Wed, 17 Jul 2013 20:39:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 6/7] nohz_full: Add full-system-idle state
 machine
Message-ID: <20130718033921.GL4161@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130709012934.GA26058@linux.vnet.ibm.com>
 <1373333406-26979-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1373333406-26979-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130717233119.GA2801@somewhere>
 <20130718004141.GI4161@linux.vnet.ibm.com>
 <20130718013259.GA7398@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718013259.GA7398@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071803-3620-0000-0000-00000391894D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 03:33:01AM +0200, Frederic Weisbecker wrote:
> On Wed, Jul 17, 2013 at 05:41:41PM -0700, Paul E. McKenney wrote:
> > On Thu, Jul 18, 2013 at 01:31:21AM +0200, Frederic Weisbecker wrote:
> > > I'm missing a key here.
> > > 
> > > Let's imagine that the timekeeper has finally set full_sysidle_state = RCU_SYSIDLE_FULL_NOTED
> > > with cmpxchg, what guarantees that this CPU is not seeing a stale RCU_SYSIDLE_SHORT value
> > > for example?
> > 
> > Good question!  Let's see if I have a reasonable answer.  ;-)
> > 
> > I am going to start with the large-CPU case, so that the state is advanced
> > only by the grace-period kthread.
> > 
> > 1.	Case 1: the timekeeper CPU invoked rcu_sysidle_force_exit().
> > 	In this case, this is the same CPU that set full_sysidle_state
> > 	to RCU_SYSIDLE_FULL_NOTED, so it is guaranteed not to see a
> > 	stale value.
> > 
> > 2.	Case 2: Some CPU came out of idle, and invoked rcu_sysidle_exit().
> > 	In this case, if this CPU reads a RCU_SYSIDLE_SHORT from
> > 	full_sysidle_state, this read must have come before the
> > 	cmpxchg() (on some other CPU) that set it to RCU_SYSIDLE_LONG.
> > 	Because this CPU's read from full_sysidle_state was preceded by
> > 	an atomic_inc() that updated this CPU's ->dynticks_idle, that
> > 	update must also precede the cmpxchg() that set full_sysidle_state
> > 	to RCU_SYSIDLE_LONG.  Because the state advancing is done from
> > 	within a single thread, the subsequent scan is guaranteed to see
> > 	the first CPU's update of ->dynticks_idle, and will therefore
> > 	refrain from advancing full_sysidle_state to RCU_SYSIDLE_FULL.
> > 
> > 	This will in turn prevent the timekeeping thread from advancing
> > 	the state to RCU_SYSIDLE_FULL_NOTED, so this scenario cannot
> > 	happen.
> 
> Ok, so IIUC the safety is guaranteed in the following ordering:
> 
>     CPU 0                                               CPU 1
> 
>     idle = 1                                            smp_mb()
>     //for each cpu
>     if (atomic_read(rdp(1)->dyntick_idle) & 1)          atomic_inc(rdp->dyntick_idle)
>           idle = 0                                      smp_mb()
> 
>     if (idle)
>          cmpxchg(full_sysidle_state, SHORT, LONG)       while (full_sysidle_state > SHORT)
>                                                             //reset with cmpxchg
> 
> So it's like:
> 
>     CPU 0                                              CPU 1
> 
>     read I                                             write I
>     smp_mb()                                           smp_mb()
>     cmpxchg S                                          read S
> 
> I still can't find what guarantees we don't read a value in CPU 1 that is way below
> what we want.

One key point is that there is a second cycle from LONG to FULL.

(Not saying that there is not a bug -- there might well be.  In fact,
I am starting to think that I need to do another Promela model...)

> > Unfortunately, the reasoning in #2 above does not hold in the small-CPU
> > case because there is the possibility of both the timekeeping CPU and
> > the RCU grace-period kthread concurrently advancing the state machine.
> > This would be bad, good catch!!!
> 
> It's not like I spotted anything myself but you're welcome :)

I will take them any way I can get them.  ;-)

> > The patch below (untested) is an attempt to fix this.  If it actually
> > works, I will merge it in with 6/7.
> > 
> > Anything else I missed?  ;-)
> 
> Well I guess I'll wait one more night before trying to understand
> the below ;)

The key point is that the added check means that either the timekeeping
CPU is advancing the state machine (if there are few CPUs) or the
RCU grace-period kthread is (if there are many CPUs), but never both.
Or that is the intent, anyway!

							Thanx, Paul

>     Thanks!
> 
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index aa3f525..fe83085 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1364,7 +1364,7 @@ int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
> >  		}
> >  		force_qs_rnp(rsp, dyntick_save_progress_counter,
> >  			     &isidle, &maxj);
> > -		rcu_sysidle_report(rsp, isidle, maxj);
> > +		rcu_sysidle_report_gp(rsp, isidle, maxj);
> >  		fqs_state = RCU_FORCE_QS;
> >  	} else {
> >  		/* Handle dyntick-idle and offline CPUs. */
> > diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> > index 1602c21..657b415 100644
> > --- a/kernel/rcutree.h
> > +++ b/kernel/rcutree.h
> > @@ -559,8 +559,8 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
> >  				  unsigned long *maxj);
> >  static bool is_sysidle_rcu_state(struct rcu_state *rsp);
> >  static void rcu_bind_gp_kthread(void);
> > -static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
> > -			       unsigned long maxj);
> > +static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
> > +				  unsigned long maxj);
> >  static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
> >  
> >  #endif /* #ifndef RCU_TREE_NONCORE */
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index a4d44c3..f65d9c2 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -2655,14 +2655,22 @@ static void rcu_sysidle_cancel(void)
> >   * scan of the CPUs' dyntick-idle state.
> >   */
> >  static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
> > -			       unsigned long maxj)
> > +			       unsigned long maxj, bool gpkt)
> >  {
> >  	if (rsp != rcu_sysidle_state)
> >  		return;  /* Wrong flavor, ignore. */
> > -	if (isidle)
> > -		rcu_sysidle(maxj);    /* More idle! */
> > -	else
> > +	if (isidle) {
> > +		if (gpkt && nr_cpu_ids > RCU_SYSIDLE_SMALL)
> > +			rcu_sysidle(maxj);    /* More idle! */
> > +	} else {
> >  		rcu_sysidle_cancel(); /* Idle is over. */
> > +	}
> > +}
> > +
> > +static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
> > +				  unsigned long maxj)
> > +{
> > +	rcu_sysidle_report(rsp, isidle, maxj, true);
> >  }
> >  
> >  /* Callback and function for forcing an RCU grace period. */
> > @@ -2713,7 +2721,8 @@ bool rcu_sys_is_idle(void)
> >  				if (!isidle)
> >  					break;
> >  			}
> > -			rcu_sysidle_report(rcu_sysidle_state, isidle, maxj);
> > +			rcu_sysidle_report(rcu_sysidle_state,
> > +					   isidle, maxj, false);
> >  			oldrss = rss;
> >  			rss = ACCESS_ONCE(full_sysidle_state);
> >  		}
> > @@ -2776,8 +2785,8 @@ static void rcu_bind_gp_kthread(void)
> >  {
> >  }
> >  
> > -static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
> > -			       unsigned long maxj)
> > +static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
> > +				  unsigned long maxj)
> >  {
> >  }
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

