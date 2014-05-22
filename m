Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaEVM6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:58:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:45299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaEVM6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:58:24 -0400
Date: Thu, 22 May 2014 14:58:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/8] sched,idle: need resched polling rework
Message-ID: <20140522125818.GV30445@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NslO8/oLdnqAPeMq"
Content-Disposition: inline
In-Reply-To: <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NslO8/oLdnqAPeMq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 11, 2014 at 08:00:23AM -0700, Andy Lutomirski wrote:
>=20
> That being said, I think that this addresses once one of the two major
> issues.  While the race you're fixing is more interesting, I think its
> impact is dwarfed by the fact that ttwu_queue_remote completely
> ignores polling.  (NB: I haven't actually tested this patch set, but I
> did try to instrument this stuff awhile ago.)
>=20
> To fix this, presumably the wake-from-idle path needs a
> sched_ttwu_pending call, and ttwu_queue_remote could use resched_task.
>  sched_ttwu_pending could benefit from a straightforward optimization:
> it doesn't need rq->lock if llist is empty.
>=20
> If you're not planning on trying to fix that, I can try to write up a
> patch in the next day or two.
>=20
> Even with all of this fixed, what happens when ttwu_queue_remote is
> called with a task that has lower priority than whatever is currently
> running on the targeted cpu?  I think the result is an IPI that serves
> very little purpose other than avoiding taking a spinlock in the
> waking thread.  This may be a bad tradeoff.  I doubt that this matters
> for my particular workload, though.
>=20

Ok, now that that all settled, how about something like this on top?

---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4ea7b3f1a087..a5da85fb3570 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -546,12 +546,38 @@ static bool set_nr_and_not_polling(struct task_struct=
 *p)
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
+	typeof(ti->flags) old, val =3D ti->flags;
+
+	for (;;) {
+		if (!(val & _TIF_POLLING_NRFLAG))
+			return false;
+		if (val & _TIF_NEED_RESCHED)
+			return true;
+		old =3D cmpxchg(&ti->flags, val, val | _TIF_NEED_RESCHED);
+		if (old =3D=3D val)
+			return true;
+		val =3D old;
+	}
+}
+
 #else
 static bool set_nr_and_not_polling(struct task_struct *p)
 {
 	set_tsk_need_resched(p);
 	return true;
 }
+
+static bool set_nr_if_polling(struct task_struct *p)
+{
+	return false;
+}
 #endif
=20
 /*
@@ -652,16 +678,7 @@ static void wake_up_idle_cpu(int cpu)
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
@@ -1521,12 +1538,15 @@ static int ttwu_remote(struct task_struct *p, int w=
ake_flags)
 }
=20
 #ifdef CONFIG_SMP
-static void sched_ttwu_pending(void)
+void sched_ttwu_pending(void)
 {
 	struct rq *rq =3D this_rq();
 	struct llist_node *llist =3D llist_del_all(&rq->wake_list);
 	struct task_struct *p;
=20
+	if (!llist)
+		return;
+
 	raw_spin_lock(&rq->lock);
=20
 	while (llist) {
@@ -1581,8 +1601,10 @@ void scheduler_ipi(void)
=20
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
 {
-	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
-		smp_send_reschedule(cpu);
+	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list)) {
+		if (!set_nr_if_polling(p))
+			smp_send_reschedule(cpu);
+	}
 }
=20
 bool cpus_share_cache(int this_cpu, int that_cpu)
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 34083c9ac976..4286f2e59136 100644
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
@@ -223,6 +225,7 @@ static void cpu_idle_loop(void)
 		 */
 		preempt_set_need_resched();
 		tick_nohz_idle_exit();
+		sched_ttwu_pending();
 		schedule_preempt_disabled();
 	}
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b2cbe81308af..2b35ec6df6b3 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -670,6 +670,8 @@ extern int migrate_swap(struct task_struct *, struct ta=
sk_struct *);
=20
 #ifdef CONFIG_SMP
=20
+extern void sched_ttwu_pending(void);
+
 #define rcu_dereference_check_sched_domain(p) \
 	rcu_dereference_check((p), \
 			      lockdep_is_held(&sched_domains_mutex))
@@ -787,6 +789,10 @@ static inline unsigned int group_first_cpu(struct sche=
d_group *group)
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

--NslO8/oLdnqAPeMq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTffRqAAoJEHZH4aRLwOS6gvMP/0KPhGYN98oaickgJ9wg+szk
VSE6ZSKG/ev8o6FoaWsggOxT+/6UeV9fmlRSH4HJYJIQPcAanrRVlJyqd7mjH050
7EKNjJ5W9xdit7tmkanC/dGoS6Ea+4xY7xV15Bx6CvWjSfZQ+CESAk10XK4PPyFj
oHWwxkL/NtETT2Qq5Gf3JbXTf3M9k7/ZKOV0sXsCYvvFA6cIVHxJYP8hUb5JPPO4
nAPP3jKv6S3FhgkGBl3Id3WEFyjZT5hLGLvobMoiZYUyL6aASmJNjgnY4ITwayQK
9d8FEGlKx8W/28furXk2HQm4LKID9se9kUlugWZv+fvLPrr9m3TVPBUlOebMJXbs
oFidffWQ7B37IN5mot7NMkws8etpaCBDGCYQZgyjX3DQSUCTQO5cHZk40K9DCg8s
04IX1CETl2+gFYIgCcnk0kQao4SPefZnoja8graHeO/reHMMbEtrqwn+L6H0U41J
GZ+atPUJbkS5NweNLTlc4BvVHtz34W1TQHeE09ClfyR8AmipGQlfYLsYz4WXOh2i
vdmKNyhUNWJAywliFED3UmCv6nxbFu8hLqZtJpFsJfSJy1eXDEMG8Jdlmq5qOO3W
wLt71IlSUQlJMdqwp0qLqvUtC3ieR4GzGUXbzxLqvEpkrvBek/Aq/xamrIdhHQTd
zeST2Ftogt5ekmOD8FUb
=xUJh
-----END PGP SIGNATURE-----

--NslO8/oLdnqAPeMq--
