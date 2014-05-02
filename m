Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaEBPmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:42:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50704 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaEBPmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:42:33 -0400
Date: Fri, 2 May 2014 17:42:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140502154217.GW11096@twins.programming.kicks-ass.net>
References: <20140429190108.GB30445@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu>
 <20140430184437.GH17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu>
 <20140501150948.GR11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="47eKBCiAZYFK5l32"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--47eKBCiAZYFK5l32
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 01, 2014 at 02:49:01PM -0400, Vince Weaver wrote:
> It is a rance condition of sorts, because it's just a 10us or so=20
> interleaving of calls that causes the bug to happen or not.
>=20
> In the good trace:
>=20
> 	[parent] __perf_event_task_sched_out (and hence perf_swevent_del)
> 	[child]  perf_release
>=20
> In the buggy trace:
>=20
> 	[child] perf_release
> 	[parent] __perf_event_task_sched_out (perf_swevent_del never happens)
>=20

Can you give this a spin?

---
Subject: perf: Fix race in removing an event
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Fri May 2 16:56:01 CEST 2014

When removing a (sibling) event we do:

	raw_spin_lock_irq(&ctx->lock);
	perf_group_detach(event);
	raw_spin_unlock_irq(&ctx->lock);

	<hole>

	perf_remove_from_context(event);
		raw_spin_lock_irq(&ctx->lock);
		...
		raw_spin_unlock_irq(&ctx->lock);

Now, assuming the event is a sibling, it will be 'unreachable' for
things like ctx_sched_out() because that iterates the
groups->siblings, and we just unhooked the sibling.

So, if during <hole> we get ctx_sched_out(), it will miss the event
and not call event_sched_out() on it, leaving it programmed on the
PMU.

The subsequent perf_remove_from_context() call will find the ctx is
inactive and only call list_del_event() to remove the event from all
other lists.

Hereafter we can proceed to free the event; while still programmed!

Close this hole by moving perf_group_detach() inside the same
ctx->lock region(s) perf_remove_from_context() has.

The condition on inherited events only in __perf_event_exit_task() is
likely complete crap because non-inherited events are part of groups
too and we're tearing down just the same. But leave that for another
patch.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Much-staring-at-traces-by: Vince Weaver <vincent.weaver@maine.edu>
Much-staring-at-traces-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/events/core.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1444,6 +1444,11 @@ group_sched_out(struct perf_event *group
 		cpuctx->exclusive =3D 0;
 }
