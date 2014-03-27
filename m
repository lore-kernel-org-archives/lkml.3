Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbaC0N0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 09:26:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51839 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbaC0N0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 09:26:45 -0400
Date: Thu, 27 Mar 2014 13:26:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Li.Xiubo@freescale.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        timur@tabi.org, David.Laight@ACULAB.COM
Message-ID: <20140327132626.GN30768@sirena.org.uk>
References: <1395918419-20739-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U6leaJ20qZQc29iB"
Content-Disposition: inline
In-Reply-To: <1395918419-20739-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.45.252.252
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: fsl_sai: Add isr to deal with error flag
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U6leaJ20qZQc29iB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 27, 2014 at 07:06:59PM +0800, Nicolin Chen wrote:
> It's quite cricial to clear error flags because SAI might hang if getting
> FIFO underrun during playback (I haven't confirmed the same issue on Rx
> overflow though).
>=20
> So this patch enables those irq and adds isr() to clear the flags so as to
> keep playback entirely safe.

So, I've applied this since we're (hopefully!) very near the merge
window opening and it seems like it should be an improvement overall.
However a few things below:

> +	/* Only handle those what we enabled */
> +	mask =3D (FSL_SAI_FLAGS >> FSL_SAI_CSR_xIE_SHIFT) << FSL_SAI_CSR_xF_SHI=
FT;

The shifting here could use a comment.

> +	regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
> +			   FSL_SAI_CSR_xF_W_MASK | FSL_SAI_CSR_FR, xcsr);

Using update_bits() is going to do an extra read, better to do this as:

	if (xcsr)
		regmap_write(sai->regmap, FSL_SAI_RCSR, xcsr);

otherwise we might be ignoring any of the bits that are actually clear
on read (it seems like there are some?).

> +	return IRQ_HANDLED;

I'd expect to see IRQ_NONE if we didn't actually see an interrupt
source.

--U6leaJ20qZQc29iB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTNCb/AAoJELSic+t+oim94iIQAII157fGozbgumNEgl6Gz7fz
M1dRUCoWrUz630B1uCMuRLgdw2TW9fAdLrN7x+LXp2H+VxfufymllYT7m49P/HxT
arHZ1/Wo3FO5VJJL1FeNfTnRn/9xk4QSQ0WOOhKDWT463tZKkFOTlEADFBmYMu/J
vr2xPllFMLQIZENW3SLBn+ABc40zqFlMNRobnUuUpRXdtQPh8bwjIw8KKTnVPJpu
1rPPH/Tts0m+WSwB8584X5eYtzt+C++HbsUjsFQtqVYGJE0Jh3rmLlGlcUwsKvDc
4jqSxTDY0lByDF7tEcPimB+dveKm7LNxaAD36LGgOOhrxKpDkYkkl9YXTNLwPgSs
TfmAXN0d1UnAIw4v01YehS+E1064amfMILmi46O3sYbxrBcqv9C1RJZCzCOwjJ6t
KNEJVUVuEYyfQpK0gMUd5T5iU5a63p1IkSargGiuLDMw7cxe7UBsVBOOloyun/FO
jMCnVL42UZUQFZ7iNsmZuV0CuQxWi5DqCl8pNiYZZFoSinMCthYUB2Ll4wMlVLh2
6gx4ve0qG8xANJKDMBuHaNmRCL0bkhlqyqM4+rrIeTM9huwJ7jOuZbbiIHa2Th4G
ANBvvlIgOSDt3qh2bkA5CxpqZ3VfiZtVY2M0trBvfVyymRVRipgg/qWYh8Zsrfjh
oREufYGLQzoUPA/+XBSK
=TIA3
-----END PGP SIGNATURE-----

--U6leaJ20qZQc29iB--
