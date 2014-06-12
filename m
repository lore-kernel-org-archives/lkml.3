Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaFLGAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:00:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:57722 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaFLGAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:00:41 -0400
Date: Thu, 12 Jun 2014 08:00:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Long, Wai Man" <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v11 06/16] qspinlock: prolong the stay in the pending bit
 path
Message-ID: <20140612060032.GQ6758@twins.programming.kicks-ass.net>
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
 <1401464642-33890-7-git-send-email-Waiman.Long@hp.com>
 <20140611102606.GK3213@twins.programming.kicks-ass.net>
 <5398C894.6040808@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yhCE4sTDB5mqd9YJ"
Content-Disposition: inline
In-Reply-To: <5398C894.6040808@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yhCE4sTDB5mqd9YJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 05:22:28PM -0400, Long, Wai Man wrote:

> >>@@ -233,11 +233,25 @@ void queue_spin_lock_slowpath(struct qspinlock *l=
ock, u32 val)
> >>  	 */
> >>  	for (;;) {
> >>  		/*
> >>-		 * If we observe any contention; queue.
> >>+		 * If we observe that the queue is not empty or both
> >>+		 * the pending and lock bits are set, queue
> >>  		 */
> >>-		if (val & ~_Q_LOCKED_MASK)
> >>+		if ((val & _Q_TAIL_MASK) ||
> >>+		    (val =3D=3D (_Q_LOCKED_VAL|_Q_PENDING_VAL)))
> >>  			goto queue;
> >>+		if (val =3D=3D _Q_PENDING_VAL) {
> >>+			/*
> >>+			 * Pending bit is set, but not the lock bit.
> >>+			 * Assuming that the pending bit holder is going to
> >>+			 * set the lock bit and clear the pending bit soon,
> >>+			 * it is better to wait than to exit at this point.
> >>+			 */
> >>+			cpu_relax();
> >>+			val =3D atomic_read(&lock->val);
> >>+			continue;
> >>+		}
> >>+
> >>  		new =3D _Q_LOCKED_VAL;
> >>  		if (val =3D=3D new)
> >>  			new |=3D _Q_PENDING_VAL;

> >Wouldn't something like:
> >
> >	while (atomic_read(&lock->val) =3D=3D _Q_PENDING_VAL)
> >		cpu_relax();
> >
> >before the cmpxchg loop have gotten you all this?
>=20
> That is not exactly the same. The loop will exit if other bits are set or=
 the pending
> bit cleared. In the case, we will need to do the same check at the beginn=
ing of the
> for loop in order to avoid doing an extra cmpxchg that is not necessary.

If other bits get set we should stop poking at the pending bit and get
queued. The only transition we want to wait for is: 0,1,0 -> 0,0,1.

What extra unneeded cmpxchg() is there? If we have two cpus waiting in
this loop for the pending bit to go away then both will attempt to grab
the now free pending bit, one will loose and get queued?

There's no avoiding that contention.



--yhCE4sTDB5mqd9YJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTmUIAAAoJEHZH4aRLwOS6d1kP+wZX1ZPRaWS1nRcTCcUmc+D0
eSXmxC3CGBNkShcRc/4dSvFfjAtozeDQCoDbwhUCzADGbMNph4UuvUrYSXLizHM3
M46Tn/ibZ0a5r2kZDVaBqi1RUUDgOEVc2a2OtJtzb3TrU2rPKjeBiLm8sWThFfAe
OCsJXO2T0SxNRNbQKJbNNfr99tDC0AVG8JOEPdJXL2A8Jf5T88mw4gFmyIHTOpcV
idh26oKRkxP0/iGFAdgheFdHY+dOd5jlMsdqsCGO7ee4Ol7YFDCRctwyZWTBDVJq
wNC8GgqJHnA0y9LOtwO+XMlUaN6afKcojxfeZraCtPTCv3gekKuXj+9fLXFwXJ/H
NpjiyDAuN3OjdHh3NeKR1mMviTBrVdYa471aVADKMjSfvvzHEjEEMMDGj+EeTJUk
pj0aV/v2gC1yW0YDGzD+IYKCTJRAD7sz+sWkIT7rK6lpGGfZN5A4gHSvscjkpMqT
XxR2Lv0nU1ogkMenaPT/Z3Txd96dLD4ogwkT4tIJ0UbCAZaEHDpLS4Mc9HhUQdA4
tsM7amb3Knln4Pq30UBs8r9lHSaEvZFt/QRdPOJPE14Egn4mtDpD+lFY+L9XS0qj
L1xx5J+qH309+yqT2j1hg4bbBHcJTv2Q4SX+UYGgtyaPZugBZ9urYygObiSveN9c
Qf2DeTxSSFU+AztfMQQY
=fnbJ
-----END PGP SIGNATURE-----

--yhCE4sTDB5mqd9YJ--
