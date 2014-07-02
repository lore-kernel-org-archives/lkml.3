Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbaGBNbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:31:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:60846 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbaGBNbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:31:13 -0400
Date: Wed, 2 Jul 2014 15:31:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: David Rientjes <rientjes@google.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, perf: avoid spamming kernel log for bts buffer
 failure
Message-ID: <20140702133105.GG19379@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.02.1406301600460.26302@chino.kir.corp.google.com>
 <20140701093442.GN6758@twins.programming.kicks-ass.net>
 <CABPqkBT9zT6Qejc3hin5yLO4x8bxkZqrXTS-VNana8MhtWC0XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QWpDgw58+k1mSFBj"
Content-Disposition: inline
In-Reply-To: <CABPqkBT9zT6Qejc3hin5yLO4x8bxkZqrXTS-VNana8MhtWC0XA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QWpDgw58+k1mSFBj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 02, 2014 at 03:16:40PM +0200, Stephane Eranian wrote:
> On Tue, Jul 1, 2014 at 11:34 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, Jun 30, 2014 at 04:04:08PM -0700, David Rientjes wrote:
> >> It's unnecessary to excessively spam the kernel log anytime the BTS buffer
> >> cannot be allocated, so make this allocation __GFP_NOWARN.
> >>
> >> The user probably will want to at least find some artifact that the
> >> allocation has failed in the past, probably due to fragmentation because
> >> of its large size, when it's not allocated at bootstrap.  Thus, add a
> >> WARN_ONCE() so something is left behind for them to understand why perf
> >> commnads that require PEBS is not working properly.
> >
> > Can you elaborate a bit under which conditions this triggered? Typically
> > we should be doing fairly well allocating such buffers with GFP_KERNEL,
> > that should allow things like compaction to run and create higher order
> > pages.
> >
> I think this triggers when you have fragmented memory and you have
> perf_events active and inactive (i.e., 0 users = no nmi watchdog) frequently.
> Each first user invokes the reserve_ds() function to reserve DS, PEBS, BTS.

Right, that'd suck. I suppose we could also change that to allocate the
DS resources on first demand and never free them again.

So only allocate the PEBS buffer when we create the first PEBS event,
and idem for the BTS muck.

> The reason for BTS rather then PEBS is the size of the allocation.
> PEBS allocates one page, i.e., less likely to get a failure than BTS
> which allocates 4 pages, I think.

Sure..

> David and I discussed this. He can probably add more background
> info, if needed.

It would still be good to see why compaction etc is failing.

--QWpDgw58+k1mSFBj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtAmZAAoJEHZH4aRLwOS6yMcP/iDqAXYUt+zbcCVjHFFT74Eh
Ciow2pyh9l7K6avoXCWRMQxccrmkiSkVhfKjKUyod2tS91QINYPXVm5nwyTBfidQ
UmHI6HmK0+Vn3X7XIJUCEjniQMyesg2qJXkFOD/ezgE0J3mfIyquSj2Xo3Tjymmp
xgVEYCxiXDn/4tGdgr3citvo8SUPciuXdFiDq3W85SVp6N/2lkooc+YJEy32wNEw
mnFqriEZ3c/pF3mG1yvorio2ifVsidXDDqisiNQTLzCTKmf0SOz7W0KraZbEIsUf
Qj1Cvzn/Co48g3mxYue/HgRXhmJVXBj0Ljvwb4GNJG2tW0ezvwRkauPvoBcwmF99
IrYzPx78bOtaWeXA0enyW+o13W5wBc81J3LM2f320lXSNTStObVLWYKBD+4VdvGr
pkbIq8e15t6IO6zoAqO7YHHmt+ZnQRrGMzHHMvY6pE+noEpg0vK8PKGfWRvr4XEc
ykGzFIvid3B3HV2vICM1cRgy4LPLNx6ngw248LTCezx4L7fuKVb20wCRfS5bKwJO
cmg1E67ccWTLcM6UeRJ8D8Q4a3FiKYCCX+yk928XgMCKDL+F47r68e5YACTEErWU
jokeIFjF048HHJUkn9p5lzS5lOBPb/20ID6X618yMNLFlvqpD4KNe9T/jnBqFfbw
2mlPgQWA9mZiKUS3P3Ng
=duHH
-----END PGP SIGNATURE-----

--QWpDgw58+k1mSFBj--
