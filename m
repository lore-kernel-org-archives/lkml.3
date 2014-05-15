Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaEOSVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:21:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaEOSVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:21:47 -0400
Date: Thu, 15 May 2014 20:21:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perfevents: irq loop stuck!
Message-ID: <20140515182136.GI11096@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1405132256470.27229@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405142246170.30015@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P6nFlVIU+yrLqGt6"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405142246170.30015@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P6nFlVIU+yrLqGt6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 10:55:40PM -0400, Vince Weaver wrote:
> On Tue, 13 May 2014, Vince Weaver wrote:
>=20
> >         pe[32].sample_period=3D0xc0000000000000bd;
> >=20
> > Should it be possible to open an event with a large negative sample_per=
iod=20
> > like that?=20
>=20
> so this seems to be a real bug.
>=20
> attr->sample_period is a u64 value, but internally it gets cast to
> s64 and is added against itself and so all kinds of unexpected things=20
> happen.
>=20
> So if you set attr->sample_period to 0xc0000000000000bd in the hopes of=
=20
> sampling the RETIRED_INSTRUCTIONS event every 5 years or so, instead
> what happens is that in
> 	x86_perf_event_set_period()
> the value is cast to a signed 64-bit value, so we are now negative.
>=20
> Then "left" is set to period because we are negative.
>=20
> Then since left is less than 0, we double the period value.
> This overflows the 64-bit integer and suddenly we are in undefined
> behavior territory and we're lucky the C compiler doesn't decide to
> format the hard drive.
>=20
> Anyway we are still less than 0, so then the
>=20
> 	if (unlikely(left < 2))
> 		left =3D 2;
>=20
> code kicks in and suddenly our hugely positive sample_period has changed
> to just being "2".  And so we suddenly get a storm of interrupts instead=
=20
> of one every 5 years.
>=20
> So, not sure how to fix this without a total re-write, unless we want to=
=20
> cheat and just say sample_period is capped at 62-bits or something.

63 bits should do I think, but yes, we hit a very similar but a few days
ago in the sched_deadline code.

I'm fine with capping it, allowing the full 64bit would mean we need 65
bits (effectively 96 or 128 bit of course) math to make it all work
which would be tedious and give no real gain.

> Also it's unclear why sometimes this can cause a stuck interrupt leading=
=20
> to the "irq loop stuck" message.  I have a reproducible fuzzer test case=
=20
> that will cause this to happen, but can't isolate it down to a simple tes=
t=20
> case...

So yes.. in theory we should throttle the event after a number of
interrupts to keep the machine alive, and I think that happens because
I've managed to hit it too while trying to reproduce one of the problems
Sasha reported and the machine was largely usuable.

It might trigger the getting stuck msgs because we can reach the 2
events (2 retired instructions isn't that many) in the NMI return path
after we've re-enabled the PMU I suppose.

We'll then not make progress for a while, print the msg, get throttled,
goto 1. This is possible if we're allowed 100+ interrupts per jiffy, so
if you adjust /proc/sys/kernel/perf_event_max_sample_rate to below that
and it doesn't trigger anymore we know the throttle works.

We've also seen hardware seize up on low period counts like that, which
is why there's a minimum of 2, 1 would guarantee an NMI storm/lockup no
matter what.

--P6nFlVIU+yrLqGt6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdQWwAAoJEHZH4aRLwOS6wakP/3oAyFh3dGRZkFWc76FSRKoB
AyXTbJzYh04ILwsQFiiIKKpQjUHgGxcCWvcedGqIw1liTccwIejIimyqk+vEX8Ae
I17wDE7KYSeeMVzpDjLsLWBACgOJiunSaPNb0wK78PbW/QjLj60POZXhQC7ahlHd
wobtEuj+nDkAmbNwZ3naPRh6NtB3QvYrsKSzkFQr/UdvbGJivqBXlbDhQWrrWBhR
XdZawZQxRr+6SAsrQr40LP9nSyLmYLaYi8g1/doicf2fx1PFZdXDS0/V1TJ/J2Z2
NpWBqETDqITVUsucZOFC8ArRM7bzrGs9DygQmGzM5+PBW4Tgqe7Ib7DqkA8W84ij
wMqZXSOryVN25lG5j1J4BljODJjcUZXUmZ5CwbfEYIreYcVqnOJCZBzp6IkkPjrP
fTaxQJZk/bjRuKwoLdj5QOrVheUYPciTsYLpoT/+pNMVh5a3Yhek/YBhr1LBfusC
NiGeD/sXZlC77fUxfB3f3Dj9INVgyUjJBT6ldwbu6Xj9calSekQIFgZ8X35YEQus
5I427mYkzdzVie47QmPaIaSu6Ibyeryq1ol1PCnkAmD4cUs+OyOskj66dkv0ZKlt
N71zbYgvVFn6gPz/RQJ/78VmKlPtRDOk1iTxVks1L9Mp98AhANB6hqVco4UDg7hT
B9xXTbjQ+MI7G5xKW9iN
=4AQE
-----END PGP SIGNATURE-----

--P6nFlVIU+yrLqGt6--
