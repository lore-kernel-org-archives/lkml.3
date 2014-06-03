Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaFCKn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:43:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53084 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaFCKn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:43:57 -0400
Date: Tue, 3 Jun 2014 12:43:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/8] sched,idle: need resched polling rework
Message-ID: <20140603104347.GT11096@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
 <20140522125818.GV30445@twins.programming.kicks-ass.net>
 <20140522130931.GV13658@twins.programming.kicks-ass.net>
 <CALCETrVBVOjs0EVqEz3qKtSHQg1agJzAyG4Ohqueky-zPF7uKA@mail.gmail.com>
 <20140529064827.GI19143@laptop.programming.kicks-ass.net>
 <CALCETrWnG7fSuinDv+GAHsnTLJ-6xn+_1LB2XdLGVXcC=TQURA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BM/1i/1Z34LY4Oq9"
Content-Disposition: inline
In-Reply-To: <CALCETrWnG7fSuinDv+GAHsnTLJ-6xn+_1LB2XdLGVXcC=TQURA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BM/1i/1Z34LY4Oq9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2014 at 11:40:26PM -0700, Andy Lutomirski wrote:
> You're testing polling on the task being woken, which cannot possibly
> succeed: the only tasks that have any business polling are the idle
> tasks.  Something like this seems to help:
>=20
>  static void ttwu_queue_remote(struct task_struct *p, int cpu)
>  {
> +       struct rq *rq =3D cpu_rq(cpu);
> +
>         if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list)) {
> -               if (!set_nr_if_polling(p))
> +               if (!set_nr_if_polling(rq->idle))
>                         smp_send_reschedule(cpu);
> +               else
> +                       trace_sched_wake_polling_cpu(cpu);
>         }
>  }
>=20
> If you don't beat me to it, I'll send real patches in the morning.
> I'll also send some followup patches to make it even better.  Fully
> fixed up, this gets rid of almost all of my rescheduling interrupts
> except for interrupts from the timer tick.

We need rq->curr, rq->idle 'sleeps' with polling set and nr clear, but
it obviously has no effect setting that if its not actually the current
task.

Touching rq->curr needs holding rcu_read_lock() though, to make sure the
task stays around, still shouldn't be a problem.

> Also, grr, I still think this would be clearer if polling and
> need_resched were per cpu instead of per task -- they only make sense
> on a running task.  I guess that need_resched being in
> thread_info->flags is helpful because it streamlines the interrupt
> exit code.  Oh, well.

Yes, and the fact that traditionally we didn't have per-cpu storage. But
yes, the interrupt/system return path is a good reason to keep all this.

---
Subject: sched: Optimize ttwu IPI
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Thu May 22 17:19:22 CEST 2014

When enqueueing tasks on remote LLC domains, we send an IPI to do the
work 'locally' and avoid bouncing all the cachelines over.

However, when the remote CPU is idle (and polling, say x86 mwait), we
don't need to send an IPI, we can simply kick the TIF word to wake it
up and have the 'idle' loop do the work.

So when _TIF_POLLING_NRFLAG is set, but _TIF_NEED_RESCHED is not (yet)
set, set _TIF_NEED_RESCHED and avoid sending the IPI.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Much-Requested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c  |   61 +++++++++++++++++++++++++++++++++++++---------=
-----
 kernel/sched/idle.c  |    3 ++
 kernel/sched/sched.h |    6 +++++
 3 files changed, 54 insertions(+), 16 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -535,7 +535,7 @@ static inline void init_hrtick(void)
  	__old;								\
 })
=20
-#ifdef TIF_POLLING_NRFLAG
+#if defined(CONFIG_SMP) && defined(TIF_POLLING_NRFLAG)
 /*
  * Atomically set TIF_NEED_RESCHED and test for TIF_POLLING_NRFLAG,
  * this avoids any races wrt polling state changes and thereby avoids
@@ -546,12 +546,40 @@ static bool set_nr_and_not_polling(struc
 	struct thread_info *ti =3D task_thread_info(p);
 	return !(fetch_or(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLING_NRFLAG);
 }
+
+/*
+ * Atomically set TIF_NEED_RESCHED if TIF_POLLING_NRFLAG is set.
+ */
+static bool set_nr_if_polling(struct task_struct *p)
+{
+	struct thread_info *ti =3D task_thread_info(p);
+	typeof(ti->flags) old, val =3D ACCESS_ONCE(ti->flags);
+
+	for (;;) {
+		if ((val & (_TIF_NEED_RESCHED | _TIF_POLLING_NRFLAG)) !=3D
+				_TIF_POLLING_NRFLAG)
+			return false;
+		old =3D cmpxchg(&ti->flags, val, val | _TIF_NEED_RESCHED);
+		if (old =3D=3D val)
+			break;
+		val =3D old;
+	}
+	return true;
+}
+
 #else
 static bool set_nr_and_not_polling(struct task_struct *p)
 {
 	set_tsk_need_resched(p);
 	return true;
 }
+
+#ifdef CONFIG_SMP
+static bool set_nr_if_polling(struct task_struct *p)
+{
+	return false;
+}
+#endif
 #endif
