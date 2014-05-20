Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaETO4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:56:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:34480 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbaETOz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:55:59 -0400
Date: Tue, 20 May 2014 16:55:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: bsegall@google.com
Cc: Roman Gushchin <klamm@yandex-team.ru>, linux-kernel@vger.kernel.org,
        pjt@google.com, chris.j.arges@canonical.com,
        gregkh@linuxfoundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched: tg_set_cfs_bandwidth() causes rq->lock deadlock
Message-ID: <20140520145554.GT13658@twins.programming.kicks-ass.net>
References: <87mwej0yja.wl%klamm@yandex-team.ru>
 <xm26k39n3pl9.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <87lhu215ky.wl%klamm@yandex-team.ru>
 <20140519103247.GX30445@twins.programming.kicks-ass.net>
 <xm26wqdh3cde.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140520131526.GE11096@twins.programming.kicks-ass.net>
 <20140520140155.GS13658@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qnK4RqISe3HuYx1/"
Content-Disposition: inline
In-Reply-To: <20140520140155.GS13658@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qnK4RqISe3HuYx1/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 04:01:55PM +0200, Peter Zijlstra wrote:

> Hmm,. doesn't this also mean its entirely unsafe to call
> hrtimer_forward*() from the timer callback, because it might be changing
> the time of an already enqueued timer, which would corrupt the rb-tree
> order.
>=20
> Lemme go find a nice way out of this mess, I think I'm responsible for
> creating it in the first place :-(

Ah, so since the hrtimer doesn't provide any serialization of its own,
per design, we should serialize the access to it ourselves, which is
easily done.

Something like so would do I suppose..

Here we make sure to be holding the bandwidth lock (be it cfs_b->lock or
rt_b->rt_runtime_lock) around both starting the timer and in the handler
while modifying its expiration date.

---
 kernel/hrtimer.c     |  9 +++++---
 kernel/sched/core.c  | 12 ++++++----
 kernel/sched/fair.c  | 65 +++++++++++-------------------------------------=
----
 kernel/sched/rt.c    | 14 +++++------
 kernel/sched/sched.h |  4 ++--
 5 files changed, 34 insertions(+), 70 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3ab28993f6e0..28942c65635e 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1273,11 +1273,14 @@ static void __run_hrtimer(struct hrtimer *timer, kt=
ime_t *now)
 	 * Note: We clear the CALLBACK bit after enqueue_hrtimer and
 	 * we do not reprogramm the event hardware. Happens either in
 	 * hrtimer_start_range_ns() or in hrtimer_interrupt()
+	 *
+	 * Note: Because we dropped the cpu_base->lock above,
+	 * hrtimer_start_range_ns() can have popped in and enqueued the timer
+	 * for us already.
 	 */
-	if (restart !=3D HRTIMER_NORESTART) {
-		BUG_ON(timer->state !=3D HRTIMER_STATE_CALLBACK);
+	if (restart !=3D HRTIMER_NORESTART &&
+	    !(timer->state & HRTIMER_STATE_ENQUEUED))
 		enqueue_hrtimer(timer, base);
-	}
=20
 	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
=20
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4ea7b3f1a087..1f4602993d37 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -106,17 +106,17 @@ void __smp_mb__after_atomic(void)
 EXPORT_SYMBOL(__smp_mb__after_atomic);
 #endif
=20
-void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
+int start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
 	unsigned long delta;
-	ktime_t soft, hard, now;
+	ktime_t soft, hard;
+	int overruns =3D 0;
=20
 	for (;;) {
-		if (hrtimer_active(period_timer))
+		if (hrtimer_is_queued(period_timer))
 			break;
=20
-		now =3D hrtimer_cb_get_time(period_timer);
-		hrtimer_forward(period_timer, now, period);
+		overruns +=3D hrtimer_forward_now(period_timer, period);
=20
 		soft =3D hrtimer_get_softexpires(period_timer);
 		hard =3D hrtimer_get_expires(period_timer);
@@ -124,6 +124,8 @@ void start_bandwidth_timer(struct hrtimer *period_timer=
, ktime_t period)
 		__hrtimer_start_range_ns(period_timer, soft, delta,
 					 HRTIMER_MODE_ABS_PINNED, 0);
 	}
+
+	return overruns;
 }
=20
 DEFINE_MUTEX(sched_domains_mutex);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 28ccf502c63c..11152b621a31 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3146,15 +3146,13 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs=
