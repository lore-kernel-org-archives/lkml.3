Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbaGNJqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:46:23 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39686 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbaGNJqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:46:16 -0400
Date: Mon, 14 Jul 2014 11:45:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to
 CLOCK_MONOTONIC[_RAW]
Message-ID: <20140714094558.GN9918@twins.programming.kicks-ass.net>
References: <20140711133623.530368377@linutronix.de>
 <20140711133709.835700036@linutronix.de>
 <20140714083753.GK9918@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1407141100280.4357@nanos>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WeDu0lr7bteb/II5"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1407141100280.4357@nanos>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WeDu0lr7bteb/II5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 11:04:39AM +0200, Thomas Gleixner wrote:
> On Mon, 14 Jul 2014, Peter Zijlstra wrote:
> > On Fri, Jul 11, 2014 at 01:45:19PM -0000, Thomas Gleixner wrote:
> > > Tracers want a correlated time between the kernel instrumentation and
> > > user space. We really do not want to export sched_clock() to user
> > > space, so we need to provide something sensible for this.
> > >=20
> > > Using separate data structures with an non blocking sequence count
> > > based update mechanism allows us to do that. The data structure
> > > required for the readout has a sequence counter and two copies of the
> > > timekeeping data.
> > >=20
> > > On the update side:
> > >=20
> > >   tkf->seq++;
> > >   smp_wmb();
> > >   update(tkf->base[0], tk;
> > >   tkf->seq++;
> > >   smp_wmb();
> > >   update(tkf->base[1], tk;
> > >=20
> > > On the reader side:
> > >=20
> > >   do {
> > >      seq =3D tkf->seq;
> > >      smp_rmb();
> > >      idx =3D seq & 0x01;
> > >      now =3D now(tkf->base[idx]);
> > >      smp_rmb();
> > >   } while (seq !=3D tkf->seq)
> > >=20
> > > So if NMI hits the update of base[0] it will use base[1] which is
> > > still consistent. In case of CLOCK_MONOTONIC this can result in
> > > slightly wrong timestamps (a few nanoseconds) accross an update. Not a
> > > big issue for the intended use case.
> >=20
> > But it breaks monotonicity, right? ;-)
>=20
> It can in theory, but does it really matter for tracing?

Not so much; but I think the interfaces aren't quite as explicit as they
maybe should be about this.

> > Also, what happens when TSC is not available as a clocksource? There's
> > still a metric ton of hardware (including the latest generation HSW)
> > that has fucked firmware/TSC.
>=20
> Well, bad luck then. You end up using hpet or worse, but it's still
> your decision whether to base your instrumentation on that or not. For
> sane clock sources (i.e. almost anything except TSC) it works
> perfectly fine.

So I can imagine clock sources themselves not being NMI safe on a
hardware level. But also, I'm fairly sure you do not want HPET reads in
a function tracer :-)

And I absolutely detest this configurability muck. I want a single
'clock'.

But yes, we can do what you suggested, we can do something like:

	if (tsc-stable)
		return nmi-mono
	else
		return sched_clock

Seeing how with tsc-unstable the sched_clock muck is synched to clock
monotonic.



--WeDu0lr7bteb/II5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw6bWAAoJEHZH4aRLwOS6xBsP/Rw/w1cZfmeTCXsk4iCyVSjG
tbmwp8u8Uu1WRqmMOjC75v0rdZhw1tIrNm8qv9k8fSzP96/xx1mHPPSVqe94hg+Y
Xvhx2c5lXZTlJaDMNfkaYS90gami/tM+YAyA7MGU/QzpwcVqAJ/FZe9bRoJIjDCR
ZDnrApWJaR49P71sC5W4dvAuanq83VdgHcxtlG+/TRkySyGUk8ukF9IoYDgAry4p
JhmAn4kYcwrq95gTnu1j/WzFq/ppl5qFcec3gAEoLh0bc9FjJI7avJohDqIuIJgp
iwX5vK5crnMd2pmuPsjiTEi4kWaVAAL3ennIhU8EuqDu+/Lvtmm/1PYKTUrzu8Au
U6AnHB5VoXT31Hh5DK5mvyMcgVdic3RQtmAadIeflUgGGXrq9PlaYz2rQRLDkSjs
po+rw2TE+muBGYkh6rbgA12T9SarinocgxlWOc6fyHSlFOE8rLXZKEQnvbCubNV1
zrfpEV3On1itl7uIUUiyp/ZhEsypm1y5kNCTIDAZ083C7HRDCx6g9SX5b9MxQ+bH
tNNVBkQx/uq+l9eSLcPUc320Jnmpf2/Pfl6QXwHFE0StO0zWCwGHG7KjBMGY/Civ
Wa10Xb4s/B2z3/W7M4A7VQQSB1vb9APHSNpNpHVLT8QgI7hhOq9A9nRWL39G5tVv
FMgJZ/cJ3KooKdNWORle
=xSwL
-----END PGP SIGNATURE-----

--WeDu0lr7bteb/II5--
