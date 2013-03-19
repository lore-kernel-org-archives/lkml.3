Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab3CSCTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:19:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60674 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab3CSCTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:19:53 -0400
Date: Tue, 19 Mar 2013 13:19:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the workqueues tree with Linus' tree
Message-Id: <20130319131938.73dd0f1233c8aba41742aded@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Mar_2013_13_19_38_+1100_XFzR.aQtTuqSBjfD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Mar_2013_13_19_38_+1100_XFzR.aQtTuqSBjfD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
kernel/workqueue.c between commit e68035fb65de ("workqueue: convert to
idr_alloc()") from Linus' tree and commit 5bcab3355a55 ("workqueue:
separate out pool and workqueue locking into wq_mutex") from the
workqueues tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/workqueue.c
index 55fac5b,833a152..0000000
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@@ -456,40 -462,30 +462,30 @@@ static int worker_pool_assign_id(struc
  {
  	int ret;
 =20
- 	mutex_lock(&worker_pool_idr_mutex);
- 	ret =3D idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
- 	if (ret >=3D 0)
- 		pool->id =3D ret;
- 	mutex_unlock(&worker_pool_idr_mutex);
+ 	lockdep_assert_held(&wq_mutex);
+=20
+ 	do {
 -		if (!idr_pre_get(&worker_pool_idr, GFP_KERNEL))
 -			return -ENOMEM;
 -		ret =3D idr_get_new(&worker_pool_idr, pool, &pool->id);
++		ret =3D idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
++		if (ret >=3D 0)
++			pool->id =3D ret;
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
+  * This must be called either with pwq_lock held or sched RCU read locked.
+  * If the pwq needs to be used beyond the locking in effect, the caller is
+  * responsible for guaranteeing that the pwq stays online.
   */
- static struct worker_pool *worker_pool_by_id(int pool_id)
- {
- 	return idr_find(&worker_pool_idr, pool_id);
- }
-=20
- static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
+ static struct pool_workqueue *first_pwq(struct workqueue_struct *wq)
  {
- 	struct worker_pool *pools =3D std_worker_pools(cpu);
-=20
- 	return &pools[highpri];
- }
-=20
- static struct pool_workqueue *get_pwq(unsigned int cpu,
- 				      struct workqueue_struct *wq)
- {
- 	if (!(wq->flags & WQ_UNBOUND)) {
- 		if (likely(cpu < nr_cpu_ids))
- 			return per_cpu_ptr(wq->pool_wq.pcpu, cpu);
- 	} else if (likely(cpu =3D=3D WORK_CPU_UNBOUND))
- 		return wq->pool_wq.single;
- 	return NULL;
+ 	assert_rcu_or_pwq_lock();
+ 	return list_first_or_null_rcu(&wq->pwqs, struct pool_workqueue,
+ 				      pwqs_node);
  }
 =20
  static unsigned int work_color_to_flags(int color)

--Signature=_Tue__19_Mar_2013_13_19_38_+1100_XFzR.aQtTuqSBjfD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRR8s6AAoJEECxmPOUX5FEHFcP/3JKiYQHmvegvHsVes4GJOLe
yEBGEPe1nhaide7+2b1WGeng6c5y91IhevsMBUYqIDLdjCL0owhCacf4sXUwMoPS
35vj/4gSVidt8A7YjAq3VQj5zA3Ur6MmIjeGUW2MKDh0bs2tAgy7RE452wIxhlcO
H3LotC550TUr4lPY1VXi6xZsfseok6djAvrFK+f6iMhIrTNFmAjA5voCnWU4mDBa
rGowxZpn2IR8oqAA8lHHM+GS5aAARO6E3/st7k2cUItzGhg0QcYNHhXkqVjgENpS
MqZnmZ7/+gOIkwZuxuVYSsjYN249BKpRmbrahJ4+XNFLbKaOjZoaCZNXTFJKBNlC
kRNqMcl9VtYhxyW38TBwHfbfsDFGurvNk97Qku58do3U0Y4UpHim9oBzqr8xHr7J
SG3B1h9ByF6FiS8DLt4glxt5J/kBamviOsYKiPosg7pGSy1va0AivuSRdFiHKoMZ
Yde2B0f047BVoFZyJt/yoUiGdsVMww4TwzFuaDNh59xbBatZdTGHUTDGrfjMAuYf
6VeZCHo3gXrti+XK5klrexrHypFByRnsWgTk8xA9TPd5vVV6jxlEfv+AwsvLmaB5
CLxagjkud+3NXUGGkxWuM/CCLlBgw5jZus3ouEiIR/Babl1lQYTaIdVYGoIiLOqg
FeegbOTGJSrdzqtYI/lF
=Vhkm
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Mar_2013_13_19_38_+1100_XFzR.aQtTuqSBjfD--