_rq)
 		amount =3D min_amount;
 	else {
 		/*
-		 * If the bandwidth pool has become inactive, then at least one
+		 * If we had overruns starting the timer, then at least one
 		 * period must have elapsed since the last consumption.
 		 * Refresh the global state and ensure bandwidth timer becomes
 		 * active.
 		 */
-		if (!cfs_b->timer_active) {
+		if (start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period))
 			__refill_cfs_bandwidth_runtime(cfs_b);
-			__start_cfs_bandwidth(cfs_b);
-		}
=20
 		if (cfs_b->runtime > 0) {
 			amount =3D min(cfs_b->runtime, min_amount);
@@ -3331,8 +3329,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	cfs_rq->throttled_clock =3D rq_clock(rq);
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
-	if (!cfs_b->timer_active)
-		__start_cfs_bandwidth(cfs_b);
+	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
 	raw_spin_unlock(&cfs_b->lock);
 }
=20
@@ -3430,12 +3427,13 @@ static u64 distribute_cfs_runtime(struct cfs_bandwi=
dth *cfs_b,
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int over=
run)
 {
 	u64 runtime, runtime_expires;
-	int idle =3D 1, throttled;
+	bool idle, throttled;
+
+	lockdep_assert_held(&cfs_b->lock);
=20
-	raw_spin_lock(&cfs_b->lock);
 	/* no need to continue the timer with no bandwidth constraint */
 	if (cfs_b->quota =3D=3D RUNTIME_INF)
-		goto out_unlock;
+		return 1;
=20
 	throttled =3D !list_empty(&cfs_b->throttled_cfs_rq);
 	/* idle depends on !throttled (for the case of a large deficit) */
@@ -3444,21 +3442,14 @@ static int do_sched_cfs_period_timer(struct cfs_ban=
dwidth *cfs_b, int overrun)
=20
 	/* if we're going inactive then everything else can be deferred */
 	if (idle)
-		goto out_unlock;
-
-	/*
-	 * if we have relooped after returning idle once, we need to update our
-	 * status as actually running, so that other cpus doing
-	 * __start_cfs_bandwidth will stop trying to cancel us.
-	 */
-	cfs_b->timer_active =3D 1;
+		return 1;
=20
 	__refill_cfs_bandwidth_runtime(cfs_b);
=20
 	if (!throttled) {
 		/* mark as potentially idle for the upcoming period */
 		cfs_b->idle =3D 1;
-		goto out_unlock;
+		return 0;
 	}
=20
 	/* account preceding periods in which throttling occurred */
@@ -3498,12 +3489,7 @@ static int do_sched_cfs_period_timer(struct cfs_band=
width *cfs_b, int overrun)
 	 * timer to remain active while there are any throttled entities.)
 	 */
 	cfs_b->idle =3D 0;
-out_unlock:
-	if (idle)
-		cfs_b->timer_active =3D 0;
-	raw_spin_unlock(&cfs_b->lock);
-
-	return idle;
+	return 0;
 }
=20
 /* a cfs_rq won't donate quota below this amount */
@@ -3676,19 +3662,18 @@ static enum hrtimer_restart sched_cfs_period_timer(=
struct hrtimer *timer)
 {
 	struct cfs_bandwidth *cfs_b =3D
 		container_of(timer, struct cfs_bandwidth, period_timer);
-	ktime_t now;
 	int overrun;
 	int idle =3D 0;
=20
+	raw_spin_lock(&cfs_b->lock);
 	for (;;) {
-		now =3D hrtimer_cb_get_time(timer);
-		overrun =3D hrtimer_forward(timer, now, cfs_b->period);
-
+		overrun =3D hrtimer_forward_now(timer, cfs_b->period);
 		if (!overrun)
 			break;
=20
 		idle =3D do_sched_cfs_period_timer(cfs_b, overrun);
 	}
+	raw_spin_unlock(&cfs_b->lock);
=20
 	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
 }
@@ -3713,30 +3698,6 @@ static void init_cfs_rq_runtime(struct cfs_rq *cfs_r=
q)
 	INIT_LIST_HEAD(&cfs_rq->throttled_list);
 }
