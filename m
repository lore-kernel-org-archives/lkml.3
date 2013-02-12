Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3BLXAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:00:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3BLXAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:00:19 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=1e2jXibFBfAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=TMThcRnKKdAA:10 a=JfrnYn6hAAAA:8 a=Duj7teEOjNXlbOJIJ4QA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=qp24slXe02aenkxc8BIA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130212230017.443502875@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 12 Feb 2013 17:54:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] sched/rt: Fix push_rt_task() to have the same checks as the caller
 did
References: <20130212225412.781044738@goodmis.org>
Content-Disposition: inline; filename=0001-sched-rt-Fix-push_rt_task-to-have-the-same-checks-as.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently, push_rt_task() only pushes the task if it is lower
priority than the currently running task.

But it can be called for other reasons. Namely, if the current process
that is about to be preempted, is a real time task and is also pinned
to the CPU. This happens on wake up of high priority task. A check
is made in wake_up_rt() to see if the woken task can preempt the
task on its CPU, and the running task is not a pinned RT task. If
the task is pinned, and the woken task can migrate, it will try to
migrate it by calling push_rt_task().

Now in push_rt_task(), it will check if it can preempt the current
task but does not check if that task is pinned. If the woken task
is of higher priority, it wont try to migrate the woken task, even
if the other task is pinned. It will simply not push the task, which
is not consistent with the reason that push_rt_task() was called for
in the first place. Even for other callers of push_rt_task(), the task
should try to avoid preempting pinned RT tasks.

A helper routine is created call "ok_to_push_task()" that is now
used by both the wake_up_rt() and push_rt_task() code.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/rt.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index c25de14..6f3108e 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1613,6 +1613,14 @@ static struct task_struct *pick_next_pushable_task(s=
truct rq *rq)
 	return p;
 }
=20
+static int ok_to_push_task(struct task_struct *p, struct task_struct *curr)
+{
+	return p->nr_cpus_allowed > 1 &&
+		rt_task(curr) &&
+		(curr->nr_cpus_allowed < 2 ||
+		 curr->prio <=3D p->prio);
+}
+
 /*
  * If the current CPU has more than one RT task, see if the non
  * running task can migrate over to a CPU that is running a task
@@ -1642,7 +1650,7 @@ retry:
 	 * higher priority than current. If that's the case
 	 * just reschedule current.
 	 */
-	if (unlikely(next_task->prio < rq->curr->prio)) {
+	if (!ok_to_push_task(next_task, rq->curr)) {
 		resched_task(rq->curr);
 		return 0;
 	}
@@ -1807,10 +1815,7 @@ static void task_woken_rt(struct rq *rq, struct task=
_struct *p)
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
 	    has_pushable_tasks(rq) &&
-	    p->nr_cpus_allowed > 1 &&
-	    rt_task(rq->curr) &&
-	    (rq->curr->nr_cpus_allowed < 2 ||
-	     rq->curr->prio <=3D p->prio))
+	    ok_to_push_task(p, rq->curr))
 		push_rt_tasks(rq);
 }
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRGsmBAAoJEOdOSU1xswtM4VEIAMXXZ7OySM9xUmNYCLZPoRvT
SxrcXeMKO1+UHRFuMYrXsys2xKq07eD0pzjy0FUEa3TSx035X8J0Pifm4wJ+4wUu
8jA4UxPvDrMMkhfCXw4yUCZPlXtd2alYh95JfMKwj2RkL6IJ/LpK+hFtrKnIt4Kw
fFa1grTgD90ly3yBFKKGAPmBLcHdpFKQLn8fXYrmZGHFruGiDxkqQODJbrwmpSVc
/3Y60HLvmXai5ku+/RVNEsAhnNU46lWqexoHyV70hmhyPudgadNOjrVybot92Rhk
blka1fD+UvTyqqMKdZP2LN0zAvVsCyjJzkdFctmwKoRyb2mOzGc9R/j4dQNJCgU=
=0RBa
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
