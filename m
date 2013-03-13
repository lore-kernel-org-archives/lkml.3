Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3CMEtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 00:49:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36188 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3CMEtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 00:49:18 -0400
Date: Wed, 13 Mar 2013 15:49:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the akpm tree with the workqueues tree
Message-Id: <20130313154905.59d00adb5b62d5169649aea0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Mar_2013_15_49_05_+1100_MzgEDV51=LS.H0.a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Mar_2013_15_49_05_+1100_MzgEDV51=LS.H0.a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/workqueue.c between commit fa1b54e69bc6 ("workqueue: update
synchronization rules on worker_pool_idr") from the workqueues tree and
commit "workqueue: convert to idr_alloc()" from the akpm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/workqueue.c
index 2f43753,09bee1d..0000000
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@@ -456,31 -456,40 +456,31 @@@ static int worker_pool_assign_id(struc
  {
  	int ret;
 =20
 -	mutex_lock(&worker_pool_idr_mutex);
 -	ret =3D idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
 -	if (ret >=3D 0)
 -		pool->id =3D ret;
 -	mutex_unlock(&worker_pool_idr_mutex);
 +	do {
- 		if (!idr_pre_get(&worker_pool_idr, GFP_KERNEL))
- 			return -ENOMEM;
-=20
++		idr_preload(GFP_KERNEL);
 +		spin_lock_irq(&workqueue_lock);
- 		ret =3D idr_get_new(&worker_pool_idr, pool, &pool->id);
++		ret =3D idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_NOWAIT);
++		if (ret >=3D 0)
++			pool->id =3D ret;
 +		spin_unlock_irq(&workqueue_lock);
 +	} while (ret =3D=3D -EAGAIN);
 =20
- 	return ret;
+ 	return ret < 0 ? ret : 0;
  }
 =20
 -/*
 - * Lookup worker_pool by id.  The idr currently is built during boot and
 - * never modified.  Don't worry about locking for now.
 +/**
 + * first_pwq - return the first pool_workqueue of the specified workqueue
 + * @wq: the target workqueue
 + *
 + * This must be called either with workqueue_lock held or sched RCU read
 + * locked.  If the pwq needs to be used beyond the locking in effect, the
 + * caller is responsible for guaranteeing that the pwq stays online.
   */
 -static struct worker_pool *worker_pool_by_id(int pool_id)
 -{
 -	return idr_find(&worker_pool_idr, pool_id);
 -}
 -
 -static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
 -{
 -	struct worker_pool *pools =3D std_worker_pools(cpu);
 -
 -	return &pools[highpri];
 -}
 -
 -static struct pool_workqueue *get_pwq(unsigned int cpu,
 -				      struct workqueue_struct *wq)
 +static struct pool_workqueue *first_pwq(struct workqueue_struct *wq)
  {
 -	if (!(wq->flags & WQ_UNBOUND)) {
 -		if (likely(cpu < nr_cpu_ids))
 -			return per_cpu_ptr(wq->pool_wq.pcpu, cpu);
 -	} else if (likely(cpu =3D=3D WORK_CPU_UNBOUND))
 -		return wq->pool_wq.single;
 -	return NULL;
 +	assert_rcu_or_wq_lock();
 +	return list_first_or_null_rcu(&wq->pwqs, struct pool_workqueue,
 +				      pwqs_node);
  }
 =20
  static unsigned int work_color_to_flags(int color)

--Signature=_Wed__13_Mar_2013_15_49_05_+1100_MzgEDV51=LS.H0.a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQAVBAAoJEECxmPOUX5FElYkP/3EoCACvyWeNh0zJjpuufkEI
oMVUexBtpIqmfEK669lEO4UGkNTIH8zU04Yz7gprwvnIwbe35eUC0ajtVHROcWr0
HV2f2cErxcKPWmspOS6PeHpc/FoI0wKkRu4hhC2hhlr4tO0qrWCM78Yoczro/yNo
+p+mWx4hG8c/XdKFGTLu0bnC+ZYL39I5Vmvn7CfTk1xRTKc7/t78qynzShbKmpiA
jib9o/Cih961KuByT9VBNsEq6Q1lgfPRXpC+r0D4T5Tp7J/rHu4KgTRCp8uaeD4x
kIxCNiCeU6cxkqMZiIZV1LcMF8zxcjvmuJDD6UDFSnYDxLigCq/09QRFUu7qh/tr
/rGx3wIAtRAAJLi9K5j9KwZRCht2r+5E0DlbFX7eYRq2/aJWvx541otEDJEcMAkr
P4hhMSLUgB8aKj1JEBKOLapB/rT4aGr3FK8y7gi7Hd71uY5bXsVD9jy2qP5OoKqc
ssVav30kqB649xETd1VvyE/Q6LWuvkGSoVI1SbDwouq2BPtrxyR+u6RZMXb8l4/S
D+SabAn+5rC26ePnYOffA3d+ypy/zR11yD1Z/ZeVEeeNHJKqKn2PfIk6pZM4b4Ab
301tg3qRPVV0tExCZgC46Yns3VeFbEbf54XZp+KV4XKzUtxNJjw5FSve5NbvENhz
QYDorR99GIpUuGHYxMTP
=et9E
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Mar_2013_15_49_05_+1100_MzgEDV51=LS.H0.a--
