Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaHLJXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:23:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:38602 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaHLJXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:23:02 -0400
Date: Tue, 12 Aug 2014 11:22:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, oleg@redhat.com,
        rostedt@goodmis.org, umgwanakikbuti@gmail.com, tkhai@yandex.ru,
        tim.c.chen@linux.intel.com, mingo@kernel.org, nicolas.pitre@linaro.org
Subject: Re: [PATCH v4 5/6] sched/fair: Remove double_lock_balance() from
 active_load_balance_cpu_stop()
Message-ID: <20140812092246.GQ9918@twins.programming.kicks-ass.net>
References: <20140806075138.24858.23816.stgit@tkhai>
 <1407312416.8424.47.camel@tkhai>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZSdvA9YEY8RSCMrU"
Content-Disposition: inline
In-Reply-To: <1407312416.8424.47.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZSdvA9YEY8RSCMrU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Something like so?

---
Subject: sched/fair: Remove double_lock_balance() from active_load_balance_=
cpu_stop()
=46rom: Kirill Tkhai <ktkhai@parallels.com>
Date: Wed, 6 Aug 2014 12:06:56 +0400

Avoid double_rq_lock() and use ONRQ_MIGRATING for
active_load_balance_cpu_stop(). The advantage is (obviously) not
holding two 'rq->lock's at the same time and thereby increasing
parallelism.

Further note that if there was no task to migrate we will not have
acquired the second rq->lock at all.

The important point to note is that because we acquire dst->lock
immediately after releasing src->lock the potential wait time of
task_rq_lock() callers on ONRQ_MIGRATING is not longer than it would
have been in the double rq lock scenario.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1407312416.8424.47.camel@tkhai
---
 kernel/sched/fair.c |   60 ++++++++++++++++++++++++++++++++++++++---------=
