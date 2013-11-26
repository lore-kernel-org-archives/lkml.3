Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3KZCaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:30:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39760 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab3KZCaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:30:19 -0500
Date: Tue, 26 Nov 2013 13:30:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Chao Yu <chao2.yu@samsung.com>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20131126133001.7cc9d05bdbd763ffa1e1dc4d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Nov_2013_13_30_01_+1100_w/+ChGoWFVdsri4Y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Nov_2013_13_30_01_+1100_w/+ChGoWFVdsri4Y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/f2fs/data.c: In function 'submit_read_page':
fs/f2fs/data.c:457:10: error: 'struct bio' has no member named 'bi_sector'
   io->bio->bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
          ^

Caused by commit 4f024f3797c4 ("block: Abstract out bvec iterator") from
the block tree interacting with commit 32cd69ef0893 ("f2fs: add a new
function to support for merging contiguous read") from the f2fs tree.

I added the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 26 Nov 2013 13:19:30 +1100
Subject: [PATCH] f2fs: cope with bvec iterator abstraction

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 728eedb1c0c6..8d31b83bfc89 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -454,7 +454,7 @@ alloc_new:
 	if (io->bio =3D=3D NULL) {
 		bio_blocks =3D MAX_BIO_BLOCKS(max_hw_blocks(sbi));
 		io->bio =3D f2fs_bio_alloc(bdev, bio_blocks);
-		io->bio->bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
+		io->bio->bi_iter.bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
 		io->bio->bi_end_io =3D read_end_io;
 	}
=20
--=20
1.8.4.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Nov_2013_13_30_01_+1100_w/+ChGoWFVdsri4Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSlAepAAoJEMDTa8Ir7ZwV3KsP/j2keY3icILZfwAVbE8vzweU
XXAqq6H6hV2hawwBQZXyrvpl6TXR+LHjCtpQxk10mc8qmhNa/v2FaV58vadatUc4
SoxqT4EOBuXM9HmTlBdJZpRZgO0ho0IWtsq+8ZM/Tk/CV3GSNPD4UYGLPvTTnYSN
XIc0PWgvRXaaYZRfxf6Q7dJsEcdtR9JqZxffNfuE9bsL5Y9o/tlfZon+W4UxPXe4
ZxuRMt/FPITyBdJC0fiq/X75srDnaYXfG/7mIV8Rd4SlvKAIZ/FBSFxwiBFrNqB6
TZbd2PKAj7Xo2QxMh/7HRT+KaHO5tI4PIypZF2uYjAZQ8j1i7SronJXtDkI0n5PD
/bhrl9IM30Q3pAiheAfG52xdwq7hbkU/XaV0AFJBtD7rNH7+gJ4r7DsUkVtkXHmE
TfImBBYMDSyIlIlarJjidBN5QJgZnhyO47sXMq4MYtH6A97wF0ULf345wW7izMSF
6CfssrA67jpKZxQvJo2Ay6xYKrLn5yPshrDbyccMGX6xkk8EVEog6VcV1PlUPDhk
gur1DmYMGA8QcAiEv4seSwbgBLPKSsey7CaHV6t7t42RzgAvphrMYnuhYlkYfmW6
uGtsW6nHvwcgJ78fa+/x8tMqgUYH3o49kQpp1UDSCPMz9c02+olh41kt3a/ZXNGj
+njAog1O5Kh8jrpcq0Ly
=AaoT
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Nov_2013_13_30_01_+1100_w/+ChGoWFVdsri4Y--
