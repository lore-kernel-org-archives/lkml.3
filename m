Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaFEHMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:12:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:50538 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaFEHMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:12:53 -0400
Date: Thu, 5 Jun 2014 09:12:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        lenb@kernel.org, mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        arjan@linux.intel.com, rui.zhang@intel.com, luto@amacapital.net
Subject: Re: [PATCH] idle, thermal, acpi: Remove home grown idle
 implementations
Message-ID: <20140605071247.GC3213@twins.programming.kicks-ass.net>
References: <20140604085418.GA11096@twins.programming.kicks-ass.net>
 <20140604015812.140a00d1@jacob-desktop>
 <1509308.hu7EZQqxxC@vostro.rjw.lan>
 <20140604155920.3fd4e94d@ultegra>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline
In-Reply-To: <20140604155920.3fd4e94d@ultegra>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 03:59:20PM -0700, Jacob Pan wrote:
> Sounds good. Let me test/integrate Peter's patch with PM QoS change,
> powerclamp and acpipad then come up with a patchset.

Slight change since yesterday, it applies on top of:

  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git sched/core

Note that that tree isn't stable, its generated from my quilt series and
completely regenerated every time I update.

Ideally those things would soon make their wait into tip, but Ingo's
busy with real life stuff for a bit.

---
Subject: idle, thermal, acpi: Remove home grown idle implementations
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Wed Nov 20 14:32:37 CET 2013

People are starting to grow their own idle implementations in various
disgusting ways. Collapse the lot and use the generic idle code to
provide a proper idle cycle implementation.

This does not fully preseve existing behaviour in that the generic
idle cycle function calls into the normal cpuidle governed idle
routines and should thus respect things like QoS parameters and the
like.

If people want to over-ride the idle state they should talk to the
cpuidle folks about extending the interface and attempt to preserve
QoS guarantees, instead of jumping straight to the deepest possible C
state -- Jacub Pan said he was going to do this.

This is reported to work for intel_powerclamp by Jacub Pan, the
acpi_pad driver is untested.

Cc: rui.zhang@intel.com
Cc: jacob.jun.pan@linux.intel.com
Cc: lenb@kernel.org
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: hpa@zytor.com
Cc: arjan@linux.intel.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 drivers/acpi/acpi_pad.c            |   41 ----------
 drivers/thermal/intel_powerclamp.c |   38 ---------
 include/linux/cpu.h                |    2=20
 include/linux/sched.h              |    3=20
 kernel/sched/core.c                |    1=20
 kernel/sched/idle.c                |  143 ++++++++++++++++++++++----------=
-----
 kernel/time/tick-sched.c           |    2=20
 kernel/trace/trace_irqsoff.c       |    2=20
 8 files changed, 97 insertions(+), 135 deletions(-)

--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -40,9 +40,7 @@ static DEFINE_MUTEX(round_robin_lock);
 static unsigned long power_saving_mwait_eax;
=20
 static unsigned char tsc_detected_unstable;
-static unsigned char tsc_marked_unstable;
 static unsigned char lapic_detected_unstable;
