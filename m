Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaHFIWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:22:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaHFIWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:22:11 -0400
Date: Wed, 6 Aug 2014 10:21:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [sched] 36932a9e2b1: +121.2% boot-meminfo.SUnreclaim
Message-ID: <20140806082155.GP9918@twins.programming.kicks-ass.net>
References: <20140805212948.GE14042@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W9vGU1oaykqH3YL2"
Content-Disposition: inline
In-Reply-To: <20140805212948.GE14042@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W9vGU1oaykqH3YL2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 06, 2014 at 05:29:48AM +0800, Fengguang Wu wrote:
> Hi Peter,
>=20
> FYI, we noticed the below changes on
>=20
> git://internal_merge_and_test_tree devel-athens-alpha-201408042000
> commit 36932a9e2b1043506d06414fa988cd5b9592841f ("sched: Fix finish_task_=
switch vs prev_state")
>=20
> test case: vm-vp-1G/boot/1
>=20
> 11b4855f1d9f1cc  36932a9e2b1043506d06414fa=20
> ---------------  -------------------------=20
>       8524 =B1 1%    +121.2%      18858 =B1 0%  TOTAL boot-meminfo.SUnrec=
laim
>       1321 =B1 9%   +3196.6%      43568 =B1 0%  TOTAL boot-meminfo.Kernel=
Stack
>       8756 =B1 0%     +29.8%      11363 =B1 0%  TOTAL boot-slabinfo.num_p=
ages
>      34982 =B1 0%     +29.5%      45311 =B1 0%  TOTAL boot-meminfo.Slab
>     535601 =B1 0%      -9.9%     482375 =B1 0%  TOTAL boot-meminfo.MemFree
>     116621 =B1 0%      +9.4%     127548 =B1 0%  TOTAL boot-slabinfo.num_o=
bjs


*blink*.. how does that happen?

For reference, that's the below patch (I've since given it an actual
Changelog, but the patch is the same).

---
Subject: sched: Fix finish_task_switch vs prev_state
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 29 Jul 2014 11:22:37 +0200

Oleg wondered about the prev_state comment in finish_task_switch().

Aside from it being confusingly worded -- we neither initially
understood the actual problem being described -- we found that we'd
broken the scenario described.

