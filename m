Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaHMIcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:32:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaHMIcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:32:04 -0400
Message-ID: <53EB2271.1080002@redhat.com>
Date: Wed, 13 Aug 2014 10:31:45 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>, minchan@kernel.org
CC: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] zram: fix incorrectly stat with failed_reads
References: <009001cfb69a$a8470840$f8d518c0$@samsung.com>
In-Reply-To: <009001cfb69a$a8470840$f8d518c0$@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="XKvbmKNatH66kcgbGqdclrm0ju1we9sP3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XKvbmKNatH66kcgbGqdclrm0ju1we9sP3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/13/2014 04:01 AM, Chao Yu wrote:
> Since we allocate a temporary buffer in zram_bvec_read to handle partia=
l page
> operations in this commit 924bd88d703e53d30f393fac6117f8f1bc79aab6 (Sta=
ging:
> zram: allow partial page operations), our ->failed_reads value may be i=
ncorrect
> as we do not increase its value when failed to allocate the temporary b=
uffer.
>=20
> Let's fix this issue and correct the annotation of failed_reads.
>=20
>  v2: clean codes of failed_{reads,writes} stat pointed out by Minchan K=
im, and
> this cleanup also fix incorrectly stat when fail in zram_decompress_pag=
e.
>=20
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>

Acked-by: Jerome Marchand <jmarchan@redhat.com>

> ---
>  drivers/block/zram/zram_drv.c | 10 +++++++---
>  drivers/block/zram/zram_drv.h |  2 +-
>  2 files changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_dr=
v.c
> index dfa4024..d00831c 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -378,7 +378,6 @@ static int zram_decompress_page(struct zram *zram, =
char *mem, u32 index)
>  	/* Should NEVER happen. Return bio error if it does. */
>  	if (unlikely(ret)) {
>  		pr_err("Decompression failed! err=3D%d, page=3D%u\n", ret, index);
> -		atomic64_inc(&zram->stats.failed_reads);
>  		return ret;
>  	}
> =20
> @@ -547,8 +546,6 @@ out:
>  		zcomp_strm_release(zram->comp, zstrm);
>  	if (is_partial_io(bvec))
>  		kfree(uncmem);
> -	if (ret)
> -		atomic64_inc(&zram->stats.failed_writes);
>  	return ret;
>  }
> =20
> @@ -566,6 +563,13 @@ static int zram_bvec_rw(struct zram *zram, struct =
bio_vec *bvec, u32 index,
>  		ret =3D zram_bvec_write(zram, bvec, index, offset);
>  	}
> =20
> +	if (unlikely(ret)) {
> +		if (rw =3D=3D READ)
> +			atomic64_inc(&zram->stats.failed_reads);
> +		else
> +			atomic64_inc(&zram->stats.failed_writes);
> +	}
> +
>  	return ret;
>  }
> =20
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_dr=
v.h
> index 5b0afde..e0f725c 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -84,7 +84,7 @@ struct zram_stats {
>  	atomic64_t compr_data_size;	/* compressed size of pages stored */
>  	atomic64_t num_reads;	/* failed + successful */
>  	atomic64_t num_writes;	/* --do-- */
> -	atomic64_t failed_reads;	/* should NEVER! happen */
> +	atomic64_t failed_reads;	/* can happen when memory is too low */
>  	atomic64_t failed_writes;	/* can happen when memory is too low */
>  	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
>  	atomic64_t notify_free;	/* no. of swap slot free notifications */
>=20



--XKvbmKNatH66kcgbGqdclrm0ju1we9sP3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT6yJxAAoJEHTzHJCtsuoCPv8H/35+Th3G3iiOSAD9c4dqBJE0
tLRTQnFE0RBUlk/r266FQrxF6gtU2je+TZhlk8Uvcg5VS6/M8QVd0KUFkxy4EyDk
8od9DnTe5xMPtR0uHjAqynDYjcYClMXAdbfmtc5GURQzc4lKo9tc7ZOrUVUibD0e
mOKQ74AKTd/Jx2rrTq1EbdcyJkR1yzRD06P3rHJF1yCsSQ/Em/n2R8gsS8K331Kp
8dA2kyMAryY0hxqVtSWmMjyROxRA4l+ZpcRB0wH8rGQp9aa4Sam5ZVuXHNAX6b63
Mn+Vt9WpCDvp8nl5xVZNtTLufQwXHV6+d4OhdetQ6xKYGUjj2takdYaM4yIQo9s=
=NHM/
-----END PGP SIGNATURE-----

--XKvbmKNatH66kcgbGqdclrm0ju1we9sP3--
