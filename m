Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaLOALj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 19:11:39 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35247 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaLOALa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 19:11:30 -0500
Date: Sun, 14 Dec 2014 16:11:23 -0800
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
Message-ID: <20141215001123.GK5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <alpine.DEB.2.02.1412121157060.18579@nftneq.ynat.uz>
 <20141212203417.GE25340@linux.vnet.ibm.com>
 <548B5CEC.1040607@oracle.com>
 <20141213083055.GI32572@gmail.com>
 <548C60FF.9020607@oracle.com>
 <20141213180752.GI25340@linux.vnet.ibm.com>
 <20141214175007.GA6927@linux.vnet.ibm.com>
 <548E214D.6040706@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <548E214D.6040706@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121500-0009-0000-0000-000007240A5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 06:46:21PM -0500, Sasha Levin wrote:
> On 12/14/2014 12:50 PM, Paul E. McKenney wrote:
> > rcu: Make cond_resched_rcu_qs() apply to normal RCU flavors
> > 
> > Although cond_resched_rcu_qs() only applies to TASKS_RCU, it is used
> > in places where it would be useful for it to apply to the normal RCU
> > flavors, rcu_preempt, rcu_sched, and rcu_bh.  This is especially the
> > case for workloads that aggressively overload the system, particularly
> > those that generate large numbers of RCU updates on systems running
> > NO_HZ_FULL CPUs.  This commit therefore communicates quiescent states
> > from cond_resched_rcu_qs() to the normal RCU flavors.
> > 
> > Note that it is unfortunately necessary to leave the old ->passed_quiesce
> > mechanism in place to allow quiescent states that apply to only one
> > flavor to be recorded.  (Yes, we could decrement ->rcu_qs_ctr_snap in
> > that case, but that is not so good for debugging of RCU internals.)
> > 
> > Reported-by: Sasha Levin <sasha.levin@oracle.com>
> > Reported-by: Dave Jones <davej@redhat.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Does it depend on anything not currently in -next? My build fails with
> 
> kernel/rcu/tree.c: In function ‘rcu_report_qs_rdp’:
> kernel/rcu/tree.c:2099:6: error: ‘struct rcu_data’ has no member named ‘gpwrap’
>    rdp->gpwrap) {

Indeed it does.  Please see below for a port to current mainline.

> On an unrelated subject, I've tried disabling preemption, and am seeing different
> stalls even when I have the testfiles fuzzing in trinity disabled (which means I'm
> not seeing hangs in the preempt case):
> 
> [  332.920142] INFO: rcu_sched self-detected stall on CPU
> [  332.920142] 	19: (2099 ticks this GP) idle=f7d/140000000000001/0 softirq=21726/21726 fqs=1751
> [  332.920142] 	 (t=2100 jiffies g=10656 c=10655 q=212427)

More than 200K RCU callbacks queued.  Impressive!  ;-)

> [  332.920142] Task dump for CPU 19:
> [  332.920142] trinity-c522    R  running task    13544  9447   8279 0x1008000a
> [  332.920142]  00000000000034e8 00000000000034e8 ffff8808a678a000 ffff8808bc203c18
> [  332.920142]  ffffffff814b66f6 dfffe900000054de 0000000000000013 ffff8808bc215800
> [  332.920142]  0000000000000013 ffffffff9cb5d018 dfffe90000000000 ffff8808bc203c48
> [  332.920142] Call Trace:
> [  332.920142] <IRQ> sched_show_task (kernel/sched/core.c:4541)
> [  332.920142] dump_cpu_task (kernel/sched/core.c:8383)
> [  332.940081] INFO: rcu_sched detected stalls on CPUs/tasks:
> [  332.920142] rcu_dump_cpu_stacks (kernel/rcu/tree.c:1093)
> [  332.920142] rcu_check_callbacks (kernel/rcu/tree.c:1199 kernel/rcu/tree.c:1261 kernel/rcu/tree.c:3194 kernel/rcu/tree.c:3254 kernel/rcu/tree.c:2507)
> [  332.920142] update_process_times (./arch/x86/include/asm/preempt.h:22 kernel/time/timer.c:1386)
> [  332.920142] tick_sched_timer (kernel/time/tick-sched.c:152 kernel/time/tick-sched.c:1128)
> [  332.920142] __run_hrtimer (kernel/time/hrtimer.c:1216 (discriminator 3))
> [  332.920142] ? tick_init_highres (kernel/time/tick-sched.c:1115)
> [  332.920142] hrtimer_interrupt (include/linux/timerqueue.h:37 kernel/time/hrtimer.c:1275)
> [  332.920142] ? acct_account_cputime (kernel/tsacct.c:168)
> [  332.920142] local_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:921)
> [  332.920142] smp_apic_timer_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/apic/apic.c:945)
> [  332.920142] apic_timer_interrupt (arch/x86/kernel/entry_64.S:983)
> [  332.920142] <EOI> ? retint_restore_args (arch/x86/kernel/entry_64.S:844)
> [  332.920142] ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
> [  332.920142] __debug_check_no_obj_freed (lib/debugobjects.c:713)
> [  332.920142] debug_check_no_obj_freed (lib/debugobjects.c:727)
> [  332.920142] free_pages_prepare (mm/page_alloc.c:829)
> [  332.920142] free_hot_cold_page (mm/page_alloc.c:1496)
> [  332.920142] __free_pages (mm/page_alloc.c:2982)

If this still appears after applying the below patch, I would be tempted
to place a few cond_resched_rcu_qs() calls in the above three functions.

							Thanx, Paul

> [  332.920142] ? __vunmap (mm/vmalloc.c:1459 (discriminator 2))
> [  332.920142] __vunmap (mm/vmalloc.c:1455 (discriminator 2))
> [  332.920142] vfree (mm/vmalloc.c:1500)
> [  332.920142] SyS_init_module (kernel/module.c:2483 kernel/module.c:3359 kernel/module.c:3346)
> [  332.920142] ia32_do_call (arch/x86/ia32/ia32entry.S:446)

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
index ed4f5939a452..04eb366ab7fa 100644
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