Ever since commit e4a52bcb9a18 ("sched: Remove rq->lock from the first
half of ttwu()") we don't actually acquire rq->lock on wakeups anymore
and therefore holding rq->lock after the switch is no good.

Even if we did, __ARCH_WANT_UNLOCKED_CTXSW was already broken, because
it explicitly didn't hold the rq->lock anymore.

We could fix things by placing a full barrier between the prev->state
read and the next->on_cpu =3D 0 store, seeing how the remote wakeup code
waits for ->on_cpu to become false before proceeding with the wakeup
(so as to avoid having the task running on two cpus at the same time),
however full barriers are expensive.

Instead we read prev->state before the context switch and propagate it
unto finish_task_switch. This trivially solves the problem without
adding extra (and costly) memory barriers.

I'm not sure why we've never seen crashes due to this, it appears
entirely possible.

Fixes: e4a52bcb9a18 ("sched: Remove rq->lock from the first half of ttwu()")
Cc: Ingo Molnar <mingo@kernel.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140729092237.GU12054@laptop.lan
---
 kernel/sched/core.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2190,6 +2190,7 @@ prepare_task_switch(struct rq *rq, struc
  * finish_task_switch - clean up after a task-switch
  * @rq: runqueue associated with task-switch
  * @prev: the thread we just switched away from.
+ * @prev_state: the state of @prev before we switched away from it.
  *
  * finish_task_switch must be called after the context switch, paired
  * with a prepare_task_switch call before the context switch.
@@ -2201,26 +2202,14 @@ prepare_task_switch(struct rq *rq, struc
  * with the lock held can cause deadlocks; see schedule() for
  * details.)
  */
-static void finish_task_switch(struct rq *rq, struct task_struct *prev)
+static void
+finish_task_switch(struct rq *rq, struct task_struct *prev, long prev_stat=
e)
 	__releases(rq->lock)
 {
 	struct mm_struct *mm =3D rq->prev_mm;
-	long prev_state;
=20
 	rq->prev_mm =3D NULL;
=20
-	/*
-	 * A task struct has one reference for the use as "current".
-	 * If a task dies, then it sets TASK_DEAD in tsk->state and calls
-	 * schedule one last time. The schedule call will never return, and
-	 * the scheduled task must drop that reference.
-	 * The test for TASK_DEAD must occur while the runqueue locks are
-	 * still held, otherwise prev could be scheduled on another cpu, die
-	 * there before we look at prev->state, and then the reference would
-	 * be dropped twice.
-	 *		Manfred Spraul <manfred@colorfullife.com>
-	 */
-	prev_state =3D prev->state;
 	vtime_task_switch(prev);
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(prev, current);
@@ -2279,7 +2268,7 @@ asmlinkage __visible void schedule_tail(
 {
 	struct rq *rq =3D this_rq();
=20
-	finish_task_switch(rq, prev);
+	finish_task_switch(rq, prev, 0);
=20
 	/*
 	 * FIXME: do we need to worry about rq being invalidated by the
@@ -2304,6 +2293,21 @@ context_switch(struct rq *rq, struct tas
 	       struct task_struct *next)
 {
 	struct mm_struct *mm, *oldmm;
+	/*
+	 * A task struct has one reference for the use as "current".
+	 * If a task dies, then it sets TASK_DEAD in tsk->state and calls
+	 * schedule one last time. The schedule call will never return, and
+	 * the scheduled task must drop that reference.
+	 *
+	 * We must observe prev->state before clearing prev->on_cpu (in
+	 * finish_lock_switch), otherwise a concurrent wakeup can get prev
+	 * running on another CPU and we could race with its RUNNING -> DEAD
+	 * transition, and then the reference would be dropped twice.
+	 *
+	 * We avoid the race by observing prev->state while it is still
+	 * current.
+	 */
+	long prev_state =3D prev->state;
=20
 	prepare_task_switch(rq, prev, next);
=20
@@ -2347,7 +2351,7 @@ context_switch(struct rq *rq, struct tas
 	 * CPUs since it called schedule(), thus the 'rq' on its stack
 	 * frame will be invalid.
 	 */
-	finish_task_switch(this_rq(), prev);
+	finish_task_switch(this_rq(), prev, prev_state);
 }
=20
 /*

--W9vGU1oaykqH3YL2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT4eWjAAoJEHZH4aRLwOS6OdIP/RWWMuCSp3xuO5hkCg6IgPw/
V7DfVv3fsc8vhhXGxxvN96VH2k/FU3LA7ue8EXQsrERnMsqdKTdiAPj9wW59fOl5
zL4Mg6vchvrHNarKx9qV961GtYpgtkkBSYSly5lJbZ3V5aJP1AfscuMAMBEJJhAK
fuPP5jfz+9rVq89REGm/C4QJ7qmdi0JuA/R/ANIqzOrU2RbuLXfaJtpPSU8d/fGH
9XSy95MgQlH37Iv7Eqv2lab1fWrU9HfbdHJtUUVlSsE6YIsTpdAV/xH1bEkwnhVP
BQ0hNjQq8qE4pIjZIAO/xbeve2SIz+kHPxlsZJiqvWzYeKUCKbslfZevltMLBesu
QNGPOOFQ9eNgLtKwrmjL7L2Yq6Rt95VVhF3oDp8/VEHoOIUYUqNc3nv+jGx57PUj
sRj9ZsSi/XhykeVdPVFl9tXPkZe4m6mR4rspDTqDeBimBZ8Z0+Luf4lJC5XTfdun
w4qWrfFrpNvzcO2Jn09K0Bf3nP0r5cwTVdjcAYTa0tjo4ifuNz+M5xqJHi+bAJng
QYC2mPWN93lRx7ZDn5mrjqvPLN/LQ8zpwTGQDE7V5sQd5zLhvZMM86/iKR2wDTiZ
13VjYGobheB6DHX3MrOI0VCNYPE7XKfiGcKg8Rbj8HNnY4HExZIdS1DV05gK26IZ
yLAlanFIxlmdtv2pgOBr
=1cWd
-----END PGP SIGNATURE-----

--W9vGU1oaykqH3YL2--
