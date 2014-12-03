Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661AbaLCAkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:40:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933487AbaLCAkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:40:20 -0500
Date: Wed, 3 Dec 2014 11:40:11 +1100
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH - v3?] workqueue: allow rescuer thread to do more work.
Message-ID: <20141203114011.5d02dc43@notabene.brown>
In-Reply-To: <20141202204304.GR10918@htj.dyndns.org>
References: <20141029172608.39119c80@notabene.brown>
	<20141029143210.GA25226@htj.dyndns.org>
	<20141030101932.2241daa7@notabene.brown>
	<20141104142240.GD14459@htj.dyndns.org>
	<20141106165811.GA2338@gmail.com>
	<545C368C.5040704@cn.fujitsu.com>
	<20141110162848.6f2246bb@notabene.brown>
	<20141110085250.GB15948@quack.suse.cz>
	<20141111090402.35fa0700@notabene.brown>
	<20141118152754.60b0c75e@notabene.brown>
	<20141202204304.GR10918@htj.dyndns.org>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/qYsqL/oqJE_w7daA/EYspQT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qYsqL/oqJE_w7daA/EYspQT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Dec 2014 15:43:04 -0500 Tejun Heo <tj@kernel.org> wrote:

> Hello,
>=20
> On Tue, Nov 18, 2014 at 03:27:54PM +1100, NeilBrown wrote:
> > @@ -2253,26 +2253,36 @@ repeat:
> >  					struct pool_workqueue, mayday_node);
> >  		struct worker_pool *pool =3D pwq->pool;
> >  		struct work_struct *work, *n;
> > +		int still_needed;
> > =20
> >  		__set_current_state(TASK_RUNNING);
> > -		list_del_init(&pwq->mayday_node);
> > -
> > -		spin_unlock_irq(&wq_mayday_lock);
> > -
> > -		worker_attach_to_pool(rescuer, pool);
> > -
> > -		spin_lock_irq(&pool->lock);
> > -		rescuer->pool =3D pool;
> > -
> > +		spin_lock(&pool->lock);
> >  		/*
> >  		 * Slurp in all works issued via this workqueue and
> >  		 * process'em.
> >  		 */
> >  		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
> > +		still_needed =3D need_to_create_worker(pool);
> >  		list_for_each_entry_safe(work, n, &pool->worklist, entry)
> >  			if (get_work_pwq(work) =3D=3D pwq)
> >  				move_linked_works(work, scheduled, &n);
> > =20
> > +		if (!list_empty(scheduled))
> > +			still_needed =3D 1;
> > +		if (still_needed) {
> > +			list_move_tail(&pwq->mayday_node, &wq->maydays);
> > +			get_pwq(pwq);
> > +		} else
> > +			/* We can let go of this one now */
> > +			list_del_init(&pwq->mayday_node);
>=20
> This seems rather convoluted.

Agreed.

>     Why are we testing this before
> executing the work item?  Can't we do this after?=20

To execute the work item, we need to drop the locks.
To perform the "list_move_tail" and the "get_pwq" we need to hold both lock=
s.

It seems easier to do the test while holding the required locks.

>    Isn't that -
> whether the wq still needs rescuing after rescuer went through it once
> - what we wanna know anyway?  e.g. something like the following.
>=20
> 	for_each_pwq_on_mayday_list {
> 		try to fetch work items from pwq->pool;
> 		if (none was fetched)
> 			goto remove_pwq;
>=20
> 		execute the fetched work items;
>=20
> 		if (need_to_create_worker()) {
> 			move the pwq to the tail;
> 			continue;
> 		}
>=20
> 	remove_pwq:
> 		remove the pwq;
> 	}

That looks nice.  I have a little difficulty matching the code to that
outline.
In particular I need to hold the pool->lock to call put_pwq() and after
calling put_pwq() it isn't clear that I have a safe reference to pool so th=
at
it is safe to de-reference it... unless I always
attach_to_pool/detach_from_pool.
But to do that I have to drop the locks at awkward times.

Please correct me if I'm wrong, but it looks like I have to call
worker_attach_to_pool() or I cannot safely call put_pwq().
I then have to call worker_detach_from_pool() as the last step.

I need to hold wq_mayday_lock to either move the pwq to the end of the mayd=
ay
list or to remove it, and I have to drop that lock to call
process_scheduled_works and after that I cannot retake wq_mayday_lock witho=
ut
first dropping pool->lock.

The net result is that if I try to map the code on to your outline, it
becomes even more convoluted due to the various locking/refcounting issues.

The best I can do is below (much the same as before).  If someone else can =
do
better I'd be very happy to see it.


