Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab3DAXWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 19:22:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59040 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab3DAXWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:22:47 -0400
Date: Tue, 2 Apr 2013 10:22:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>
Subject: Re: linux-next: build failure after merge of the final tree (block
 tree related)
Message-Id: <20130402102236.9a597c047fbf8d09038bc989@canb.auug.org.au>
In-Reply-To: <20130326173159.09dad51a1b8825a264f3171f@canb.auug.org.au>
References: <20130326173159.09dad51a1b8825a264f3171f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_10_22_36_+1100_RdaSoNRo_H_auoFA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_10_22_36_+1100_RdaSoNRo_H_auoFA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Tue, 26 Mar 2013 17:31:59 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the final tree, today's linux-next build (powerpc allyescon=
fig)
> failed like this:
>=20
> drivers/built-in.o: In function `bio_alloc_pages':
> (.opd+0x2364a8): multiple definition of `bio_alloc_pages'
> fs/built-in.o:(.opd+0x7188): first defined here
>=20
> Caused by an interaction between commits a07876064a0b ("block: Add
> bio_alloc_pages()") and commit cafe56359144 ("bcache: A block layer
> cache") from the block tree.
>=20
> I have applied the following fix patch (this should have happened in
> merge commit 12f45f28441e "Merge branch 'for-3.10/drivers' into
> for-next"):
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 26 Mar 2013 17:26:45 +1100
> Subject: [PATCH] block: remove the extra copy of bio_alloc_pages
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/md/bcache/util.c | 18 ------------------
>  drivers/md/bcache/util.h |  2 --
>  2 files changed, 20 deletions(-)
>=20
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index dcec2e4..671a55d 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -237,24 +237,6 @@ start:		bv->bv_len	=3D min_t(size_t, PAGE_SIZE - bv-=
>bv_offset,
>  }
>  EXPORT_SYMBOL_GPL(bio_map);
> =20
> -int bio_alloc_pages(struct bio *bio, gfp_t gfp)
> -{
> -	int i;
> -	struct bio_vec *bv;
> -
> -	bio_for_each_segment(bv, bio, i) {
> -		bv->bv_page =3D alloc_page(gfp);
> -		if (!bv->bv_page) {
> -			while (bv-- !=3D bio->bi_io_vec + bio->bi_idx)
> -				__free_page(bv->bv_page);
> -			return -ENOMEM;
> -		}
> -	}
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(bio_alloc_pages);
> -
>  /*
>   * Portions Copyright (c) 1996-2001, PostgreSQL Global Development Group=
 (Any
>   * use permitted, subject to terms of PostgreSQL license; see.)
> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> index 56705fd..499d746 100644
> --- a/drivers/md/bcache/util.h
> +++ b/drivers/md/bcache/util.h
> @@ -570,8 +570,6 @@ static inline unsigned fract_exp_two(unsigned x, unsi=
gned fract_bits)
> =20
>  void bio_map(struct bio *bio, void *base);
> =20
> -int bio_alloc_pages(struct bio *bio, gfp_t gfp);
> -
>  static inline sector_t bdev_sectors(struct block_device *bdev)
>  {
>  	return bdev->bd_inode->i_size >> 9;
> --=20
> 1.8.1

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Apr_2013_10_22_36_+1100_RdaSoNRo_H_auoFA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRWha8AAoJEECxmPOUX5FEEGEP/Re050H6OsZMocEbnbqpI6qP
4zIkJFaJ98Yfz2jjXGUxd0vTshntITg8weCkIrDfQlTNCuSowYW+uSg/2npsQw07
iboMemhcFpR1qXNuBeC3IHjPin3rfIWQJ91Z6+z5Y2GMLqbnTox5/nUDDQTTn73l
b8IN4LGE+GMOkLyJiunrD1R4Wamyi7EW77zYcD4V2et9rqgS6wfUMO/mEwSbCsoL
0cacFwmPdp/iX67hbsX2M32x7pTBEMdLqcaX7Jyj6XJfpYsq7MHHE3SFaDk2CGAU
oPvL/gLswD0XLwloA49yjZD/tCbyMoiNXOBaZ/t67u3Ux3P0h/p+K+qN9Bf1HIJ7
ZdLrhC259F+aWqvggrJnIdoJhkt+E2bQ8JPVCuMEqulVSafZjYY7zobLkjh36gGo
5ZjhB5SXfADMjgIYXhiNuYoMGhMCeJMAFQ/D0N3KhDu07yjw6V21hoRFtzhcm1iH
/ttx/14tNAZfnTv777ydJJZiuNGH81KTYjWyIeS/K7nNi6HQawn1hj3JUuK7ysIw
pmBkc48CV/VWPlO3jQ2Jq/kWuYcINubphahZBOUC55GLYDr2FqS4i/xA2RWbM3Am
OkyirM5Ji5SrOrVX4ZEDUMkQt2PcAObhJ1cZNfBIxBabI4rND/KAVDqdqv1hj5kK
k7kWGlli7fjAoz3/OEZM
=kuhw
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_10_22_36_+1100_RdaSoNRo_H_auoFA--
