Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaHMRlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:41:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51379 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbaHMRlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:41:02 -0400
Date: Wed, 13 Aug 2014 19:40:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
Message-ID: <20140813174048.GV9918@twins.programming.kicks-ass.net>
References: <20140812142539.01851e52@annuminas.surriel.com>
 <20140812191218.GA15210@redhat.com>
 <53EA94DD.5040900@redhat.com>
 <20140813172230.GA6296@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JifNnQum/cg2Woy5"
Content-Disposition: inline
In-Reply-To: <20140813172230.GA6296@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JifNnQum/cg2Woy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 07:22:30PM +0200, Oleg Nesterov wrote:
> On 08/12, Rik van Riel wrote:
> >
> > Any other ideas?
>=20
> To simplify, lets suppose that we only need sum_exec_runtime.
>=20
> Perhaps we can do something like this
>=20
> 	u64 thread_group_sched_runtime(void)
> 	{
> 		struct task_struct *tsk =3D current;
> 		spinlock_t *siglock =3D &tsk->sighand->siglock; /* stable */
> 		struct task_struct *t;
> 		u64 x1, x2;
>=20
> 	retry:
> 		x1 =3D tsk->signal->sum_sched_runtime;
> 		rmb();
> 		spin_unlock_wait(siglock);
> 		rmb();
>=20
> 		x2 =3D 0;
> 		rcu_read_lock();
> 		for_each_thread(tsk, t)
> 			x2 +=3D task_sched_runtime(t);
> 		rcu_read_unlock();
>=20
> 		rmb();
> 		spin_unlock_wait(siglock);
> 		rmb();
>=20
> 		if (x1 !=3D tsk->signal->sum_sched_runtime)
> 			goto retry;
>=20
> 		return x1 + x2;
> 	}
>=20
> ?
>=20
> We do not care if for_each_thread() misses the new thread, we can pretend
> thread_group_sched_runtime() was called before clone.
>=20
> We do not care if a thread with sum_sched_runtime =3D=3D 0 exits, obvious=
ly.
>=20
> Otherwise "x1 !=3D tsk->signal->sum_sched_runtime" should tell us that we
> raced with __exit_signal().

So the problem with the above is the lack of fwd progress; if there's
enough clone()/exit() happening in the thread group (and the more CPUs
the more possible), we'll keep repeating.




--JifNnQum/cg2Woy5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT66MfAAoJEHZH4aRLwOS6DRgP/09D31xCxGkn2XAjBuU6EHGl
xUf0UbhAnouQvnzJw46WUZdWinfrltD6VATfId4yIBifI2y9ulNFlbWt1IGcy5JA
cA7213HCq8QoiHBU4mAON0TiXdLo1mVD3BiXoamJKQQXVEaLVxc6WyDqgFxkhbvC
B03ma/qQguyvt6XNxi36dx7Jq5LQarJuwTeQtw14fbAUZSrTpJVkIGcvR8K3/YMC
KD8iCC0ESIHBOIboo9T50+48EbihQXO1rv3Mnkx1gb8vbzG5/tslHegqDFfgmKX5
lmCJKuQb7oVsgos3BqGUN35zVSxGfAc1+iPrSmRsopuTKAITyZH9omKPaLeejhdR
pTU0VHKINVTWeIeLiBlbkvP5PvtxQOOF2+GaycVnvbrD8TdGHn9Uj+6PFCSSliRh
Ota7F0q65OFExbAvsPqqaKLgKv8YmLpWbft63wPlHNhsVWgOBTuJVILjvbnuBMyr
+END46X1LUhdneYXJXlibAX/QAmXcQZYZ+dAIQTyh4Lx5Tdhq1BQvBWhZUIBlsmy
WJi4joZiFHeJNllG5K/Yyi/7L3OFjSLio9vnpUJn+NvgvtSLf0wFWzzMF1ydBR3w
S3YUoEfhiA7tBgGKSwDhfoqRn2qlfAY09ibJCnmqcL4N+thCe68396fdNnSqqhpp
TYVV25Tr8v380/J0sOnq
=5gs7
-----END PGP SIGNATURE-----

--JifNnQum/cg2Woy5--
