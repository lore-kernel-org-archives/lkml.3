Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaENLU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:20:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbaENLU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:20:57 -0400
Date: Wed, 14 May 2014 13:20:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Michael wang <wangyun@linux.vnet.ibm.com>,
        "ktkhai@parallels.com" <ktkhai@parallels.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
Message-ID: <20140514112048.GJ13658@twins.programming.kicks-ass.net>
References: <534610A4.5000302@oracle.com>
 <53464164.5030701@linux.vnet.ibm.com>
 <336561397137116@web27h.yandex.ru>
 <5347FCED.8040706@oracle.com>
 <1442521397229373@web20m.yandex.ru>
 <53711785.5010504@oracle.com>
 <2614131400060552@web30m.yandex.ru>
 <20140514101354.GI30445@twins.programming.kicks-ass.net>
 <2158101400062864@web10h.yandex.ru>
 <20140514102602.GJ30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eMnpOGXCMazMAbfp"
Content-Disposition: inline
In-Reply-To: <20140514102602.GJ30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eMnpOGXCMazMAbfp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 12:26:02PM +0200, Peter Zijlstra wrote:
> so we serialize stop_cpus_work() vs stop_two_cpus() with an l/g lock.
>=20
> Ah, but stop_cpus_work() only holds the global lock over queueing, it
> doesn't wait for completion, that might indeed cause a problem.
=20
Hmm, is this so? If the stop_cpus_work() queueing is complete, the
stop_two_cpus() queueing must always happen _after_ it.

Therefore the stopper threads should also observe them in that order,
right? /me goes check..

Hmm, cpu_stop_queue_work() does list_add_tail(), does that make it a
LIFO?=20

Bah, now I've confused myself again.

> Also, since its two different cpus queueing, the ordered queue doesn't
> really matter, you can still interleave the all and two sets and get
> into this state.


Anyway, before I stared getting self doubts, I wrote the below, now I'm
not sure its at all relevant but here goes.

---

Yeah, sorry for not also providing a solution, extending the lg_global
lock over the entire sqeuence won't work for it will disable preemption,
which means we need something a little smarter.

Now, I still have the hotplug lock rewrite laying about, now Linus had
an opinion on that, but we could adapt percpu-rwsem.c to use the same
logic.

At that point, I think it would be possible to use the percpu-rwsem for
this, use the write lock for the global stop all thing, and the read
side for the two-cpu stopper.

  http://thread.gmane.org/gmane.linux.kernel/1574737


--eMnpOGXCMazMAbfp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc1GQAAoJEHZH4aRLwOS6Cw4P/iYXNtBE5BzI77ZivOK50R+I
tYYQNjrhdb4PFdQCjX5xxKFWFdHV1VHCcNHZ6O89UIlWdE9i9wsuF0CAbbGkQQj1
Q2xW24xtaRaJ8N3pDsiOdJar9j+rP6u8WWRLs0BklAWprdxG7nJSLA7mOi/8qDSQ
jpqbkgf/3yQ+j+tamp/dWkCqSzejgPQnNS0qdWbdggiKSqrIBh+QofRBJ43D8yBC
Mq5Z68bQsJ0UdU8B2vFKTY6anyTMDrYSYV3D4b3HO7MBdgExG+VORyZJgyHM0IO8
WwOzIXoLoOmtlzSdt9mzKczKZ2HURXSyj7hi379gn/jPm8N9waTA+4Ot69rebaLJ
XkyHFSP4K7mb/dk/571iyI84tg2ZGvADf19NsghB6/qkfLOXg0WXgwcyl2ZKogL0
raEbSPHQLWysfYpL5iu0Ig9BqS4CfsB7L6MQFIbq9szfMzNi0QJ+qdwv9Oi8AkWT
m9sYDTqn3DBtkf1qKDxZnrzbeNsU0bglAVH/ChARM8lEyoEut7JUB+TkDLPK4TYF
LiCJbTNek2B8Jn/bY6guaXE7HL8SQ8IWK20w/jauSfbLKYT9mdOD61WvqTV9fZQL
3IyXQ+rYQhpYPFB1xj9SjFAn1bqDo40sAaAs0DhnaM5XDufpYMSinVwhns3NEWub
R0yQR8h82ZFlaK31UhqB
=d5Ju
-----END PGP SIGNATURE-----

--eMnpOGXCMazMAbfp--
