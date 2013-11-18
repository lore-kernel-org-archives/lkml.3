Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab3KRXo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:44:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab3KRXox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:44:53 -0500
Date: Tue, 19 Nov 2013 10:44:38 +1100
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH/RFC] wait_for_completion_timeout() considered harmful.
Message-ID: <20131119104438.6d45828b@notabene.brown>
In-Reply-To: <20131118152746.937b2b7971d7a4bba4ef996d@linux-foundation.org>
References: <20131117080603.2a0d3b6d@notabene.brown>
	<20131118152746.937b2b7971d7a4bba4ef996d@linux-foundation.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Rsj/DHD7c=F0TuV=41=v7Rj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Rsj/DHD7c=F0TuV=41=v7Rj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Nov 2013 15:27:46 -0800 Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Sun, 17 Nov 2013 08:06:03 +1100 NeilBrown <neilb@suse.de> wrote:
>=20
> > It would be reasonable to assume that
> >=20
> >       wait_for_completion_timeout(&wm8350->auxadc_done, msecs_to_jiffie=
s(5));
> >=20
> > would wait at least 5 msecs for the auxadc_done to complete.  But it do=
es not.
> > With a HZ of 200 or less, msecs_to_jiffies(5) has value '1', and so this
> > will only wait until the next "timer tick", which could happen immediat=
ely.
> >=20
> > This can lead to incorrect results - and has done so in out-of-tree pat=
ches
> > for drivers/misc/bmp085.c which uses a very similar construct to enable=
 interrupt
> > based result collection.
> >=20
> > The documentation for several *_timeout* functions claim they will wait=
 for
> > "timeout jiffies" to have elapsed where this is not the case.  They will
> > actually wait for "timeout" jiffies to have started implying an elapsed=
 time
> > between (timeout-1) and (timeout).
> >=20
> > This patch corrects some of this documentation, and adds a collection of
> >   wait_for_completion*_msecs()
> > interfaces which wait at least the given number of milliseconds for the
> > completion (or a signal).
>=20
> Mutter.  wait_for_x(..., 5ms) should wait for a minimum of 5ms, no matter
> what.
>=20
> So I'd suggest we make that happen, rather than adding some new interface=
s?

I thought of that.  It would certainly be nice.

However what we have is=20
         XXX_timeout(...., jiffies).
And if we decided that
         XXX_timeout(...., msecs_to_jiffies(5))
would only timeout after at least 5ms, then
         schedule_timeout(1)
would have to wait at least one full jiffie, which is quite different to wh=
at
it currently does.

We have loops that have
    timeout =3D schedule_timeout(timeout)
in the middle and if we change the semantics of schedule_timeout() to round
up, those loops could wait quite a bit longer than expected.

So I think that we do need to add new interfaces just like msleep() was int=
roduced
a while back to fix all the various misuses of
    schedule_timeout(msecs_to_jiffies(XX))).

Possibly we can also discard old bad interfaces.
Maybe the *_timeout() interfaces should become *_until() where the jiffies
number isn't a count but is a value that we wait for "jiffies" to exceed.

I don't think there is a really easy solution, but thanks for pushing the
discussion along towards trying to understand one.

NeilBrown


--Sig_/Rsj/DHD7c=F0TuV=41=v7Rj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoqmZjnsnt1WYoG5AQIJ0g//QOJQ2wvezJe7pPULcoqP8RLgZoK2BmoJ
TZ/vIncxQzRr1fHHdgePWfSC0/rKFrAoDkhr2mnUn0EkR0LcgzX0NybnWLyZGprS
4fGEa/PtBIUFQQgoWAgeMZZxHpiPJgTZrSAi0vKhyBd78TWr//AiIdY5rR1GChOV
//XQxqKVD4ytfvOwaTNy8zu6faG6p2LIeT7iH7lRgjOI/bP4dOjcMdJi/DKTP5oE
KBK5dQ77kGkPxPhrOHbxTipX/++KPJYnNC7YI/7YVBVDytIRTvGZIfWbrsNumEyc
F6+HyZelHnaPzQJKLSVK11pVD+tJZOWymWk3fB3uq3k9VKSgtpDLFyYq5PDbVasW
0OmW8p/bv3QceDx77HzqaTelewhRc7QozBVWIb4y6TWvyEFCx4SQEVEFa5X+JK/j
RGgsAyug6ieaTFo/r4oov0CfqI0j2S9lWGoBp8aMYFoNh+M/4ktXclIMPWvq6pj1
t2YSWDKmAuXoDulJj8JLzEAkgW0zUXpucCX1lYM09M5hGz6zlbG6dDoe9bvEn0AR
G1R2XNnfszRHRPQq1f7evGnwU31KMPg+tVcNfkEtZ2iORL3LfBQ4JtVccJTW6PzO
hB7EDRFL3IJmfksA9TPb25Wa2emsjDl1gaCY7DBkew6Q6GUxSqAcnvv0cPFj3oh6
utddvc7v0I0=
=RFUC
-----END PGP SIGNATURE-----

--Sig_/Rsj/DHD7c=F0TuV=41=v7Rj--
