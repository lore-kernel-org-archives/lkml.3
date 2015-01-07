Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbbAGJzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:55:11 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:46771 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751147AbbAGJzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:55:08 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Wed, 07 Jan 2015 09:55:06 +0000
Message-ID: <54AD0278.1040909@imgtec.com>
Date: Wed, 7 Jan 2015 09:55:04 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux-metag@vger.kernel.org>
Subject: Re: [PATCH v2 20/40] metag: fix put_user sparse errors
References: <1420558883-10131-1-git-send-email-mst@redhat.com> <1420558883-10131-21-git-send-email-mst@redhat.com>
In-Reply-To: <1420558883-10131-21-git-send-email-mst@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="X7dVsXX01wr6Mfoij5v0F1Sh5JLoQXdBF"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: da4c5968
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--X7dVsXX01wr6Mfoij5v0F1Sh5JLoQXdBF
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/01/15 15:44, Michael S. Tsirkin wrote:
> virtio wants to write bitwise types to userspace using put_user.
> At the moment this triggers sparse errors, since the value is passed
> through an integer.
>=20
> For example:
>=20
> 	__le32 __user *p;
> 	__le32 x;
> 	put_user(x, p);
>=20
> is safe, but currently triggers a sparse warning.
>=20
> Fix that up using __force.
>=20
> This also fixes warnings due to writing a pointer out to
> userland.
>=20
> Note: this does not suppress any useful sparse checks since callers
> do a cast (__typeof__(*(ptr))) (x) which in turn forces all the
> necessary type checks.
>=20
> Suggested-by: James Hogan <james.hogan@imgtec.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/metag/include/asm/uaccess.h | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/metag/include/asm/uaccess.h b/arch/metag/include/asm/=
uaccess.h
> index c314b45..9627c19 100644
> --- a/arch/metag/include/asm/uaccess.h
> +++ b/arch/metag/include/asm/uaccess.h
> @@ -107,18 +107,23 @@ extern long __put_user_asm_w(unsigned int x, void=
 __user *addr);
>  extern long __put_user_asm_d(unsigned int x, void __user *addr);
>  extern long __put_user_asm_l(unsigned long long x, void __user *addr);=

> =20
> -#define __put_user_size(x, ptr, size, retval)			\
> -do {                                                            \
> -	retval =3D 0;                                             \
> -	switch (size) {                                         \
> +#define __put_user_size(x, ptr, size, retval)				\
> +do {                                                            	\
> +	retval =3D 0;                                             	\
> +	switch (size) {                                         	\

On the last 3 lines here you've added a tab after spaces which
checkpatch complains about. With that fixed (or converted to tabs properl=
y):

Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

>  	case 1:								\
> -		retval =3D __put_user_asm_b((unsigned int)x, ptr); break;	\
> +		retval =3D __put_user_asm_b((__force unsigned int)x, ptr);\
> +		break;							\
>  	case 2:								\
> -		retval =3D __put_user_asm_w((unsigned int)x, ptr); break;	\
> +		retval =3D __put_user_asm_w((__force unsigned int)x, ptr);\
> +		break;							\
>  	case 4:								\
> -		retval =3D __put_user_asm_d((unsigned int)x, ptr); break;	\
> +		retval =3D __put_user_asm_d((__force unsigned int)x, ptr);\
> +		break;							\
>  	case 8:								\
> -		retval =3D __put_user_asm_l((unsigned long long)x, ptr); break; \
> +		retval =3D __put_user_asm_l((__force unsigned long long)x,\
> +					  ptr);				\
> +		break;							\
>  	default:							\
>  		__put_user_bad();					\
>  	}								\
>=20


--X7dVsXX01wr6Mfoij5v0F1Sh5JLoQXdBF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrQJ4AAoJEGwLaZPeOHZ6lAAQALPhV+Zf5mFvIe1IxWW48QIZ
V5ftcbjErBcgGXZXFtcQEsUkiCda6TE+xbEtOyXi0ze8KtEIyaig2JFRdBMe96Mh
HYFhb5hqvApRdMm/iBWocvAr8FYE2iO8sqGh2EgVVByQpiEP/dQmRrtYYoa7/+kC
8yHLQToC2e2SEbQJdgjYp7X7xh0EmjI4TarBhtKzRaL4Dv3pHAuyUHhqDn6ZqaD/
IkZDSx8UYaavJ7FgeheTz7nh2vaQfZbtXdW6WhJzMf5G9rtw74euQEJ2e3n06mEU
/fPO4/K+adOGINPI53k2Y+Wjn8rZ6cOsYhn8kqm136o0BFxuhAleqr0K+t62W/0N
Cl0fPjAvPrNa03X8WyPSuDbY8PLEKE33z/5hkBZjpMWB37Za1ADog4nTRyf9+z5n
ZDItZuu4PDTnqvr+YXhBLPc+dxpZZZ9QkVbRHYLx6hSrsr+jEHa1pqZwTkl1tmg1
NecBuxDk+lqoHqdfs3ncMLZpXRnc93/vB5skK3W65psRykAPpgshKwRAbLOnvYox
+LtwtnkjGS7+M13LxeTLNk/DlSHbiBqjn7Qoz4tcfv40hs4Jm0xLd8zwevNM6H1E
sPiMjYLHLD8vmthAm5B656ZB5a4iDWFz+k/CMimwbWmjd9+MxTOc++IKRYZODQ46
h7SXOni+zGWd39HmD0wg
=R+gX
-----END PGP SIGNATURE-----

--X7dVsXX01wr6Mfoij5v0F1Sh5JLoQXdBF--
