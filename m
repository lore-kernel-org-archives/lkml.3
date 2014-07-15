Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbaGON2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:28:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:57498 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbaGON2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:28:16 -0400
Date: Tue, 15 Jul 2014 15:28:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: Re: sched, timers: use after free in __lock_task_sighand when
 exiting a process
Message-ID: <20140715132804.GG9918@twins.programming.kicks-ass.net>
References: <53C2FF4D.3020606@oracle.com>
 <53C31A34.8030500@oracle.com>
 <20140714090449.GL9918@twins.programming.kicks-ass.net>
 <20140714144953.GA8173@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7DP64HymKb+JCWvF"
Content-Disposition: inline
In-Reply-To: <20140714144953.GA8173@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7DP64HymKb+JCWvF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 04:49:53PM +0200, Oleg Nesterov wrote:
> > Oleg, what guarantees the RCU free of task-struct and sighand?
>=20
> > The only RCU I can find is delayed_put_task_struct() but that's not
> > often used.
>=20
> Yes, usually the code uses put_task_struct(). delayed_put_task_struct()
> acts almost as "if (dec_and_test(usage)) kfree_rcu(), but allows to use
> get_task_struct() if you observe this task under rcu_read_lock().
>=20
> Say,
> 	rcu_read_lock();
> 	task =3D find_task_by_vpid(...);
> 	if (task)
> 		get_task_struct(task);
> 	rcu_read_unlock();
>=20
> If release_task() used dec_and_test + kfree_rcu, the code above could
> not work.

Agreed.

> > TASK_DEAD etc. use regular put_task_struct() and that
> > doesn't seem to involve RCU.
>=20
> Yes, the task itself (or, depending ob pov, scheduler) has a reference.
> copy_process() does
>=20
> 	/*
> 	 * One for us, one for whoever does the "release_task()" (usually
> 	 * parent)
> 	 */
> 	atomic_set(&tsk->usage, 2);
>=20
> "us" actually means that put_task_struct(TASK_DEAD).

Right, that's it. I got confused in the exit code. Thanks!

--7DP64HymKb+JCWvF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxSxkAAoJEHZH4aRLwOS6hEYQAKqSUNDs03jeh3ZugzxLJkAA
0Ot80vWsqVSwSd7enDFRC87KGFdZiYOxB8aGTUsx3elE55mPj27OIg7AqLJGkVEF
jD6lccokGJrEFS84kaGwmljoSnv3Os+XbZbOeeiZ4ajOMcfH63/cS6hX1UdyHI6i
RvnEYrNgtJNkJw5Jvmh4Jw81jPT/QEW0xcBh3cio2CB58qMh15Y1JBVYKGDDLkNw
eMeGKVaBCD7DH1eoCKwYio4vZLDVQf/08mEvlD34JblrjNyKZJi/UG3jS3IEVmG/
1IiOxTey19XJ0+aYraFSC+b2BSfgIGEjaCQpHiISS1HAH1F3YjEFlhrtdRacepCX
2o2GNNubT3m6R6orVqexY5/bB/0EEpxnJMDGf8R4dNQ5pY+rrhZsV25rBOeznMm5
/DeVBT/C170niMyavzeKv1OsUxOefxt3TOu/QLckZ7gfHG6elqP+W7w0QArvVi1W
pMR4R/NsJAB9k14vsbqLd3zS37LiCc3kLix2wUsD5FEzSMhOuXpZIb/O4hcXpK74
1KpjMAn18elMtT/smVT+Yli3SmQNlW+zI1EiNKo9RuVqanyobuUYcyHVfzrR0IC/
r2DxiPxo0p6pf4uulpc3SlPONG/6W0Y5reVh/dMN6QB6q+Z2MCDz6aOx0zjsiGeB
LDsSop0RfPNa+A82+BGc
=/zM0
-----END PGP SIGNATURE-----

--7DP64HymKb+JCWvF--
