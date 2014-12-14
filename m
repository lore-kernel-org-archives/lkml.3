Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750764AbaLNRuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 12:50:17 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:37422 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaLNRuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 12:50:13 -0500
Date: Sun, 14 Dec 2014 09:50:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, David Lang <david@lang.hm>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141214175007.GA6927@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <alpine.DEB.2.02.1412121157060.18579@nftneq.ynat.uz>
 <20141212203417.GE25340@linux.vnet.ibm.com>
 <548B5CEC.1040607@oracle.com>
 <20141213083055.GI32572@gmail.com>
 <548C60FF.9020607@oracle.com>
 <20141213180752.GI25340@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141213180752.GI25340@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121417-0033-0000-0000-00000304163C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 10:07:52AM -0800, Paul E. McKenney wrote:
> On Sat, Dec 13, 2014 at 10:53:35AM -0500, Sasha Levin wrote:
> > On 12/13/2014 03:30 AM, Ingo Molnar wrote:
> > >> > This is my no_hz related config:
> > >> > 
> > >> > $ grep NO_HZ .config
> > >> > CONFIG_NO_HZ_COMMON=y
> > >> > # CONFIG_NO_HZ_IDLE is not set
> > >> > CONFIG_NO_HZ_FULL=y
> > >> > CONFIG_NO_HZ_FULL_ALL=y
> > > Just curious, if you disable NO_HZ_FULL_ALL, does the bug change?
> > 
> > On 12/13/2014 07:08 AM, Paul E. McKenney wrote:
> > > Alternatively, your could boot with nohz_full=2-27 (or maybe even
> > > nohz_full=4-27).  This will override CONFIG_NO_HZ_FULL_ALL=y and will
> > > provide two (or four with 4-27) housekeeping CPUs that are available to
> > > run things like RCU grace-period kthreads and RCU callback processing.
> > > This might allow RCU to get the CPU bandwidth it needs despite
> > > competition from your workload.
> > 
> > I've tried both nohz_full=4-27 and disabling CONFIG_NO_HZ_FULL_ALL
> > altogether, but I'm still seeing the stall:
> 
> And again looping in workqueues, despite the cond_resched_rcu_qs() there.
> And the reason for that is that cond_resched_rcu_qs() currently only
> provides quiescent states for tasks RCU.  I will put together something
> that makes it work for other RCU flavors.
> 
> Not that this is likely to do much about Dave Jones's lockup, but one
> thing at a time...

And here is a patch for this purpose that passes moderate rcutorture
testing.  Please note that this patch is designed to help the case you
were seeing, which is workqueues running indefinitely on the housekeeping
CPU, namely CPU 0.  If this also ends up happening on the other CPUs,
I will need to get you another CPU-kicking mechanism.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Make cond_resched_rcu_qs() apply to normal RCU flavors

Although cond_resched_rcu_qs() only applies to TASKS_RCU, it is used
in places where it would be useful for it to apply to the normal RCU
flavors, rcu_preempt, rcu_sched, and rcu_bh.  This is especially the
case for workloads that aggressively overload the system, particularly
those that generate large numbers of RCU updates on systems running
NO_HZ_FULL CPUs.  This commit therefore communicates quiescent states
from cond_resched_rcu_qs() to the normal RCU flavors.

Note that it is unfortunately necessary to leave the old ->passed_quiesce
mechanism in place to allow quiescent states that apply to only one
flavor to be recorded.  (Yes, we could decrement ->rcu_qs_ctr_snap in
that case, but that is not so good for debugging of RCU internals.)

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index b63b9bb3bc0c..08651da15448 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -56,14 +56,14 @@ rcuboost:
 
 The output of "cat rcu/rcu_preempt/rcudata" looks as follows:
 
