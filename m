Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaJ1Rjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:39:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53557 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaJ1Rj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:39:28 -0400
Date: Tue, 28 Oct 2014 17:38:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: alsa-devel@alsa-project.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20141028173853.GD18557@sirena.org.uk>
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
 <20141027193229.GE18557@sirena.org.uk>
 <CAMo8Bf+Z9V8mkiC3JOupPQmi1EJUDKrb1qcNncDbsEbhjigbww@mail.gmail.com>
 <20141028154224.GX18557@sirena.org.uk>
 <CAMo8BfLpJ0bdmaFt9+gLQ_kEjB68XdjAJUw8f8s=Owv46h_yDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uaw16JuuybUwHkzF"
Content-Disposition: inline
In-Reply-To: <CAMo8BfLpJ0bdmaFt9+gLQ_kEjB68XdjAJUw8f8s=Owv46h_yDQ@mail.gmail.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: add xtensa xtfpga I2S interface and platform
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Uaw16JuuybUwHkzF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 08:00:45PM +0300, Max Filippov wrote:
> On Tue, Oct 28, 2014 at 6:42 PM, Mark Brown <broonie@kernel.org> wrote:

> > Then this just shouldn't exist at all, adding Kconfig entries for all
> > the simple-card devices would defeat the point of having simple-card
> > which is why we don't do it for other systems.

> sound/soc/sh/Kconfig does that as well.
> Not having single config item to enable at once all relevant drivers feels
> a bit strange... But ok, I'll drop that.

This is new code, not a replacement of old code.

> > So atomics don't work?  Simple flags are one of the few cases where they
> > might cover it...  again, the fact that this isn't similar to other code
> > doing the same thing is worrying.

> tx_substream use pattern is the same as of a typical RCU variable.
> RCU wrappers combine ACCESS_ONCE and barriers that I'd otherwise
> have to write myself.

You *really* need to explain how it's supposed to work - right now it's
not at all obvious, like I say the fact that this is a rarely used idiom
is not helping.  For example when we tear down the stream we just assign
the pointer in _stop() but don't bother with a sync until the stream is
closed - why?  We also appear to be doing several different dereferences
of the pointer inside a single rcu_read_lock() for some reason which is
worrying.

> >> > I would also expect to see the data transfer and I2S bits more split
> >> > out, presumably this IP can actually be used in designs with a DMA
> >> > controller and one would expect that for practical systems this woul=
d be
> >> > the common case?

> >> I don't know of other designs that use this IP block. Can we do it when
> >> we get such users?

> > It's also about ensuring that the code is cleanly split up so that
> > someone can actually go in and add the required support later (and TBH

> Can you point me to an example of such split, so that I don't write it in
> an unusual way?

Essentially all drivers are split this way...

> > it'd be better to just add a DMA controller on the FPGA, everyone will
> > be much happier).

> Hardware people think different and it's been like that for more than 5
> years.

They appear to be the only hardware people who think this way, while we
do have some FIQ based PIO stuff in mainline all the examples I can
think of are there because people didn't work out how to drive the DMA
controller yet (and even there we're using FIQs not bashing things in
=66rom a regular interrupt).

> >> Because this callback is said to be potentially called multiple times =
per
> >> initialization. Is it not?

> > It can but but I'm not seeing any connection between that and the idea
> > of not keeping the clock enabled when the device isn't in use?

> hw_params callback can change MCLK rate, so it has to disable and
> enable the clock anyway, and since enable can fail it does not guarantee
> that the clock will be left in the same state. Or should I adjust MCLK ra=
te
> w/o disabling the clock?

So yet again: why not just enable the clock only when the device is in
use?  If it's being configured it stands to reason that the device isn't
actively in use...

> > I'm not sure I find that terribly convincing, I'd like to be able to
> > look at the code and tell that it's not going to blow up.  This again
> > comes back to the general comment about clarity - the code *looks*
> > suspicious (strange indentation of the for loop with a comment in the
> > middle of the statement itself for example).

> The level field in the control register is 4 bit wide, so the allowed ran=
ge of
> level is 0..15. FIFO size is 8192 entries, level =3D 1 corresponds to
> FIFO size / 2, level =3D 14 -- to FIFO size of 0. I guess this function
> won't get period_size of 0?

So if the IP gets changed and the code gets blown up this could well
explode then...  which doesn't seem entirely unlikely considering this
is a FPGA platform so presumably this is easy to update.  To repeat this
is about clarity and the code looking like it's probably hiding bugs as
much as if the code actually works if you really sit down and study it.

--Uaw16JuuybUwHkzF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUT9SsAAoJECTWi3JdVIfQOGsH/j4XcuOOaoBR7qBgAdNjEYm0
Ey/C2K1KIxymJool2Abr2x2XaNEL8sqHMxI+NkVLupN0uEslRKUKhsacXwyyelPc
zKE0E5TrpL4GDFEpCrAvSQJe3EI3HOM+AR3UnmUv5HVS38V5RD3MRDecti/iHOpL
SGnHkBmCL0gMVIYS6KjTJbYRS9Xwjx10C54CVC5dMRkE766BiFdV23eg7mMC10Hl
By83MOxO5S3YTqbNSP6FjXX6tZIQV3djqg6APhWtQFIFZcyjXbMmwD8LCXdiqpov
7SYh2R+QJoWyFk26zw/cWCW4qxbDOL8cbxsWGNyV0l45SXDD0YxAd3wRtwNg+jc=
=f3yD
-----END PGP SIGNATURE-----

--Uaw16JuuybUwHkzF--
