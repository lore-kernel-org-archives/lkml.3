Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbaLONFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 08:05:00 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:50779 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaLONE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 08:04:58 -0500
Date: Mon, 15 Dec 2014 04:56:41 -0800
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
Message-ID: <20141215125641.GA12673@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141212203417.GE25340@linux.vnet.ibm.com>
 <548B5CEC.1040607@oracle.com>
 <20141213083055.GI32572@gmail.com>
 <548C60FF.9020607@oracle.com>
 <20141213180752.GI25340@linux.vnet.ibm.com>
 <20141214175007.GA6927@linux.vnet.ibm.com>
 <548E214D.6040706@oracle.com>
 <20141215001123.GK5310@linux.vnet.ibm.com>
 <548E374D.1040003@oracle.com>
 <20141215063331.GL5310@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141215063331.GL5310@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121513-8236-0000-0000-000007C9AD3E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 10:33:31PM -0800, Paul E. McKenney wrote:
> On Sun, Dec 14, 2014 at 08:20:13PM -0500, Sasha Levin wrote:
> > On 12/14/2014 07:11 PM, Paul E. McKenney wrote:
> > >> Does it depend on anything not currently in -next? My build fails with
> > >> > 
> > >> > kernel/rcu/tree.c: In function ‘rcu_report_qs_rdp’:
> > >> > kernel/rcu/tree.c:2099:6: error: ‘struct rcu_data’ has no member named ‘gpwrap’
> > >> >    rdp->gpwrap) {
> > > Indeed it does.  Please see below for a port to current mainline.
> > 
> > With the patch:
> > 
> > 
> > [  620.340045] INFO: rcu_preempt detected stalls on CPUs/tasks:
> > [  620.341087]  (detected by 22, t=8407 jiffies, g=10452, c=10451, q=3622)
> > [  620.342154] All QSes seen, last rcu_preempt kthread activity 4294990929/4294999330, jiffies_till_next_fqs=1
> 
> OK, 8401 jiffies since the grace-period kthread ran.  This is without
> the "Run grace-period kthreads at real-time priority" patch?
> 
> > [  643.710049] INFO: rcu_preempt detected stalls on CPUs/tasks:
> > [  643.710073] INFO: rcu_sched detected stalls on CPUs/tasks:
> > [  643.710093]  0: (6 ticks this GP) idle=bd5/140000000000002/0 softirq=12421/12421 fqs=0 last_accelerate: 5283/8643, nonlazy_posted: 643841, ..
> > [  643.710110]  (detected by 1, t=2102 jiffies, g=-292, c=-293, q=0)
> 
> But this one is real.
> 
> > [  643.710112] Task dump for CPU 0:
> > [  643.710129] kworker/0:1     R  running task    13016   628      2 0x10080008
> > [  643.710148] Workqueue: events vmstat_update
> > [  643.710156]  ffffffffb0301dc4 ffff88006be15000 ffff880060ba1c70 0000000000000000
> > [  643.710161]  ffff88006be10680 ffff8800633efde8 ffffffffa0461f1b ffff88006a776000
> > [  643.710166]  ffff880060ba1cb8 ffff880060ba1c78 ffff880060ba1c80 ffff880060ba1c90
> > [  643.710168] Call Trace:
> > [  643.710181]  [<ffffffffb0301dc4>] ? _raw_spin_unlock_irq+0x64/0x200
> > [  643.710191]  [<ffffffffa0461f1b>] ? process_one_work+0x5fb/0x1660
> > [  643.710197]  [<ffffffffa0463545>] ? worker_thread+0x5c5/0x1680
> > [  643.710205]  [<ffffffffb02f0b6f>] ? __schedule+0xf6f/0x2fc0
> > [  643.710211]  [<ffffffffa0462f80>] ? process_one_work+0x1660/0x1660
> > [  643.710216]  [<ffffffffa047ae22>] ? kthread+0x1f2/0x2b0
> > [  643.710221]  [<ffffffffa047ac30>] ? kthread_worker_fn+0x6a0/0x6a0
> > [  643.710226]  [<ffffffffb030243c>] ? ret_from_fork+0x7c/0xb0
> > [  643.710233]  [<ffffffffa047ac30>] ? kthread_worker_fn+0x6a0/0x6a0
> 
> Which in theory should have been addressed by the "Make
> cond_resched_rcu_qs() apply to normal RCU flavors" patch,
> given that this is CPU 0, which should be taking scheduling
> clock interrupts.  Well, I guess that theory and practice
> are only the same in theory.  :-/
> 
> Will dig into it more.

And maybe it would help if I did the CONFIG_TASKS_RCU=n case as well as
the CONFIG_TASKS_RCU=y case.  Please see below for an updated patch.

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
index ed4f5939a452..aa894d4fe375 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -331,12 +331,13 @@ static inline void rcu_init_nohz(void)
 extern struct srcu_struct tasks_rcu_exit_srcu;
 #define rcu_note_voluntary_context_switch(t) \
 	do { \
+		rcu_all_qs(); \
 		if (ACCESS_ONCE((t)->rcu_tasks_holdout)) \
 			ACCESS_ONCE((t)->rcu_tasks_holdout) = false; \
 	} while (0)
 #else /* #ifdef CONFIG_TASKS_RCU */
 #define TASKS_RCU(x) do { } while (0)
-#define rcu_note_voluntary_context_switch(t)	do { } while (0)
+#define rcu_note_voluntary_context_switch(t)	do { rcu_do_qs(); } while (0)
 #endif /* #else #ifdef CONFIG_TASKS_RCU */
 
 /**
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 0e5366200154..fabd3fad8516 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -154,7 +154,10 @@ static inline bool rcu_is_watching(void)
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
index 52953790dcca..3344783af1f2 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -97,4 +97,10 @@ extern int rcu_scheduler_active __read_mostly;
 
 bool rcu_is_watching(void);
 
+DECLARE_PER_CPU(unsigned long, rcu_qs_ctr);
+static inline void rcu_all_qs(void)
+{
+	this_cpu_inc(rcu_qs_ctr);
+}
+
 #endif /* __LINUX_RCUTREE_H */
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 7680fc275036..38f0009b999b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -215,6 +215,9 @@ static DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 #endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 };
 
+DEFINE_PER_CPU_SHARED_ALIGNED(unsigned long, rcu_qs_ctr);
+EXPORT_PER_CPU_SYMBOL_GPL(rcu_qs_ctr);
+
 /*
  * Let the RCU core know that this CPU has gone through the scheduler,
  * which is a quiescent state.  This is called when the need for a
@@ -1554,6 +1557,7 @@ static bool __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp,
 		rdp->gpnum = rnp->gpnum;
 		trace_rcu_grace_period(rsp->name, rdp->gpnum, TPS("cpustart"));
 		rdp->passed_quiesce = 0;
+		rdp->rcu_qs_ctr_snap = __this_cpu_read(rcu_qs_ctr);
 		rdp->qs_pending = !!(rnp->qsmask & rdp->grpmask);
 		zero_cpu_stall_ticks(rdp);
 	}
@@ -2020,6 +2024,7 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 		 * within the current grace period.
 		 */
 		rdp->passed_quiesce = 0;	/* need qs for new gp. */
+		rdp->rcu_qs_ctr_snap = __this_cpu_read(rcu_qs_ctr);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -2064,7 +2069,8 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 	 * Was there a quiescent state since the beginning of the grace
 	 * period? If no, then exit and wait for the next call.
 	 */
-	if (!rdp->passed_quiesce)
+	if (!rdp->passed_quiesce &&
+	    rdp->rcu_qs_ctr_snap == __this_cpu_read(rcu_qs_ctr))
 		return;
 
 	/*
@@ -3109,9 +3115,12 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 
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
@@ -3444,6 +3453,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 			rdp->gpnum = rnp->completed;
 			rdp->completed = rnp->completed;
 			rdp->passed_quiesce = 0;
+			rdp->rcu_qs_ctr_snap = __this_cpu_read(rcu_qs_ctr);
 			rdp->qs_pending = 0;
 			trace_rcu_grace_period(rsp->name, rdp->gpnum, TPS("cpuonl"));
 		}
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 8e7b1843896e..c259a0bc0d97 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -257,6 +257,8 @@ struct rcu_data {
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