>=20
> > +
> > +		spin_unlock(&pool->lock);
> > +		spin_unlock_irq(&wq_mayday_lock);
> > +
> > +		worker_attach_to_pool(rescuer, pool);
> > +
> > +		spin_lock_irq(&pool->lock);
> > +		rescuer->pool =3D pool;
> >  		process_scheduled_works(rescuer);
> > =20
> >  		/*
> > @@ -2293,7 +2303,7 @@ repeat:
> >  		spin_unlock_irq(&pool->lock);
> > =20
> >  		worker_detach_from_pool(rescuer, pool);
> > -
> > +		cond_resched();
>=20
> Also, why this addition?  process_one_work() already has
> cond_resched_rcu_qs().

Just being over-cautious I suppose.  I agree that isn't needed.

>=20
> Thanks.
>=20

Thanks,
NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Tue, 18 Nov 2014 15:23:07 +1100
Subject: [PATCH] workqueue: allow rescuer thread to do more work.

When there is serious memory pressure, all workers in a pool could be
blocked, and a new thread cannot be created because it requires memory
allocation.

In this situation a WQ_MEM_RECLAIM workqueue will wake up the
rescuer thread to do some work.

The rescuer will only handle requests that are already on ->worklist.
If max_requests is 1, that means it will handle a single request.

The rescuer will be woken again in 100ms to handle another max_requests
requests.

I've seen a machine (running a 3.0 based "enterprise" kernel) with
thousands of requests queued for xfslogd, which has a max_requests of
1, and is needed for retiring all 'xfs' write requests.  When one of
the worker pools gets into this state, it progresses extremely slowly
and possibly never recovers (only waited an hour or two).

With this patch we leave a pool_workqueue on mayday list
until it is clearly no longer in need of assistance.  This allows
all requests to be handled in a timely fashion.

The code is a bit awkward due to the need to hold both wq_mayday_lock
and pool->lock at the same time, and due to the lock ordering imposed
on them.  In particular we move work items from the ->worklist to the
rescuer list while holding both locks because we need pool->lock
to do the move, and need wq_mayday_lock to manipulate the mayday list
after we have found out if there was anything to do.

'need_to_create_worker()' is called *before* moving work items off
pool->worklist as an empty worklist will make it return false, but
after the move_linked_works() calls and before the
process_scheduled_works() call, an empty worklist does not indicate
that there is no work to do.

We keep each pool_workqueue on the mayday list until
need_to_create_worker() is false, and no work for this workqueue is
found in the pool.

As the main rescuer loop now iterates an arbitrary number of time,
cond_resched() was inserted to avoid imposing excessive latencies.

I have tested this in combination with a (hackish) patch which forces
all work items to be handled by the rescuer thread.  In that context
it significantly improves performance.  A similar patch for a 3.0
kernel significantly improved performance on a heavy work load.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index caedde34ee7f..fc9a2771fc0d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2253,26 +2253,36 @@ repeat:
 					struct pool_workqueue, mayday_node);
 		struct worker_pool *pool =3D pwq->pool;
 		struct work_struct *work, *n;
+		int still_needed;
=20
 		__set_current_state(TASK_RUNNING);
-		list_del_init(&pwq->mayday_node);
-
-		spin_unlock_irq(&wq_mayday_lock);
-
-		worker_attach_to_pool(rescuer, pool);
-
-		spin_lock_irq(&pool->lock);
-		rescuer->pool =3D pool;
-
+		spin_lock(&pool->lock);
 		/*
 		 * Slurp in all works issued via this workqueue and
 		 * process'em.
 		 */
 		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
+		still_needed =3D need_to_create_worker(pool);
 		list_for_each_entry_safe(work, n, &pool->worklist, entry)
 			if (get_work_pwq(work) =3D=3D pwq)
 				move_linked_works(work, scheduled, &n);
=20
+		if (list_empty(scheduled))
+			still_needed =3D 0;
+		if (still_needed) {
+			list_move_tail(&pwq->mayday_node, &wq->maydays);
+			get_pwq(pwq);
+		} else
+			/* We can let go of this one now */
+			list_del_init(&pwq->mayday_node);
+
+		spin_unlock(&pool->lock);
+		spin_unlock_irq(&wq_mayday_lock);
+
+		worker_attach_to_pool(rescuer, pool);
+
+		spin_lock_irq(&pool->lock);
+		rescuer->pool =3D pool;
 		process_scheduled_works(rescuer);
=20
 		/*

--Sig_/qYsqL/oqJE_w7daA/EYspQT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVH5b6znsnt1WYoG5AQKwIRAApzo/0G4Ixe/OKh4rOE3kpB/1EIZFz7SY
2eHTB77KG8nHMQ5zAuFYKObdgGcF2Gg/b2C3+bunHBOdigFmvH6lL+14FwvayKh5
UXwrk/Xy102pbYKgvHa0pFNlA62FBsPE7fhPeW56cdwdEtH2xANk8pzGe06o/pIF
Ao7R+x5i0WE5xLGO7/5KteDzidIlU7Xh/lzvvlKnK51l76DkklXNk9ETWqhVUyTe
Ac95bDuyTHTXKudpTKuXSZmAKJSFb1LaDsOsDzZCb+V9JROUxiS/PlvN3itt4Cz9
UYnRH+BWFSNfJMNe7o5qYUBLsS/OGTS0dMDvb/4FN5vy9Y67jxsvrb4ATER6zgUL
Ew8s7wB0JCCzmfzJAOC1Xt/pjgZPP93ZOQpQHM4cvM4vD1V8MjXjqurzp6Fk8Jr7
1ItXdSEQpEgReyQmI0AybsUOPteB9WSPhJPkiEiJlO2zwyb+0sskkC1ZF5L0MC/X
tb05puk5RYlK3hd0DUM9PMbv1YJydFswoqPbYhT4MhuOUDxeptFx5uYYME2Rk3Hz
44QrR+vexV059UWUrCWR0Nw1WNCU4m+QLlulRrWTf3XYzyVPb0xmibimBz+fv4Bz
UaNiqC7LXoV6aV5DXZWTe4/ELcc3W1P3tvaRee6ehnzmu5MUcaVPtnDZQI5ajmbA
7YHRtg3NUuw=
=A385
-----END PGP SIGNATURE-----

--Sig_/qYsqL/oqJE_w7daA/EYspQT--
