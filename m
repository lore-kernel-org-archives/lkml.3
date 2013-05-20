Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750812Ab3ETEFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 00:05:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54506 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab3ETEFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 00:05:00 -0400
Date: Mon, 20 May 2013 14:04:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>,
        Kent Overstreet <koverstreet@google.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130520140449.5da8b61ceaaf06618914e76f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_May_2013_14_04_49_+1000_RHrBdk+_o_3dxtPm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_May_2013_14_04_49_+1000_RHrBdk+_o_3dxtPm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got conflicts in
fs/btrfs/inode.c and fs/btrfs/volumes.c between commit 9be3395bcd4a
("Btrfs: use a btrfs bioset instead of abusing bio internals") from
Linus' tree and commit "block: prep work for batch completion" from the
akpm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

I also noticed that a single conversion of bio_endio to bio_endio_batch
is done in the akpm patch but bio_endio_batch is not introduced until a
later patch ... :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/btrfs/inode.c
index af978f7,551c8bd..0000000
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@@ -6932,14 -6928,11 +6932,15 @@@ struct btrfs_dio_private=20
  	/* IO errors */
  	int errors;
 =20
 +	/* orig_bio is our btrfs_io_bio */
  	struct bio *orig_bio;
 +
 +	/* dio_bio came from fs/direct-io.c */
 +	struct bio *dio_bio;
  };
 =20
- static void btrfs_endio_direct_read(struct bio *bio, int err)
+ static void btrfs_endio_direct_read(struct bio *bio, int err,
+ 				    struct batch_complete *batch)
  {
  	struct btrfs_dio_private *dip =3D bio->bi_private;
  	struct bio_vec *bvec_end =3D bio->bi_io_vec + bio->bi_vcnt - 1;
@@@ -6992,12 -6984,12 +6993,13 @@@ failed
 =20
  	/* If we had a csum failure make sure to clear the uptodate flag */
  	if (err)
 -		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 -	dio_end_io(bio, err, batch);
 +		clear_bit(BIO_UPTODATE, &dio_bio->bi_flags);
- 	dio_end_io(dio_bio, err);
++	dio_end_io(dio_bio, err, batch);
 +	bio_put(bio);
  }
 =20
- static void btrfs_endio_direct_write(struct bio *bio, int err)
+ static void btrfs_endio_direct_write(struct bio *bio, int err,
+ 				     struct batch_complete *batch)
  {
  	struct btrfs_dio_private *dip =3D bio->bi_private;
  	struct inode *inode =3D dip->inode;
@@@ -7039,9 -7030,8 +7041,9 @@@ out_done
 =20
  	/* If we had an error make sure to clear the uptodate flag */
  	if (err)
 -		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 -	dio_end_io(bio, err, batch);
 +		clear_bit(BIO_UPTODATE, &dio_bio->bi_flags);
- 	dio_end_io(dio_bio, err);
++	dio_end_io(dio_bio, err, batch);
 +	bio_put(bio);
  }
 =20
  static int __btrfs_submit_bio_start_direct_io(struct inode *inode, int rw,
diff --cc fs/btrfs/volumes.c
index 8bffb91,7299b55..0000000
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@@ -5018,9 -5019,35 +5018,10 @@@ int btrfs_rmap_block(struct btrfs_mappi
  	return 0;
  }
 =20
- static void btrfs_end_bio(struct bio *bio, int err)
 -static void *merge_stripe_index_into_bio_private(void *bi_private,
 -						 unsigned int stripe_index)
 -{
 -	/*
 -	 * with single, dup, RAID0, RAID1 and RAID10, stripe_index is
 -	 * at most 1.
 -	 * The alternative solution (instead of stealing bits from the
 -	 * pointer) would be to allocate an intermediate structure
 -	 * that contains the old private pointer plus the stripe_index.
 -	 */
 -	BUG_ON((((uintptr_t)bi_private) & 3) !=3D 0);
 -	BUG_ON(stripe_index > 3);
 -	return (void *)(((uintptr_t)bi_private) | stripe_index);
 -}
 -
 -static struct btrfs_bio *extract_bbio_from_bio_private(void *bi_private)
 -{
 -	return (struct btrfs_bio *)(((uintptr_t)bi_private) & ~((uintptr_t)3));
 -}
 -
 -static unsigned int extract_stripe_index_from_bio_private(void *bi_privat=
e)
 -{
 -	return (unsigned int)((uintptr_t)bi_private) & 3;
 -}
 -
+ static void btrfs_end_bio(struct bio *bio, int err,
+ 			  struct batch_complete *batch)
  {
 -	struct btrfs_bio *bbio =3D extract_bbio_from_bio_private(bio->bi_private=
);
 +	struct btrfs_bio *bbio =3D bio->bi_private;
  	int is_orig_bio =3D 0;
 =20
  	if (err) {

--Signature=_Mon__20_May_2013_14_04_49_+1000_RHrBdk+_o_3dxtPm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRmaDhAAoJEECxmPOUX5FEFMwP/3OxDYQ2mXK+/aZaXM6eYnU0
PFV1g95W8sd36ySBVgePal0q+oeXwvYn75URESFQ2cup97x+fH+OnX52mcSpCHTY
x6wSv4LBqPcjrq4i1km8uBOOwJvGO8eE6nI5i89ZDdexJBN3k7EK+3sLD+Y573WI
Kxv27h1YT1XtIfu8mrouRwb4zfKxWfeGMRQPiFCv0KgO6Lkr+IgAXvgnQpadW1Ua
4dTwmFqyjO8FmgnQhCuTK4I7pwux9up8dCZGnco0E3BqHcPOw9YB1y+xaAGfgZhe
buurNCEZBbXPgOuUUUzx0KodCVZhNIEw+xqhaMiKpf05ao5vVb4du9b8hHD3Nkq+
mrawCxURcelOKErZTRfFAqJgemMs7knZzy85l+3xq7PqAvtBmhT6c5QV4G5fjerA
PXqoA5pHq5gEV4brMoChkpohR1TwlBBC36M2wkMTSrVv06t9mndZ+OKgpbiiPCJ2
Qi3QkksL53bUEy77Q5EPZAR+F4C3XYzAYIzXJQYbd9JjMT+cCknDjBIh/R87nH84
NOzZk+FU6MfcOOi4HbS9RxUsmYLZihFMJBnS+eFZMYifFJRBMfuik6DVR0hEPx1y
aqvPFaprg7D9Ln0w8yOkcLDljJLL3U7P5N76eWnjA9JoT+az7nEJj0tu4CpxNAiD
JnvXbNPbRbIJ361JZlVz
=zi7k
-----END PGP SIGNATURE-----

--Signature=_Mon__20_May_2013_14_04_49_+1000_RHrBdk+_o_3dxtPm--
