Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaBJMIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:08:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39922 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaBJMIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:08:20 -0500
Date: Mon, 10 Feb 2014 12:08:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, dmitry.torokhov@gmail.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140210120803.GS1757@sirena.org.uk>
References: <20140210110536.GB6856@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xe2geHXJg22At20M"
Content-Disposition: inline
In-Reply-To: <20140210110536.GB6856@opensource.wolfsonmicro.com>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: dapm: Add locking to snd_soc_dapm_xxxx_pin
 functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xe2geHXJg22At20M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2014 at 11:05:36AM +0000, Charles Keepax wrote:
> snd_soc_dapm_disable_pin, snd_soc_dapm_enable_pin and
> snd_soc_dapm_force_enable_pin all require the dapm_mutex to be held when
> they are called as they edit the dirty list. There are 385 usages of
> these functions and only 7 hold the lock whilst calling.
>=20
> This patch moves the locking into snd_soc_dapm_set_pin and fixes up the
> places where the lock was held on the caller side. This saves on fixing
> up all the current users and also is much more consistant with the rest
> of the DAPM API which all handles the locking internally.

Unfortunately the fix needs to be in the callers to some extent - there
are situations where you want to do atomic updates of multiple pins so
that we don't end up bouncing the power up and down too much, we need
the unlocked version for things that care.  This means we need to at
least preserve an unlocked version and translate those callers that
might care over to it (not sure if any of them are in mainline).

It should also be safe to call the functions without explicit locking
during init since we won't run DAPM until we've finished init - it is
effectively locked even if we don't actually hold the mutex.  There
shouldn't be a race with marking the widget dirty since every widget
should start out dirty but I'd have to verify that one.  This will
account for a very large proportion of the callers so perhaps it's less
of an issue to add the locking to them than you had thought.

--xe2geHXJg22At20M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+MEgAAoJELSic+t+oim97PAQAI9bbI24cArteSwsBd2P3IxC
/lj916LZlei15VVwAgjwpSJLAXsPumDc9K222qQ61oVbliJbKhM87uvazKNpSEj7
fwt4jVZPaClKyS788kGNrsJeEOeKbzKI0hvR3SnU8Mn00zppll14SY7iR3KHp8zl
DZsLnhWR+rrbKN7TT3ePhoxzgctJEL3wlOeO5c2LYZT+KjkoWDrrYMjK6dN2hTHP
9WMYpPr1u1pE6nD2TQ6lOi4Got/U45gPlGSA4zS97cplCAxU33waKqVEh8Bgkk8L
pU3llqGERg/6Gk85rTg7r4CWHpaXi3efNOCChtmy/HYPGv3fSIvv8kPykJSrRZCk
aNVxvh3RuTcP1aCwMtV31wz1fZSOzeXcK04EI8pfwJGe2cqE3Q65WTIWW4JBL99l
XEdYlW7sBxw7GuSmWH0JvteIiA48ES5Qwz/dvuoLDEDlZyY5FZrb5nCQbCHAW6Xi
RurYa1cX72Qd0PNiVuwocRLcpnnvWb4mYc4zxjpovqyrfO1q269BN3oyjtNXTdms
xVF8eee0ECRfjJLujF7Y2xzWVeHckiD8knBwpRjwEkCjR0RwbMq9M9MNDPfhFEl5
lGR8+oBsBQMnuCcUXNhzM31BNc/G7u4kwA0tzl0DjmPvRy96Dm0vY2qkQ+rcmTMb
pdtHXke2Y4E9zB65Kx/G
=eUOK
-----END PGP SIGNATURE-----

--xe2geHXJg22At20M--