=20
+struct remove_event {
+	struct perf_event *event;
+	bool detach_group;
+};
+
 /*
  * Cross CPU call to remove a performance event
  *
@@ -1452,12 +1457,15 @@ group_sched_out(struct perf_event *group
  */
 static int __perf_remove_from_context(void *info)
 {
-	struct perf_event *event =3D info;
+	struct remove_event *re =3D info;
+	struct perf_event *event =3D re->event;
 	struct perf_event_context *ctx =3D event->ctx;
 	struct perf_cpu_context *cpuctx =3D __get_cpu_context(ctx);
=20
 	raw_spin_lock(&ctx->lock);
 	event_sched_out(event, cpuctx, ctx);
+	if (re->detach_group)
+		perf_group_detach(event);
 	list_del_event(event, ctx);
 	if (!ctx->nr_events && cpuctx->task_ctx =3D=3D ctx) {
 		ctx->is_active =3D 0;
@@ -1482,10 +1490,14 @@ static int __perf_remove_from_context(vo
  * When called from perf_event_exit_task, it's OK because the
  * context has been detached from its task.
  */
-static void perf_remove_from_context(struct perf_event *event)
+static void perf_remove_from_context(struct perf_event *event, bool detach=
_group)
 {
 	struct perf_event_context *ctx =3D event->ctx;
 	struct task_struct *task =3D ctx->task;
+	struct remove_event re =3D {
+		.event =3D event,
+		.detach_group =3D detach_group,
+	};
=20
 	lockdep_assert_held(&ctx->mutex);
=20
@@ -1494,12 +1506,12 @@ static void perf_remove_from_context(str
 		 * Per cpu events are removed via an smp call and
 		 * the removal is always successful.
 		 */
-		cpu_function_call(event->cpu, __perf_remove_from_context, event);
+		cpu_function_call(event->cpu, __perf_remove_from_context, &re);
 		return;
 	}
=20
 retry:
-	if (!task_function_call(task, __perf_remove_from_context, event))
+	if (!task_function_call(task, __perf_remove_from_context, &re))
 		return;
=20
 	raw_spin_lock_irq(&ctx->lock);
@@ -1516,6 +1528,8 @@ static void perf_remove_from_context(str
 	 * Since the task isn't running, its safe to remove the event, us
 	 * holding the ctx->lock ensures the task won't get scheduled in.
 	 */
+	if (detach_group)
+		perf_group_detach(event);
 	list_del_event(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
 }
@@ -3285,10 +3299,7 @@ int perf_event_release_kernel(struct per
 	 *     to trigger the AB-BA case.
 	 */
 	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
-	raw_spin_lock_irq(&ctx->lock);
-	perf_group_detach(event);
-	raw_spin_unlock_irq(&ctx->lock);
-	perf_remove_from_context(event);
+	perf_remove_from_context(event, true);
 	mutex_unlock(&ctx->mutex);
=20
 	free_event(event);
@@ -7180,7 +7191,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		struct perf_event_context *gctx =3D group_leader->ctx;
=20
 		mutex_lock(&gctx->mutex);
-		perf_remove_from_context(group_leader);
+		perf_remove_from_context(group_leader, false);
=20
 		/*
 		 * Removing from the context ends up with disabled
@@ -7190,7 +7201,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		perf_event__state_init(group_leader);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
-			perf_remove_from_context(sibling);
+			perf_remove_from_context(sibling, false);
 			perf_event__state_init(sibling);
 			put_ctx(gctx);
 		}
@@ -7320,7 +7331,7 @@ void perf_pmu_migrate_context(struct pmu
 	mutex_lock(&src_ctx->mutex);
 	list_for_each_entry_safe(event, tmp, &src_ctx->event_list,
 				 event_entry) {
-		perf_remove_from_context(event);
+		perf_remove_from_context(event, false);
 		unaccount_event_cpu(event, src_cpu);
 		put_ctx(src_ctx);
 		list_add(&event->migrate_entry, &events);
@@ -7382,13 +7393,7 @@ __perf_event_exit_task(struct perf_event
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	if (child_event->parent) {
-		raw_spin_lock_irq(&child_ctx->lock);
-		perf_group_detach(child_event);
-		raw_spin_unlock_irq(&child_ctx->lock);
-	}
-
-	perf_remove_from_context(child_event);
+	perf_remove_from_context(child_event, !!child_event->parent);
=20
 	/*
 	 * It can happen that the parent exits first, and has events

--47eKBCiAZYFK5l32
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTY7zPAAoJEHZH4aRLwOS6o50P/39434rDB8hDMM8ohuh/YXWQ
mTkCboGAJyjXANalOB6HVVus0BJoX2m/Gz0tLm6i9xA39x51gIVZzDDhXJ3YCWil
3E1jP4ICMMCrqXLq5zjD6df9GV4mT1ZqT6WU6c2QXEIB4egJGdi3lqFoQXIP61U9
ssZTuIOjreuI3H+3Hd3/U7ve3qM/fN8fUlkJlIS7a80SFAPgokIVenUhTB17Ereu
4HR+z6IM/Locy4UdsHaWyDTSbSRHF+MICkQjEFBgL4HxyYa6Cn0K2PJEK12qT7+9
1Dx2O0Q0iZ/9fgANNEWCCu0tOpXBZ2HGa8Og1a0pn5WV5ene16+LLwD3fpeCeW8A
jNPe5Gw4JJeY1mYhnhi2gZvUbBVzWs1quJ0vTcmEBshoL1lNSV6xHMZtQU5UK729
nBzZmaKPCg2XE9WpjpqIFm8cAX3HkripRwj053ceJFxXBm6n5H/kTH3IgDncT2kR
8OudBLIZkGBnPvue5vj/rpq3BiPqVcRwam6j91/AE2c0lDJdMSZw3rphGh2u8Cxr
reYvb6gbhZV0MjRhjmSnBxe540P8z2HiDUXMjajOOtYWX6augDNF3oF6JheE4agX
HN5xSCC2105581urizoKio4A4BY8yes9iJrr8YKknuUDNogE9NN6F23LauGz2nrO
C0hho7d9HWOxNRperq2M
=PV8N
-----END PGP SIGNATURE-----

--47eKBCiAZYFK5l32--
