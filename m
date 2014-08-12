Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaHLJgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:36:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaHLJgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:36:49 -0400
Date: Tue, 12 Aug 2014 11:36:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, oleg@redhat.com,
        rostedt@goodmis.org, umgwanakikbuti@gmail.com, tkhai@yandex.ru,
        tim.c.chen@linux.intel.com, mingo@kernel.org, nicolas.pitre@linaro.org
Subject: Re: [PATCH v4 6/6] sched/fair: Remove double_lock_balance() from
 load_balance()
Message-ID: <20140812093631.GR9918@twins.programming.kicks-ass.net>
References: <20140806075138.24858.23816.stgit@tkhai>
 <1407312424.8424.48.camel@tkhai>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZdU67af53GA9VBj6"
Content-Disposition: inline
In-Reply-To: <1407312424.8424.48.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZdU67af53GA9VBj6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



Changed quite a bit around, _should_ be more or less the same end result
I suppose. Only compile tested so far.

---
Subject: sched/fair: Remove double_lock_balance() from load_balance()
=46rom: Kirill Tkhai <ktkhai@parallels.com>
Date: Wed, 6 Aug 2014 12:07:04 +0400

Avoid double_rq_lock() and use ONRQ_MIGRATING for load_balance(). The
advantage is (obviously) not holding two 'rq->lock's at the same time
and thereby increasing parallelism.

Further note that if there was no task to migrate we will not have
acquired the second rq->lock at all.

The important point to note is that because we acquire dst->lock
immediately after releasing src->lock the potential wait time of
task_rq_lock() callers on ONRQ_MIGRATING is not longer than it would
have been in the double rq lock scenario.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1407312424.8424.48.camel@tkhai
---
 kernel/sched/fair.c |  151 ++++++++++++++++++++++++++++++++++-------------=
-----
 1 file changed, 99 insertions(+), 52 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4706,7 +4706,7 @@ static void check_preempt_wakeup(struct
 		return;
=20
 	/*
-	 * This is possible from callers such as move_task(), in which we
+	 * This is possible from callers such as attach_tasks(), in which we
 	 * unconditionally check_prempt_curr() after an enqueue (which may have
 	 * lead to a throttle).  This both saves work and prevents false
 	 * next-buddy nomination below.
@@ -5114,21 +5114,10 @@ struct lb_env {
 	unsigned int		loop_max;
=20
 	enum fbq_type		fbq_type;
+	struct list_head	tasks;
 };
=20
 /*
- * move_task - move a task from one runqueue to another runqueue.
- * Both runqueues must be locked.
- */
-static void move_task(struct task_struct *p, struct lb_env *env)
-{
-	deactivate_task(env->src_rq, p, 0);
-	set_task_cpu(p, env->dst_cpu);
-	activate_task(env->dst_rq, p, 0);
-	check_preempt_curr(env->dst_rq, p, 0);
-}
-
-/*
  * Is this task likely cache-hot:
  */
 static int task_hot(struct task_struct *p, struct lb_env *env)
@@ -5343,6 +5332,18 @@ int can_migrate_task(struct task_struct
 }
=20
 /*
+ * detach_task() -- detach the task for the migration specified in env
+ */
+static void detach_task(struct task_struct *p, struct lb_env *env)
+{
+	lockdep_assert_held(&env->src_rq->lock);
+
+	deactivate_task(env->src_rq, p, 0);
+	p->on_rq =3D ONRQ_MIGRATING;
+	set_task_cpu(p, env->dst_cpu);
+}
+
+/*
  * detach_one_task() -- tries to dequeue exactly one task from env->src_rq=
, as
  * part of active balancing operations within "domain".
  *
@@ -5358,15 +5359,13 @@ static struct task_struct *detach_one_ta
 		if (!can_migrate_task(p, env))
 			continue;
=20
-		deactivate_task(env->src_rq, p, 0);
-		p->on_rq =3D ONRQ_MIGRATING;
-		set_task_cpu(p, env->dst_cpu);
+		detach_task(p, env);
=20
 		/*
 		 * Right now, this is only the second place where
-		 * lb_gained[env->idle] is updated (other is move_tasks)
+		 * lb_gained[env->idle] is updated (other is detach_tasks)
 		 * so we can safely collect stats here rather than
-		 * inside move_tasks().
+		 * inside detach_tasks().
 		 */
 		schedstat_inc(env->sd, lb_gained[env->idle]);
 		return p;
@@ -5374,35 +5373,22 @@ static struct task_struct *detach_one_ta
 	return NULL;
 }