-  0!c=30455 g=30456 pq=1 qp=1 dt=126535/140000000000000/0 df=2002 of=4 ql=0/0 qs=N... b=10 ci=74572 nci=0 co=1131 ca=716
-  1!c=30719 g=30720 pq=1 qp=0 dt=132007/140000000000000/0 df=1874 of=10 ql=0/0 qs=N... b=10 ci=123209 nci=0 co=685 ca=982
-  2!c=30150 g=30151 pq=1 qp=1 dt=138537/140000000000000/0 df=1707 of=8 ql=0/0 qs=N... b=10 ci=80132 nci=0 co=1328 ca=1458
-  3 c=31249 g=31250 pq=1 qp=0 dt=107255/140000000000000/0 df=1749 of=6 ql=0/450 qs=NRW. b=10 ci=151700 nci=0 co=509 ca=622
-  4!c=29502 g=29503 pq=1 qp=1 dt=83647/140000000000000/0 df=965 of=5 ql=0/0 qs=N... b=10 ci=65643 nci=0 co=1373 ca=1521
-  5 c=31201 g=31202 pq=1 qp=1 dt=70422/0/0 df=535 of=7 ql=0/0 qs=.... b=10 ci=58500 nci=0 co=764 ca=698
-  6!c=30253 g=30254 pq=1 qp=1 dt=95363/140000000000000/0 df=780 of=5 ql=0/0 qs=N... b=10 ci=100607 nci=0 co=1414 ca=1353
-  7 c=31178 g=31178 pq=1 qp=0 dt=91536/0/0 df=547 of=4 ql=0/0 qs=.... b=10 ci=109819 nci=0 co=1115 ca=969
+  0!c=30455 g=30456 pq=1/0 qp=1 dt=126535/140000000000000/0 df=2002 of=4 ql=0/0 qs=N... b=10 ci=74572 nci=0 co=1131 ca=716
+  1!c=30719 g=30720 pq=1/0 qp=0 dt=132007/140000000000000/0 df=1874 of=10 ql=0/0 qs=N... b=10 ci=123209 nci=0 co=685 ca=982
+  2!c=30150 g=30151 pq=1/1 qp=1 dt=138537/140000000000000/0 df=1707 of=8 ql=0/0 qs=N... b=10 ci=80132 nci=0 co=1328 ca=1458
+  3 c=31249 g=31250 pq=1/1 qp=0 dt=107255/140000000000000/0 df=1749 of=6 ql=0/450 qs=NRW. b=10 ci=151700 nci=0 co=509 ca=622
+  4!c=29502 g=29503 pq=1/0 qp=1 dt=83647/140000000000000/0 df=965 of=5 ql=0/0 qs=N... b=10 ci=65643 nci=0 co=1373 ca=1521
+  5 c=31201 g=31202 pq=1/0 qp=1 dt=70422/0/0 df=535 of=7 ql=0/0 qs=.... b=10 ci=58500 nci=0 co=764 ca=698
+  6!c=30253 g=30254 pq=1/0 qp=1 dt=95363/140000000000000/0 df=780 of=5 ql=0/0 qs=N... b=10 ci=100607 nci=0 co=1414 ca=1353
+  7 c=31178 g=31178 pq=1/0 qp=0 dt=91536/0/0 df=547 of=4 ql=0/0 qs=.... b=10 ci=109819 nci=0 co=1115 ca=969
 
 This file has one line per CPU, or eight for this 8-CPU system.
 The fields are as follows:
@@ -188,14 +188,14 @@ o	"ca" is the number of RCU callbacks that have been adopted by this
 Kernels compiled with CONFIG_RCU_BOOST=y display the following from
 /debug/rcu/rcu_preempt/rcudata:
 
