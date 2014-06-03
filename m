Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbaFCHgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:36:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:32780 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbaFCHgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:36:36 -0400
Date: Tue, 3 Jun 2014 09:36:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
Message-ID: <20140603073613.GH11096@twins.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <CA+55aFzwrqkwD=G=w2m7TdXTpsMFjV7XUMXv5DMPGr=5x5YGCQ@mail.gmail.com>
 <alpine.LRH.2.02.1406021622200.5874@file01.intranet.prod.int.rdu2.redhat.com>
 <CA+55aFwCy4-x02U6A-KbkPEpe_4pagsZ__ipBhe5HZOQt2vNmw@mail.gmail.com>
 <alpine.LRH.2.02.1406021656550.5874@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C3csQhHPgbq3tf44"
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1406021656550.5874@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C3csQhHPgbq3tf44
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2014 at 05:12:16PM -0400, Mikulas Patocka wrote:
> The patch adds atomic_pointer_t for all architectures - it is in the=20
> common code and it is backed by atomic_long_t (that already exists for al=
l=20
> architectures). There is no new arch-specific code at all.
>=20
> When we have atomic_pointer_t, we can find the instances of xchg() and=20
> cmpxchg() and convert them to atomic_pointer_t (or to other atomic*_t=20
> types).
>=20
> When we convert them all, we can drop xchg() and cmpxchg() at all (at=20
> least from architecture-neutral code).
>=20
> The problem with xchg() and cmpxchg() is that they are very easy to=20
> misuse. Peter Zijlstra didn't know that they are not atomic w.r.t. normal=
=20
> stores, a lot of other people don't know it too - and if we allow these=
=20
> functions to be used, this race condition will reappear in the future=20
> again and again.
>=20
> That's why I'm proposing atomic_pointer_t - it guarantees that this race=
=20
> condition can't be made.

But its horrible, and doesn't have any benefit afaict.

So if we really want to keep supporting these platforms; I would propose
something like:

#ifdef __CHECKER__
#define __atomic	__attribute__((address_space(5)))
#else
#define __atomic
#endif

#define store(p, v)	(*(p) =3D (typeof(*(p)) __force __atomic)(v))
#define load(p)		((typeof(*p) __force)ACCESS_ONCE(*(p)))

Along with changes to xchg() and cmpxchg() that require them to take
pointers to __atomic.

That way we keep the flexibility of xchg() and cmpxchg() for being
(mostly) type and size invariant, and get sparse to find wrong usage.

Then parisc, sparc32, tile32, metag-lock1 and arc-!llsc can go implement
store() however they like.



--C3csQhHPgbq3tf44
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjXrtAAoJEHZH4aRLwOS600UP/31g+OD4KSjczG/ZhSVsIagP
0wLJYumd8UqFkArSRcJ6q3xcTzV34C705M34dZyFq0etylvyMcNtjvyZkjzTzpcd
nM5nPNGLIrew12PCqkPeUxCSe7V7e+Wyte/mg1ejWdhdTKi3B3YeKICqGo52cW2v
8PtzYyVKi83WkYEV/Y1gok1nsbych19manSI6Rn1hy4eLBKS3IBKYcz9Pwff2bgs
moowd/K19tkvvl2MrBQM1yrrHe8iYSvmeLmdEWma0s3lJCp3BknyjUPPTQpGF8sq
dE8YDO2mxgcIzx0p/xvBQ2OtiJNqfStrEZMne/2ODWKF12r7pZ/gPnJU4SO8rIZI
U7xm07hPDKvmBG+h8wSBvCcdtnWqj9Tp6tMa4OqV4Ze4DWne8ysj/y7bJrhAYyiP
bY25GXknujcOxZPliXgmX5E1fpTAtNP/lG39EACZFP0wBGRHq/efO3wia0Pbw+Ev
gkZksDf1GkKPmmVkHuAerlzbhBhupy1ZbR6YDWAwNmHiAkitXy5rPmrso6z5Z+6G
8f/fGIz233BI9bOnYmaf/a0O8xLU9Y+h0+cUXvSoSbfwwZrrgMbbSCufDeYKN/aG
9quSHASRcQpeUM3aEHk29Wpj0hFyZiRFKntpvrVrCqvo/hAh3iJ5CdpieoBVrB2+
MkXIDDqJNoUwusUl8lY6
=CJbB
-----END PGP SIGNATURE-----

--C3csQhHPgbq3tf44--
