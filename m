Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbbAFMNC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:13:02 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38075 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbbAFMNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:13:00 -0500
Date: Tue, 6 Jan 2015 12:12:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20150106121225.GZ2634@sirena.org.uk>
References: <1418612879-16094-1-git-send-email-zyw@rock-chips.com>
 <1418612879-16094-3-git-send-email-zyw@rock-chips.com>
 <20141229172555.GE17800@sirena.org.uk>
 <CAD=FV=VUp2xvH28g77PTC5x7__+kiiz5VRWxwmSr7V9XV_paRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B2XwZuBUJ8PPSpsy"
Content-Disposition: inline
In-Reply-To: <CAD=FV=VUp2xvH28g77PTC5x7__+kiiz5VRWxwmSr7V9XV_paRg@mail.gmail.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/2] regulator: rk808: add dvs support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B2XwZuBUJ8PPSpsy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 02, 2015 at 10:41:13AM -0800, Doug Anderson wrote:
> On Mon, Dec 29, 2014 at 9:25 AM, Mark Brown <broonie@kernel.org> wrote:

> > So, this seems a bit odd.  What we appear to be doing here is
> > alternating between the two different voltage setting registers which is
> > all well and good but makes me wonder why we're bothering - it's a bit
> > more work than just sticking with one.  We do get...

> It's odd, but the rk808 is odd.

> Specifically if you don't use the "DVFS" pins like this then the
> hardware ignores the ramp rate that's programmed into it.  When I
> submitted (8af2522 regulator: rk808: Add function for ramp delay for
> buck1/buck2) upstream I verified my change by looking at the register
> values that were being set (ran i2cget in userspace).  I didn't
> measure the waveforms myself.  Later, Chris found that my change was
> not doing anything at all because the ramp delay has no effect if you
> are setting the voltage using an i2c write--it only has an effect if
> you're setting the voltage using DVFS pins.

> If you write the voltage directly using an i2c write the rk808 will
> ramp as fast as it possibly can, which will probably lead to an
> overshoot.  You could fix this by changing the voltage more slowly in
> software, but it seems better to use the DVFS pin if we have it...

OK, so this is all stuff that should go in at *least* the commit log and
most likely comments in the driver since right now it just looks like
it's adding complexity.  It does also sound like the regulation here is
a bit interesting, normally the ramp time control is more about limiting
inrush currents than suppressing transients.

Currrently we'd end up with code that just looks redundant.

> > ...this but unless the voltage typically ramps much faster than spec
> > it's never clear to me that we're actually winning by polling the pin
> > instead of just dead reckoning the time, it's more work for the CPU to
> > poll the GPIO than to sleep after all.

> Possibly even fewer CPU cycles: we could configure this GPIO as an
> interrupt.  Then we can look for the rising edge in hardware.  ...you
> might need to make sure that the pin actually falls and goes back up,
> though.  If you changed between two voltages that were pretty close to
> begin with I wonder if the edge could be missed.  I guess you could
> make it high-level sensitive and put the 1us delay before unmasking
> it...

Yes, if you make it interrupt driven it might be less work though then
you have to worry about interrupt and scheduling latencies.

> > We can just check to see what the two values are current set to before
> > switching and skip the register write if it's the same (making things
> > faster since we're typically avoiding an I2C or SPI transaction by doing
> > that) but that's a bit meh.  We can also try to do things like keep the
> > top voltage from the voltage ranges we're being given programmed which
> > for DVS typically ends up doing a reasonable job since governors often
> > like to jump straight to top speed when things get busy so that's one of
> > the common cases where we most want to change voltages as quickly as
> > possible.

> You're right that there could be some cool optimizations here, but
> since we really need to do a switch from A-to-B on every voltage
> change to get the ramp speed right then I don't think we can do them.

Like I say this needs to be obvious in the code, the combination of
calling this "DVS" (which is normally some sort of performance
optimisation thing for fast voltage changes) and lack of any information
on what it's supposed to achieve mean that the patch as it stands has
no clear goal or benefit.  Someone has to know not to come along and try
to do such optimizations later on if nothing else.

> Note that the MFD driver sets things up using regcache, so we
> shouldn't ever do a needless i2c transaction.

That's not the point really, the point is about doing a better job of
predicting what voltages we might want to transition to.

--B2XwZuBUJ8PPSpsy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUq9EoAAoJECTWi3JdVIfQYoMH/imGhDgh1jSY+EQn0v9uVkgB
A3i/UbSmigY6KRvdDSkumOpEdfTKqrfD+2k/fNKCY8kGpKhi4xX4nYRTVs36/2Sw
ytXYOVV1z3mrO4BpZTGee73xuPN9y3/3fN78Unvf3+Xm9Ne1Pv3jmnjYNMVFlAmA
9HIZEdnKlAR3/HtVGkReWJXIbVG/jVjCVEZJ42E/wTmB5M9UoapkKrIAIAQn/HEa
YqVn6/0XWE4QumrQVc0OgJkIadzfbvGT49Kst7jdedhwzxoH0rqhSZwnmFoUNoxF
TQ0eMUQMBokJrGY6oaPaZvy9T4ZsB7YXiDQTm7Imnhb4cBTL6ijYIMy4SvtGZ/Y=
=Tm1h
-----END PGP SIGNATURE-----

--B2XwZuBUJ8PPSpsy--