-  0!c=12865 g=12866 pq=1 qp=1 dt=83113/140000000000000/0 df=288 of=11 ql=0/0 qs=N... kt=0/O ktl=944 b=10 ci=60709 nci=0 co=748 ca=871
-  1 c=14407 g=14408 pq=1 qp=0 dt=100679/140000000000000/0 df=378 of=7 ql=0/119 qs=NRW. kt=0/W ktl=9b6 b=10 ci=109740 nci=0 co=589 ca=485
-  2 c=14407 g=14408 pq=1 qp=0 dt=105486/0/0 df=90 of=9 ql=0/89 qs=NRW. kt=0/W ktl=c0c b=10 ci=83113 nci=0 co=533 ca=490
-  3 c=14407 g=14408 pq=1 qp=0 dt=107138/0/0 df=142 of=8 ql=0/188 qs=NRW. kt=0/W ktl=b96 b=10 ci=121114 nci=0 co=426 ca=290
-  4 c=14405 g=14406 pq=1 qp=1 dt=50238/0/0 df=706 of=7 ql=0/0 qs=.... kt=0/W ktl=812 b=10 ci=34929 nci=0 co=643 ca=114
-  5!c=14168 g=14169 pq=1 qp=0 dt=45465/140000000000000/0 df=161 of=11 ql=0/0 qs=N... kt=0/O ktl=b4d b=10 ci=47712 nci=0 co=677 ca=722
-  6 c=14404 g=14405 pq=1 qp=0 dt=59454/0/0 df=94 of=6 ql=0/0 qs=.... kt=0/W ktl=e57 b=10 ci=55597 nci=0 co=701 ca=811
-  7 c=14407 g=14408 pq=1 qp=1 dt=68850/0/0 df=31 of=8 ql=0/0 qs=.... kt=0/W ktl=14bd b=10 ci=77475 nci=0 co=508 ca=1042
+  0!c=12865 g=12866 pq=1/0 qp=1 dt=83113/140000000000000/0 df=288 of=11 ql=0/0 qs=N... kt=0/O ktl=944 b=10 ci=60709 nci=0 co=748 ca=871
+  1 c=14407 g=14408 pq=1/0 qp=0 dt=100679/140000000000000/0 df=378 of=7 ql=0/119 qs=NRW. kt=0/W ktl=9b6 b=10 ci=109740 nci=0 co=589 ca=485
+  2 c=14407 g=14408 pq=1/0 qp=0 dt=105486/0/0 df=90 of=9 ql=0/89 qs=NRW. kt=0/W ktl=c0c b=10 ci=83113 nci=0 co=533 ca=490
+  3 c=14407 g=14408 pq=1/0 qp=0 dt=107138/0/0 df=142 of=8 ql=0/188 qs=NRW. kt=0/W ktl=b96 b=10 ci=121114 nci=0 co=426 ca=290
+  4 c=14405 g=14406 pq=1/0 qp=1 dt=50238/0/0 df=706 of=7 ql=0/0 qs=.... kt=0/W ktl=812 b=10 ci=34929 nci=0 co=643 ca=114
+  5!c=14168 g=14169 pq=1/0 qp=0 dt=45465/140000000000000/0 df=161 of=11 ql=0/0 qs=N... kt=0/O ktl=b4d b=10 ci=47712 nci=0 co=677 ca=722
+  6 c=14404 g=14405 pq=1/0 qp=0 dt=59454/0/0 df=94 of=6 ql=0/0 qs=.... kt=0/W ktl=e57 b=10 ci=55597 nci=0 co=701 ca=811
+  7 c=14407 g=14408 pq=1/0 qp=1 dt=68850/0/0 df=31 of=8 ql=0/0 qs=.... kt=0/W ktl=14bd b=10 ci=77475 nci=0 co=508 ca=1042
 
 This is similar to the output discussed above, but contains the following
 additional fields:
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 386ba288084a..7f08f5079757 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -331,6 +331,7 @@ static inline void rcu_init_nohz(void)
 extern struct srcu_struct tasks_rcu_exit_srcu;
 #define rcu_note_voluntary_context_switch(t) \
 	do { \
+		rcu_all_qs(); \
 		if (ACCESS_ONCE((t)->rcu_tasks_holdout)) \
 			ACCESS_ONCE((t)->rcu_tasks_holdout) = false; \
 	} while (0)
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 984192160e9b..937edaeb150d 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -186,7 +186,10 @@ static inline bool rcu_is_watching(void)
 	return true;
 }
 
-
 #endif /* #else defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
 
+static inline void rcu_all_qs(void)
+{
+}
+
 #endif /* __LINUX_RCUTINY_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index c0dd124e69ec..fbfd61d40e73 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -100,4 +100,10 @@ extern int rcu_scheduler_active __read_mostly;
 
 bool rcu_is_watching(void);
 
+DECLARE_PER_CPU(unsigned long, rcu_qs_ctr);
+static inline void rcu_all_qs(void)
+{
+	this_cpu_inc(rcu_qs_ctr);
+}
+
 #endif /* __LINUX_RCUTREE_H */
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 57fd8f5bd1ad..58ea6bf55fd2 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -219,6 +219,9 @@ static DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 #endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 };
 
