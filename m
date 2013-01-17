Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab3AQCfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:35:44 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59574 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758267Ab3AQCfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:35:43 -0500
Date: Thu, 17 Jan 2013 13:35:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: linux-next: manual merge of the staging tree with Linus' tree
Message-Id: <20130117133533.c005e3b2ee5c489e94902e3a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_Jan_2013_13_35_33_+1100_4/UDtCo6YFn3gQW9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Jan_2013_13_35_33_+1100_4/UDtCo6YFn3gQW9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/zram/zram_drv.c between commit 397c60668aa5 ("staging:
zram: fix invalid memory references during disk write") from Linus' tree
and commit d178a07c4bd3 ("staging: zram: drop zram_stat_dec/inc
functions") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/zram/zram_drv.c
index f2a73bd,6762b99..0000000
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@@ -300,19 -291,17 +289,19 @@@ static int zram_bvec_write(struct zram=20
 =20
  	user_mem =3D kmap_atomic(page);
 =20
 -	if (is_partial_io(bvec))
 +	if (is_partial_io(bvec)) {
  		memcpy(uncmem + offset, user_mem + bvec->bv_offset,
  		       bvec->bv_len);
 -	else
 +		kunmap_atomic(user_mem);
 +		user_mem =3D NULL;
 +	} else {
  		uncmem =3D user_mem;
 +	}
 =20
  	if (page_zero_filled(uncmem)) {
 -		kunmap_atomic(user_mem);
 -		if (is_partial_io(bvec))
 -			kfree(uncmem);
 +		if (!is_partial_io(bvec))
 +			kunmap_atomic(user_mem);
- 		zram_stat_inc(&zram->stats.pages_zero);
+ 		zram->stats.pages_zero++;
  		zram_set_flag(zram, index, ZRAM_ZERO);
  		ret =3D 0;
  		goto out;
@@@ -333,11 -320,9 +322,11 @@@
  	}
 =20
  	if (unlikely(clen > max_zpage_size)) {
- 		zram_stat_inc(&zram->stats.bad_compress);
+ 		zram->stats.bad_compress++;
 -		src =3D uncmem;
  		clen =3D PAGE_SIZE;
 +		src =3D NULL;
 +		if (is_partial_io(bvec))
 +			src =3D uncmem;
  	}
 =20
  	handle =3D zs_malloc(zram->mem_pool, clen);
@@@ -362,14 -343,13 +351,14 @@@
 =20
  	/* Update stats */
  	zram_stat64_add(zram, &zram->stats.compr_size, clen);
- 	zram_stat_inc(&zram->stats.pages_stored);
+ 	zram->stats.pages_stored++;
  	if (clen <=3D PAGE_SIZE / 2)
- 		zram_stat_inc(&zram->stats.good_compress);
+ 		zram->stats.good_compress++;
 =20
 -	return 0;
 -
  out:
 +	if (is_partial_io(bvec))
 +		kfree(uncmem);
 +
  	if (ret)
  		zram_stat64_inc(zram, &zram->stats.failed_writes);
  	return ret;

--Signature=_Thu__17_Jan_2013_13_35_33_+1100_4/UDtCo6YFn3gQW9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ92N1AAoJEECxmPOUX5FEEp0QAKV+K6Y4rsGOidycwypTYIM+
MELF2fpsfdaOs19QlgC96riV8Dydl8w0Q+tX6gBhNhfXMDR0BMKQIwZLK1pXi8Pz
uk7bqs7zIoYJn59r8Fnn2GUWPXMKV6xpzct57TkXbMPIfCr7DlLh65070Iu87EZ4
mcxB7GnJiQo1oBdQfJ59W8lkjF4rqLXTIt+QJgL81kgUUcUWTGGp3g0rnfWBn96P
ydznBjvkCDYUVWU9uDrBT6IEN/bm4c4Yi8YyxPHIhSf9YmhC9LAOAEC1OOkk4Ew5
ypl0hHkDUfMCu/RN2QDZBJBsRFhp7u3ISx5GHHZpSV5r2r+TZzCusVWbEAI4vIHV
DbaSb2zAuGX52JuPPRC/5YTLOEL8Z4pjLngFQH5rJ7XVL6eLAk8/Z0QQqepuD4MU
tY01Xf/v3ry5mOhEvW6q9j6wv/YdIesXTJZoFx2g21fcT122f8blzc9CafFCVCsh
XZIiX6zseyl3l7eVVHh4xIsNG3chC4+XFgC0Epd4p24M6B/EObjoBjE9qLOtq93k
CKRsPLgKMJ7Jp2GGRTl0WeESFBJTJoUP94ABcpzdJ+TMj1rVysf3DgE4NER3ctoY
lgFaAnZNerTjm7y917gGEwRTghmJvTdeVEtdB57ppfhSg3mC0D1gkJzyF//kNQjb
Jg6akGNcPVUnpWKN7AaK
=dHNg
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Jan_2013_13_35_33_+1100_4/UDtCo6YFn3gQW9--
