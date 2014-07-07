Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaGGOe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:34:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaGGOeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:34:24 -0400
Date: Mon, 7 Jul 2014 16:33:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 05/11] qspinlock: Optimize for smaller NR_CPUS
Message-ID: <20140707143357.GR6758@twins.programming.kicks-ass.net>
References: <20140615124657.264658593@chello.nl>
 <20140615130153.483502389@chello.nl>
 <20140618155730.GA5107@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AC4h36899OtEuhrO"
Content-Disposition: inline
In-Reply-To: <20140618155730.GA5107@laptop.dumpdata.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AC4h36899OtEuhrO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 11:57:30AM -0400, Konrad Rzeszutek Wilk wrote:
> On Sun, Jun 15, 2014 at 02:47:02PM +0200, Peter Zijlstra wrote:
> > From: Peter Zijlstra <peterz@infradead.org>
> >=20
> > When we allow for a max NR_CPUS < 2^14 we can optimize the pending
> > wait-acquire and the xchg_tail() operations.
> >=20
> > By growing the pending bit to a byte, we reduce the tail to 16bit.
> > This means we can use xchg16 for the tail part and do away with all
> > the repeated compxchg() operations.
> >=20
> > This in turn allows us to unconditionally acquire; the locked state
> > as observed by the wait loops cannot change. And because both locked
> > and pending are now a full byte we can use simple stores for the
> > state transition, obviating one atomic operation entirely.
>=20
> I have to ask - how much more performance do you get from this?
>=20
> Is this extra atomic operation hurting that much?

Its not extra, its a cmpxchg loop vs an unconditional xchg.

And yes, its somewhat tedious to show, but on 4 socket systems you can
really see it make a difference. I'll try and run some numbers, I need
to reinstall the box.

(there were numbers in the previous threads, but you're right, I
should've put some in the Changelog).

> >  /**
> >   * queue_spin_lock_slowpath - acquire the queue spinlock
> > @@ -173,8 +259,13 @@ void queue_spin_lock_slowpath(struct qsp
> >  	 * we're pending, wait for the owner to go away.
> >  	 *
> >  	 * *,1,1 -> *,1,0
> > +	 *
> > +	 * this wait loop must be a load-acquire such that we match the
> > +	 * store-release that clears the locked bit and create lock
> > +	 * sequentiality; this because not all clear_pending_set_locked()
> > +	 * implementations imply full barriers.
> >  	 */
> > -	while ((val =3D atomic_read(&lock->val)) & _Q_LOCKED_MASK)
> > +	while ((val =3D smp_load_acquire(&lock->val.counter)) & _Q_LOCKED_MAS=
K)
>=20
> lock->val.counter? Ugh, all to deal with the 'int' -> 'u32' (or 'u64')

No, to do atomic_t -> int.

> Could you introduce a macro in atomic.h called 'atomic_read_raw' which
> would do the this? Like this:

That would be worse I think. It looks like a function returning an
rvalue whereas we really want an lvalue.



--AC4h36899OtEuhrO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTuq/VAAoJEHZH4aRLwOS63hwQAIFCSObxs1K7RGi7RHMikHRD
joavWYubyQmoi8/xhdk2sU10wP82yaLctY4V+gqMdW9e6Tw09yGPcfWRFGVQE/wG
r/XYr00u6vpxlJggRRSaBjf/S7I44h/TI329UoZ1HeAsETozUU/PNa0H5Y+91SqU
UrFARlmIdDKQH+stqmlbnJ5kO8fTx5DF8Dfj9wbuVqzK/d1CHrN0k0PWgzkHsdPE
pHkFPOYe1m6MO4T/6khbOSzLSVWhJrgDAkoroKlp+y41jPcqIKGMJ9kanw9ueuk9
4rKd2/a+M7ZBnBjDHfyZuvNaeRyeR1SOl7oIb6HWBwhzaY7jdZcRLwCOLkWYgFKY
3lbSA53qoXgG6zEdfB0J0FMvw/vjHQ6MoRG7kqYVQhwa6fWDWMAx/fSE9P2ERCKH
Xj9zfMBHNGnLpaWBRrstLKvIe6FHBRxnTmTX+tmjJdv8Amw6aoQwEOw4Es+Iz5Iv
gwVroYO3EqXesMj4++GaWEEZ8NCtBYjjTnn/N6aZLvA1pyhHdE2/WTUha+xzTTvI
ZV05O/KREthFoJZdrvFdEZv6LfYv+g+nmz+3acTB71QI14AleTsrJ82optdziWvb
3dy/G/wgfknZmyZGsS2IdZk27DoOoEhwbB77hqRThiTpVwPRYXQ50Y8TgDxybKZo
pPt2MpfCQed7ZdrNmgWd
=qzB6
-----END PGP SIGNATURE-----

--AC4h36899OtEuhrO--