=20
-/* requires cfs_b->lock, may release to reprogram timer */
-void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
-{
-	/*
-	 * The timer may be active because we're trying to set a new bandwidth
-	 * period or because we're racing with the tear-down path
-	 * (timer_active=3D=3D0 becomes visible before the hrtimer call-back
-	 * terminates).  In either case we ensure that it's re-programmed
-	 */
-	while (unlikely(hrtimer_active(&cfs_b->period_timer)) &&
-	       hrtimer_try_to_cancel(&cfs_b->period_timer) < 0) {
-		/* bounce the lock to allow do_sched_cfs_period_timer to run */
-		raw_spin_unlock(&cfs_b->lock);
-		cpu_relax();
-		raw_spin_lock(&cfs_b->lock);
-		/* if someone else restarted the timer then we're done */
-		if (cfs_b->timer_active)
-			return;
-	}
-
-	cfs_b->timer_active =3D 1;
-	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
-}
-
 static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
 	hrtimer_cancel(&cfs_b->period_timer);
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 7795e292f4c9..60bfb8caa27a 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -17,19 +17,20 @@ static enum hrtimer_restart sched_rt_period_timer(struc=
t hrtimer *timer)
 {
 	struct rt_bandwidth *rt_b =3D
 		container_of(timer, struct rt_bandwidth, rt_period_timer);
-	ktime_t now;
-	int overrun;
 	int idle =3D 0;
+	int overrun;
=20
+	raw_spin_lock(&rt_b->rt_runtime_lock);
 	for (;;) {
-		now =3D hrtimer_cb_get_time(timer);
-		overrun =3D hrtimer_forward(timer, now, rt_b->rt_period);
-
+		overrun =3D hrtimer_forward_now(timer, rt_b->rt_period);
 		if (!overrun)
 			break;
=20
+		raw_spin_unlock(&rt_b->rt_runtime_lock);
 		idle =3D do_sched_rt_period_timer(rt_b, overrun);
+		raw_spin_lock(&rt_b->rt_runtime_lock);
 	}
+	raw_spin_unlock(&rt_b->rt_runtime_lock);
=20
 	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
 }
@@ -51,9 +52,6 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 	if (!rt_bandwidth_enabled() || rt_b->rt_runtime =3D=3D RUNTIME_INF)
 		return;
=20
-	if (hrtimer_active(&rt_b->rt_period_timer))
-		return;
-
 	raw_spin_lock(&rt_b->rt_runtime_lock);
 	start_bandwidth_timer(&rt_b->rt_period_timer, rt_b->rt_period);
 	raw_spin_unlock(&rt_b->rt_runtime_lock);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b2cbe81308af..0937e341e079 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -187,7 +187,7 @@ struct cfs_bandwidth {
 	s64 hierarchal_quota;
 	u64 runtime_expires;
=20
-	int idle, timer_active;
+	int idle;
 	struct hrtimer period_timer, slack_timer;
 	struct list_head throttled_cfs_rq;
=20
@@ -1288,7 +1288,7 @@ static inline void sched_rt_avg_update(struct rq *rq,=
 u64 rt_delta) { }
 static inline void sched_avg_update(struct rq *rq) { }
 #endif
=20
-extern void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t pe=
riod);
+extern int start_bandwidth_timer(struct hrtimer *period_timer, ktime_t per=
iod);
=20
 #ifdef CONFIG_SMP
 #ifdef CONFIG_PREEMPT

--qnK4RqISe3HuYx1/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTe2z6AAoJEHZH4aRLwOS6zb8P/3cycIwNQRUYMFDWctIRmwpM
ynnaYQe1LlGoLRLZqaRAPECaKguLa7vvdyVxIXxS0h+IzaKDitCZDnt319mXIlPH
smkvflpUBN1nG4/L0l4uMAoexigqDdwJBNTUv4ImCvMc7QrjwT70MAsa1GeghOks
N6q4sBov6tK9xh+GM9aFETZBLr/piwPS1ksXN9Eqm/J0ujDJb5KzDkuHsJNFfWxk
0gD04TIchrbgCuXGdxS3O7oFGzAh9R0yNX5Ivj2SNNicolrhmuE2V6vPO10kpkjX
ib5V56hUpDy83yILnWnwaYHrt7rZVwyNf4hzArreXQ3L1KbymE+cZ1pYZHPZdPbT
8QlcUNH9WUCZS7apYq0VKYff01T3RfeRSTB+jxLXoVOnme9S4Ee8YET2AyCC5l9X
q7mmCmmhUYh4S3j/X/BdBu8ni4Jm58L+sevysiAJe/azCOBYCPFh+FSKCIp1bmAS
adnMJEIztw+1eo42LV9BBiLSqeX0sO5Uj5KHLePHCxjCwzG5G+3Bsm2AWUwg+2SJ
R+1oqS73ukudxwIocE1nHfE/b17pN9CAaWihOl/0uYCBCD8IK7tYRdH05VXIr1Dg
75NKr0DsjPKrcrVZxUYTG0SCIHHu/85izmLi8FQRMIALFVuwzB3vQTdgLfOOpMFc
sHCXDXEhkIRSbworDqTq
=aL0y
-----END PGP SIGNATURE-----

--qnK4RqISe3HuYx1/--
