Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3CNE3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:29:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40818 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab3CNE3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:29:34 -0400
Date: Thu, 14 Mar 2013 15:29:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the workqueues tree with Linus' tree
Message-Id: <20130314152922.419606e04d2ff65a69cfa6f9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__14_Mar_2013_15_29_22_+1100_mDEsWB1T8I9jbGv6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Mar_2013_15_29_22_+1100_mDEsWB1T8I9jbGv6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
kernel/workqueue.c between commit e68035fb65de ("workqueue: convert to
idr_alloc()") from Linus' tree and commit fa1b54e69bc6 ("workqueue:
update synchronization rules on worker_pool_idr") from the workqueues
tree.

I fixed it up (as suggested - see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/workqueue.c
index 55fac5b,2ebd182..0000000
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@@ -456,40 -456,31 +456,32 @@@ static int worker_pool_assign_id(struc
  {
  	int ret;
 =20
- 	mutex_lock(&worker_pool_idr_mutex);
- 	ret =3D idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
- 	if (ret >=3D 0)
- 		pool->id =3D ret;
- 	mutex_unlock(&worker_pool_idr_mutex);
+ 	do {
 -		if (!idr_pre_get(&worker_pool_idr, GFP_KERNEL))
 -			return -ENOMEM;
 -
++		idr_preload(GFP_KERNEL);
+ 		spin_lock_irq(&workqueue_lock);
 -		ret =3D idr_get_new(&worker_pool_idr, pool, &pool->id);
++		ret =3D idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_NOWAIT);
++		if (ret >=3D 0)
++			pool->id =3D ret;
+ 		spin_unlock_irq(&workqueue_lock);
++		idr_preload_end();
+ 	} while (ret =3D=3D -EAGAIN);
 =20
 -	return ret;
 +	return ret < 0 ? ret : 0;
  }
 =20
- /*
-  * Lookup worker_pool by id.  The idr currently is built during boot and
-  * never modified.  Don't worry about locking for now.
+ /**
+  * first_pwq - return the first pool_workqueue of the specified workqueue
+  * @wq: the target workqueue
+  *
+  * This must be called either with workqueue_lock held or sched RCU read
+  * locked.  If the pwq needs to be used beyond the locking in effect, the
+  * caller is responsible for guaranteeing that the pwq stays online.
   */
- static struct worker_pool *worker_pool_by_id(int pool_id)
- {
- 	return idr_find(&worker_pool_idr, pool_id);
- }
-=20
- static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
- {
- 	struct worker_pool *pools =3D std_worker_pools(cpu);
-=20
- 	return &pools[highpri];
- }
-=20
- static struct pool_workqueue *get_pwq(unsigned int cpu,
- 				      struct workqueue_struct *wq)
+ static struct pool_workqueue *first_pwq(struct workqueue_struct *wq)
  {
- 	if (!(wq->flags & WQ_UNBOUND)) {
- 		if (likely(cpu < nr_cpu_ids))
- 			return per_cpu_ptr(wq->pool_wq.pcpu, cpu);
- 	} else if (likely(cpu =3D=3D WORK_CPU_UNBOUND))
- 		return wq->pool_wq.single;
- 	return NULL;
+ 	assert_rcu_or_wq_lock();
+ 	return list_first_or_null_rcu(&wq->pwqs, struct pool_workqueue,
+ 				      pwqs_node);
  }
 =20
  static unsigned int work_color_to_flags(int color)

--Signature=_Thu__14_Mar_2013_15_29_22_+1100_mDEsWB1T8I9jbGv6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQVIiAAoJEECxmPOUX5FEAYcQAJq1uu4cmkesACoYz7H9uFrH
27g2GXXgrznWzAKwTucIk/AI0GbbrpKNVci+AYvSS2o4XH/CWAcZlmtbCuh2X73O
iUJ+WXI6UVcQUZhg4BGoxCY4Vm+pHXyyGsZCkPBQjRYR+aCwgLYl1+CmxJRklm+E
5Jawi5sDKlyEPlwFzxy5Y2z+1RWifd/2l/e9iaOejj9cBrcYXTuZ9/+Wk4OhlbD4
s+ek+fOdDSWvi7AXGh2WSjqqvSSIPcjBWvXhGgMkof5lPJc3xDi35gGkf0fVyYYa
jI69PdXvYb/Y4AgCZ1G3tACwWuGyMrPEZuSGZmP2gt/aKr2O72bmYV1PqDa6rSg8
7rtEh0QaxdV98GkUdeVYHBWCvphfNduQ1Nt5l1XU04ScDMPJg+0NuIGIqcthKQrk
wivdp4aS+K0BDAwu6RC30Wi0NnwOvysmKrJomTEd4IfUJgWop7KyCloJJhJvzUpp
ALHZm/eeOWOITC8/G4CU5fkPHbWQn6fhimPNek2u0F/p4mH1WjPeuMbbVx8Ttb3t
P8w6BdqvRBe33Li96xgDS1dtT5hCzJYQUrARNKjQbTYCuXZ06po/BSUI/UOfKBNI
PowXPy5z5o5ZEyHoFyZARJ99l4dR+wqFddGBA5PEOfggJO3xOyiQwSYDA2k2uiSd
LcEDKWEX2KsmOj37nIxZ
=jyOJ
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Mar_2013_15_29_22_+1100_mDEsWB1T8I9jbGv6--
