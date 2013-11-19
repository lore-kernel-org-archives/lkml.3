Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab3KSI7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:59:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab3KSI7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:59:08 -0500
Date: Tue, 19 Nov 2013 19:58:51 +1100
From: NeilBrown <neilb@suse.de>
To: Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
        Dean Nelson <dcn@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH/RFC] wait_for_completion_timeout() considered harmful.
Message-ID: <20131119195851.26bee8e6@notabene.brown>
In-Reply-To: <20131119082548.GD10022@twins.programming.kicks-ass.net>
References: <20131117080603.2a0d3b6d@notabene.brown>
	<20131118152746.937b2b7971d7a4bba4ef996d@linux-foundation.org>
	<20131119104438.6d45828b@notabene.brown>
	<20131119082548.GD10022@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dS17FHGmyp08E=snPSsJ9bB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dS17FHGmyp08E=snPSsJ9bB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Nov 2013 09:25:48 +0100 Peter Zijlstra <peterz@infradead.org>
wrote:

> On Tue, Nov 19, 2013 at 10:44:38AM +1100, NeilBrown wrote:
> > We have loops that have
> >     timeout =3D schedule_timeout(timeout)
> > in the middle and if we change the semantics of schedule_timeout() to r=
ound
> > up, those loops could wait quite a bit longer than expected.
>=20
> Depends on what you expect; most of these functions have documentation
> that says they will sleep at least timeout amount of time.
>=20
> schedule_timeout()'s version looks like:
>=20
>  * Make the current task sleep until @timeout jiffies have
>  * elapsed.
>=20
> Clearly it doesn't do that currently, so adding 1 will actually make it
> do what it says on the tin.

Hmm.. maybe you are right, and I now see that my argument about loops isn't
nearly as convincing as it seemed at the time.

However there is still the risk that someone wrote code depending on the
current behaviour rather than the current documentation.  msleep() is one
such example (it has a "+1") but that is easily found and fixed.

I went hunting for code that uses a timeout of '1' which would be affected
the most (I found no use cases for '0').  Two interesting examples:

drivers/video/via/via-core.c:=20

	/*
	 * Now we just wait until the interrupt handler says
	 * we're done.  Except that, actually, we need to wait a little
	 * longer: the interrupts seem to jump the gun a little and we
	 * get corrupted frames sometimes.
	 */
	wait_for_completion_timeout(&viafb_dma_completion, 1);
	msleep(1);

Maybe the 'msleep(1)' was only needed because of this 'bug' - Jon might kno=
w.
In that case the comment and  msleep could get removed.

drivers/misc/sgi-xp/xpc_channel.c:

/*
 * Wait for a message entry to become available for the specified channel,
 * but don't wait any longer than 1 jiffy.
 */

.....
	atomic_inc(&ch->n_on_msg_allocate_wq);
	ret =3D interruptible_sleep_on_timeout(&ch->msg_allocate_wq, 1);
	atomic_dec(&ch->n_on_msg_allocate_wq);

If interruptible_sleep_on_timeout were affected by the proposed change, then
the code would no longer match the comment.  That code is five years old ...
I wonder Dean remembers if it is important ... or is even still at SGI.

Also
     git grep '_timeout[_a-z]*(.*msecs_to_jiffies(1)'

finds 10 matches which would be significantly affected.  I can't easily say
if it would be for the better or not.

Another random piece of code that maybe could get simplified:
drivers/iio/light/tsl2563.c:
	/*
	 * TODO: Make sure that we wait at least required delay but why we
	 * have to extend it one tick more?
	 */
	schedule_timeout_interruptible(msecs_to_jiffies(delay) + 2);


NeilBrown

--Sig_/dS17FHGmyp08E=snPSsJ9bB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUosoSznsnt1WYoG5AQJ9+hAAteNqzhdOPsbMVqd4F4abDjnH2KQ3yygq
bDa8X2z51oAdd85FL/z5euDHRpe0c6trTy+UZKihkieLC05M1ZEzhvnoziyFrq2D
yTUqGcMPP9L9owqEp/tkrQrfsM8xI5X82FEtpSV48B9vp4P+uLO1EzR+/nM1ceV8
ZZkVA/AG28HjGwxvfY7c10oDqLpQPdY0Z0FZ+QGpuNS2JWyu9tU4u9V3k5MFwVV0
IWgke5yGc2gD13F5Ccsd+YVJC4VnWRmlZgsrx/cGI16WqBQxsM4vpXG1gWOWWIGZ
Lewo5bIRA9zyweJJqWLZtnJhH12LYyXJifTgrkUXYFP9Py9rrSITDNffbe78LmYW
4v/CxiKAH+YKEaEDM0S/rJkpCOjQ1HaRVD4d6CvqtXV//zRELbIqDIbEWPrLRedC
E3zCQYxODC8K5HoAGKeIXGOV/bE27EJ/kGeaZ9BwDlyI374Nz7mtNfF5y/Pw9++e
7HWC39S3ELMiSM35zxrh3ZO1jchxTdeNJIawpTOyyuaJG1zwwR9KzGkzto5dldJ+
fM1itpe2JNkkUer7iHsg1qgVLjfbXIKTJ4DJBFo8f0p9iBwTsSvqRHi2GaFdXHh/
vx16yqJp+MJWzg1BVnJjtaSeqgDqDNNGWzpz2gzFOqwmuwdfmOiscRtRB+HAwJ53
IwlyiHD8bG4=
=f1I8
-----END PGP SIGNATURE-----

--Sig_/dS17FHGmyp08E=snPSsJ9bB--
