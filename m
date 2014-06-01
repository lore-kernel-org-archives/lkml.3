Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbaFALiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 07:38:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49741 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899AbaFALix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 07:38:53 -0400
Date: Sun, 1 Jun 2014 12:38:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Message-ID: <20140601113834.GG5099@sirena.org.uk>
References: <1400691239-21987-1-git-send-email-l.stach@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CDSQlumANh/CoDwR"
Content-Disposition: inline
In-Reply-To: <1400691239-21987-1-git-send-email-l.stach@pengutronix.de>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: allow non-exact matches in
 regulator_set_voltage_time()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CDSQlumANh/CoDwR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2014 at 06:53:59PM +0200, Lucas Stach wrote:
> Currently this function only provides a valid output if both
> old_uV and new_uV are exact voltages that can be provided by the
> regulator.
> This is almost impossible to achive as the consumer has
> no way to know the exact voltages provided by the regulator.

Yes it does - this is what regulator_list_voltage() is there for.
Drivers can enumerate all the voltages supported by a regulator.

> This breaks the current cpufreq users of this function, as they
> stick in the raw voltages retrieved from their operating points,
> which may or may not match one of the regulator voltages.

At least the code in cpufreq-cpu0 looks a bit confused here.  The use of
min_uV and max_uV is a bit unclear but probably correct however for some
reason it appears that what it's doing is stepping through each single
step transition between two adjacent frequencies, getting the transition
latency for that and then summing those.  Given that it needs a single
number I'd expect it to instead be getting the minimum and maximum
voltages and then working out the highest latency for transitioning
between those, what it's doing at the minute will be overestimating any
fixed component of transition latency (from the time taken to issue
commands to the device for example).

Incidentally the clock API ought to have a similar thing - at the minute
the driver just has a fixed number stuffed into it from DT but it really
ought to be able to ask the clock API in the same way as it asks the
regulator API.

> To make this function behave as expected employ the same logic
> as used when calling set_voltage() and round the voltages to
> the closest matching voltage supported by the regulator.

That's not what the set_voltage() code does - what it does is find the
lowest voltage in the requested range. =20

Your code won't actually do quite what cpufreq-cpu0 is doing since it
uses set_voltage_tol() which will ask for a range around the voltage
it's trying to set so the query in cpufreq-cpu0 will come out as
something different to what the driver actually ends up doing when it
does transitions.  We should probably add functions to query what the
actual voltage selected for a given set_voltage() and set_voltage_tol()
will be then let that be fed into requesting the transition times.

--CDSQlumANh/CoDwR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTixC3AAoJELSic+t+oim9nIsP/0PlM8N4UlwH1MSoCJ+1BDfn
YQv4SEJaPcenz7AcZLx3gPxn9eEwM9IVm3Rtt4rm5Los1UN3mpQHUsl6TSFKvNnL
mYXbSYgvAOTMFq829oG2JJQLDauXcAhRDw6+k8o7cwKfsxkAJKfbjarzfucScedC
X7XdNY7fmjLn1bATXc1rqzSLvgMyxEOdKngvKHxKaUgTvEpdFu74Olw95Dy2fF5b
yTAPNWyMfAVm+BgE9wAlsRLOJlF3mashD224XTAPMij1MGuz6cS3AfV53bvFuM1A
yJ5VI8W0vCJVHqAWQSGaj2/JWn3wOxGS4Hx0BhlZCnkMzSRwR2lRqeRcRz6Z6WCm
vAw68yXdHB67xl62dcyj7ZtNZONp2dzp9us0xpFbl3lfCJDti0I+FBDO8OnRV4Y/
K+3pwNnueLIak4dVgPXFDw8B3uX3PtdLoKlgMeo+Bdbd1pVwb6A9l+QAbtKdJy0O
dybR5RUR5jnsv7Z+3RceqAZXXJyDny2T8za7JN77r/9At6wessdnzAmpGYLvuN5R
pC/k9yfDG+xwA7iELi+fEgwPHi64ZzEgwnIVqc9jXLKY3lnKa0m7AmamKuymsxMc
4k/IX8k40TbiNEOpnj51+pQfZaU989Ii+mAArNBQffZcZibQyDp6IpMytBgz+Bzf
rfCH2b8D/LqjviemQoE7
=Z9Ha
-----END PGP SIGNATURE-----

--CDSQlumANh/CoDwR--
