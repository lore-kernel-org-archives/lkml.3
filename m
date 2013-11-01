Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab3KADZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 23:25:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33234 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3KADZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 23:25:28 -0400
Date: Fri, 1 Nov 2013 14:25:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.de>,
        Kent Overstreet <kmo@daterainc.com>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20131101142520.19f30a62817414772a3045de@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Nov_2013_14_25_20_+1100_EdFfWs7/zrRi6y8="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Nov_2013_14_25_20_+1100_EdFfWs7/zrRi6y8=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/md/raid5.c between commit 37c61ff31e9b ("raid5: set bio bi_vcnt 0
for discard request") from Linus' tree and commit ed2d2f9a8265 ("block:
Abstract out bvec iterator") from the block tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/md/raid5.c
index f8b906843926,e00beb5d2e88..000000000000
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@@ -777,13 -777,7 +777,13 @@@ static void ops_run_io(struct stripe_he
  			bi->bi_vcnt =3D 1;
  			bi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
  			bi->bi_io_vec[0].bv_offset =3D 0;
- 			bi->bi_size =3D STRIPE_SIZE;
+ 			bi->bi_iter.bi_size =3D STRIPE_SIZE;
 +			/*
 +			 * If this is discard request, set bi_vcnt 0. We don't
 +			 * want to confuse SCSI because SCSI will replace payload
 +			 */
 +			if (rw & REQ_DISCARD)
 +				bi->bi_vcnt =3D 0;
  			if (rrdev)
  				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
 =20
@@@ -821,13 -815,7 +821,13 @@@
  			rbi->bi_vcnt =3D 1;
  			rbi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
  			rbi->bi_io_vec[0].bv_offset =3D 0;
- 			rbi->bi_size =3D STRIPE_SIZE;
+ 			rbi->bi_iter.bi_size =3D STRIPE_SIZE;
 +			/*
 +			 * If this is discard request, set bi_vcnt 0. We don't
 +			 * want to confuse SCSI because SCSI will replace payload
 +			 */
 +			if (rw & REQ_DISCARD)
 +				rbi->bi_vcnt =3D 0;
  			if (conf->mddev->gendisk)
  				trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
  						      rbi, disk_devt(conf->mddev->gendisk),

--Signature=_Fri__1_Nov_2013_14_25_20_+1100_EdFfWs7/zrRi6y8=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScx8lAAoJEMDTa8Ir7ZwVJzwP/RGMmr42W1r3d2G+5+B5EA0a
ECsfBYkxAY/AprMjOnl/E2xr2BfDZMPQ5Xsxl93jzyt8DoKpHDSJhgdU4+2uUWKh
fTyAr3pdXGyfELhuUg33zQrRWP7Vt4+NUN+U904P/XWHRRlyn4Am5HdXTYN4rYPv
fa4M5nYTw8wHQ5AugwNkHAGm60bTZuScgdSw/2XTuxDpNMaxe++xbeIp0HlNwW1t
KSPHuu9d9r++/JubtjeuFMmx0/QaPLghx9kETNrB9eOK/L3/FklbklgFcv9aPtDS
9c2clAvDkcuciLFaLmrofvxUw5KfSiy6ZHZX1v1RbaNZdc3BK5I3Lrtxvfk3MG+/
QIAeZMkpXWViEy+DHA6U6Rm7OT8+WjXKZq24WymArCBPasAcCneeIcpMiI2rAGzs
uLk8GkSecaI/qzai7cKPwbvgMq7vnbr2zoeMYzRLbUWs0Je1ioDZivroL7k3/b4o
KNTGul99yVmIkd3tWSr+CBeYqGpi9vOn4hzUaRkMn1nrCVEoShuV/a8uEugAq9ae
zxN0YPhutNu9hZZi1nnf3LHNLXjEU/Pz5ipG+fZpcUicqqT8rXrhIgtTcj1VuVX1
ZqpjjNryFX0OxO8M/LWBghayhu+B9X1tNqlsKU8UE8qF/P6I433asE9rSbL6FJM6
weHb9JgCo3DApiWDzj9p
=6tG+
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Nov_2013_14_25_20_+1100_EdFfWs7/zrRi6y8=--
