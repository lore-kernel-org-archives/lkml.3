Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaFCNZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:25:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45565 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaFCNZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:25:15 -0400
Date: Tue, 3 Jun 2014 15:24:39 +0200
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
Message-ID: <20140603132439.GN30445@twins.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <CA+55aFzwrqkwD=G=w2m7TdXTpsMFjV7XUMXv5DMPGr=5x5YGCQ@mail.gmail.com>
 <alpine.LRH.2.02.1406021622200.5874@file01.intranet.prod.int.rdu2.redhat.com>
 <CA+55aFwCy4-x02U6A-KbkPEpe_4pagsZ__ipBhe5HZOQt2vNmw@mail.gmail.com>
 <alpine.LRH.2.02.1406021656550.5874@file01.intranet.prod.int.rdu2.redhat.com>
 <20140603073613.GH11096@twins.programming.kicks-ass.net>
 <alpine.LRH.2.02.1406030341570.10639@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WFkhpfBSKA51eMK1"
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1406030341570.10639@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WFkhpfBSKA51eMK1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 07:14:31AM -0400, Mikulas Patocka wrote:
> > So if we really want to keep supporting these platforms; I would propose
> > something like:
> >=20
> > #ifdef __CHECKER__
> > #define __atomic	__attribute__((address_space(5)))
> > #else
> > #define __atomic
> > #endif
> >=20
> > #define store(p, v)	(*(p) =3D (typeof(*(p)) __force __atomic)(v))
> > #define load(p)		((typeof(*p) __force)ACCESS_ONCE(*(p)))
> >=20
> > Along with changes to xchg() and cmpxchg() that require them to take
> > pointers to __atomic.
> >=20
> > That way we keep the flexibility of xchg() and cmpxchg() for being
> > (mostly) type and size invariant, and get sparse to find wrong usage.
> >=20
> > Then parisc, sparc32, tile32, metag-lock1 and arc-!llsc can go implement
> > store() however they like.
>=20
> Your proposal is very good because it warns about incorrect usage=20
> automatically.

Exactly the point.

> Your usage is very similar to what my patch at the top of this thread=20
> does:
>=20
> Instead of "__atomic struct s *p;" declaration, my patch uses
> "atomic_pointer(struct s*) p;" as the declaration
> Instead of store(&p, v), my patch uses atomic_pointer_set(&p, v);
> Instead of load(&p), my patch uses atomic_pointer_get(&p);
> Instead of xchg(&p, v), my patch uses atomic_pointer_xchg(&p, v);
> Instead of cmpxchg(&p, v1, v2), my patch uses atomic_pointer_cmpxchg(&p1,=
 v1, v2);
>=20
> > But its horrible, and doesn't have any benefit afaict.
>=20
> See the five cases above - why do you say that the operation on the left=
=20
> is good and the operation on the right is horrible? To me, it looks like=
=20
> they are both similar, they are just named differently. Both check the=20
> type of the pointer and warns if the user passes incompatible pointer. If=
=20
> I rename the operations in my patch to store(), load(), xchg(), cmpxchg()=
,=20
> would you like it?

Nope.. because the above store,load,xchg,cmpxchg are type invariant and
work for anything of size (1),2,4,(8).

So I dislike your proposal on a number of points:

 1) its got pointer in, and while the immediate problem is indeed with
 pointers, there is no reason it always should be, so we'll keep on
 introducing new APIs;

 2) its got a fixed length, nl. sizeof(void *), if we were to find
 another case which had the same problem which used 'int' we'd have to
 again create new APIs;

 3) you only fixed the one site;

 4) I'm the lazy kind and atomic_foo_* is just too much typing, let
 alone remembering all the various new atomic_foo_ APIs resulting from
 all this.

This is the place where I really miss C++ templates; and yes before
people shoot me in the head for that, I do know about all the various
pitfalls and down sides of those too.

> My patch has advantage (over your #define __atomic=20
> __attribute__((address_space(5))) ) that it checks the mismatches at=20
> compile time. Your proposal only check them with sparse. But either way -=
=20
> it is very good that the mismatches are being checked automatically.

So my proposal goes a lot further in that by making xchg() and cmpxchg()
require pointer to __atomic, all sites get coverage, not only the one
case where you found was a problem.

Yes, this requires a lot more effort, for we'll have to pretty much
audit and annotate the entire tree, but such things can be done, see for
example the introduction of __rcu.

Also, these days we get automagic emails if we introduce new sparse
fails, so it being sparse and not gcc isn't really any threshold at all.

> We need some method to catch these races automatically. There are places=
=20
> where people xchg() or cmpxchg() with direct modifications, see for=20
> example this:

Yep, so all those places will immediately stand out, the first fail will
be that those variables aren't marked __atomic, once you do that, the
direct assignment will complain about crossing the address_space marker.

Voila, sorted.

--WFkhpfBSKA51eMK1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjcyWAAoJEHZH4aRLwOS6BjYP/1dyK54lrQr8N7sSFHyc3l+X
AaV/goYoXEIoQK2nRVX8Zsne1GLWhGVJvNwwa+oLM03qU0Fdx2E4EOyIEoYTAczd
tQpWH4QKzg9sG4EuBUqJ7ROO3rK+43YB9GwyXzOFX2yjzmbjGnbXk4KBOapyVelC
Gxwp3b6zHnMvfARPatMaNCqNYqMeidxvxCftgUrw6XqYzEwMBq6BrdRwhbrCXlEb
3TeXy1yCP1ldxtHmuGKImqDtUVrpHes/c6N4GQFZPFLqkxji74CdujIs5gfr0pVc
sS/u3mhOIpAMOaZ1jrnnh6Yx0x15PuQCp7Ut7VQvhyZvQkKTMWTUlbFsdfxsT0ND
miw5yZXJlGuqsuUjSm3YoLkKD5U80/+tyQe5JpAdKNAx08yGLgecGAr3ou0o1vzX
PmX+qU3R95NfQaRWRdIL+KqC+byA+2uB5yZmxbP5Y3nu3ZXBgaMfk7K/tzL8Qt97
/Ko5xqsPGdkmMJlnPNVhvhTbKDYWlXtGKYm2C9mc6iyENj9ouIyaXO6dzq+v9HJy
vtKTSFpvGaeQpGpdeJxKsDKv2Sb90DFyLRoVCI2eBNPk6ZZwO/LLZ0wRi3YMlJkU
H2jpITn9u0LXOs4GRlFp+b/+TySDEmXbK2Bxy9YPrxRkwR3pt4HojnY05xM1Bayh
XFLht5ElNrS8wBhm3gd3
=npg2
-----END PGP SIGNATURE-----

--WFkhpfBSKA51eMK1--
