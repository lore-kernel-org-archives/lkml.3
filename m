Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab3DSHk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 03:40:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51374 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab3DSHkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 03:40:55 -0400
Date: Fri, 19 Apr 2013 17:40:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kent Overstreet <koverstreet@google.com>,
        Minchan Kim <minchan@kernel.org>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130419174041.f0f8f47ae745896a6857000d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__19_Apr_2013_17_40_41_+1000_BgeF2Eu/uyHfv=PI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Apr_2013_17_40_41_+1000_BgeF2Eu/uyHfv=PI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/bio.c
between commit 0a82a8d132b2 ("Revert "block: add missing
block_bio_complete() tracepoint"") from Linus' tree and commit "block,
aio: batch completion for bios/kiocbs" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/bio.c
index e082907,a8081ae..0000000
--- a/fs/bio.c
+++ b/fs/bio.c
@@@ -1688,31 -1689,42 +1689,40 @@@ void bio_flush_dcache_pages(struct bio=20
  EXPORT_SYMBOL(bio_flush_dcache_pages);
  #endif
 =20
- /**
-  * bio_endio - end I/O on a bio
-  * @bio:	bio
-  * @error:	error, if any
-  *
-  * Description:
-  *   bio_endio() will end I/O on the whole bio. bio_endio() is the
-  *   preferred way to end I/O on a bio, it takes care of clearing
-  *   BIO_UPTODATE on error. @error is 0 on success, and and one of the
-  *   established -Exxxx (-EIO, for instance) error values in case
-  *   something went wrong. No one should call bi_end_io() directly on a
-  *   bio unless they own it and thus know that it has an end_io
-  *   function.
-  **/
- void bio_endio(struct bio *bio, int error)
+ static inline void __bio_endio(struct bio *bio, struct batch_complete *ba=
tch)
  {
- 	if (error)
+ 	if (bio->bi_error)
  		clear_bit(BIO_UPTODATE, &bio->bi_flags);
  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
- 		error =3D -EIO;
+ 		bio->bi_error =3D -EIO;
 =20
  	if (bio->bi_end_io)
- 		bio->bi_end_io(bio, error, NULL);
+ 		bio->bi_end_io(bio, bio->bi_error, batch);
+ }
+=20
+ void bio_endio_batch(struct bio *bio, int error, struct batch_complete *b=
atch)
+ {
+ 	if (error)
+ 		bio->bi_error =3D error;
+=20
 -	trace_block_bio_complete(bio, error);
 -
+ 	if (batch)
+ 		bio_list_add(&batch->bio, bio);
+ 	else
+ 		__bio_endio(bio, batch);
+=20
+ }
+ EXPORT_SYMBOL(bio_endio_batch);
+=20
+ void batch_complete(struct batch_complete *batch)
+ {
+ 	struct bio *bio;
+=20
+ 	while ((bio =3D bio_list_pop(&batch->bio)))
+ 		__bio_endio(bio, batch);
+=20
+ 	batch_complete_aio(batch);
  }
- EXPORT_SYMBOL(bio_endio);
+ EXPORT_SYMBOL(batch_complete);
 =20
  void bio_pair_release(struct bio_pair *bp)
  {

--Signature=_Fri__19_Apr_2013_17_40_41_+1000_BgeF2Eu/uyHfv=PI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRcPT5AAoJEECxmPOUX5FENsUP/iCghpLoIf9Yjh9Z8nTGtk1J
ctdVZZ+448EHB9YnC6nUesbbmjG9VeAmBDHMjSmkwB4y7sDPhJL8doGrptRuunMv
wTP0cPn+r6bTqkMKgdZBUhrVXkTHvNaOUCcq2IBfSAbVVVcrCHJeOZnwd6yKNZv9
6q3OiVSsL2riXk4sq54VK5BJStX5eMTGG0QPKoim+I3WB55fGbfGTupwzDvUtAGP
f5QxXZdeUfdkJvnBHfdRlzNDwl4DYEOajgtpzBD9eCa97MZ2rg3AehdYBKj/KtjQ
t1i8fiaSiLt6qTwLhvwxf9pNXxvZz+Ra3Fr5rggyekJz+Y8cFFRaQcaschHpBICC
+ltJZTL9eNZ/0zNIIRWZgcXZXxbA4eqEXORjSJKpPLx19qtUFGFoWtg1fOlHy6Do
WWJLPykoIKt/yUxF+S1KlUazQ2Xet6hFaYklbNMKFmJoZFzmgmwFD5ppUylk/dV/
aga4EdHdLWcyCg/wX9yZskt3zUjLz5/3NRhvWqD88DSdIWOG3jn9XB27wBh+/O2P
W2YaZCFSXZGqczTabK1f1vh1SUV/mp0HgISyZvyFhAXmA9FfUUAGjpKGdM7GuY72
I7c0HHuQ6uHAVffIDoiZaaNv5EZoIfWREFlLhw99Ml9BFPKl4W/gcqLx1eJEL6dJ
d8nGJrennXFNwyz7TMwf
=ZqR7
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Apr_2013_17_40_41_+1000_BgeF2Eu/uyHfv=PI--
