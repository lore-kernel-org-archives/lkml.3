Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaJ1Pm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:42:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53366 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbaJ1Pmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:42:55 -0400
Date: Tue, 28 Oct 2014 15:42:24 +0000
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
Message-ID: <20141028154224.GX18557@sirena.org.uk>
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
 <20141027193229.GE18557@sirena.org.uk>
 <CAMo8Bf+Z9V8mkiC3JOupPQmi1EJUDKrb1qcNncDbsEbhjigbww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rze2H98aPGdtvpzG"
Content-Disposition: inline
In-Reply-To: <CAMo8Bf+Z9V8mkiC3JOupPQmi1EJUDKrb1qcNncDbsEbhjigbww@mail.gmail.com>
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


--Rze2H98aPGdtvpzG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 27, 2014 at 11:38:53PM +0300, Max Filippov wrote:
> On Mon, Oct 27, 2014 at 10:32 PM, Mark Brown <broonie@kernel.org> wrote:
> > On Mon, Oct 27, 2014 at 10:07:05PM +0300, Max Filippov wrote:

> >> +config SND_SOC_XTENSA_XTFPGA
> >> +     tristate "SoC Audio for xtensa xtfpga"
> >> +     depends on XTENSA_PLATFORM_XTFPGA
> >> +     select SND_SOC_XTFPGA_I2S
> >> +     select SND_SOC_TLV320AIC23_SPI
> >> +     select SND_SIMPLE_CARD

> > I've only got this far in the file and have to leave now so I'll look
> > properly at the actual code later but the above shouldn't have the CODEC
> > or card driver selected, if the I2S driver is well written it should be
> > usable independently of either.

> The above entry is for the whole sound subsystem of that SoC.
> An entry for I2S driver is above it.

Then this just shouldn't exist at all, adding Kconfig entries for all
the simple-card devices would defeat the point of having simple-card
which is why we don't do it for other systems.

> > Some documentation explaining what your RCU usage is all about would
> > also be good...  I'm not clear why it's being used, none of the FIQ
> > drivers do this and I can't entirely figure out what we're defending
> > against other than the tasklet which we should be stopping anyway and
> > why what we're doing is safe.

> Ok, I'll document it. I'm synchronizing trigger callback with both interrupt
> handler and the tasklet. All that they need to know is whether we're playing
> a stream or not, so I protect the stream pointer with RCU. A spinlock for
> protection of a single pointer seems too big for me.

So atomics don't work?  Simple flags are one of the few cases where they
might cover it...  again, the fact that this isn't similar to other code
doing the same thing is worrying.

> > I would also expect to see the data transfer and I2S bits more split
> > out, presumably this IP can actually be used in designs with a DMA
> > controller and one would expect that for practical systems this would be
> > the common case?

> I don't know of other designs that use this IP block. Can we do it when
> we get such users?

It's also about ensuring that the code is cleanly split up so that
someone can actually go in and add the required support later (and TBH
it'd be better to just add a DMA controller on the FPGA, everyone will
be much happier).

> >> +     if (int_status & XTFPGA_I2S_INT_UNDERRUN) {
> >> +             i2s->tx_fifo_sz = 0;
> >> +             regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
> >> +                                XTFPGA_I2S_CONFIG_INT_ENABLE |
> >> +                                XTFPGA_I2S_CONFIG_TX_ENABLE, 0);
> >> +     } else {
> >> +             i2s->tx_fifo_sz = i2s->tx_fifo_low;
> >> +             regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
> >> +                                XTFPGA_I2S_CONFIG_INT_ENABLE, 0);
> >> +     }

> > We're trying to implement a NAPI style thing here?

> No, there's no way to retrieve the exact FIFO level from the hardware,
> there's no such register. But there are two interrupt reasons: one
> when the FIFO is below preset level and another when FIFO is empty.
> So this code tracks the FIFO level according to the interrupt reason.

...and then it appears to try to implement something like NAPI?

> >> +     switch (params_format(params)) {
> >> +     case SNDRV_PCM_FORMAT_S16_LE:
> >> +     case SNDRV_PCM_FORMAT_S32_LE:
> >> +             break;

> > This looks buggy, we're accepting two different formats but not storing
> > anything or telling the hardware - especially concerning given that this
> > is a master only driver.

> xtfpga_i2s_push_tx does the right thing based on runtime->sample_bits
> value.

So add a comment then.  The thing I was saying about the data push code
being hard to understand apply generally.

> >> +     err = clk_prepare_enable(i2s->clk);
> >> +     if (err < 0)
> >> +             return err;
> >> +     i2s->clk_enabled = true;

> > This stuff with the clock seems complicated, why not just leave it
> > disabled when not in use and take advantage of the reference counting
> > the core already has?

> Because this callback is said to be potentially called multiple times per
> initialization. Is it not?

It can but but I'm not seeing any connection between that and the idea
of not keeping the clock enabled when the device isn't in use?

> >> +     i2s->tx_fifo_low = XTFPGA_I2S_FIFO_SIZE / 2;
> >> +     for (level = 1;
> >> +          /* period_size * 2: FIFO always gets 2 samples per frame */
> >> +          i2s->tx_fifo_low / 2 >= period_size * 2;
> >> +          ++level)
> >> +             i2s->tx_fifo_low /= 2;

> > This can't come out with a bad value?

> I've tested it in the range of frequencies that we support -- works well.

I'm not sure I find that terribly convincing, I'd like to be able to
look at the code and tell that it's not going to blow up.  This again
comes back to the general comment about clarity - the code *looks*
suspicious (strange indentation of the for loop with a comment in the
middle of the statement itself for example).

--Rze2H98aPGdtvpzG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUT7lgAAoJECTWi3JdVIfQz0cH/RWuK3aV5pX2A5pfFdKhRxKG
zGkqdW/Sk9OegO/906zUd1Ig+2k2IHic2xHuAMxpFpEysWLriqu+Py3Rh2H5uSML
svnOJU+P2mjKGjsuusZCt+dkXTnROdoUin1avQt17H8KJhHGx/h17x/OckY/QIYw
TT4lMpnDzsh8edaYYDJyRgjUQ2We23vGYiD3YM1vojdKhhT8uNxwV+hYBV1Nv8Hc
T1yE1hR7u7XXTNEwa8wi0qUGReVxTHA69JeePlEu6HNBis5C+g7q2vYnO44MuXqr
5ds23fL8iY1+4/U1wR83nyGJ6QKb2LwFmT0QS/CueifguHJ2kDYIIcf4QumEtB4=
=49rK
-----END PGP SIGNATURE-----

--Rze2H98aPGdtvpzG--
