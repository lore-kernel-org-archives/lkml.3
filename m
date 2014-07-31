Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaGaL6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:58:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:47398 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaGaL6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:58:11 -0400
Date: Thu, 31 Jul 2014 13:57:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ilya Dryomov <ilya.dryomov@inktank.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        ceph-devel@vger.kernel.org, davidlohr@hp.com, jason.low2@hp.com
Subject: Re: [PATCH] locking/mutexes: Revert "locking/mutexes: Add extra
 reschedule point"
Message-ID: <20140731115759.GS19379@twins.programming.kicks-ass.net>
References: <1406801797-20139-1-git-send-email-ilya.dryomov@inktank.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yILFoTi2Ujy0ZZ8L"
Content-Disposition: inline
In-Reply-To: <1406801797-20139-1-git-send-email-ilya.dryomov@inktank.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yILFoTi2Ujy0ZZ8L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 02:16:37PM +0400, Ilya Dryomov wrote:
> This reverts commit 34c6bc2c919a55e5ad4e698510a2f35ee13ab900.
>=20
> This commit can lead to deadlocks by way of what at a high level
> appears to look like a missing wakeup on mutex_unlock() when
> CONFIG_MUTEX_SPIN_ON_OWNER is set, which is how most distributions ship
> their kernels.  In particular, it causes reproducible deadlocks in
> libceph/rbd code under higher than moderate loads with the evidence
> actually pointing to the bowels of mutex_lock().
>=20
> kernel/locking/mutex.c, __mutex_lock_common():
> 476         osq_unlock(&lock->osq);
> 477 slowpath:
> 478         /*
> 479          * If we fell out of the spin path because of need_resched(),
> 480          * reschedule now, before we try-lock the mutex. This avoids =
getting
> 481          * scheduled out right after we obtained the mutex.
> 482          */
> 483         if (need_resched())
> 484                 schedule_preempt_disabled(); <-- never returns
> 485 #endif
> 486         spin_lock_mutex(&lock->wait_lock, flags);
>=20
> We started bumping into deadlocks in QA the day our branch has been
> rebased onto 3.15 (the release this commit went in) but then as part of
> debugging effort I enabled all locking debug options, which also
> disabled CONFIG_MUTEX_SPIN_ON_OWNER and made everything disappear,
> which is why it hasn't been looked into until now.  Revert makes the
> problem go away, confirmed by our users.

This doesn't make sense and you fail to explain how this can possibly
deadlock.

--yILFoTi2Ujy0ZZ8L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2i9HAAoJEHZH4aRLwOS6ORgP/3X4oTHF/0PDDxTJd45u7zXS
CvFdbG9jv6hcE8/4eMR4vjFoQABw6rOWXeJUBLF7faoSaAVTs1rhW149rxmV4+nA
OWMHqZXTH9A8cLeYdcfW1BQbRAeMEJPsUrvJqQmul84WkKr4YjobBC64LqKoJQ1K
cQZTzyOeXqNM5sTRs9MqoVlGEoR7r1s/OPunEgiyq53d3oXSWpr7lDt2oIi0roJq
YYZNONCJy4GrHz/iKcxzpwZI31EiCeH0T5uxisTz1D1AqoqJkLx+8sLqseaf8yQC
Uf/waDxeOQYvcB7WZ+4Wrj/+is2A3ikx4BxRzt2d9QDA4DdUxIX+BH2ZJM0w9UZh
z3uI5J2yNztEaK3RKFfmoEFjpPBv6VzkSc+SLxYKT9Ec/WwfhxuxXwHn2znsUb4D
Dsy4E/e3T2rcaFFZWHdAcshwPYH9Bw1O8muY+g0+vYVifWQn44q6UKNi5kHgUmii
obYHK7ID5BP7YKldLJMkkaHamte+mY1c597QuA5pWdIdatmSuOpE7jNcsimO/e8K
WM0j/9YXfeU/QjW4rp7Toyn+ePxtsEl4q/pSD1D8psOMtoOlq9tLZ6NhDaFN52gv
Bq2UFNDD4eYa5BCSH2uSEXRmCsxxaGv7M539qnC2G0HXl45K53jT33+KGtM7hEAs
BhgQS7m3rZBRLosEHtpZ
=OEt/
-----END PGP SIGNATURE-----

--yILFoTi2Ujy0ZZ8L--