-----
 1 file changed, 44 insertions(+), 16 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5135,6 +5135,8 @@ static int task_hot(struct task_struct *
 {
 	s64 delta;
=20
+	lockdep_assert_held(&env->src_rq->lock);
+
 	if (p->sched_class !=3D &fair_sched_class)
 		return 0;
=20
@@ -5254,6 +5256,9 @@ static
 int can_migrate_task(struct task_struct *p, struct lb_env *env)
 {
 	int tsk_cache_hot =3D 0;
+
+	lockdep_assert_held(&env->src_rq->lock);
+
 	/*
 	 * We do not migrate tasks that are:
 	 * 1) throttled_lb_pair, or
@@ -5338,30 +5343,49 @@ int can_migrate_task(struct task_struct
 }
=20
 /*
- * move_one_task tries to move exactly one task from busiest to this_rq, as
+ * detach_one_task() -- tries to dequeue exactly one task from env->src_rq=
, as
  * part of active balancing operations within "domain".
- * Returns 1 if successful and 0 otherwise.
  *
- * Called with both runqueues locked.
+ * Returns a task if successful and NULL otherwise.
  */
-static int move_one_task(struct lb_env *env)
+static struct task_struct *detach_one_task(struct lb_env *env)
 {
 	struct task_struct *p, *n;
=20
+	lockdep_assert_held(&env->src_rq->lock);
+
 	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
 		if (!can_migrate_task(p, env))
 			continue;
=20
-		move_task(p, env);
+		deactivate_task(env->src_rq, p, 0);
+		p->on_rq =3D ONRQ_MIGRATING;
+		set_task_cpu(p, env->dst_cpu);
+
 		/*
-		 * Right now, this is only the second place move_task()
-		 * is called, so we can safely collect move_task()
-		 * stats here rather than inside move_task().
+		 * Right now, this is only the second place where
+		 * lb_gained[env->idle] is updated (other is move_tasks)
+		 * so we can safely collect stats here rather than
+		 * inside move_tasks().
 		 */
 		schedstat_inc(env->sd, lb_gained[env->idle]);
-		return 1;
+		return p;
 	}
-	return 0;
+	return NULL;
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
+	BUG_ON(task_rq(p) !=3D rq);
+	p->on_rq =3D ONRQ_QUEUED;
+	activate_task(rq, p, 0);
+	check_preempt_curr(rq, p, 0);
+	raw_spin_unlock(&rq->lock);
 }
=20
 static const unsigned int sched_nr_migrate_break =3D 32;
@@ -6940,6 +6964,7 @@ static int active_load_balance_cpu_stop(
 	int target_cpu =3D busiest_rq->push_cpu;
 	struct rq *target_rq =3D cpu_rq(target_cpu);
 	struct sched_domain *sd;
+	struct task_struct *p =3D NULL;
=20
 	raw_spin_lock_irq(&busiest_rq->lock);
=20
@@ -6959,9 +6984,6 @@ static int active_load_balance_cpu_stop(
 	 */
 	BUG_ON(busiest_rq =3D=3D target_rq);
=20
-	/* move a task from busiest_rq to target_rq */
-	double_lock_balance(busiest_rq, target_rq);
-
 	/* Search for an sd spanning us and the target CPU. */
 	rcu_read_lock();
 	for_each_domain(target_cpu, sd) {
@@ -6982,16 +7004,22 @@ static int active_load_balance_cpu_stop(
=20
 		schedstat_inc(sd, alb_count);
=20
-		if (move_one_task(&env))
+		p =3D detach_one_task(&env);
+		if (p)
 			schedstat_inc(sd, alb_pushed);
 		else
 			schedstat_inc(sd, alb_failed);
 	}
 	rcu_read_unlock();
-	double_unlock_balance(busiest_rq, target_rq);
 out_unlock:
 	busiest_rq->active_balance =3D 0;
-	raw_spin_unlock_irq(&busiest_rq->lock);
+	raw_spin_unlock(&busiest_rq->lock);
+
+	if (p)
+		attach_one_task(target_rq, p);
+
+	local_irq_enable();
+
 	return 0;
 }
=20

--ZSdvA9YEY8RSCMrU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6dzmAAoJEHZH4aRLwOS66PUP+wbsPlBz0HZsSpefboeT+wOl
zk35ZCU/V5Mq97HjXTsHvaGbmZaIcoO/y3pLx0ghxVmc7iMO6Nu6LnxDoSc6BvRt
jCtkV3ox44YyVFMXN2RlfuMxC+gQfBZJIs+Te893S1aNNhVutrROoK+SDF8j0i1P
tUKFfBTVJGm/YEppMdrYE+K5Jl8kLmq/Rk/LSqk0NB2K/1xXtaMObV5+AEHNVMq4
8/gqieYVrcY7pEwKf6GnPjzBs6dlTIt6eTosGSmlWDD48SJRjqXpLeEr7p8FvACo
ouyTbgJo27xlEz53Dn5ylaKM/8y6mHo6lOXnTxrdu7ZRg0bavYqmgSXYD6+0K8jz
xcTNNE37cTVPjz9H/PqJWvmTMHLBckycQMxcBmZkqv9f7VWzHYI4VwX/FQexuHtk
48Te3X+9bWi2+SjZX0RBxsuyvWF8BS9WDRlDm6hVxklKM4p6Qh7Ln0pBjVTuGjUP
+Mxr0uCqCyNmpJwsPJAzcg0s9BHiPfKrmAONqp4SKJlSGI0uDgRLdGtDRzQ4JlWI
zHScsZeqwt+xvtt0m4QvJ1EuZqbY8j5VQVQIUHGTmPKziw4J+R+P5lTb5Uo2U+HD
/7KhG730tqhVDCB6oxOyGnSsdR5G8ZdDnFZOBlkv9agSXU95OMelqVeGPCjUhugy
QC+5fO4c6jWSH205Q5LH
=r8VY
-----END PGP SIGNATURE-----

--ZSdvA9YEY8RSCMrU--
