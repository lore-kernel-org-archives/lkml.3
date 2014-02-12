Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaBLQj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:39:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43279 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaBLQj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:39:26 -0500
Date: Wed, 12 Feb 2014 17:39:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Too many rescheduling interrupts (still!)
Message-ID: <20140212163916.GA27965@twins.programming.kicks-ass.net>
References: <CALCETrVL44ewQPJXNwPAm2s5aj9auo2p4tYYieNcxANoL91VWw@mail.gmail.com>
 <alpine.DEB.2.02.1402112219160.21991@ionos.tec.linutronix.de>
 <CALCETrUPyG1HoXFToXuVLOzX2f20zzxJyABKASOUPY691JmjMA@mail.gmail.com>
 <20140212101324.GC3545@laptop.programming.kicks-ass.net>
 <CALCETrW-GCNuqSTO=p==0gPE2c8wZKSe98Gi4PP2NRdgk5iKag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW-GCNuqSTO=p==0gPE2c8wZKSe98Gi4PP2NRdgk5iKag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 07:49:07AM -0800, Andy Lutomirski wrote:
> On Wed, Feb 12, 2014 at 2:13 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Feb 11, 2014 at 02:34:11PM -0800, Andy Lutomirski wrote:
> >> On Tue, Feb 11, 2014 at 1:21 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> >> A small number of reschedule interrupts appear to be due to a race:
> >> >> both resched_task and wake_up_idle_cpu do, essentially:
> >> >>
> >> >> set_tsk_need_resched(t);
> >> >> smb_mb();
> >> >> if (!tsk_is_polling(t))
> >> >>   smp_send_reschedule(cpu);
> >> >>
> >> >> The problem is that set_tsk_need_resched wakes the CPU and, if the CPU
> >> >> is too quick (which isn't surprising if it was in C0 or C1), then it
> >> >> could *clear* TS_POLLING before tsk_is_polling is read.
> >
> > Yeah we have the wrong default for the idle loops.. it should default to
> > polling and only switch to !polling at the very last moment if it really
> > needs an interrupt to wake.
> 
> I might be missing something, but won't that break the scheduler? 

for the idle task.. all other tasks will have it !polling.

But note how the current generic idle loop does:

  if (!current_clr_polling_and_test()) {
  	...
	if (cpuidle_idle_call())
		arch_cpu_idle();
	...
  }

This means that it still runs a metric ton of code, right up to the
mwait with !polling, and then at the mwait we switch it back to polling.

Completely daft.

> Since rq->lock is held, the resched calls could check the rq state
> (curr == idle, maybe) to distinguish these cases.

Not enough; but I'm afraid I confused you with the above.

My suggestion was really more that we should call into the cpuidle/arch
idle code with polling set, and only right before we hit hlt/wfi/etc..
should we clear the polling bit.

> > It can't we're holding its rq->lock.
> 
> Exactly.  AFAICT the only reason that any of this code holds rq->lock
> (especially ttwu_queue_remote, which I seem to call a few thousand
> times per second) is because the only way to make a cpu reschedule
> involves playing with per-task flags.  If the flags were per-rq or
> per-cpu instead, then rq->lock wouldn't be needed.  If this were all
> done locklessly, then I think either a full cmpxchg or some fairly
> careful use of full barriers would be needed, but I bet that cmpxchg
> is still considerably faster than a spinlock plus a set_bit.

Ahh, that's what you're saying. Yes we should be able to do something
clever there.

Something like the below is I think as close as we can come without
major surgery and moving TIF_NEED_RESCHED and POLLING into a per-cpu
variable.

I might have messed it up though; brain seems to have given out for the
day :/

---
 kernel/sched/core.c  | 17 +++++++++++++----
 kernel/sched/idle.c  | 21 +++++++++++++--------
 kernel/sched/sched.h |  5 ++++-
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fb9764fbc537..a5b64040c21d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -529,7 +529,7 @@ void resched_task(struct task_struct *p)
 	}
 
 	/* NEED_RESCHED must be visible before we test polling */
-	smp_mb();
+	smp_mb__after_clear_bit();
 	if (!tsk_is_polling(p))
 		smp_send_reschedule(cpu);
 }
@@ -1476,12 +1476,15 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 }
 
 #ifdef CONFIG_SMP
-static void sched_ttwu_pending(void)
+void sched_ttwu_pending(void)
 {
 	struct rq *rq = this_rq();
 	struct llist_node *llist = llist_del_all(&rq->wake_list);
 	struct task_struct *p;
 
+	if (!llist)
+		return;
+
 	raw_spin_lock(&rq->lock);
 
 	while (llist) {
@@ -1536,8 +1539,14 @@ void scheduler_ipi(void)
 
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
 {
-	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
-		smp_send_reschedule(cpu);
+	struct rq *rq = cpu_rq(cpu);
+
+	if (llist_add(&p->wake_entry, &rq->wake_list)) {
+		set_tsk_need_resched(rq->idle);
+		smp_mb__after_clear_bit();
+		if (!tsk_is_polling(rq->idle) || rq->curr != rq->idle)
+			smp_send_reschedule(cpu);
+	}
 }
 
 bool cpus_share_cache(int this_cpu, int that_cpu)
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 14ca43430aee..bd8ed2d2f2f7 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -105,19 +105,24 @@ static void cpu_idle_loop(void)
 				} else {
 					local_irq_enable();
 				}
-				__current_set_polling();
 			}
 			arch_cpu_idle_exit();
-			/*
-			 * We need to test and propagate the TIF_NEED_RESCHED
-			 * bit here because we might not have send the
-			 * reschedule IPI to idle tasks.
-			 */
-			if (tif_need_resched())
-				set_preempt_need_resched();
 		}
+
+		/*
+		 * We must clear polling before running sched_ttwu_pending().
+		 * Otherwise it becomes possible to have entries added in
+		 * ttwu_queue_remote() and still not get an IPI to process
+		 * them.
+		 */
+		__current_clr_polling();
+
+		set_preempt_need_resched();
+		sched_ttwu_pending();
+
 		tick_nohz_idle_exit();
 		schedule_preempt_disabled();
+		__current_set_polling();
 	}
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1bf34c257d3b..b59dbdb135d8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1157,9 +1157,10 @@ extern const struct sched_class rt_sched_class;
 extern const struct sched_class fair_sched_class;
 extern const struct sched_class idle_sched_class;
 
-
 #ifdef CONFIG_SMP
 
+extern void sched_ttwu_pending(void)
+
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
@@ -1170,6 +1171,8 @@ extern void idle_exit_fair(struct rq *this_rq);
 
 #else	/* CONFIG_SMP */
 
+static inline void sched_ttwu_pending(void) { }
+
 static inline void idle_balance(int cpu, struct rq *rq)
 {
 }
