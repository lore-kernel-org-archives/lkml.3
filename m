Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbaJ1VgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:36:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53914 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbaJ1VfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:35:12 -0400
Date: Tue, 28 Oct 2014 21:34:26 +0000
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
Message-ID: <20141028213426.GE18557@sirena.org.uk>
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
 <20141027193229.GE18557@sirena.org.uk>
 <CAMo8Bf+Z9V8mkiC3JOupPQmi1EJUDKrb1qcNncDbsEbhjigbww@mail.gmail.com>
 <20141028154224.GX18557@sirena.org.uk>
 <CAMo8BfLpJ0bdmaFt9+gLQ_kEjB68XdjAJUw8f8s=Owv46h_yDQ@mail.gmail.com>
 <20141028173853.GD18557@sirena.org.uk>
 <CAMo8BfL+vW7BjC1bQPNjhuBMTcRTkf8_DDS3NO2HmBUnfHYAFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o1Pxsi7EGdPPGBHz"
Content-Disposition: inline
In-Reply-To: <CAMo8BfL+vW7BjC1bQPNjhuBMTcRTkf8_DDS3NO2HmBUnfHYAFQ@mail.gmail.com>
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


--o1Pxsi7EGdPPGBHz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 28, 2014 at 09:11:34PM +0300, Max Filippov wrote:
> On Tue, Oct 28, 2014 at 8:38 PM, Mark Brown <broonie@kernel.org> wrote:

> > You *really* need to explain how it's supposed to work - right now it's
> > not at all obvious, like I say the fact that this is a rarely used idiom
> > is not helping.  For example when we tear down the stream we just assign
> > the pointer in _stop() but don't bother with a sync until the stream is
> > closed - why?

> Because we can't wait in stop and syncing is not time critical, we can
> do it any time before the stream becomes invalid.

To be clear: the important part is that someone reading the code can
understand what's going on.

> >> > it'd be better to just add a DMA controller on the FPGA, everyone will
> >> > be much happier).

> >> Hardware people think different and it's been like that for more than 5
> >> years.

> > They appear to be the only hardware people who think this way, while we

> The whole audio subsystem on xtfpga boards is there for, I think, a single
> purpose: for the demonstration of CPU audio processing capabilities.
> That's why it's that simple.

This means that the demos include cycles spent taking interrupts and
stuffing data into the FIFO (with associated cache impacts) instead of
signal processing which isn't usually helpful for benchmarks.

> >> hw_params callback can change MCLK rate, so it has to disable and
> >> enable the clock anyway, and since enable can fail it does not guarantee
> >> that the clock will be left in the same state. Or should I adjust MCLK rate
> >> w/o disabling the clock?

> > So yet again: why not just enable the clock only when the device is in
> > use?  If it's being configured it stands to reason that the device isn't
> > actively in use...

> Mark, I don't get it, sorry ): My clock synthesizer is I2C controlled, so
> I can't prepare/unprepare it in the trigger callback. When should I do it?

Runtime PM is the normal way of doing it.

> >> The level field in the control register is 4 bit wide, so the allowed range of
> >> level is 0..15. FIFO size is 8192 entries, level = 1 corresponds to
> >> FIFO size / 2, level = 14 -- to FIFO size of 0. I guess this function
> >> won't get period_size of 0?

> > So if the IP gets changed and the code gets blown up this could well
> > explode then...  which doesn't seem entirely unlikely considering this
> > is a FPGA platform so presumably this is easy to update.  To repeat this
> > is about clarity and the code looking like it's probably hiding bugs as
> > much as if the code actually works if you really sit down and study it.

> The calculation does not depend on the actual hardware, but on the
> constant definitions in the same file. They need to be updated if the
> hardware changes. I'll try to rewrite it in a cleaner way.

Right, my point is that if someone changes the hardware they'll just
update the constants and then things will break.

--o1Pxsi7EGdPPGBHz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUAvhAAoJECTWi3JdVIfQx+IH+wbCe8/ralW+77h3qoNIpCyO
eN0Bsqx34r78LcAIHbStdiadMMM1uQk83ob3Me50rOZ1apEEOWCV5q8HzPeazPVQ
LdjfJlf2ptzmtmWzesITcEZP7o8YPc+uw4Ba/o6nu5ilKjV0yqI622bYCvQBXnuO
FxdE0v/RL1wI7GcdE5pjalaiZMBa2FeP2qXqcExKdJNzB2hGHogG7ZyTed4f+cfr
oySx1mZc5yMLumcGRYHKCfrIW9FvE4DZ9OIxuFIBvEwm9snEjdCQS8UR0bKoxaep
RzErdFYeejkdbmmP7tR8Jcgx9+Us6g3DK3LhkZOW2goPFgNt4i7wuZJikBktgQY=
=bAYO
-----END PGP SIGNATURE-----

--o1Pxsi7EGdPPGBHz--
