Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaETNPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:15:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:33891 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaETNPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:15:32 -0400
Date: Tue, 20 May 2014 15:15:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: bsegall@google.com
Cc: Roman Gushchin <klamm@yandex-team.ru>, linux-kernel@vger.kernel.org,
        pjt@google.com, chris.j.arges@canonical.com,
        gregkh@linuxfoundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched: tg_set_cfs_bandwidth() causes rq->lock deadlock
Message-ID: <20140520131526.GE11096@twins.programming.kicks-ass.net>
References: <87mwej0yja.wl%klamm@yandex-team.ru>
 <xm26k39n3pl9.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <87lhu215ky.wl%klamm@yandex-team.ru>
 <20140519103247.GX30445@twins.programming.kicks-ass.net>
 <xm26wqdh3cde.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FAVlh7XA/4iOdtaa"
Content-Disposition: inline
In-Reply-To: <xm26wqdh3cde.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FAVlh7XA/4iOdtaa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 10:30:05AM -0700, bsegall@google.com wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
>=20
> > On Fri, May 16, 2014 at 12:38:21PM +0400, Roman Gushchin wrote:
> >
> >> I still think, there is a deadlock. I'll try to explain.
> >> Three CPUs must be involved:
> >> CPU0				CPU1				CPU2
> >> take rq->lock			period timer fired	=09
> >> ...				take cfs_b lock
> >> ...				...				tg_set_cfs_bandwidth()
> >> throttle_cfs_rq()		release cfs_b lock		take cfs_b lock
> >> ...				distribute_cfs_runtime()	timer_active =3D 0
> >> take cfs_b->lock		wait for rq->lock		...
> >> __start_cfs_bandwidth()=09
> >> {wait for timer callback
> >>  break if timer_active =3D=3D 1}
> >>=20
> >> So, CPU0 and CPU1 are deadlocked.
> >
> > OK, so can someone explain this ->timer_active thing? esp. what's the
> > 'obvious' difference with hrtimer_active()?
>=20
> timer_active is only changed or checked under cfs_b lock, so that we can
> be certain that the timer is active whenever runtime isn't full. We
> can't use hrtimer_active because the timer might have unlocked the cfs_b
> on another cpu and be about to return HRTIMER_NORESTART.

The more I look at that code the more I'm convinced its crack, that
entire __start_cfs_bandwidth() thing is brain melting, we don't need to
cancel a timer before starting it, *hrtimer_start*() will happily remove
the timer for you if its still enqueued.

Removing that, removes a big part of the problem, no more ugly cancel
loop to get stuck in.

So now, if I understood you right, the entire reason you have this
cfs_b->lock guarded ->timer_active nonsense is to make sure we don't
accidentally loose the timer.

It appears to me that it should be possible to guarantee that same by
unconditionally (re)starting the timer when !queued. Because regardless
what hrtimer::function will return, if we beat it to (re)enqueue the
timer, it doesn't matter.

Which leads us to what I think is a BUG in the current hrtimer code (and
one wonders why we never hit that), because we drop the cpu_base->lock
over calling hrtimer::function, hrtimer_start_range_ns() can in fact
come in and (re)enqueue the timer, if hrtimer::function then returns
HRTIMER_RESTART, we'll hit that BUG_ON() before trying to enqueue the
timer once more.

So I _think_ something like the below would actually solve all the
problems, no?

Completely untested... does anybody have a 'useful' test case for this
bw stuff?

---
 kernel/hrtimer.c     |  9 ++++++---
 kernel/sched/core.c  | 10 ++++++----
 kernel/sched/fair.c  | 42 +++---------------------------------------
 kernel/sched/sched.h |  2 +-
 4 files changed, 16 insertions(+), 47 deletions(-)

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
index 4ea7b3f1a087..829a158948a6 100644
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
 	ktime_t soft, hard, now;
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
index 28ccf502c63c..27dfb59f6aaf 100644
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
@@ -3446,13 +3443,6 @@ static int do_sched_cfs_period_timer(struct cfs_band=
width *cfs_b, int overrun)
 	if (idle)
 		goto out_unlock;
=20
-	/*
-	 * if we have relooped after returning idle once, we need to update our
-	 * status as actually running, so that other cpus doing
-	 * __start_cfs_bandwidth will stop trying to cancel us.
-	 */
-	cfs_b->timer_active =3D 1;
-
 	__refill_cfs_bandwidth_runtime(cfs_b);
=20
 	if (!throttled) {
@@ -3499,8 +3489,6 @@ static int do_sched_cfs_period_timer(struct cfs_bandw=
idth *cfs_b, int overrun)
 	 */
 	cfs_b->idle =3D 0;
 out_unlock:
-	if (idle)
-		cfs_b->timer_active =3D 0;
 	raw_spin_unlock(&cfs_b->lock);
=20
 	return idle;
@@ -3713,30 +3701,6 @@ static void init_cfs_rq_runtime(struct cfs_rq *cfs_r=
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
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b2cbe81308af..3214eb78fd91 100644
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

--FAVlh7XA/4iOdtaa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTe1VpAAoJEHZH4aRLwOS6QVcQAINHQuPL4ZVQpCzqn9b1RQmk
nxFkilZT5EjxXJL/Yqc0JUBaCOgs4oTQdrCy3rcqjIpYhvUrcfJ9fY+2pmlv2MNM
McoEVD67y5/3jeDIEAWSXIt95EU8kMtN/oqieo/daouuK9DGL34KqnBKerl/dVi2
fS6Cr636CwDUlMz2OsDn6lziKZy0ClSmR4hvGnmB2e/pzRI/i8WHIPs0bvRgpTbG
tX/KrRWfDpNmnabVMOgZSOfVjuO2t8KIE1PpZnHvUpVnVEJoZtMoy5OVSRPgYfB7
EOf0wLjzGX/mf7iQ3nmv+OkVs6ibHPKRr/zo5BjY1tJunnsp5CJeZyv0BVWaEpkU
T91Zs5U1fSSMMK4pwPyJ2MkMRMgu+IGDUhcxe5Camqccr3SqpE1DyYbIgPkfsb0T
UyDE/Br3YevNh3l06um+HcjoiuavnxMDUSRmwVlocAEOjBv8r9LxnjYk6ox+uJp1
kMOMk2Br5kD/enCTtpLrsxYVT6uWn/k1pj1mYftgx/w5+O4NxWPKzxRmtvGlsHdO
Q6l34aLKcCs94UC46fuYWpY7PlRjlf6RR0kpj439hRw3KNZoruQLRp2h9cFY3n/I
J6W/5ayvPNWyTSvAaheE36zQNN9rnyBW5Z1z65FlhNdHCFC7rX3YU70cLhTnES0t
XYskfFMvyWNAN3FFF2Aa
=NUfA
-----END PGP SIGNATURE-----

--FAVlh7XA/4iOdtaa--