=20
-/*
- * attach_one_task() -- attaches the task returned from detach_one_task() =
to
- * its new rq.
- */
-static void attach_one_task(struct rq *rq, struct task_struct *p)
-{
-	raw_spin_lock(&rq->lock);
-	BUG_ON(task_rq(p) !=3D rq);
-	p->on_rq =3D ONRQ_QUEUED;
-	activate_task(rq, p, 0);
-	check_preempt_curr(rq, p, 0);
-	raw_spin_unlock(&rq->lock);
-}
-
 static const unsigned int sched_nr_migrate_break =3D 32;
=20
 /*
- * move_tasks tries to move up to imbalance weighted load from busiest to
- * this_rq, as part of a balancing operation within domain "sd".
- * Returns 1 if successful and 0 otherwise.
+ * detach_tasks() -- tries to detach up to imbalance weighted load from
+ * busiest_rq, as part of a balancing operation within domain "sd".
  *
- * Called with both runqueues locked.
+ * Returns number of detached tasks if successful and 0 otherwise.
  */
-static int move_tasks(struct lb_env *env)
+static int detach_tasks(struct lb_env *env)
 {
 	struct list_head *tasks =3D &env->src_rq->cfs_tasks;
 	struct task_struct *p;
 	unsigned long load;
-	int pulled =3D 0;
+	int detached =3D 0;
+
+	lockdep_assert_held(&env->src_rq->lock);
=20
 	if (env->imbalance <=3D 0)
 		return 0;
@@ -5433,14 +5419,16 @@ static int move_tasks(struct lb_env *env
 		if ((load / 2) > env->imbalance)
 			goto next;
=20
-		move_task(p, env);
-		pulled++;
+		detach_task(p, env);
+		list_add(&p->se.group_node, &env->tasks);
+
+		detached++;
 		env->imbalance -=3D load;
=20
 #ifdef CONFIG_PREEMPT
 		/*
 		 * NEWIDLE balancing is a source of latency, so preemptible
-		 * kernels will stop after the first task is pulled to minimize
+		 * kernels will stop after the first task is detached to minimize
 		 * the critical section.
 		 */
 		if (env->idle =3D=3D CPU_NEWLY_IDLE)
@@ -5460,13 +5448,58 @@ static int move_tasks(struct lb_env *env
 	}
=20
 	/*
-	 * Right now, this is one of only two places move_task() is called,
-	 * so we can safely collect move_task() stats here rather than
-	 * inside move_task().
+	 * Right now, this is one of only two places we collect this stat
+	 * so we can safely collect detach_one_task() stats here rather
+	 * than inside detach_one_task().
 	 */
-	schedstat_add(env->sd, lb_gained[env->idle], pulled);
+	schedstat_add(env->sd, lb_gained[env->idle], detached);
=20
-	return pulled;
+	return detached;
+}
+
+/*
+ * attach_task() -- attach the task detached by detach_task() to its new r=
q.
+ */
+static void attach_task(struct rq *rq, struct task_struct *p)
+{
+	lockdep_assert_held(&rq->lock);
+
+	BUG_ON(task_rq(p) !=3D rq);
+	p->on_rq =3D ONRQ_QUEUED;
+	activate_task(rq, p, 0);
+	check_preempt_curr(rq, p, 0);
+}
+
+/*
+ * attach_one_task() -- attaches the task returned from detach_one_task() =
to
+ * its new rq.
+ */
+static void attach_one_task(struct rq *rq, struct task_struct *p)
+{
+	raw_spin_lock(&rq->lock);
+	attach_task(rq, p);
+	raw_spin_unlock(&rq->lock);
+}
+
+/*
+ * attach_tasks() -- attaches all tasks detached by detach_tasks() to their
+ * new rq.
+ */
+static void attach_tasks(struct lb_env *env)
+{
+	struct list_head *tasks =3D &env->tasks;
+	struct task_struct *p;
+
+	raw_spin_lock(&env->dst_rq->lock);
+
+	while (!list_empty(tasks)) {
+		p =3D list_first_entry(tasks, struct task_struct, se.group_node);
+		list_del_init(&p->se.group_node);
+
+		attach_task(env->dst_rq, p);
+	}
+
+	raw_spin_unlock(&env->dst_rq->lock);
 }
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -6600,6 +6633,7 @@ static int load_balance(int this_cpu, st
 		.loop_break	=3D sched_nr_migrate_break,
 		.cpus		=3D cpus,
 		.fbq_type	=3D all,
+		.tasks		=3D LIST_HEAD_INIT(env.tasks),
 	};
=20
 	/*
@@ -6649,16 +6683,29 @@ static int load_balance(int this_cpu, st
 		env.loop_max  =3D min(sysctl_sched_nr_migrate, busiest->nr_running);
=20
 more_balance:
-		local_irq_save(flags);
-		double_rq_lock(env.dst_rq, busiest);
+		raw_spin_lock_irqsave(&busiest->lock, flags);
=20
 		/*
 		 * cur_ld_moved - load moved in current iteration
 		 * ld_moved     - cumulative load moved across iterations
 		 */
-		cur_ld_moved =3D move_tasks(&env);
-		ld_moved +=3D cur_ld_moved;
-		double_rq_unlock(env.dst_rq, busiest);
+		cur_ld_moved =3D detach_tasks(&env);
+
+		/*
+		 * We've detached some tasks from busiest_rq. Every
+		 * task is masked "ONRQ_MIGRATED", so we can safely
+		 * unlock busiest->lock, and we are able to be sure
+		 * that nobody can manipulate the tasks in parallel.
+		 * See task_rq_lock() family for the details.
+		 */
+
+		raw_spin_unlock(&busiest->lock);
+
+		if (cur_ld_moved) {
+			attach_tasks(&env);
+			ld_moved +=3D cur_ld_moved;
+		}
+
 		local_irq_restore(flags);
=20
 		/*
@@ -6794,7 +6841,7 @@ static int load_balance(int this_cpu, st
 		 * If we've begun active balancing, start to back off. This
 		 * case may not be covered by the all_pinned logic if there
 		 * is only 1 task on the busy runqueue (because we don't call
-		 * move_tasks).
+		 * detach_tasks).
 		 */
 		if (sd->balance_interval < sd->max_interval)
 			sd->balance_interval *=3D 2;

--ZdU67af53GA9VBj6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6eAfAAoJEHZH4aRLwOS6zI8P/RK+Q4HLf1EjMbecLvOgnD4D
O/4lS+Npaa3+k+E3H14R3y54y59g6IFg2+h0JvX9O0LybKbKpCHSF8hUAWrHylHc
KnJHprTSGlQIkMsU5OrrQZUrp9vYSpORhVRDSHVCWjXEV3PbW/PrsYpmI+TfkIQq
ZLlkQ0w+230rmdVFHKwUm2pOtRB0GuTMLzHJ8blRlexutVVga8dXKcnOX2vnnGEN
cPCwTaSKFdb9rNpUI80+VYHdvK5mryTrb9wPuUdVTbeWg3S/yACo+vgfUj7lZ5uu
COf/4xq5XYWHvs1Z2f1PlVnFbRSxlr9aVw3v43BJR5fssg+RTTn8UbqJCX0oUFZa
mfOf9KQPH7lQB06owq6eaqXuJBTXAHmJqzAQCP8a6252+8LmksjcHoGqElil+fAH
fycQgUKjZ/ElEwXAewpMhLcgtec4dl+JxjQ8myElfrZ9bn135dmEDvsNDbX9Z9Ex
8iX2+QC+31Y3Jx7YFGHueUX1/7mbOtBqAuf60ut0eefogxfqIiuwInGhVOTkg2ds
sh3637avDxBJsCZSGzWwfe7wo0+BHm0ZGWC/RR7wNRQqn3VwxjMd8z4WvwpdYnyR
Mxvg5TRu5Hl7kTFTeK3VRoqNhQhIhZ7IIJfgas1SNLAXpRIHh7QRD/GkLeGQfCi3
dgL/QHzv9t8LPYxfeMIr
=4jdu
-----END PGP SIGNATURE-----

--ZdU67af53GA9VBj6--
