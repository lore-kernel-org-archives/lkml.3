Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaETAAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:00:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:59291 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaETAAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:00:33 -0400
Date: Tue, 20 May 2014 02:00:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] sched/dl: Fix race between dl_task_timer() and
 sched_setaffinity()
Message-ID: <20140520000026.GD11096@twins.programming.kicks-ass.net>
References: <20140516213003.10384.7946.stgit@localhost>
 <20140519151233.5043b749361e1b384f1e5562@gmail.com>
 <783871400527879@web2j.yandex.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJmQ7d57n2fskpx3"
Content-Disposition: inline
In-Reply-To: <783871400527879@web2j.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJmQ7d57n2fskpx3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 11:31:19PM +0400, Kirill Tkhai wrote:
> @@ -513,9 +513,17 @@ static enum hrtimer_restart dl_task_timer(struct hrt=
imer *timer)
>  						     struct sched_dl_entity,
>  						     dl_timer);
>  	struct task_struct *p =3D dl_task_of(dl_se);
> -	struct rq *rq =3D task_rq(p);
> +	struct rq *rq;
> +again:
> +	rq =3D task_rq(p);
>  	raw_spin_lock(&rq->lock);
> =20
> +	if (unlikely(rq !=3D task_rq(p))) {
> +		/* Task was moved, retrying. */
> +		raw_spin_unlock(&rq->lock);
> +		goto again;
> +	}
> +

That thing is called: rq =3D __task_rq_lock(p);

--IJmQ7d57n2fskpx3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTepsVAAoJEHZH4aRLwOS6Nw8QAI/+wt1Vo66IoVvLg4BXkkdp
/qZO5ZcAopKW0AFFXj2l4kTB2zrz+s/bK+2g6Sn9RVvf5YfzbRY9uVwTGh48es4b
qTNBTZ07Mww/HategKt+mJctiIsvB3zcwu8cP5GGfgwo4wXKJk3jner61wjsz1NT
wZ/SRqn0uWN/Jy0lhBztdkRW/F9f1kOG5K/KDa5+WYTLUoX9y43crS/OBBweM2MT
WgJFnFm45dfgq5VBsm3/KuOdSIXyHIZmhvDy7AE3yGItLhu1qKLTjjbIo15ERqQv
H0ySmWMfgmygpLSSJ/fjmMPSXpeQKZcPu7We/mCJjuuodTVlga0wb6mLgy4r1lmP
LnU9bbULjtQsF20mMI2P8nD1AfsAAs2Be9KaEPEkqOLt/Jm6gWnq8hllJVVmV0Oq
NQxQyXkRAc6qMbBkNepKMEni9JEA6Tum0LJwXuFK6eKl+F7LAy2YaMIFgodbFrbi
vXKOAXrumfUC/OlqBnfa8ytQfDEOf3rh713J1Tontfq0faUGvy9pBJqzW1lQI5x4
iY9vLhqwaqLsEUnz3tev7dJJil9vYN83eIYAKsl8rIvdPYfeP6wX4mN+IIdE5Oi6
cuuX8SWI+oBuZzuPrIIOtsXql6zl8fFWWsojQbXFmIElgUMxUphbcjGPlvv/aiFI
xM4dnrxd5i8ZF30jB8h+
=UgSc
-----END PGP SIGNATURE-----

--IJmQ7d57n2fskpx3--