=20
 /*
@@ -652,16 +680,7 @@ static void wake_up_idle_cpu(int cpu)
 	if (rq->curr !=3D rq->idle)
 		return;
=20
-	/*
-	 * We can set TIF_RESCHED on the idle task of the other CPU
-	 * lockless. The worst case is that the other CPU runs the
-	 * idle task through an additional NOOP schedule()
-	 */
-	set_tsk_need_resched(rq->idle);
-
-	/* NEED_RESCHED must be visible before we test polling */
-	smp_mb();
-	if (!tsk_is_polling(rq->idle))
+	if (set_nr_and_not_polling(rq->idle))
 		smp_send_reschedule(cpu);
 }
=20
@@ -1521,13 +1540,17 @@ static int ttwu_remote(struct task_struc
 }
=20
 #ifdef CONFIG_SMP
-static void sched_ttwu_pending(void)
+void sched_ttwu_pending(void)
 {
 	struct rq *rq =3D this_rq();
 	struct llist_node *llist =3D llist_del_all(&rq->wake_list);
 	struct task_struct *p;
+	unsigned long flags;
+
+	if (!llist)
+		return;
=20
-	raw_spin_lock(&rq->lock);
+	raw_spin_lock_irqsave(&rq->lock, flags);
=20
 	while (llist) {
 		p =3D llist_entry(llist, struct task_struct, wake_entry);
@@ -1535,7 +1558,7 @@ static void sched_ttwu_pending(void)
 		ttwu_do_activate(rq, p, 0);
 	}
=20
-	raw_spin_unlock(&rq->lock);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
=20
 void scheduler_ipi(void)
@@ -1581,8 +1604,14 @@ void scheduler_ipi(void)
=20
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
 {
-	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
-		smp_send_reschedule(cpu);
+	struct rq *rq =3D cpu_rq(cpu);
+
+	if (llist_add(&p->wake_entry, &rq->wake_list)) {
+		rcu_read_lock();
+		if (!set_nr_if_polling(rq->curr))
+			smp_send_reschedule(cpu);
+		rcu_read_unlock();
+	}
 }
=20
 bool cpus_share_cache(int this_cpu, int that_cpu)
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -12,6 +12,8 @@
=20
 #include <trace/events/power.h>
=20
+#include "sched.h"
+
 static int __read_mostly cpu_idle_force_poll;
=20
 void cpu_idle_poll_ctrl(bool enable)
@@ -218,6 +220,7 @@ static void cpu_idle_loop(void)
 		 */
 		preempt_set_need_resched();
 		tick_nohz_idle_exit();
+		sched_ttwu_pending();
 		schedule_preempt_disabled();
 	}
 }
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -670,6 +670,8 @@ extern int migrate_swap(struct task_stru
=20
 #ifdef CONFIG_SMP
=20
+extern void sched_ttwu_pending(void);
+
 #define rcu_dereference_check_sched_domain(p) \
 	rcu_dereference_check((p), \
 			      lockdep_is_held(&sched_domains_mutex))
@@ -787,6 +789,10 @@ static inline unsigned int group_first_c
=20
 extern int group_balance_cpu(struct sched_group *sg);
=20
+#else
+
+static inline void sched_ttwu_pending(void) { }
+
 #endif /* CONFIG_SMP */
=20
 #include "stats.h"

--BM/1i/1Z34LY4Oq9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjabjAAoJEHZH4aRLwOS6hlIP+wat77Aggrji+czMsneoF5ve
LdgRyYv85jVhPQBBJRY+RrtWjarv8+5MWmeyIQMGqZngPnEtXU0jvEeII/2LnIJj
GhMp4dOHoNL5W7aiQxgpEGE2vUEVPUt7f8PaEBoBKQCTFClQNvBUDFp4vOIoWrGJ
s6V9GIMOqTWryVV7pmhz5JXz70n8lzsVS1/VkCU5VnXFFbQw6gr122S7e9McDhbV
52jwkjVNo+YmpLI8E6Oe5+KCU8DuXNnp/NVi9iFWaRMhw3bHD6uAUaiykSm8v8BM
sUAgBhq+g/9zg1fXcHIkVwjvZkIElfipIGhQSb1F+AHo91iWNii7vGBBWlPS8KiN
gMMTjjZN1P0P1wbLOA3dDIPOwxW9lGoIedVIW0L+SJGDr1hLt/e0Ukjo7HGiXbe2
70I1JWRfwd7pCETkO5hD5o/5vdtjbdlxOgxXLoSNgcb/MefcYY2tKWhqFN6yz+ko
JU4Yl8dyZr2e6nU6znyCPw0OVNrx3YbHK6HJDuZ71C47R0mSIq3ptP1ddO69NvFV
JNubaGBF2jh9VkSRKEP5kQMDEN6awncWSRktNPEtsV/RgjvfkoXQO/PXX9oTAJ56
HNaifw0Nrhb+NHk2oe8B5uUGlxLyMCI50stc43beknw7Ti2yqZ/l89JuTSUFIb1N
GMHj7kXkm1wMUORs2dFQ
=nymG
-----END PGP SIGNATURE-----

--BM/1i/1Z34LY4Oq9--
