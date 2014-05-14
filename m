Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbaENRK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:10:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:51172 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbaENRK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:10:57 -0400
Date: Wed, 14 May 2014 19:10:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-ID: <20140514171051.GX30445@twins.programming.kicks-ass.net>
References: <20140509160455.GA4486@htj.dyndns.org>
 <20140514140034.GM30445@twins.programming.kicks-ass.net>
 <20140514170238.GB15690@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hh0bd0om1WS2KCoe"
Content-Disposition: inline
In-Reply-To: <20140514170238.GB15690@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hh0bd0om1WS2KCoe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 01:02:38PM -0400, Tejun Heo wrote:
> On Wed, May 14, 2014 at 04:00:34PM +0200, Peter Zijlstra wrote:
> > Does something like the below help any? I noticed those things (cpudl
> > and cpupri) had [NR_CPUS] arrays, which is always 'fun'.
> >=20
> > The below is a mostly no thought involved conversion of cpudl which
> > boots, I'll also do cpupri and then actually stare at the algorithms to
> > see if I didn't make any obvious fails.
>=20
> Yeah, should avoid large allocation on reasonably sized machines and I
> don't think 2k CPU machines suspend regularly.  Prolly good / safe
> enough for -stable port? =20

Yeah, its certainly -stable material. Esp. if this cures the immediate
problem.

> It'd be still nice to avoid allocations if
> possible during online tho given that the operation happens while mm
> is mostly crippled.

Yeah, I started looking at that but that turned out to be slightly more
difficult than I had hoped (got lost in the suspend code). Also avoiding
large order allocs is good practise regardless.

So probably the easiest way to not free/alloc the entire sched_domain
thing is just keeping it around in its entirety over suspend/resume, as
I think the promise of suspend/resume is that you return to the
status-quo.

But I'll stick it on the todo list after fixing this use-after-free
thing I've been trying to chase down.



--Hh0bd0om1WS2KCoe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc6ObAAoJEHZH4aRLwOS6eAEP/R33MGH6fKXcS4w7exigB0Qk
rG4yLgcyR7q4JtsEkAU22kS4yod5x2LmqzaSUiL9Lqc4liEgpZ08Ed1Nb5A40b9d
pLfGsBcmYfzeyygznnxJThKo+nYX9rZJfYfXjI9tAGXIhuFG1MuZzpUbOGM3JjKq
uwmbEUtD9MMFnHDnm9+AZTpJTpw7S+bZovtzkB8ZZiL6hvh6xiVee5TfnvVR1GfG
EyzjwlhLemBadvUZnEOP+EKV+KdrzMZuGoKnwULXZpM+cgJyiFEiZ/gm/BJEVCeM
Cb9Y6ywXbUqlt+YblMroXOYgc4bt7zg7KaUk2qgdIh644xAlpyfAaYC+ErdoheU0
vy1d+C+JDzZAKNzTNKj+ybFQiZhHm7SUt/E7bOMcupuBs2GgY/jEvIHwPf6zL3fE
/kbntqJS76WGpgasmbGVn4kuVCCy/pQhbQiel0CY4myBe7wOVaq0CVK5fnGCpzp5
yORNq9/JunC8VL7MqPxyLQZ6MKe7ZbtMtrzD6ELpJCe/HR4Y6EU127u86LTOSc+u
Ysvlsj4zva5yLgkxVRqeqe5rIrJcL2ZBa2V8HLneqOrrXW2q5FcbPShLV+k37pEd
pTX9aaZ/eOv+NF6zYAq1z46XLASyWTl6BEvuAdYcK9Ep5FUy71SmbAeBnSdFQtUL
LTSAxvK/63tcva0pAbMB
=NM57
-----END PGP SIGNATURE-----

--Hh0bd0om1WS2KCoe--