+DEFINE_PER_CPU_SHARED_ALIGNED(unsigned long, rcu_qs_ctr);
+EXPORT_PER_CPU_SYMBOL_GPL(rcu_qs_ctr);
+
 /*
  * Let the RCU core know that this CPU has gone through the scheduler,
  * which is a quiescent state.  This is called when the need for a
@@ -1630,6 +1633,7 @@ static bool __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp,
 		rdp->gpnum = rnp->gpnum;
 		trace_rcu_grace_period(rsp->name, rdp->gpnum, TPS("cpustart"));
 		rdp->passed_quiesce = 0;
+		rdp->rcu_qs_ctr_snap = __this_cpu_read(rcu_qs_ctr);
 		rdp->qs_pending = !!(rnp->qsmask & rdp->grpmask);
 		zero_cpu_stall_ticks(rdp);
 		ACCESS_ONCE(rdp->gpwrap) = false;
@@ -2096,8 +2100,10 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 	rnp = rdp->mynode;
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	smp_mb__after_unlock_lock();
-	if (rdp->passed_quiesce == 0 || rdp->gpnum != rnp->gpnum ||
-	    rnp->completed == rnp->gpnum || rdp->gpwrap) {
+	if ((rdp->passed_quiesce == 0 &&
+	     rdp->rcu_qs_ctr_snap == __this_cpu_read(rcu_qs_ctr)) ||
+	    rdp->gpnum != rnp->gpnum || rnp->completed == rnp->gpnum ||
+	    rdp->gpwrap) {
 
 		/*
 		 * The grace period in which this quiescent state was
@@ -2106,6 +2112,7 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 		 * within the current grace period.
 		 */
 		rdp->passed_quiesce = 0;	/* need qs for new gp. */
+		rdp->rcu_qs_ctr_snap = __this_cpu_read(rcu_qs_ctr);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -2150,7 +2157,8 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 	 * Was there a quiescent state since the beginning of the grace
 	 * period? If no, then exit and wait for the next call.
 	 */
-	if (!rdp->passed_quiesce)
+	if (!rdp->passed_quiesce &&
+	    rdp->rcu_qs_ctr_snap == __this_cpu_read(rcu_qs_ctr))
 		return;
 
 	/*
@@ -3206,9 +3214,12 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
 	if (rcu_scheduler_fully_active &&
-	    rdp->qs_pending && !rdp->passed_quiesce) {
+	    rdp->qs_pending && !rdp->passed_quiesce &&
+	    rdp->rcu_qs_ctr_snap == __this_cpu_read(rcu_qs_ctr)) {
 		rdp->n_rp_qs_pending++;
-	} else if (rdp->qs_pending && rdp->passed_quiesce) {
+	} else if (rdp->qs_pending &&
+		   (rdp->passed_quiesce ||
+		    rdp->rcu_qs_ctr_snap != __this_cpu_read(rcu_qs_ctr))) {
 		rdp->n_rp_report_qs++;
 		return 1;
 	}
@@ -3542,6 +3553,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 			rdp->gpnum = rnp->completed;
 			rdp->completed = rnp->completed;
 			rdp->passed_quiesce = 0;
+			rdp->rcu_qs_ctr_snap = __this_cpu_read(rcu_qs_ctr);
 			rdp->qs_pending = 0;
 			trace_rcu_grace_period(rsp->name, rdp->gpnum, TPS("cpuonl"));
 		}
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 4c156b43ff1a..f1dfc0bbb498 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -252,6 +252,8 @@ struct rcu_data {
 					/*  in order to detect GP end. */
 	unsigned long	gpnum;		/* Highest gp number that this CPU */
 					/*  is aware of having started. */
+	unsigned long	rcu_qs_ctr_snap;/* Snapshot of rcu_qs_ctr to check */
+					/*  for rcu_all_qs() invocations. */
 	bool		passed_quiesce;	/* User-mode/idle loop etc. */
 	bool		qs_pending;	/* Core waits for quiesc state. */
 	bool		beenonline;	/* CPU online at least once. */
diff --git a/kernel/rcu/tree_trace.c b/kernel/rcu/tree_trace.c
index 5cdc62e1beeb..4ec028a9987a 100644
--- a/kernel/rcu/tree_trace.c
+++ b/kernel/rcu/tree_trace.c
@@ -115,11 +115,13 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 
 	if (!rdp->beenonline)
 		return;
-	seq_printf(m, "%3d%cc=%ld g=%ld pq=%d qp=%d",
+	seq_printf(m, "%3d%cc=%ld g=%ld pq=%d/%d qp=%d",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
 		   ulong2long(rdp->completed), ulong2long(rdp->gpnum),
-		   rdp->passed_quiesce, rdp->qs_pending);
+		   rdp->passed_quiesce,
+		   rdp->rcu_qs_ctr_snap == __this_cpu_read(rcu_qs_ctr),
+		   rdp->qs_pending);
 	seq_printf(m, " dt=%d/%llx/%d df=%lu",
 		   atomic_read(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,

