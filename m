Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183Ab3IGAaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 20:30:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41738 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3IGAaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 20:30:06 -0400
Date: Fri, 6 Sep 2013 17:30:00 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, ecryptfs@vger.kernel.org
Subject: Re: [PATCH] ecryptfs: avoid ctx initialization race
Message-ID: <20130907002959.GN3853@boyd>
References: <20130813220227.GA20160@www.outflux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Rzq/nSLlHy1djmXS"
Content-Disposition: inline
In-Reply-To: <20130813220227.GA20160@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Rzq/nSLlHy1djmXS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-08-13 15:02:27, Kees Cook wrote:
> It might be possible for two callers to race the mutex lock after the
> NULL ctx check. Instead, move the lock above the check so there isn't
> the possibility of leaking a crypto ctx. Additionally, report the full
> algo name when failing.
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>

Thanks, Kees!

I've pushed this to my next branch and it'll be included in a pull
request early next week.

I made one small change to this patch. See below.

> ---
>  fs/ecryptfs/crypto.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index d107576..c134346 100644
> --- a/fs/ecryptfs/crypto.c
> +++ b/fs/ecryptfs/crypto.c
> @@ -618,27 +618,28 @@ int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_s=
tat *crypt_stat)
>  			"key_size_bits =3D [%zd]\n",
>  			crypt_stat->cipher, (int)strlen(crypt_stat->cipher),
>  			crypt_stat->key_size << 3);
> +	mutex_lock(&crypt_stat->cs_tfm_mutex);
>  	if (crypt_stat->tfm) {
>  		rc =3D 0;
> -		goto out;
> +		goto out_unlock;
>  	}
> -	mutex_lock(&crypt_stat->cs_tfm_mutex);
>  	rc =3D ecryptfs_crypto_api_algify_cipher_name(&full_alg_name,
>  						    crypt_stat->cipher, "cbc");
>  	if (rc)
>  		goto out_unlock;
>  	crypt_stat->tfm =3D crypto_alloc_ablkcipher(full_alg_name, 0, 0);
> -	kfree(full_alg_name);
>  	if (IS_ERR(crypt_stat->tfm)) {
>  		rc =3D PTR_ERR(crypt_stat->tfm);
>  		crypt_stat->tfm =3D NULL;
>  		ecryptfs_printk(KERN_ERR, "cryptfs: init_crypt_ctx(): "
>  				"Error initializing cipher [%s]\n",
> -				crypt_stat->cipher);
> -		goto out_unlock;
> +				full_alg_name);
> +		goto out_free;
>  	}
>  	crypto_ablkcipher_set_flags(crypt_stat->tfm, CRYPTO_TFM_REQ_WEAK_KEY);
>  	rc =3D 0;
> +out_free:
> +	kfree(full_alg_name);
>  out_unlock:
>  	mutex_unlock(&crypt_stat->cs_tfm_mutex);
>  out:

The out label is no longer used. I removed it when I committed this
patch.

Tyler

--Rzq/nSLlHy1djmXS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCgAGBQJSKnOHAAoJENaSAD2qAscKbtoP/ic+7sNw1EUN15M6M8Yp2308
fQdYvmetD7Y7PlF8dYV1/y0yhZi41BelkbATKXi2vaV5CjJqf4d+20Lo0hV1TeAs
r5tBqurcDJaHhY6GpC+LS5aV5Gw0VJC7N6f5OYqcMt4md/6Yh1fD8ITZ9TOLKm6n
6WnweWvUEkUtkOYg4ok6qcwtwuZWvw3RepJ8Ucv5hXgMBU7ib4hTT6MTxEQR0XmX
AVt8cbRKSc3PGqZgl24UYGsXag9SF1UuzcN7TgmmiNlYaKxIZqNqb7pE1jrVidju
xk9ThOOHKMmVFVvPZ8FOI8XJN1CEAyeMPQ6YCUENG5uIGK391MUcYpdqx9jQLnlt
hsOH5rPeei/vdrHaEqivhcRYcN/nzdb8MXIEUg2WA4r0fxpkyVWp2N5SuSzPkw3l
WbVyR5PQuer+NDZ0Hh5XkVjm6HLeCbcrRdoS0QQ6Sc4+Vfq9rX4tBVUvddNXeuX6
pC7SHN1Y3HZdIzM5tcVCjR7RLoPUzjetXrZpbSunu61Iu/a8erDHx8CcKZJ2Jpxu
VYOLbQh6Mgxcx6YegdiCPqSmbmrSBQYO8gs3WuYfs1yz/6V/GBJOs7S/tkoo9UyS
FfGfXodNz7Ps7+H52NwjwdTRgrnvBslhb53RUZv2/Gdp95IezOmH6Y2BpSYsma/9
bNtKewblIBkrN44Ayogl
=DDO6
-----END PGP SIGNATURE-----

--Rzq/nSLlHy1djmXS--
