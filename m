Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaEVXgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:36:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39562 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaEVXgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:36:50 -0400
Date: Fri, 23 May 2014 00:36:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        tiwai@suse.de, perex@perex.cz, dianders@chromium.org,
        jerry.wong@maximintegrated.com
Message-ID: <20140522233628.GW12304@sirena.org.uk>
References: <1400750228-13750-1-git-send-email-tushar.behera@linaro.org>
 <1400750228-13750-2-git-send-email-tushar.behera@linaro.org>
 <537E1D0A.6020303@wwwdotorg.org>
 <20140522173403.GL12304@sirena.org.uk>
 <537E38FF.9000407@wwwdotorg.org>
 <20140522181948.GP12304@sirena.org.uk>
 <537E7937.2010408@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wwca24FQN26//Jqu"
Content-Disposition: inline
In-Reply-To: <537E7937.2010408@wwwdotorg.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: max98090: Add master clock handling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wwca24FQN26//Jqu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 04:24:55PM -0600, Stephen Warren wrote:

> My main worry is that this patch opens the door for set_sysclk() to
> perform some kind of calculation to determine the MCLK rate. Right now,
> this patch doesn't do that, but there's nothing obvious from the code
> that no CODEC is allowed to do that. After all, sysclk has a parameter
> to indicate *which* clock in the CODEC to set. Some CODEC driver author
> might write something where the machine driver tells the CODEC driver
> the desired rate of some CODEC-internal PLL, from which set_sysclk()
> calculates what it needs for MCLK, and then goes off and requests that
> value from the clock API.

I really think you're reading too much into this - the set_sysclk() API
isn't any different to the clock API here really and most of the
potential for doing really problematic stuff and defining your clocks to
mean funny things exists anyway.  Of course people could do tasteless
things but that's always going to be a risk and we also want to try to
minimise the amount of redundant code people have to write.

It should be fairly easy to spot substantial abuse since the driver
would need to call clk_set_rate() with a different rate.

> Ignoring that, I'm still not sure that the CODEC driver setting the MCLK
> rate is appropriate. If we have 1 MCLK output from an SoC, connected to
> 2 different CODECs, why wouldn't the overall machine driver call
> clk_set_rate() on that clock, and then notify the two CODEC drivers of
> that rate. Making each CODEC's set_sysclk() call clk_set_rate() on the
> same clock with the same value seems redundant, albeit it should work
> out fine since they both request the same rate.

Right, it should work fine and it's less work for the machine drivers.
The alternative is that every machine driver using a device with a
programmable input has the code to get that clock from the CODEC device
and set it in sync with telling the CODEC about it which is redundant
and makes life harder for generic drivers like simple card (which
obviously can't know the specifics of every CODEC it works with).

It's certainly a more normal thing from a device model and device tree
point of view for the CODEC to be responsible for getting the resource
and it seems natural to extend that to such basic management as setting
the rate. =20

If anything I think want to expose some or all of the CODEC clock trees
to the clock API, sometimes (rarely but not never) the CODEC PLLs and
FLLs are used to supply things outside the audio subsystem if they
happen to be going spare, it's difficult to do that at the minute since
there's no guaranteed API for being a clock provider.  At the minute
we're mostly reimplementing a custom clock API which seems like the
wrong way to be doing things.  That might go towards answering your
concerns since set_sysclk() would end up as a clock API call (or at
least a thin wrapper around one).

--Wwca24FQN26//Jqu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfon5AAoJELSic+t+oim90pEQAINzaP+0sN7QLFYXrNMRtkCb
afNPrx1Nt1kYR3r7RcHX/6DEqigEpydq7I/i6a35+nv08lJLOw2LS2IXyYMLeSm0
qazYoKfrUH5ZpdLs85ud6srorn4VBJ/U+UaKXUB6BtJzCLAysJnT4/Rkt3DP3KJZ
TJo7oE5ipj40bThwY7ACHOe9g4+ACSQjBTKBzcov9eU4hfnxZhR+8v/a2rUweV4a
6BPL2eJ8EJgzmkNEdmUBP5RdsVL0WwCw/xhxH+JyPx0l8cRifD+1XaEloPW8bM6C
EisdIdt4agUxEBCXtcne7fVpgZCBoYilE2xWGoRzRbP9Voe5nYrzcxu6evBHf5CO
++0VBc4v/xBmnDkO5lIwR6b7Tu3E8MP+C2dxd5hecmacWd/mcy6tgJxUVhR9aCP2
q6eeqlGEln/MeC24pinVZL3qllc3ABW+OzRBmS2LA1KtvC7OPa1UxVp5yAH9rEGB
UjHH9rPXMd7ePPlhWYa5fJC13/Dc/PEr1cN8KAjkinGf+6qHnXwtRQNmry3o22zK
ZGnBStJwbNttPfHBWHTDnBULSbKO+iNbhr9oBWbx0QPPQNasH5x/ffNeotgvVC9I
ZZg+M4ks3ADuQQs1g/+R3km/Ed27/c5CdVgUr3yx0OO4H4NJb+CRQ2DWm/crDO8X
p8yYWIdv4cgsDy2YSupo
=rYHp
-----END PGP SIGNATURE-----

--Wwca24FQN26//Jqu--
