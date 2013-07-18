Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab3GRAlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:41:49 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51213 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807Ab3GRAls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:41:48 -0400
Date: Wed, 17 Jul 2013 17:41:41 -0700
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
Message-ID: <20130718004141.GI4161@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130709012934.GA26058@linux.vnet.ibm.com>
 <1373333406-26979-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1373333406-26979-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130717233119.GA2801@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717233119.GA2801@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071800-3620-0000-0000-000003910EF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 01:31:21AM +0200, Frederic Weisbecker wrote:
> On Mon, Jul 08, 2013 at 06:30:05PM -0700, Paul E. McKenney wrote:
> >  }
> >  
> >  /*
> > + * Unconditionally force exit from full system-idle state.  This is
> > + * invoked when a normal CPU exits idle, but must be called separately
> > + * for the timekeeping CPU (tick_do_timer_cpu).  The reason for this
> > + * is that the timekeeping CPU is permitted to take scheduling-clock
> > + * interrupts while the system is in system-idle state, and of course
> > + * rcu_sysidle_exit() has no way of distinguishing a scheduling-clock
> > + * interrupt from any other type of interrupt.
> > + */
> > +void rcu_sysidle_force_exit(void)
> > +{
> > +	int oldstate = ACCESS_ONCE(full_sysidle_state);
> > +	int newoldstate;
> > +
> > +	/*
> > +	 * Each pass through the following loop attempts to exit full
> > +	 * system-idle state.  If contention proves to be a problem,
> > +	 * a trylock-based contention tree could be used here.
> > +	 */
> > +	while (oldstate > RCU_SYSIDLE_SHORT) {
> 
> I'm missing a key here.
> 
> Let's imagine that the timekeeper has finally set full_sysidle_state = RCU_SYSIDLE_FULL_NOTED
> with cmpxchg, what guarantees that this CPU is not seeing a stale RCU_SYSIDLE_SHORT value
> for example?

Good question!  Let's see if I have a reasonable answer.  ;-)

I am going to start with the large-CPU case, so that the state is advanced
only by the grace-period kthread.

1.	Case 1: the timekeeper CPU invoked rcu_sysidle_force_exit().
	In this case, this is the same CPU that set full_sysidle_state
	to RCU_SYSIDLE_FULL_NOTED, so it is guaranteed not to see a
	stale value.

2.	Case 2: Some CPU came out of idle, and invoked rcu_sysidle_exit().
	In this case, if this CPU reads a RCU_SYSIDLE_SHORT from
	full_sysidle_state, this read must have come before the
	cmpxchg() (on some other CPU) that set it to RCU_SYSIDLE_LONG.
	Because this CPU's read from full_sysidle_state was preceded by
	an atomic_inc() that updated this CPU's ->dynticks_idle, that
	update must also precede the cmpxchg() that set full_sysidle_state
	to RCU_SYSIDLE_LONG.  Because the state advancing is done from
	within a single thread, the subsequent scan is guaranteed to see
	the first CPU's update of ->dynticks_idle, and will therefore
	refrain from advancing full_sysidle_state to RCU_SYSIDLE_FULL.

	This will in turn prevent the timekeeping thread from advancing
	the state to RCU_SYSIDLE_FULL_NOTED, so this scenario cannot
	happen.

Unfortunately, the reasoning in #2 above does not hold in the small-CPU
case because there is the possibility of both the timekeeping CPU and
the RCU grace-period kthread concurrently advancing the state machine.
This would be bad, good catch!!!

The patch below (untested) is an attempt to fix this.  If it actually
works, I will merge it in with 6/7.

Anything else I missed?  ;-)

							Thanx, Paul

------------------------------------------------------------------------

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index aa3f525..fe83085 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1364,7 +1364,7 @@ int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 		}
 		force_qs_rnp(rsp, dyntick_save_progress_counter,
 			     &isidle, &maxj);
-		rcu_sysidle_report(rsp, isidle, maxj);
+		rcu_sysidle_report_gp(rsp, isidle, maxj);
 		fqs_state = RCU_FORCE_QS;
 	} else {
 		/* Handle dyntick-idle and offline CPUs. */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 1602c21..657b415 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -559,8 +559,8 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
 				  unsigned long *maxj);
 static bool is_sysidle_rcu_state(struct rcu_state *rsp);
 static void rcu_bind_gp_kthread(void);
-static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
-			       unsigned long maxj);
+static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
+				  unsigned long maxj);
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a4d44c3..f65d9c2 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2655,14 +2655,22 @@ static void rcu_sysidle_cancel(void)
  * scan of the CPUs' dyntick-idle state.
  */
 static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
-			       unsigned long maxj)
+			       unsigned long maxj, bool gpkt)
 {
 	if (rsp != rcu_sysidle_state)
 		return;  /* Wrong flavor, ignore. */
-	if (isidle)
-		rcu_sysidle(maxj);    /* More idle! */
-	else
+	if (isidle) {
+		if (gpkt && nr_cpu_ids > RCU_SYSIDLE_SMALL)
+			rcu_sysidle(maxj);    /* More idle! */
+	} else {
 		rcu_sysidle_cancel(); /* Idle is over. */
+	}
+}
+
+static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
+				  unsigned long maxj)
+{
+	rcu_sysidle_report(rsp, isidle, maxj, true);
 }
 
 /* Callback and function for forcing an RCU grace period. */
@@ -2713,7 +2721,8 @@ bool rcu_sys_is_idle(void)
 				if (!isidle)
 					break;
 			}
-			rcu_sysidle_report(rcu_sysidle_state, isidle, maxj);
+			rcu_sysidle_report(rcu_sysidle_state,
+					   isidle, maxj, false);
 			oldrss = rss;
 			rss = ACCESS_ONCE(full_sysidle_state);
 		}
@@ -2776,8 +2785,8 @@ static void rcu_bind_gp_kthread(void)
 {
 }
 
-static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
-			       unsigned long maxj)
+static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
+				  unsigned long maxj)
 {
 }
 

