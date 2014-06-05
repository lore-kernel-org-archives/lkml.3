Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaFEHWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:22:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36206 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaFEHWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:22:52 -0400
Date: Thu, 5 Jun 2014 09:22:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andev <debiandev@gmail.com>
Cc: Pranith Kumar <pranith@gatech.edu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] remove redundant compare, cmpxchg already does it
Message-ID: <20140605072248.GE3213@twins.programming.kicks-ass.net>
References: <538F83DF.8090303@gatech.edu>
 <CAJUuVQ4VioKuVuCTXr3BcfRpYs+9+5bx9m2WLO7Swsnni0tUAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DqhR8hV3EnoxUkKN"
Content-Disposition: inline
In-Reply-To: <CAJUuVQ4VioKuVuCTXr3BcfRpYs+9+5bx9m2WLO7Swsnni0tUAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DqhR8hV3EnoxUkKN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 04:56:50PM -0400, Andev wrote:
> On Wed, Jun 4, 2014 at 4:38 PM, Pranith Kumar <pranith@gatech.edu> wrote:
> > remove a redundant comparision
> >
> > Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> > ---
> >  kernel/locking/rwsem-xadd.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> > index 1f99664b..6f8bd3c 100644
> > --- a/kernel/locking/rwsem-xadd.c
> > +++ b/kernel/locking/rwsem-xadd.c
> > @@ -249,8 +249,7 @@ static inline bool rwsem_try_write_lock(long count,=
 struct rw_semaphore *sem)
> >  {
> >      if (!(count & RWSEM_ACTIVE_MASK)) {
> >          /* try acquiring the write lock */
> > -        if (sem->count =3D=3D RWSEM_WAITING_BIAS &&
> > -            cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
> > +        if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
> >                  RWSEM_ACTIVE_WRITE_BIAS) =3D=3D RWSEM_WAITING_BIAS) {
>=20
> This was mainly done to avoid the cost of a cmpxchg in case where they
> are not equal. Not sure if it really makes a difference though.

It does, a cache hot cmpxchg instruction is 24 cycles (as is pretty much
any other LOCKed ins, as measured on my WSM-EP), not to mention that
cmpxchg is a RMW so it needs to grab the cacheline in exclusive mode.

A read, which allows the cacheline to remain in shared, and non LOCKed
ops are way faster.

--DqhR8hV3EnoxUkKN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkBrIAAoJEHZH4aRLwOS6QfsP/jU1bNNlNoaL/Gk3ksAX/d5K
zllkfyV2B35G44HuBO2HQqakfluecr/v7fp9+b8T/OZQTd8IWcGePoUE1Ondt3Ct
vGgcZUPhqvURAQS/y2p0yHvkSdBCwQGNfk/jNnAPf0oFD1PKKk5mcoKOMUgnbQr4
rC6cDEfCVMJMOdt1YbuTB6yv6RMug2xPQRBlzMYDuA/RMu1uS/2lBGWRkKEMmnok
fJFrNOu3Bc+pwyP6MOGF0i+Y6InNEQ489/H5JL1tDxs/UspFJVk3w6bQwLMpe3A7
ahUNRYPnpTzW+9G+O6Xdr/xE3deljIVV47exxoCxBoXJQ/0Qej6/WerCkV7gXgom
Fxq5DkSzlMxraY9fcqhLBPjfB1kzt4+E9lrYkH6RM5kAAxQbUmw3w13NWU1z/HTL
68FANLTTJfCQ+vWWrOF9NVd0cZ8802j1jmxX/IwL4HPZc44jIIiK1maj52TLJAFw
PVb8iq/CWG0LK67ll/uZCjmP9JtuaGxsdiHthB7VBa1o1ANhK/6FxIJcivmTcZBA
O0ASZ3InEGSi+G8DjBJdz3Kmhx1bEJy8f1JyoKzYGv7EJpTo71n25bkF+S3hMWH5
+ibD1jxLYfpcEkLifWPNYI3pTCdYgIxoSZAWgZ3B9fEJuBeDY5YsPwEcPVIqA5+H
W2hUKfPFvajjdfx7TQ2S
=+VM7
-----END PGP SIGNATURE-----

--DqhR8hV3EnoxUkKN--
