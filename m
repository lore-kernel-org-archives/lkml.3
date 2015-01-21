Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbbAUTjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:39:20 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35545 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbbAUTjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:39:12 -0500
Date: Wed, 21 Jan 2015 20:39:09 +0100
From: Levente Kurusa <levex@linux.com>
To: Anshul Garg <aksgarg1989@gmail.com>
Cc: akpm@linux-foundation.org, felipe.contreras@gmail.com,
        linux-kernel@vger.kernel.org, anshul.g@samsung.com
Subject: Re: [PATCH] lib/kstrtox.c break if overflow is detected
Message-ID: <20150121193909.GA15481@linux.com>
References: <aksgarg1989@gmail.com>
 <1421868386-77010-1-git-send-email-aksgarg1989@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <1421868386-77010-1-git-send-email-aksgarg1989@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 21, 2015 at 11:26:26AM -0800, Anshul Garg wrote:
> From: Anshul Garg <aksgarg1989@gmail.com>
>=20
> 1. While converting string representation to integer
> break the loop if overflow is detected.
> 2. Clean kstrtoll function
>=20
> Signed-off-by: Anshul Garg <aksgarg1989@gmail.com>
> ---
>  lib/kstrtox.c |   28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
>=20
> diff --git a/lib/kstrtox.c b/lib/kstrtox.c
> index ec8da78..8cbe5ca 100644
> --- a/lib/kstrtox.c
> +++ b/lib/kstrtox.c
> @@ -70,8 +70,10 @@ unsigned int _parse_integer(const char *s, unsigned in=
t base, unsigned long long
>  		 * it in the max base we support (16)
>  		 */
>  		if (unlikely(res & (~0ull << 60))) {
> -			if (res > div_u64(ULLONG_MAX - val, base))
> +			if (res > div_u64(ULLONG_MAX - val, base)) {
>  				overflow =3D 1;
> +				break;
> +			}
>  		}
>  		res =3D res * base + val;
>  		rv++;
> @@ -146,23 +148,19 @@ EXPORT_SYMBOL(kstrtoull);
>  int kstrtoll(const char *s, unsigned int base, long long *res)
>  {
>  	unsigned long long tmp;
> -	int rv;
> +	int rv, sign =3D 1;
> =20
>  	if (s[0] =3D=3D '-') {
> -		rv =3D _kstrtoull(s + 1, base, &tmp);
> -		if (rv < 0)
> -			return rv;
> -		if ((long long)(-tmp) >=3D 0)
> -			return -ERANGE;
> -		*res =3D -tmp;
> -	} else {
> -		rv =3D kstrtoull(s, base, &tmp);
> -		if (rv < 0)
> -			return rv;
> -		if ((long long)tmp < 0)
> -			return -ERANGE;
> -		*res =3D tmp;
> +		sign =3D -1;
> +		s++;
>  	}
> +
> +	rv =3D kstrtoull(s, base, &tmp);
> +	if (rv < 0)
> +		return rv;
> +	if ((long long)tmp < 0)
> +		return -ERANGE;
> +	*res =3D sign * tmp;
>  	return 0;
>  }
>  EXPORT_SYMBOL(kstrtoll);

Looks correct to me, so:

Reviewed-by: Levente Kurusa <levex@linux.com>

But I believe the two hunks are completely unrelated to
eachother and hence should split into a patch series.

Could you please do that and resend? Or if Andrew is OK
with picking it up as is, then it's fine.

Thanks,
    Levente.

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJUwABcAAoJELBqK2lO9dZB1jcH/A9xU/AJRq1Doc+yfALgJcVH
QlCOXp1Eth/vwOLHyjcRABOVxmyX+VgkTX1d+ZyqAdJmZbw4fue1x/C5i0dmWG0y
bPN5a2vsQOQ573MFco47ZG1Rz0yy8IorJaUZjZn74CSNdco6azC4hITEpurx/4BR
8w0JtrVyIK66oC5tUkXs/XmcJKZR0918WU1CfOybHNuhXr3abqv77I7rKk5eF5Cn
yuB2cbgekT1yF/XaEsXi9c04XmqIIqHw6y0JJYqUlEaWuPkQuRBiPhpunHNhidUn
TxT9cgJ0vDLxiIxOXt84kiWdqfK2IRLKaGZRCmrLsYBpyuWDnkyBY+hWCu638HA=
=fxCw
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
