Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab3FGFsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:48:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50233 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779Ab3FGFsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:48:16 -0400
Message-ID: <1370584088.4021.88.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 139/184] NLS: improve UTF8 -> UTF16 string conversion routine
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Clemens Ladisch <clemens@ladisch.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Date: Fri, 07 Jun 2013 06:48:08 +0100
In-Reply-To: <20130604172136.066346020@1wt.eu>
References: <20130604172136.066346020@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-dVHPQK07/4JULKTZA8PV"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dVHPQK07/4JULKTZA8PV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:23 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Alan Stern <stern@rowland.harvard.edu>
>=20
> commit 0720a06a7518c9d0c0125bd5d1f3b6264c55c3dd upstream.
>=20
> The utf8s_to_utf16s conversion routine needs to be improved.  Unlike
> its utf16s_to_utf8s sibling, it doesn't accept arguments specifying
> the maximum length of the output buffer or the endianness of its
> 16-bit output.
>=20
> This patch (as1501) adds the two missing arguments, and adjusts the
> only two places in the kernel where the function is called.  A
> follow-on patch will add a third caller that does utilize the new
> capabilities.
>=20
> The two conversion routines are still annoyingly inconsistent in the
> way they handle invalid byte combinations.  But that's a subject for a
> different patch.
>=20
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Clemens Ladisch <clemens@ladisch.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> [bwh: Bakckported to 2.6.32: drop Hyper-V change]

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  fs/fat/namei_vfat.c |  3 ++-
>  fs/nls/nls_base.c   | 43 +++++++++++++++++++++++++++++++++----------
>  include/linux/nls.h |  5 +++--
>  3 files changed, 38 insertions(+), 13 deletions(-)
>=20
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index 67b3df1..4251f35 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -499,7 +499,8 @@ xlate_to_uni(const unsigned char *name, int len, unsi=
gned char *outname,
>  	int charlen;
> =20
>  	if (utf8) {
> -		*outlen =3D utf8s_to_utf16s(name, len, (wchar_t *)outname);
> +		*outlen =3D utf8s_to_utf16s(name, len, UTF16_HOST_ENDIAN,
> +				(wchar_t *) outname, FAT_LFN_LEN + 2);
>  		if (*outlen < 0)
>  			return *outlen;
>  		else if (*outlen > FAT_LFN_LEN)
> diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
> index 44a88a9..0eb059e 100644
> --- a/fs/nls/nls_base.c
> +++ b/fs/nls/nls_base.c
> @@ -114,34 +114,57 @@ int utf32_to_utf8(unicode_t u, u8 *s, int maxlen)
>  }
>  EXPORT_SYMBOL(utf32_to_utf8);
> =20
> -int utf8s_to_utf16s(const u8 *s, int len, wchar_t *pwcs)
> +static inline void put_utf16(wchar_t *s, unsigned c, enum utf16_endian e=
ndian)
> +{
> +	switch (endian) {
> +	default:
> +		*s =3D (wchar_t) c;
> +		break;
> +	case UTF16_LITTLE_ENDIAN:
> +		*s =3D __cpu_to_le16(c);
> +		break;
> +	case UTF16_BIG_ENDIAN:
> +		*s =3D __cpu_to_be16(c);
> +		break;
> +	}
> +}
> +
> +int utf8s_to_utf16s(const u8 *s, int len, enum utf16_endian endian,
> +		wchar_t *pwcs, int maxlen)
>  {
>  	u16 *op;
>  	int size;
>  	unicode_t u;
> =20
>  	op =3D pwcs;
> -	while (*s && len > 0) {
> +	while (len > 0 && maxlen > 0 && *s) {
>  		if (*s & 0x80) {
>  			size =3D utf8_to_utf32(s, len, &u);
>  			if (size < 0)
>  				return -EINVAL;
> +			s +=3D size;
> +			len -=3D size;
> =20
>  			if (u >=3D PLANE_SIZE) {
> +				if (maxlen < 2)
> +					break;
>  				u -=3D PLANE_SIZE;
> -				*op++ =3D (wchar_t) (SURROGATE_PAIR |
> -						((u >> 10) & SURROGATE_BITS));
> -				*op++ =3D (wchar_t) (SURROGATE_PAIR |
> +				put_utf16(op++, SURROGATE_PAIR |
> +						((u >> 10) & SURROGATE_BITS),
> +						endian);
> +				put_utf16(op++, SURROGATE_PAIR |
>  						SURROGATE_LOW |
> -						(u & SURROGATE_BITS));
> +						(u & SURROGATE_BITS),
> +						endian);
> +				maxlen -=3D 2;
>  			} else {
> -				*op++ =3D (wchar_t) u;
> +				put_utf16(op++, u, endian);
> +				maxlen--;
>  			}
> -			s +=3D size;
> -			len -=3D size;
>  		} else {
> -			*op++ =3D *s++;
> +			put_utf16(op++, *s++, endian);
>  			len--;
> +			maxlen--;
>  		}
>  	}
>  	return op - pwcs;
> diff --git a/include/linux/nls.h b/include/linux/nls.h
> index d47beef..5dc635f 100644
> --- a/include/linux/nls.h
> +++ b/include/linux/nls.h
> @@ -43,7 +43,7 @@ enum utf16_endian {
>  	UTF16_BIG_ENDIAN
>  };
> =20
> -/* nls.c */
> +/* nls_base.c */
>  extern int register_nls(struct nls_table *);
>  extern int unregister_nls(struct nls_table *);
>  extern struct nls_table *load_nls(char *);
> @@ -52,7 +52,8 @@ extern struct nls_table *load_nls_default(void);
> =20
>  extern int utf8_to_utf32(const u8 *s, int len, unicode_t *pu);
>  extern int utf32_to_utf8(unicode_t u, u8 *s, int maxlen);
> -extern int utf8s_to_utf16s(const u8 *s, int len, wchar_t *pwcs);
> +extern int utf8s_to_utf16s(const u8 *s, int len,
> +		enum utf16_endian endian, wchar_t *pwcs, int maxlen);
>  extern int utf16s_to_utf8s(const wchar_t *pwcs, int len,
>  		enum utf16_endian endian, u8 *s, int maxlen);
> =20

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-dVHPQK07/4JULKTZA8PV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbF0GOe/yOyVhhEJAQqk3RAAq4lMi77hNkjTfi+S450L/4PWaIsrrQyF
7D7AgV1WNkaUeZU4u2y93OZBXvTehqs3BaWsq7B2BRDjUHGPZ/sBlhkfxYpVPWQB
5bFwSVshh7Uu6dq2B3/R7/6RN0V5nw5zR2yz5ZTbBHBNXNJl/ixZ6/Xx1THYYpVM
ZkUL2tY+NSMJnPZAE0NzkXdfnddenX1XpsKXgK/YKvXUcjtZSmDtNdLfUpZt1Xf4
uqO/OOkYvlU2/6+wRdFnRewqj6TKQETZOHwBnpjsvPgHu3hmBYDn3rFJuiGsfwYS
MztCo9s7KfmGCYC7c/zhdRInj05ph4pM+zmGbjNt33f02V+vI+T61azcuxCmKTUh
4A1ehxBVSLQJB76sjlGHto2rUNoR7zTeHoAGXqLu1d6iyP23/mSBwsln/2kjWvDg
P0czZ3uz5jiaEXC11p0M7wteh9DA64oE9t44Yn8ci2UIhVbg3k5TPzt/ovPoMLRd
7M/F5AuDXRWfRo7QFkY/ClOUY0aH+Y4xpxeybJxzed4yz97BjjDDqzkIOuT56Zlw
R9UH4ezvqphB3QfDppAcc3GUfaGzc2tMMqyvqtSRKkyk3eYTAMfVdvualeDJe6qZ
q5ZzpjzE9O27L4MdfGkNXYT60hGMbA44s1YkjNZPipFJililTRZiydaAXZ2TM112
1w/1Mt5cciY=
=IgzS
-----END PGP SIGNATURE-----

--=-dVHPQK07/4JULKTZA8PV--
