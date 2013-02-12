Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab3BLXA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:00:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab3BLXAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:00:19 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ZVopYIfSr7gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=9aOUTBF5I_8A:10 a=JfrnYn6hAAAA:8 a=Q3eUv2njtvneWTBh4EYA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=Kin9INT5YykyTbz9iZIA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130212230017.625583020@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 12 Feb 2013 17:54:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/3] sched: Move idle_balance() to post_schedule
References: <20130212225412.781044738@goodmis.org>
Content-Disposition: inline; filename=0002-sched-Move-idle_balance-to-post_schedule.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The idle_balance() code is called to do task load balancing just before
going to idle. This makes sense as the CPU is about to sleep anyway.
But currently it's called in the middle of the scheduler and in a place
that must have interrupts disabled. That means, while the load balancing
is going on, if a task wakes up on this CPU, it wont get to run while
the interrupts are disabled. The idle task doing the balancing will be
clueless about it.

There's no real reason that the idle_balance() needs to be called in the
middle of schedule anyway. The only benefit is that if a task is pulled
to this CPU, it can be scheduled without the need to schedule the idle
task. But load balancing and migrating the task makes a switch to idle
and back negligible.

By using the post_schedule function pointer of the sched class, the
unlikely branch in the hot path of the scheduler can be removed, and
the idle task itself can do the load balancing.

Another advantage of this, is that by moving the idle_balance to the
post_schedule routine, interrupts can now be enabled in the load balance
allowing for interrupts and wakeups to still occur on that CPU while a
balance is taking place. The enabling of interrupts will come as a separate
patch.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/core.c      |    3 ---
 kernel/sched/idle_task.c |   10 ++++++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1dff78a..a9317b7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2927,9 +2927,6 @@ need_resched:
=20
 	pre_schedule(rq, prev);
=20
-	if (unlikely(!rq->nr_running))
-		idle_balance(cpu, rq);
-
 	put_prev_task(rq, prev);
 	next =3D pick_next_task(rq);
 	clear_tsk_need_resched(prev);
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index b6baf37..66b5220 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -13,6 +13,11 @@ select_task_rq_idle(struct task_struct *p, int sd_flag, =
int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
+
+static void post_schedule_idle(struct rq *rq)
+{
+	idle_balance(smp_processor_id(), rq);
+}
 #endif /* CONFIG_SMP */
 /*
  * Idle tasks are unconditionally rescheduled:
@@ -25,6 +30,10 @@ static void check_preempt_curr_idle(struct rq *rq, struc=
t task_struct *p, int fl
 static struct task_struct *pick_next_task_idle(struct rq *rq)
 {
 	schedstat_inc(rq, sched_goidle);
+#ifdef CONFIG_SMP
+	/* Trigger the post schedule to do an idle_balance */
+	rq->post_schedule =3D 1;
+#endif
 	return rq->idle;
 }
=20
@@ -86,6 +95,7 @@ const struct sched_class idle_sched_class =3D {
=20
 #ifdef CONFIG_SMP
 	.select_task_rq		=3D select_task_rq_idle,
+	.post_schedule		=3D post_schedule_idle,
 #endif
=20
 	.set_curr_task          =3D set_curr_task_idle,
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRGsmBAAoJEOdOSU1xswtMJCAIALXjscIhzWeFnDbeQalZS3Ol
g0RKq/W5MTg6+hEtKaBXEnVM6qA25ZoxPTSRhLu6V2pOotj5aV8F3qodhtYlqHYt
aUfhU95HxJZYOM8i1H683QDRCmVUempXbOsYDP9WRwLIV6FfFCBlqruu06qS3onK
foWodYI1wAqqlgSZWl7yu/6kuvBYVDmTfYfrHM8kpLGrw2WXNvxG4QXG2RCClb1n
zHncR5QzwRK13xDesZiKdgBW9P8n8ku7pWxsQPxeU7gppN8o4d2qc8DMmN5lzcFe
8UsuN0ctSTIe5R7jITbWj6iTrzSfg2L1/uSZZTCCKbwZsUrUbImrNLizVQfiGag=
=tnwe
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
