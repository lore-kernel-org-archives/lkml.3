Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaENJoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:44:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39369 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaENJog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:44:36 -0400
Date: Wed, 14 May 2014 11:44:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
Message-ID: <20140514094426.GF30445@twins.programming.kicks-ass.net>
References: <537192D3.5030907@linux.vnet.ibm.com>
 <20140513094737.GU30445@twins.programming.kicks-ass.net>
 <53721FD4.6060300@redhat.com>
 <20140513142328.GE2485@laptop.programming.kicks-ass.net>
 <53731D12.7040804@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nWclrlgqnAApBvUd"
Content-Disposition: inline
In-Reply-To: <53731D12.7040804@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nWclrlgqnAApBvUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 03:36:50PM +0800, Michael wang wrote:
> distro mount cpu-subsys under '/sys/fs/cgroup/cpu', create group like:
> 	mkdir /sys/fs/cgroup/cpu/A
> 	mkdir /sys/fs/cgroup/cpu/B
> 	mkdir /sys/fs/cgroup/cpu/C

Yeah, distro is on crack, nobody sane mounts anything there.

> and then:
> 	echo $$ > /sys/fs/cgroup/cpu/A/tasks ; ./my_tool -l
> 	echo $$ > /sys/fs/cgroup/cpu/B/tasks ; ./my_tool -l
> 	echo $$ > /sys/fs/cgroup/cpu/C/tasks ; ./my_tool 50
>=20
> the results in top is around:
>=20
> 		A	B	C
> 	CPU%	550	550	100

top doesn't do per-cgroup accounting, so how do you get these numbers,
per the above all instances of the prog are also called the same,
further making it error prone and difficult to get sane numbers.


> #include <sys/time.h>
> #include <unistd.h>
> #include <stdio.h>
> #include <pthread.h>
>=20
> pthread_mutex_t my_mutex;
>=20
> unsigned long long stamp(void)
> {
> 	struct timeval tv;
> 	gettimeofday(&tv, NULL);
>=20
> 	return (unsigned long long)tv.tv_sec * 1000000 + tv.tv_usec;
> }
> void consume(int spin, int total)
> {
> 	unsigned long long begin, now;
> 	begin =3D stamp();
>=20
> 	for (;;) {
> 		pthread_mutex_lock(&my_mutex);
> 		now =3D stamp();
> 		if ((long long)(now - begin) > spin) {
> 			pthread_mutex_unlock(&my_mutex);
> 			usleep(total - spin);
> 			pthread_mutex_lock(&my_mutex);
> 			begin +=3D total;
> 		}
> 		pthread_mutex_unlock(&my_mutex);
> 	}
> }

Uh,.. that's just insane.. what's the point of having a multi-threaded
program do busy-wait loops if you then serialize the lot on a global
mutex such that only 1 thread can run at any one time?

How can one such prog ever consume more than 100% cpu.

--nWclrlgqnAApBvUd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTczr6AAoJEHZH4aRLwOS67xUP/AyuMzcauSQsYNvPYe7H/BUc
bajKN4EfvOk61kejICBTQtKZKigAJXcIh3UniVgrweiNTwPn0Pe6TJlthbYg709b
Gy7tQAwyBsgaE0zYnMvsFmkQ/m4AueULQOByPdzypaZk4YvUEz6bzCjarrsdEV8s
vYGwcFjFYqEOU/hXOR8EC27N156+wjCxFRFA3HfqjLkCXxZobx2tW6tZ3Wu15kw0
qrSPUptVSOC72PSunAtbMGN80mczJPfFVLmKpwMmcBxyQ4NLxNEWV2MunAeB0aml
zttN8FLDbb3QflACD9RlTRvoZXvYZWrS4bpSwcGp3LvB/43ymxfD2s4BsOlrXNqi
Ba+tmbbef4tYjcX24b4RXe68Og9zTB3DztEr5ZcvMuZPwAt5Nu6/h6LKpJ1E6ydM
6N2HR+YK+hktlxIoBH8tFkiqpgY85Ma6BZbjJ4BCKujtkBToiVr/FrjuNcrJWk4A
aX/+GfbQvl8ZcQeDuU3Mcc2MDvaIdp5fHygoqTwNjzLvOLaaFaLx8D2bBoNIChvH
KXrYo1fez1AQb13txYamERbZC8lSvoQMRK4NCorhsjl5d0hyxKjiBV5xzbvuMHCD
WpgY6C8V/9O24U23QCTWg5LBkNRW2j6gpy2Mf1PA/PEPfY7lJ9NDtxIjjW0yHF+Q
028BIpaKmHwVK/kAhsRZ
=FWak
-----END PGP SIGNATURE-----

--nWclrlgqnAApBvUd--
