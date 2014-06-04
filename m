Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaFDKlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:41:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:46032 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaFDKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:41:29 -0400
Date: Wed, 4 Jun 2014 12:41:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com, laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: [PATCH] sched: Fix migration_cpu_stop() return value
Message-ID: <20140604104122.GL30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KnDXMCVtq+otksxP"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KnDXMCVtq+otksxP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

A while ago I did a similar patch for some debugging, but looking at it
again today I realized we should probably fix this anyway.

---
Subject: sched: Fix migration_cpu_stop() return value

There are a number of migration_cpu_stop() users; and some actually care
about the success of the migration. So report this.

In particular migrate_task_to() as used from task_numa_migrate()
actually tests this return value.

Also change set_cpus_allowed_ptr() to propagate this return value, since
it already returns other errors.

Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4633,11 +4633,13 @@ int set_cpus_allowed_ptr(struct task_str
 	dest_cpu =3D cpumask_any_and(cpu_active_mask, new_mask);
 	if (p->on_rq) {
 		struct migration_arg arg =3D { p, dest_cpu };
+
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, p, &flags);
-		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
+		ret =3D stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
 		tlb_migrate_finish(p->mm);
-		return 0;
+
+		return ret;
 	}
 out:
 	task_rq_unlock(rq, p, &flags);
@@ -4747,19 +4749,24 @@ void sched_setnuma(struct task_struct *p
  * migration_cpu_stop - this will be executed by a highprio stopper thread
  * and performs thread migration by bumping thread off CPU then
  * 'pushing' onto another runqueue.
+ *
+ * Returns 0 on success, -EAGAIN on failure to migrate.
  */
 static int migration_cpu_stop(void *data)
 {
 	struct migration_arg *arg =3D data;
+	int ret =3D 0;
=20
 	/*
 	 * The original target cpu might have gone down and we might
 	 * be on another cpu but it doesn't matter.
 	 */
 	local_irq_disable();
-	__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu);
+	if (!__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu))
+		ret =3D -EAGAIN;
 	local_irq_enable();
-	return 0;
+
+	return ret;
 }
=20
 #ifdef CONFIG_HOTPLUG_CPU

--KnDXMCVtq+otksxP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjvfSAAoJEHZH4aRLwOS6XMYP/Ah/ZCtyoA6HhXEcPeMZuij7
PPae9EFbURDqEwMAnrWu7UI2NoU7wDBOEOUqT9nS/LG1PxJaGssdrgQDEnAKbzXH
9GgHb/0PGOCqZHmhxow0WVcRWdQFSsYbJOshmzrZ3A7am5fS4ZykJW6Zi/k3MngS
p3yYShHaCrwFmMLZYHnzyDIM60fyge4co5p/LafUhwLtyv2xTtdb4Rj+eypPj7vS
9aX+KX5+On418tAeyzN3rBKJ6xlWgaB8dhHUcud8RJVMLSFrrKmVj83u/sE9QNkH
SmX1bw/lebE1GZFWrMQSr3BO/lswOLSnqOfSAaLXNYnTdRz3N5dVxAGqFUMuJ0c1
Cui3MZAI6E7cwXO0hxyrr27W7yXzV+ynhtqhT4uIzeHXty6594NorSxo48bAeMBS
vWTe9k3Agg5GMGex91gn1x33N4ze+aNSrf2TBY6VjfHAulQ3pgA4/Iy7F9gABzuC
+Be905YRfZ1jfbXyrZ8FmpkZUGm77biJEhj5jFPHIxWKB8iB81TsXnZQNGikxYhY
4gw+30EsgjXJ3YLZqMz8po5AK9EUBz8gGd4OXzo2edNqaf5gA9CVo3huZDhHX6wH
Bj+qqS3GroSpYR1ZmSAlOJif1H1bHUCQ+Z4rirBZAX7RpDHA+JluFptk5Vw/Y49v
S8KjTz9yTBYG6i2rKiVV
=MJw8
-----END PGP SIGNATURE-----

--KnDXMCVtq+otksxP--
