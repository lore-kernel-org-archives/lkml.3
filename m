Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbaJUPOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:14:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbaJUPOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:14:15 -0400
Message-ID: <544668D0.30302@redhat.com>
Date: Tue, 21 Oct 2014 16:08:16 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: karam.lee@lge.com, minchan@kernel.org, ngupta@vflare.org,
        linux-kernel@vger.kernel.org
CC: matthew.r.wilcox@intel.com, seungho1.park@lge.com
Subject: Re: [PATCH v3 1/3] zram: remove bio parameter from zram_bvec_rw().
References: <1413876458-19279-1-git-send-email-karam.lee@lge.com> <1413876458-19279-2-git-send-email-karam.lee@lge.com>
In-Reply-To: <1413876458-19279-2-git-send-email-karam.lee@lge.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Q3nMSL1vfNr0nWdHpABtbawkfSQjNUXA0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Q3nMSL1vfNr0nWdHpABtbawkfSQjNUXA0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/21/2014 09:27 AM, karam.lee@lge.com wrote:
> From: "karam.lee" <karam.lee@lge.com>
>=20
> This patch removes an unnecessary parameter(bio)
> from zram_bvec_rw() and zram_bvec_read().
> zram_bvec_read() doesn't use a bio parameter, so remove it.
> zram_bvec_rw() calls a read/write operation not using bio, so a rw para=
meter
> replaces a bio parameter.
>=20
> Signed-off-by: karam.lee <karam.lee@lge.com>

Acked-by: Jerome Marchand <jmarchan@redhat.com>

> ---
>  drivers/block/zram/zram_drv.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_dr=
v.c
> index 48eccb3..54da18a 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -368,7 +368,7 @@ static int zram_decompress_page(struct zram *zram, =
char *mem, u32 index)
>  }
> =20
>  static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> -			  u32 index, int offset, struct bio *bio)
> +			  u32 index, int offset)
>  {
>  	int ret;
>  	struct page *page;
> @@ -535,14 +535,13 @@ out:
>  }
> =20
>  static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 i=
ndex,
> -			int offset, struct bio *bio)
> +			int offset, int rw)
>  {
>  	int ret;
> -	int rw =3D bio_data_dir(bio);
> =20
>  	if (rw =3D=3D READ) {
>  		atomic64_inc(&zram->stats.num_reads);
> -		ret =3D zram_bvec_read(zram, bvec, index, offset, bio);
> +		ret =3D zram_bvec_read(zram, bvec, index, offset);
>  	} else {
>  		atomic64_inc(&zram->stats.num_writes);
>  		ret =3D zram_bvec_write(zram, bvec, index, offset);
> @@ -718,7 +717,7 @@ out:
> =20
>  static void __zram_make_request(struct zram *zram, struct bio *bio)
>  {
> -	int offset;
> +	int offset, rw;
>  	u32 index;
>  	struct bio_vec bvec;
>  	struct bvec_iter iter;
> @@ -733,6 +732,7 @@ static void __zram_make_request(struct zram *zram, =
struct bio *bio)
>  		return;
>  	}
> =20
> +	rw =3D bio_data_dir(bio);
>  	bio_for_each_segment(bvec, bio, iter) {
>  		int max_transfer_size =3D PAGE_SIZE - offset;
> =20
> @@ -747,15 +747,15 @@ static void __zram_make_request(struct zram *zram=
, struct bio *bio)
>  			bv.bv_len =3D max_transfer_size;
>  			bv.bv_offset =3D bvec.bv_offset;
> =20
> -			if (zram_bvec_rw(zram, &bv, index, offset, bio) < 0)
> +			if (zram_bvec_rw(zram, &bv, index, offset, rw) < 0)
>  				goto out;
> =20
>  			bv.bv_len =3D bvec.bv_len - max_transfer_size;
>  			bv.bv_offset +=3D max_transfer_size;
> -			if (zram_bvec_rw(zram, &bv, index + 1, 0, bio) < 0)
> +			if (zram_bvec_rw(zram, &bv, index + 1, 0, rw) < 0)
>  				goto out;
>  		} else
> -			if (zram_bvec_rw(zram, &bvec, index, offset, bio) < 0)
> +			if (zram_bvec_rw(zram, &bvec, index, offset, rw) < 0)
>  				goto out;
> =20
>  		update_position(&index, &offset, &bvec);
>=20



--Q3nMSL1vfNr0nWdHpABtbawkfSQjNUXA0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJURmjQAAoJEHTzHJCtsuoCIegIAJNihbUf0cbqZEn7zCbwXsaj
omANPr5ivEMvrKGGqGLMhRycM6COPxsp0kWYfPbPHi1SaKGtLQb6P+Anl0aCq9Kh
MetmdY82L3LR1L2hDa/jIcYrC8doxqRQahLDt6FwsVkfIq1wF6dNrus1fmRJkZ7f
G1OazHIEJ/YhV7ewVdtxA/7AfneZCMEhTGzaNb7i5eObXcaICaSz4GJhZ3+8hbKh
LcF8KH8DLX3JIXiA2fIMqwIk7Rxxz5s50nIECastENEIt63XneKYKPTPD5UF2dH+
h4oG6D/QEa7nvuHNBhkheJ8/tDEi+RuGDVq4PTSZEHkpuq+qUYevr2LPzq9mc84=
=MlcF
-----END PGP SIGNATURE-----

--Q3nMSL1vfNr0nWdHpABtbawkfSQjNUXA0--
