Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaKRE2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 23:28:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaKRE2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 23:28:07 -0500
Date: Tue, 18 Nov 2014 15:27:54 +1100
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH - v3?] workqueue: allow rescuer thread to do more work.
Message-ID: <20141118152754.60b0c75e@notabene.brown>
In-Reply-To: <20141111090402.35fa0700@notabene.brown>
References: <20141029172608.39119c80@notabene.brown>
	<20141029143210.GA25226@htj.dyndns.org>
	<20141030101932.2241daa7@notabene.brown>
	<20141104142240.GD14459@htj.dyndns.org>
	<20141106165811.GA2338@gmail.com>
	<545C368C.5040704@cn.fujitsu.com>
	<20141110162848.6f2246bb@notabene.brown>
	<20141110085250.GB15948@quack.suse.cz>
	<20141111090402.35fa0700@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/PAob2GQ60HXiBAx+PF9Azcg"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PAob2GQ60HXiBAx+PF9Azcg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


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

Thanks to Jan Kara for some design ideas, and to Dongsu Park for
some comments and testing.

Cc: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index caedde34ee7f..4baa7b8b7e0f 100644
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
+		if (!list_empty(scheduled))
+			still_needed =3D 1;
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
@@ -2293,7 +2303,7 @@ repeat:
 		spin_unlock_irq(&pool->lock);
=20
 		worker_detach_from_pool(rescuer, pool);
-
+		cond_resched();
 		spin_lock_irq(&wq_mayday_lock);
 	}
=20

--Sig_/PAob2GQ60HXiBAx+PF9Azcg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVGrKyznsnt1WYoG5AQI0oQ//clm8m0yH/wW/3C8LwzyTAlYWb48zw46g
n0RWDYrUV1F91PIOifCbpIkgSZXZ/z7tHwopupYFx2uJO1pELNrOaxUx5tD5zNjP
EsSLFeHjuJq9zhhpCQcpPOmYyBKYFYijZwMouvbfH8z1Cacj+VFZ56dxvr7wbcau
UIzdBprMHVXWMaQiL+8FQSKDJKCrTXBrtrPdKBmsNWX2TVjij13aNEyzsFPMTRlk
sdneIWJ9Ae837ZaBcWfxiBsAPOc4PYHgdMWbXqbxcnvZCzH5IvJNe496VtNRJaUW
s7qZLo7XXZFgHmxDPnWA1P0ZDhxNz+RDoDiF8PSBsRD7ANs4ORGSMzCaj/UnNqJg
cqSoPIgixWQzOv6DYO2E4hYxl4O93RBV6BClKFoYPoRii6u6mlNlF2SQVYxAksSn
StDcGecdJRc+eCJYJN2Qha3WolhXJG+8aGV7PrJXuviLIAJjvA6gapqxdH55pfFU
6iw3Mb6QnAsS4fwcN8gGz6BpslQhvafEhnXCsovzod1MeKhic4jYytb0Uxx7Yxav
2uP3FQCy3fQ2LkQ9ujsDIY6wrbbZtJrewGE6rp6QkEQ1cdHfwPWlQOxCM3xG1+/f
a7/cVV4WAq59uvmZAImFTGS3ImZxtrhGmbvlEED8lI8E79D5UrkveFibJmUwSdK6
PGxb+uL+Epw=
=wYEH
-----END PGP SIGNATURE-----

--Sig_/PAob2GQ60HXiBAx+PF9Azcg--
