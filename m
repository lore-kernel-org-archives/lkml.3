Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782AbaFCPJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:09:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:42065 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaFCPJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:09:18 -0400
Date: Tue, 3 Jun 2014 17:09:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>,
        sparse@chrisli.org
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
Message-ID: <20140603150908.GW30445@twins.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <CA+55aFzwrqkwD=G=w2m7TdXTpsMFjV7XUMXv5DMPGr=5x5YGCQ@mail.gmail.com>
 <alpine.LRH.2.02.1406021622200.5874@file01.intranet.prod.int.rdu2.redhat.com>
 <CA+55aFwCy4-x02U6A-KbkPEpe_4pagsZ__ipBhe5HZOQt2vNmw@mail.gmail.com>
 <alpine.LRH.2.02.1406021656550.5874@file01.intranet.prod.int.rdu2.redhat.com>
 <20140603073613.GH11096@twins.programming.kicks-ass.net>
 <20140603140727.GM22231@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Aud9EHxdAK8dTD3F"
Content-Disposition: inline
In-Reply-To: <20140603140727.GM22231@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Aud9EHxdAK8dTD3F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 07:07:27AM -0700, Paul E. McKenney wrote:
> On Tue, Jun 03, 2014 at 09:36:13AM +0200, Peter Zijlstra wrote:
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
> Should be fun interacting with atomic operations on __rcu variables
> (address space 4).  Of course, that is already fun...
>=20

Hmm, good point, I suppose sparse doesn't like two different
address_space annotations on the same variable ?

/me adds Christpoher Li to the CC list.

ISTR Mikulas actually listing one such, me digs in recent email..

> $ grep -w "fdt->fd" */*.c
> fs/file.c:      free_fdmem(fdt->fd);
> fs/file.c:      fdt->fd =3D data;
> fs/file.c:      free_fdmem(fdt->fd);
> fs/file.c:                              struct file * file =3D xchg(&fdt-=
>fd[i], NULL);

So yes, that's going to be fun, mostly because rcu_assign_pointer()
doesn't actually do the right magic for this to be safe on their
platform(s).



--Aud9EHxdAK8dTD3F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjeUUAAoJEHZH4aRLwOS6fisP/07P8wBlEH4qC13SCTzXVmhp
YWI9JQLjLCr1Hlgiv7swJNCDhgXmY6sh1wm+2HQXuQTUrV71Bh/UfkILSiUV/mnJ
5qwJQo/sEj/0T9lzACmazPH9Gi0eJjNjLtY/sppoWSeB5P3ET51LYyMCmW9i31sE
zcrcJgt8X75P1uHvECeG4rKXa+jWcXO9EqZllWLXRWUPPOauCoKSa+BMu+TcJJlr
OiwKbUjtBLPt8ZbhGw+rmSx5OlOhgNirv4kstGdcq4z6fF0T8YRnRWvSQiaoXbgs
VTSatBjI4p6qMX5IGVA008qyxppxQPgCNMZzauCXCPjpa8KO4OLbw5rAfgdfYv/i
MpwpSITf4DazlC9F2S9Jc/7M5NnHEt6LtGGjDeJVs49miFDs00F38lC/1EmkQLon
Bt3D7w/6y7IMmCGT9sNnunzsaW1thK9otlXCHARdWsrhkQCv/B8QXKv603ioYtWo
vbHeDDAIsaqPNVpD0X1ydfbfX9nw0Y5OMFF5JG4/kxgxhorfutHOnSB/2mjdF0ge
eBK69lIKsYyMjQR2H5hIuVLRoRHLwfoaRFncQjY3Xc59m0xefepyoK9QFh6yzsN9
ooVIkHIGB9PQwwQ9zlUeeARO3FH0YPBgLgOJFVaQs1dsRP8HmN2W3KIPEEClqRvu
9LqIs4cnUnZLerupqXoi
=yPLl
-----END PGP SIGNATURE-----

--Aud9EHxdAK8dTD3F--
