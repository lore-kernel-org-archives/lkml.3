Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaHMNjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:39:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:44550 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaHMNjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:39:47 -0400
Date: Wed, 13 Aug 2014 15:39:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
Message-ID: <20140813133934.GM9918@twins.programming.kicks-ass.net>
References: <20140812142539.01851e52@annuminas.surriel.com>
 <20140812191218.GA15210@redhat.com>
 <1407913190.5542.50.camel@marge.simpson.net>
 <20140813111112.GJ9918@twins.programming.kicks-ass.net>
 <53EB66F6.2050304@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zMok4GuR9rt3L1k1"
Content-Disposition: inline
In-Reply-To: <53EB66F6.2050304@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zMok4GuR9rt3L1k1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 09:24:06AM -0400, Rik van Riel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> On 08/13/2014 07:11 AM, Peter Zijlstra wrote:
> > On Wed, Aug 13, 2014 at 08:59:50AM +0200, Mike Galbraith wrote:
> >=20
> >> I was told that clock_gettime(CLOCK_PROCESS_CPUTIME_ID) has
> >> scalability issues on BIG boxen
> >=20
> >> I'm sure the real clock_gettime() using proggy that gummed up a
> >> ~1200 core box for "a while" wasn't the testcase below, which
> >> will gum it up for a long while, but looks to me like using
> >> CLOCK_PROCESS_CPUTIME_ID from LOTS of threads is a "Don't do
> >> that, it'll hurt a LOT".
> >=20
> > Yes, don't do that. Its unavoidably slow and bad.
>=20
> I don't see why that needs the tasklist_lock, when do_sys_times
> grabs a different lock.
>=20
> If the same bottleneck exists from multiple places, maybe it does
> make sense to have a seqlock for the statistics at the sighand
> level?
>=20
> I can code up a patch that does that, and throw it over the wall
> to people with big systems who hit that bottleneck on a regular
> basis...

PROCESS_CPUTIME doesn't need tasklist lock; it only takes the sighand
lock. It needs that to stabilize the thread list, you cannot give a
straight answer if threads are coming/going.

It further needs to take the rq->lock for any active task in the thread
group.

Combined its painful; and it being painful should be no surprise to
anybody seeing how its basically a 'global' property -- the more CPUs
you stick in a machine the more expensive those become.

--zMok4GuR9rt3L1k1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT62qWAAoJEHZH4aRLwOS6DYIQAJeW6Xs6fEQ4zxA7bGSyISxY
u0sx+xPXR8fFFIHFLn0c9wxpq2XMNErAsjJYSHUCDGrDLpFA7RbLUTEdqbXCackM
mb/yQoURL8HnuBgX1jI3E6HrlFVSe2pVYKQ9Ijd55JQ51bsvl6GWCIHMwebbYVZX
OO7w4rmXeR3WYvwErM9J1nLgSx/TkyDF86tJgpUvo5lI426zx2GWN2o8d0bdLKWb
JQqg/RM2tsQ39T/T3m2ErOhWK/JQ6iAH6m3qZqT+4AOU0tLCod72YgO/llMeSjK+
W38AgVgIX1gl+sLuciMZSZOGp4f9qFKjdv5ASh3WIKLk26ugevEK98n0UmAPXw5l
y9lBZcSCOFDxU+rmTBfOE+z+Fa37HWAnYpltm4pdLYTw1EJeiDX3oM9VPhX9J3+M
7qMsTDjn4UjPKN6ngO7WRIub4hMO99MDJJ6QhuJlAJcGebH1vs8in8SePYODGcmT
A+Tsltg1Rk0AW9SPQf6tTGv9QidDocVWYZ7/Goz4lAS7kaBHTG8l7NP3BMOeBptD
rPE33qqUGQQNQIFp7OLd0JEd7DFH2O+LMcfvUodIJx47Q6qBqhcvDkeSHq4jrOkA
RGA0Tany0auiExeDzj1+2wRJHoFxLM2EdcbfaeKGsR6EtfEc8E1k1YZjFx3mi8c1
OOyYdxCSpW8KGn6AzAEk
=r7Q+
-----END PGP SIGNATURE-----

--zMok4GuR9rt3L1k1--
