Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaGNIiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:38:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:50870 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaGNIiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:38:02 -0400
Date: Mon, 14 Jul 2014 10:37:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to
 CLOCK_MONOTONIC[_RAW]
Message-ID: <20140714083753.GK9918@twins.programming.kicks-ass.net>
References: <20140711133623.530368377@linutronix.de>
 <20140711133709.835700036@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cy+5HEalSgyXkpVS"
Content-Disposition: inline
In-Reply-To: <20140711133709.835700036@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Cy+5HEalSgyXkpVS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2014 at 01:45:19PM -0000, Thomas Gleixner wrote:
> Tracers want a correlated time between the kernel instrumentation and
> user space. We really do not want to export sched_clock() to user
> space, so we need to provide something sensible for this.
>=20
> Using separate data structures with an non blocking sequence count
> based update mechanism allows us to do that. The data structure
> required for the readout has a sequence counter and two copies of the
> timekeeping data.
>=20
> On the update side:
>=20
>   tkf->seq++;
>   smp_wmb();
>   update(tkf->base[0], tk;
>   tkf->seq++;
>   smp_wmb();
>   update(tkf->base[1], tk;
>=20
> On the reader side:
>=20
>   do {
>      seq =3D tkf->seq;
>      smp_rmb();
>      idx =3D seq & 0x01;
>      now =3D now(tkf->base[idx]);
>      smp_rmb();
>   } while (seq !=3D tkf->seq)
>=20
> So if NMI hits the update of base[0] it will use base[1] which is
> still consistent. In case of CLOCK_MONOTONIC this can result in
> slightly wrong timestamps (a few nanoseconds) accross an update. Not a
> big issue for the intended use case.

But it breaks monotonicity, right? ;-)

Also, what happens when TSC is not available as a clocksource? There's
still a metric ton of hardware (including the latest generation HSW)
that has fucked firmware/TSC.



--Cy+5HEalSgyXkpVS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw5bhAAoJEHZH4aRLwOS6SJAP/2qwCgmLctptct9v65YaeZZ4
IjPIum50eAA5KNVMndphGEwMqVB78DvoOHitNpjt7SGK2uJtpi+UWHXBeNwXKL0x
sbBuhYosv5+jK55eCKF2vb8nDWne7HjL+Zx/jPsdEVmWdrAJWno2gMK96LIY26pr
vt/K8i79NIYcJn1gPj46wIx1Qb+YYlMvUuU7NW1X1iCQU5K7cAuWFecyQuK1X6pQ
Q6LeKHPDJWeShr028Rh96Sye1MesmX/rJzzMnmeEuyBrhDOUdn5UHdEAhBp7pi7k
qmQ12RyhTJKu6Ic2T7S9evCgCI+VH6k9KAP6AXiqTWDFmeRp7uLHfB0n8XunTD1h
+13sl3IKi9wIleQe4/U7r334TMnWDARa8f8Td29iiynWgY29ju0zukiz8odDbnsX
rqWGP8VDYJXM09O1Fze0wQPON8GADrNBraklU6fxvP5zprNCc5CP+jEYo9lqFxjO
n0+IaQ0xDEMhwWH51AEubuXHE0uMupDTrYsHg4w2rcnqpByGJI6gnN1pCId90xu+
/vDfRITk6g9VgL7545rxiNxYmYF94wOcMYqd72tlBCmqE8T9uXDxPyBUQt+E2cbO
GCI/pTLPjRUEcRLGAZPur61mjsNDMHxEqxyl5jHiBR7Sk+I5kFK7/9KMfXyc4R7F
Bi4tzKMVrZPyjWESYoTU
=ff3U
-----END PGP SIGNATURE-----

--Cy+5HEalSgyXkpVS--