-static unsigned char lapic_marked_unstable;
=20
 static void power_saving_mwait_init(void)
 {
@@ -152,10 +150,9 @@ static int power_saving_thread(void *dat
 	unsigned int tsk_index =3D (unsigned long)data;
 	u64 last_jiffies =3D 0;
=20
-	sched_setscheduler(current, SCHED_RR, &param);
+	sched_setscheduler(current, SCHED_FIFO, &param);
=20
 	while (!kthread_should_stop()) {
-		int cpu;
 		u64 expire_time;
=20
 		try_to_freeze();
@@ -170,41 +167,7 @@ static int power_saving_thread(void *dat
=20
 		expire_time =3D jiffies + HZ * (100 - idle_pct) / 100;
=20
-		while (!need_resched()) {
-			if (tsc_detected_unstable && !tsc_marked_unstable) {
-				/* TSC could halt in idle, so notify users */
-				mark_tsc_unstable("TSC halts in idle");
-				tsc_marked_unstable =3D 1;
-			}
-			if (lapic_detected_unstable && !lapic_marked_unstable) {
-				int i;
-				/* LAPIC could halt in idle, so notify users */
-				for_each_online_cpu(i)
-					clockevents_notify(
-						CLOCK_EVT_NOTIFY_BROADCAST_ON,
-						&i);
-				lapic_marked_unstable =3D 1;
-			}
-			local_irq_disable();
-			cpu =3D smp_processor_id();
-			if (lapic_marked_unstable)
-				clockevents_notify(
-					CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
-			stop_critical_timings();
-
-			mwait_idle_with_hints(power_saving_mwait_eax, 1);
-
-			start_critical_timings();
-			if (lapic_marked_unstable)
-				clockevents_notify(
-					CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
-			local_irq_enable();
-
-			if (jiffies > expire_time) {
-				do_sleep =3D 1;
-				break;
-			}
-		}
+		play_idle(expire_time);
=20
 		/*
 		 * current sched_rt has threshold for rt task running time.
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -256,11 +256,6 @@ static u64 pkg_state_counter(void)
 	return count;
 }
=20
-static void noop_timer(unsigned long foo)
-{
-	/* empty... just the fact that we get the interrupt wakes us up */
-}
-
 static unsigned int get_compensation(int ratio)
 {
 	unsigned int comp =3D 0;
@@ -365,7 +360,6 @@ static bool powerclamp_adjust_controls(u
 static int clamp_thread(void *arg)
 {
 	int cpunr =3D (unsigned long)arg;
-	DEFINE_TIMER(wakeup_timer, noop_timer, 0, 0);
 	static const struct sched_param param =3D {
 		.sched_priority =3D MAX_USER_RT_PRIO/2,
 	};
@@ -374,11 +368,9 @@ static int clamp_thread(void *arg)
=20
 	set_bit(cpunr, cpu_clamping_mask);
 	set_freezable();
-	init_timer_on_stack(&wakeup_timer);
 	sched_setscheduler(current, SCHED_FIFO, &param);
=20
-	while (true =3D=3D clamping && !kthread_should_stop() &&
-		cpu_online(cpunr)) {
+	while (clamping && !kthread_should_stop() && cpu_online(cpunr)) {
 		int sleeptime;
 		unsigned long target_jiffies;
 		unsigned int guard;
@@ -426,35 +418,11 @@ static int clamp_thread(void *arg)
 		if (should_skip)
 			continue;
=20
-		target_jiffies =3D jiffies + duration_jiffies;
-		mod_timer(&wakeup_timer, target_jiffies);
 		if (unlikely(local_softirq_pending()))
 			continue;
-		/*
-		 * stop tick sched during idle time, interrupts are still
-		 * allowed. thus jiffies are updated properly.
-		 */
-		preempt_disable();
-		tick_nohz_idle_enter();
-		/* mwait until target jiffies is reached */
-		while (time_before(jiffies, target_jiffies)) {
-			unsigned long ecx =3D 1;
-			unsigned long eax =3D target_mwait;
-
-			/*
-			 * REVISIT: may call enter_idle() to notify drivers who
-			 * can save power during cpu idle. same for exit_idle()
-			 */
-			local_touch_nmi();
-			stop_critical_timings();
-			mwait_idle_with_hints(eax, ecx);
-			start_critical_timings();
-			atomic_inc(&idle_wakeup_counter);
-		}
-		tick_nohz_idle_exit();
-		preempt_enable();
+
+		play_idle(duration_jiffies);
 	}
-	del_timer_sync(&wakeup_timer);
 	clear_bit(cpunr, cpu_clamping_mask);
=20
 	return 0;
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -255,6 +255,8 @@ enum cpuhp_state {
 	CPUHP_ONLINE,
 };
=20
+void play_idle(unsigned long jiffies);
+
 void cpu_startup_entry(enum cpuhp_state state);
 void cpu_idle(void);
=20
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1892,6 +1892,7 @@ extern void thread_group_cputime_adjuste
 /*
  * Per process flags
  */
+#define PF_IDLE		0x00000002	/* I am an IDLE thread */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
@@ -2204,7 +2205,7 @@ extern struct task_struct *idle_task(int
  */
 static inline bool is_idle_task(const struct task_struct *p)
 {
-	return p->pid =3D=3D 0;
+	return !!(p->flags & PF_IDLE);
 }
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4537,6 +4537,7 @@ void init_idle(struct task_struct *idle,
 	__sched_fork(0, idle);
 	idle->state =3D TASK_RUNNING;
 	idle->se.exec_start =3D sched_clock();
+	idle->flags |=3D PF_IDLE;
=20
 	do_set_cpus_allowed(idle, cpumask_of(cpu));
 	/*
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -184,72 +184,102 @@ static void cpuidle_idle_call(void)
  *
  * Called with polling cleared.
  */
-static void cpu_idle_loop(void)
+static void do_idle(void)
 {
-	while (1) {
-		/*
-		 * If the arch has a polling bit, we maintain an invariant:
-		 *
-		 * Our polling bit is clear if we're not scheduled (i.e. if
-		 * rq->curr !=3D rq->idle).  This means that, if rq->idle has
-		 * the polling bit set, then setting need_resched is
-		 * guaranteed to cause the cpu to reschedule.
-		 */
+	/*
+	 * If the arch has a polling bit, we maintain an invariant:
+	 *
+	 * Our polling bit is clear if we're not scheduled (i.e. if
+	 * rq->curr !=3D rq->idle).  This means that, if rq->idle has
+	 * the polling bit set, then setting need_resched is
+	 * guaranteed to cause the cpu to reschedule.
+	 */
=20
-		__current_set_polling();
-		tick_nohz_idle_enter();
+	__current_set_polling();
+	tick_nohz_idle_enter();
=20
-		while (!need_resched()) {
-			check_pgt_cache();
-			rmb();
-
-			if (cpu_is_offline(smp_processor_id()))
-				arch_cpu_idle_dead();
-
-			local_irq_disable();
-			arch_cpu_idle_enter();
-
-			/*
-			 * In poll mode we reenable interrupts and spin.
-			 *
-			 * Also if we detected in the wakeup from idle
-			 * path that the tick broadcast device expired
-			 * for us, we don't want to go deep idle as we
-			 * know that the IPI is going to arrive right
-			 * away
-			 */
-			if (cpu_idle_force_poll || tick_check_broadcast_expired())
-				cpu_idle_poll();
-			else
-				cpuidle_idle_call();
+	while (!need_resched()) {
+		check_pgt_cache();
+		rmb();
=20
-			arch_cpu_idle_exit();
-		}
+		if (cpu_is_offline(smp_processor_id()))
+			arch_cpu_idle_dead();
=20
-		/*
-		 * Since we fell out of the loop above, we know
-		 * TIF_NEED_RESCHED must be set, propagate it into
-		 * PREEMPT_NEED_RESCHED.
-		 *
-		 * This is required because for polling idle loops we will
-		 * not have had an IPI to fold the state for us.
-		 */
-		preempt_set_need_resched();
-		tick_nohz_idle_exit();
-		__current_clr_polling();
+		local_irq_disable();
+		arch_cpu_idle_enter();
=20
 		/*
-		 * We promise to call sched_ttwu_pending and reschedule
-		 * if need_resched is set while polling is set.  That
-		 * means that clearing polling needs to be visible
-		 * before doing these things.
+		 * In poll mode we reenable interrupts and spin.
+		 *
+		 * Also if we detected in the wakeup from idle
+		 * path that the tick broadcast device expired
+		 * for us, we don't want to go deep idle as we
+		 * know that the IPI is going to arrive right
+		 * away
 		 */
-		smp_mb__after_atomic();
+		if (cpu_idle_force_poll || tick_check_broadcast_expired())
+			cpu_idle_poll();
+		else
+			cpuidle_idle_call();
=20
-		sched_ttwu_pending();
-		schedule_preempt_disabled();
+		arch_cpu_idle_exit();
 	}
+
+	/*
+	 * Since we fell out of the loop above, we know
+	 * TIF_NEED_RESCHED must be set, propagate it into
+	 * PREEMPT_NEED_RESCHED.
+	 *
+	 * This is required because for polling idle loops we will
+	 * not have had an IPI to fold the state for us.
+	 */
+	preempt_set_need_resched();
+	tick_nohz_idle_exit();
+	__current_clr_polling();
+
+	/*
+	 * We promise to call sched_ttwu_pending and reschedule
+	 * if need_resched is set while polling is set.  That
+	 * means that clearing polling needs to be visible
+	 * before doing these things.
+	 */
+	smp_mb__after_atomic();
+
+	sched_ttwu_pending();
+	schedule_preempt_disabled();
+}
+
+static void play_idle_timer(unsigned long foo)
+{
+	set_tsk_need_resched(current);
+}
+
+void play_idle(unsigned long duration)
+{
+	DEFINE_TIMER(wakeup_timer, play_idle_timer, 0, 0);
+
+	/*
+	 * Only FIFO tasks can disable the tick since they don't need the forced
+	 * preemption.
+	 */
+	WARN_ON_ONCE(current->policy !=3D SCHED_FIFO);
+	WARN_ON_ONCE(current->nr_cpus_allowed !=3D 1);
+	WARN_ON_ONCE(!(current->flags & PF_NO_SETAFFINITY));
+	WARN_ON_ONCE(!(current->flags & PF_KTHREAD));
+	rcu_sleep_check();
+
+	init_timer_on_stack(&wakeup_timer);
+	mod_timer_pinned(&wakeup_timer, jiffies + duration);
+
+	preempt_disable();
+	current->flags |=3D PF_IDLE;
+	do_idle();
+	current->flags &=3D ~PF_IDLE;
+	del_timer_sync(&wakeup_timer);
+	preempt_fold_need_resched();
+	preempt_enable();
 }
+EXPORT_SYMBOL_GPL(play_idle);
=20
 void cpu_startup_entry(enum cpuhp_state state)
 {
@@ -269,5 +299,6 @@ void cpu_startup_entry(enum cpuhp_state
 	boot_init_stack_canary();
 #endif
 	arch_cpu_idle_prepare();
-	cpu_idle_loop();
+	while (1)
+		do_idle();
 }
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -807,7 +807,6 @@ void tick_nohz_idle_enter(void)
=20
 	local_irq_enable();
 }
-EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
=20
 /**
  * tick_nohz_irq_exit - update next tick event from interrupt exit
@@ -934,7 +933,6 @@ void tick_nohz_idle_exit(void)
=20
 	local_irq_enable();
 }
-EXPORT_SYMBOL_GPL(tick_nohz_idle_exit);
=20
 static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
 {

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkBhvAAoJEHZH4aRLwOS6SIMQAJNqcjmyJt42uRS8lGl9dBAK
ht5zAlAD9wpVWnqXylpdBg6NoOWhg4jRYEmcjl9/04i7flMDm3YTGBNluF58Mlj/
4pMcJORqN5WfQFeHJgGCqhiVdd9aZQlSbYOwJptVPRYWvjJz+9J1+Mvbg1X2um5Z
ebd1LAsTYHHnx5q+AdNWOf+IQXuISQ5d+yoFT2NW1jFi9ev0svyvvXuJSAo3kLWW
+BSqzYTPIob8KQ9Rwz648DaDWnPBcLU5GioqxpIh4oDNJYZrlz/TKBPIbPnJYQ69
VEwGS5TpWfcSPj8S7wqQRthvd6V5FAgDd4L1ls5J9S7+aQ9+S/cMLdzYhN2n3b/X
TN9AFEY4hEy1pwEk4vKWU1ZdPZszXVMBKZiXMC4PnSBmLVDDCsqzNGHDmia3ZnbV
ihpu517g2+FWo58AO6jzy+Ms8j3QdlsRkIet52eqeTLXOqDlQ+BfHyz1P7sA3Dn7
rlXph8Jz1sTY+MG7o+kaBuMM1s3gmUVx79EsCRZMAw3nELjYzgaiG5kglZU0zDdH
3VECgkJ0aqGeO3/k/grAKCU/xxqU+buhSk4JJoSkCXOtd8deo1hvjblj35RWdY8V
FjKCCxglx266JA8aqv0dT1CKXf45QBHZpk5tRYIcUwTNx6qCQGI9d+OL5y2auXKO
HFBWh2KPv0bDliIL1FLl
=ik+e
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
