Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaJ2G0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:26:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbaJ2G0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:26:17 -0400
Date: Wed, 29 Oct 2014 17:26:08 +1100
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH/RFC] workqueue: allow rescuer thread to do more work.
Message-ID: <20141029172608.39119c80@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/pkHoEUk_jhwGl0TtJzIz1PC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pkHoEUk_jhwGl0TtJzIz1PC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


When there is serious memory pressure, all workers in a pool could be block=
ed,
and a new thread cannot be created because it requires memory allocation.

In this situation a WQ_MEM_RECLAIM workqueue will wake up the
rescuer thread to do some work.

The rescuer will only handle requests that are already on ->worklist.
If max_requests is 1, that means it will handle a single request.

The rescuer will be woken again in 100ms to handle another max_requests
requests.

I've seen a machine (running a 3.0 based "enterprise" kernel) with thousands
of requests queued for xfslogd, which has a max_requests of 1, and is needed
for retiring all 'xfs' write requests.  When one of the worker pools gets
into this state, it progresses extremely slowly and possibly never recovers
(only waited an hour or two).

So if, after handling everything on worklist, there is again something on
worklist (counted in nr_active), and if the queue is still congested, keep
processing instead of waiting for the next wake-up.

Signed-off-by: NeilBrown <neilb@suse.de>
---

Hi Tejun,
  I haven't tested this patch yet so this really is an 'RFC'.
In general ->nr_active should only be accessed under the pool->lock,
but a miss-read here will at most cause a very occasional 100ms delay so
shouldn't be a big problem.  The only thread likely to change ->nr_active is
this thread, so such a delay would be extremely unlikely.

Thanks,
NeilBrown


diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 09b685daee3d..d0a8b101c5d9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2244,16 +2244,18 @@ repeat:
 		spin_lock_irq(&pool->lock);
 		rescuer->pool =3D pool;
=20
-		/*
-		 * Slurp in all works issued via this workqueue and
-		 * process'em.
-		 */
-		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
-		list_for_each_entry_safe(work, n, &pool->worklist, entry)
-			if (get_work_pwq(work) =3D=3D pwq)
-				move_linked_works(work, scheduled, &n);
+		do {
+			/*
+			 * Slurp in all works issued via this workqueue and
+			 * process'em.
+			 */
+			WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
+			list_for_each_entry_safe(work, n, &pool->worklist, entry)
+				if (get_work_pwq(work) =3D=3D pwq)
+					move_linked_works(work, scheduled, &n);
=20
-		process_scheduled_works(rescuer);
+			process_scheduled_works(rescuer);
+		} while (need_more_worker(pool) && pwq->nr_active);
=20
 		/*
 		 * Put the reference grabbed by send_mayday().  @pool won't

--Sig_/pkHoEUk_jhwGl0TtJzIz1PC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFCIgTnsnt1WYoG5AQJ3aw/+PAtZXM7i0qoGX6PbyueYhlcpUbR0Kyg4
rT/XcMoCYq1DqYNxIXnuO4Rh0zGD80GFnv/q+NbzDEAdVTC/yToUWCwsEiH9Nsw6
yE/kY/EpKanON35Xv+G8+BIFP1ztSkSa3jdGsc05yppHEiLW0Jcp6oCXe8BDwMRV
ip/Fa1ev5Qi0SqzbhmNMOCsGjTeFDiS4x1b888zByjt1JFCDdIh6DQwqs+VFOhF2
7RxuKtdCTZ/1slPwxK3OweQBn44/GEQ46f8+GyKudAKAP++jrI7zDPwbCCyGXLMJ
0unQGu/mzFgcpnPRwk4SxRUO8xuabbiy/j3uavxlR0rBiNDJy3mLtz3I9RzYhfMA
qPrdoVhX14iwlKymiQJNH3+cSga/8VaKzqMIseVWiGdBiL9UyFLu5QaYN/BqhzLo
uCb/4O8zxTftTQuAQYBgd+qzl77JaVmmkiHg0m0UOLJQS1bGbb6L6lMYLhk+7Oez
/O3sF5CV74XbekJwGtPzpvwQmwE5+ZrkZIwBhFCGac8Ufd1q4gdeDmyncG7U0+Ho
brPhaRHDwK5OhgblxQlGHJ+3A3d4QSr4pUJuP1nBAP/dqlpYgHOBsnISKaxmNF/j
G46dPVoX1RLhzYveMajsEQrg7tyXcmKspScSOncDeD51l29XlE18mGIDnnAmVDvM
lwpCJq/qV9s=
=+Yj4
-----END PGP SIGNATURE-----

--Sig_/pkHoEUk_jhwGl0TtJzIz1PC--
