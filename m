Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087Ab3CZGcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:32:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60921 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab3CZGcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:32:17 -0400
Date: Tue, 26 Mar 2013 17:31:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>
Subject: linux-next: build failure after merge of the final tree (block tree
 related)
Message-Id: <20130326173159.09dad51a1b8825a264f3171f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Mar_2013_17_31_59_+1100_aiRggckB+t4XII3R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Mar_2013_17_31_59_+1100_aiRggckB+t4XII3R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

drivers/built-in.o: In function `bio_alloc_pages':
(.opd+0x2364a8): multiple definition of `bio_alloc_pages'
fs/built-in.o:(.opd+0x7188): first defined here

Caused by an interaction between commits a07876064a0b ("block: Add
bio_alloc_pages()") and commit cafe56359144 ("bcache: A block layer
cache") from the block tree.

I have applied the following fix patch (this should have happened in
merge commit 12f45f28441e "Merge branch 'for-3.10/drivers' into
for-next"):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 26 Mar 2013 17:26:45 +1100
Subject: [PATCH] block: remove the extra copy of bio_alloc_pages

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/md/bcache/util.c | 18 ------------------
 drivers/md/bcache/util.h |  2 --
 2 files changed, 20 deletions(-)

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index dcec2e4..671a55d 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -237,24 +237,6 @@ start:		bv->bv_len	=3D min_t(size_t, PAGE_SIZE - bv->b=
v_offset,
 }
 EXPORT_SYMBOL_GPL(bio_map);
=20
-int bio_alloc_pages(struct bio *bio, gfp_t gfp)
-{
-	int i;
-	struct bio_vec *bv;
-
-	bio_for_each_segment(bv, bio, i) {
-		bv->bv_page =3D alloc_page(gfp);
-		if (!bv->bv_page) {
-			while (bv-- !=3D bio->bi_io_vec + bio->bi_idx)
-				__free_page(bv->bv_page);
-			return -ENOMEM;
-		}
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(bio_alloc_pages);
-
 /*
  * Portions Copyright (c) 1996-2001, PostgreSQL Global Development Group (=
Any
  * use permitted, subject to terms of PostgreSQL license; see.)
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index 56705fd..499d746 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -570,8 +570,6 @@ static inline unsigned fract_exp_two(unsigned x, unsign=
ed fract_bits)
=20
 void bio_map(struct bio *bio, void *base);
=20
-int bio_alloc_pages(struct bio *bio, gfp_t gfp);
-
 static inline sector_t bdev_sectors(struct block_device *bdev)
 {
 	return bdev->bd_inode->i_size >> 9;
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Mar_2013_17_31_59_+1100_aiRggckB+t4XII3R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUUDfAAoJEECxmPOUX5FE9k4P/2GhCwPScZSaxuQECwjDcGru
8obxB1u871+FW1v9PHwrKwuiV6qvKxJJgOUf2/3Q7RVqmVEFgX8IvK5+HbnmhyV+
r7C9vZ0n/MgMzAwtEeRjBtekonvwV/HpM4+CeiAnUdpQIJqCBr7n4JF1YgExIZhq
kPS1skRqp1fxVj435bmqMvwv+L3/LimGUCxYzQxUBNEGRI2/slhkU9qLWav4CEv/
IZEasFcEN9/6T4qCjk1vVwPOhwoxVB/syA9b9yJ8uobQr+r53CZYICFl0jDRyIdO
N5IqisofwhJS0YqpoGnKs6SuHN9uC3F1O1KhogOTHnhbtx0cvSaEYeCt4S7mMwJM
WLlt3vv3d3BMRs8Ws37d/ywIC2gbsF+SMcguhAGtjbzhg1N6uzGqzg0a+qIshSr/
ixY0uIPZJWLmJM1qYnwfXi80she/mpY8cmvcteden8FG7HTuBKeGTNw4ERqkCpx1
VXUasVD7WrbDvVxIo0e0sqn9pgyZTdMtC11gTNbhpaY9jD2HsUKAfJIMtVtKF+hJ
CmVTvabcSe0YI0A6MMofx02nX3mRnlMcXRKnSEDFpra6CIIG0ZUxa1odd/jMJgPH
qwpIfEaQytBt6VFRuWw5YXJm1fOj+7bZX1/EC0PF7AHcjJeH3Ze21obDfqkT2kOU
OTCLPaTcO3ikcOA6KtE0
=DXGh
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Mar_2013_17_31_59_+1100_aiRggckB+t4XII3R--
